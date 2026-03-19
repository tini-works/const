## rvsa — Proficiency Test Certificates

| Field | Value |
|-------|-------|
| **Satzart** | rvsa |
| **German Name** | Ringversuchszertifikate |
| **Source** | KVDT-DSB v6.02 |
| **Section** | 2.2.4 Satzart: Ringversuchszertifikate "rvsa" |
| **Data Package** | Container |
| **Refer** | [con0](con0.md), [con9](con9.md), [besa](besa.md), [container-feldtabelle](container-feldtabelle.md), [container-regeltabelle](container-regeltabelle.md) |

### Purpose

The Proficiency Test Certificates record documents information about proficiency testing (ring trial / Ringversuch) certificates for laboratory services billed within the practice site. It records whether the practice site bills certificate-mandatory laboratory services, details on pnSD/uu analyses, device types, manufacturers, analyte IDs, and the proficiency test certificate status. This record must be present if an ADT data package is contained in the KVDT file (provided it is not exclusively a hospital billing in the context of ASV billing).

**Note:** In the context of KVDT billing, only proficiency test certificates per Chapter B1 of the Federal Medical Association guideline ("Quantitative Untersuchungen", see [BAEK_Rili_Labormedizin]), which correspond to the values of the key table "S_NVV_RV_ZERTIFIKAT", are to be documented.

Further proficiency-test-mandatory analyses (e.g., per Chapter B2 of the above guideline) are not subject to documentation via the KVDT/RVSA data record.

### Ordering Rules

Record "rvsa" may be present once per file. It must be stored as the third record (after [besa](besa.md)), provided the data package "Hybrid-DRG" is not contained in the billing file.

### Field Table (Satztabelle)

The rvsa record has a 5-level hierarchy. The "Occ" column shows the hierarchy level and occurrence count.

| FK | Occ | Field Name | Type | Condition | Notes |
|----|-----|-----------|------|-----------|-------|
| 8000 | L1=1 | Record type | m | Regel 743 | Record type Proficiency Test Certificates |
| 0201 | L1=n | (N)BSNR | M | | |
| 0300 | L2=1 | Billing of (certificate-mandatory) laboratory services | m | | Information on billing of laboratory services within the practice site |
| 0301 | L3=1 | pnSD/uu analyses | m | Regel 740 | Information on unit-use usage |
| 0302 | L3=n | Device type | m | Regel 741, Regel 748 | |
| 0303 | L4=1 | Manufacturer | m | | |
| 0304 | L3=n | Analyte ID | m | Regel 740 | |
| 0305 | L4=1 | Proficiency test certificate | m | | |
