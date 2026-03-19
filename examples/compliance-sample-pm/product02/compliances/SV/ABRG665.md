## ABRG665 — System must ensure all diagnosed conditions are included in billing...

| Field | Value |
|-------|-------|
| **ID** | ABRG665 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.2 ABRG — Billing Process |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-ABRG665](../../user-stories/US-ABRG665.md) |

### Requirement

System must ensure all diagnosed conditions are included in billing cases

### Acceptance Criteria

1. Given a Behandlungsfall with documented Diagnosen, when billing is generated, then all Diagnosen are included in the Abrechnungsfall
