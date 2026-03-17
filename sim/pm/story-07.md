# Story 07 — Two Receptionists Finalized Same Patient (Bug)

## Customer's Words (Receptionist)

> "Two of us grabbed the same patient. I was checking in Mrs. Rodriguez on my screen, and Sarah was too on hers. We both finalized. Now the patient's record has my edits but not Sarah's — Sarah had updated the insurance and it's gone."

## What the Customer Is Saying

1. **"Two of us grabbed the same patient"** — Concurrent check-in happened despite BOX-E5 (concurrent check-in prevention) being specified. The system either didn't enforce it, or the enforcement failed.

2. **"We both finalized"** — Both sessions reached completion. The system allowed two finalization writes for the same patient. This is a data integrity failure.

3. **"Sarah had updated the insurance and it's gone"** — Last-write-wins destroyed Sarah's changes. The patient's insurance update is lost. This is not just a system bug — it has operational consequences (wrong insurance on file = billing problems, claim denials).

## Root Cause Assessment

BOX-E5 was specified by Engineering and accepted by all verticals. DevOps added BOX-O3 (background check for concurrent sessions). QA identified G-08 (Design missing the concurrent check-in state on S2).

This bug means one or more of:
1. BOX-E5 was never implemented (the unique partial index doesn't exist)
2. BOX-E5 was implemented but has a race condition (both INSERTs passed constraint check simultaneously)
3. The prevention works at session creation but not at finalization (two sessions were created at different times, but the first wasn't finalized before the second started)

**Option 3 is most likely.** BOX-E5 says "At most one active check-in session per patient." But what's the lifecycle? If Session 1 was created 20 minutes ago and the receptionist hadn't finalized yet, Session 2 could still be blocked. But if Session 1 was in `patient_complete` state (patient done, receptionist hasn't clicked Finalize), and Session 2 was created by another receptionist who didn't see Session 1 — the constraint may not catch it if Session 1's status made it look "almost done."

## Impact

- Data loss (insurance update lost)
- Patient trust (if they learn their update vanished)
- Operational impact (incorrect insurance = billing errors)
- Validates DevOps BOX-O3 need (runtime invariant checking)

## Resolution Required

The prevention must be airtight. Not just at session creation — the entire lifecycle from creation through finalization must be exclusive. If a session exists for a patient in ANY non-terminal state, no second session can be created.
