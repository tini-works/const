# UnMatching: catalog_sdav

## File
`backend-core/app/app-core/api/catalog_sdav/`

## Analysis
- **What this code does**: Manages the SDAV (Stammdatei Aerzte-Verzeichnis) catalog, which is the German physician directory/master data. Provides full CRUD operations (get, get by ID/IDs, create, edit, delete) with search and pagination, plus management of area-of-expertise entries. This is a user-facing reference data catalog for physician information lookup.
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

## US-PROPOSED-CATALOG_SDAV — Physician Directory (SDAV) Catalog Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-CATALOG_SDAV |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5 — Practice Core |
| **Data Entity** | SdavCatalog, AreaOfExpertiseItem |

### User Story
As a practice administrator, I want to manage the physician directory (Stammdatei Aerzte-Verzeichnis) catalog with full CRUD operations and area-of-expertise entries, so that referring physician information is available for referrals, letters, and billing.

### Acceptance Criteria
1. Given an authenticated user, when they search for SDAV entries with query, filter, search type, and pagination, then matching physician records are returned with total count.
2. Given an authenticated user, when they retrieve an SDAV entry by ID or multiple IDs, then the corresponding physician records are returned.
3. Given an authenticated user, when they create a new SDAV entry, then the physician record is persisted and returned.
4. Given an authenticated user, when they edit an existing SDAV entry, then the record is updated and returned.
5. Given an authenticated user, when they delete an SDAV entry by ID, then the record is removed.
6. Given an authenticated user, when they list area-of-expertise entries, then all available specializations are returned.
7. Given an authenticated user, when they create a new area of expertise by name, then the entry is added to the catalog.

### Technical Notes
- Source: `backend-core/app/app-core/api/catalog_sdav/`
- Key functions: GetSdav, GetSdavById, GetSdavByIds, CreateSdav, EditSdav, DeleteSdav, GetAreaOfExpertises, CreateAreaOfExpertise
- Integration points: `service/domains/api/catalog_sdav_common` (SdavCatalog, SdavSearchType), `service/domains/api/common` (pagination)

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| Phase 7.4 — KBV Master Data Files (SDAV) | [`compliances/phase-7.4-kbv-master-data-files.md`](../../compliances/phase-7.4-kbv-master-data-files.md) | P6-200 |

### Compliance Mapping

#### Phase 7.4 — KBV Master Data Files (SDAV Physician Directory)
**Source**: [`compliances/phase-7.4-kbv-master-data-files.md`](../../compliances/phase-7.4-kbv-master-data-files.md)

**Related Requirements**:
- "Mandatory deployment of the SDAV physician directory — the physician directory master data file must be available for laboratory referral cases (Muster 10/10A)." (P6-200)

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Search for SDAV entries with query, filter, search type, and pagination | P6-200: SDAV physician directory must be deployed and available |
| AC2: Retrieve an SDAV entry by ID or multiple IDs | P6-200: Physician directory must be available for referral cases |
| AC3: Create a new SDAV entry | P6-200: Physician directory maintenance for referral workflows |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
