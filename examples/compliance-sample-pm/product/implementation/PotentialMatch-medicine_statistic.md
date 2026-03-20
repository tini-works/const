# UnMatching: medicine_statistic

## File
`backend-core/app/app-core/api/medicine_statistic/`

## Analysis
- **What this code does**: Provides medication prescription statistics and reporting. Supports querying medication prescriptions with filters (patient IDs, date range, Schein main groups) and pagination/sorting, exporting prescription data as a downloadable document, and retrieving consultation-level prescriptions by BSNR (practice location). Returns prescription details including drug information, pricing, and associated doctor/patient data.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-MEDICINE_STATISTIC — Medication Prescription Statistics and Reporting

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-MEDICINE_STATISTIC |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E6=Medication Management |
| **Data Entity** | MedicationPrescription, Patient, Doctor, Drug, Schein |

### User Story
As a physician or practice manager, I want to query and export medication prescription statistics with filters for patients, date ranges, and Schein main groups, so that I can analyze prescribing patterns, track drug costs, and generate reports for practice management.

### Acceptance Criteria
1. Given filter criteria (patient IDs, date range, Schein main groups), when the user queries medication prescriptions, then the system returns paginated and sortable prescription data including drug information, pricing, doctor, and patient details
2. Given the same filter criteria, when the user exports medication prescriptions, then the system generates a downloadable document with the prescription data
3. Given a BSNR and pagination parameters, when the user requests consultation prescriptions, then the system returns prescriptions grouped by consultation for that practice location

### Technical Notes
- Source: `backend-core/app/app-core/api/medicine_statistic/`
- Key functions: GetMedicationPrescription, ExportMedicationPrescription, GetConsultationPrescriptions
- Integration points: `backend-core/app/app-core/api/medicine` (DrugInformation, PriceInformation), `backend-core/app/app-core/api/patient_overview` (PatientOverview), `backend-core/app/profile/api/profile_bff` (EmployeeProfileResponse), `backend-core/service/domains/api/common` (MainGroup, PaginationRequest)

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| AVWG K4-150 — Export of Prescription Data | [`product/compliances/AVWG/K4-150.md`](../compliances/AVWG/K4-150.md) | Section 4.2 Statistik-Funktion |
| AVWG K4-200 — Creation of Statistics, Graphical Representation | [`product/compliances/AVWG/K4-200.md`](../compliances/AVWG/K4-200.md) | Section 4.2 Statistik-Funktion |

### Compliance Mapping

#### AVWG K4-150 — Export of Prescription Data
**Source**: [`product/compliances/AVWG/K4-150.md`](../compliances/AVWG/K4-150.md)

**Related Requirements**:
- "A simple export of prescription data stored in the medical records to spreadsheet programs must be enabled, provided the prescribing software does not offer statistical services per K4-200"
- "The following data must be exportable at a minimum per prescribed product: Date of the prescription, Patient reference (name, insurance number), PZN, Trade name, ATC code, Price (AVP per AMPreisV or § 129 Absatz 5a SGB V for non-prescription medicines) at the time of the prescription, For prescriptions of multiples of a pack, the quantity where applicable"

#### AVWG K4-200 — Creation of Statistics, Graphical Representation
**Source**: [`product/compliances/AVWG/K4-200.md`](../compliances/AVWG/K4-200.md)

**Related Requirements**:
- "The creation of statistics is possible. Prescription-related metrics (e.g., costs, number of prescriptions, number of DDD) can be presented on a case-count basis (related to the total case count), prescription-case-count basis (related to the number of cases with at least one prescription), or individual-case basis (related to a single case)."
- "A breakdown of the statistics by individual medicinal products or product groups (e.g., by ATC code) or by individual patient groups (e.g., by age, gender, or ICD-10-GM diagnosis) is possible."
- "The graphical representation of the results is possible in the form of various chart types by years, quarters, months, etc."

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Query medication prescriptions with filters (patient IDs, date range, Schein main groups) | K4-200: Breakdown of statistics by individual patient groups, by defined time periods (year, quarter) |
| AC2: Export medication prescriptions as downloadable document | K4-150: Export of prescription data to spreadsheet programs with minimum fields (date, patient, PZN, trade name, ATC, price, quantity) |
| AC3: Get consultation prescriptions by BSNR | K4-200: Prescription-related metrics on case-count and prescription-case-count basis |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
