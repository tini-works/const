# UnMatching: catalog_sdkt

## File
`backend-core/app/app-core/api/catalog_sdkt/`

## Analysis
- **What this code does**: Manages the SDKT (Stammdatei Kostentraeger) catalog, which is the German cost unit/payer directory. Provides CRUD operations, search by VKNR (Vertragskassennummer) and IK numbers, input validation for create/edit, cost unit company deduplication, and catalog termination with billable quarter tracking. This is a core reference data catalog for insurance payer information.
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

## US-PROPOSED-CATALOG_SDKT — Cost Unit (SDKT) Catalog Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-CATALOG_SDKT |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E1 — Billing |
| **Data Entity** | SdktCatalog, IkNumber |

### User Story
As a practice administrator, I want to manage the cost unit/payer directory (Stammdatei Kostentraeger) with VKNR and IK number lookups, input validation, company deduplication, and termination tracking, so that insurance payer information is accurate for billing and claims processing.

### Acceptance Criteria
1. Given an authenticated user, when they search for SDKT entries with text, date, and pagination, then matching cost unit records are returned with total count.
2. Given an authenticated user, when they create a new SDKT entry, then the record is persisted after input validation.
3. Given an authenticated user, when they update an existing SDKT entry, then the record is modified after edit validation.
4. Given an authenticated user, when they validate create or edit input, then field-level validation errors are returned if applicable.
5. Given an authenticated user, when they search by VKNR with a selected date, then the matching cost unit is returned.
6. Given an authenticated user, when they search by IK number, then the corresponding cost unit is returned.
7. Given an authenticated user, when they request company deduplication for a cost unit, then unique company data and IK numbers are returned.
8. Given an authenticated user, when they terminate an SDKT catalog entry with termination date and last billable quarter/year, then the entry is marked as terminated.

### Technical Notes
- Source: `backend-core/app/app-core/api/catalog_sdkt/`
- Key functions: CreateSdktCatalogItem, UpdateSdktCatalogItem, ValidateCreateInput, ValidateEditInput, GetSdktCatalogByVknr, GetSdktCatalog, SearchSdkt, SearchSdktByIKNumber, UniqCompanyByAccquiredCostUnit, TerminateSdktCatalog
- Integration points: `service/domains/api/catalog_sdkt_common` (SdktCatalog, IkNumber, SearchType), `service/domains/api/common` (pagination, FieldError)

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| Phase 7.4 — KBV Master Data Files (SDKT) | [`compliances/phase-7.4-kbv-master-data-files.md`](../../compliances/phase-7.4-kbv-master-data-files.md) | P6-20, P6-40, P6-45, K6-46, P6-51 |

### Compliance Mapping

#### Phase 7.4 — KBV Master Data Files (SDKT Cost Carriers)
**Source**: [`compliances/phase-7.4-kbv-master-data-files.md`](../../compliances/phase-7.4-kbv-master-data-files.md)

**Related Requirements**:
- "The currently valid cost carrier master data file (KT-Stammdatei) must be deployed in connection with the quarterly billing and the printing of statutory physician forms." (P6-20)
- "Certain fields of the cost carrier master record have official (authoritative) character and must not be modified by the user." (P6-40)
- "The cost carrier master data file may be temporarily extended — new cost carriers may be added as temporary master records." (P6-45)
- "Optional: The software vendor may provide temporary extensions to the cost carrier master data file." (K6-46)
- "The software must ensure that the cost carrier with VKNR 74799 (gematik test payer) is not transmitted to the KV associations." (P6-51)

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Search for SDKT entries with text, date, and pagination | P6-20: SDKT must be deployed and current for billing |
| AC2: Create a new SDKT entry | P6-45: Temporary extension with new cost carriers allowed |
| AC3: Update an existing SDKT entry | P6-40: Official fields must not be modified by user |
| AC4: Validate create or edit input | P6-40: Official field protection enforcement |
| AC5: Search by VKNR with selected date | P6-20: Current SDKT must be available; P6-51: VKNR 74799 filtering |
| AC6: Search by IK number | P6-20: Cost carrier lookup from authoritative data |
| AC8: Terminate an SDKT catalog entry | P6-45: Temporary records reconciliation on next SDKT release |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
