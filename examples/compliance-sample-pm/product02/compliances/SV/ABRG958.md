## ABRG958 — System must check pre-participation status before allowing billing

| Field | Value |
|-------|-------|
| **ID** | ABRG958 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.2 ABRG — Billing Process |
| **Status** | TBC |
| **Goals** | BG-1a, BG-2 |
| **Verification Method** | Integration test (API) |
| Matched by | [US-ABRG958](../../user-stories/US-ABRG958.md) |

### Requirement

System must check pre-participation status before allowing billing

### Acceptance Criteria

1. Given a billing attempt for a Selektivvertrag, when Teilnahmestatus is not active, then billing is blocked
