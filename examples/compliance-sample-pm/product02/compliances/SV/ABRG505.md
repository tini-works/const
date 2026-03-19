## ABRG505 — System must verify diagnosis prerequisites for service P3 (code 0003)

| Field | Value |
|-------|-------|
| **ID** | ABRG505 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.2 ABRG — Billing Process |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-ABRG505](../../user-stories/US-ABRG505.md) |

### Requirement

System must verify diagnosis prerequisites for service P3 (code 0003)

### Acceptance Criteria

1. Given Leistung P3 (code 0003) documented, when diagnosis prerequisites are missing, then validation blocks billing
