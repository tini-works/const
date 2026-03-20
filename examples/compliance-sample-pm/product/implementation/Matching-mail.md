# Matching: mail

## File
`backend-core/app/app-core/api/mail/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST1020](../user-stories/US-VSST1020.md) | eDMP transmission | AC1 |
| [US-VSST1749](../user-stories/US-VSST1749.md) | eDMP workflow | AC1 |

## Evidence
- `mail.d.go` lines 304-332: `MailApp` interface defines comprehensive mail functionality including `SendMail`, `GetInboxMails`, `GetOutboxMails`, `GetArchivedMails`, `SyncInboxKvMail`, `SyncInboxMail`, `GetKimAccounts`, `SearchMailAddress`, `GetAttachmentFileUrl`, `GetAttachment` -- provides KIM (Kommunikation im Medizinwesen) mail service used for DMP data transmission (matches AC1 of [US-VSST1020](../user-stories/US-VSST1020.md))
- `mail.d.go` lines 68-74: `GetKimAccountsRequest`/`GetKimAccountsResponse` with `BsnrCodes` and `MailAccountDto` -- KIM account management per BSNR, enabling DMP-Datenstelle transmission
- `mail.d.go` lines 35-41: `GetMailsRequest` with `AccountEmail`, `SearchValue`, `SearchType`, `Pagination`, `MailBox` -- supports inbox/outbox/archive mail retrieval for monitoring transmission status
- `mail.d.go` lines 47-51: `MailItemDTO` with `EmailItem` and `Date` -- mail item tracking with date stamps for audit trail
- `mail.d.go` lines 83-96: `SearchMailAddressRequest`/`SearchMailAddressResponse` with `MailAddressEntry` containing `Name`, `Mail`, `Location`, `Specialization` -- mail address directory search for finding DMP-Datenstelle addresses
- `mail.d.go` line 330: `OnPatientUpdate` method subscribing to `EventPatientProfileChange` -- integrates with patient profile updates for maintaining mail associations
- `mail.d.go` line 331: `GenPresignedPutAttachmentURL` method -- supports attachment upload for mail with documents

## Coverage
- Full Match: The mail package provides the KIM mail infrastructure used by the eDMP module for transmitting DMP documentation to the DMP-Datenstelle. The `SendMail` method enables the `edmp` package's `SendKIMMail` function to transmit eDMP data. The package also supports inbox synchronization, outbox tracking, and attachment management, covering the full eDMP transmission workflow referenced in both [US-VSST1020](../user-stories/US-VSST1020.md) and [US-VSST1749](../user-stories/US-VSST1749.md).
