# UnMatching: schein

## File
`backend-core/app/app-core/api/schein/`

## Analysis
- **What this code does**: Provides the core Schein (treatment case/insurance voucher) management API. Supports creating, updating, deleting, and querying Scheins for KV, BG, and private billing. Handles treatment case validation, diagnosis takeover, billing marking, KTAB lookups, psychotherapy tracking, subgroup/billing area master data retrieval, and Rezidiv lists. Listens to schein change and patient participation change events. This is a central user-facing domain module.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-SCHEIN — Treatment Case (Schein) Management for KV, BG, and Private Billing

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-SCHEIN |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E1 Billing Documentation |
| **Data Entity** | Schein, PrivateSchein, ScheinDetail, TreatmentCase, KTAB, Psychotherapy |

### User Story
As a physician or practice staff member, I want to create, update, validate, and manage treatment cases (Scheine) for KV statutory billing, BG occupational injury billing, and private billing, so that all patient encounters are properly documented and billable per quarterly billing requirements.

### Acceptance Criteria
1. Given valid patient and insurance data, when the user creates a KV/BG Schein with quarter, year, and treatment case details, then a new Schein is created and returned with its ID
2. Given an existing Schein, when the user updates it with modified fields, then the Schein is updated accordingly
3. Given an existing Schein ID, when the user deletes it, then the Schein is removed from the system
4. Given Schein creation data and insurance information, when validation is requested, then field-level errors are returned if any constraints are violated
5. Given a patient and insurance context, when requesting Schein overview, then all Scheins for that context are listed
6. Given billing preparation, when MarkBill is called with contract and main group, then matching Scheins are marked for billing
7. Given a VKNR, special group, and quarter, when requesting KTABs, then the applicable KTAB values are returned
8. Given a patient with previous Scheins, when diagnosis takeover is requested, then diagnoses from prior Scheins are carried forward
9. Given private billing context, when creating/updating/validating a private Schein, then private Schein operations with GOA factor values are handled
10. Given SV Schein creation, when automatic or manual creation is triggered, then SV Scheins are created with appropriate contract linkage
11. Given a Schein change or patient participation change event, when the event is received, then related Schein data is updated reactively

### Technical Notes
- Source: `backend-core/app/app-core/api/schein/`
- Key functions: CreateSchein, UpdateSchein, DeleteSchein, IsValid, GetScheinDetail, GetScheinsOverview, MarkBill, GetKTABs, TakeOverScheinDiagnosis, CreatePrivateSchein, UpdatePrivateSchein, CreateSvScheinAutomaticly, CreateSvScheinManually, MarkAsReferral, RevertTechnicalSchein
- Integration points: `service/domains/api/schein_common`, `service/domains/api/private_schein_common`, `service/domains/api/patient_participation`, `service/domains/api/patient_profile_common`, `service/domains/api/catalog_sdkt_common`, `service/domains/timeline/common`
- Subscribes to EventScheinChanged, EventCreateRemoveSchein, EventPatientParticipationChange

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 1.5 Schein Management | [`compliances/phase-1.5-schein-management.md`](../../compliances/phase-1.5-schein-management.md) | KP2-500, P2-501, KP2-502–514, P2-520, P2-521, P2-530, P2-535, P2-540, KP2-560, P2-790 |
| 1.2 Cost Carrier Resolution | [`compliances/phase-1.2-cost-carrier-resolution.md`](../../compliances/phase-1.2-cost-carrier-resolution.md) | P2-200, P2-320 |
| 1.3 Patient Matching & Insurance Changes | [`compliances/phase-1.3-patient-matching-insurance-changes.md`](../../compliances/phase-1.3-patient-matching-insurance-changes.md) | P2-320 |

### Compliance Mapping

#### 1.5 Schein Management
**Source**: [`compliances/phase-1.5-schein-management.md`](../../compliances/phase-1.5-schein-management.md)

**Related Requirements**:
- "When an insurance card is read for the first time in a quarter, the system must require the user to select the billing record type (Satzart 010x) or the Schein subgroup (Scheinuntergruppe)."
- "The system must allow creation of multiple 010x billing records per patient within the same quarter."
- "The system must implement rules governing the transition between billing quarters (Quartalsuebergang)."
- "Insurance changes (Kassenwechsel) occurring within a quarter must be detected and processed."
- "When an insurance change occurs within a quarter, the billing records must be split."
- "Immediately after reading a Card for Privately Insured, the system must display a notice. The data must not flow into KVDT billing routines."

#### 1.3 Patient Matching & Insurance Changes
**Source**: [`compliances/phase-1.3-patient-matching-insurance-changes.md`](../../compliances/phase-1.3-patient-matching-insurance-changes.md)

**Related Requirements**:
- "The system must assist the user in selecting the appropriate KTAB (KT-Abrechnungsbereich, FK 4106) based on the Besondere Personengruppe (special person group, FK 4131)."

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: create KV/BG Schein with quarter, year, treatment case | KP2-500: record type selection; P2-501: multiple records per quarter |
| AC4: field-level validation errors returned | KP2-562: referral fields validation |
| AC5: Schein overview for patient and insurance context | P2-501: multiple billing records per patient per quarter |
| AC6: MarkBill with contract and main group | P2-530: insurance change detection; P2-535: Schein splitting |
| AC7: KTAB values returned for VKNR, special group, quarter | P2-320: KTAB assignment based on Besondere Personengruppe |
| AC8: diagnosis takeover from prior Scheins | P2-521: open case carry-over rules |
| AC9: private Schein operations with GOA factor | P2-790: privately insured handling |
| AC10: SV Scheins created with contract linkage | KP2-950: pseudo-Behandlungsfaelle for selective contracts |
| AC11: Schein data updated reactively on events | P2-520: quarter transition handling |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
