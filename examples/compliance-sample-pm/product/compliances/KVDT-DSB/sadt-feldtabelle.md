## SADT Field Table (Feldtabelle)

| Field | Value |
|-------|-------|
| **Source** | KVDT-DSB v6.02 |
| **Section** | 5.5.1 |
| **Scope** | Field validation rules for SADT data package |

The field table serves to validate field contents. Some validations can be performed immediately based on entries in this table, while others require referral to the [SADT Rule Table](sadt-regeltabelle.md) or subordinate tables. Each entry in the field table is uniquely assigned to one field. Entries "kvxn" (n=0,1,2,3) are references to the KV-Specifika master data file.

A continuous extension of the criteria is planned. Their stepwise introduction depends on the possibilities for direct verification. Only requirements that can also be programmatically controlled upon data receipt at the Kassenarztlichen Vereinigung are made in principle.

### Fields

| FK | Field Name | Length | Type | Rule | Allowed Values | Example |
|----|-----------|--------|------|------|---------------|---------|
| 0102 | Software vendor (Softwareverantwortlicher, SV) | <=60 | a | | | KBV Arztsoftware GmbH |
| 0103 | Software | <=60 | a | | | DOCSFUN |
| 0105 | KBV check number (KBV-Prufnummer) | 15-17 | a | 052, 204, 213 | | X/1/1401/36/id9 |
| 0111 | Email address of SV (Email-Adresse des SV) | <=60 | a | | | test@kbv.de |
| 0121 | Street of SV (Strasse des SV) | <=60 | a | | | Ottostr. 1 |
| 0122 | Postal code of SV (PLZ des SV) | <=7 | a | | | 56070 |
| 0123 | City of SV (Ort des SV) | <=60 | a | | | Koblenz |
| 0124 | Phone number of SV (Telefonnummer des SV) | <=60 | a | | | 0261/4094 |
| 0125 | Fax number of SV (Telefaxnummer des SV) | <=60 | a | | | 0261/40943 |
| 0126 | Regional system operator (Regionaler Systembetreuer, SB) | <=60 | a | | | Fa. Datasoft |
| 0127 | Street of SB (Strasse des SB) | <=60 | a | | | Durener Str. 322 |
| 0128 | Postal code of SB (PLZ des SB) | <=7 | a | | | 50859 |
| 0129 | City of SB (Ort des SB) | <=60 | a | | | Koln |
| 0130 | Phone number of SB (Telefonnummer des SB) | <=60 | a | | | 0221/10002 |
| 0131 | Fax number of SB (Telefaxnummer des SB) | <=60 | a | | | 0221/34893 |
| 0132 | Software release version (Release-Stand der Software) | <=60 | a | | | 2.52b |
| 3005 | SA identifier (Kennziffer SA) | <=27 | a | 048, 709 | | |
| 4101 | Quarter (Quartal) | 5 | n | 016, 324, kvx0 | | |
| 4104 | Billing VKNR (Abrechnungs-VKNR) | 5 | n | 017, 201, 212 | | 27106 |
| 4111 | Cost carrier identifier (Kostentraegerkennung) | 9 | n | 202 | | 101568008 |
| 4205 | Order (Auftrag) | <=60 | a | | | |
| 4218 | (N)BSNR of referrer ((N)BSNR des Uberweisers) | 9 | n | 049 | | |
| 4242 | Lifetime physician number of referrer (lebenslange Arztnummer des Uberweisers) | 9 | n | 050, 762 | | |
| 4220 | Referral to (Uberweisung an) | <=60 | a | | | Radiologen |
| 5000 | Service date (Leistungstag) | 8 | d | 304, 324 | | |
| 5001 | Fee schedule number (Gebuhrennummer, GNR) | 5, 6 | a | 203 | | 13100 |
| 5009 | Free-text justification (freier Begrundungstext) | <=60 | a | | | Neuerkrankung |
| 5011 | Material cost description (Sachkosten-Bezeichnung) | <=60 | a | | | Norm-Silberstift |
| 5012 | Material costs in cents (Sachkosten/Materialkosten in Cent) | <=10 | n | 710 | | 12345 |
| 5076 | Invoice number (Rechnungsnummer) | <=20 | a | | | |
| 5098 | (N)BSNR of service location ((N)BSNR des Ortes der Leistungserbringung) | 9 | n | 049, 732 | | |
| 5099 | Lifetime physician number (LANR) of contracted physician/psychotherapist (Lebenslange Arztnummer (LANR) des Vertragsarztes/Vertragspsychotherapeuten) | 9 | n | 050, 733, 762 | | |
| 8000 | Record type (Satzart) | 4 | a | 523 | sad0 = SADT data package header; sad9 = SADT data package closing; sad1 = SADT ambulatory treatment; sad2 = SADT referral; sad3 = SADT hospital-based physician treatment | |
| 9102 | Recipient (Empfanger) | 2 | n | 524, kvx0 | 18 = Dortmund; 19 = Munster; 20 = Dortmund; 21 = Aachen; 24 = Dusseldorf; 25 = Duisburg; 27 = Koln; 28 = Linker Niederrhein; 31 = Ruhr; 37 = Bergisch-Land | 27 |
| 9122 | Creation date SADT data package (Erstellungsdatum SADT-Datenpaket) | 8 | d | | | |
| 9204 | Billing quarter (Abrechnungsquartal) | 5 | n | 016 | | 22020 |
| 9212 | Record description version (Version der Satzbeschreibung) | <=11 | a | 031, 815 | | |
| 9250 | AVWG check number of AVS (AVWG-Prufnummer der AVS) | 15-17 | a | 052, 204 | | Y/1/1901/36/id9 |
| 9251 | HMV check number (HMV-Prufnummer) | 15-17 | a | 052, 204 | | Y/2/1912/36/xxx |
| 9901 | System-internal parameter (Systeminterner Parameter) | <=60 | a | 999 | | abcd/q<rs |
