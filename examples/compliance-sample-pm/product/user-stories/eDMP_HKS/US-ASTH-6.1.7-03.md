## US-ASTH-6.1.7-03 — Medikamente must capture Kurz wirksame inhalative Beta-2-Sympathomimetika (Bei Bedarf/Dauermedikation/Keine/Kontraindikation)

| Field | Value |
|-------|-------|
| **ID** | US-ASTH-6.1.7-03 |
| **Traced from** | [ASTH-6.1.7-03](../../compliances/raw/eDMP-HKS/eDMP-HKS/Asthma/ASTH-6.1.7-03.md) |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Kurz wirksame inhalative Beta-2-Sympathomimetika usage with options Bei Bedarf, Dauermedikation, Keine, or Kontraindikation, so that short-acting beta-agonist therapy is tracked per eDMP Asthma requirements.

### Acceptance Criteria

1. Given an eDMP Asthma Medikamente section is displayed, when Kurz wirksame inhalative Beta-2-Sympathomimetika is selected, then exactly one of Bei Bedarf, Dauermedikation, Keine, Kontraindikation must be chosen
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised
