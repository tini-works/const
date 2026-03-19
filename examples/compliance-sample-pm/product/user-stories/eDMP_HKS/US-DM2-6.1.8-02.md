## US-DM2-6.1.8-02 — Practice doctor must document Schulung vor Einschreibung wahrgenommen in the Schulung section

| Field | Value |
|-------|-------|
| **ID** | US-DM2-6.1.8-02 |
| **Traced from** | [DM2-6.1.8-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-6.1.8-02.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document which Schulungen were attended before enrollment selecting from Keine, Diabetes-Schulung, or Hypertonie-Schulung, so that prior patient education history is captured at enrollment time.

### Acceptance Criteria

1. Given an eDMP DM2 Schulung section is documented, when Schulung vor Einschreibung wahrgenommen is recorded, then one or more of Keine, Diabetes-Schulung, or Hypertonie-Schulung is selected
2. Given "Keine" is selected together with a specific Schulung, when validated, then an error is reported
