## US-ABRG619 — System must log all erroneous billing data with case, service,...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG619 |
| **Traced from** | [ABRG619](../compliances/SV/ABRG619.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want log all erroneous billing data with case, service, and rule references for audit, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given billing validation errors, when logged, then each error includes Fall-ID, Leistung, and violated rule reference
