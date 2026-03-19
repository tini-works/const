## US-ABRD679 — ICD-10 validity must be checked against current catalog

| Field | Value |
|-------|-------|
| **ID** | US-ABRD679 |
| **Traced from** | [ABRD679](../compliances/SV/ABRD679.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want iCD-10 validity is checked against current catalog, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given an ICD-10-Code entered, when it is not in the current Katalogversion, then a validation error is displayed

### Actual Acceptance Criteria

1. The `coding_rule.GetIcdByCodes` validates ICD-10 codes against the current catalog.
2. The `coding_rule.ValidateCodingRuleByPatientId` enforces catalog validity.
3. The timeline validation engine checks ICD-10 validity during entry.
