# UnMatching: service_rezidiv

## File
`backend-core/service/rezidiv/`

## Analysis
- **What this code does**: Provides a repository for KBV Rezidiv (recurrence) coding table data. Parses an embedded CSV file (KBV_ITA_AHEX_Codierungstabelle_PT_Rezidiv.csv) containing psychotherapy recurrence codes and their descriptions. Exposes a simple lookup for all Rezidiv codes used in psychotherapy documentation.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [ ] Create new User Story for this functionality
- [x] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

## Classification
- [x] E7=Clinical Documentation

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-REZIDIV — KBV Psychotherapy Recurrence Code Lookup

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-REZIDIV |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E7=Clinical Documentation |
| **Data Entity** | Rezidiv (Code, Content) |

### User Story
As a psychotherapist, I want to look up KBV-defined psychotherapy recurrence (Rezidiv) codes and their descriptions, so that I can accurately document recurrence information in psychotherapy treatment cases.

### Acceptance Criteria
1. Given the embedded KBV coding table CSV, when the service initializes, then all Rezidiv codes and descriptions are parsed and loaded into memory
2. Given a request for Rezidiv codes, when `GetAllRezidivList` is called, then the complete list of codes with their descriptions is returned
3. Given the CSV format with "Code;Content" rows, when parsing, then the header row is skipped and trailing whitespace is cleaned

### Technical Notes
- Source: `backend-core/service/rezidiv/`
- Key functions: GetAllRezidivList, newRezidivRepo (CSV parser)
- Integration points: Embedded CSV (KBV_ITA_AHEX_Codierungstabelle_PT_Rezidiv.csv), used by schein service for psychotherapy documentation

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 2B.5 Psychotherapy Documentation | [`compliances/phase-2B.5-psychotherapy-documentation.md`](../../compliances/phase-2B.5-psychotherapy-documentation.md) | KP2-625, KP2-961 |

### Compliance Mapping

#### 2B.5 Psychotherapy Documentation
**Source**: [`compliances/phase-2B.5-psychotherapy-documentation.md`](../../compliances/phase-2B.5-psychotherapy-documentation.md)

**Related Requirements**:
- "Psychotherapy services require specific documentation of the treatment context." (KP2-625)
- "The system must calculate the daily profile (Tagesprofil) for psychotherapy services. This tracks the total therapy time per day to ensure compliance with maximum daily treatment limits." (KP2-961)

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Given the embedded KBV coding table CSV, when the service initializes, then all Rezidiv codes and descriptions are parsed and loaded into memory | KP2-625: "Psychotherapy services require specific documentation of the treatment context" — Rezidiv codes are part of the psychotherapy treatment context documentation |
| AC2: Given a request for Rezidiv codes, when GetAllRezidivList is called, then the complete list of codes with their descriptions is returned | KP2-625: Supports correct coding of psychotherapy recurrence scenarios as required by KBV documentation standards |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
