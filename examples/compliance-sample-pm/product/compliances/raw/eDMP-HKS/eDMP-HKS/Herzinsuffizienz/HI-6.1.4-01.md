## HI-6.1.4-01 — When a doctor documents eDMP HI enrollment, Herzinsuffizienz-specific Einschreibung reason must be recorded

| Field | Value |
|-------|-------|
| **ID** | HI-6.1.4-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Section** | Sec 6.1.4 — Administrative Daten |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-HI-6.1.4-01](../../../../../user-stories/eDMP_HKS/US-HI-6.1.4-01.md) |

### Requirement

When a doctor documents eDMP HI enrollment, Herzinsuffizienz-specific Einschreibung reason must be recorded

### Acceptance Criteria

1. Given a new eDMP HI documentation, when administrative data is entered, then Herzinsuffizienz-specific enrollment reasons are available for selection
2. Given an enrollment reason is selected, when the XML is generated, then the Einschreibung wegen field contains the HI-specific value
