## DEP-2.0-01 — When practice software generates eDMP Depression export file, naming must follow KBV XML-Schnittstellen convention

| Field | Value |
|-------|-------|
| **ID** | DEP-2.0-01 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Section** | Sec 2 — Dateinamenkonventionen |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | XML schema validation |
| **Matched by** | [US-DEP-2.0-01](../../../../../user-stories/eDMP_HKS/US-DEP-2.0-01.md) |

### Requirement

When practice software generates eDMP Depression export file, naming must follow KBV XML-Schnittstellen convention

### Acceptance Criteria

1. Given an eDMP Depression documentation is exported, when the file is created, then the filename follows the KBV XML-Schnittstellen naming pattern
2. Given a file with incorrect naming, when validation is run, then an error is reported before transmission
