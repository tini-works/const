## ABRD456 — When a doctor documents services without code 0000 (Arzt-Patienten-Kontakt), system must prompt to add it

| Field | Value |
|-------|-------|
| **ID** | ABRD456 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.1 ABRD — Billing Documentation |
| **Status** | TBC |
| **Goals** | BG-1a, BG-2 |
| **Verification Method** | Validator unit test |
| **Matched by** | [US-ABRD456](../../user-stories/US-ABRD456.md) |

### Requirement

When a doctor documents services without code 0000 (Arzt-Patienten-Kontakt), system must prompt to add it

### Acceptance Criteria

1. Given Leistungen without code 0000 in a Quartal, when Abrechnung is triggered, then a prompt to add code 0000 is displayed
2. Given code 0000 is present, then no prompt appears
