# UnMatching: service_contracts

## File
`backend-core/service/contracts/`

## Analysis
- **What this code does**: Provides a contracts metadata repository that reads contract overview data from an embedded CSV file (_Vertragsberblick.csv). Parses contract metadata for selective healthcare contracts and provides it to other services. Acts as a static data source for contract definitions.
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

## US-PROPOSED-CONTRACTS — Selective Healthcare Contract Metadata Repository

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-CONTRACTS |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E2=Contract Management |
| **Data Entity** | ContractMetadata, Contract, ChargeSystem, EnrolmentTypeOption |

### User Story
As a system component, I want to load and provide selective healthcare contract metadata from an embedded CSV file, so that contract definitions (HZV, FAV, KV, module contracts) with their charge systems, regions, registration periods, and enrollment type options are available to all dependent services.

### Acceptance Criteria
1. Given the application starts, when the contracts repository initializes, then the embedded _Vertragsberblick.csv is parsed and contract metadata is cached
2. Given a contract ID, when GetContractById is called, then the full contract detail including charge systems and software functions is returned
3. Given the contract list, when GetContractsMetaData is called, then all contracts are returned with their type (HZV/FAV/KV/module), region, charge systems, module charge systems, and enrollment type options
4. Given a module contract (Modulvertrag), when parsed, then its charge systems are resolved from the parent contract (AWH_01) module charge systems
5. Given a contract with software functions, when enrollment type options are derived, then the correct enrollment type options are computed from the function list

### Technical Notes
- Source: `backend-core/service/contracts/`
- Key functions: NewContractsRepo, GetContractsMetaData, GetContractById, getContractsMetaData (CSV parsing), getContractTypeFunc
- Integration points: contract_service (contract detail lookup), enrollment_common (enrollment type options), embedded CSV data file (_Vertragsberblick.csv)

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 7.6 HZV/FAV Contract Infrastructure | [`compliances/phase-7.6-hzv-fav-contract-infrastructure.md`](../../compliances/phase-7.6-hzv-fav-contract-infrastructure.md) | [ALLG864](../compliances/SV/ALLG864.md), [ALLG1014](../compliances/SV/ALLG1014.md), [ALLG1003](../compliances/SV/ALLG1003.md), [ALLG661](../compliances/SV/ALLG661.md) |

### Compliance Mapping

#### 7.6 HZV/FAV Contract Infrastructure
**Source**: [`compliances/phase-7.6-hzv-fav-contract-infrastructure.md`](../../compliances/phase-7.6-hzv-fav-contract-infrastructure.md)

**Related Requirements**:
- "The contract software must manage the contract-controlling information contained in the contract-specific selective contract definition, specifically the elements `<metainformationen>` and `<dokumentationstypen>`."
- "During the initial setup (activation) of a contract for a physician, the user must first be shown only those contracts that meet the following conditions: 1. The contract is valid for the KV region of the practice (verified using the practice's BSNR) 2. The contract is listed in the contract overview appendices and has not ended at the time of display"
- "The contract software must manage the fee schedule appendix/appendices (Honoraranlage) according to the respective selective contract definition in the appendices."
- "The contract software must manage each HÄVG contract internally with a unique contract ID."

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Given the application starts, when the contracts repository initializes, then the embedded CSV is parsed and contract metadata is cached | [ALLG864](../compliances/SV/ALLG864.md): manage the contract-controlling information contained in the contract-specific selective contract definition |
| AC2: Given a contract ID, when GetContractById is called, then the full contract detail is returned | [ALLG661](../compliances/SV/ALLG661.md): manage each HÄVG contract internally with a unique contract ID |
| AC3: Given the contract list, when GetContractsMetaData is called, then all contracts are returned with type, region, charge systems | [ALLG1014](../compliances/SV/ALLG1014.md): show only those contracts valid for the KV region; [ALLG1003](../compliances/SV/ALLG1003.md): manage fee schedule appendices |
| AC4: Given a module contract, when parsed, then its charge systems are resolved from the parent contract | [ALLG1003](../compliances/SV/ALLG1003.md): each individual service is assigned to exactly one fee schedule appendix |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
