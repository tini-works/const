# Boxes — Story 07 (Concurrent Check-In Bug)

Bug report. This is a failure of BOX-E5 (concurrent check-in prevention).

---

## BOX-26: Concurrent check-in prevention is airtight

No two active check-in sessions may exist for the same patient, across all locations, at any point in the session lifecycle. This includes all non-terminal states: pending, in_progress, patient_complete.

**Traces to:** "Two of us grabbed the same patient... We both finalized. Now the patient's record has my edits but not Sarah's."

**Difference from BOX-E5:** BOX-E5 specified prevention at session creation. This bug shows it must also be enforced at finalization. The constraint must cover the full lifecycle.

**Verified when:**
1. Receptionist A starts check-in for Patient X -> succeeds
2. Receptionist B attempts to start check-in for Patient X -> blocked with clear message ("Patient X is being checked in by Receptionist A since [time]")
3. If both sessions somehow exist (race condition), finalization of the second session is rejected
4. After finalization of Session A, Session B (if it exists) is invalidated, not silently overwritten

---

## BOX-27: Finalization is conflict-safe

If despite all prevention, two sessions reach finalization for the same patient, the system must detect the conflict and reject the second finalization rather than silently overwriting.

**Traces to:** "Sarah had updated the insurance and it's gone" — last-write-wins destroyed data.

**Verified when:** Finalization checks for concurrent sessions as a pre-condition. If another session was finalized for the same patient after this session was created, finalization fails with a conflict error. The receptionist is informed and can review the other session's changes.

---

## BOX-28: Lost data from concurrent finalization is recoverable

For the specific S-07 incident: Sarah's insurance update must be recoverable from the session audit trail, even though the session was overwritten.

**Traces to:** Operational need — the patient's correct insurance info is in a dead session.

**Verified when:** All session data (including from conflicting sessions) is retained in the audit trail. An administrator can review conflicting sessions and manually apply the correct data.

---

## Impact on BOX-E5

BOX-E5 is **not proven**. This bug is the proof of failure. Engineer must:
1. Diagnose the exact failure mode
2. Fix the constraint to cover the full lifecycle
3. Add finalization-time conflict detection
4. DevOps BOX-O3 (runtime invariant check) must be verified as running — it should have caught this
