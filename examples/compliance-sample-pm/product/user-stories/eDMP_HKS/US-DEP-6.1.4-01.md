## US-DEP-6.1.4-01 — When a doctor documents eDMP Depression enrollment, Depression-specific Einschreibung reason must be recorded

| Field | Value |
|-------|-------|
| **ID** | US-DEP-6.1.4-01 |
| **Traced from** | [DEP-6.1.4-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Depression/DEP-6.1.4-01.md) |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document the enrollment reason specific to Depression (Einschreibung wegen Depression), so that the administrative section correctly reflects the Depression-specific enrollment cause.

### Acceptance Criteria

1. Given a new eDMP Depression documentation, when administrative data is entered, then Depression-specific enrollment reasons are available for selection
2. Given an enrollment reason is selected, when the XML is generated, then the Einschreibung wegen field contains the Depression-specific value
