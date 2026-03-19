## US-HI-6.1.9-03 — When a doctor documents eDMP HI treatment plan, HI-bezogene Ueberweisung must be recorded

| Field | Value |
|-------|-------|
| **ID** | US-HI-6.1.9-03 |
| **Traced from** | [HI-6.1.9-03](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-6.1.9-03.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document HI-related referrals (HI-bezogene Ueberweisung) in the treatment plan section, so that specialist referrals are recorded per the eDMP HI specification.

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the Behandlungsplanung section is displayed, then an HI-bezogene Ueberweisung field is available
2. Given a referral is documented, when the XML is generated, then the Ueberweisung value is encoded correctly
