## US-ASTH-6.1.5-02 — Anamnese must capture Blutdruck systolisch and diastolisch in mmHg

| Field | Value |
|-------|-------|
| **ID** | US-ASTH-6.1.5-02 |
| **Traced from** | [ASTH-6.1.5-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/Asthma/ASTH-6.1.5-02.md) |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Blutdruck systolisch and diastolisch values in mmHg in the Anamnese section, so that blood pressure is recorded as required by the eDMP Asthma specification.

### Acceptance Criteria

1. Given an eDMP Asthma documentation is opened, when Anamnese is entered, then fields for systolisch and diastolisch Blutdruck in mmHg are available
2. Given systolisch is less than diastolisch, when saved, then a plausibility warning is displayed
