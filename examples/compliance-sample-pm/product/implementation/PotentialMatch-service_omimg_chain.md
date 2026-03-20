# UnMatching: service_omimg_chain

## File
`backend-core/service/omimg_chain/`

## Analysis
- **What this code does**: Provides the OmimG chain service for managing custom OmimG (diagnosis code) chain templates. Supports creating, deleting, and searching OmimG chains with pagination. OmimG chains are reusable sequences of diagnosis codes used for common clinical patterns (text modules/shortcuts).
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

## Classification
- [x] E7=Clinical Documentation

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-OMIMG-CHAIN — OmimG Diagnosis Code Chain Templates

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-OMIMG-CHAIN |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E7=Clinical Documentation |
| **Data Entity** | OmimGChain, OmimGChainEntity |

### User Story
As a physician, I want to create and manage reusable diagnosis code chain templates (OmimG chains), so that I can quickly apply common sequences of diagnosis codes to patient encounters without re-entering them each time.

### Acceptance Criteria
1. Given a set of diagnosis codes, when I create an OmimG chain via `CreateOmimGChain` with a name and chain data, then the template is persisted and returned
2. Given an existing OmimG chain, when I update it via `UpdateOmimGChain`, then the name and chain data are modified
3. Given an existing OmimG chain, when I delete it via `DeleteOmimGChain`, then it is removed by ID
4. Given a search query, when I search via `SearchOmimGChain` with a name filter and pagination, then matching chains are returned with default page size of 10

### Technical Notes
- Source: `backend-core/service/omimg_chain/`
- Key functions: CreateOmimGChain, DeleteOmimGChain, SearchOmimGChain, UpdateOmimGChain
- Integration points: catalog_omimg_chain API, OmimGChainRepo (MongoDB)

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| Phase 2B.3 — Genetic Testing Documentation | [`compliances/phase-2B.3-genetic-testing-documentation.md`](../../compliances/phase-2B.3-genetic-testing-documentation.md) | KP2-612 through KP2-618 |

### Compliance Mapping

#### Phase 2B.3 — Genetic Testing Documentation (OMIM-G Service)
**Source**: [`compliances/phase-2B.3-genetic-testing-documentation.md`](../../compliances/phase-2B.3-genetic-testing-documentation.md)

**Related Requirements**:
- "The software must enable capture of the type of disease (FK 5079) for GOP 11233." (KP2-612)
- "The software must enable capture of the HGNC gene symbol (FK 5077) and type of disease (FK 5079) for GOPs 11511, 11512, 11516-11518, and 11521." (KP2-613)
- "The software must enable capture of type of disease per ICD-10-GM for GOPs 11302, 11303, 19402, and 32901-32918." (KP2-617)
- "The software must enable capture of type of disease per ICD-10-GM for the functions defined in KP2-615, KP2-616, and KP2-617." (KP2-618 — Panel/Exome Scope)

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Create an OmimG chain with name and chain data | KP2-618: Panel/exome scope documentation; grouped genetic diagnosis codes for efficient capture |
| AC2: Update OmimG chain name and data | KP2-615/KP2-616: Comprehensive genetic testing documentation |
| AC3: Delete OmimG chain by ID | User-managed chain templates |
| AC4: Search OmimG chains with name filter and pagination | KP2-612/KP2-617: Disease type capture for genetic testing GOPs |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
