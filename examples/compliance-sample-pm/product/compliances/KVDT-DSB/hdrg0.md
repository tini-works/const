## hdrg0 -- HDRG Data Package Header

| Field | Value |
|-------|-------|
| **Satzart** | hdrg0 |
| **German Name** | HDRG-Datenpaket-Header |
| **Source** | KVDT-DSB v6.02 |
| **Section** | 6.5.1 |
| **Data Package** | HDRG |
| **Refer** | [hdrg9](hdrg9.md), [hdrg1](hdrg1.md), [hdrg-feldtabelle](hdrg-feldtabelle.md), [hdrg-regeltabelle](hdrg-regeltabelle.md) |

### Purpose

Header record for the Hybrid-DRG data package. Appears exactly once as the first record of the Hybrid-DRG data package (after the file-level con0 record).

#### Zielsetzung (Section 6.1)

The Hybrid-DRG data package enables the billing of Hybrid-DRG services according to the [HDRG_Verordnung] via a special cross-sector reimbursement to the Kassenarztlichen Vereinigungen.

#### Intended Use (Section 6.2)

Billing files based on the Hybrid-DRG data package may be used exclusively for billing Hybrid-DRG services between physician practices and Kassenarztliche Vereinigungen.

#### Overview (Section 6.3)

| Record Type Description | Satzart |
|--------------------------|---------|
| Hybrid-DRG Data Package Header | hdrg0 |
| Hybrid-DRG Data Package Closing | hdrg9 |
| Hybrid-DRG Record | hdrg1 |

#### Ordering (Section 6.4)

- Record "con0" appears once per file. It must be placed as the first record of the file.
- Record "hdrg0" appears once. It must be placed as the first record of the Hybrid-DRG data package.
- Record "hdrg1" follows record "hdrg0" in any number.
- Record "hdrg9" appears once per Hybrid-DRG data package. It must be placed as the last record of the Hybrid-DRG data package.
- Record "con9" appears once per file. It must be placed as the last record of the file.

### Field Table (Satztabelle)

| FK | Occ | Field Name | Type | Condition | Notes |
|----|-----|-----------|------|-----------|-------|
| 8000 | 1 | Record type (Satzart) | M | | Record type HDRG data package header |
| 0105 | 1 | KBV check number (KBV-Prufnummer) | K | | Unique number assigned during KBV system certification |
| 9212 | 1 | Record description version (Version der Satzbeschreibung) | M | | Binding version of the HDRG record description: HDRG0126.01 |
| 0103 | 1 | Software | M | | Name of the certified software or software variant. If a software variant is used, its name must be provided. |
| 0132 | 1 | Software release version (Release-Stand der Software) | K | | |
| 0104 | 1 | Grouper software (Grouper-Software) | K | | Name of the grouper software used |
| 9117 | 1 | Creation date Hybrid-DRG data package (Erstellungsdatum Hybrid-DRG-Datenpaket) | K | | |
