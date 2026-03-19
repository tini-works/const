## US-ABRD612 — Confirmed diagnoses ('G') must be documented as terminal codes, not...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD612 |
| **Traced from** | [ABRD612](../compliances/SV/ABRD612.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E1: Billing Documentation](../epics/E1-billing-documentation.md) |
| **Data Entity** | DX |

### User Story

As a practice doctor, I want confirmed diagnoses ('G') is documented as terminal codes, not group codes, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a gesicherte Diagnose ('G'), when it is a Gruppencode, then validation rejects it and requests an Endstellencode

### Actual Acceptance Criteria

1. The `coding_rule.ValidateCodingRuleByPatientId` enforces terminal code requirements for confirmed diagnoses.
2. The `coding_rule.GetIcdByCodes` provides metadata to distinguish group from terminal codes.
3. The `billing_kv.Troubleshoot` surfaces non-terminal code errors.
