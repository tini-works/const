## ABRD786 — Diagnosis marker 'Z' must not be used for acute diseases...

| Field | Value |
|-------|-------|
| **ID** | ABRD786 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a, BG-4 |
| **Verification Method** | Validator unit test |
| Matched by | [US-ABRD786](../../user-stories/US-ABRD786.md) |

### Requirement

Diagnosis marker 'Z' must not be used for acute diseases — system must warn

### Acceptance Criteria

1. Given a Diagnose with Zusatzkennzeichen 'Z' (Zustand nach), when the ICD-Code is classified as akut, then a warning is displayed
