# UnMatching: diga

## File
`backend-core/app/app-core/api/diga/`

## Analysis
- **What this code does**: Manages DiGA (Digitale Gesundheitsanwendungen / Digital Health Applications) functionality. Provides search and detail views for the DiGA directory with filtering by price, status, and age group. Supports prescribing DiGAs to patients, updating and exporting prescriptions, searching similar DiGAs, creating free-text prescriptions with validation, and PDF generation via QES signing. Integrates with the patient timeline and form systems.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

## Classification
- [x] User-facing feature
- [ ] Infrastructure/utility
- [ ] Dead code

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-DIGA — Digital Health Application (DiGA) Prescribing

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-DIGA |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E6 — Medication |
| **Data Entity** | DigaItem, DigaDetail, DigaPrescribe |

### User Story
As a medical practitioner, I want to search the DiGA directory, view detailed information about digital health applications, and prescribe them to patients with PDF generation and QES signing, so that I can offer regulated digital therapy options as part of patient treatment plans.

### Acceptance Criteria
1. Given an authenticated user, when they search the DiGA directory with query, type, pagination, and filters (price, status, age group), then matching DiGA items are returned with last-updated timestamp.
2. Given an authenticated user, when they view a DiGA detail by ID, then comprehensive information including platform availability, indications, contraindications, and history is returned.
3. Given an authenticated user, when they prescribe a DiGA to a patient, then the prescription is created and linked to the patient timeline.
4. Given an authenticated user, when they update an existing DiGA prescription, then the prescription is modified accordingly.
5. Given an authenticated user, when they search for similar DiGAs, then related alternatives are returned.
6. Given an authenticated user, when they create a free-text DiGA prescription, then the input is validated and the prescription is created.
7. Given an authenticated user, when they export prescriptions, then the prescriptions are exported (e.g., as PDF via QES signing).
8. Given a timeline hard-delete event, when the system processes it, then associated DiGA prescriptions are cleaned up.

### Technical Notes
- Source: `backend-core/app/app-core/api/diga/`
- Key functions: Search, GetDigaDetail, Prescribe, UpdatePrescribe, GetPrescribes, SearchSimilarDiga, CreateFreeText, ValidateFreeText, ExportPrescribes
- Integration points: `service/domains/form/common`, `service/domains/qes/common`, `service/domains/repos/app_core/patient_encounter`, `service/domains/api/patient_profile_common`

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| Phase 4.5 — eVDGA Digital Health Apps | [`compliances/phase-4.5-evdga-digital-health-apps.md`](../../compliances/phase-4.5-evdga-digital-health-apps.md) | DiGA Prescriptions, eVDGA FHIR Bundle Generation |

### Compliance Mapping

#### Phase 4.5 — eVDGA Digital Health Apps (DiGA Prescribing)
**Source**: [`compliances/phase-4.5-evdga-digital-health-apps.md`](../../compliances/phase-4.5-evdga-digital-health-apps.md)

**Related Requirements**:
- "Search and select DiGA by name, indication, or DiGA-VE-ID"
- "Validate that the selected DiGA is currently listed and approved"
- "Check indication alignment with the patient's documented diagnoses"
- "Generate the prescription with required fields: DiGA name, DiGA-VE-ID, PZN (if applicable), indication"
- "Support the full lifecycle: create, sign (QES via eHBA), submit to E-Rezept Fachdienst"
- "Generate patient-readable copy with redemption information"

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Search DiGA directory with query, type, pagination, and filters | Search and select DiGA by name, indication, or DiGA-VE-ID |
| AC2: View DiGA detail by ID | Validate that the selected DiGA is currently listed and approved |
| AC3: Prescribe a DiGA to a patient | Generate the prescription with required fields: DiGA name, DiGA-VE-ID, PZN, indication |
| AC6: Create free-text DiGA prescription with validation | Generate the prescription with required fields |
| AC7: Export prescriptions as PDF via QES signing | Support the full lifecycle: create, sign (QES via eHBA), submit to E-Rezept Fachdienst |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
