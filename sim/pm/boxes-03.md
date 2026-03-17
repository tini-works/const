# Boxes — Story 03 (Mobile Pre-Check-In)

---

## BOX-08: Patient can complete check-in from their own device before arriving

A patient with a scheduled appointment can receive a link (SMS or email) that allows them to complete the data confirmation flow from their personal device, before arriving at the clinic.

**Traces to:** "Can I just do this from my phone at home before I leave?"

**Verified when:**
1. Patient receives a check-in link for their upcoming appointment
2. Link opens a mobile-optimized version of the confirmation flow
3. Patient can confirm/update all data categories (address, insurance, allergies, medications)
4. Completion is recorded and visible to the receptionist before the patient arrives

---

## BOX-09: Pre-check-in has a time window

The pre-check-in link should be available within a defined time window before the appointment. Too early creates stale confirmations. Too late provides no benefit.

**Traces to:** Business logic — need to balance data freshness with convenience.

**Proposed window:** 24 hours before appointment through appointment start time.

**Verified when:** Link is not active outside the window. Patient sees a clear message if they try too early or if the appointment has passed.

---

## BOX-10: Pre-checked-in patients are recognized at arrival

When a patient who has pre-checked-in arrives at the clinic, the receptionist must immediately see that check-in is already complete. The patient should not be asked to check in again at the kiosk.

**Traces to:** "I'd rather confirm my info on the couch" — the value is eliminating the kiosk step entirely, not adding a second one.

**Verified when:** Receptionist's queue/list shows the patient as "pre-checked-in" with a distinct visual status. Patient arrival triggers finalization or the receptionist can finalize directly.

---

## BOX-11: Pre-check-in requires identity verification

Unlike the kiosk (where the receptionist hands over the tablet), mobile pre-check-in is unsupervised. The patient must prove they are who they claim to be.

**Traces to:** Security — the link grants access to PHI (patient data). Without verification, anyone with the link sees the data.

**Verified when:** The pre-check-in link requires at least one verification step (DOB confirmation, last 4 of SSN, or similar) before displaying patient data.

**Note:** This changes Engineer's BOX-E2 (token-scoped, not authenticated). Mobile pre-check-in needs a stronger access model than the kiosk flow.

---

## Open Questions

- **Link delivery mechanism:** SMS, email, or both? Does the clinic have patient contact info on file?
- **No-show handling:** Patient pre-checks-in but doesn't show up. What happens to the session?
- **Partial pre-check-in:** Patient starts at home, doesn't finish. Can they complete at the kiosk?
- **Appointment system integration:** Where do appointments live? Is there an existing scheduling system to integrate with?
