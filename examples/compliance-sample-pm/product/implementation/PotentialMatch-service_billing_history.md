# UnMatching: service_billing_history

## File
`backend-core/service/billing_history/`

## Analysis
- **What this code does**: Provides the billing history service for tracking KV billing submissions. Manages billing history records, companion file (Begleitdatei) generation, KV Connect integration for electronic billing transmission, and real-time WebSocket notifications for billing status updates. Includes common types for submitted users, KV Connect, companion files, delivery messages, and one-click billing errors.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-SERVICE_BILLING_HISTORY — KV Billing Submission History and One-Click Billing

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-SERVICE_BILLING_HISTORY |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E1=Billing Documentation |
| **Data Entity** | BillingHistoryItem, BillingKVHistory, Companion (Begleitdatei), DeliveryMessage, KVConnect, OneClickError, SendToAddress |

### User Story
As a care provider member, I want to manage KV billing submissions including creating billing records, sending them via KV Connect or KIM mail, tracking their status through the one-click billing workflow, and downloading history files, so that quarterly billing to KV associations is tracked end-to-end with real-time status updates.

### Acceptance Criteria
1. Given a billing submission request, when the billing history record is created, then it includes schein IDs, BSNR, billing type, companion file (Begleitdatei), and submitted user information
2. Given a created billing history, when sent via KV Connect or KIM mail, then the billing data is transmitted electronically and the status is updated to Sent/Sending
3. Given a sent billing, when a confirmation (Eingangsbestaetigung), feedback (Rueckmeldung), or test report (Pruefprotokoll) is received via KIM, then the one-click status is automatically updated
4. Given a billing history, when the user searches by quarter and year, then matching billing records are returned with their current status
5. Given a billing history record, when the user requests a download, then the history file is retrieved from MinIO storage
6. Given a billing submission fails, when a retry is initiated, then the mail is resent and status is updated accordingly
7. Given billing status changes, when updates occur, then real-time WebSocket notifications are pushed to connected clients
8. Given a billing record, when marked as billable or not billable, then the stage is updated accordingly

### Technical Notes
- Source: `backend-core/service/billing_history/`
- Key functions: Create, Search, UpdateStatus, SendKvConnectMail, SendKimMail, SendMailRetry, GetDownloadHistoryFile, MarkStageBillable, SyncOneClickInBoxMail, GetValidCompanionVersion, UpdateBillingStatusByKim
- Integration points: billing_history_repo (MongoDB), KV Connect service, KIM mail service, MinIO (file storage), BSNR service, schein service, WebSocket notifications, employee profile repository, SDKVCA data

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 3.1 KV Billing File Generation & Transmission | [`compliances/phase-3.1-kv-billing-file-generation-transmission.md`](../../compliances/phase-3.1-kv-billing-file-generation-transmission.md) | P2-96, P2-97, P2-890 |

### Compliance Mapping

#### 3.1 KV Billing File Generation & Transmission
**Source**: [`compliances/phase-3.1-kv-billing-file-generation-transmission.md`](../../compliances/phase-3.1-kv-billing-file-generation-transmission.md)

**Related Requirements**:
- "The software must provide a 1-Click-Abrechnung (one-click billing) function via KV-Connect. This streamlined submission process allows the practice to transmit the complete quarterly billing with a single action."
- "The software must provide a function for transmitting the online billing based on KIM (1ClickAbrechnung V2.1). This alternative transmission channel uses the KIM secure messaging infrastructure."
- "The system must handle billing transmission confirmations. After successful transmission, the system must record the confirmation, timestamp, and any reference numbers returned by the receiving system."

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: billing history record includes schein IDs, BSNR, billing type, Begleitdatei | P2-890: record confirmation, timestamp, reference numbers |
| AC2: send via KV Connect or KIM mail, status updated | P2-96: 1-Click-Abrechnung via KV-Connect; P2-97: 1-Click via KIM |
| AC3: one-click status auto-updated on confirmation/feedback/test report via KIM | P2-890: billing transmission confirmation handling |
| AC4: search billing records by quarter and year | P2-890: record confirmation and reference numbers |
| AC5: download history file from MinIO | P2-96: KV-Connect submission; P2-97: KIM transmission |
| AC6: retry on failure, resend mail | P2-96: 1-Click-Abrechnung streamlined submission |
| AC7: real-time WebSocket notifications for billing status | P2-890: billing transmission confirmation handling |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
