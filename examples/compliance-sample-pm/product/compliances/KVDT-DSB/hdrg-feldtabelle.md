## HDRG Field Table (Feldtabelle)

| Field | Value |
|-------|-------|
| **Source** | KVDT-DSB v6.02 |
| **Section** | 6.5.4 |
| **Scope** | Field validation rules for HDRG data package |

The field table serves to validate field contents. Some validations can be performed immediately based on entries in this table, while others require referral to the [HDRG Rule Table](hdrg-regeltabelle.md) or subordinate tables. Each entry in the field table is uniquely assigned to one field.

### Fields

| FK | Field Name | Length | Type | Rule | Allowed Values | Example |
|----|-----------|--------|------|------|---------------|---------|
| 0103 | Software | <=60 | a | | | DOCSFUN |
| 0104 | Grouper software (Grouper-Software) | <=60 | a | | | |
| 0105 | KBV check number (KBV-Prufnummer) | 15-17 | a | 052 | | X/1401/36/id9 |
| 0132 | Software release version (Release-Stand der Software) | <=60 | a | | | 2.52b |
| 3000 | Patient number (Patientennummer) | <=20 | a | | | 2002 |
| 3006 | CDM Version | 5-11 | a | 055, 308, 790 | | 5.2.0 |
| 3010 | Online check date/time and update timestamp (Datum und Uhrzeit der Onlineprufung und -aktualisierung, Timestamp) | 14 | n | 060, 876 | | 20191024101010 |
| 3011 | Online check and update result (Ergebnis der Onlineprufung und -aktualisierung) | 1 | n | 528 | 1 = VSD update on eGK performed; 2 = No VSD update on eGK required; 3 = VSD update on eGK technically not possible; 4 = Authentication certificate eGK invalid; 5 = Online check of authentication certificate technically not possible; 6 = VSD update on eGK technically not possible and maximum offline period exceeded | |
| 3012 | Error code (Error-Code) | <=5 | n | | | 12101 |
| 3013 | Check digit of specialist service (Prufziffer des Fachdienstes) | <=128 | a | | | |
| 3100 | Name suffix (Namenszusatz) | <=20 | a | | | Herzogin |
| 3101 | Last name (Name) | <=45 | a | | | Schmitz |
| 3102 | First name (Vorname) | <=45 | a | | | Erna |
| 3103 | Date of birth (Geburtsdatum) | 8 | n | 021, 023, 304, 314, 390, 898 | | 19661024 |
| 3104 | Title (Titel) | <=20 | a | | | Dr. |
| 3105 | Insurance number (Versichertennummer) | 6-12 | n | 053, 776 | | 1234567890 |
| 3107 | Street (Strasse) | <=46 | a | | | Holzweg |
| 3108 | Insured person type (Versichertenart) | 1 | n | 116 | 1 = Member (Mitglied); 3 = Family insured (Familienversicherter); 5 = Pensioner (Rentner) | 3 |
| 3109 | House number (Hausnummer) | <=9 | a | | | |
| 3110 | Gender (Geschlecht) | 1 | a | 538 | M = male (mannlich); W = female (weiblich); X = indeterminate (unbestimmt); D = diverse (divers) | |
| 3111 | Admission weight (Aufnahmegewicht) | <=5 | n | 390 | | 3200 |
| 3112 | Postal code (PLZ) | <=10 | a | | | 50859 |
| 3113 | City (Ort) | <=40 | a | | | Koln |
| 3114 | Residence country code (Wohnsitzlaendercode) | <=3 | a | | | |
| 3115 | Address supplement (Anschriftenzusatz) | <=40 | a | | | |
| 3116 | WOP (Wohnortprinzip) | 2 | n | | 00 = Dummy bei eGK; 01 = Schleswig-Holstein; 02 = Hamburg; 03 = Bremen; 17 = Niedersachsen; 20 = Westfalen-Lippe; 38 = Nordrhein; 46 = Hessen; (47 = Koblenz); (48 = Rheinhessen); (49 = Pfalz); (50 = Trier); 51 = Rheinland-Pfalz; 52 = Baden-Wurttemberg; (55 = Nordbaden); (60 = Sudbaden); (61 = Nordwurttemberg); (62 = Sudwurttemberg); 71 = Bayern; 72 = Berlin; 73 = Saarland; 78 = Mecklenburg-Vorpommern; 83 = Brandenburg; 88 = Sachsen-Anhalt; 93 = Thuringen; 98 = Sachsen | () fusioniert, teilweise aber noch in Gebrauch (bspw. KVK-WOP) |
| 3119 | Insured person ID (Versicherten_ID) | 10 | a | 054, 776, 537 | not equal to T555558879 | |
| 3120 | Name prefix (Vorsatzwort) | <=20 | a | | | bei der |
| 3121 | PO box postal code (PostfachPLZ) | <=10 | a | | | |
| 3122 | PO box city (PostfachOrt) | <=40 | a | | | |
| 3123 | PO box (Postfach) | <=8 | a | | | |
| 3124 | PO box residence country code (PostfachWohnsitzlaendercode) | <=3 | a | | | |
| 4104 | Billing VKNR (Abrechnungs-VKNR) | 5 | n | 017, 201, 212, 790 | | 27106 |
| 4106 | Cost carrier billing area (Kostentrager-Abrechnungsbereich, KTAB) | 2 | n | 174, 778, 779, 780, 818, 827 | 00 = Primary billing (Primarabrechnung); 01 = Social insurance agreement (Sozialversicherungsabkommen, SVA); 02 = Federal supply act (Bundesversorgungsgesetz, BVG); 03 = Federal compensation act (Bundesentschadigungsgesetz, BEG); 04 = Cross-border commuter (Grenzganger, GG); 05 = Rhine shipping (Rheinschiffer, RHS); 06 = Social welfare carrier without asylum centers (Sozialhilfetrager, ohne Asylstellen, SHT); 07 = Federal expellees act (Bundesvertriebenengesetz, BVFG); 08 = Asylum centers (Asylstellen, AS); 09 = Pregnancy termination benefits (Schwangerschaftsabbruche) | 00 |
| 4109 | Last insurance card read date in quarter (Letzter Einlesetag der Versichertenkarte im Quartal) | 8 | d | 776, 790, 876 | | 20210505 |
| 4110 | Insurance coverage end (VersicherungsschutzEnde) | 8 | d | 321 | | 20201010 |
| 4111 | Cost carrier identifier (Kostentraegerkennung) | 9 | n | 202 | | 101568008 |
| 4112 | eEB available (eEB vorhanden) | 1 | n | 142, 895 | 1 = yes (ja) | |
| 4124 | SKT supplementary information (SKT-Zusatzangaben) | 5<=60 | a | 734 | | Osterreich |
| 4125 | Validity period from ... to ... (Gultigkeitszeitraum von ... bis ...) | 16 | n | 058, 364, 365, 366 | | 2019100120191015 |
| 4126 | SKT remarks (SKT-Bemerkungen) | <=60 | a | | | |
| 4131 | Special person group (BesonderePersonengruppe) | 2 | a | 534, 778, 779, 780, 818, 827 | 00 = no special person group (default); 04 = BSHG (Bundessozialhilfegesetz) S 264 SGB V; 06 = SER (Soziales Entschadigungsrecht) (formerly BVG); 07 = SVA identifier for cross-border health insurance law: persons with domestic residence, billing by expenditure; 08 = SVA identifier, flat-rate; 09 = Recipient of health benefits under SS 4 and 6 of the Asylum Seekers Benefits Act (AsylbLG) | |
| 4132 | DMP identifier (DMP_Kennzeichnung) | 2 | a | 536 | 00 = no DMP identifier (default); 01 = Diabetes mellitus Typ 2; 02 = Brustkrebs; 03 = Koronare Herzkrankheit; 04 = Diabetes mellitus Typ 1; 05 = Asthma bronchiale; 06 = COPD (chronic obstructive pulmonary disease); 07 = Chronische Herzinsuffizienz; 08 = Depression; 09 = Ruckenschmerz; 10 = Rheuma; 11 = Osteoporose; 12 = Adipositas; 30 = Diabetes Typ 2 und KHK; 31 = Asthma und Diabetes Typ 2; 32 = COPD und Diabetes Typ 2; 33 = COPD und KHK; 34 = COPD, Diabetes Typ 2 und KHK; 35 = Asthma und KHK; 36 = Asthma, Diabetes Typ 2 und KHK; 37 = Brustkrebs und Diabetes Typ 2; 38 = Diabetes Typ 1 und KHK; 39 = Asthma und Diabetes Typ 1; 40 = Asthma und Brustkrebs; 41 = Brustkrebs und KHK; 42 = Brustkrebs und COPD; 43 = COPD und Diabetes Typ 1; 44 = Brustkrebs, Diabetes Typ 2 und KHK; 45 = Asthma, Brustkrebs und Diabetes Typ 2; 46 = Brustkrebs und Diabetes Typ 1; 47 = COPD, Diabetes Typ 1 und KHK; 48 = Brustkrebs, COPD und Diabetes Typ 2; 49 = Asthma, Diabetes Typ 1 und KHK; 50 = Asthma, Brustkrebs und KHK; 51 = Brustkrebs, COPD und KHK; 52 = Brustkrebs, COPD, Diabetes Typ 2 und KHK; 53 = Asthma, Brustkrebs, Diabetes Typ 2 und KHK; 54 = Brustkrebs, Diabetes Typ 1 und KHK; 55 = Asthma, Brustkrebs und Diabetes Typ 1; 56 = Asthma, Brustkrebs, Diabetes Typ 1 und KHK; 57 = Brustkrebs, COPD und Diabetes Typ 1; 58 = Brustkrebs, COPD, Diabetes Typ 1 und KHK | |
| 4133 | Insurance coverage start (VersicherungsschutzBeginn) | 8 | d | 322, 775 | | |
| 4218 | (N)BSNR of referrer ((N)BSNR des Uberweisers) | 9 | n | 049 | | |
| 4242 | Lifetime physician number of referrer (Lebenslange Arztnummer des Uberweisers) | 9 | n | 056, 764 | | |
| 5009 | Free-text justification (freier Begrundungstext) | <=60 | a | | | Dokumentation der Abrechnungsbegrundung |
| 5027 | Hybrid-DRG service (Hybrid-DRG Leistung) | 4 | a | 066, 221 | | G24M |
| 5028 | Service start date (Datum Beginn der Leistung) | 8 | d | 365, 390, 706 | | 20240502 |
| 5029 | Service end date (Datum Ende der Leistung) | 8 | d | 366 | | 20240503 |
| 5030 | Ventilation hours (Beatmungsstunden) | <=4 | n | 896 | | 0 |
| 5034 | Surgery date (OP-Datum) | 8 | d | 314, 321, 322, 364 | | 20191003 |
| 5035 | OPS code (OP-Schlussel) | <=8 | a | 223 | | 5-301.1 |
| 5041 | OPS laterality (Seitenlokalisation OPS) | 1 | a | 110, 178, 706 | R = right (rechts); L = left (links); B = bilateral (beidseitig) (treatments up to 31.12.2025 can use range of Regel 110; from 01.01.2026 the allowed range for FK 5041 is Regel 178: R, L) | R |
| 5098 | (N)BSNR of service location ((N)BSNR des Ortes der Leistungserbringung) | 9 | n | 049 | | |
| 5099 | Lifetime physician number (LANR) of contracted physician/psychotherapist (Lebenslange Arztnummer (LANR) des Vertragsarztes/Vertragspsychotherapeuten) | 9 | n | 056, 764 | | |
| 6009 | Primary diagnosis (ICD-10-GM code) (Hauptdiagnose (ICD-10-GM-Kode)) | 3, 5, 6 | a | 024, 493, 494, 498, 499, 735, 737 | | J09.6 |
| 6010 | Laterality of primary diagnosis (Seitenlokalisation Hauptdiagnose) | 1 | a | 110 | R = right (rechts); L = left (links); B = bilateral (beidseitig) | |
| 6011 | Secondary diagnosis (ICD-10-GM code) (Nebendiagnose (ICD-10-GM-Kode)) | 3, 5, 6 | a | 024, 493, 494, 498, 499, 735, 737 | | |
| 6012 | Laterality of secondary diagnosis (Seitenlokalisation Nebendiagnose) | 1 | a | 110 | R = right (rechts); L = left (links); B = bilateral (beidseitig) | |
| 8000 | Record type (Satzart) | 5 | a | 623, 824 | hdrg0 = Hybrid-DRG data package header; hdrg9 = Hybrid-DRG data package closing; hdrg1 = Hybrid-DRG | |
| 9117 | Creation date Hybrid-DRG data package (Erstellungsdatum Hybrid-DRG-Datenpaket) | 8 | d | | | 20240502 |
| 9212 | Record description version (Version der Satzbeschreibung) | <=11 | a | 031, 824 | | |
| 9901 | System-internal parameter (Systeminterner Parameter) | <=60 | a | 999* | | abcd/q<rs |
