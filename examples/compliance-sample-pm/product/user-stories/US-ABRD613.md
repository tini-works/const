## US-ABRD613 — Substitute value "UUU" must only be allowed with specific order...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD613 |
| **Traced from** | [ABRD613](../compliances/SV/ABRD613.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E1: Billing Documentation](../epics/E1-billing-documentation.md) |
| **Data Entity** | DX, SVC |

### User Story

As a practice doctor, I want substitute value "UUU" only be allowed with specific order services, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given Diagnose "UUU" entered, when the associated Leistung is not an Auftragsleistung, then validation rejects the entry

### Actual Acceptance Criteria

1. The `coding_rule.ValidateCodingRuleByPatientId` enforces restrictions on substitute diagnosis values like UUU.
2. The timeline validation engine checks diagnosis-service associations.
3. The `billing_kv.Troubleshoot` detects invalid UUU usage.
