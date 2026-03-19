## DEP-6.1.7-01 — When a doctor documents eDMP Depression medication, Antidepressiva fields must be captured

| Field | Value |
|-------|-------|
| **ID** | DEP-6.1.7-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Section** | Sec 6.1.7 — Medikamente |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-DEP-6.1.7-01](../../../../../user-stories/eDMP_HKS/US-DEP-6.1.7-01.md) |

### Requirement

When a doctor documents eDMP Depression medication, Antidepressiva fields must be captured

### Acceptance Criteria

1. Given an eDMP Depression documentation form, when the medication section is displayed, then Antidepressiva-specific fields are available
2. Given Antidepressiva data is entered, when the XML is generated, then the medication values are encoded in the correct Depression-specific elements
