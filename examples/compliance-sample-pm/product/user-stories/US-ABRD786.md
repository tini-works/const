## US-ABRD786 — Diagnosis marker 'Z' must not be used for acute diseases...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD786 |
| **Traced from** | [ABRD786](../compliances/SV/ABRD786.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want diagnosis marker 'Z' not be used for acute diseases — system warn, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Diagnose with Zusatzkennzeichen 'Z' (Zustand nach), when the ICD-Code is classified as akut, then a warning is displayed
