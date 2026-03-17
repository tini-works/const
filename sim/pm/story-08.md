# Story 08 — Insurance Card Photo Upload (Feature Request)

## Customer's Words

> "My insurance card changed and I had to read the tiny numbers off the card at the kiosk. Can I just take a photo of it? My other doctor's app lets me do that."

## What the Customer Is Saying

1. **"Tiny numbers off the card"** — Manual data entry of insurance details is error-prone and frustrating. Member ID, group number, payer information — these are long alphanumeric strings not designed for human transcription.

2. **"Can I just take a photo"** — The patient wants image capture as the input method. Take a picture, system extracts the data. This is now an expected UX pattern — "my other doctor's app lets me do that."

3. **"My other doctor's app"** — Competitive expectation. Patients compare clinic experiences. Falling behind in convenience erodes loyalty.

## What the Customer Is NOT Saying

- They're not asking for OCR accuracy guarantees. They expect it to work, but they'd likely accept a "please verify these fields" step after photo capture.
- They're not asking to upload other documents (ID, referrals). Just the insurance card. But the capability could extend.
- They're not describing a mobile-only feature. They mentioned the kiosk. This should work on both kiosk (camera) and mobile (phone camera).

## Technical Implications

- **Image capture** on kiosk tablets and mobile devices
- **OCR / document intelligence** to extract structured data (member ID, group number, payer name, plan type) from the card image
- **Image storage** — the photo itself is PHI (it contains patient identifiers). Storage, access controls, retention policies apply.
- **Verification step** — OCR output shown to patient for confirmation before submission. Never trust OCR blindly.
- **Front and back** — Insurance cards typically have relevant info on both sides.

## Relationship to Existing Stories

- Extends S-01 BOX-03 (confirm or update, not re-enter) — photo upload is a better "update" mechanism for insurance specifically
- Relevant to S-03 (mobile pre-check-in) — if pre-check-in exists, photo upload from phone is natural
- Must respect S-04 (data breach) learnings — the captured image must be handled with the same PHI protections
