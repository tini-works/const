## KADT Field Table (Feldtabelle)

| Field | Value |
|-------|-------|
| **Source** | KVDT-DSB v6.02 |
| **Section** | 4.7.1 |
| **Scope** | Field validation rules for KADT data package |

The field table serves to validate field contents. Some validations can be performed immediately based on entries in this table, while others require referral to the [KADT Rule Table](kadt-regeltabelle.md) or subordinate tables. Each entry in the field table is uniquely assigned to one field. Entries "kvxn" (n=0,1,2,3) are references to the KV-Specifika master data file (see Section 1.6.2).

### Fields

| FK | Field Name | Length | Type | Rule | Allowed Values | Example |
|----|-----------|--------|------|------|---------------|---------|
| 0102 | Software vendor (Softwareverantwortlicher, SV) | <=60 | a | | | KBV Arztsoftware AG |
| 0103 | Software | <=60 | a | | | DOCSFUN |
| 0105 | KBV check number (KBV-Prufnummer) | 15-17 | a | 052, 204, 213 | | X/1/1401/36/id9 |
| 0111 | Email address of SV (E-Mail-Adresse des SV) | <=60 | a | | | test@kbv.de |
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
| 3000 | Patient number (Patientennummer) | <=20 | a | | | 127 |
| 3003 | Certificate ID (Schein-ID) | <=60 | a | | | |
| 3006 | CDM Version | 5-11 | a | 055, 308, 791 | | |
| 3010 | Online check date/time and update timestamp (Datum und Uhrzeit der Onlineprufung und -aktualisierung, Timestamp) | 14 | n | 060, 865, 866, 867, 876 | | 20191024101010 |
| 3011 | Online check and update result (Ergebnis der Onlineprufung und -aktualisierung) | 1 | n | 528 | 1 = VSD update on eGK performed; 2 = No VSD update on eGK required; 3 = VSD update on eGK technically not possible; 4 = Authentication certificate eGK invalid; 5 = Online check of authentication certificate technically not possible; 6 = VSD update on eGK technically not possible and maximum offline period exceeded | |
| 3012 | Error code (Error-Code) | <=5 | n | | | 12101 |
| 3013 | Check digit of specialist service (Prufziffer des Fachdienstes) | <=128 | a | | | |
| 3100 | Name suffix (Namenszusatz) | <=20 | a | | | Herzogin |
| 3101 | Last name (Name) | <=45 | a | | | Schmitz |
| 3102 | First name (Vorname) | <=45 | a | | | Erna |
| 3103 | Date of birth (Geburtsdatum) | 8 | n | 021, 304, 313 | | |
| 3104 | Title (Titel) | <=20 | a | | | Dr. |
| 3107 | Street (Strasse) | <=46 | a | | | Holzweg |
| 3108 | Insured person type (Versichertenart) | 1 | n | 116 | 1 = Member (Mitglied); 3 = Family insured (Familienversicherter); 5 = Pensioner (Rentner) | 3 |
| 3109 | House number (Hausnummer) | <=9 | a | | | |
| 3110 | Gender (Geschlecht) | 1 | a | 533 | M = male (mannlich); W = female (weiblich); U = unknown (unbekannt); X = indeterminate (unbestimmt); D = diverse (divers) | |
| 3112 | Postal code (PLZ) | <=10 | a | | | 50859 |
| 3113 | City (Ort) | <=40 | a | | | Koln |
| 3114 | Residence country code (Wohnsitzlaendercode) | <=3 | a | | | |
| 3115 | Address supplement (Anschriftenzusatz) | <=40 | a | | | Hinterhaus |
| 3119 | Insured person ID (Versicherten_ID) | 10 | a | 054, 791, 537 | not equal to T555558879 | |
| 3120 | Name prefix (Vorsatzwort) | <=20 | a | | | bei der |
| 3121 | PO box postal code (PostfachPLZ) | <=10 | a | | | |
| 3122 | PO box city (PostfachOrt) | <=40 | a | | | |
| 3123 | PO box (Postfach) | <=8 | a | | | |
| 3124 | PO box residence country code (PostfachWohnsitzlaendercode) | <=3 | a | | | |
| 4102 | Issue date (Ausstellungsdatum) | 8 | d | | | |
| 4104 | Billing VKNR (Abrechnungs-VKNR) | 5 | n | 017, 201, 212 | | 27106 |
| 4108 | Authorization number (Zulassungsnummer, mobiles Lesegerat) | <=40 | a | | | INGHC;ORGA930M;4.9.0:1.0.0 (Hersteller-ID;ProduktKurzel;Produktversion(=Firmwareversion: Hardwareversion)) |
| 4109 | Last insurance card read date in quarter (letzter Einlesetag der Versichertenkarte im Quartal) | 8 | d | 791, 876 | | |
| 4110 | Insurance coverage end (VersicherungsschutzEnde) | 8 | d | 315 | | 20191010 |
| 4111 | Cost carrier identifier (Kostentraegerkennung) | 9 | n | 202 | | 101568008 |
| 4112 | eEB available (eEB vorhanden) | 1 | n | 142, 895 | 1 = yes (ja) | |
| 4131 | Special person group (BesonderePersonengruppe) | 2 | a | 530 | 00 = no special person group (default); 04 = BSHG (Bundessozialhilfegesetz) S 264 SGB V | |
| 4132 | DMP identifier (DMP_Kennzeichnung) | 2 | a | 536 | 00 = no DMP identifier (default); 01 = Diabetes mellitus Typ 2; 02 = Brustkrebs; 03 = Koronare Herzkrankheit; 04 = Diabetes mellitus Typ 1; 05 = Asthma bronchiale; 06 = COPD (chronic obstructive pulmonary disease); 07 = Chronische Herzinsuffizienz; 08 = Depression; 09 = Ruckenschmerz; 10 = Rheuma; 11 = Osteoporose; 12 = Adipositas; 30 = Diabetes Typ 2 und KHK; 31 = Asthma und Diabetes Typ 2; 32 = COPD und Diabetes Typ 2; 33 = COPD und KHK; 34 = COPD, Diabetes Typ 2 und KHK; 35 = Asthma und KHK; 36 = Asthma, Diabetes Typ 2 und KHK; 37 = Brustkrebs und Diabetes Typ 2; 38 = Diabetes Typ 1 und KHK; 39 = Asthma und Diabetes Typ 1; 40 = Asthma und Brustkrebs; 41 = Brustkrebs und KHK; 42 = Brustkrebs und COPD; 43 = COPD und Diabetes Typ 1; 44 = Brustkrebs, Diabetes Typ 2 und KHK; 45 = Asthma, Brustkrebs und Diabetes Typ 2; 46 = Brustkrebs und Diabetes Typ 1; 47 = COPD, Diabetes Typ 1 und KHK; 48 = Brustkrebs, COPD und Diabetes Typ 2; 49 = Asthma, Diabetes Typ 1 und KHK; 50 = Asthma, Brustkrebs und KHK; 51 = Brustkrebs, COPD und KHK; 52 = Brustkrebs, COPD, Diabetes Typ 2 und KHK; 53 = Asthma, Brustkrebs, Diabetes Typ 2 und KHK; 54 = Brustkrebs, Diabetes Typ 1 und KHK; 55 = Asthma, Brustkrebs und Diabetes Typ 1; 56 = Asthma, Brustkrebs, Diabetes Typ 1 und KHK; 57 = Brustkrebs, COPD und Diabetes Typ 1; 58 = Brustkrebs, COPD, Diabetes Typ 1 und KHK | |
| 4133 | Insurance coverage start (VersicherungsschutzBeginn) | 8 | d | 791 | | |
| 4134 | Cost carrier name (Kostentraegername) | <=45 | a | 791 | | |
| 4261 | Spa type (Kurart) | 1 | n | 106, 382 | 1 = Ambulatory preventive care for disease prevention (Ambulante Vorsorgeleistung zur Krankheitsverhutung); 2 = Ambulatory preventive care for existing diseases (Ambulante Vorsorgeleistung bei bestehenden Krankheiten); 3 = Ambulatory preventive care for children (Ambulante Vorsorgeleistung fur Kinder) | 1 |
| 4262 | Conducted as compact spa (Durchfuhrung als Kompaktkur) | 1 | n | 101, 382, 383, 881 | | 1 |
| 4263 | Approved spa duration in weeks (genehmigte Kurdauer in Wochen) | <=2 | n | 168 | | 3 |
| 4264 | Arrival date (Anreisetag) | 8 | d | 316, 882, 883, 884, 885 | | |
| 4265 | Departure date (Abreisetag) | 8 | d | 317, 866, 882, 883, 884, 885 | | |
| 4266 | Early termination date (Kurabbruch am) | 8 | d | 318, 867, 883, 885 | | |
| 4267 | Approved spa extension in weeks (Bewilligte Kurverlagerung in Wochen) | <=2 | n | 168 | | 1 |
| 4268 | Approval date for spa extension (Bewilligungsdatum Kurverlagerung) | 8 | d | | | |
| 4269 | Behavioral preventive measures initiated (Verhaltenspraventive Massnahmen angeregt) | 1 | n | 101 | | 1 |
| 4270 | Behavioral preventive measures performed (Verhaltenspraventive Massnahmen durchgefuhrt) | 1 | n | 101 | | 1 |
| 4271 | Compact spa not possible (Kompaktkur nicht moglich) | 1 | n | 101, 383 | | 1 |
| 4272 | Conducted as compact spa with refresher (Durchfuhrung als Kompaktkur mit Refresher) | 1 | n | 101, 317, 318, 382, 383, 866, 881, 882, 883, 884, 885 | | |
| 4275 | Contact for spa stay preparation (Kontakt zur Vorbereitung des Kuraufenthaltes) | 1 | n | 101 | | |
| 4276 | Arrival date as part 2 for refresher (Anreisetag als Teil 2 bei Refresher) | 8 | d | 317, 318, 879, 882, 883, 884, 885 | | |
| 4277 | Departure date as part 2 for refresher (Abreisetag als Teil 2 bei Refresher) | 8 | d | 317, 866, 879, 882, 883, 884, 885 | | |
| 4278 | Early termination date as part 2 for refresher (Kurabbruch am als Teil 2 bei Refresher) | 8 | d | 318, 867, 880, 884, 885 | | |
| 5000 | Service date (Leistungstag) | 8 | d | 304, 315, 316, 317, 318, 882, 883, 884, 885 | | |
| 5001 | Fee schedule number (Gebuhrennummer, GNR) | 5, 6 | a | 042, 203, kvx1 | | 00001U |
| 5098 | (N)BSNR of service location ((N)BSNR des Ortes der Leistungserbringung) | 9 | n | 049, 730 | | |
| 5099 | Lifetime physician number (LANR) of contracted physician/psychotherapist (Lebenslange Arztnummer (LANR) des Vertragsarztes/Vertragspsychotherapeuten) | 9 | n | 050, 731, 762 | | |
| 6001 | ICD code (ICD-Code) | 3, 5, 6 | a | 022, 489, 490, 491, 492, 728, 729, 761, 817, 856 | | L50.0 |
| 6003 | Diagnosis certainty (Diagnosensicherheit) | 1 | a | 109, 856 | V = Suspected (Verdacht auf); Z = Status post (Zustand nach); A = Excluded (Ausschluss); G = Confirmed diagnosis (gesicherte Diagnose) | V |
| 6004 | Laterality (Seitenlokalisation) | 1 | a | 110 | R = right (rechts); L = left (links); B = bilateral (beidseitig) | R |
| 6006 | Diagnosis explanation (Diagnosenerlaruterung) | <=60 | a | | | |
| 6008 | Diagnosis exception status (Diagnoseausnahmetatbestand) | <=60 | a | 491 | | |
| 8000 | Record type (Satzart) | 4 | a | 165, kvx2, kvx3 | kad0 = KADT data package header; kad9 = KADT data package closing; 0109 = Spa physician billing (Kurarztliche Abrechnung) | |
| 9102 | Recipient (Empfanger) | 2 | n | 166, kvx0 | 20 = KV Westfalen Lippe | 20 |
| 9116 | Creation date KADT data package (Erstellungsdatum KADT-Datenpaket) | 8 | d | | | |
| 9204 | Billing quarter (Abrechnungsquartal) | 5 | n | 016 | | 12020 |
| 9212 | Record description version (Version der Satzbeschreibung) | <=11 | a | 031, 814 | | |
| 9250 | AVWG check number of AVS (AVWG-Prufnummer der AVS) | 15-17 | a | 052, 204 | | Y/1/1901/36/id9 |
| 9251 | HMV check number (HMV-Prufnummer) | 15-17 | a | 052, 204 | | Y/2/1912/36/xxx |
| 9901 | System-internal parameter (Systeminterner Parameter) | <=60 | a | 999 | | abcd/q<rs |
