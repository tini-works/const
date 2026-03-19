## COPD-2.0-01 — Practice software must generate eDMP COPD export files following KBV XML-Schnittstellen naming pattern

| Field | Value |
|-------|-------|
| **ID** | COPD-2.0-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Section** | Sec 2 — Dateinamenkonventionen |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | XML schema validation |
| **Matched by** | [US-COPD-2.0-01](../../../../../user-stories/eDMP_HKS/US-COPD-2.0-01.md) |

### Requirement

As a practice software, I want to generate eDMP COPD export files with file names conforming to the KBV XML-Schnittstellen naming convention, so that the files are correctly identified and processed by the KBV infrastructure.

### Acceptance Criteria

1. Given an eDMP COPD documentation is exported, when the file is created, then the file name follows the KBV XML-Schnittstellen naming pattern
2. Given a non-conforming file name, when the export is validated, then an error is raised before transmission
