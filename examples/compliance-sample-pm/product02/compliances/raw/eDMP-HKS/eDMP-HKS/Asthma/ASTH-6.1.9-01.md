## ASTH-6.1.9-01 — Behandlungsplanung must capture Informationsangebote multi-select (Tabakverzicht/Ernaehrungsberatung/Koerperliches Training)

| Field | Value |
|-------|-------|
| **ID** | ASTH-6.1.9-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Section** | Sec 6.1.9 — Behandlungsplanung |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-ASTH-6.1.9-01](../../../../user-stories/eDMP_HKS/US-ASTH-6.1.9-01.md) |

### Requirement

As a practice doctor, I want to select recommended information services (Informationsangebote) from a multi-select list including Tabakverzicht, Ernaehrungsberatung, and Koerperliches Training, so that patient counseling is documented per eDMP Asthma requirements.

### Acceptance Criteria

1. Given an eDMP Asthma Behandlungsplanung section is displayed, when Informationsangebote is presented, then multiple values can be selected from Tabakverzicht, Ernaehrungsberatung, Koerperliches Training
2. Given at least one information offer applies, when selected, then the values are correctly encoded in the XML export
