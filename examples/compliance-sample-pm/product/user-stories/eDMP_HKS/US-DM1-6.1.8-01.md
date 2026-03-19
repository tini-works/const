## US-DM1-6.1.8-01 — Practice doctor must document empfohlene Schulungen as multi-select in the Schulung section

| Field | Value |
|-------|-------|
| **ID** | US-DM1-6.1.8-01 |
| **Traced from** | [DM1-6.1.8-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-6.1.8-01.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document empfohlene Schulungen selecting from Keine, Diabetes-Schulung, or Hypertonie-Schulung in the Schulung section, so that recommended patient education programmes are recorded for care planning.

### Acceptance Criteria

1. Given an eDMP DM1 Schulung section is documented, when empfohlene Schulung is recorded, then one or more of Keine, Diabetes-Schulung, or Hypertonie-Schulung is selected
2. Given "Keine" is selected together with a specific Schulung, when validated, then an error is reported
