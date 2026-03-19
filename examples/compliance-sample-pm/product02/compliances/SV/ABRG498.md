## ABRG498 — Billing data must include the accident indicator (Unfallkennzeichen) when work...

| Field | Value |
|-------|-------|
| **ID** | ABRG498 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.2 ABRG — Billing Process |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-ABRG498](../../user-stories/US-ABRG498.md) |

### Requirement

Billing data must include the accident indicator (Unfallkennzeichen) when work accidents apply

### Acceptance Criteria

1. Given a Behandlungsfall with Arbeitsunfall, when billing is generated, then Unfallkennzeichen is included in the data
