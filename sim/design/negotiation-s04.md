# Design Negotiation — Story 04 (Data Breach / HIPAA)

## Context

CRITICAL. Another patient's PHI (name + allergies) flashed on the kiosk screen. This is a HIPAA violation and the highest-severity design failure in the system. The fix is immediate.

## Boxes Received from PM

| Box | Verdict | Notes |
|-----|---------|-------|
| BOX-12: No PHI from one patient visible to another | **Accepted — zero exceptions** | This is absolute. I'm reviewing every screen and transition for PHI exposure vectors. The fix is not just "clear on session end" — it's ensuring no transition state can leak data. |
| BOX-13: Screen clearing is enforced, not advisory | **Accepted with a new screen** | Session end triggers a hard clear. But "clear" must mean "show something else," not a blank screen. I'm adding a kiosk idle/welcome screen that replaces patient data on session end. |
| BOX-14: Data encrypted at rest | **Accepted — no design impact** | This is an engineer/DevOps box. No screen changes. |
| BOX-15: HIPAA access logging | **Accepted — minimal design impact** | No visible UX change for patients. Receptionist may eventually need an audit access view, but not for this round. |
| BOX-16: Minimum necessary standard | **Accepted — already partially implemented** | BOX-D2 (two actor views) already separates information density. But I need to audit every screen: does the receptionist see more than necessary? Does the patient view expose anything beyond their own data? |
| BOX-17: Breach incident response process | **No design impact** — this is a PM/operational process, not a screen. |
| BOX-18: PHI in transit encrypted | **No design impact** — this is engineer/DevOps. |

## Boxes I'm Adding

### BOX-D9: Kiosk has a distinct idle state (Welcome Screen)

Between patients, the kiosk must show a clean welcome screen with zero patient data. This is not a blank/off screen — it's a branded, welcoming idle state: "Welcome to [Clinic Name]. Please see the receptionist to begin check-in."

**Why this is necessary:** The S-04 bug likely happened because there was no defined idle state. The kiosk went from one patient's session to the next without a clean break. A welcome screen creates a hard visual boundary between sessions.

**What this screen does:**
- Shows when: session finalized, session timed out, session cancelled, kiosk first powered on
- Contains: clinic branding, welcome message, instructions to see receptionist
- Contains NO: patient names, data, search results, previous session artifacts
- Cannot be bypassed by browser back button (history.replaceState or no-cache headers)

### BOX-D10: Screen transitions never show intermediate data states

During the transition from one patient's session to another (or from welcome screen to a new session), there must be no frame where stale data is visible. This means:

- New session data is fetched and ready BEFORE the welcome screen is dismissed
- Loading states show a spinner or skeleton, never partial previous data
- The welcome screen is the gate — it only transitions to a new session when the new session's data is fully loaded

**Why this matters beyond S-04:** S-04 was likely a "flash" of old data during a transition. Even with screen clearing, if the new session loads the old session's cached data for one frame before the new data arrives, the bug returns. The fix must be at the rendering pipeline level, not just the data layer.

## Design Changes Required

1. **New screen: S0 (Kiosk Welcome/Idle)** — Shown between patients, on startup, after timeout
2. **S3P modification** — On session end (finalize/timeout/cancel), hard transition to S0. No gradual fade. Instant replacement.
3. **S4 modification** — Completion screen auto-transitions to S0 after 10 seconds or on receptionist action
4. **All screens** — No browser back-button access to previous patient data. Session-scoped URL routing.

## Push-back to PM

1. **BOX-17 (breach incident response) needs a design artifact eventually.** For this round, it's a process document. But if the clinic needs to identify affected patients from the incident, someone needs a screen to query the audit trail. That screen doesn't exist yet. I'm not building it now, but flagging it as future work.

2. **BOX-16 (minimum necessary) has a tension with S5 (check-in queue).** The receptionist queue shows patient names and check-in statuses. Is a list of patient names "minimum necessary" for the receptionist? I say yes — the receptionist needs to manage the queue. But PM should confirm this is HIPAA-acceptable.

## Audit of Existing Screens for PHI Exposure

| Screen | PHI Present | Exposure Risk | Mitigation |
|--------|-------------|---------------|------------|
| S0 (new: Welcome) | None | None | By design |
| S1 (Patient Lookup) | Search results: names, DOB | Low — receptionist-only screen | Receptionist terminal is staff-facing, not patient-visible. But search results should clear when receptionist navigates away. |
| S1b (Assisted Search) | Same as S1 + partial matches | Low | Same mitigation as S1 |
| S2 (Patient Summary) | Full patient record | Medium — if receptionist screen is visible to other patients in the waiting area | Screen positioning is a physical concern, not a software one. But: S2 should have a "privacy mode" (blur sensitive fields when not actively working). Future scope. |
| S3R (Check-in Monitor) | Active patient data + diffs | Medium | Same as S2 |
| S3P (Patient Confirm) | Patient's own data | **HIGH — this is where S-04 happened** | Session-end clearing to S0. No caching. No browser back. |
| S4 (Completion) | First name only | Low | Auto-transition to S0 after 10s |
| S5 (Queue) | Patient names + statuses | Medium | Receptionist-only screen |
