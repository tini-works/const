## US-DM1-6.1.9-03 — Practice doctor must document HbA1c-Zielwert as erreicht or noch nicht erreicht

| Field | Value |
|-------|-------|
| **ID** | US-DM1-6.1.9-03 |
| **Traced from** | [DM1-6.1.9-03](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-6.1.9-03.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether the HbA1c target has been reached (erreicht) or not yet reached (noch nicht erreicht) in the Behandlungsplanung section, so that HbA1c target achievement status is tracked for therapy evaluation.

### Acceptance Criteria

1. Given an eDMP DM1 Behandlungsplanung is documented, when HbA1c-Zielwert is recorded, then exactly one of erreicht or noch nicht erreicht is selected
2. Given no value is selected, when validated, then an error is reported
