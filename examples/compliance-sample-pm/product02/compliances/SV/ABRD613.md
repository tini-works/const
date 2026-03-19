## ABRD613 — Substitute value "UUU" must only be allowed with specific order...

| Field | Value |
|-------|-------|
| **ID** | ABRD613 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a, BG-4 |
| **Verification Method** | Validator unit test |
| Matched by | [US-ABRD613](../../user-stories/US-ABRD613.md) |

### Requirement

Substitute value "UUU" must only be allowed with specific order services

### Acceptance Criteria

1. Given Diagnose "UUU" entered, when the associated Leistung is not an Auftragsleistung, then validation rejects the entry
