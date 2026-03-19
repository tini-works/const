## con9 — Container Closing

| Field | Value |
|-------|-------|
| **Satzart** | con9 |
| **German Name** | Container-Abschluss |
| **Source** | KVDT-DSB v6.02 |
| **Section** | 2.2.2 Satzart: Container-Abschluss "con9" |
| **Data Package** | Container |
| **Refer** | [con0](con0.md), [besa](besa.md), [rvsa](rvsa.md), [container-feldtabelle](container-feldtabelle.md), [container-regeltabelle](container-regeltabelle.md) |

### Purpose

The Container Closing is the last record in every KVDT file. It marks the end of the container and signals that no further records follow.

### Ordering Rules

Record "con9" must be present exactly once per file. It must be stored as the last record of the file.

### Field Table (Satztabelle)

| FK | Occ | Field Name | Type | Condition | Notes |
|----|-----|-----------|------|-----------|-------|
| 8000 | 1 | Record type | M | | Record type Container-Closing |
