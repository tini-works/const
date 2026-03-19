## US-DEP-2.0-01 — When practice software generates eDMP Depression export file, naming must follow KBV XML-Schnittstellen convention

| Field | Value |
|-------|-------|
| **ID** | US-DEP-2.0-01 |
| **Traced from** | [DEP-2.0-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Depression/DEP-2.0-01.md) |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to generate eDMP Depression export files with naming conventions per KBV XML-Schnittstellen, so that files are accepted by the KBV infrastructure without rejection.

### Acceptance Criteria

1. Given an eDMP Depression documentation is exported, when the file is created, then the filename follows the KBV XML-Schnittstellen naming pattern
2. Given a file with incorrect naming, when validation is run, then an error is reported before transmission
