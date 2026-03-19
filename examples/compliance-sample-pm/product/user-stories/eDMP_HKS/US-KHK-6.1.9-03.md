## US-KHK-6.1.9-03 — When a doctor documents eDMP KHK treatment plan, KHK-bezogene Ueberweisung must be recorded

| Field | Value |
|-------|-------|
| **ID** | US-KHK-6.1.9-03 |
| **Traced from** | [KHK-6.1.9-03](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-6.1.9-03.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document KHK-related referrals (KHK-bezogene Ueberweisung) in the treatment plan section, so that specialist referrals are recorded per the eDMP KHK specification.

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the Behandlungsplanung section is displayed, then a KHK-bezogene Ueberweisung field is available
2. Given a referral is documented, when the XML is generated, then the Ueberweisung value is encoded correctly
