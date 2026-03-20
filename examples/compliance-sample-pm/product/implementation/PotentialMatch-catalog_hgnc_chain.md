# UnMatching: catalog_hgnc_chain

## File
`backend-core/app/app-core/api/catalog_hgnc_chain/`

## Analysis
- **What this code does**: Provides an HGNC (treatment chain / Heilmittelgruppen-Nachweiskette) catalog management service (HgncChainApp). Supports searching, creating, updating, and deleting HGNC chains, which group related HGNC items (remedy/therapy items) into named chains. Used by practitioners to manage predefined treatment sequences for therapy prescriptions.
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

## US-PROPOSED-CATALOG_HGNC_CHAIN — HGNC Treatment Chain Catalog Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-CATALOG_HGNC_CHAIN |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E6 — Medication |
| **Data Entity** | HgncChain, HgncItem |

### User Story
As a medical practitioner, I want to manage predefined treatment chains (Heilmittelgruppen-Nachweiskette) that group related therapy/remedy items into named sequences, so that I can quickly select standardized treatment combinations when prescribing therapies.

### Acceptance Criteria
1. Given an authenticated care provider member, when they search for HGNC chains by name with pagination, then matching chains are returned with their associated HGNC items.
2. Given an authenticated care provider member, when they create a new HGNC chain with a name and list of HGNC items, then the chain is persisted and returned with its generated ID.
3. Given an existing HGNC chain, when the user updates its name or HGNC items, then the chain is modified and the updated version is returned.
4. Given an existing HGNC chain, when the user deletes it by ID, then the chain is removed from the catalog.

### Technical Notes
- Source: `backend-core/app/app-core/api/catalog_hgnc_chain/`
- Key functions: SearchHgncChain, CreateHgncChain, UpdateHgncChain, DeleteHgncChain
- Integration points: `service/domains/hgnc/common` (HgncItem), `service/domains/api/common` (pagination)

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| Phase 4.3 — Heilmittel (Therapeutic Remedies) | [`compliances/phase-4.3-heilmittel-therapeutic-remedies.md`](../../compliances/phase-4.3-heilmittel-therapeutic-remedies.md) | Therapeutic Remedy Prescriptions |
| Heilmittel P2-01 — Mandatory Use of Remedies Master Data | [`product/compliances/Heilmittel/P2-01.md`](../compliances/Heilmittel/P2-01.md) | Section 2.1 |
| Heilmittel P3-19 — Remedy as per Catalog | [`product/compliances/Heilmittel/P3-19.md`](../compliances/Heilmittel/P3-19.md) | Section 3.2 |

### Compliance Mapping

#### Phase 4.3 — Heilmittel (Therapeutic Remedies)
**Source**: [`compliances/phase-4.3-heilmittel-therapeutic-remedies.md`](../../compliances/phase-4.3-heilmittel-therapeutic-remedies.md)

**Related Requirements**:
- "Prescriptions must comply with the Heilmittel-Richtlinie and reference the Heilmittelkatalog for valid diagnosis-remedy combinations."
- "Per-diagnosis quantity limits (Verordnungsmenge je Diagnosegruppe)"

#### Heilmittel P2-01 — Mandatory Use of Remedies Master Data
**Source**: [`product/compliances/Heilmittel/P2-01.md`](../compliances/Heilmittel/P2-01.md)

**Related Requirements**:
- "The data of the valid remedies master data file must be stored in the software for use. The data records of the remedies master data file must not be modified in content."
- "The remedies master data file from KBV must be integrated into the software and used in the currently valid version."

#### Heilmittel P3-19 — Remedy as per Catalog
**Source**: [`product/compliances/Heilmittel/P3-19.md`](../compliances/Heilmittel/P3-19.md)

**Related Requirements**:
- "The user must be given the ability to select remedies according to the Remedy Master Data File for populating the 'Remedy as per Catalog' field."
- "The selection of available remedies must be restricted according to the selected diagnosis group in line with the Remedy Master Data File."

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Search for HGNC chains by name with pagination | P3-19: User must be able to select remedies according to the Remedy Master Data File |
| AC2: Create a new HGNC chain with name and list of HGNC items | P2-01: Remedies master data must be stored in software for use; chains reference catalog items |
| AC3: Update HGNC chain name or items | P3-19: Selection restricted according to diagnosis group per Remedy Master Data File |
| AC4: Delete HGNC chain by ID | User-managed chains (not official master data records) |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
