## US-ASTH-2.0-01 — Practice software must generate eDMP Asthma export files following KBV XML-Schnittstellen naming pattern

| Field | Value |
|-------|-------|
| **ID** | US-ASTH-2.0-01 |
| **Traced from** | [ASTH-2.0-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Asthma/ASTH-2.0-01.md) |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to generate eDMP Asthma export files with file names conforming to the KBV XML-Schnittstellen naming convention, so that the files are correctly identified and processed by the KBV infrastructure.

### Acceptance Criteria

1. Given an eDMP Asthma documentation is exported, when the file is created, then the file name follows the KBV XML-Schnittstellen naming pattern
2. Given a non-conforming file name, when the export is validated, then an error is raised before transmission
