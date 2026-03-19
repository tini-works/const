## US-HI-6.1.7-02 — When a doctor documents eDMP HI medication, Betablocker status must be captured

| Field | Value |
|-------|-------|
| **ID** | US-HI-6.1.7-02 |
| **Traced from** | [HI-6.1.7-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-6.1.7-02.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Betablocker medication status in the HI medication section, so that beta-blocker therapy is recorded per the eDMP HI specification.

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the medication section is displayed, then a Betablocker field is available
2. Given a selection is made, when the XML is generated, then the Betablocker value is encoded correctly
