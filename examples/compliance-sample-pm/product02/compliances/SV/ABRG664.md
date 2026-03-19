## ABRG664 — System must warn when billing services older than 4 quarters...

| Field | Value |
|-------|-------|
| **ID** | ABRG664 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.2 ABRG — Billing Process |
| **Status** | TBC |
| **Goals** | BG-2 |
| **Verification Method** | Integration test (API) |
| Matched by | [US-ABRG664](../../user-stories/US-ABRG664.md) |

### Requirement

System must warn when billing services older than 4 quarters (beyond late-submission window)

### Acceptance Criteria

1. Given Leistungen older than 4 Quartale, when billing is attempted, then a Nachreichungsfrist warning is displayed
