# UnMatching: service_awst

## File
`backend-core/service/awst/`

## Analysis
- **What this code does**: Provides patient data import from AWST (Arztwechselservice - Doctor Change Service) XML files. Parses XML bundles, transforms them into patient profile creation requests, and imports them via the patient profile service. The Transform method currently has a panic("implement me"), indicating this is partially implemented.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-SERVICE_AWST — Patient Import from Doctor Change Service (AWST)

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-SERVICE_AWST |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E3=Patient Management |
| **Data Entity** | Bundle (AWST XML), PatientProfile, CreatePatientProfileV2Request |

### User Story
As a care provider member, I want to import patient data from AWST (Arztwechselservice - Doctor Change Service) XML files, so that patients transferring from another practice can be onboarded with their existing data.

### Acceptance Criteria
1. Given an uploaded AWST XML file, when the import is initialized with a file ID, then the XML bundle is fetched from document management and parsed into a patient transform model
2. Given a parsed AWST XML bundle, when the transform step is executed, then the XML data is converted into a CreatePatientProfileV2Request (NOTE: Transform is currently unimplemented with panic("implement me"))
3. Given a valid patient profile creation request, when the import step is executed, then a new patient profile is created via the patient profile service

### Technical Notes
- Source: `backend-core/service/awst/`
- Key functions: InitializeTransform, Transform (NOT YET IMPLEMENTED), Import
- Integration points: DocumentManagementService (file retrieval), PatientProfileBffImpl (patient creation), XML decoding of AWST Bundle model
- WARNING: The Transform method currently contains `panic("implement me")` indicating partial implementation
