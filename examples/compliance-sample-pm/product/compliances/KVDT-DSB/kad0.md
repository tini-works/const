## kad0 -- KADT Data Package Header

| Field | Value |
|-------|-------|
| **Satzart** | kad0 |
| **German Name** | KADT-Datenpaket-Header |
| **Source** | KVDT-DSB v6.02 |
| **Section** | 4.4.1 |
| **Data Package** | KADT |
| **Refer** | [kad9](kad9.md), [0109](0109.md), [kadt-feldtabelle](kadt-feldtabelle.md), [kadt-regeltabelle](kadt-regeltabelle.md) |

### Purpose

Header record for the KADT data package. Appears exactly once as the first record of the data package. Contains metadata about the software vendor, regional system operator, software identification, and the billing quarter.

### Field Table (Satztabelle)

| FK | Occ | Field Name | Type | Condition | Notes |
|----|-----|-----------|------|-----------|-------|
| 8000 | 1 | Record type (Satzart) | M | | Record type KADT data package header |
| 0105 | 1 | KBV check number (KBV-Prufnummer) | M | | Unique number assigned during KBV system certification |
| 9102 | 1 | Recipient (Empfanger) | M | | 20 |
| 9212 | 1 | Record description version (Version der Satzbeschreibung) | M | | Binding version of the KADT record description: KADT0425.01 |
| 0102 | 1 | Software vendor (Softwareverantwortlicher, SV) | M | | See Chapter 7 |
| 0121 | 1 | Street of SV (Strasse des SV) | M | | |
| 0122 | 1 | Postal code of SV (PLZ des SV) | M | | |
| 0123 | 1 | City of SV (Ort des SV) | M | | |
| 0124 | 1 | Phone number of SV (Telefonnummer des SV) | M | | |
| 0125 | 1 | Fax number of SV (Telefaxnummer des SV) | K | | |
| 0111 | 1 | Email address of SV (E-Mail-Adresse des SV) | K | | |
| 0126 | 1 | Regional system operator (Regionaler Systembetreuer, SB) | M | | See Chapter 7 |
| 0127 | 1 | Street of SB (Strasse des SB) | M | | |
| 0128 | 1 | Postal code of SB (PLZ des SB) | M | | |
| 0129 | 1 | City of SB (Ort des SB) | M | | |
| 0130 | 1 | Phone number of SB (Telefonnummer des SB) | M | | |
| 0131 | 1 | Fax number of SB (Telefaxnummer des SB) | K | | |
| 0103 | 1 | Software | M | | Name of the certified software or software variant. If a software variant is used, its name must be provided. |
| 0132 | 1 | Software release version (Release-Stand der Software) | K | | |
| 9116 | 1 | Creation date of KADT data package (Erstellungsdatum KADT-Datenpaket) | K | | |
| 9204 | 1 | Billing quarter (Abrechnungsquartal) | M | | |
| 9250 | n | AVWG check number of AVS (AVWG-Prufnummer der AVS) | K | | Check number of the medication prescribing software, if available |
| 9251 | n | HMV check number (HMV-Prufnummer) | K | | |
