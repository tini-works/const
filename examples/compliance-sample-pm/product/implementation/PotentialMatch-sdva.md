# UnMatching: sdva

## File
`backend-core/app/app-core/api/sdva/`

## Analysis
- **What this code does**: Provides an API for querying SDVA (Stammdatei Vertragsaerzte - contracted physician master data) catalog data. Exposes endpoints to get SDVA chapters by date and by specific code. Used for looking up physician qualification/specialization data from the KBV master data catalog.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [ ] Create new User Story for this functionality
- [x] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-SDVA — SDVA Contracted Physician Master Data Lookup

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-SDVA |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5 Practice Software Core |
| **Data Entity** | Chapter (SDVA catalog) |

### User Story
As a system component, I want to query the SDVA (contracted physician master data) catalog by date and by specific code, so that physician qualification and specialization data from KBV master data is available for validation and display.

### Acceptance Criteria
1. Given a selected date, when GetSdva is called, then the SDVA chapters valid for that date are returned
2. Given a selected date and a specific code, when GetSdvaByCode is called, then the SDVA chapters matching that code and date are returned

### Technical Notes
- Source: `backend-core/app/app-core/api/sdva/`
- Key functions: GetSdva, GetSdvaByCode
- Integration points: `service/domains/sdva/common` (Chapter)
- Both endpoints require CARE_PROVIDER_MEMBER role
- Classified as infrastructure/utility code supporting physician qualification lookups

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| Phase 2A.4 — SDVA Coding Instructions | [`compliances/phase-2A.4-sdva-coding-instructions.md`](../../compliances/phase-2A.4-sdva-coding-instructions.md) | P11-700 through P11-760 |

### Compliance Mapping

#### Phase 2A.4 — SDVA Coding Instructions
**Source**: [`compliances/phase-2A.4-sdva-coding-instructions.md`](../../compliances/phase-2A.4-sdva-coding-instructions.md)

**Related Requirements**:
- "The PVS must use the coding instruction master data file (SDVA — Verschluesselungsanleitung) provided by the KBV and make it accessible to the user." (P11-700)
- "At the start of each year, the currently valid SDVA version must be deployed." (P11-710)
- "The contents of the SDVA must not be modified." (P11-720)
- "The PVS must be able to display the relevant coding instruction (Verschluesselungsanleitung) for a specific ICD-10-GM code in context." (P11-740)
- "The PVS must provide a full browse/reference mode for the complete coding instructions document (SDVA)." (P11-750)
- "The PVS must make annual changes to the coding instructions visible." (P11-760)

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Given a selected date, when GetSdva is called, then the SDVA chapters valid for that date are returned | P11-700: Must make SDVA accessible to user; P11-750: Full browse mode for coding instructions |
| AC2: Given a selected date and a specific code, when GetSdvaByCode is called, then the SDVA chapters matching that code and date are returned | P11-740: Context-sensitive display of coding instruction for a specific ICD-10-GM code |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
