## BK-2.0-01 — Practice software must generate eDMP Brustkrebs export files following KBV XML-Schnittstellen naming pattern

| Field | Value |
|-------|-------|
| **ID** | BK-2.0-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Section** | Sec 2 -- Dateinamen |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | XML schema validation |
| **Matched by** | [US-BK-2.0-01](../../../../user-stories/eDMP_HKS/US-BK-2.0-01.md) |

### Requirement

As a practice software, I want to generate eDMP Brustkrebs export files with file names conforming to the KBV XML-Schnittstellen naming convention, so that the files are correctly identified and processed by the KBV infrastructure.

### Acceptance Criteria

1. Given an eDMP Brustkrebs documentation is exported, when the file is created, then the file name follows the KBV XML-Schnittstellen naming pattern
2. Given a non-conforming file name, when the export is validated, then an error is raised before transmission
