# Boxes — Story 02 (Patient Confirmed But Receptionist Blind)

Bug report. No new feature boxes — this is a failure of existing boxes.

---

## BOX-05: Patient completion is visible to receptionist in real time

When a patient completes their check-in on the kiosk/device, the receptionist's screen must reflect this within 2 seconds. If the real-time channel fails, a fallback mechanism must ensure visibility within 10 seconds.

**Traces to:** "She said she couldn't see anything on her screen" — the receptionist was blind to the patient's completed check-in.

**Verified when:**
1. Patient taps final confirm -> receptionist's S3R updates within 2 seconds
2. If WebSocket is disconnected, receptionist's view auto-polls and updates within 10 seconds
3. Receptionist never needs to manually refresh to see patient completion

**Relates to:** BOX-D2 (two actor views), BOX-E1 (no data loss), QA G-06 (WebSocket contract tests)

---

## BOX-06: System never shows "success" to patient if data didn't persist

The green checkmark must be a proof of persistence, not a UI animation. If the data write failed, the patient must not see a success state.

**Traces to:** "I got a green checkmark" — the system lied. It showed success when the receptionist had nothing.

**Verified when:** The confirmation UI only renders after receiving a server acknowledgment that the data was persisted. Optimistic UI updates for individual sections are acceptable, but final completion status requires server confirmation.

---

## BOX-07: Receptionist has a fallback to see pending check-ins

Even if real-time updates fail, the receptionist must be able to see all active and completed check-in sessions via a list/queue view, not just per-patient.

**Traces to:** "She said she couldn't see anything" — if the receptionist had a queue of check-in sessions, she could have found the patient's completed session by browsing.

**Verified when:** Receptionist has access to a check-in queue showing all sessions (pending, in-progress, completed, timed-out) with patient name, status, and timestamp. This view works without WebSocket (pure REST polling or page refresh).
