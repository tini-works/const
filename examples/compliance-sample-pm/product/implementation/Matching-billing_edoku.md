# Matching: billing_edoku

## File
`backend-core/app/app-core/api/billing_edoku/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST496](../user-stories/US-VSST496.md) | Mark transmitted prescription data as billed | AC1, AC2 |
| [US-VSST516](../user-stories/US-VSST516.md) | Block Verordnungsdaten transmission; support retroactive | AC1, AC2 |
| [US-VSST1749](../user-stories/US-VSST1749.md) | eDMP | AC1 |
| [US-VSST592](../user-stories/US-VSST592.md) | DMP integration per KBV specifications | AC3, AC4 |
| [US-VSST1020](../user-stories/US-VSST1020.md) | eDMP transmission | AC1, AC3 |

## Evidence
- `billing_edoku.d.go` lines 178-192: `BillingEDokuApp` interface defines `GetValidationList`, `CreateBilling`, `PrepareForShipping`, `SendMail`, `GetDispatchList`, `CheckForValidation`, `GetBillingHistory`, and `GetEdokuDocumentByIds` providing the complete eDoku billing lifecycle (matches AC1 of [US-VSST1749](../user-stories/US-VSST1749.md), AC3 of [US-VSST592](../user-stories/US-VSST592.md))
- `billing_edoku.d.go` lines 55-67: `CreateBillingRequest` struct with `DocumentIds`, `Quarter`, `Bsnr`, `DMPValue`, and `IsOpenPreviousQuarter` fields; `CreateBillingResponse` with `Status`, `DMPBillingHistoryId`, and `DMPBillingFieldsValidationResults` implementing DMP billing creation with validation (matches AC4 of [US-VSST592](../user-stories/US-VSST592.md))
- `billing_edoku.d.go` lines 37-46: `GetValidationListRequest` with `Quarter`, `BsnrId`, `DocumentType`, `OpenPreviousQuarter` and response with `BillingValidationList` and `TotalPatient` enabling pre-billing validation (matches AC2 of [US-VSST496](../user-stories/US-VSST496.md))
- `billing_edoku.d.go` lines 75-83: `PrepareForShippingRequest` and `SendMailRequest` with `BillingHistoryId` and `SenderMailSettingId` handle the shipping and transmission workflow (matches AC1 of [US-VSST1020](../user-stories/US-VSST1020.md))
- `billing_edoku.d.go` lines 91-93: `UndoSubmissionRequest` with `BillingHistoryId` allows undoing a submission, supporting retroactive adjustments (matches AC2 of [US-VSST516](../user-stories/US-VSST516.md))
- `billing_edoku.d.go` lines 128-131: `EventBillingEDokuStatusChanged` with `BillingHistoryId` and `Status` tracks billing status changes after transmission (matches AC1 of [US-VSST496](../user-stories/US-VSST496.md))
- `billing_edoku.d.go` lines 109-118: `CheckForValidationRequest`/`CheckForValidationResponse` with `DMPBillingFieldsValidationResults` validates documents before billing creation (matches AC3 of [US-VSST1020](../user-stories/US-VSST1020.md))
- `billing_edoku.d.go` lines 95-101: `GetDispatchListRequest`/`GetDispatchListResponse` with `BillingHistories` list provides dispatch tracking (matches AC1 of [US-VSST516](../user-stories/US-VSST516.md))
- `billing_edoku.d.go` lines 133-139: `GetEdokuDocumentByIdsRequest`/`GetEdokuDocumentByIdsResponse` retrieves documentation overviews for billing (matches AC1 of [US-VSST1749](../user-stories/US-VSST1749.md))

## Coverage
- Full Match: The billing_edoku package provides a complete eDoku billing workflow including validation, creation, preparation for shipping, mail sending, dispatch tracking, undo submission, and billing history. This covers the eDoku aspects of DMP billing ([US-VSST592](../user-stories/US-VSST592.md), [US-VSST1020](../user-stories/US-VSST1020.md)), prescription data status tracking ([US-VSST496](../user-stories/US-VSST496.md)), and the documentation-without-transmission model supporting retroactive transmission ([US-VSST516](../user-stories/US-VSST516.md)).
