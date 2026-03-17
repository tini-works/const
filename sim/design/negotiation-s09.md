# Design Negotiation — Story 09 (Monday Morning Crush)

## Context

Performance issue. 30 concurrent check-ins at peak. Kiosks freeze, search is slow, receptionist reverts to manual workflow, patients leave. Revenue loss.

## Boxes Received from PM

| Box | Verdict | Notes |
|-----|---------|-------|
| BOX-32: 30 concurrent check-ins per location without degradation | **Accepted — mostly an engineer/DevOps box** | Design impact is minimal. My screens don't change based on concurrency. But I need to design what happens when performance targets are NOT met (BOX-34). |
| BOX-33: 60 concurrent check-ins across all locations | **Accepted — no design impact** | System capacity box. Engineer and DevOps own this. |
| BOX-34: Degraded performance is visible to staff | **Accepted — this is a new UX state** | I'm designing load indicators and warning states for the receptionist UI. The patient should never see system load indicators — that erodes trust. |
| BOX-35: Patient loss due to wait times is measurable | **Accepted with design note** | Abandonment tracking is a data/backend concern. The only design question: does the receptionist see abandonment data in real-time (a counter on S5) or only in reports? I'm proposing both. |

## Boxes I'm Adding

### BOX-D19: Patient never sees system load state

When the system is under load, the patient's kiosk experience degrades gracefully (slower responses) but never shows technical error states, load warnings, or "system is busy" messages. The patient sees their normal flow, potentially slower. If a specific action fails (section save timeout), the patient sees "We're having trouble saving. Please try again." — not "Server overloaded."

**Why this matters:** BOX-34 gives the receptionist visibility into system load. The patient should NOT have this visibility. A patient seeing "System is experiencing high load" loses confidence in the clinic. The degradation must be invisible to the patient or presented as a temporary hiccup.

### BOX-D20: Queue view (S5) shows wait time and queue depth

The receptionist's queue should show aggregate operational data during peak times:
- How many patients are currently checking in
- Average time in the check-in flow
- How many are waiting (session created but not started)

This transforms S5 from a list of sessions to an operational dashboard during peak hours.

**Why this matters:** The receptionist in S-09 said "half the time I just tell people to sit down." They need data to make triage decisions: which patients to prioritize, whether to use paper as backup, whether to call for help.

## Design Changes Required

### S5 (Queue) Modifications for Load Awareness

**Normal state (< 10 active sessions):**
Queue displays as designed in S-02 — list of sessions with statuses.

**Busy state (10-20 active sessions):**
Queue header shows: "15 patients checking in | Avg. time: 4 min"
Sessions are sorted by wait time (longest waiting first).

**Peak state (20+ active sessions):**
Queue header shows warning banner: "High volume — 25 patients checking in | Avg. time: 7 min"
Receptionist sees a suggestion: "Consider directing patients to pre-check-in on their phones" (if S-03 is live).

### Receptionist UI: System Health Indicators

In the app header (next to location indicator from BOX-D11):

- **Green:** System responsive (API < 200ms)
- **Amber:** System slowing (API 200ms-1s). Tooltip: "Responses may be slightly delayed"
- **Red:** System degraded (API > 1s). Banner: "System is experiencing high load. Check-ins may take longer than usual."

These indicators are visible only on receptionist screens, never on patient-facing kiosk.

### S3P: Graceful Degradation for Patients

- Section save actions show a brief spinner (normally < 100ms, not visible). Under load, the spinner becomes visible but doesn't change messaging.
- If a save times out (> 5 seconds), show: "We're having trouble saving. Please try again." with a retry button.
- If retry also fails: "Please see the receptionist for assistance." and mark the section as not-confirmed.

## Push-back to PM

1. **BOX-35 (abandonment tracking) needs a definition of "abandonment."** Is it: session created but never finalized? Patient started confirming but left mid-flow? Session timed out? All of these? I think all three should be tracked with distinct labels. PM should confirm.

2. **The strategic answer to S-09 is S-03 (mobile pre-check-in), not UX polish.** Load indicators help the receptionist cope but don't reduce the load. Pre-check-in from home removes patients from the Monday morning kiosk queue entirely. PM's note about S-03 mitigating S-09 is correct — I'm reinforcing it. My peak-state suggestion on S5 ("direct patients to pre-check-in on their phones") bridges S-09 and S-03.

3. **Kiosk hardware may be the bottleneck, not the server.** If kiosk tablets freeze under load, that's a device performance issue, not a server issue. My designs assume the client device can render the screens. If the tablets are old/slow, no amount of server optimization fixes the UX. DevOps should assess kiosk hardware specs.
