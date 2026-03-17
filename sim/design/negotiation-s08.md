# Design Negotiation — Story 08 (Insurance Card Photo Upload)

## Context

Feature request. Patient wants to photograph their insurance card instead of typing tiny numbers. Competitive expectation ("my other doctor's app lets me do that").

## Boxes Received from PM

| Box | Verdict | Notes |
|-----|---------|-------|
| BOX-29: Patient can photograph insurance card | **Accepted — this is a sub-flow within S3P** | The photo capture happens inside the insurance section's "Update" action. It's an alternative to manual entry, not a replacement. The patient chooses: type the numbers OR take a photo. |
| BOX-30: OCR output requires patient verification | **Accepted — this is load-bearing** | I'm designing a review screen that shows the extracted fields alongside the card image. The patient must confirm or correct each field before submission. This is not a "looks good?" checkbox — it's field-by-field review. |
| BOX-31: Insurance card images are PHI | **Accepted — design implications for retention and display** | The card image appears in the verification step and then must be handled per HIPAA (BOX-14, 15, 16). I need to design what happens to the image after verification: is it visible later? Can the receptionist see it? Can it be re-accessed at the next visit? |

## Boxes I'm Adding

### BOX-D17: Photo capture has clear framing guidance

Taking a photo of an insurance card with a tablet or phone camera is error-prone: bad angle, poor lighting, finger covering text, blurry. The capture interface must guide the patient:
- A card-shaped overlay/frame on the camera viewfinder
- "Position card within the frame" instruction
- Auto-capture when card is detected (if technically feasible) or manual shutter button
- Immediate quality feedback: "Image is blurry — try again" or "Card detected" before proceeding to OCR

**Why PM missed this:** PM's box says "camera interface opens." But a raw camera is not enough. The difference between a good insurance card photo and an unreadable one is framing guidance.

### BOX-D18: Manual entry remains available as fallback

Photo capture can fail: camera broken, card is too worn, OCR can't extract data. The patient must always be able to fall back to manual entry. The flow is: try photo first -> if it works, great -> if not, type it in.

**Why this matters:** If photo capture is the only path and it fails, the patient is stuck. Manual entry is the safety net. It should be accessible from the photo capture screen: "Having trouble? Enter your information manually."

## Design Changes: Insurance Photo Capture Sub-Flow

This is a sub-flow within S3P's insurance section "Update" action.

### Step 1: Capture Choice
```
How would you like to update your insurance?

[Take a photo of your card]     [Enter manually]
```

### Step 2: Photo Capture (if photo chosen)
```
[Camera viewfinder]
┌─────────────────────────────┐
│                             │
│    ┌───────────────────┐    │
│    │                   │    │
│    │  Position card    │    │
│    │  within frame     │    │
│    │                   │    │
│    └───────────────────┘    │
│                             │
└─────────────────────────────┘

Capture FRONT of card first.

[Capture]     [Enter manually instead]
```

After front captured:
```
Front captured!  [Retake]

Now capture the BACK of your card.

[Capture]     [Skip back — front only]
```

### Step 3: OCR Processing
```
Reading your card...

[spinner / progress animation]
```

If OCR fails:
```
We couldn't read your card clearly.

[Try again]     [Enter manually instead]
```

### Step 4: Verification (if OCR succeeds)
```
Please verify the information from your card:

Insurance Provider:  [BlueCross BlueShield    ]  ✓ Correct  [Edit]
Member ID:           [XYZ123456789            ]  ✓ Correct  [Edit]
Group Number:        [98765                   ]  ✓ Correct  [Edit]
Plan Type:           [PPO                     ]  ✓ Correct  [Edit]

Card image: [thumbnail of front] [thumbnail of back]

[Confirm — this information is correct]
```

Each field shows the OCR result pre-filled. The patient can mark each as correct or edit it. Only after all fields are reviewed (confirmed or edited) does the "Confirm" button activate.

### Step 5: Return to S3P
After confirmation, the insurance section on S3P shows as "Updated" (blue highlight) with the new values. The card images are attached to the session as evidence.

## Design Impact

1. **S3P modification** — Insurance section "Update" action branches to photo capture sub-flow or manual entry
2. **No new top-level screens** — The photo capture flow is a modal/overlay within S3P, not a separate screen in the state machine
3. **Receptionist impact (S3R)** — When the receptionist sees the insurance diff, they should also see the card image (helps them verify: "let me see your card" becomes "I can see the card image already")

## Push-back to PM

1. **"Both sides required?"** — I'm designing front as required, back as optional but encouraged. The front has the member info. The back has claims info that's nice to have but not critical for check-in. If PM disagrees, the flow adjusts easily.

2. **Image retention policy must be decided before launch.** My design shows the card image on the receptionist's screen (S3R) and stores it with the session. But if the image is discarded after OCR extraction, the receptionist loses the "let me see your card" convenience. I recommend keeping the image as part of the patient record (useful for insurance disputes), but PM must confirm given HIPAA storage implications.

3. **Kiosk camera quality is a hardware question, not a design question.** I'll design for both good and bad cameras (the "try again" and "enter manually" fallbacks handle bad hardware). But if the kiosk tablets have rear-facing-only cameras, the patient has to hold the card in an awkward position. PM/DevOps should assess hardware.
