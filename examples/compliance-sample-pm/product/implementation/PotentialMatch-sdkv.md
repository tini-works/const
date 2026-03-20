# UnMatching: sdkv

## File
`backend-core/app/app-core/api/sdkv/`

## Analysis
- **What this code does**: Provides an API for querying SDKV (Stammdatei KV - KV master data) pseudo-GNR requirements. Exposes a single endpoint GetPseudoGnrIsRequired that checks whether pseudo-GNR codes are required for a given BSNR. Used for billing validation against KV rules.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [ ] Create new User Story for this functionality
- [x] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-SDKV — SDKV Pseudo-GNR Requirement Lookup

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-SDKV |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E1 Billing Documentation |
| **Data Entity** | PseudoGNR |

### User Story
As a billing system component, I want to query whether pseudo-GNR codes are required for a given BSNR from the SDKV (KV master data), so that billing validation can enforce correct pseudo-GNR usage per KV rules.

### Acceptance Criteria
1. Given a BSNR, when GetPseudoGnrIsRequired is called, then the list of pseudo-GNR requirements for that BSNR is returned from the SDKV catalog

### Technical Notes
- Source: `backend-core/app/app-core/api/sdkv/`
- Key functions: GetPseudoGnrIsRequired
- Integration points: `service/domains/api/sdkv` (PseudoGNR)
- Single endpoint, requires CARE_PROVIDER_MEMBER role
- Classified as infrastructure/utility code supporting billing validation

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| Phase 7.4 — KBV Master Data Files (SDKV) | [`compliances/phase-7.4-kbv-master-data-files.md`](../../compliances/phase-7.4-kbv-master-data-files.md) | P6-100, P6-110, P6-130, P6-145 |

### Compliance Mapping

#### Phase 7.4 — KBV Master Data Files (SDKV Regional)
**Source**: [`compliances/phase-7.4-kbv-master-data-files.md`](../../compliances/phase-7.4-kbv-master-data-files.md)

**Related Requirements**:
- "Mandatory deployment of the KV-specific master data file — the current SDKV must be available in time for the start of each quarter." (P6-100)
- "The existing records in the KV-specific master data file must not be modified by the user." (P6-110)
- "Only those data packages listed under fields FK 9135 and FK 9138 may be stored in a KVDT file." (P6-130)
- "Only the encounter sub-groups (Scheinuntergruppen) listed under FK 4239 of record type kvx2 and the billing areas listed under FK 4122 may be used." (P6-145)

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Given a BSNR, when GetPseudoGnrIsRequired is called, then the list of pseudo-GNR requirements for that BSNR is returned from the SDKV catalog | P6-100: SDKV must be deployed and current; P6-130/P6-145: Regional rules enforcement per KV |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
