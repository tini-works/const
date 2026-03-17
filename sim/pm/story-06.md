# Story 06 — Medication List Mandate (Compliance Requirement)

## Source Words (State Health Board)

> "Effective Q3, all outpatient clinics must collect and display the patient's current medication list during check-in. The patient must confirm or update their medications at every visit. This is mandatory for license renewal."

## What the Mandate Is Saying

1. **"Collect and display the patient's current medication list"** — Medications are a new data category, joining allergies, insurance, and address. But unlike those, this is clinically active data that changes frequently.

2. **"During check-in"** — The check-in flow is the mandated collection point. Not a separate workflow, not a pre-visit questionnaire — it happens at check-in.

3. **"Confirm or update at every visit"** — No staleness exception. Unlike address (rarely changes) or insurance (changes annually), medications must be actively confirmed every single visit. This is a different freshness policy than anything we've had.

4. **"Mandatory for license renewal"** — Non-negotiable. Failure to comply risks the clinic's operating license. This is not a feature request — it is a regulatory requirement with enforcement consequences.

## Impact on Existing Boxes

**BOX-02 (previously collected data is not re-asked):** Medications are an exception. The mandate requires re-confirmation every visit. This doesn't contradict BOX-02 — the patient is still shown their existing medication list for confirmation, not a blank form. But the staleness threshold for medications is effectively 0 days — always stale, always requires active confirmation.

**BOX-03 (confirm or update, not re-enter):** Applies. The patient confirms or updates their medication list, not re-enters from scratch.

**Design's staleness thresholds** (6 months insurance, 12 months address, never allergies): Must add medications = 0 days (always confirm).

## New Data Characteristics

Medications differ from allergies/insurance/address:
- **Variable length** — A patient may be on 0 or 15 medications
- **Structured data** — Drug name, dosage, frequency, prescribing doctor
- **Clinically sensitive** — Errors here have patient safety implications
- **Frequently changing** — Patients add/remove medications between visits
- **Potential drug interaction implications** — Display may need to flag interactions (future scope, not in mandate)

## Compliance Box Required

This generates a mandatory compliance box. The clinic's license depends on provable compliance. QA needs a verification path that can demonstrate: every patient check-in collected/confirmed a medication list.

## Timeline Pressure

"Effective Q3" — this is a deadline, not a suggestion. The system must support medication collection at check-in by Q3.
