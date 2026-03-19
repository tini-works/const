## ABRG670 — Patient birth dates must be captured enabling accurate age calculation...

| Field | Value |
|-------|-------|
| **ID** | ABRG670 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.2 ABRG — Billing Process |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-ABRG670](../../user-stories/US-ABRG670.md) |

### Requirement

Patient birth dates must be captured enabling accurate age calculation for age-dependent billing rules

### Acceptance Criteria

1. Given a Patient with Geburtsdatum, when age-dependent billing rules are evaluated, then age is calculated correctly from the birth date
