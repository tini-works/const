## COPD-6.1.7-03 — Medikamente must capture Lang wirksame Anticholinergika

| Field | Value |
|-------|-------|
| **ID** | COPD-6.1.7-03 |
| **Type** | Mandatory |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Section** | Sec 6.1.7 — Medikamente |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-COPD-6.1.7-03](../../../../user-stories/eDMP_HKS/US-COPD-6.1.7-03.md) |

### Requirement

As a practice doctor, I want to document Lang wirksame Anticholinergika usage with the defined value options, so that long-acting anticholinergic therapy is tracked per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD Medikamente section is displayed, when Lang wirksame Anticholinergika is presented, then exactly one valid option must be chosen
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised
