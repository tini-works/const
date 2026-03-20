# UnMatching: service_diga

## File
`backend-core/service/diga/`

## Analysis
- **What this code does**: Provides the DiGA (Digitale Gesundheitsanwendungen - Digital Health Applications) service for managing digital health application prescriptions. Handles DiGA master data, prescription creation via timeline integration, eRezept (e-prescription) integration, XSL transformation for documents, and MinIO file storage. Integrates with TI (Telematik Infrastructure) settings, patient profiles, and schein data.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

## Classification
- [x] Create new User Story for this functionality

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-DIGA — Digital Health Application (DiGA) Prescription Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-DIGA |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E6=Medication Management |
| **Data Entity** | DiGA, PrescribeEntity, DigaMasterdata, PrescribeDetail, Timeline |

### User Story
As a physician, I want to search for, prescribe, update, and export Digital Health Applications (DiGA), so that patients can receive validated digital health application prescriptions integrated with e-prescriptions and the patient timeline.

### Acceptance Criteria
1. Given a DiGA search query, when Search is called, then matching DiGA entries from the master data catalog are returned
2. Given a patient and DiGA selection, when Prescribe is called, then a prescription is created and linked to the patient timeline with proper schein association
3. Given an existing DiGA prescription, when UpdatePrescribe is called, then the prescription details are updated and the timeline entry is refreshed
4. Given a DiGA prescription, when ExportPrescribes is called, then the prescription documents are generated via XSL transformation and stored in MinIO
5. Given a patient ID, when GetPrescribes is called, then all DiGA prescriptions for that patient are returned with full detail including device and organization info
6. Given a DiGA, when GetDigaDetail is called, then complete details including questionnaires and charge item definitions are returned from the FHIR-based master data
7. Given a free text request, when ValidateFreeText is called, then the text is validated against DiGA-specific constraints
8. Given a timeline hard delete, when OnTimelineHardDelete is called, then the associated DiGA prescription is also removed

### Technical Notes
- Source: `backend-core/service/diga/`
- Key functions: Search, Prescribe, UpdatePrescribe, DeletePrescribe, ExportPrescribes, GetPrescribes, GetPrescribeById, SearchPrescribe, SearchSimilarDiga, GetDigaDetail, ValidateFreeText, CreateFreeText, DeleteByPatientId, OnTimelineHardDelete
- Integration points: diga/repo (MongoDB master data + prescriptions), diga/api (FHIR catalog, device, org, questionnaire), diga/elt (ETL transform), timeline_service, erezept (e-prescription client), MinIO (document storage), XSL transformer, TI settings, patient_profile, schein, employee profile, socket notifier

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| Phase 4.5 — eVDGA Digital Health Apps | [`compliances/phase-4.5-evdga-digital-health-apps.md`](../../compliances/phase-4.5-evdga-digital-health-apps.md) | DiGA Prescriptions, eVDGA FHIR Bundle Generation |

### Compliance Mapping

#### Phase 4.5 — eVDGA Digital Health Apps (DiGA Service Layer)
**Source**: [`compliances/phase-4.5-evdga-digital-health-apps.md`](../../compliances/phase-4.5-evdga-digital-health-apps.md)

**Related Requirements**:
- "Search and select DiGA by name, indication, or DiGA-VE-ID"
- "Validate that the selected DiGA is currently listed and approved"
- "Check indication alignment with the patient's documented diagnoses"
- "Conform to the gematik eVDGA FHIR profiles"
- "Include MedicationRequest referencing the DiGA"
- "Support the full lifecycle: create, sign (QES via eHBA), submit to E-Rezept Fachdienst"

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Search DiGA entries from master data catalog | Search and select DiGA by name, indication, or DiGA-VE-ID |
| AC2: Prescribe DiGA linked to patient timeline | Generate the prescription with required fields; Support the full lifecycle |
| AC4: Export prescription documents via XSL transformation | Conform to gematik eVDGA FHIR profiles |
| AC6: Get DiGA detail including questionnaires and charge item definitions from FHIR-based master data | Validate that the selected DiGA is currently listed and approved; BfArM DiGA Directory integration |
| AC7: Validate free text against DiGA-specific constraints | Check indication alignment with the patient's documented diagnoses |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
