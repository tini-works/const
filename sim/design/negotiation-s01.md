# Design Negotiation — Story 01

## Boxes Received from PM

| Box | Verdict | Notes |
|-----|---------|-------|
| BOX-01: Returning patient is recognized | **Accepted with addition** | I accept the box. But I'm adding a box for the failure case — recognition is not guaranteed. |
| BOX-02: Previously collected data is not re-asked | **Accepted with nuance** | Agreed. But "previously collected" has a staleness dimension PM flagged as open. I'm taking a position: staleness is surfaced visually, not by re-asking from scratch. Stale data gets a flag, not a blank field. |
| BOX-03: Confirm or update, not re-enter | **Accepted** | This is the core interaction. Pre-filled fields, confirm-or-edit. Clean box. |
| BOX-04: Experience communicates recognition | **Accepted, made concrete** | "Observably different" is my job. I'll define exactly what changes between first-visit and returning-visit flows. The difference: greeting by name, fewer steps, pre-filled data, skip-able sections. |

## Boxes I'm Adding

### BOX-D1: Recognition failure has a graceful path

When the system cannot find a match for someone who claims to be a returning patient, the flow must not dead-end or force a full first-visit intake. Instead: assisted search (alternative lookup criteria), and if still no match, a streamlined intake that acknowledges "we may have your data under different information."

**Why PM missed this:** PM's story is told from the happy path — "I already told you last time." But "last time" might have been at a different location, under a maiden name, or with a different insurance card. Recognition is not binary in practice.

**Traces to:** "Nobody remembers me" — if recognition fails and the system makes the patient re-enter everything with no acknowledgment, the wound is even deeper.

### BOX-D2: Receptionist and patient see purpose-appropriate views

The patient's complaint is about their experience, but the check-in is operated by a receptionist. Two actors, two views. The receptionist needs a lookup/verification view. The patient needs a confirmation view. These are different screens with different information density.

**Why this matters:** If we design only the patient-facing screen, we haven't solved the operational flow. If we design only the receptionist screen, the patient still feels like "nobody remembers me" because they can't see their own data being recognized.

### BOX-D3: Partial data is handled without confusion

A returning patient may have incomplete records — visited once for a walk-in, gave name and DOB but not insurance. On return, some fields are pre-filled and some are blank. The screen must make the distinction clear: "we have this" vs. "we still need this." Mixed state should not look like a blank form or a fully pre-filled form.

**Traces to:** BOX-02 and BOX-03 both assume binary (data exists or doesn't). Reality is partial.

## Open Questions Pushed Back to PM

1. **Identity verification method** — PM left this open. I need an answer to design the first screen. My proposal: Name + DOB as primary lookup, insurance card scan as secondary. But this has operational implications PM should validate.
2. **Data freshness thresholds** — PM flagged this. I'm proposing visual treatment (flag stale data, don't blank it), but PM needs to define the policy: what age makes insurance data "stale"? I'll assume 6 months for insurance, 12 months for address, never for allergies — PM should confirm or correct.
3. **Multi-location** — PM flagged. For this round, I'm designing as if data persists across locations. PM should confirm.
