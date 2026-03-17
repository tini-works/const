# Story 03 — Mobile Pre-Check-In (Feature Request)

## Customer's Words

> "I always arrive 10 minutes early just to deal with the check-in screen. Can I just do this from my phone at home before I leave? I'd rather confirm my info on the couch than standing at a kiosk."

## What the Customer Is Saying

1. **"10 minutes early just to deal with"** — Check-in is a chore with a known time cost. The patient plans their arrival around it. This is friction the patient has learned to manage, but resents.

2. **"From my phone at home before I leave"** — The patient wants temporal and spatial separation from the clinic. Check-in is not inherently tied to being physically present. The data confirmation (allergies, insurance, address) can happen anywhere.

3. **"On the couch"** — Comfort and convenience. The kiosk is associated with standing, waiting, clinic anxiety. Home is associated with control.

## What the Customer Is NOT Saying

- They're not asking to skip check-in entirely. They still want to confirm their info. They just want to do it earlier, from their device.
- They're not describing a patient portal with full account access. They want the same check-in flow, on their phone, before the visit.
- They're not asking to book or reschedule appointments. This is narrowly about the data confirmation step.
- They're not worried about identity verification — they assume it will "just work."

## Architectural Implications

This fundamentally changes Engineer's BOX-E2 (token-scoped, not authenticated). A kiosk session is receptionist-initiated with a short-lived token on a clinic device. A mobile pre-check-in is patient-initiated, on their own device, potentially hours before the visit.

This requires:
- Patient identity verification (not just a handed-over tablet)
- A link/notification delivery mechanism (SMS, email, app notification)
- A time window: when can they pre-check-in? Same-day only? 24 hours before?
- What happens when they arrive? The receptionist needs to know pre-check-in is complete.
- What if they pre-check-in but don't show up?

## Relationship to Existing Stories

- Extends S-01 (same data confirmation flow, different context)
- Potentially resolves S-09 (Monday crush) by spreading check-in load temporally
- Must respect S-06 (medication list) — if pre-check-in happens, medications must be part of it
