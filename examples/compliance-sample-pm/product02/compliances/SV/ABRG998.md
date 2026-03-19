## ABRG998 — System must ensure billing data includes required material cost documentation...

| Field | Value |
|-------|-------|
| **ID** | ABRG998 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.2 ABRG — Billing Process |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-ABRG998](../../user-stories/US-ABRG998.md) |

### Requirement

System must ensure billing data includes required material cost documentation (Sachkosten)

### Acceptance Criteria

1. Given a Leistung with Sachkosten requirement, when material cost data is missing, then validation flags the omission
