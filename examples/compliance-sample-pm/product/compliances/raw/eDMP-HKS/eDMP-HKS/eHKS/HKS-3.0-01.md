## HKS-3.0-01 — Practice software must generate eHKS export files following KBV XML-Schnittstellen naming pattern

| Field | Value |
|-------|-------|
| **ID** | HKS-3.0-01 |
| **Type** | Mandatory |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Section** | Sec 3 -- Dokumenttypen |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eHKS Certification) |
| **Verification Method** | XML schema validation |
| **Matched by** | [US-HKS-3.0-01](../../../../user-stories/eDMP_HKS/US-HKS-3.0-01.md) |

### Requirement

As a practice software, I want to generate eHKS export files with file names conforming to the KBV XML-Schnittstellen naming convention, so that the files are correctly identified and processed by the KBV infrastructure.

### Acceptance Criteria

1. Given an eHKS documentation is exported, when the file is created, then the file name follows the KBV XML-Schnittstellen naming pattern
2. Given a non-conforming file name, when the export is validated, then an error is raised before transmission
