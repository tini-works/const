## ASTH-6.1.5-02 — Anamnese must capture Blutdruck systolisch and diastolisch in mmHg

| Field | Value |
|-------|-------|
| **ID** | ASTH-6.1.5-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Section** | Sec 6.1.5 — Anamnese- und Befunddaten |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-ASTH-6.1.5-02](../../../../user-stories/eDMP_HKS/US-ASTH-6.1.5-02.md) |

### Requirement

As a practice doctor, I want to document Blutdruck systolisch and diastolisch values in mmHg in the Anamnese section, so that blood pressure is recorded as required by the eDMP Asthma specification.

### Acceptance Criteria

1. Given an eDMP Asthma documentation is opened, when Anamnese is entered, then fields for systolisch and diastolisch Blutdruck in mmHg are available
2. Given systolisch is less than diastolisch, when saved, then a plausibility warning is displayed
