# UnMatching: versioninfor

## File
`backend-core/app/app-core/api/versioninfor/`

## Analysis
- **What this code does**: Provides an API for retrieving version information about the system's components. Returns version data for master data catalogs, medication database, HPM (Healthcare Provider Module), XPM, and XKM modules. Also supports querying the current version by document/master data type and checking whether the HPM version is valid.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-VERSIONINFOR — System Component Version Information

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-VERSIONINFOR |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5=Practice Software Core |
| **Data Entity** | VersionInformation, HpmVersion, XpmVersion, XkmVersion, MasterData VersionInfo, Medication VersionInfo |

### User Story
As a care provider member, I want to view version information for all system components (master data catalogs, medication database, HPM, XPM, XKM), so that I can verify my system is running current and compatible versions.

### Acceptance Criteria
1. Given an authenticated care provider member, when they request version information for a BSNR, then versions for master data, medication, HPM, XPM, and XKM are returned
2. Given an authenticated user, when they query the current version by master data document type, then the version string, validity, year, quarter, and version number are returned
3. Given an authenticated user, when they check HPM version validity, then a boolean indicating whether the HPM version is valid is returned

### Technical Notes
- Source: `backend-core/app/app-core/api/versioninfor/`
- Key functions: GetVersionInformation, GetCurrentVersionByDocumentType, CheckValidHpmVersion
- Integration points: master_data_common, medicine_common, version_info/common services via NATS RPC

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 7.4 KBV Master Data Files | [`compliances/phase-7.4-kbv-master-data-files.md`](../../compliances/phase-7.4-kbv-master-data-files.md) | P6-20, P6-100, P6-700 |
| 7.5 Validation & Crypto Modules | [`compliances/phase-7.5-validation-crypto-modules.md`](../../compliances/phase-7.5-validation-crypto-modules.md) | P5-10 |

### Compliance Mapping

#### 7.4 KBV Master Data Files
**Source**: [`compliances/phase-7.4-kbv-master-data-files.md`](../../compliances/phase-7.4-kbv-master-data-files.md)

**Related Requirements**:
- "The currently valid cost carrier master data file (KT-Stammdatei) must be deployed in connection with the quarterly billing and the printing of statutory physician forms." (P6-20)
- "Mandatory deployment of the KV-specific master data file — the current SDKV must be available in time for the start of each quarter." (P6-100)
- "Mandatory deployment of the SDEBM — the user must have access to the current EBM data foundation in time for the start of each quarter." (P6-700)

#### 7.5 Validation & Crypto Modules
**Source**: [`compliances/phase-7.5-validation-crypto-modules.md`](../../compliances/phase-7.5-validation-crypto-modules.md)

**Related Requirements**:
- "Through appropriate organizational measures, it must be ensured that users can deploy the current KVDT validation module (XPM) and KBV crypto module (XKM) in a timely manner." (P5-10)

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Given an authenticated care provider member, when they request version information for a BSNR, then versions for master data, medication, HPM, XPM, and XKM are returned | P6-20/P6-100/P6-700: Quarterly deployment requirements for SDKT, SDKV, SDEBM — version info enables verification of current deployment |
| AC2: Given an authenticated user, when they query the current version by master data document type, then the version string, validity, year, quarter, and version number are returned | P5-10: "users can deploy the current KVDT validation module (XPM) and KBV crypto module (XKM) in a timely manner" — version tracking supports timely deployment verification |
| AC3: Given an authenticated user, when they check HPM version validity, then a boolean indicating whether the HPM version is valid is returned | P5-10: Ensuring current module versions are deployed |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
