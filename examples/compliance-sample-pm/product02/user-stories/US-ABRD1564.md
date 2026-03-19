## US-ABRD1564 — Age precondition must be validated per KV region rules

| Field | Value |
|-------|-------|
| **ID** | US-ABRD1564 |
| **Traced from** | [ABRD1564](../compliances/SV/ABRD1564.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want age precondition is validated per KV region rules, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Leistung with KV-regional age rules, when patient age is outside the allowed range, then validation blocks the service

### Actual Acceptance Criteria

1. Implemented -- `KvAbrd1564Validator` and `AgeValidator` enforce age-based billing rules for KV/SV.
