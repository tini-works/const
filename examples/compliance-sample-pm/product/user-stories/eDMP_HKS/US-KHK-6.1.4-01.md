## US-KHK-6.1.4-01 — When a doctor documents eDMP KHK enrollment, KHK-specific Einschreibung reason must be recorded

| Field | Value |
|-------|-------|
| **ID** | US-KHK-6.1.4-01 |
| **Traced from** | [KHK-6.1.4-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-6.1.4-01.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the enrollment reason specific to KHK (Einschreibung wegen KHK), so that the administrative section correctly reflects the KHK-specific enrollment cause.

### Acceptance Criteria

1. Given a new eDMP KHK documentation, when administrative data is entered, then KHK-specific enrollment reasons are available for selection
2. Given an enrollment reason is selected, when the XML is generated, then the Einschreibung wegen field contains the KHK-specific value
