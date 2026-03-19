## ABRG617 — Substitute doctor services must be correctly attributed while maintaining primary...

| Field | Value |
|-------|-------|
| **ID** | ABRG617 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.2 ABRG — Billing Process |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-ABRG617](../../user-stories/US-ABRG617.md) |

### Requirement

Substitute doctor services must be correctly attributed while maintaining primary care relationship

### Acceptance Criteria

1. Given a Vertreterarzt documenting services, when billing is generated, then services are attributed to the Vertreter while the Stammpraxis relationship is maintained
