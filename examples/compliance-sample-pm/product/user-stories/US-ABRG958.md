## US-ABRG958 — System must check pre-participation status before allowing billing

| Field | Value |
|-------|-------|
| **ID** | US-ABRG958 |
| **Traced from** | [ABRG958](../compliances/SV/ABRG958.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want check pre-participation status before allowing billing, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given a billing attempt for a Selektivvertrag, when Teilnahmestatus is not active, then billing is blocked
