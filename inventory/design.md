# Design Inventory — Faces the User's Experience

Translates requirements into what the user sees and does.

**Contains:** Screens (including nested regions). State machine (exhaustive transition tree).

**Proven means:** Every screen and transition matches a box from PM. The state machine has no hanging states — every path leads somewhere intentional.

---

## Entry 001 — Patient Check-In

**Boxes received:** B1 (pre-filled + editable), B2 (persistence), B3 (confirm flow), B4 (confirm step), B5 (allergy staleness guard)

### Screens added

| ID | Screen | Regions | Matches |
|----|--------|---------|---------|
| SCR-01 | "Welcome Back" | Pre-filled fields, edit toggles, confirm button | B1, B3, B4 |
| SCR-02 | "Staff Review Queue" | Flagged-change list for receptionist | B1 (change flagging) |
| SCR-03 | "Allergy Re-confirmation" | Forced re-entry for stale allergy data | B5 |

### State machine added

```
New Patient → Full Intake → Ready
Returning Patient → Confirm Info →
    (allergies stale >6mo?) → Allergy Re-confirmation → Confirm Info
    (edits?) → Staff Review Queue → Ready
    (no edits) → Ready
```

**Hanging state check:** Every path terminates at Ready. No dead ends. **No hanging states.**

**Negotiation impact:** Design pushed back on B1 ("editable or locked?") — this produced a better box. Design also originated B4 (confirm step replaces intake). Design doesn't just receive — it negotiates and creates.

---

## Entry 002 — Silent Checkout Failure

**Boxes received:** B1 (failure visible), B2 (categorized reason), B3 (recovery path), B4 (preserve cart)

### Screens added

| ID | Screen | Regions | Matches |
|----|--------|---------|---------|
| SCR-10 | Checkout Error — card problem | "There's a problem with your card" + "Update payment method" CTA | B1, B2 |
| SCR-11 | Checkout Error — temporary decline | "Payment couldn't be processed right now" + "Try again" CTA | B1, B2 |
| SCR-12 | Checkout Error — contact bank | "Please contact your bank" + alt payment CTA | B1, B2 |

### State machine modified

```
Pay → Processing →
    Success → Confirmation
    Failure → Error State (categorized) →        ← NEW BRANCH
        Card problem → Update Card → return to Payment
        Temporary → Retry → return to Processing
        Bank issue → Alt payment / Contact support
        (all paths) → Cart preserved, session saved    ← B4
```

**Hanging state check:** Every error path leads to either resolution (retry/update) or explicit exit (support). Cart preserved on all paths. **No hanging states.**

**Negotiation impact:** Design pushed back on B2 — "actionable" can't mean raw gateway errors. "Insufficient funds" is sensitive. This negotiation created the categorization approach. Design also originated B4 (cart preservation). Without Design's pushback, the solution might have been "show the error string from the gateway" — worse for users.

---

## Entry 003 — Auth Library Migration

**N/A.** No UI change. Auth is infrastructure. Design's inventory is untouched.

Design was not notified by the transition mechanic — correct behavior. None of Design's boxes depended on the auth library implementation.

---

## Entry 004 — Dark Mode

**Boxes received:** B1 (reduced brightness), B3 (persistent preference)

**Deferred:** B2 (full coverage — blocked by missing design tokens)

### Discovery: architectural gap

Design started mapping all screens for dark mode coverage. Found: **no design token system.** 200+ hardcoded color values. Full dark mode is a design system migration, not a toggle.

**This is Design doing its job.** Not blindly mocking up screens, but checking whether the system can support the ask. The answer: not yet.

Design raised B4 (design token infrastructure) and renegotiated B2 to deferred.

### Screens added

| ID | Screen | Regions | Matches |
|----|--------|---------|---------|
| SCR-40 | Settings → Appearance | Toggle: Light / Reduced Brightness | B3 |
| SCR-41 | All screens — reduced brightness variant | 12 primary surfaces tokenized, remainder overlaid | B1 |

### State machine modified

```
Settings → Appearance → Toggle →
    Light mode (default)
    Reduced brightness mode
    (auto-detect: prefers-color-scheme on first visit)
    (no page reload on switch)
```

**Hanging state check:** Toggle is a binary switch. Both states are stable. **No hanging states.**

**Known gap:** Non-tokenized surfaces use an opacity overlay. Usable (meets WCAG AA) but not ideal. This gap is explicitly tracked — it resolves when B4 (design tokens) lands.

---

## Entry 005 — Ghost Feature Removal

### Screens removed

| ID | Screen | Reason |
|----|--------|--------|
| SCR-XX | "Export Report" button on dashboard | Feature removed — no active users, dependency dead |

### State machine modified

Removed export-triggered states. All transitions that led to export now lead to their parent state.

**Hanging state check after removal:** Verified — no orphaned states, no dead links. **No hanging states.**

**Observation:** Inventory shrank. This is good. A screen that points to a broken feature is worse than no screen — it misleads users and accumulates questions to support.

---

## Entry 006 — Order Service Rewrite

**N/A.** No UI change. Engineer rewrote the backend; the API contract (which Design's screens depend on) was unchanged.

Design was not notified — correct behavior. Design's box (B3: confirmation screen within 2 seconds) still matches. The backend is faster now, but that doesn't change what Design owns.

---

## Sanity checklist (daily reconciliation)

Run across all screens and state machine:

| Dimension | Question | Action if yes |
|-----------|----------|---------------|
| Staleness | Does this screen still serve a live PM requirement? | Remove if requirement is dead (see Entry 005) |
| Correctness | Does the state machine have hanging states? Does every path terminate intentionally? | Fix hanging states immediately |
| Coverage | Are there new PM boxes not yet reflected in screens or states? | Add screens/states to match |

### Integrity rule: No hanging states

The state machine must be exhaustive. Every screen a user can reach must have a path forward or an explicit termination. Hanging states are Design bugs — they mean a user can get stuck.

After every inventory change, run the hanging state check.
