# Matching: billing

## File
`backend-core/app/app-core/api/billing/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST496](../user-stories/US-VSST496.md) | Mark transmitted prescription data as billed | AC1, AC2 |
| [US-VSST515](../user-stories/US-VSST515.md) | Prescription data transmission prerequisites | AC1, AC2 |
| [US-VSST516](../user-stories/US-VSST516.md) | Block Verordnungsdaten transmission; support retroactive | AC1, AC2 |
| [US-VSST518](../user-stories/US-VSST518.md) | Allow transmission for prescriptions documented before transmission start date | AC1 |
| [US-VSST548](../user-stories/US-VSST548.md) | Display medications sorted by Gruen/Blau categories | -- |
| [US-VSST1548](../user-stories/US-VSST1548.md) | Retroactive transmission from GueltigAbReferenzdatum | AC1, AC2 |
| [US-ABRD606](../user-stories/US-ABRD606.md) | Service lookup must filter by IK assignment | AC1, AC2, AC3 |
| [US-ABRD608](../user-stories/US-ABRD608.md) | Diagnoses must be documented per par.295 SGB V | -- |

## Evidence
- `billing.d.go` lines 190-199: `BillingApp` interface defines `GetBillableEncounters`, `GetBillingHistories`, `SubmitBillings`, `SubmitBilling`, `TestSubmitBillings`, and `ReValidatePatientBillingSubmission` implementing the full billing pipeline (matches AC1 of [US-VSST496](../user-stories/US-VSST496.md), AC2 of [US-VSST515](../user-stories/US-VSST515.md))
- `billing.d.go` lines 134-136: `EVENT_GetBillableEncounters` endpoint retrieves encounters filtered by patient and contract context for IK-based service lookup (matches AC1 of [US-ABRD606](../user-stories/US-ABRD606.md))
- `billing.d.go` lines 83-88: `GetContractTypeByIdsRequest`/`GetContractTypeByIdsResponse` with `ContractIds` to `ContractType` mapping provides contract metadata including IK assignment (matches AC3 of [US-ABRD606](../user-stories/US-ABRD606.md))
- `billing.d.go` lines 61-63: `EventBillingHistoryChange` struct with `BillingHistoriesResponse` data tracks billing status changes after transmission (matches AC1 of [US-VSST496](../user-stories/US-VSST496.md))
- `billing.d.go` lines 65-67: `EventBillingSubmissionResponse` provides submission result notification supporting post-transmission status updates (matches AC2 of [US-VSST496](../user-stories/US-VSST496.md))
- `billing.d.go` lines 174-177: `EVENT_PreConditionSvBilling` and `EVENT_CalculateBillingSummary` enforce billing prerequisites before transmission (matches AC1 of [US-VSST515](../user-stories/US-VSST515.md))
- `billing.d.go` lines 144-147: `SubmitBillings` and `SubmitBilling` endpoints handle the actual billing transmission workflow (matches AC1 of [US-VSST516](../user-stories/US-VSST516.md))
- `billing.d.go` lines 90-94: `GetBillingCaseErrorRequest` with `PatientIds` and `ContractIds` supports billing case error validation (matches AC2 of [US-VSST515](../user-stories/US-VSST515.md))
- `billing.d.go` lines 168-173: `EVENT_SubmitPreParticipateService` and `EVENT_SubmitBillingToHpm` handle HPM billing submission supporting Verordnungsdaten transmission (matches AC1 of [US-VSST518](../user-stories/US-VSST518.md))
- `billing.d.go` lines 108-110: `GetBillingHistoriesByReferenceIdRequest` enables tracking billing histories by reference supporting retroactive billing (matches AC1, AC2 of [US-VSST1548](../user-stories/US-VSST1548.md))

## Coverage
- Partial Match: The billing package provides comprehensive billing workflows including submission, validation, and history tracking. The core billing pipeline (create, validate, submit, track) is fully implemented. However, [US-VSST548](../user-stories/US-VSST548.md) (Gruen/Blau medication sorting) is not addressed by this backend package -- it is a frontend/HPM concern. [US-ABRD608](../user-stories/US-ABRD608.md) diagnosis validation is handled primarily by billing_kv and coding_rule packages rather than this package. The specific per-Verordnung 'abgerechnet' flag ([US-VSST496](../user-stories/US-VSST496.md)) and GueltigAbReferenzdatum enforcement ([US-VSST1548](../user-stories/US-VSST1548.md)) require verification at the service layer.
