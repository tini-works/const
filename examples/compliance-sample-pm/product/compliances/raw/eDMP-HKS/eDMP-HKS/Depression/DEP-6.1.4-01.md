## DEP-6.1.4-01 — When a doctor documents eDMP Depression enrollment, Depression-specific Einschreibung reason must be recorded

| Field | Value |
|-------|-------|
| **ID** | DEP-6.1.4-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Section** | Sec 6.1.4 — Administrative Daten |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-DEP-6.1.4-01](../../../../../user-stories/eDMP_HKS/US-DEP-6.1.4-01.md) |

### Requirement

When a doctor documents eDMP Depression enrollment, Depression-specific Einschreibung reason must be recorded

### Acceptance Criteria

1. Given a new eDMP Depression documentation, when administrative data is entered, then Depression-specific enrollment reasons are available for selection
2. Given an enrollment reason is selected, when the XML is generated, then the Einschreibung wegen field contains the Depression-specific value
