## US-ABRD608 — Diagnoses must be documented per §295 SGB V

| Field | Value |
|-------|-------|
| **ID** | US-ABRD608 |
| **Traced from** | [ABRD608](../compliances/SV/ABRD608.md) |
| **Source** | AKA Q1-26-1, SGB V §295 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want diagnoses is documented per §295 SGB V, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Behandlungsfall, when Abrechnung is triggered, then at least one ICD-10-Diagnose per §295 SGB V is present

### Actual Acceptance Criteria

1. The `billing_kv.ValidateCodingRuleByPatientId` and `coding_rule.ValidateCodingRuleByPatientId` validate ICD-10 diagnosis presence per treatment case.
2. The `billing_kv.Troubleshoot` and `billing_kv.GetError` surface missing diagnosis errors.
3. The `coding_rule.GetIcdByCodes` validates ICD-10 codes against the catalog.
