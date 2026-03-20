# Matching: coding_rule

## File
`backend-core/app/app-core/api/coding_rule/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST543](../user-stories/US-VSST543.md) | HPM endpoints queried with Hauptkassen-IK | AC1 |
| [US-VSST1543](../user-stories/US-VSST1543.md) | AVWG including ARV | AC1 |
| [US-ABRD456](../user-stories/US-ABRD456.md) | Prompt to add code 0000 when missing | AC1 |

## Evidence
- `coding_rule.d.go` lines 108-112: `CodingRuleApp` interface defines `ValidateCodingRuleByPatientId`, `GetCodingRuleOverviewByQuarter`, and `GetIcdByCodes` providing coding rule validation and ICD lookup (matches AC1 of [US-ABRD456](../user-stories/US-ABRD456.md), AC1 of [US-VSST1543](../user-stories/US-VSST1543.md))
- `coding_rule.d.go` lines 38-43: `ValidateCodingRulesRequest` with `PatientId`, `Year`, `Quarter`, and `CheckTime` enables per-patient coding rule validation including AVWG rules (matches AC1 of [US-VSST1543](../user-stories/US-VSST1543.md), AC1 of [US-ABRD456](../user-stories/US-ABRD456.md))
- `coding_rule.d.go` lines 45-48: `ValidateCodingRulesResponse` with `PatientId` and `Suggestions` list of `CodingRuleSuggestion` returns actionable coding rule violation suggestions (matches AC1 of [US-ABRD456](../user-stories/US-ABRD456.md))
- `coding_rule.d.go` lines 50-53: `GetCodingRuleOverviewByQuarterRequest` with `Year`, `Quarter`, and `Pagination` provides quarterly coding rule overview for all patients (matches AC1 of [US-VSST1543](../user-stories/US-VSST1543.md))
- `coding_rule.d.go` lines 78-81: `GetCodingRuleOverviewByQuarterResponse` with `TotalPatient` and `Data` containing patient info and suggestions per patient (matches AC1 of [US-ABRD456](../user-stories/US-ABRD456.md))
- `coding_rule.d.go` lines 64-71: `CodingRuleOverviewSuggestion` with `RuleId`, `IcdCode`, `IcdCertainty`, `IcdDescription`, `Hint`, and `LastDocumentedDoctorId` provides detailed rule violation information (matches AC1 of [US-VSST1543](../user-stories/US-VSST1543.md))
- `coding_rule.d.go` lines 83-90: `GetIcdByCodesRequest`/`GetIcdByCodesResponse` with `Codes`, `SelectedDate`, and `IcdItems` validates ICD-10 codes against the catalog (matches AC1 of [US-VSST543](../user-stories/US-VSST543.md))

## Coverage
- Partial Match: The coding_rule package provides comprehensive coding rule validation including per-patient quarterly validation, ICD-10 code lookup, and coding rule overview. It directly supports the code 0000 prompt requirement ([US-ABRD456](../user-stories/US-ABRD456.md)) via ValidateCodingRuleByPatientId. The AVWG rule checking ([US-VSST1543](../user-stories/US-VSST1543.md)) is supported through the general coding rule validation framework, though the specific ARV inclusion needs service-layer verification. For [US-VSST543](../user-stories/US-VSST543.md), the ICD code validation is available but the specific HPM Hauptkassen-IK query mechanism is handled at the HPM integration layer, not this package.
