## ABRG616 — System must prevent billing of services that fail HPM validation;...

| Field | Value |
|-------|-------|
| **ID** | ABRG616 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.2 ABRG — Billing Process |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-ABRG616](../../user-stories/US-ABRG616.md) |

### Requirement

System must prevent billing of services that fail HPM validation; invalid services must be corrected

### Acceptance Criteria

1. Given HPM validation returning errors, when the user attempts submission, then billing is blocked until errors are corrected
