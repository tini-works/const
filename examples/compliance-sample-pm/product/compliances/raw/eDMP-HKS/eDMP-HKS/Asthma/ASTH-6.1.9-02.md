## ASTH-6.1.9-02 — Behandlungsplanung must capture Dokumentationsintervall (Quartalsweise/Jedes zweite Quartal)

| Field | Value |
|-------|-------|
| **ID** | ASTH-6.1.9-02 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Section** | Sec 6.1.9 — Behandlungsplanung |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-ASTH-6.1.9-02](../../../../user-stories/eDMP_HKS/US-ASTH-6.1.9-02.md) |

### Requirement

As a practice doctor, I want to select the documentation interval (Dokumentationsintervall) as either Quartalsweise or Jedes zweite Quartal, so that the follow-up frequency is defined per eDMP Asthma treatment planning.

### Acceptance Criteria

1. Given an eDMP Asthma Behandlungsplanung section is displayed, when Dokumentationsintervall is presented, then exactly one of Quartalsweise or Jedes zweite Quartal must be selected
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised
