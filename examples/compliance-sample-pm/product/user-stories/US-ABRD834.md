## US-ABRD834 — FAV service documentation must verify patient's active FAV participation before...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD834 |
| **Traced from** | [ABRD834](../compliances/SV/ABRD834.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want fAV service documentation verify patient's active FAV participation before allowing service entry, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Patient without active FAV-Teilnahme, when a FAV-Leistung is entered, then the system blocks entry with a participation error
