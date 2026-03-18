# Technical Design: Kiosk Session Isolation (BUG-002 P0 Fix)

**Related:** [BUG-002](../product/user-stories.md#bug-002-data-leak--previous-patients-data-visible-on-scan), [US-003](../product/user-stories.md#us-003-secure-patient-identification-on-scan), [ADR-002](adrs.md#adr-002-session-purge-protocol-for-kiosk-state-isolation), DD-001
**Screens:** [1.1 Kiosk Welcome](../experience/screen-specs.md#11-kiosk-welcome-screen), [1.2 Session Transition](../experience/screen-specs.md#12-session-transition-screen), [1.3 Identity Confirmation](../experience/screen-specs.md#13-patient-identification-confirmation-screen)
**Flows:** [4. Data Leak Prevention](../experience/user-flows.md#4-data-leak-prevention--between-patients-bug-002-fix)
**Tested by:** [TC-301](../quality/test-suites.md#tc-301-sequential-patients--no-data-leakage), [TC-302](../quality/test-suites.md#tc-302-rapid-sequential-scans--no-data-leakage), [TC-303](../quality/test-suites.md#tc-303-rapid-sequential-scans--sub-second-timing), [TC-304](../quality/test-suites.md#tc-304-session-purge--dom-inspection), [TC-305](../quality/test-suites.md#tc-305-browser-back-button-does-not-reveal-previous-session)
**Monitored by:** [Data Leak Detected (P0)](../operations/monitoring-alerting.md#p0----page-immediately-any-time), [security_session_isolation_failure metric](../operations/monitoring-alerting.md#check-in-service)
**Confirmed by:** Priya Patel (Senior Engineer), 2024-11-05

---

## Problem

A patient scanned their card at the kiosk and briefly saw another patient's name and allergies on screen. This is a PHI exposure incident — potentially HIPAA-reportable.

**Root cause:** The React component tree retained state from the previous patient session. When a new card was scanned, the app started fetching the new patient's data, but the old data remained visible in the DOM during the re-render cycle. For approximately 200-400ms, the screen showed Patient A's data while Patient B's session was initializing.

The underlying issue is that React's reconciliation model updates the DOM incrementally. There is no guarantee that all remnants of the previous render are gone before the new render begins — especially when the data fetch for the new patient resolves while the old component tree is still mounted.

---

## Approach: Session Purge Protocol

Three layers of defense, any one of which should prevent data leakage:

### Layer 1: Application State Reset

When a new card scan event fires:

1. Cancel all in-flight API requests (via AbortController)
2. Clear all React state:
   - Call a top-level `resetSession()` that sets all patient-related state atoms/stores to null
   - Clear any React Query / SWR / TanStack Query caches
   - Clear any context providers holding patient data
3. Clear all in-memory caches (any memoized selectors, computed values)
4. Clear sessionStorage and any temporary browser storage

```typescript
function resetSession(): void {
  // Cancel in-flight requests
  activeAbortController?.abort();

  // Clear query cache
  queryClient.clear();

  // Reset all patient state atoms
  patientStore.reset();
  checkInStore.reset();

  // Clear browser storage
  sessionStorage.clear();
}
```

### Layer 2: DOM Destruction

After state reset, we don't just re-render — we unmount the entire patient data component subtree and remount from scratch:

```typescript
function KioskApp() {
  const [sessionKey, setSessionKey] = useState(0);

  function handleNewScan() {
    resetSession();              // Layer 1
    setSessionKey(prev => prev + 1); // Force full unmount/remount
  }

  return (
    <SessionBoundary key={sessionKey}>
      {/* Entire patient flow renders here */}
      {/* key change forces React to destroy and recreate this subtree */}
    </SessionBoundary>
  );
}
```

Using React's `key` prop guarantees that the entire subtree is destroyed and rebuilt. This is not a re-render — it's a full unmount (componentWillUnmount / useEffect cleanup on every component) followed by a fresh mount.

### Layer 3: Transition Screen Barrier (Design-mandated)

The Session Transition Screen is rendered between every patient session. It is a simple branded loading screen that:
- Renders from a clean component tree (no patient data in its subtree)
- Displays for a minimum of 800ms
- Is the visual proof that the old DOM is gone

```typescript
function SessionTransition({ onReady }: { onReady: () => void }) {
  useEffect(() => {
    // Minimum display time
    const timer = setTimeout(onReady, 800);
    return () => clearTimeout(timer);
  }, []);

  return (
    <div className="transition-screen">
      <ClinicLogo />
      <Spinner />
      <p>Loading your information...</p>
    </div>
  );
}
```

**Sequencing:**
```
Card scan event
    → resetSession()              [Layer 1: state cleared]
    → sessionKey++                [Layer 2: DOM destroyed]
    → render TransitionScreen     [Layer 3: clean screen visible]
    → wait 800ms minimum
    → begin fetching new patient data
    → on data arrival: fade to Identity Confirmation screen
```

The data fetch does NOT begin until after the transition screen is rendered. This is critical: if we fetch data first and render second, a fast network response could populate state before the transition screen appears — reintroducing the original bug.

---

## Edge Cases

### Rapid sequential scans (Patient B scans while Patient A's data is loading)

1. Patient A scans card → transition screen renders, data fetch begins
2. Patient B scans card before Patient A's data arrives
3. Patient A's fetch is aborted (AbortController)
4. Full purge protocol runs again (state reset, DOM destroy)
5. New transition screen renders (800ms timer restarts)
6. Patient B's data fetch begins after transition screen is visible

**Test scenario:** Automate two scans 100ms apart. Assert that Patient A's data is never rendered in the DOM at any point.

### Auto-return after success screen

The success screen has a 10-second countdown. On expiry:
1. Full purge protocol runs
2. Welcome screen renders (clean state)

If Patient B scans while the countdown is active:
1. Countdown is interrupted
2. Full purge protocol runs immediately
3. Transition screen renders
4. Patient B's flow begins

### Multiple quick scans of the SAME card

If the same patient scans twice quickly, the protocol still runs. We don't skip the purge based on card ID — every scan triggers a full purge, every time. This is intentional: the security guarantee is unconditional.

---

## Verification

### Automated tests

1. **DOM inspection test:** After purge, query the DOM for any element containing patient data attributes (`data-patient-*`, text content matching patient names, allergy names, etc.). Assert zero matches.

2. **Rapid scan test:** Simulate 10 sequential scans with randomized timing (0-500ms between scans). After each scan, assert that only the current patient's data (or the transition screen) is in the DOM.

3. **Memory leak test:** Run 100 consecutive sessions. Monitor heap size. Assert no unbounded growth (which would indicate state from old sessions is retained).

### Manual security test

- Two testers, two different patient cards
- Tester A scans, sees their data
- Tester A walks away
- Tester B scans immediately
- Record video of the screen during the transition
- Frame-by-frame analysis: at no point should Patient A's data appear after Patient B's scan

### Penetration test

- Attempt to extract previous patient data from the kiosk's browser dev tools, memory dump, or network cache after the purge protocol runs
- Ensure browser back button doesn't reveal previous session data
- Ensure browser autofill doesn't populate fields with previous session data

---

## Security Classification

This is a **P0 security fix**. The purge protocol is not a feature — it's a security control. Any code change that modifies the kiosk session lifecycle must be reviewed against this design. Regressions on session isolation are treated as security incidents.
