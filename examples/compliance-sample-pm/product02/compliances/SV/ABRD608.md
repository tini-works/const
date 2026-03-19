## ABRD608 — Diagnoses must be documented per §295 SGB V

| Field | Value |
|-------|-------|
| **ID** | ABRD608 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1, SGB V §295 |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-ABRD608](../../user-stories/US-ABRD608.md) |

### Requirement

Diagnoses must be documented per §295 SGB V

### Acceptance Criteria

1. Given a Behandlungsfall, when Abrechnung is triggered, then at least one ICD-10-Diagnose per §295 SGB V is present
