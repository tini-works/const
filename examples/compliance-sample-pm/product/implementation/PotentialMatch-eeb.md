# UnMatching: eeb

## File
`backend-core/app/app-core/api/eeb/`

## Analysis
- **What this code does**: Manages EEB (Elektronische Ersatzbescheinigung / Electronic Replacement Certificate) workflows. Provides functionality to sign and send EEB requests, retrieve insurance provider lists, and get EEB data. This is part of the German healthcare telematics infrastructure for electronically verifying patient insurance coverage when the eGK (electronic health card) is unavailable.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-EEB — Electronic Replacement Certificate (EEB) Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-EEB |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E8=Integration Services |
| **Data Entity** | EEB, Insurance, Patient |

### User Story
As a medical practice staff member, I want to electronically verify patient insurance coverage via EEB (Elektronische Ersatzbescheinigung) when the patient's eGK card is unavailable, so that I can still process the patient visit with valid insurance confirmation.

### Acceptance Criteria
1. Given an authenticated care provider member, when they submit an EEB sign-and-send request, then the system signs the request and sends it to the telematics infrastructure
2. Given an authenticated care provider member, when they request the list of insurances supporting EEB, then the system returns the available insurance providers
3. Given an authenticated care provider member with a valid EEB request ID, when they retrieve EEB data, then the system returns the electronic replacement certificate details

### Technical Notes
- Source: `backend-core/app/app-core/api/eeb/`
- Key functions: SignAndSend, GetInsurances, GetEEB
- Integration points: `backend-core/service/domains/api/eeb` (domain service), telematics infrastructure

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 1.4 Manual Entry / Ersatzverfahren | [`compliances/phase-1.4-manual-entry-ersatzverfahren.md`](../../compliances/phase-1.4-manual-entry-ersatzverfahren.md) | KP2-404, KP2-405 |

### Compliance Mapping

#### 1.4 Manual Entry / Ersatzverfahren
**Source**: [`compliances/phase-1.4-manual-entry-ersatzverfahren.md`](../../compliances/phase-1.4-manual-entry-ersatzverfahren.md)

**Related Requirements**:
- "The software must enable receiving an electronic replacement confirmation (eEB — elektronische Ersatzbestaetigung) via KIM. This allows practices to receive insurance coverage confirmation electronically when a patient's card is unavailable."
- "Upon receiving an eEB, the software must set FK 4112 = 1 as the billing marker, indicating that coverage was confirmed via the electronic replacement procedure rather than a physical card read."

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: sign-and-send EEB request to telematics infrastructure | KP2-404: enable receiving eEB via KIM |
| AC2: request list of insurances supporting EEB | KP2-404: receive insurance coverage confirmation electronically |
| AC3: retrieve EEB data (electronic replacement certificate details) | KP2-405: set FK 4112 = 1 as billing marker upon receiving eEB |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
