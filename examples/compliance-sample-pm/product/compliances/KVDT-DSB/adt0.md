## adt0 — ADT Data Package Header

| Field | Value |
|-------|-------|
| **Satzart** | adt0 |
| **German Name** | ADT-Datenpaket-Header |
| **Source** | KVDT-DSB v6.02 |
| **Section** | 3.4.1 Satzart: ADT-Datenpaket-Header "adt0" |
| **Data Package** | ADT |
| **Refer** | [adt9](adt9.md), [0101](0101.md), [0102](0102.md), [0103](0103.md), [0104](0104.md) |

### Purpose

The ADT data package header record opens the ADT data package. It occurs exactly once and must be the first record in the package. It contains global metadata such as the recipient, software version, and billing period information.

### Field Table (Satztabelle)

| FK | Occ | Field Name | Type | Condition | Notes |
|----|-----|-----------|------|-----------|-------|
| 8000 | 1 | Record type (Satzart) | M | | Record type ADT data package header |
| 0105 | 1 | KBV verification number (KBV-Pruefnummer) | M | | Unique number assigned during system verification by KBV |
| 9102 | 1 | Recipient (Empfaenger) | M | | UKV/OKV identifier |
| 9212 | 1 | Version of record description (Version der Satzbeschreibung) | M | | Binding version of the ADT record description. ADT0126.01, ADT0426.01 |
| 0102 | 1 | Software vendor (Softwareverantwortlicher (SV)) | M | | see Chapter 7 |
| 0121 | 1 | Street of SV (Strasse des SV) | M | | |
| 0122 | 1 | Postal code of SV (PLZ des SV) | M | | |
| 0123 | 1 | City of SV (Ort des SV) | M | | |
| 0124 | 1 | Phone number of SV (Telefonnummer des SV) | M | | |
| 0125 | 1 | Fax number of SV (Telefaxnummer des SV) | K | | |
| 0111 | 1 | Email address of SV (E-Mail-Adresse des SV) | K | | |
| 0126 | 1 | Regional system operator (Regionaler Systembetreuer (SB)) | M | | see Chapter 7 |
| 0127 | 1 | Street of SB (Strasse des SB) | M | | |
| 0128 | 1 | Postal code of SB (PLZ des SB) | M | | |
| 0129 | 1 | City of SB (Ort des SB) | M | | |
| 0130 | 1 | Phone number of SB (Telefonnummer des SB) | M | | |
| 0131 | 1 | Fax number of SB (Telefaxnummer des SB) | K | | |
| 0103 | 1 | Software | M | | Name of the certified software or software variant. If a software variant is used, its name is to be entered. |
| 0132 | 1 | Software release version (Release-Stand der Software) | K | | |
| 9115 | 1 | ADT data package creation date (Erstellungsdatum ADT-Datenpaket) | K | | |
| 9260 | 1 | Number of partial billings (Anzahl Teilabrechnungen) | K | | Total number of all billing parts of a practice site |
| 9261 | 1 | Billing part x of y (Abrechnungsteil x von y) | m | | Unique part number assigned to this billing part |
| 9204 | 1 | Billing quarter (Abrechnungsquartal) | M | | |
| 9250 | n | AVWG verification number of the AVS (AVWG-Pruefnummer der AVS) | K | | AVWG verification number of the medication ordering software, if available |
| 9251 | n | HMV verification number (HMV-Pruefnummer) | K | | |
