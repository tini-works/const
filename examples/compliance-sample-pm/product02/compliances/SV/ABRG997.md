## ABRG997 — System must validate OPS codes against contract-specific catalog and reject...

| Field | Value |
|-------|-------|
| **ID** | ABRG997 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.2 ABRG — Billing Process |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-ABRG997](../../user-stories/US-ABRG997.md) |

### Requirement

System must validate OPS codes against contract-specific catalog and reject invalid codes

### Acceptance Criteria

1. Given an OPS-Code in billing data, when it is not in the contract-specific Katalog, then validation rejects it
