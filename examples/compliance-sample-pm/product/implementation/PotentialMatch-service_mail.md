# UnMatching: service_mail

## File
`backend-core/service/mail/`

## Analysis
- **What this code does**: Provides a comprehensive KIM (Kommunikation im Medizinwesen - Communication in Healthcare) mail service. Handles sending and receiving encrypted healthcare emails via POP3, LDAP directory lookups for KIM addresses, mail settings management per practice, and MinIO-based attachment storage. Integrates with TI card operations for S/MIME signing, companion modules, timeline service, and Redis caching. Includes mail inbox/sent repository management.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

## Classification
- [x] E8=Integration Services

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-MAIL — KIM Healthcare Mail Service

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-MAIL |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E8=Integration Services |
| **Data Entity** | MailItemInbox, MailItemSent, MailSetting, MailAddressBook |

### User Story
As a medical practice staff member, I want to send and receive encrypted KIM (Kommunikation im Medizinwesen) healthcare emails with LDAP directory lookups and attachment handling, so that I can securely communicate with other healthcare providers in compliance with German healthcare communication standards.

### Acceptance Criteria
1. Given a configured KIM mail account, when I send a mail via `SendMail`, then the message is S/MIME signed via TI card operations and delivered through the KIM infrastructure
2. Given incoming KIM messages, when the system syncs via POP3, then new mails are stored in the inbox repository with attachments uploaded to MinIO
3. Given a mail address search request, when I search via LDAP, then matching KIM addresses are returned from the healthcare directory
4. Given a received mail, when I assign it to a patient via `AssignPatient`, then the mail is linked to the patient timeline
5. Given a mail in inbox or sent, when I delete it, then it is soft-deleted or hard-deleted based on criteria, and associated file storage is cleaned up
6. Given mail settings per account, when I configure BSNR-scoped accounts, then each practice location can have independent KIM mail settings
7. Given a sent mail that failed delivery, when I resend via `ReSendMail`, then the mail is rebuilt and retransmitted

### Technical Notes
- Source: `backend-core/service/mail/`
- Key functions: SendMail, ReSendMail, GetMailsInbox, Delete, AssignPatient, GetAllAccount, SearchMailAddress (LDAP), SyncMail (POP3)
- Integration points: companion_modules (TI card operations), MinIO (attachment storage), Redis (sync locking), timeline_service, mail_address_book repo, mail_setting_repo, socket notifications

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 5.3 eArztbrief — Electronic Doctor Letter | [`compliances/phase-5.3-earztbrief-electronic-doctor-letter.md`](../../compliances/phase-5.3-earztbrief-electronic-doctor-letter.md) | KIM S/MIME Envelopes, Delivery Status Tracking, Incoming Letter Matching |
| 2B.5 Psychotherapy Documentation | [`compliances/phase-2B.5-psychotherapy-documentation.md`](../../compliances/phase-2B.5-psychotherapy-documentation.md) | KP2-967 |
| 3.1 KV Billing File Generation & Transmission | [`compliances/phase-3.1-kv-billing-file-generation-transmission.md`](../../compliances/phase-3.1-kv-billing-file-generation-transmission.md) | P2-97 |

### Compliance Mapping

#### 5.3 eArztbrief — Electronic Doctor Letter
**Source**: [`compliances/phase-5.3-earztbrief-electronic-doctor-letter.md`](../../compliances/phase-5.3-earztbrief-electronic-doctor-letter.md)

**Related Requirements**:
- "Encrypt and sign the CDA document using S/MIME"
- "Recipient address lookup from KIM directory (by LANR/BSNR)"
- "Support for multiple recipients per letter"
- "DSN (Delivery Status Notification) processing"
- "Display delivery confirmation or failure to the sending physician"
- "Retry mechanism for undelivered letters"
- "Parse incoming CDA documents"
- "Match to patient records using patient identification data"
- "Archive received letters in patient documentation"

#### 2B.5 Psychotherapy Documentation
**Source**: [`compliances/phase-2B.5-psychotherapy-documentation.md`](../../compliances/phase-2B.5-psychotherapy-documentation.md)

**Related Requirements**:
- "Termination notices must be transmittable via KIM (Kommunikation im Medizinwesen). This enables electronic delivery to the relevant health insurance carrier." (KP2-967)

#### 3.1 KV Billing File Generation & Transmission
**Source**: [`compliances/phase-3.1-kv-billing-file-generation-transmission.md`](../../compliances/phase-3.1-kv-billing-file-generation-transmission.md)

**Related Requirements**:
- "The software must provide a function for transmitting the online billing based on KIM (1ClickAbrechnung V2.1)." (P2-97)

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Given a configured KIM mail account, when I send a mail via SendMail, then the message is S/MIME signed via TI card operations | "Encrypt and sign the CDA document using S/MIME" (phase-5.3) and KP2-967: "Termination notices must be transmittable via KIM" |
| AC2: Given incoming KIM messages, when the system syncs via POP3, then new mails are stored in the inbox | "Parse incoming CDA documents" and "Archive received letters in patient documentation" (phase-5.3) |
| AC3: Given a mail address search request, when I search via LDAP, then matching KIM addresses are returned | "Recipient address lookup from KIM directory (by LANR/BSNR)" (phase-5.3) |
| AC4: Given a received mail, when I assign it to a patient via AssignPatient, then the mail is linked to the patient timeline | "Match to patient records using patient identification data" (phase-5.3) |
| AC7: Given a sent mail that failed delivery, when I resend via ReSendMail, then the mail is rebuilt and retransmitted | "Retry mechanism for undelivered letters" (phase-5.3) |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
