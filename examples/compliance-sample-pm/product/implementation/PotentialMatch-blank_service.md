# UnMatching: blank_service

## File
`backend-core/app/app-core/api/blank_service/`

## Analysis
- **What this code does**: Provides a blank (custom/user-defined) service code management service (BlankServicesApp). Allows practitioners to define custom billing service codes with contract ID, charge system, code, description, and price. Supports activating and deactivating blank services, listing them by contract, and broadcasting change events via NATS and WebSocket to keep all connected clients synchronized.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-BLANK_SERVICE — Custom Billing Service Code Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-BLANK_SERVICE |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E1: Billing Documentation |
| **Data Entity** | BlankService |

### User Story
As a practitioner, I want to define, activate, and deactivate custom billing service codes with contract, charge system, code, description, and price, so that I can bill for services not covered by standard fee schedules.

### Acceptance Criteria
1. Given an authenticated care provider member and an optional contract ID, when they request blank services, then the system returns all blank service codes for that contract.
2. Given a contract ID, charge system ID, code, description, and price, when the practitioner activates a blank service, then the system creates or activates the custom service code and broadcasts a change event to all connected clients via NATS and WebSocket.
3. Given a contract ID, charge system ID, and code, when the practitioner deactivates a blank service, then the system deactivates the service code and broadcasts a change event.
4. Given a blank service code change event is published, when the service receives it, then it handles the event to keep local state synchronized.

### Technical Notes
- Source: `backend-core/app/app-core/api/blank_service/`
- Key functions: GetBlankServices, ActiveBlankService, DeactiveBlankService, HandleEventBlankServiceCode
- Integration points: WebSocket notifications (BlankServiceCode events to care provider members, users, devices, clients)

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 7.4 KBV Master Data Files | [`compliances/phase-7.4-kbv-master-data-files.md`](../../compliances/phase-7.4-kbv-master-data-files.md) | P6-720 |

### Compliance Mapping

#### 7.4 KBV Master Data Files — SDEBM Extensibility
**Source**: [`compliances/phase-7.4-kbv-master-data-files.md`](../../compliances/phase-7.4-kbv-master-data-files.md)

**Related Requirements**:
- "The software must provide the user with the ability to modify or extend the EBM data foundation." (P6-720)
- "While the SDEBM is the authoritative fee schedule, practices may need to add custom GOPs (Gebührenordnungspositionen) for regional or contract-specific services not yet reflected in the official dataset. The system must allow users to add new service codes or modify existing entries, while clearly distinguishing user-modified data from official EBM records." (P6-720)

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Given an authenticated care provider member and an optional contract ID, when they request blank services, then the system returns all blank service codes for that contract | P6-720: "practices may need to add custom GOPs for regional or contract-specific services" |
| AC2: Given a contract ID, charge system ID, code, description, and price, when the practitioner activates a blank service, then the system creates or activates the custom service code | P6-720: "The software must provide the user with the ability to modify or extend the EBM data foundation" |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
