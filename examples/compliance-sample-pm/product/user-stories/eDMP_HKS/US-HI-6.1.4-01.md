## US-HI-6.1.4-01 — When a doctor documents eDMP HI enrollment, Herzinsuffizienz-specific Einschreibung reason must be recorded

| Field | Value |
|-------|-------|
| **ID** | US-HI-6.1.4-01 |
| **Traced from** | [HI-6.1.4-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-6.1.4-01.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the enrollment reason specific to Herzinsuffizienz (Einschreibung wegen Herzinsuffizienz), so that the administrative section correctly reflects the HI-specific enrollment cause.

### Acceptance Criteria

1. Given a new eDMP HI documentation, when administrative data is entered, then Herzinsuffizienz-specific enrollment reasons are available for selection
2. Given an enrollment reason is selected, when the XML is generated, then the Einschreibung wegen field contains the HI-specific value
