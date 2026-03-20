# UnMatching: billing_patient

## File
`backend-core/app/app-core/api/billing_patient/`

## Analysis
- **What this code does**: Provides a patient-level billing service (BillingPatientApp) for quarterly KV (Kassenaerztliche Vereinigung) billing. Supports retrieving billing data per patient by date and billing doctor, generating print content with point values and quotes, printing billing summaries via printer profiles, viewing print history, and updating excluded service codes with reasons. Core to the quarterly billing workflow for statutory health insurance patients.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-BILLING_PATIENT — Quarterly KV Patient Billing Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-BILLING_PATIENT |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E1: Billing Documentation |
| **Data Entity** | BillingPatientModel, BillingPatientPrintModel, BillingPatientPrintHistoryModel |

### User Story

As a practice staff member, I want to manage quarterly KV patient billing including viewing billing data per patient, generating print content with point values and quotes, printing billing summaries, viewing print history, and excluding service codes with reasons, so that I can complete the quarterly billing workflow for statutory health insurance patients.

### Acceptance Criteria

1. Given a selected date, billing doctor ID, and pagination, when the user requests billing patient data, then the system returns paginated billing records for the quarter.
2. Given a list of patient bill IDs, selected date, BSNR code, quote, and point value, when the user requests print content, then the system generates billing print data with calculated values.
3. Given prepared print data and a printer profile, when the user prints billing patient summaries, then the system sends the data to the specified printer.
4. Given a history ID, when the user requests print history, then the system returns the historical print record.
5. Given a billing patient ID and timeline IDs, when the user updates excluded service codes with a reason, then the specified service codes are excluded from the billing.

### Technical Notes
- Source: `backend-core/app/app-core/api/billing_patient/`
- Key functions: GetBillingPatient, GetBillingPatientPrintContent, PrintBillingPatient, GetBillingPatientPrintHistory, UpdateExcludedServiceCodes
- Integration points: billing_patient_common (BillingPatientModel, BillingPatientPrintModel), printer_common (PrinterProfile), common (PaginationRequest)

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 3.2 Patient Receipts | [`compliances/phase-3.2-patient-receipts.md`](../../compliances/phase-3.2-patient-receipts.md) | P2-820, P2-830, P2-840 |

### Compliance Mapping

#### 3.2 Patient Receipts
**Source**: [`compliances/phase-3.2-patient-receipts.md`](../../compliances/phase-3.2-patient-receipts.md)

**Related Requirements**:
- "The patient receipt must list the services the physician documents for their own billing. Only valued services from the SDEBM (EBM master data) are included. The orientation values give patients an indication of the economic value of services rendered."
- "Patient receipt generation must meet the defined content and layout requirements per Tabelle 11. The receipt must be generateable on demand for any patient upon request."
- "The patient receipt must conform to the detailed content and layout specifications defined in Tabelle 11."

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: paginated billing records for the quarter | P2-820: list services documented for billing with orientation values |
| AC2: generate billing print data with point values and quotes | P2-820: orientation values from EBM; P2-840: content and layout per Tabelle 11 |
| AC3: print billing patient summaries via printer | P2-830: receipt generateable on demand for any patient |
| AC4: return historical print record | P2-830: patient receipt generation requirements |
| AC5: exclude service codes from billing with reason | P2-820: only valued services from SDEBM included |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
