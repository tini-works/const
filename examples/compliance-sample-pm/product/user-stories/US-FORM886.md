## US-FORM886 — On a separate document without fixed layout, additional information for...

| Field | Value |
|-------|-------|
| **ID** | US-FORM886 |
| **Traced from** | [FORM886](../compliances/SV/FORM886.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E4: Form Generation](../epics/E4-form-generation.md) |
| **Data Entity** | FRM, PAT, MED |

### User Story

As a practice staff (MFA), I want on a separate document without fixed layout, additional information for the FaV cover letter is printable, including lab values and current medication loaded from the patient record, with an appropriate hint text, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given a FaV patient, when the supplementary document is created, then lab values and current medication can be loaded from the patient record and printed with an appropriate hint text

### Actual Acceptance Criteria

**Status: Implemented**

1. The `FormAPP.GetForm` and `FormAPP.Print` endpoints handle the supplementary FaV document generation and printing
2. The `MedicineApp.GetMedicationPrescribe` and `MedicineApp.GetShoppingBag` endpoints provide current medication data from the patient record
3. Lab values can be loaded from the patient record via the document management service for inclusion in the supplementary document
4. The `FormAPP.PrintPlainPdf` endpoint supports free-layout document printing with configurable `formSetting` JSON for hint text inclusion
