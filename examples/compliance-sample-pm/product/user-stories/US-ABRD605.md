## US-ABRD605 — Service documentation is only permitted when the patient has active...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD605 |
| **Traced from** | [ABRD605](../compliances/SV/ABRD605.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want service documentation is only permitted when the patient has active contract participation status, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Patient without active Teilnahmestatus, when a Selektivvertrag-Leistung is entered, then the system blocks the entry
