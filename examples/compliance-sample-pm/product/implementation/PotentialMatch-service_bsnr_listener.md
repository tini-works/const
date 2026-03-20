# UnMatching: service_bsnr_listener

## File
`backend-core/service/bsnr_listener/`

## Analysis
- **What this code does**: Provides an event listener that reacts to BSNR-related changes. Registers hooks on mail setting CUD (create/update/delete) events to propagate changes when a practice's mail settings or BSNR associations change. Coordinates between mail settings, card operations, and KV billing history services.
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

## US-PROPOSED-BSNR_LISTENER — Automatic TI Component Status Propagation on BSNR Events

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-BSNR_LISTENER |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5=Practice Software Core |
| **Data Entity** | BSNR, TiComponent, MailSetting, Card, Terminal, BillingKVHistory |

### User Story
As a system operator, I want TI component statuses (KIM, SMCB, EHBA, Kartenterminal) on BSNR entities to be automatically updated when mail settings change, cards are read, or terminals are detected, so that the practice TI infrastructure state is always current for KV billing compliance.

### Acceptance Criteria
1. Given a mail setting is created or deleted for a BSNR, when the CUD hook fires, then the KIM TI component on the associated BSNR entity is updated based on whether any mail settings remain
2. Given a mail setting is updated with a changed BSNR, when the update hook fires, then both the old and new BSNR entities have their KIM status recalculated
3. Given cards are read from a card terminal, when the OnReadCard hook fires, then SMCB and EHBA TI components are updated on all BSNRs based on detected card types
4. Given card terminals are detected, when the OnGetTerminal hook fires, then the Kartenterminal TI component is updated on all BSNRs
5. Given a TI component was previously detected in the prior quarter, when the current detection is false, then the component remains editable (not readonly) for manual override

### Technical Notes
- Source: `backend-core/service/bsnr_listener/`
- Key functions: Register, OnMailSettingCUD, OnReadCard, OnGetTerminal
- Integration points: mail_setting_service (CUD hooks), card_operation_service (card/terminal hooks), bsnr_service, billing_kv_history repo (previous quarter TI info lookup)

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 7.3 TI Connector Reporting | [`compliances/phase-7.3-ti-connector-reporting.md`](../../compliances/phase-7.3-ti-connector-reporting.md) | P2-67 |
| 7.2 User & Practice Administration | [`compliances/phase-7.2-user-practice-administration.md`](../../compliances/phase-7.2-user-practice-administration.md) | P2-52 |

### Compliance Mapping

#### 7.3 TI Connector Reporting
**Source**: [`compliances/phase-7.3-ti-connector-reporting.md`](../../compliances/phase-7.3-ti-connector-reporting.md)

**Related Requirements**:
- "The software must enable the transmission of an attestation confirming support for TI specialist applications (ePA, eRezept, KIM, etc.) and the availability of TI components as part of the ADT billing submission."

#### 7.2 User & Practice Administration
**Source**: [`compliances/phase-7.2-user-practice-administration.md`](../../compliances/phase-7.2-user-practice-administration.md)

**Related Requirements**:
- "A PVS must manage all physicians active at each practice location (identified by BSNR — Betriebsstättennummer), including their LANR, and transmit this information in the besa dataset as part of the KV billing process."

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Given a mail setting is created or deleted for a BSNR, when the CUD hook fires, then the KIM TI component on the associated BSNR entity is updated | P2-67: transmission of an attestation confirming support for TI specialist applications (ePA, eRezept, KIM, etc.) |
| AC3: Given cards are read from a card terminal, when the OnReadCard hook fires, then SMCB and EHBA TI components are updated on all BSNRs | P2-67: the availability of TI components as part of the ADT billing submission |
| AC4: Given card terminals are detected, when the OnGetTerminal hook fires, then the Kartenterminal TI component is updated on all BSNRs | P2-67: the availability of TI components as part of the ADT billing submission |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
