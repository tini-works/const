## ABRG490 — Transmitted billing data must be marked as transmitted

| Field | Value |
|-------|-------|
| **ID** | ABRG490 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.2 ABRG — Billing Process |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-ABRG490](../../user-stories/US-ABRG490.md) |

### Requirement

Transmitted billing data must be marked as transmitted

### Acceptance Criteria

1. Given successful Abrechnungsübertragung, when the process completes, then all transmitted records are marked with Übertragungsstatus
