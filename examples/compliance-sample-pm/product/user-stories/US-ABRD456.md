## US-ABRD456 — When a doctor documents services without code 0000 (Arzt-Patienten-Kontakt), system...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD456 |
| **Traced from** | [ABRD456](../compliances/SV/ABRD456.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want when I documents services without code 0000 (Arzt-Patienten-Kontakt), system prompt to add it, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given Leistungen without code 0000 in a Quartal, when Abrechnung is triggered, then a prompt to add code 0000 is displayed
2. Given code 0000 is present, then no prompt appears
