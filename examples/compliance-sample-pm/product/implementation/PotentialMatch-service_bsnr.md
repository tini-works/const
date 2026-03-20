# UnMatching: service_bsnr

## File
`backend-core/service/bsnr/`

## Analysis
- **What this code does**: Provides the BSNR (Betriebsstaettennummer - Practice Location Number) service for managing practice location data. Supports lookup by ID, code, or multiple codes, phone number updates, and checking whether a BSNR has associated HZV/FAV contract doctors. Used as a foundational service by many other modules.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [ ] Create new User Story for this functionality
- [x] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

## Classification
- [x] This is infrastructure/utility code (no story needed)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-BSNR — Practice Location (BSNR) Management and HZV/FAV Contract Doctor Verification

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-BSNR |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5=Practice Software Core |
| **Data Entity** | BSNR, EmployeeProfile, TiComponent, HpmConfig |

### User Story
As a practice administrator, I want to manage practice location (BSNR) data including lookups, employee associations, TI component status, and HPM configuration, so that the practice locations are correctly configured for billing and contract operations.

### Acceptance Criteria
1. Given a BSNR code, when looked up, then the corresponding practice location entity is returned with all associated data
2. Given a practice location, when checking for contract doctors, then the system correctly identifies whether HZV and/or FAV contract doctors are associated
3. Given a BSNR with employees, when GetBSNRWithEmployee is called, then billing doctors are resolved with their employee profiles and filtered by active status if requested
4. Given a BSNR entity, when TI components are updated, then SMCB, EHBA, KIM, and Kartenterminal states are persisted
5. Given a doctor ID, when HPM config is requested, then the HPM endpoint configuration for the doctor's associated BSNR is returned
6. Given a BSNR ID, when deactivation is requested, then the BSNR is marked as deactivated

### Technical Notes
- Source: `backend-core/service/bsnr/`
- Key functions: GetById, FindByCode, GetByCodes, GetByIds, CheckBsnrHasContractDoctor, GetBSNRWithEmployee, GetListBSNR, UpdateTiComponents, SelectCurrentTiComponentOnDetect, GetHpmConfig, GetHpmConfigByDoctorId, DeactivateBSNR, UpdateTelephoneNumberById
- Integration points: bsnr_repo (MongoDB), employee profile service, bsnr_common models

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 7.2 User & Practice Administration | [`compliances/phase-7.2-user-practice-administration.md`](../../compliances/phase-7.2-user-practice-administration.md) | P2-52, P2-70, P2-71 |
| 7.6 HZV/FAV Contract Infrastructure | [`compliances/phase-7.6-hzv-fav-contract-infrastructure.md`](../../compliances/phase-7.6-hzv-fav-contract-infrastructure.md) | [ALLG1014](../compliances/SV/ALLG1014.md) |

### Compliance Mapping

#### 7.2 User & Practice Administration
**Source**: [`compliances/phase-7.2-user-practice-administration.md`](../../compliances/phase-7.2-user-practice-administration.md)

**Related Requirements**:
- "A PVS must manage all physicians active at each practice location (identified by BSNR — Betriebsstättennummer), including their LANR, and transmit this information in the besa dataset as part of the KV billing process."
- "The software must ensure that each (N)BSNR appears only once in the besa dataset within the ADT, SADT, and KADT billing submissions."
- "The software must ensure that each LANR is transmitted only once per (N)BSNR in the ADT, SADT, and KADT billing datasets."

#### 7.6 HZV/FAV Contract Infrastructure
**Source**: [`compliances/phase-7.6-hzv-fav-contract-infrastructure.md`](../../compliances/phase-7.6-hzv-fav-contract-infrastructure.md)

**Related Requirements**:
- "During the initial setup (activation) of a contract for a physician, the user must first be shown only those contracts that meet the following conditions: 1. The contract is valid for the KV region of the practice (verified using the practice's BSNR)"

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Given a BSNR code, when looked up, then the corresponding practice location entity is returned | P2-52: manage all physicians active at each practice location (identified by BSNR) |
| AC2: Given a practice location, when checking for contract doctors, then the system correctly identifies whether HZV/FAV contract doctors are associated | [ALLG1014](../compliances/SV/ALLG1014.md): contract valid for KV region of the practice (verified using the practice's BSNR) |
| AC3: Given a BSNR with employees, when GetBSNRWithEmployee is called, then billing doctors are resolved | P2-52: manage all physicians active at each practice location, including their LANR |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
