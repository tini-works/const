## adt9 — ADT Data Package Closing Record

| Field | Value |
|-------|-------|
| **Satzart** | adt9 |
| **German Name** | ADT-Datenpaket-Abschluss |
| **Source** | KVDT-DSB v6.02 |
| **Section** | 3.4.2 Satzart: ADT-Datenpaket-Abschluss "adt9" |
| **Data Package** | ADT |
| **Refer** | [adt0](adt0.md), [0101](0101.md), [0102](0102.md), [0103](0103.md), [0104](0104.md) |

### Purpose

The ADT data package closing record terminates the ADT data package. It occurs exactly once per ADT data package and must be placed as the last record.

### Field Table (Satztabelle)

| FK | Occ | Field Name | Type | Condition | Notes |
|----|-----|-----------|------|-----------|-------|
| 8000 | 1 | Record type (Satzart) | M | | Record type ADT data package closing |
