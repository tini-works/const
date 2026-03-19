## ABRG668 — System must flag diagnoses that lack required specificity or terminal...

| Field | Value |
|-------|-------|
| **ID** | ABRG668 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.2 ABRG — Billing Process |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-ABRG668](../../user-stories/US-ABRG668.md) |

### Requirement

System must flag diagnoses that lack required specificity or terminal ICD codes

### Acceptance Criteria

1. Given a non-terminal ICD-Code in billing data, when validation runs, then it is flagged as insufficiently specific
