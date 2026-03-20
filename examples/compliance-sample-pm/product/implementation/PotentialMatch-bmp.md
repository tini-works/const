# UnMatching: bmp

## File
`backend-core/app/app-core/api/bmp/`

## Analysis
- **What this code does**: Provides a comprehensive BMP (Bundeseinheitlicher Medikationsplan / German federal medication plan) management service (BmpApp). Supports parsing medication plan barcodes, comparing and merging medication plans, managing medication entries (add/update/delete/sort), printing medication plans as PDF (directly and via MMI integration), managing subheadings and keytabs, refilling medications, and handling asynchronous comparison results via events. A core clinical feature for medication reconciliation.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-BMP — Federal Medication Plan (BMP) Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-BMP |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E6: Medication Management |
| **Data Entity** | MedicationPlan, MedicationEntry, BmpKeytab, MedicationPlanGroup |

### User Story

As a practitioner, I want to manage German federal medication plans (BMP) including parsing barcodes, comparing and merging medication plans, adding/updating/deleting entries, reordering, printing as PDF, refilling medications, and managing subheadings and keytabs, so that I can maintain accurate and up-to-date medication plans for my patients and support medication reconciliation workflows.

### Acceptance Criteria

1. Given a medication plan barcode, when the practitioner scans it, then the system parses the barcode and returns structured medication plan data.
2. Given a patient's existing BMP and an imported plan, when the practitioner compares them, then the system identifies differences and returns comparison results with group-level status.
3. Given comparison results, when the practitioner saves the merge result, then the system merges the plans and returns the updated BMP list.
4. Given a patient ID, when the practitioner requests the BMP list, then the system returns all medication plan entries for that patient.
5. Given medication entry data, when the practitioner adds, updates, or deletes an entry, then the system modifies the medication plan accordingly.
6. Given a list of entry IDs in a desired order, when the practitioner saves the sorted list, then the system reorders the medication plan entries.
7. Given a patient's medication plan, when the practitioner prints it as PDF (directly or via MMI), then the system generates and returns the PDF document.
8. Given a medication entry, when the practitioner refills it, then the system creates new prescriptions for the specified doctor, contract, and encounter case.
9. Given an asynchronous comparison event completes, when the result is published, then the system notifies the requesting user via WebSocket with the comparison results.

### Technical Notes
- Source: `backend-core/app/app-core/api/bmp/`
- Key functions: ParseBarcode, ParseBarcodeForUnmatch, CompareWithBmp, CompareWithBmpEvent, SaveMergeResult, GetBmpList, AddEntry, UpdateEntry, DeleteEntry, SaveSortedIdList, GetSubheadingsList, AddKeytab, GetPredefinedDataOfMedication, RefillMedicationBmp, PrintPdf, PrintPdfViaMMI, QuitMergeMedicationPlan, UpdateAdditionalData, UpdateBmpOutDateViaMMI
- Integration points: bmp domain types, medicine/common (MedicineInfo), MMI integration for PDF printing, WebSocket notifications (ResultCompareBmp events)

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| Phase 4.6 — BMP Medication Plan | [`compliances/phase-4.6-bmp-medication-plan.md`](../../compliances/phase-4.6-bmp-medication-plan.md) | Create/Edit, Rearrange, Multi-Version, 2D Barcode |
| AVWG P3-800 — Medication Plan per § 31a SGB V | [`product/compliances/AVWG/P3-800.md`](../compliances/AVWG/P3-800.md) | Section 3.10 Medikationsplan |

### Compliance Mapping

#### Phase 4.6 — BMP Medication Plan
**Source**: [`compliances/phase-4.6-bmp-medication-plan.md`](../../compliances/phase-4.6-bmp-medication-plan.md)

**Related Requirements**:
- "The system must support creation and editing of the Bundeseinheitlicher Medikationsplan (BMP — Federal Uniform Medication Plan) in accordance with the BMP specification"
- "Add medications with: trade name, active ingredient, strength, dosage form, dosage schedule (morning/noon/evening/night), unit, notes"
- "The physician must be able to reorder medication entries on the plan"
- "The system must support multiple BMP specification versions simultaneously"
- "The system must read BMP data from printed medication plans via 2D barcode (DataMatrix)"
- "Parse encoded medication data per BMP specification"
- "Reconcile imported data with existing medication records"

#### AVWG P3-800 — Medication Plan per § 31a SGB V
**Source**: [`product/compliances/AVWG/P3-800.md`](../compliances/AVWG/P3-800.md)

**Related Requirements**:
- "The prescribing software must contain the functions and information necessary for the creation and updating of the medication plan pursuant to § 31a SGB V."

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Parse medication plan barcode | Phase 4.6: Read BMP data from printed medication plans via 2D barcode (DataMatrix); Parse encoded medication data per BMP specification |
| AC2: Compare existing BMP with imported plan | Phase 4.6: Reconcile imported data with existing medication records |
| AC3: Save merge result | Phase 4.6: Reconcile imported data with existing medication records |
| AC4: Get BMP list for patient | P3-800: Functions necessary for creation and updating of medication plan per § 31a SGB V |
| AC5: Add, update, or delete medication entry | Phase 4.6: Add medications with trade name, active ingredient, strength, dosage form, dosage schedule |
| AC6: Reorder medication plan entries | Phase 4.6: The physician must be able to reorder medication entries on the plan |
| AC7: Print medication plan as PDF | Phase 4.6: BMP creation conforming to specification |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
