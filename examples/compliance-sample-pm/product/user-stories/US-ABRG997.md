## US-ABRG997 — System must validate OPS codes against contract-specific catalog and reject...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG997 |
| **Traced from** | [ABRG997](../compliances/SV/ABRG997.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want validate OPS codes against contract-specific catalog and reject invalid codes, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given an OPS-Code in billing data, when it is not in the contract-specific Katalog, then validation rejects it
