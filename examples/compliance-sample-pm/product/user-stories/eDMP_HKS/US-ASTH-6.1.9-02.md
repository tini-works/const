## US-ASTH-6.1.9-02 — Behandlungsplanung must capture Dokumentationsintervall (Quartalsweise/Jedes zweite Quartal)

| Field | Value |
|-------|-------|
| **ID** | US-ASTH-6.1.9-02 |
| **Traced from** | [ASTH-6.1.9-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/Asthma/ASTH-6.1.9-02.md) |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to select the documentation interval (Dokumentationsintervall) as either Quartalsweise or Jedes zweite Quartal, so that the follow-up frequency is defined per eDMP Asthma treatment planning.

### Acceptance Criteria

1. Given an eDMP Asthma Behandlungsplanung section is displayed, when Dokumentationsintervall is presented, then exactly one of Quartalsweise or Jedes zweite Quartal must be selected
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised
