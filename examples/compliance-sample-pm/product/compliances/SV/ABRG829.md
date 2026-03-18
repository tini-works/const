## ABRG829 — System must warn when KV services are billed for a...

| Field | Value |
|-------|-------|
| **ID** | ABRG829 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.2 ABRG — Billing Process |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-ABRG829](../../user-stories/US-ABRG829.md) |

### Requirement

System must warn when KV services are billed for a patient with active contract participation

### Acceptance Criteria

1. Given a Patient with active Selektivvertrag-Teilnahme, when KV-Leistungen are billed, then a warning about potential duplicate billing is shown
