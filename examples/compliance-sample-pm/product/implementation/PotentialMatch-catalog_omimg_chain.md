# UnMatching: catalog_omimg_chain

## File
`backend-core/app/app-core/api/catalog_omimg_chain/`

## Analysis
- **What this code does**: Manages OMIM-G (Online Mendelian Inheritance in Man - German) diagnosis chain catalogs. Provides CRUD operations (search, create, update, delete) for named chains of OMIM-G diagnosis codes, which are used to group related genetic/hereditary disease diagnoses in clinical documentation.
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

## US-PROPOSED-CATALOG_OMIMG_CHAIN — OMIM-G Diagnosis Chain Catalog Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-CATALOG_OMIMG_CHAIN |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E7 — Clinical Documentation |
| **Data Entity** | OmimGChain, OmimG |

### User Story
As a medical practitioner, I want to manage named chains of OMIM-G (genetic/hereditary disease) diagnosis codes, so that I can quickly apply grouped genetic diagnosis combinations during clinical documentation.

### Acceptance Criteria
1. Given an authenticated care provider member, when they search for OMIM-G chains by name with pagination, then matching chains are returned with their diagnosis codes.
2. Given an authenticated care provider member, when they create a new OMIM-G chain with a name and list of OMIM-G codes, then the chain is persisted and returned.
3. Given an existing OMIM-G chain, when the user updates its name or diagnosis codes, then the chain is modified accordingly.
4. Given an existing OMIM-G chain, when the user deletes it by ID, then the chain is removed from the catalog.

### Technical Notes
- Source: `backend-core/app/app-core/api/catalog_omimg_chain/`
- Key functions: SearchOmimGChain, CreateOmimGChain, UpdateOmimGChain, DeleteOmimGChain
- Integration points: `service/domains/api/schein_common` (OmimG), `service/domains/api/common` (pagination)

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| Phase 2B.3 — Genetic Testing Documentation | [`compliances/phase-2B.3-genetic-testing-documentation.md`](../../compliances/phase-2B.3-genetic-testing-documentation.md) | KP2-612 through KP2-618 |

### Compliance Mapping

#### Phase 2B.3 — Genetic Testing Documentation (OMIM)
**Source**: [`compliances/phase-2B.3-genetic-testing-documentation.md`](../../compliances/phase-2B.3-genetic-testing-documentation.md)

**Related Requirements**:
- "The software must enable capture of the type of disease (FK 5079) for GOP 11233." (KP2-612)
- "The software must enable capture of the HGNC gene symbol (FK 5077) and type of disease (FK 5079) for GOPs 11511, 11512, 11516-11518, and 11521." (KP2-613)
- "The software must enable capture of HGNC gene symbol, type of disease, and ICD-10-GM code for GOPs 19424, 19453, and 19456." (KP2-615)
- "The software must enable capture of type of disease per ICD-10-GM for GOPs 11302, 11303, 19402, and 32901-32918." (KP2-617)
- "The software must enable capture of type of disease per ICD-10-GM for the functions defined in KP2-615, KP2-616, and KP2-617." (KP2-618 — Panel/Exome Scope)

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Search for OMIM-G chains by name with pagination | KP2-612/KP2-617: Capture of disease type per ICD-10-GM for genetic testing GOPs |
| AC2: Create a new OMIM-G chain with name and OMIM-G codes | KP2-618: Panel/exome scope documentation requires grouped genetic diagnosis codes |
| AC3: Update OMIM-G chain name or diagnosis codes | KP2-615/KP2-616: Genetic testing requires HGNC gene symbol, disease type, and ICD code |
| AC4: Delete OMIM-G chain by ID | User-managed chains for efficient genetic documentation workflows |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
