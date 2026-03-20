# UnMatching: card_raw

## File
`backend-core/app/app-core/api/card_raw/`

## Analysis
- **What this code does**: Provides a mobile card reader raw data management service (CardRawApp). Handles raw insurance card data read from mobile card readers (companion app), including listing raw results with pagination, reviewing and importing card data into patient profiles, removing results, updating import status, checking card status against existing patients, and triggering mobile card reader sessions. Broadcasts card change events via WebSocket for real-time UI updates.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-CARD_RAW — Mobile Card Reader Raw Data Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-CARD_RAW |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E8: Integration Services |
| **Data Entity** | MobileCardInfoModel, ImportStatus, PatientInfo |

### User Story

As a practice staff member, I want to manage raw insurance card data from mobile card readers including listing, reviewing, importing into patient profiles, removing results, checking card status, and triggering mobile reader sessions, so that I can process patient insurance cards read via the companion mobile app.

### Acceptance Criteria

1. Given an authenticated care provider member, when they request raw results with pagination, then the system returns mobile card info models with pagination metadata.
2. Given a raw result ID, when the user reviews it, then the system returns patient comparison data showing matched and prepared patient records from the card.
3. Given a list of raw result IDs, when the user imports them, then the system imports the card data into patient profiles and broadcasts import change events via WebSocket.
4. Given raw result IDs, when the user removes them, then the system deletes the specified raw results.
5. Given no parameters, when the user removes all raw results, then all raw results are cleared.
6. Given a raw result ID and status details, when the user updates the import status, then the system updates and returns the new card status.
7. Given a patient ID and insurance info from a card, when the user checks the mobile card status, then the system returns whether the card data has already been imported.
8. Given a raw result ID, when the user requests card information, then the system returns the patient info extracted from the card.
9. Given an authenticated user, when they trigger a mobile card reader session, then the system initiates reading on the companion device.

### Technical Notes
- Source: `backend-core/app/app-core/api/card_raw/`
- Key functions: GetRawResult, ReviewRawResult, ImportRawResult, RemoveRawResult, RemoveAllRawResult, UpdateStatus, CheckStatusCardMobile, GetCardInformation, StartReadingMobileCardReader, HandleEventMobileCardChanged
- Integration points: cardservice (GetCardsResponse), mobile_app (companion app), patient_profile_common (PatientInfo, InsuranceInfo), WebSocket notifications (MobileCardChanged, ImportRawMobileCardChanged events)

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 1.1 eGK Card Read-In | [`compliances/phase-1.1-egk-card-read-in.md`](../../compliances/phase-1.1-egk-card-read-in.md) | KP2-102, P2-135, KP2-185 |
| 1.3 Patient Matching & Insurance Changes | [`compliances/phase-1.3-patient-matching-insurance-changes.md`](../../compliances/phase-1.3-patient-matching-insurance-changes.md) | KP2-300 |

### Compliance Mapping

#### 1.1 eGK Card Read-In
**Source**: [`compliances/phase-1.1-egk-card-read-in.md`](../../compliances/phase-1.1-egk-card-read-in.md)

**Related Requirements**:
- "The software must allow the user to display the card data of a rejected KVK in a copyable format, enabling manual transfer of patient data from mobile terminals or rejected cards into the PVS."
- "Following a successful card read, the system date is generated as the read-in date (FK 4109), displayed, and stored."
- "Card data must be stored with field-level controls distinguishing between official (immutable) and user-editable fields."

#### 1.3 Patient Matching & Insurance Changes
**Source**: [`compliances/phase-1.3-patient-matching-insurance-changes.md`](../../compliances/phase-1.3-patient-matching-insurance-changes.md)

**Related Requirements**:
- "The software must ensure correct patient identification when reading an insurance card by matching against already stored patient data. The system must prevent creation of duplicate patient records and avoid unintentional overwriting of existing patient data."

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC2: review raw result returns patient comparison data | KP2-300: patient matching on card read; KP2-102: mobile terminal data transfer to PVS |
| AC3: import card data into patient profiles | KP2-185: card data storage with field-level control |
| AC7: check mobile card status for existing import | KP2-300: prevent duplicate patient records |
| AC8: get patient info extracted from card | P2-135: card read date capture |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
