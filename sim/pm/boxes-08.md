# Boxes — Story 08 (Insurance Card Photo Upload)

---

## BOX-29: Patient can photograph their insurance card to update insurance data

Instead of manually entering insurance details, the patient can take a photo of their insurance card (front and back) and the system extracts the relevant fields.

**Traces to:** "Can I just take a photo of it?"

**Verified when:**
1. Patient selects "Update Insurance" in check-in flow
2. Camera interface opens (kiosk camera or phone camera)
3. Patient captures front and back of card
4. System extracts: member ID, group number, payer name, plan type, effective dates
5. Extracted data is shown to patient for confirmation before submission

---

## BOX-30: OCR output requires patient verification

Extracted data from the card photo is never written directly to the record. The patient must review and confirm or correct the extracted fields.

**Traces to:** OCR is imperfect. "Tiny numbers" on cards are error-prone for both humans and machines.

**Verified when:** After photo capture and OCR, patient sees a form pre-filled with extracted values. Patient confirms or edits each field. Only confirmed/edited values are staged for the session.

---

## BOX-31: Insurance card images are PHI

The photographed insurance card contains patient identifiers (name, member ID, group number). The image is PHI and must be handled accordingly.

**Traces to:** HIPAA (BOX-14, BOX-15, BOX-16).

**Verified when:**
1. Card images are encrypted at rest
2. Card images are transmitted over TLS
3. Access to stored card images is logged
4. Retention policy is defined (store permanently as part of patient record, or discard after data extraction?)
5. Card images are never displayed to other patients (BOX-12)

---

## Open Questions

- **Image retention:** Keep the card photo as part of the patient record (useful for insurance disputes), or discard after extraction? Recommend: keep, with retention policy matching other PHI.
- **Both sides required?** Front has member info. Back has claims address and phone. Require both, or make back optional?
- **Kiosk camera quality:** Are kiosk tablets equipped with cameras adequate for OCR? May need specific hardware requirements.
