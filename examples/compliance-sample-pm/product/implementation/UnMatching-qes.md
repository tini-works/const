# UnMatching: qes

## File
`backend-core/app/app-core/api/qes/`

## Analysis
- **What this code does**: Provides the Qualified Electronic Signature (QES) API for managing electronic signatures via smart cards (doctor cards, practice cards). Supports getting signature info, activating/deactivating comfort signatures, stopping signature sessions, and retrieving comfort signature logs. Communicates PIN status events via WebSocket notifications.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-QES — Qualified Electronic Signature Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-QES |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5 Practice Software Core |
| **Data Entity** | CardInfo, ComfortSignatureInfo, SignatureLog |

### User Story
As a physician, I want to manage qualified electronic signatures (QES) using my doctor card or practice card, including activating and deactivating comfort signatures, so that I can digitally sign documents in compliance with German healthcare regulations.

### Acceptance Criteria
1. Given a doctor ID and BSNR, when the user requests signature info, then the doctor card, practice card, signature service version, and comfort signature status are returned
2. Given a valid doctor ID and card ID, when the user activates comfort signature, then the comfort signature mode is enabled for that card
3. Given an active comfort signature, when the user deactivates it, then the comfort signature mode is disabled
4. Given an active signing session, when the user stops the signature with a session job number, then the signing session is terminated
5. Given signature activity, when the user requests comfort signature logs with pagination, query filter, and date range, then matching log entries are returned
6. Given a PIN input event occurs, when the system processes it, then a QESInputPin event is broadcast via WebSocket to the care provider, user, device, and client levels

### Technical Notes
- Source: `backend-core/app/app-core/api/qes/`
- Key functions: GetSignatureInfo, ActivateComfortSignature, DeactivateComfortSignature, StopSignature, GetComfortSignatureLog
- Integration points: `service/domains/qes/common`, `service/domains/api/card_common` (CardTypeType), WebSocket notifications (EventQESInputPin)
- All endpoints require CARE_PROVIDER_MEMBER role
