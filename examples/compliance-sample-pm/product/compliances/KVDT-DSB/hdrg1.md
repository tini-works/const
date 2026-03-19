## hdrg1 -- Hybrid-DRG Record

| Field | Value |
|-------|-------|
| **Satzart** | hdrg1 |
| **German Name** | Hybrid-DRG-Datenpaket |
| **Source** | KVDT-DSB v6.02 |
| **Section** | 6.5.3 |
| **Data Package** | HDRG |
| **Refer** | [hdrg0](hdrg0.md), [hdrg9](hdrg9.md), [hdrg-feldtabelle](hdrg-feldtabelle.md), [hdrg-regeltabelle](hdrg-regeltabelle.md) |

### Purpose

Main billing record for Hybrid-DRG services. Contains patient demographics, insurance information, diagnoses (primary and secondary with ICD-10-GM codes), procedures (OPS codes with laterality), service dates, ventilation hours, and referral information. Follows the hdrg0 header in any number.

### Field Table (Satztabelle)

| FK | Occ | Field Name | Type | Condition | Notes |
|----|-----|-----------|------|-----------|-------|
| 8000 | 1 | Record type (Satzart) | M | | Record type Hybrid-DRG |
| 3000 | 1 | Patient number (Patientennummer) | K | | See Chapter 7 |
| 3006 | 1 | CDM Version | m | Regel 307 | See Chapter 7 |
| 3010 | 1 | Online check date/time and update timestamp (Datum und Uhrzeit der Onlineprufung und -aktualisierung, Timestamp) | m | If eGK was read and if record stored as proof of performed online check and update on the eGK, present; Regel 876 | See Chapter 7 |
| 3011 | 1 | Online check and update result (Ergebnis der Onlineprufung und -aktualisierung) | m | | See Chapter 7 |
| 3012 | 1 | Error code (Error-Code) | k | | See Chapter 7 |
| 3013 | 1 | Check digit of specialist service (Prufziffer des Fachdienstes) | k | | See Chapter 7 |
| 3100 | 1 | Name suffix (Namenszusatz) | K | | See Chapter 7 |
| 3120 | 1 | Name prefix (Vorsatzwort) | K | | See Chapter 7 |
| 3101 | 1 | Last name (Name) | M | | |
| 3102 | 1 | First name (Vorname) | M | | |
| 3103 | 1 | Date of birth (Geburtsdatum) | M | | See Chapter 7 |
| 3104 | 1 | Title (Titel) | K | | |
| 3105 | 1 | Insurance number (Versichertennummer) | m | Regel 776 | See Chapter 7 |
| 3119 | 1 | Insured person ID (Versicherten_ID) | m | Regel 776 | See Chapter 7 |
| 3107 | 1 | Street (Strasse) | K | | Street of patient address |
| 3109 | 1 | House number (Hausnummer) | K | | House number of patient address |
| 3115 | 1 | Address supplement (Anschriftenzusatz) | K | | |
| 3112 | 1 | Postal code (PLZ) | K | | Postal code of patient address |
| 3114 | 1 | Residence country code (Wohnsitzlaendercode) | K | | See Chapter 7 |
| 3113 | 1 | City (Ort) | K | | City of patient address |
| 3121 | 1 | PO box postal code (PostfachPLZ) | K | | Postal code of PO box address |
| 3122 | 1 | PO box city (PostfachOrt) | K | | City of PO box address |
| 3123 | 1 | PO box (Postfach) | K | | |
| 3124 | 1 | PO box residence country code (PostfachWohnsitzlaendercode) | K | | See Chapter 7 |
| 3116 | 1 | WOP (Wohnortprinzip) | K | | |
| 3108 | 1 | Insured person type (Versichertenart) | M | | |
| 3110 | 1 | Gender (Geschlecht) | M | | |
| 3111 | 1 | Admission weight (Aufnahmegewicht) | k | | Admission weight in grams for infants up to 1 year |
| 4104 | 1 | Billing VKNR (Abrechnungs-VKNR) | M | | |
| 4106 | 1 | Cost carrier billing area (Kostentrager-Abrechnungsbereich, KTAB) | M | | |
| 4109 | 1 | Last insurance card read date in quarter (Letzter Einlesetag der Versichertenkarte im Quartal) | m | If insurance card was read; Regel 876 | |
| 4112 | 1 | eEB available (eEB vorhanden) | K | Regel 895 | |
| 4133 | 1 | Insurance coverage start (VersicherungsschutzBeginn) | m | | |
| 4110 | 1 | Insurance coverage end (VersicherungsschutzEnde) | K | | See Chapter 7 |
| 4111 | 1 | Cost carrier identifier (Kostentraegerkennung) | M | | |
| 4131 | 1 | Special person group (BesonderePersonengruppe) | M | | |
| 4132 | 1 | DMP identifier (DMP_Kennzeichnung) | M | | |
| 4124 | 1 | SKT supplementary information (SKT-Zusatzangaben) | K | | |
| 4125 | 1 | Validity period from ... to ... (Gultigkeitszeitraum von ... bis ...) | K | | Entry "Gultigkeitszeitraum" |
| 4126 | n | SKT remarks (SKT-Bemerkungen) | K | | |
| 4218 | 1 | (N)BSNR of referrer ((N)BSNR des Uberweisers) | K | | |
| 4242 | 1 | Lifetime physician number of referrer (Lebenslange Arztnummer des Uberweisers) | m | | |
| 5027 | 1 | Hybrid-DRG service (Hybrid-DRG Leistung) | M | | |
| 5028 | 1 | Service start date (Datum Beginn der Leistung) | M | Regel 706 | |
| 5029 | 1 | Service end date (Datum Ende der Leistung) | M | | |
| 5030 | 1 | Ventilation hours (Beatmungsstunden) | K | | |
| 5009 | n | Free-text justification (freier Begrundungstext) | K | | Documentation of billing justification |
| 5034 | 1 | Surgery date (OP-Datum) | K | | |
| 5035 | n | OPS code (OP-Schlussel) | M | | |
| 5041 | 1 | OPS laterality (Seitenlokalisation OPS) | k | Regel 706 | |
| 5098 | 1 | (N)BSNR of service location ((N)BSNR des Ortes der Leistungserbringung) | M | | |
| 5099 | 1 | Lifetime physician number (LANR) of contracted physician/psychotherapist (Lebenslange Arztnummer (LANR) des Vertragsarztes/Vertragspsychotherapeuten) | M | | |
| 6009 | 1 | Primary diagnosis (ICD-10-GM code) (Hauptdiagnose (ICD-10-GM-Kode)) | M | | |
| 6010 | 1 | Laterality of primary diagnosis (Seitenlokalisation Hauptdiagnose) | K | | |
| 6011 | n | Secondary diagnosis (ICD-10-GM code) (Nebendiagnose (ICD-10-GM-Kode)) | k | | |
| 6012 | 1 | Laterality of secondary diagnosis (Seitenlokalisation Nebendiagnose) | k | | |
