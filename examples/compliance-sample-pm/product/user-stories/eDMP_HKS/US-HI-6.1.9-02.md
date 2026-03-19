## US-HI-6.1.9-02 — When a doctor documents eDMP HI treatment plan, Informationsangebote must be recorded

| Field | Value |
|-------|-------|
| **ID** | US-HI-6.1.9-02 |
| **Traced from** | [HI-6.1.9-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-6.1.9-02.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Informationsangebote in the HI treatment plan section, so that patient information offerings are recorded per the eDMP HI specification.

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the Behandlungsplanung section is displayed, then an Informationsangebote field is available
2. Given information offerings are documented, when the XML is generated, then the values are encoded correctly
