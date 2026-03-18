## US-VSST977 — Instead of KBV AVWG P3-130 for OTC exception indication display...

| Field | Value |
|-------|-------|
| **ID** | US-VSST977 |
| **Traced from** | [VSST977](../compliances/SV/VSST977.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want instead of KBV AVWG P3-130 for OTC exception indication display per AM-RL Anlage I, the rule only apply to contract participants aged 18 and older, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given an OTC exception indication per AM-RL Anlage I, when the patient is a contract participant under 18, then the indication is not displayed
2. Given age 18+, then it is displayed
