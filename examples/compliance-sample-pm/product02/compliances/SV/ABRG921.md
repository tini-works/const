## ABRG921 — Preventive case billing must automatically add billing code 80092.2

| Field | Value |
|-------|-------|
| **ID** | ABRG921 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.2 ABRG — Billing Process |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-ABRG921](../../user-stories/US-ABRG921.md) |

### Requirement

Preventive case billing must automatically add billing code 80092.2

### Acceptance Criteria

1. Given a Vorsorge-Behandlungsfall, when billing is generated, then code 80092.2 is automatically added
