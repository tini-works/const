## US-ABRD611 — System must inform users during diagnosis entry when a more...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD611 |
| **Traced from** | [ABRD611](../compliances/SV/ABRD611.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E1: Billing Documentation](../epics/E1-billing-documentation.md) |
| **Data Entity** | DX |

### User Story

As a practice doctor, I want inform users during diagnosis entry when a more specific ICD-10 terminal code is available, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a non-terminal ICD-10-Code entered, when a more specific Endstellencode exists, then the system displays a specificity hint

### Actual Acceptance Criteria

1. The `coding_rule.GetIcdByCodes` retrieves ICD-10 details including hierarchy for non-terminal code detection.
2. The timeline validation engine enforces ICD-10 specificity checks.
3. The `coding_rule.GetCodingRuleOverviewByQuarter` includes terminal code requirements.
