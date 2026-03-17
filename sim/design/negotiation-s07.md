# Design Negotiation — Story 07 (Concurrent Check-In Bug)

## Context

Bug report. Two receptionists checked in the same patient simultaneously. Both finalized. Sarah's insurance update was lost. BOX-E5 (concurrent prevention) failed. QA predicted this in G-08 — Design never added the concurrent check-in state to S2.

## Boxes Received from PM

| Box | Verdict | Notes |
|-----|---------|-------|
| BOX-26: Concurrent check-in prevention is airtight | **Accepted — I owe a screen state for this** | QA flagged in G-08 that my state machine was missing the concurrent check-in state on S2. They were right. The bug proves it. I'm adding the state now. |
| BOX-27: Finalization is conflict-safe | **Accepted with a new error screen** | If finalization fails due to conflict, the receptionist must see something actionable — not a raw error. I'm designing a conflict resolution screen. |
| BOX-28: Lost data from concurrent finalization is recoverable | **Accepted — this needs an admin screen** | Recovering lost data from a dead session requires an audit/recovery interface. This is different from the check-in flow — it's an administrative tool. |

## Boxes I'm Adding

### BOX-D15: Concurrent check-in blocking message is informative, not just a wall

When Receptionist B tries to check in a patient already being checked in by Receptionist A, the blocking message must include:
- Who has the active session (Receptionist A's name)
- When it was started
- Current status (in progress, patient complete awaiting finalization)
- Option to contact Receptionist A (or take over the session if authorized)

**Why this matters:** A bare "already being checked in" message leaves Receptionist B stuck. They can't help the patient, and they don't know who to talk to. The message must enable resolution, not just block action.

### BOX-D16: Conflict at finalization shows both sessions' changes for manual resolution

If despite prevention, a conflict occurs at finalization time, the receptionist must see a side-by-side comparison: "Session A changed insurance. Session B changed nothing." or "Session A changed address. Session B changed insurance. Both need to be applied." The receptionist (or an admin) resolves the conflict manually.

**Why this is different from BOX-27:** BOX-27 says "reject the second finalization." But rejecting isn't enough. The receptionist needs to see what was lost and have a path to apply it. BOX-D16 defines the screen for that recovery.

## Design Changes Required

### S2 Modification: Concurrent Check-In State

New state on S2 when patient has an active session elsewhere:

```
[Patient Summary - S2]

[Patient Header: Mrs. Rodriguez, DOB 1965-03-14]

  !! This patient is currently being checked in !!

  Active session:
    Started by: Sarah (Receptionist)
    Location: Main Street Clinic
    Started: 10:23 AM (12 minutes ago)
    Status: Patient completing confirmation

  [Wait for current session]     [Contact Sarah]
```

The "Begin Check-in" button is REPLACED by this state. It cannot be clicked. This is not a modal warning on top of the normal S2 — it's a state replacement.

If the receptionist is authorized (e.g., a supervisor), an additional option: "[Take over session]" — this cancels Sarah's session and creates a new one. This is a destructive action with a confirmation dialog.

### New Screen: S8 (Finalization Conflict)

Shown when finalization is rejected due to conflict:

```
[Finalization Conflict - S8]

  Unable to complete check-in — another session was finalized first.

  Your session: Started 10:23 AM by Sarah
  Conflicting session: Finalized 10:35 AM by Maria

  Changes in YOUR session that were NOT applied:
  - Insurance: Updated from Aetna #12345 to BlueCross #67890

  Changes in the OTHER session that WERE applied:
  - Address: Updated to 456 Oak Street

  [Apply my changes too]    [Discard my changes]    [Contact admin]
```

### New Screen: S9 (Session Recovery — Admin)

For BOX-28. Admin-only screen accessible from an admin panel (not from the check-in flow):

```
[Session Recovery - S9]

  Search: [Patient name or session ID]

  Conflicting Sessions for Mrs. Rodriguez (2025-03-17):

  Session A (Finalized - APPLIED)          Session B (Finalized - REJECTED)
  ─────────────────────────────           ──────────────────────────────
  By: Maria, 10:12 AM                     By: Sarah, 10:23 AM
  Insurance: no change                     Insurance: Aetna -> BlueCross
  Address: 123 Main -> 456 Oak            Address: no change
  Allergies: confirmed                     Allergies: confirmed

  [Apply Session B's insurance change to patient record]
  [Mark as reviewed — no action needed]
```

## Push-back to PM

1. **The "take over session" capability has authority implications.** Who can take over another receptionist's session? Only supervisors? Any receptionist? PM needs to define the authorization model. For now, I'm designing it as supervisor-only with a confirmation dialog.

2. **S9 (Session Recovery) is admin tooling, not part of the check-in flow.** This is the first admin screen in the system. PM should acknowledge that we're growing beyond a check-in app into a system with operational tools. This trajectory continues with S-10 (import/merge review).

3. **BOX-E5 was specified in Round 1. Design was warned in G-08. This bug was preventable.** I should have added the concurrent state to S2 in Round 1 when Engineer raised BOX-E5. Lesson learned: when Engineer adds a constraint box, Design must immediately add the corresponding UX state, even if it feels like an edge case.
