## US-ABRD887 — System must warn when the same diagnosis with certainty 'V'...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD887 |
| **Traced from** | [ABRD887](../compliances/SV/ABRD887.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E1: Billing Documentation](../epics/E1-billing-documentation.md) |
| **Data Entity** | DX, QTR |

### User Story

As a practice doctor, I want warn when the same diagnosis with certainty 'V' (suspected) appears across multiple quarters, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Verdachtsdiagnose ('V') present in 2+ consecutive Quartale, when the user opens the Diagnose, then a review warning is shown

### Actual Acceptance Criteria

1. The timeline service supports quarter grouping for cross-quarter diagnosis analysis.
2. The `coding_rule.GetCodingRuleOverviewByQuarter` provides quarterly compliance overview.
3. The `coding_rule.ValidateCodingRuleByPatientId` may include multi-quarter suspected diagnosis checks.
