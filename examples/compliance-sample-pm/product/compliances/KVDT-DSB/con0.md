## con0 — Container Header

| Field | Value |
|-------|-------|
| **Satzart** | con0 |
| **German Name** | Container-Header |
| **Source** | KVDT-DSB v6.02 |
| **Section** | 2.2.1 Satzart: Container-Header "con0" |
| **Data Package** | Container |
| **Refer** | [con9](con9.md), [besa](besa.md), [rvsa](rvsa.md), [container-feldtabelle](container-feldtabelle.md), [container-regeltabelle](container-regeltabelle.md) |

### Purpose

The Container Header is the first record in every KVDT file. It identifies the file as a KVDT container, records the creation date, specifies the character set used, and declares which data packages are contained in the file.

### Ordering Rules

1. Record "con0" must be present exactly once per file. It must be stored as the first record.
2. Record [besa](besa.md) must be present exactly once per file. It must be stored as the second record.
3. Record [rvsa](rvsa.md) may be present once per file. It must be stored as the third record (if the data package "Hybrid-DRG" is not contained in the billing file).
4. Data packages follow, where:
   a) The first data package follows either record "rvsa" or record "besa".
   b) Each subsequent data package follows the preceding data package.
   c) For data package combination in a KVDT file, fields 9135 "Combined data packages of a KVDT file" and 9138 "Separate data packages of a KVDT file" of record type "kvx0" of the respectively valid KV-Specifika master file must be evaluated.
   d) Each data package may be present **only exactly once** per KVDT file.
   e) The order of data packages is fixed: "ADT", "KADT", and "SADT".
5. Record [con9](con9.md) must be present once per file. It must be stored as the last record of the file.

### Field Table (Satztabelle)

| FK | Occ | Field Name | Type | Condition | Notes |
|----|-----|-----------|------|-----------|-------|
| 8000 | 1 | Record type | M | | Record type Container-Header |
| 9103 | 1 | Creation date | M | | |
| 9106 | 1 | Character set used | M | | See Section 2.3.1 |
| 9132 | n | Data packages contained in this file | M | | See Section 2.3.1 |
