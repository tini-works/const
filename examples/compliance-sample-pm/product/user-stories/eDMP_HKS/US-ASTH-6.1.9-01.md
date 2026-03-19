## US-ASTH-6.1.9-01 — Behandlungsplanung must capture Informationsangebote multi-select (Tabakverzicht/Ernaehrungsberatung/Koerperliches Training)

| Field | Value |
|-------|-------|
| **ID** | US-ASTH-6.1.9-01 |
| **Traced from** | [ASTH-6.1.9-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Asthma/ASTH-6.1.9-01.md) |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to select recommended information services (Informationsangebote) from a multi-select list including Tabakverzicht, Ernaehrungsberatung, and Koerperliches Training, so that patient counseling is documented per eDMP Asthma requirements.

### Acceptance Criteria

1. Given an eDMP Asthma Behandlungsplanung section is displayed, when Informationsangebote is presented, then multiple values can be selected from Tabakverzicht, Ernaehrungsberatung, Koerperliches Training
2. Given at least one information offer applies, when selected, then the values are correctly encoded in the XML export
