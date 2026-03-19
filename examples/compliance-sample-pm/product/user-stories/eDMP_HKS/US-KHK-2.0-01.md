## US-KHK-2.0-01 — When practice software generates eDMP KHK export file, naming must follow KBV XML-Schnittstellen convention

| Field | Value |
|-------|-------|
| **ID** | US-KHK-2.0-01 |
| **Traced from** | [KHK-2.0-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-2.0-01.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to generate eDMP KHK export files with naming conventions per KBV XML-Schnittstellen, so that files are accepted by the KBV infrastructure without rejection.

### Acceptance Criteria

1. Given an eDMP KHK documentation is exported, when the file is created, then the filename follows the KBV XML-Schnittstellen naming pattern
2. Given a file with incorrect naming, when validation is run, then an error is reported before transmission
