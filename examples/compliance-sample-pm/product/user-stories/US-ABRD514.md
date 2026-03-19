## US-ABRD514 — System must warn when an acute diagnosis is marked as...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD514 |
| **Traced from** | [ABRD514](../compliances/SV/ABRD514.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want warn when an acute diagnosis is marked as permanent, as this blocks chronic care flat-rate billing, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given an akute Diagnose being marked as Dauerdiagnose, when the user confirms, then a warning about Chronikerpauschale blocking is displayed

### Actual Acceptance Criteria

1. The timeline service provides diagnosis CRUD with a validation engine and suggestion rules that can flag diagnosis-related issues during entry.
2. The `coding_rule.ValidateCodingRuleByPatientId` operation validates coding rules per patient which may include diagnosis type vs. billing code compatibility checks.
3. No explicit dedicated warning for acute-to-permanent diagnosis conversion blocking Chronikerpauschale was found as a standalone API operation.
