# Matching: billing_history

## File
`backend-core/app/app-core/api/billing_history/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST496](../user-stories/US-VSST496.md) | Mark transmitted prescription data as billed | AC1, AC2, AC3 |

## Evidence
- `billing_history.d.go` lines 156-165: `BillingHistoryApp` interface defines `Create`, `Search`, `GetDownloadHistoryFile`, `MarkStageBillable`, `SendMail`, `SendMailRetry`, `GetSettingForSending`, and `ChangeOneClickStatus` providing complete billing history lifecycle (matches AC2 of [US-VSST496](../user-stories/US-VSST496.md))
- `billing_history.d.go` lines 37-52: `CreateRequest` struct with `QuarterMonth`, `QuarterYear`, `BsnrId`, `TypeOfBilling`, `MarkAsCompletedBilling`, `BillingKvId`, `KvConnectId`, `SendToMailType`, and `MarkNotBillable` fields captures all billing transmission metadata needed for status tracking (matches AC1 of [US-VSST496](../user-stories/US-VSST496.md))
- `billing_history.d.go` lines 79-82: `MarkStageBillableRequest` with `Id` and `MarkNotBillable` fields enables marking billing entries as billed or not billable (matches AC1 of [US-VSST496](../user-stories/US-VSST496.md))
- `billing_history.d.go` lines 84-92: `EventBillingHistory` with `EventType` (Created/Updated), `BillingHistoryItem`, `CurrentUserId` provides audit trail for billing status changes (matches AC3 of [US-VSST496](../user-stories/US-VSST496.md))
- `billing_history.d.go` lines 54-69: `SearchRequest`/`SearchResponse` with pagination, BSNR filtering, and patient billing filtering enables comprehensive billing history search (matches AC2 of [US-VSST496](../user-stories/US-VSST496.md))
- `billing_history.d.go` lines 71-77: `GetDownloadHistoryFileRequest`/`GetDownloadHistoryFileResponse` with `ConfileResults` provides billing file download capability (matches AC2 of [US-VSST496](../user-stories/US-VSST496.md))
- `billing_history.d.go` lines 111-114: `ChangeOneClickStatusRequest` with `Status` of type `OneClickStatus` supports one-click billing status transitions (matches AC1 of [US-VSST496](../user-stories/US-VSST496.md))

## Coverage
- Full Match: The billing_history package provides comprehensive billing history management including creation, search, download, status marking (billable/not billable), mail sending with retry, and event-based audit trail. This directly supports the requirement to mark transmitted prescription data as billed after successful transmission.
