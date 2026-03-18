## US-ABRD613 — Substitute value "UUU" must only be allowed with specific order...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD613 |
| **Traced from** | [ABRD613](../compliances/SV/ABRD613.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want substitute value "UUU" only be allowed with specific order services, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given Diagnose "UUU" entered, when the associated Leistung is not an Auftragsleistung, then validation rejects the entry
