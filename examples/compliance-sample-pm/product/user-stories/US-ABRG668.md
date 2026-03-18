## US-ABRG668 — System must flag diagnoses that lack required specificity or terminal...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG668 |
| **Traced from** | [ABRG668](../compliances/SV/ABRG668.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want flag diagnoses that lack required specificity or terminal ICD codes, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given a non-terminal ICD-Code in billing data, when validation runs, then it is flagged as insufficiently specific
