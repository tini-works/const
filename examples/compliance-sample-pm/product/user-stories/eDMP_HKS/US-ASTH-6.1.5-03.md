## US-ASTH-6.1.5-03 — Anamnese must capture Begleiterkrankungen as multi-select (Keine/Adipositas/Allergische Rhinitis/Konjunktivitis/Andere)

| Field | Value |
|-------|-------|
| **ID** | US-ASTH-6.1.5-03 |
| **Traced from** | [ASTH-6.1.5-03](../../compliances/raw/eDMP-HKS/eDMP-HKS/Asthma/ASTH-6.1.5-03.md) |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to select Begleiterkrankungen from a multi-select list (Keine, Adipositas, Allergische Rhinitis, Konjunktivitis, Andere) in the Anamnese section, so that comorbidities are documented per eDMP Asthma requirements.

### Acceptance Criteria

1. Given an eDMP Asthma Anamnese form is displayed, when Begleiterkrankungen is selected, then multiple values can be chosen from Keine, Adipositas, Allergische Rhinitis, Konjunktivitis, Andere
2. Given "Keine" is selected, when another comorbidity is also selected, then a validation error is raised
