## ASTH-6.1.5-03 — Anamnese must capture Begleiterkrankungen as multi-select (Keine/Adipositas/Allergische Rhinitis/Konjunktivitis/Andere)

| Field | Value |
|-------|-------|
| **ID** | ASTH-6.1.5-03 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Section** | Sec 6.1.5 — Anamnese- und Befunddaten |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-ASTH-6.1.5-03](../../../../../user-stories/eDMP_HKS/US-ASTH-6.1.5-03.md) |

### Requirement

As a practice doctor, I want to select Begleiterkrankungen from a multi-select list (Keine, Adipositas, Allergische Rhinitis, Konjunktivitis, Andere) in the Anamnese section, so that comorbidities are documented per eDMP Asthma requirements.

### Acceptance Criteria

1. Given an eDMP Asthma Anamnese form is displayed, when Begleiterkrankungen is selected, then multiple values can be chosen from Keine, Adipositas, Allergische Rhinitis, Konjunktivitis, Andere
2. Given "Keine" is selected, when another comorbidity is also selected, then a validation error is raised
