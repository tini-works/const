# UnMatching: cardservice

## File
`backend-core/app/app-core/api/cardservice/`

## Analysis
- **What this code does**: Provides the primary insurance card reading service (CardServiceApp) for eGK (elektronische Gesundheitskarte) and KVK cards via connected card terminals. Supports reading cards with optional online check and quarterly-first-read detection, patient matching/comparison against existing records, and retrieving available terminals and inserted cards. Emits real-time events for card read results, card terminal events (EVT), and terminal/card discovery responses via WebSocket.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-CARDSERVICE — Insurance Card Reading via Card Terminals

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-CARDSERVICE |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E8: Integration Services |
| **Data Entity** | CardHolder, PatientCompareData, TerminalWithCards |

### User Story

As a practice staff member, I want to read insurance cards (eGK/KVK) from connected card terminals with optional online check and quarterly-first-read detection, compare card data against existing patient records, and discover available terminals and inserted cards, so that I can efficiently capture and verify patient insurance information during check-in.

### Acceptance Criteria

1. Given a mandant ID and optional online check and quarterly-first-read flags, when the user reads a card, then the system returns patient comparison data (matched patients, patient from card, compare result, prepared patients), card type, and any warning error codes.
2. Given connected card terminals, when the user requests terminals and cards, then the system discovers available terminals and inserted cards and broadcasts the response via WebSocket.
3. Given a card read event is published, when the card service receives it, then it processes the event and notifies the user via WebSocket with the read result.
4. Given card terminal events (EVT), when terminal status changes occur, then the system broadcasts them via WebSocket to connected clients.

### Technical Notes
- Source: `backend-core/app/app-core/api/cardservice/`
- Key functions: GetCards, GetTerminalsAndCards, HandleEventGetCards
- Integration points: card_common (CardTypeType, TerminalWithCards, EventType), patient_profile_common (PatientInfo, CompareStatus), error_code (ErrorCode), WebSocket notifications (ReadCard, CardEVT, GetTerminalsAndCardsResponse events)

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 1.1 eGK Card Read-In | [`compliances/phase-1.1-egk-card-read-in.md`](../../compliances/phase-1.1-egk-card-read-in.md) | KP2-100, KP2-101, P2-135, P2-136, P2-140, P2-166, KP2-185, KP2-190, KP2-191 |
| 1.3 Patient Matching & Insurance Changes | [`compliances/phase-1.3-patient-matching-insurance-changes.md`](../../compliances/phase-1.3-patient-matching-insurance-changes.md) | KP2-300, KP2-310 |

### Compliance Mapping

#### 1.1 eGK Card Read-In
**Source**: [`compliances/phase-1.1-egk-card-read-in.md`](../../compliances/phase-1.1-egk-card-read-in.md)

**Related Requirements**:
- "All terminals must be connectable to any billing system on request via at least one interface (RS232, LAN, USB). The system must support reading patient data from the electronic health card (eGK) and the legacy health insurance card (KVK) through connected card terminals."
- "The software must ensure that reading a KVK for statutory insured persons (VKNR serial number 3rd–5th digit < 800) is rejected with an error message."
- "Following a successful card read, the system date is generated as the read-in date (FK 4109), displayed, and stored."
- "The billing software must verify the cost carrier benefit obligation when reading an insurance card by checking the insurance coverage validity period (start/end dates)."
- "The software must enable transmission of the VSDM verification proof into the ADT billing."
- "The software must ensure that the co-payment exemption (Zuzahlungsbefreiung) for a patient is deleted system-side no later than the turn of the year. The VSDM online proof status must be captured and transmitted via FK 4136."

#### 1.3 Patient Matching & Insurance Changes
**Source**: [`compliances/phase-1.3-patient-matching-insurance-changes.md`](../../compliances/phase-1.3-patient-matching-insurance-changes.md)

**Related Requirements**:
- "The software must ensure correct patient identification when reading an insurance card by matching against already stored patient data. The system must prevent creation of duplicate patient records and avoid unintentional overwriting of existing patient data."
- "The software must detect insurance changes (Kassenwechsel) when a new insurance card is read for an existing patient."

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: read card with optional online check and quarterly-first-read detection, return patient comparison data | KP2-100: support reading eGK/KVK through card terminals; P2-135: card read date capture; KP2-190: VSDM online proof; KP2-300: patient matching on card read |
| AC2: discover available terminals and inserted cards | KP2-100: all terminals must be connectable to billing system |
| AC3: process card read event and notify via WebSocket | P2-140: cost carrier benefit obligation check on card read; KP2-310: insurance change detection |
| AC4: broadcast terminal status changes via WebSocket | KP2-100: terminal connectivity |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
