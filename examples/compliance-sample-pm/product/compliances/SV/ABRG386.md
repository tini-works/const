## ABRG386 — Offline billing via data carrier must be supported

| Field | Value |
|-------|-------|
| **ID** | ABRG386 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.2 ABRG — Billing Process |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-ABRG386](../../user-stories/US-ABRG386.md) |

### Requirement

Offline billing via data carrier must be supported

### Acceptance Criteria

1. Given no network connectivity, when billing is triggered via Datenträger export, then a valid billing file is generated on the carrier
