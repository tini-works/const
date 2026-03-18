## US-ABRG498 — Billing data must include the accident indicator (Unfallkennzeichen) when work...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG498 |
| **Traced from** | [ABRG498](../compliances/SV/ABRG498.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want billing data include the accident indicator (Unfallkennzeichen) when work accidents apply, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given a Behandlungsfall with Arbeitsunfall, when billing is generated, then Unfallkennzeichen is included in the data
