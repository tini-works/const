# UnMatching: vos

## File
`backend-core/app/app-core/api/vos/`

## Analysis
- **What this code does**: Provides the VOS (Verordnungssoftware - Prescription Software) API for creating electronic prescriptions. Supports creating prescriptions with a patient context (patient ID, schein, doctor, form info), with a BSNR context, or via ERP (E-Rezept) using access codes and task IDs. Returns a VOS model representing the generated prescription.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-VOS — Electronic Prescription Creation (Verordnungssoftware)

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-VOS |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E6=Medication Management |
| **Data Entity** | VOSModel, CreateVOSWithPatientRequest, CreateVOSWithBsnrRequest, CreateVOSWithERPRequest |

### User Story
As a care provider member, I want to create electronic prescriptions through the VOS (Verordnungssoftware) module using patient context, BSNR context, or ERP (E-Rezept) access codes, so that I can issue prescriptions digitally within the practice management workflow.

### Acceptance Criteria
1. Given an authenticated care provider member with a patient context, when they create a VOS prescription with patient ID, schein ID, doctor ID, and form info, then a VOSModel is returned representing the generated prescription
2. Given an authenticated care provider member, when they create a VOS prescription with a BSNR code and doctor ID, then a VOSModel is returned for that practice location context
3. Given an authenticated care provider member, when they create a VOS prescription via ERP using a doctor ID, access code, and task ID, then a VOSModel is returned linked to the E-Rezept

### Technical Notes
- Source: `backend-core/app/app-core/api/vos/`
- Key functions: CreateVOSWithPatient, CreateVOSWithBsnr, CreateVOSWithERP
- Integration points: medicine_common (FormInfo), vos/common (VOSModel), NATS RPC (api.app.app_core)

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 4.1 E-Rezept Core | [`compliances/phase-4.1-erezept-core.md`](../../compliances/phase-4.1-erezept-core.md) | Prescription Builder, FHIR Resource Generation |

### Compliance Mapping

#### 4.1 E-Rezept Core
**Source**: [`compliances/phase-4.1-erezept-core.md`](../../compliances/phase-4.1-erezept-core.md)

**Related Requirements**:
- "The system must support creation of electronic prescriptions for four medication types: PZN-based, Ingredient-based (Wirkstoff), Compounding (Rezeptur), Free-text"
- "The system must generate compliant FHIR R4 bundles conforming to the gematik E-Rezept profiles"
- "The system must support comfort signature mode (Komfortsignatur) allowing the physician to sign up to 250 prescriptions per day after a single PIN entry on the eHBA"
- "Prescriptions must be queueable for batch signing, enabling the physician to review and sign multiple prescriptions in a single workflow step"

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Given an authenticated care provider member with a patient context, when they create a VOS prescription with patient ID, schein ID, doctor ID, and form info, then a VOSModel is returned | "The system must support creation of electronic prescriptions for four medication types" |
| AC3: Given an authenticated care provider member, when they create a VOS prescription via ERP using a doctor ID, access code, and task ID, then a VOSModel is returned linked to the E-Rezept | "The system must generate compliant FHIR R4 bundles conforming to the gematik E-Rezept profiles" and comfort signature/batch signing requirements |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
