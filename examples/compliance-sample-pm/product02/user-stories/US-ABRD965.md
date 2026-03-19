## US-ABRD965 — Disease pattern check (Krankheitsbildprüfung) must be available via HPM validation...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD965 |
| **Traced from** | [ABRD965](../compliances/SV/ABRD965.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want disease pattern check (Krankheitsbildprüfung) is available via HPM validation module, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Behandlungsfall, when Krankheitsbildprüfung is triggered via HPM, then the validation result (pass/fail with reasons) is displayed

### Actual Acceptance Criteria

1. Implemented -- `billing.AnalyzeForP4Diseases` provides disease pattern analysis via HPM.
2. `patient_sidebar.GetP4ValidationReport` and `GetP4ValidationReportByQuarter` provide P4 results.
