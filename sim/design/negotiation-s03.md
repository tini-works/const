# Design Negotiation — Story 03 (Mobile Pre-Check-In)

## Context

Feature request. Patient wants to complete check-in from their phone at home before arrival. This extends the S-01 flow to a new device context with different trust assumptions.

## Boxes Received from PM

| Box | Verdict | Notes |
|-----|---------|-------|
| BOX-08: Patient can complete check-in from own device before arriving | **Accepted with major scope note** | This is not just S3P on a phone. This is a different entry point, a different session lifecycle, and a different trust model. I'm designing it as a related but distinct flow that shares the data confirmation components. |
| BOX-09: Pre-check-in has a time window (24h before through appointment start) | **Accepted** | I need to design three states for the link: too-early (link inactive, explain why), active (the flow), and expired (appointment passed or already completed). |
| BOX-10: Pre-checked-in patients are recognized at arrival | **Accepted — affects S5 (queue) and S2** | The receptionist's queue (S5) must show a "pre-checked-in" status that is visually distinct. When a pre-checked-in patient arrives, the receptionist should be able to finalize directly from the queue without going through S3R. |
| BOX-11: Pre-check-in requires identity verification | **Accepted with design specificity** | I'm designing a verification gate screen before the patient sees any data. DOB confirmation as minimum. The gate must fail gracefully (wrong DOB = locked, not "try again forever"). |

## Boxes I'm Adding

### BOX-D6: Mobile flow is responsive, not a separate app

The pre-check-in flow must work in a mobile browser. No app download. No app store. The link opens, the patient verifies identity, confirms data, done. The design must be responsive — same components as S3P, optimized for phone viewport.

**Why this matters:** PM's box says "mobile-optimized version." That could mean a native app, a PWA, or a responsive web page. I'm taking a position: responsive web. An app creates distribution friction (download, install, permissions). The patient does this a few times a year at most — not worth an app installation.

### BOX-D7: Pre-check-in flow includes feedback on what happens next

After the patient completes pre-check-in from home, they need closure: "You're all set. When you arrive at the clinic, let the receptionist know you've already checked in." Without this, the patient doesn't know if they should still arrive early, or if they need to do anything at the kiosk.

**Why PM missed this:** PM's boxes describe the operational mechanics (link, window, identity) but not the patient's emotional closure. S3P's current completion screen (S4) says "take a seat." That doesn't apply when you're at home.

### BOX-D8: Partial pre-check-in is handled

If the patient starts pre-check-in at home but doesn't finish (distracted, bad cell signal, ran out of time), they should be able to complete it at the kiosk on arrival. The kiosk should show their partial progress, not start over.

**Why this matters:** PM listed this as an open question. I'm answering it from the design side: partial progress must be preserved across device contexts. The patient started on phone, finishes on kiosk. The session is the unit of continuity, not the device.

## Design Impact

1. **New screen: S6 (Identity Verification Gate)** — DOB entry before patient sees any data on mobile
2. **New screen: S7 (Pre-Check-In Link Landing)** — Time window states (too early, active, expired, already completed)
3. **S3P modification** — Responsive layout for mobile viewport. Same data confirmation, different chrome.
4. **S4 modification** — Two variants: kiosk completion ("take a seat") and mobile completion ("you're all set for your visit")
5. **S5 modification** — Add "pre-checked-in" status column to queue

## Push-back to PM

1. **Appointment system integration is a dependency I can't design around.** BOX-09 requires a time window relative to an appointment. I need to know: does an appointment entity exist in the system? Can I query it? If there's no appointment system, I can't build time-window logic into the link. PM must clarify this dependency before I finalize the link landing screen.

2. **No-show handling is not a design question.** PM listed it as open. From my vantage: a no-show after pre-check-in is the same as a no-show without it. The session eventually expires. The only design question is: should the receptionist see "pre-checked-in but didn't arrive" in the queue? I say yes — it's useful operational data.

3. **Link delivery mechanism (SMS vs email) is not my concern** as long as the link is a standard URL. I'll design the landing page; PM and Engineer own the delivery channel.
