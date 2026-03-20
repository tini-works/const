# Matching: pvs_billing

## File
`backend-core/app/app-core/api/pvs_billing/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST496](../user-stories/US-VSST496.md) | Mark transmitted prescriptions as billed | AC1 (partial) |
| [US-VSST515](../user-stories/US-VSST515.md) | Prescription data transmission prerequisites | AC1 (partial) |
| [US-VSST518](../user-stories/US-VSST518.md) | Transmission of prescriptions before transmission start date | AC1 (partial) |
| [US-VSST1548](../user-stories/US-VSST1548.md) | Retroactive transmission from GueltigAbReferenzdatum | AC1 (partial), AC2 (partial) |
| [US-ABRD606](../user-stories/US-ABRD606.md) | Service lookup filter by IK assignment | AC1 (partial) |
| [US-ABRD608](../user-stories/US-ABRD608.md) | Diagnoses documented per SGB V section 295 | AC1 (partial) |
| [US-ABRD834](../user-stories/US-ABRD834.md) | FAV participation verification before service entry | AC1 (partial) |

## Evidence
- `pvs_billing.d.go` lines 46-56: `ExportPADneXtFileRequest` includes `BillingIds`, `BillingInstruction`, `IsMarkScheinAsBilled`, `BillingType`, `Version` -- the `IsMarkScheinAsBilled` flag supports marking prescriptions as billed after transmission (matches AC1 partial for [US-VSST496](../user-stories/US-VSST496.md))
- `pvs_billing.d.go` lines 37-44: `ValidatePvsConfigRequest/Response` validates billing configuration before export -- supports transmission prerequisites (matches AC1 partial for [US-VSST515](../user-stories/US-VSST515.md))
- `pvs_billing.d.go` lines 197-209: `PvsBillingApp` interface provides `ValidatePvsConfig`, `ExportPADneXtFile`, `ProcessPvsBillingHistory`, `GetPvsBillingHistory`, `DeletePvsBillingHistory`, `ExportPvsBillingHistoryAgain`, `RetryExportPvsBillingHistory`, `MarkPrivateBillingUnbilled`, `MarkBgBillingUnbilled`, `ReopenWholeBilling` -- comprehensive billing export and history management (matches AC1 partial for [US-VSST496](../user-stories/US-VSST496.md), [US-VSST515](../user-stories/US-VSST515.md), [US-VSST518](../user-stories/US-VSST518.md), [US-VSST1548](../user-stories/US-VSST1548.md))
- `pvs_billing.d.go` lines 85-90: `EventNotifyPvsExportProgress` with `Status`, `Url`, `FileName` notifies of export progress -- supports post-transmission notification (matches AC1 partial for [US-VSST496](../user-stories/US-VSST496.md))
- `pvs_billing.d.go` lines 66-74: `ProcessPvsBillingHistoryRequest` with `BillingType`, `Id`, `IsRetry` supports billing processing workflow including retry -- supports transmission logic (matches AC1 partial for [US-VSST518](../user-stories/US-VSST518.md), [US-VSST1548](../user-stories/US-VSST1548.md))
- `pvs_billing.d.go` lines 158-163: `BillingType` enum with `BillingType_PRIVATE` and `BillingType_BG` -- billing type differentiation (matches AC1 partial for [US-ABRD606](../user-stories/US-ABRD606.md), [US-ABRD608](../user-stories/US-ABRD608.md), [US-ABRD834](../user-stories/US-ABRD834.md))
- `pvs_billing.d.go` lines 134-141: `MarkPrivateBillingUnbilledRequest/Response` allows reverting billing status -- supports billing state management (matches AC1 partial for [US-VSST496](../user-stories/US-VSST496.md))

## Coverage
- Partial Match -- The package provides billing export, validation, history tracking, and status management for PVS billing (private and BG). It supports marking as billed (`IsMarkScheinAsBilled`), billing validation prerequisites, and billing history management. However, the specific date-range enforcement for retroactive transmission (GueltigAbReferenzdatum/GueltigBisReferenzdatum from [US-VSST1548](../user-stories/US-VSST1548.md)), contract-specific transmission start date filtering ([US-VSST518](../user-stories/US-VSST518.md)), per-Verordnung 'abgerechnet' flagging ([US-VSST496](../user-stories/US-VSST496.md)), IK-based service filtering ([US-ABRD606](../user-stories/US-ABRD606.md)), SGB V section 295 diagnosis validation ([US-ABRD608](../user-stories/US-ABRD608.md)), and FAV participation pre-check ([US-ABRD834](../user-stories/US-ABRD834.md)) are not directly verified as specific implementations in this package. These may be handled in the companion `billing` package or contract service.
