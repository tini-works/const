# Design Negotiation — Story 02 (Receptionist Blind)

## Context

Bug report. Patient completed check-in, got green checkmark, but receptionist's screen showed nothing. Receptionist fell back to paper forms. This validates QA's G-06 gap prediction.

## Boxes Received from PM

| Box | Verdict | Notes |
|-----|---------|-------|
| BOX-05: Patient completion visible to receptionist within 2s | **Accepted with design addition** | I accept the box. But "visible" needs design specificity: what exactly changes on S3R when the patient completes? I'm defining the visual transition. I'm also adding a fallback UX state for when WebSocket dies. |
| BOX-06: No false success shown to patient | **Accepted** | The green checkmark on S3P must be gated on server acknowledgment, not optimistic rendering. I'm making the "All Confirmed" button produce a brief spinner before showing the checkmark. If persistence fails, the button shows an error state instead. |
| BOX-07: Receptionist has a fallback queue view | **Accepted — this is a new screen** | This is not a modification to S3R. This is a new screen: a check-in queue that shows ALL active sessions across the receptionist's view. This is a fundamental addition to the receptionist's workflow. |

## Boxes I'm Adding

### BOX-D4: Receptionist sees connection health

The receptionist's UI must show whether the real-time channel is working. If WebSocket is disconnected, the receptionist sees a clear indicator (not silence). This prevents the S-02 scenario where the receptionist sits waiting for an update that will never arrive.

**Why PM missed this:** PM's boxes describe what should happen when things work (completion visible within 2s) and a fallback (polling within 10s). But they don't describe the intermediate state: the receptionist doesn't know the live connection is broken. The worst UX is silence when you're expecting a signal.

**Concrete design:** An unobtrusive connection indicator on S3R. Green dot = live. Amber dot + "Updates may be delayed" = polling fallback active. Red dot + "Connection lost, refreshing..." = reconnecting.

### BOX-D5: Patient completion produces an unambiguous visual event on S3R

When the patient taps "All Confirmed" on S3P, the receptionist's S3R doesn't just update a progress bar. It produces a clear notification event: a status change, a highlight, possibly a sound cue. The receptionist should not need to be staring at S3R at the exact moment of completion.

**Why this matters:** The S-02 bug happened partly because the receptionist missed the update. Even if WebSocket had worked, a silent state change on a screen the receptionist isn't watching is easy to miss. The notification must be attention-grabbing enough to work when the receptionist is multi-tasking.

## Design Changes Required

1. **S3R modification** — Add connection health indicator and completion notification event
2. **S3P modification** — Gate green checkmark on server acknowledgment; add error/retry state
3. **New screen: S5 (Check-in Queue)** — Receptionist's global view of all check-in sessions

## Push-back to PM

None. These boxes are clean. The bug is real and the fixes are clear. My only note: BOX-07 (the queue view) is a significant addition that changes the receptionist's primary workflow. S3R becomes a per-patient detail view. S5 becomes the receptionist's home base. PM should understand this reframes the receptionist's mental model from "handle one patient at a time" to "manage a queue of patients."
