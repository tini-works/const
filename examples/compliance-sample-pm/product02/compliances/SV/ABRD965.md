## ABRD965 — Disease pattern check (Krankheitsbildprüfung) must be available via HPM validation...

| Field | Value |
|-------|-------|
| **ID** | ABRD965 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-ABRD965](../../user-stories/US-ABRD965.md) |

### Requirement

Disease pattern check (Krankheitsbildprüfung) must be available via HPM validation module

### Acceptance Criteria

1. Given a Behandlungsfall, when Krankheitsbildprüfung is triggered via HPM, then the validation result (pass/fail with reasons) is displayed
