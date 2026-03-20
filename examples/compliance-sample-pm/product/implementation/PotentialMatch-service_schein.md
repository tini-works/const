# UnMatching: service_schein

## File
`backend-core/service/schein/`

## Analysis
- **What this code does**: Provides the core Schein (treatment case) business logic service. Handles Schein creation, update, deletion, and validation for KV, BG (occupational injury), and private billing cases. Integrates with patient profiles, contract management, billing services (KV, BG, private), EDMP, catalog services (SDKT, SDIK, GOA), psychotherapy tracking, and patient participation. Includes field validation, treatment case subgroup management, and billing area determination. This is one of the most central domain services.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

## Classification
- [x] E1=Billing Documentation

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-SCHEIN — Treatment Case (Schein) Lifecycle Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-SCHEIN |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E1=Billing Documentation |
| **Data Entity** | Schein (KV, BG, Private), PatientSnapshot, CaseFields |

### User Story
As a physician, I want to create, validate, and manage treatment cases (Scheins) for KV, BG (occupational injury), and private billing types, so that patient encounters are properly documented with correct billing areas, contract associations, and diagnosis takeover for quarterly billing.

### Acceptance Criteria
1. Given a patient and contract, when I call `CreateSchein`, then a treatment case is created with field validation, billing area determination, and patient snapshot
2. Given a BG case, when I call `CreateBgSchein`, then the schein is validated for occupational injury requirements including employment info
3. Given selective contract participation, when I call `CreateSvScheins`, then SV scheins are created for HZV/FAV contracts with excluded contract filtering
4. Given a schein, when I call `IsValid` or `IsValidBgSchein`, then field-level validation is performed against JSON-defined case field rules
5. Given diagnosis codes, when I call `TakeOverDiagnosisByScheinId`, then diagnoses are transferred from one schein to another
6. Given a schein update, when the `OnUpdate` hook fires, then dependent services are notified of the change
7. Given KTABs (Kassentechnische Arbeitsblatt), when I call `GetKTABs`, then treatment case summary data is returned
8. Given a billing mark request, when I call `MarkBill`, then the schein billing status is updated

### Technical Notes
- Source: `backend-core/service/schein/`
- Key functions: CreateSchein, CreateBgSchein, CreateSvScheins, UpdateBgSchein, DeleteBgSchein, IsValid, TakeOverDiagnosisByScheinId, MarkBill, GetKTABs
- Integration points: patient_profile, contract service, billing services (KV, BG, private), EDMP, SDKV, catalog services (SDKT, SDIK, GOA), timeline_service, rezidiv, feature_flag, WebSocket notifications

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 1.5 Schein Management | [`compliances/phase-1.5-schein-management.md`](../../compliances/phase-1.5-schein-management.md) | KP2-500 through P2-790, KP2-950 |
| 7.1 System Integrity & Date Controls | [`compliances/phase-7.1-system-integrity-date-controls.md`](../../compliances/phase-7.1-system-integrity-date-controls.md) | P2-10 |

### Compliance Mapping

#### 1.5 Schein Management
**Source**: [`compliances/phase-1.5-schein-management.md`](../../compliances/phase-1.5-schein-management.md)

**Related Requirements**:
- "When an insurance card is read for the first time in a quarter, the system must require the user to select the billing record type (Satzart 010x) or the Schein subgroup (Scheinuntergruppe)." (KP2-500)
- "The system must allow creation of multiple 010x billing records per patient within the same quarter." (P2-501)
- "The system must implement rules governing the transition between billing quarters (Quartalsuebergang)." (P2-520)
- "Open billing cases must be carried forward according to defined transition rules when a new quarter begins." (P2-521)
- "Insurance changes (Kassenwechsel) occurring within a quarter must be detected and processed." (P2-530)
- "When an insurance change occurs within a quarter, the billing records must be split." (P2-535)
- "Immediately after reading a Card for Privately Insured, the system must display a notice. The data must not flow into KVDT billing routines." (P2-790)
- "The software must support capturing and transmitting pseudo-treatment cases using GOP 88194 for selective contract and Knappschaft billing cases involving non-physician practice assistants (NaePa)." (KP2-950)

#### 7.1 System Integrity & Date Controls
**Source**: [`compliances/phase-7.1-system-integrity-date-controls.md`](../../compliances/phase-7.1-system-integrity-date-controls.md)

**Related Requirements**:
- "The billing software user interface must enable complete and correct entry of all billing-relevant master data and transaction data as described in the dataset specifications." (P2-10)

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Given a patient and contract, when I call CreateSchein, then a treatment case is created with field validation, billing area determination, and patient snapshot | KP2-500: "the system must require the user to select the billing record type (Satzart 010x) or the Schein subgroup" and P2-501: "allow creation of multiple 010x billing records per patient within the same quarter" |
| AC3: Given selective contract participation, when I call CreateSvScheins, then SV scheins are created for HZV/FAV contracts | KP2-950: "support capturing and transmitting pseudo-treatment cases using GOP 88194 for selective contract and Knappschaft billing cases" |
| AC4: Given a schein, when I call IsValid, then field-level validation is performed | P2-10: "enable complete and correct entry of all billing-relevant master data and transaction data" |
| AC7: Given KTABs, when I call GetKTABs, then treatment case summary data is returned | P2-520/P2-521: Quarter transition handling and open case carry-over rules |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
