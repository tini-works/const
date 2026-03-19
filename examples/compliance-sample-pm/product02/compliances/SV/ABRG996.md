## ABRG996 — System must flag missing mandatory OPS procedure codes in billing...

| Field | Value |
|-------|-------|
| **ID** | ABRG996 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.2 ABRG — Billing Process |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-ABRG996](../../user-stories/US-ABRG996.md) |

### Requirement

System must flag missing mandatory OPS procedure codes in billing cases requiring them

### Acceptance Criteria

1. Given a billing case requiring OPS, when OPS is missing, then validation flags a mandatory-OPS error
