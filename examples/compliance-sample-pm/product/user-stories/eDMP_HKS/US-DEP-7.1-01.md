## US-DEP-7.1-01 — When a doctor documents eDMP Depression follow-up, Depression-specific Verlauf fields must be captured

| Field | Value |
|-------|-------|
| **ID** | US-DEP-7.1-01 |
| **Traced from** | [DEP-7.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Depression/DEP-7.1-01.md) |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Depression-specific follow-up fields in the Verlauf section, so that the course of treatment is recorded per the eDMP Depression specification.

### Acceptance Criteria

1. Given an eDMP Depression documentation form, when the Verlauf section is displayed, then Depression-specific follow-up fields are available
2. Given follow-up data is entered, when the XML is generated, then the values are encoded in the correct Depression-specific elements
