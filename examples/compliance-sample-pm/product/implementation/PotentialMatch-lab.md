# UnMatching: lab

## File
`backend-core/app/app-core/api/lab/`

## Analysis
- **What this code does**: Provides a comprehensive laboratory management API. Supports importing lab results (LDT file format), creating and updating lab order forms, viewing lab import overviews with pagination, retrieving lab result details and parameters, checking LDK (Labor-Daten-Kommunikation) online status, fetching LDT content and attachments, generating lab results PDFs, and cancelling lab orders. Also handles timeline hard-delete events for cleanup.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-LAB — Laboratory Order and Result Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-LAB |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E7=Clinical Documentation |
| **Data Entity** | LabOrder, LabResult, LabForm, LDTContent, LabParameter, Patient |

### User Story
As a medical practice staff member, I want to manage laboratory orders and import lab results in LDT format, so that I can track lab requests, review results with pathological flags, and generate PDF reports for patient records.

### Acceptance Criteria
1. Given LDT file data, when the user imports lab results, then the system parses the files and returns any patient-matching conflicts for resolution
2. Given import conflicts, when the user updates import files with patient assignments, then the system resolves the conflicts (import or cancel)
3. Given lab order details and optional LDK check, when the user creates a lab form, then the system generates a lab order with LDT file content and detects duplicate order numbers
4. Given an existing lab order, when the user updates the lab form, then the modified form is saved and returned
5. Given date range and filter criteria, when the user requests lab import overview, then the system returns paginated lab import records with recall message counts
6. Given a lab import ID, when the user requests file detail, then the system returns lab parameters and attached files
7. Given a patient ID and date range, when the user requests lab results, then the system returns parameters, results with pathological indicators, and available parameter options
8. Given lab result criteria, when the user requests a PDF export, then the system generates a downloadable PDF of the lab results
9. Given an active lab order, when the user cancels it, then the order is cancelled and the updated lab form is returned
10. Given a request, when the user checks LDK online status, then the system returns the current connectivity status
11. Given a lab order reference, when the user retrieves LDT content or attachments, then the system returns the raw LDT data or associated files
12. Given a timeline hard-delete event, when it is published, then the lab service cleans up associated lab data

### Technical Notes
- Source: `backend-core/app/app-core/api/lab/`
- Key functions: ImportLab, UpdateImportFile, CancelLabOrder, GetLabResult, CreateLabForm, UpdateLabForm, GetLabImportOverview, GetImportFileDetail, CheckLDKStatus, GetLDTContent, GetLDTAttachment, GetLabResults, GetLabResultsPDF, OnTimelineHardDelete
- Integration points: `backend-core/service/domains/api/lab_common` (lab domain), `backend-core/service/domains/api/profile` (patient profiles), `backend-core/app/profile/api/profile_bff` (employee profiles), `backend-core/app/app-core/api/timeline` (timeline hard-delete events)

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 3.3 Laboratory Proficiency Testing | [`compliances/phase-3.3-laboratory-proficiency-testing.md`](../../compliances/phase-3.3-laboratory-proficiency-testing.md) | P20-010, P20-020, P20-070 |

### Compliance Mapping

#### 3.3 Laboratory Proficiency Testing
**Source**: [`compliances/phase-3.3-laboratory-proficiency-testing.md`](../../compliances/phase-3.3-laboratory-proficiency-testing.md)

**Related Requirements**:
- "Every billing software for laboratory services must provide a function to capture RV-relevant analytes and manage proficiency test certificates (Ringversuchszertifikate)."
- "The system must check for possible proficiency testing participation obligations by automated comparison against the service documentation for laboratory services."
- "The RVSA dataset must be transmitted as part of the billing per the KVDT dataset specification."

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Given LDT file data, when the user imports lab results, then the system parses the files | P20-010: provide a function to capture RV-relevant analytes and manage proficiency test certificates |
| AC7: Given a patient ID and date range, when the user requests lab results, then the system returns parameters and results with pathological indicators | P20-020: check for possible proficiency testing participation obligations by automated comparison against service documentation |
| AC3: Given lab order details and optional LDK check, when the user creates a lab form | P20-070: RVSA dataset must be transmitted as part of the billing per the KVDT dataset specification |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
