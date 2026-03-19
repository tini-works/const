## US-COPD-6.1.9-01 — Behandlungsplanung must capture Informationsangebote (Tabakverzicht/Ernaehrungsberatung/Koerperliches Training)

| Field | Value |
|-------|-------|
| **ID** | US-COPD-6.1.9-01 |
| **Traced from** | [COPD-6.1.9-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-6.1.9-01.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to select recommended information services (Informationsangebote) from a multi-select list including Tabakverzicht, Ernaehrungsberatung, and Koerperliches Training, so that patient counseling is documented per eDMP COPD requirements.

### Acceptance Criteria

1. Given an eDMP COPD Behandlungsplanung section is displayed, when Informationsangebote is presented, then multiple values can be selected from Tabakverzicht, Ernaehrungsberatung, Koerperliches Training
2. Given at least one information offer applies, when selected, then the values are correctly encoded in the XML export
