## US-ABRD786 — Diagnosis marker 'Z' must not be used for acute diseases...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD786 |
| **Traced from** | [ABRD786](../compliances/SV/ABRD786.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want diagnosis marker 'Z' not be used for acute diseases — system warn, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Diagnose with Zusatzkennzeichen 'Z' (Zustand nach), when the ICD-Code is classified as akut, then a warning is displayed

### Actual Acceptance Criteria

1. The timeline validation engine enforces diagnosis marker compatibility with disease classification.
2. The `coding_rule.ValidateCodingRuleByPatientId` validates marker/diagnosis type consistency.
3. The `coding_rule.GetIcdByCodes` provides classification metadata for marker validation.
