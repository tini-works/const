## sad0 -- SADT Data Package Header

| Field | Value |
|-------|-------|
| **Satzart** | sad0 |
| **German Name** | SADT-Datenpaket-Header |
| **Source** | KVDT-DSB v6.02 |
| **Section** | 5.4.1 |
| **Data Package** | SADT |
| **Refer** | [sad9](sad9.md), [sad1](sad1.md), [sad2](sad2.md), [sad3](sad3.md), [sadt-feldtabelle](sadt-feldtabelle.md), [sadt-regeltabelle](sadt-regeltabelle.md) |

### Purpose

Header record for the SADT data package. Appears exactly once as the first record of the SADT data package.

The SADT data package is used to transmit billing of services under the Pregnancy and Family Assistance Amendment Act (Schwangeren- und Familienhilfeanderungsgesetz, SFHAndG) within the areas of the Kassenarztlichen Vereinigung Nordrhein and Westfalen-Lippe.

### Overview (Section 5.2)

The following SADT record types are defined:

| Record Type Description | Satzart |
|--------------------------|---------|
| SADT Data Package Header | sad0 |
| SADT Data Package Closing | sad9 |
| SADT Ambulatory Treatment | sad1 |
| SADT Referral | sad2 |
| SADT Hospital-based Physician Treatment | sad3 |

### Ordering (Section 5.3)

- Record "sad0" appears once. It must be placed as the first record of the SADT data package.
- Records "sad1", "sad2", "sad3" follow record "sad0" in any number and order.
- Record "sad9" appears once per SADT data package. It must be placed as the last record of the SADT data package.

### Field Table (Satztabelle)

| FK | Occ | Field Name | Type | Condition | Notes |
|----|-----|-----------|------|-----------|-------|
| 8000 | 1 | Record type (Satzart) | M | | Record type SADT data package header "sad0" |
| 0105 | 1 | KBV check number (KBV-Prufnummer) | M | | Unique number assigned during KBV system certification |
| 9102 | 1 | Recipient (Empfanger) | M | | UKV identifier (restricted to KVWL and KVNO) |
| 9212 | 1 | Record description version (Version der Satzbeschreibung) | M | | Binding version of the SADT record description: SADT0125.01 |
| 0102 | 1 | Software vendor (Softwareverantwortlicher, SV) | M | | See Section 5.5.1 |
| 0121 | 1 | Street of SV (Strasse des SV) | M | | |
| 0122 | 1 | Postal code of SV (PLZ des SV) | M | | |
| 0123 | 1 | City of SV (Ort des SV) | M | | |
| 0124 | 1 | Phone number of SV (Telefonnummer des SV) | M | | |
| 0125 | 1 | Fax number of SV (Telefaxnummer des SV) | K | | |
| 0111 | 1 | Email address of SV (E-Mail-Adresse des SV) | K | | |
| 0126 | 1 | Regional system operator (Regionaler Systembetreuer, SB) | M | | See Section 5.5.1 |
| 0127 | 1 | Street of SB (Strasse des SB) | M | | |
| 0128 | 1 | Postal code of SB (PLZ des SB) | M | | |
| 0129 | 1 | City of SB (Ort des SB) | M | | |
| 0130 | 1 | Phone number of SB (Telefonnummer des SB) | M | | |
| 0131 | 1 | Fax number of SB (Telefaxnummer des SB) | K | | |
| 0103 | 1 | Software | M | | Name of the certified software or software variant. If a software variant is used, its name must be provided. |
| 0132 | 1 | Software release version (Release-Stand der Software) | K | | |
| 9122 | 1 | Creation date of SADT data package (Erstellungsdatum SADT-Datenpaket) | K | | |
| 9204 | 1 | Billing quarter (Abrechnungsquartal) | M | | |
| 9250 | n | AVWG check number of AVS (AVWG-Prufnummer der AVS) | K | | Check number of the medication prescribing software, if available |
| 9251 | n | HMV check number (HMV-Prufnummer) | K | | |
