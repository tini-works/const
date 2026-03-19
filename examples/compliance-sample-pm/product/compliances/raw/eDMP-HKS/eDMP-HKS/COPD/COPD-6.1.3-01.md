## COPD-6.1.3-01 — Practice software must encode clinical data using sciphox:sciphox-ssu observation structure

| Field | Value |
|-------|-------|
| **ID** | COPD-6.1.3-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Section** | Sec 6.1.3 — Sciphox-SSU Observation |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | XML schema validation |
| **Matched by** | [US-COPD-6.1.3-01](../../../../../user-stories/eDMP_HKS/US-COPD-6.1.3-01.md) |

### Requirement

As a practice software, I want to encode all clinical data fields using the sciphox:sciphox-ssu observation structure, so that data values are machine-readable and conform to the eDMP COPD XML schema.

### Acceptance Criteria

1. Given clinical data is documented for eDMP COPD, when the XML is generated, then each data field is wrapped in a sciphox:sciphox-ssu observation element
2. Given the observation structure is missing or malformed, when validated, then an error is reported
