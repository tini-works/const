# Matching: billing_kv

## File
`backend-core/app/app-core/api/billing_kv/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-ABRD456](../user-stories/US-ABRD456.md) | Prompt to add code 0000 when missing | AC1, AC2 |

## Evidence
- `billing_kv.d.go` lines 207-221: `BillingKVApp` interface defines `Troubleshoot`, `GetError`, `ValidateCodingRuleByPatientId`, `ToggleResolveBillingError`, `EditError`, `MakeScheinBill`, and `GetGroupEABServiceCode` providing complete KV billing validation (matches AC1 of [US-ABRD456](../user-stories/US-ABRD456.md))
- `billing_kv.d.go` lines 43-55: `TroubleshootRequest` struct with `Quarter`, `Year`, `BSNRId`, `IsValidationError`, `IsValidationWarning`, `IsValidationCodingRules`, and `ExcludeEABServiceCode` fields enable comprehensive billing validation including coding rule checks (matches AC1 of [US-ABRD456](../user-stories/US-ABRD456.md))
- `billing_kv.d.go` lines 57-71: `TroubleshootResponse` with `GroupErrorByPatientDetails`, `TotalErrors`, `TotalWarnings`, `TotalCodingRules`, and `CanIgnore` fields surface validation errors including missing required service codes (matches AC1 of [US-ABRD456](../user-stories/US-ABRD456.md))
- `billing_kv.d.go` lines 79-87: `GetErrorRequest`/`GetErrorResponse` with `FileContentDetails` and `GroupErrorByPatientDetailErrors` provides detailed per-patient error information surfacing missing code 0000 errors (matches AC1 of [US-ABRD456](../user-stories/US-ABRD456.md))
- `billing_kv.d.go` lines 125-134: `ValidateCodingRuleByPatientIdRequest` with `PatientId`, `Quarter`, `Year` and `ValidateCodingRuleByPatientIdResponse` with `Suggestions` including `DiagnoseSuggestionResponse` validates coding rules per patient per quarter (matches AC1 of [US-ABRD456](../user-stories/US-ABRD456.md))
- `billing_kv.d.go` lines 115-123: `DiagnoseSuggestionResponse` with `Code`, `Certainty`, `Description`, `Hint` provides actionable suggestions when codes like 0000 are missing (matches AC2 of [US-ABRD456](../user-stories/US-ABRD456.md))
- `billing_kv.d.go` lines 98-105: `ToggleResolveBillingErrorRequest`/`ToggleResolveBillingErrorResponse` allows marking errors as resolved after the user adds the missing code (matches AC2 of [US-ABRD456](../user-stories/US-ABRD456.md))

## Coverage
- Full Match: The billing_kv package implements KV billing validation with `Troubleshoot` and `GetError` operations that surface missing required service codes (including code 0000 for Arzt-Patienten-Kontakt), `ValidateCodingRuleByPatientId` that enforces coding rules per patient per quarter, and error resolution workflows. When code 0000 is present, the validation passes without prompts (AC2).
