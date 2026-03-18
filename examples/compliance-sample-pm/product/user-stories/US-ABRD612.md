## US-ABRD612 — Confirmed diagnoses ('G') must be documented as terminal codes, not...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD612 |
| **Traced from** | [ABRD612](../compliances/SV/ABRD612.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want confirmed diagnoses ('G') is documented as terminal codes, not group codes, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a gesicherte Diagnose ('G'), when it is a Gruppencode, then validation rejects it and requests an Endstellencode
