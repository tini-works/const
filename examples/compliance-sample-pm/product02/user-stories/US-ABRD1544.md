## US-ABRD1544 — System must warn when a specialty contract service is billed...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD1544 |
| **Traced from** | [ABRD1544](../compliances/SV/ABRD1544.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want warn when a specialty contract service is billed without a referral doctor (AOK/BKK BW), so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a FAV-Leistung (AOK/BKK BW) without Überweiser, when billing validation runs, then a warning about missing referral is shown

### Actual Acceptance Criteria

1. Implemented -- `ABRD1544Validator` warns on missing referral for AOK/BKK BW contracts.
