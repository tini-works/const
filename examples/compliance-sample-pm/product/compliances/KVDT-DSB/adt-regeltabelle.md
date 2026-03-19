## ADT Rule Table (Regeltabelle)

| Field | Value |
|-------|-------|
| **Source** | KVDT-DSB v6.02 |
| **Section** | 3.5.2 |
| **Scope** | Validation rules for ADT data package |

> Rules marked with (*) apply only to case preparation software (Fallaufbereitungs-Software) of Kassenärztliche Vereinigungen, not to billing software.

### Rules

| R-Nr | Category | Check | Status | Description |
|------|----------|-------|--------|-------------|
| 005 | Format | HHMM | F | HH = Hour, MM = Minute; Value range: 0000-2359 |
| 016 | Format | QJJJJ | F | Q = Quarter, JJJJ = Year |
| 017 | Format | nnmmm | F | nn = KV identifier; mmm = serial number; Value range nn: 01 = KV Schleswig-Holstein; 02 = KV Hamburg; 03 = KV Bremen; 06 = Aurich; 07 = Braunschweig; 08 = Göttingen; 09 = Hannover; 10 = Hildesheim; 11 = Lüneburg; 12 = Oldenburg; 13 = Osnabrück; 14 = Stade; 15 = Verden; 16 = Wilhelmshaven; 17 = KV Niedersachsen; 18 = Dortmund; 19 = Münster; 20 = KV Westfalen-Lippe; 21 = Aachen; 24 = Düsseldorf; 25 = Duisburg; 27 = Köln; 28 = Linker Niederrhein; 31 = Ruhr; 37 = Bergisch-Land; 38 = KV Nordrhein; 39 = Darmstadt; 40 = Frankfurt/Main; 41 = Gießen; 42 = Kassel; 43 = Limburg; 44 = Marburg; 45 = Wiesbaden; 46 = KV Hessen; 47 = Koblenz; 48 = Rheinhessen; 49 = Pfalz; 50 = Trier; 51 = KV Rheinland-Pfalz; 52 = KV Baden-Württemberg; 53 = Mannheim; 54 = Pforzheim; 55 = Karlsruhe; 56 = Baden-Baden; 57 = Freiburg; 58 = Konstanz; 59 = Offenburg; 60 = Freiburg; 61 = Stuttgart; 62 = Reutlingen; 63 = München Stadt und Land; 64 = Oberbayern; 65 = Oberfranken; 66 = Mittelfranken; 67 = Unterfranken; 68 = Oberpfalz; 69 = Niederbayern; 70 = Schwaben; 71 = KV Bayerns; 72 = KV Berlin; 73 = KV Saarland; 74 = KBV; 78 = KV Mecklenburg-Vorpommern; 79 = Potsdam; 80 = Cottbus; 81 = Frankfurt/Oder; 83 = KV Brandenburg; 85 = Magdeburg; 86 = Halle; 87 = Dessau; 88 = KV Sachsen-Anhalt; 89 = Erfurt; 90 = Gera; 91 = Suhl; 93 = KV Thüringen; 94 = Chemnitz; 95 = Dresden; 96 = Leipzig; 98 = KV Sachsen; 99 = KBV-Pseudo-Nummer |
| 021 | Format | JJJJMMTT | F | TT = Day, MM = Month, JJJJ = Year; additionally allowed value range: JJJJMM00, JJJJ0000, 00000000 |
| 022 | Format | ann, ann.n, ann.nn, ann.n- | F | |
| 027 | Format | JJJJ | F | JJJJ = Year |
| 031 | Format | [a]aaaMMJJ.nn | F | [a]aaa = Data package abbreviation, MM = Month, JJ = Year, nn = sub-version number |
| 035 | Format | G-alpha[n[n[n]]][K-alpha[aerw]]][/Lkz] or [G-alpha]n[n[n]]][K-alpha[aerw]][/Lkz] | F | At least one character from set "G-alpha" or at least one character from set "n" must be present in a GNR. Value set: G-alpha ::= A\|B\|...\|Z; K-alpha ::= A\|B\|...\|Z\|a\|b\|c\|d; n ::= 0\|1\|...\|9; Lkz ::= A\|B\|.\|Z\|0\|1\|.\|9\|#\|$\|*\|<\|>; aerw ::= A\|B\|...\|Z\|1\|2\|3\|4; [ ] An element from this symbol class may optionally be used, i.e. it occurs exactly once or not at all. |
| 042 | Format | nnnnn, nnnnn[G-alpha] | F | n ::= 0\|1\|...\|9; G-alpha ::= A\|B\|...\|Z |
| 049 | Format | Kknnnnnmm with kk = allowed content per Rule 162; nnnnn = serial number; mm = [undefined] | F | |
| 050 | Format | nnnnnnmff with nnnnnn = ID, where "nnn-nnn" must not equal "555555"; m = check digit; ff = allowed content per Annex 35 of BAR key directory, tolerated substitute value for digits 8-9: 00 | F | Procedure for determining check digit see footnote 5 |
| 052 | Format | a/n[n]/JJMM/nn/aaa | F | a = [V, X, Y, Z]; n = numeric; JJ = Year; MM = Month; aaa = alphanumeric |
| 053 | Format | nnnnnn[n][n][n][n][n] | F | n = numeric |
| 054 | Format | annnnnnnP | F | a = A-Z (without umlauts); n = numeric; P = check digit, numeric; Procedure for determining check digit see explanation on page 189 |
| 055 | Format | n[n][n].n[n][n].n[n][n] | F | n = numeric |
| 056 | Format | nnnnnnmff with nnnnnn = ID, where "nnn-nnn" must not equal "555555"; m = check digit; ff = allowed content per Annex 35 of BAR key directory, tolerated substitute value for digits 8-9: 00 | W | Procedure for determining check digit see footnote 5 |
| 058 | Format | JJJJMMTTJJJJMMTT | F | TT = Day, MM = Month, JJJJ = Year |
| 059 | Format | 00nnnnnnP with 00 = ASV-ID prefix; nnnnnn = unique number; P = check digit | I | Procedure for determining check digit see footnote 3 |
| 060 | Format | JJJJMMTThhmmss | F | JJJJ = Year, MM = Month, TT = Day, hh = Hour, mm = Minute, ss = Second |
| 061 | Format | 35kknnnnn with 35 = Hospitals providing services under § 75 Abs. 1a SGB V; kk = allowed content per Rule 162; nnnnn = serial number | F | (N)BSNR KH providing services at the appointment service center (Anlage 28 BMV-Ä); Structure of BSNR see footnote 6 |
| 062 | Format | 74kknnn63 with 74 = KBV; kk = allowed content per Rule 162; nnn = serial number; 63 = SAPV identifier | F | (N)BSNR SAPV; Structure of BSNR see footnote 7 |
| 063 | Format | 555555nff with 555555 = Pseudo physician number for hospital physicians in ASV billing; n = sequence number; ff = specialty group code per applicable Annex 2 of the Richtlinie der Kassenärztlichen Bundesvereinigung nach § 75 Abs. 7 SGB V zur Vergabe der Arzt-, Betriebsstätten- und Praxisnetznummern | F | Pseudo-LANR for hospital physicians in ASV billing (ASV-AV Anlage 3 specialty group codings); Value set: n ::= 0\|1\|...\|9 |
| 064 | Format | 555555nff with 555555 = Pseudo physician number for hospital physicians in ASV billing; n = sequence number; ff = specialty group code per applicable Annex 2 of the Richtlinie der Kassenärztlichen Bundesvereinigung nach § 75 Abs. 7 SGB V zur Vergabe der Arzt-, Betriebsstätten- und Praxisnetznummern | W | Pseudo-LANR for hospital physicians in ASV billing (ASV-AV Anlage 3 specialty group codings); Value set: n ::= 0\|1\|...\|9 |
| 106 | Allowed Content | 1, 2, 3 | F | |
| 108 | Allowed Content | 1, 2, 3, 4, 6 | F | |
| 109 | Allowed Content | V, Z, A, G | F | |
| 110 | Allowed Content | R, L, B | F | |
| 111 | Allowed Content | Z1, Z2, Z3, Z4 | F | Travel fee zones |
| 113 | Allowed Content | 0, 1, 2, 3 | F | |
| 116 | Allowed Content | 1, 3, 5 | F | |
| 129 | Allowed Content | 02-99 | F | |
| 131 | Allowed Content | 00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 14, 15 | F | Billing area |
| 132 | Allowed Content | 01-99 | F | |
| 142 | Allowed Content | 1 | F | |
| 147 | Allowed Content | 0, 1 | F | |
| 149 | Allowed Content | 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12 | F | Person group / examination category |
| 162 | Allowed Content | 01-03, 06-21, 24, 25, 27, 28, 31, 37-73, 78-81, 83, 85-88, 93-96, 98, 99 | F | UKV-/OKV identifiers in practice site numbers + Knappschaft |
| 174 | Allowed Content | 00, 01, 02, 03, 04, 05, 06, 07, 08, 09 | F | |
| 175 | Allowed Content | adt0, adt9, 0101, 0102, 0103, 0104 | F | |
| 176 | Allowed Content | 1, 2, 3, 4 | F | |
| 178 | Allowed Content | L, R | F | |
| 201 | Existence Check | Kassendatei (Insurance file) | I | Billing VKNR present and 5-digit |
| 202 | Existence Check | Kassendatei (Insurance file) | I | Health insurance number (IK) present and 9-digit |
| 203* | Existence Check | GO-Stammdatei (Fee schedule master data) | - | |
| 204# | Existence Check | Anbieterstammdatei (Provider master data) | W | Verification number exists and valid |
| 205 | Allowed Content | 1, 2, 3, 4 | F | |
| 210 | Existence Check | Kassendatei, if content of FK 4122 < 80 | W | Fee schedule only checked when no selective contract exists. |
| 212 | Allowed Content | ≠ 74799 | F | The cost bearer with VKNR 74799 must not be transmitted to the KVen in the billing |
| 213# | Existence Check | Anbieterstammdatei (Provider master data) | F | Extended existence check: If verification number not in provider master data, then: (Start 1st month of validity (/JJMM/) + validity duration in months (/MM/) + 12 months) > = entry in field "Billing quarter" (FK 9204) |
| 222 | Existence Check | Datei HGNC-Schlüsseltabelle (HGNC key table file) | F | HGNC gene symbol (content FK 5077) in Element /key/@DN |
| 223 | Existence Check | OPS-Stammdatei (OPS master data) | F | OP code (content FK 5035) in Element ../opscode_liste/opscode/@V |
| 304 | Context | Date ≤ machine date | F | Prevention of input errors |
| 307 | Context | If FK 4109 and FK 3119 are present and content of FK 4239 ≠ 21, 27, 28, FK 3006 must be present. | W | |
| 308 | Context | Content of FK 3006 >= 5.2.0 | W | |
| 313 | Context | Date of birth ≤ service date | F | Prevention of input errors |
| 315 | Context | If FK 4110 is present, then: Service date (FK 5000) ≤ Insurance coverage end (FK 4110) | W | Prevention of input errors |
| 319 | Context | Content of field 4218 must not be identical to content of field 4217 | F | Prevention of input errors; Explanation see Chapter 3.6.1 "Laboratory order to specialist laboratory" |
| 320 | Context | If field content of FK 8000 = 0102, then: FK 4220 must only be present when field content of FK 4239 ≠ 27, 28 | F | |
| 324 | Context | The content of field 5000 must be within the timeframe defined by the quarter specification (4101) | F | |
| 328 | Context | If field content of 8000 = 0102, then either field 4218 or field 4219 or field 4226 must be present. (XOR) Only one of the fields 4218, 4219 or 4226 may be present in a record 0102. | F | |
| 331 | Context | If field content of 8000 = 0101, then only 00 is allowed as content of FK 4239. | F | |
| 354 | Context | If field content of 4239 = 30, then field 4233 must be present | F | |
| 356 | Context | If content of 8000 = 0102, then allowed values of 4239 are 20, 21, 23, 24, 26, 27, 28 | F | |
| 363 | Context | The content of field 5000 (service date) must be within the timeframe defined by field 4125 (validity period from ... to ...) | F | Prevention of input errors |
| 404 | Context | If field content of FK 4239 = 27, 28, then field 4221 must be present. Field 4221 must not be present when field content of FK 4239 ≠ 27, 28. | F | |
| 405 | Context | If field content of FK 4239 = 27 or FK 4239 = 28, then field 4102 must be present | F | |
| 406 | Context | If FK 4102 is present, then: Issue date (FK 4102) ≤ Creation date (FK 9103, SA "con0"); Correct: 20190201 (01.02.2019) <= 20190202 (02.02.2019); Correct: 20190201 <= 20190201; Incorrect: 20190203 > 20190202 | F | Issue date is older than or equal to creation date |
| 426 | Context | If content of 8000 = 0103, then allowed values of 4239 are 30, 31, 32 | F | |
| 427 | Context | If content of 8000 = 0104, then allowed values of 4239 are 41, 42, 43, 44, 45, 46 | F | |
| 431 | Context | Only when FK 4239 = 27, either FK 4217 or FK 4225 may be present. | F | |
| 432 | Context | Only when FK 4239 = 27 or 28, FK 4229 may be present | F | |
| 478 | Context | If FK 3112 is present, then: If content of 4106 = 00 and there is no card read date (FK 4109), then the PLZ in FK 3112 must be present in the SDPLZ. | F | |
| 479 | Context | Field 3112 and/or 3121 must be present (per record type 0101-0104). **Exceptions**: Only when FK 3114 is present and content is not "D": If a card read date (FK 4109) is present, then FK 3112 need not be present. Only when FK 3124 is present and content is not "D": If a card read date (FK 4109) is present, then FK 3121 need not be present. | F | |
| 480 | Context | The content of field 4109 (card read date) must be within the timeframe defined by field 4101 (Quarter). | W | |
| 486 | Context | At least one of fields 6001 or 3673 must be present. | F | |
| 489 | Context | If for the ICD code (FK 6001/3673) in the SDICD the elements "untere_altersgrenze" and/or "obere_altersgrenze" exist, then the age calculated from date of birth FK 3103 must be above the "untere_altersgrenze" and below the "obere_altersgrenze". The content of element "altersbezug_fehlerart" is "m". *) Maximum age is calculated at quarter start and minimum age at quarter end. | W | SDICD |
| 490 | Context | If for the ICD code (FK 6001/3673) in the SDICD the element "krankheit_in_mitteleuropa_sehr_selten" has content V="j", then warning "Please check coding: Diagnoses of this code are very rare in Central Europe." | W | SDICD |
| 491 | Context | If for the ICD code (FK 6001/3673) in the SDICD the element "geschlechtsbezug" exists and the content of "geschlechtsbezug_fehlerart" is defined with V="m" and this condition does not match the gender of the patient (FK 3110), FK 6008 or 3677 must be present | W | SDICD |
| 492 | Context | If for a diagnosis (FK 6001/3673) in the SDICD the element "schluesselnummer_mit_inhalt_belegt" with content "n" exists, it must not be transmitted | F | SDICD |
| 496 | Context | If field content of 4121 = 3, then Rule 035 applies for the content of field 5001. | F | |
| 497 | Context | If field content of 4121 = 0 or 1 or 2, then Rule 042 applies for the content of field 5001. | F | |
| 521 | Allowed Content | N | F | |
| 528 | Allowed Content | 1, 2, 3, 4, 5, 6 | F | |
| 531 | Allowed Content | 00, 01, 02, 03, 17, 20, 38, 46, (47), (48), (49), (50), 51, 52, (55), (60), (61), (62), 71, 72, 73, 78, 83, 88, 93, 98 | F | WOP; ( ) merged, partially still in use (e.g. KVK-WOP) |
| 532 | Allowed Content | 01-03, 17, 18, 19, 20, 21, 24, 25, 27, 28, 31, 37, 39-45, 47-51, 55, 60-70, 72, 73, 78-81, 83, 85-87, 93-96, 99 | F | Recipient of billing: UKV-OKV identifiers of permitted billing recipients + identifier for Knappschaft |
| 533 | Allowed Content | M, W, U, X, D | F | |
| 534 | Allowed Content | 00, 04, 06, 07, 08, 09 | F | |
| 535 | Allowed Content | 002-999 | F | Multiplier / quantity |
| 536 | Allowed Content | 00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58 | F | |
| 537 | Allowed Content | ≠ T555558879 | F | |
| 701 | Context | If FK 4121 ≠ 3: If for the digit under FK 5001 per SDEBM the supplementary data "5034" is defined, FK 5034 must be present. | W | |
| 702 | Context | If FK 4121 ≠ 3: If for the GOP in field FK 5001 in the EBM master data exclusively the XML element ../gnr_zusatzangabe/@V="5035" or ../gnr_zusatzangabe/@V="5036" is present within a GNR supplementary data list, at least one field FK 5035 or FK 5036 must be present. If for the GOP in field FK 5001 in the EBM master data the XML elements ../gnr_zusatzangabe/@V="5035" and ../gnr_zusatzangabe/@V="5036" are both present within a GNR supplementary data list, at least either a field FK 5035 or a field FK 5036 must be present. | W | |
| 703 | Context | If FK 4121 ≠ 3: If for the GOP in field FK 5001 per Rule 702 at least field FK 5035 must be present and min. the XML element ../begruendungen_liste/ops_liste/ is present, then at least one content of field FK 5035 should match a content of attribute /@V of XML element ../begruendungen_liste/ops_liste/kategorie/ops. | W | |
| 704 | Context | If FK 4121 ≠ 3: If for the GOP in field FK 5001 per Rule 702 at least field FK 5036 must be present and min. the XML element ../begruendungen_liste/gnr_liste/ is present, then at least one content of field FK 5036 should match a content of attribute /@V of XML element ../begruendungen_liste/gnr_liste/gnr. | W | |
| 705 | Context | If FK 4121 ≠ 3: If the content of FK 5035 per SDOPS master data with "kzseite=J" is defined, a field FK 5041 must exist for this FK 5035. | W | |
| 706 | Context | If the value of FK 4101 < "12026", then the allowed value range of FK 5041 equals Rule 110. If the value of FK 4101 >= "12026", then the allowed value range of FK 5041 equals Rule 178. | F | For treatment cases up to and including Q4/2025, the value range of laterality of OPS codes can be L, R, and B. For treatment cases from Q1/2026, the value range of laterality of OPS codes can be L and R. |
| 707 | Context | If FK 5042 exists, FK 5005 must not be present | W | No multiplier allowed |
| 710 | Context | Content of FK 5012 ≤ 999999 | W | Check for realistic material costs |
| 715 | Context | If content of 4239 ≠ 28: The value in FK 5099 must match one of the values from FK 0212 (SA "besa"), provided the value in FK 5099 is not "999999900" (content of FK 4101 = FK 9204 (adt0)) | F | Check against besa record for current quarterly cases (analogous to Rule 716) |
| 716 | Context | If content of 4239 ≠ 28: The value in FK 5098 must match one of the values from FK 0201 (SA "besa"), provided no prior-quarter case exists (content of FK 4101 = FK 9204 (adt0)). | F | Check against besa record for current quarterly cases |
| 720 | Context | If FK 4239 = 28 and field 4218 is present, then the contents of FK 4218 and 5098 must be identical. | F | Federal collective agreement rule: referring physician is also "performing" physician |
| 721 | Context | If FK 4239 = 28 and field 4242 is present, then the contents of FK 4242 and 5099 must be identical. | F | Federal collective agreement rule: referring physician is also "performing" physician |
| 723 | Context | If content of 4239 = 28: The value in FK 5099 must match one of the values from FK 0212 (SA "besa"), provided the value in FK 5099 is not "999999900". | W | |
| 724 | Context | If content of 4239 = 28: The value in FK 5098 must match one of the values from FK 0201 (SA "besa"), provided no prior-quarter case exists (content of FK 4101 = FK 9204 (adt0)). | W | |
| 725 | Context | If content of FK 4239 = 28, then format rule 056 applies for the content of field 5099. If content of FK 4239 ≠ 28, then format rule 050 applies for the content of field 5099. | see Rule 050, 056 | Considers capture errors at SUG 28 when originating from referring physician LANR |
| 728 | Context | The content of FK 6001/3673 must exist as element "icd_code" and the child element "abrechenbar" with content V="j" in the SDICD. | F | SDICD |
| 729 | Context | If for a diagnosis (FK 6001/3673) the element "notationskennzeichen" (SDICD) with content "*" or "!" exists (= secondary code), at least one ICD code FK 6001/3673 without "notationskennzeichen" (SDICD) or, if present, with content "+" (= primary code) must be present. | F | SDICD |
| 734 | Context | If FK 8000 with content 0101, 0102, 0103, 0104 and the cost bearer matches KT group 75 (Element /kostentraegergruppe (kts)), then the content of field 4124 must match the format "TTMMJJannnnn". | W | Plausibility check of person identifier for federal SKT Bundeswehr |
| 738 | Context | The content of FK 9261 must be <= the content of FK 9260. | F | |
| 744 | Context | If field content of 4239 = 21, then field 4205 must be present. | F | |
| 746 | Context | If field content of 4239 = 31, then field 4218 and at least one of fields 4205, 4207 or 4208 must be present. | F | |
| 749 | Context | If the content of field 5001 matches the content of attribute /@gop of an element /key of the key table S_NVV_RV_Zertifikat and the content of field 9204 (adt0) is within /key/@gueltigkeit, then: At least one field 0304 (SA "rvsa") with the content from attribute /@V of the respective element /key with field 0305 = "1" or "2" must be present. | W | Plausibility check against RVSA record using key table S_NVV_RV_Zertifikat (OID 1.2.276.0.76.3.1.1.5.2.22) |
| 754 | Context | If field content of 4239 = 28, then content of 4221 must not be 3. | F | |
| 755 | Context | If field content of 4239 = 27, then field 4205 must be present. | F | |
| 756 | Context | If field content of 4239 = 28, then field 4209 may be present. Otherwise it must not be present. | W | |
| 761 | Context | If for the ICD code (FK 6001/3673) in the SDICD the elements "untere_altersgrenze" and/or "obere_altersgrenze" exist, then the age calculated from date of birth FK 3103 must be above the "untere_altersgrenze" and below the "obere_altersgrenze". The content of element "altersbezug_fehlerart" is "k". *) Maximum age is calculated at quarter start and minimum age at quarter end. | W | SDICD |
| 762 | Context | The (replacement) value "888888800" is obsolete and as field content of FK 0212, 4241, 4242, 5099 and 4299 inadmissible. | F | |
| 763 | Context | The KV area derived from positions 1-2 of FK 0201 must not match the content of attribute @V of element /kostentraeger/unz_kv_geltungsbereich_liste/unz_kv_geltungsbereich of the cost bearer master data (SDKT). | W | Check against cost bearer master data (see Anforderungskatalog KVDT, P2-265); SDKT |
| 770 | Context | If field content of 5001 = 11511[G-alpha], 11512[G-alpha], 11516[G-alpha], 11517[G-alpha], 11518[G-alpha] or 11521[G-alpha], then fields 5077 and 5079 must be present exactly once. | W | G-alpha ::= A\|B\|...\|Z; [ ] - optional; Documentation obligation also applies for the named GOPs with letter suffix |
| 774 | Context | If the content of field 3006 >= 5.2.0, then field 3116 must be present. | F | |
| 775 | Context | If FK 4109 and FK 3006 are present, then field 4133 must be present. | F | |
| 776 | Context | If FK 4109 is present and the content of positions 3-5 of field 4104 < 800, then field 3119 must be present. If FK 4109 is present and the content of positions 3-5 of field 4104 >= 800, then either field 3105 or 3119 must be present. | 776 | Context |
| 777 | Context | If FK 4109 is present and field content of FK 4239 ≠ 21, 27, 28, then field 4134 must be present. | F | The cost bearer name must always be transmitted when reading an insurance card, regardless of the certificate subgroup. |
| 778 | Context | If field content of FK 4131 = "07" or "08", then field content of FK 4106 must be "01" or "09". | F | |
| 779 | Context | If field content of FK 4131 = "06", then field content of FK 4106 must be "02" or "09". | F | |
| 780 | Context | If field content of FK 4131 = "04", then field content of FK 4106 must be "00" or "09". | F | |
| 783 | Context | If FK 3121 is present, then: If content of FK 4106 = 00 and there is no card read date (FK 4109), then the PLZ in FK 3121 must be present in the SDPLZ. | F | |
| 784 | Context | If FK 4109 and FK 3006 are present, then field 3114 and/or field 3124 must be present. | F | |
| 789 | Context | If field 5100 is present, then: The value in FK 5100 must match one of the values from FK 0222 (SA "besa"), provided no prior-quarter case exists (content of FK 4101 = FK 9204 (adt0)). | W | Check against besa record for current quarterly cases |
| 790 | Context | If FK 4109 is present and FK 3006 is not present, then the content of positions 3-5 of FK 4104 must be >= 800. | F | KVK from 01.01.2015 only permitted for "original" SKT |
| 813 | Context | If the content of field 8000 = adt0, then the content of field 9212 must match the current version specification. | W | |
| 816 | Context | If field content of 5001 = 11233[G-alpha], then field 5079 must be present. Additionally: Fields 5077 and 5078 must not be present. | W | G-alpha ::= A\|B\|...\|Z; [ ] - optional; Documentation obligation also applies for the named GOP with letter suffix |
| 817 | Context | If for an ICD code (field content FK 6001 or 3673) in the SDICD the element "geschlechtsbezug" exists and the content of element "geschlechtsbezug_fehlerart" = "k" and no field 6008/3677 is present, then the gender in FK 3110 (if 3110 ≠ U, X, D) must match the entry under element "geschlechtsbezug" (SDICD). | W | If the patient's gender does not match the entry in element "geschlechtsbezug", the PVS should indicate this (see KBV_ITA_VGEX_Anforderungskatalog_ICD-10, P10-470); SDICD |
| 818 | Context | If field content of FK 4131 = "09", then field content of FK 4106 should be "00" or "09". | W | |
| 820 | Context | If the content of field 8000 = 0102 and field 4217 is present and the content of positions 1-2 of field 4217 = 35, then format rule 061 applies for field 4217. If content of field 8000 = 0102 and field 4217 is present and the content of positions 1-2 of field 4217 ≠ 35, then format rule 049 applies for field 4217. | see Rule 049, 061 | (N)BSNR of referrer |
| 821 | Context | If the content of field 8000 = 0102 and field 4218 is present and the content of positions 1-2 of field 4218 = 35, then format rule 061 applies for field 4218. If content of field 8000 = 0102 and field 4218 is present and the content of positions 1-2 of field 4218 ≠ 35 and ≠ 77, then format rule 049 applies for field 4218. If content of field 8000 = 0102 and field 4218 is present and the content of positions 1-2 of field 4218 = 77, then the content of field 4218 must equal 777777700. | see Rule 049, 061 | (N)BSNR of referring physician |
| 822 | Context | If content of field 8000 = 0103 and field 4218 is present, then format rule 049 applies for field 4218. | see Rule 049 | (N)BSNR of referring physician |
| 823 | Context | If the content of positions 1-2 of field 5098 = 35, then format rule 061 applies for field 5098. If the content of positions 1-2 of field 5098 = 74, then format rule 062 applies for field 5098. If the content of positions 1-2 of field 5098 ≠ 35 and ≠ 74, then format rule 049 applies for field 5098. | see Rule 049, 061, 062 | (N)BSNR of place of service delivery |
| 827 | Context | If field 4109 is present and field 4131 = 00, then the field content of FK 4106 must be 00 or 09. | W | |
| 828 | Context | If field content of 5001 = 11302[G-alpha], 11303[G-alpha] or 19402[G-alpha], then at least field 6001 with content not equal "Z01.7" must be present and fields 5077 and 5079 must not be transmitted. | W | G-alpha ::= A\|B\|...\|Z; [ ] - optional; Documentation obligation also applies for the named GOP with letter suffix |
| 829 | Context | If field content of 5001 = 19421[G-alpha], 19451[G-alpha] or 19452[G-alpha], then field 5077 must be present exactly once per field 5001 **and** at least field 6001 with content not equal "Z01.7" must be present. | W | G-alpha ::= A\|B\|...\|Z; [ ] - optional; Documentation obligation also applies for the named GOP with letter suffix |
| 830 | Context | If field content of 5001 = 19424[G-alpha], 19453[G-alpha], or 19456[G-alpha], then field 5077 must be present at least once per field 5001 **and** at least field 6001 with content not equal "Z01.7" must be present. | W | G-alpha ::= A\|B\|...\|Z; [ ] - optional; Documentation obligation also applies for the named GOP with letter suffix |
| 834 | Context | If field content of 5001 = 11522[G-alpha] or 11513[G-alpha], then fields FK 5077 and FK 5079 must each be present at least once per field 5001. | W | G-alpha ::= A\|B\|...\|Z; [ ] - optional; Documentation obligation also applies for the named GOP with letter suffix |
| 837 | Context | If the content of field 8000 = 0101, 0102 or 0104, then: Either field 5099 or field 5101 must be present. | F | |
| 838 | Context | If field 4239 = 28 and field 4226 is present, then the contents of fields 4226 and 5100 must be identical. | I | "Referring physician" is also "performing" physician |
| 839 | Context | If field 5101 is present, then: the value in field 5101 must match one of the values from field 0223 (SA "besa"), provided no prior-quarter case exists (content of field 4101 = field 9204 (adt0)). | I | Check against besa record for current quarterly cases |
| 840 | Context | If field 9102 = "93" or "94" or "95" or "96", then the field content of field 0132 must match the regular expression "((.{1,23})\|(.{1,23})\\|([0-9][0-9][0-9])?([a-ku-x][a-z][1-9])\*([a-ku-x][A-Z][1-9])\*)" | W | 1-23: Version number; 24: fixed separator "\|"; 25-60: other information (footnote 9) |
| 843 | Context | If field content of 5001 = 32901[G-alpha], 32902[G-alpha], 32904[G-alpha], 32906[G-alpha], 32908[G-alpha], 32910[G-alpha] or 32911[G-alpha], then at least field 6001 with content not equal "Z01.7" must be present and fields 5077 and 5079 must not be transmitted. | W | G-alpha ::= A\|B\|...\|Z; [ ] - optional; Documentation obligation also applies for the named GOP with letter suffix |
| 844 | Context | If field 4225 is present, then either field 4241 or field 4248 must be present. | W | |
| 845 | Context | If field content of 4239 ≠ 28 and field 4226 is present, then either field 4242 or field 4249 must be present. If field content of 4239 = 28 and field 4226 is present, then field 4242 must be present. Field 4249 must not be present. | W | see Explanation Chapter 3.6.2 |
| 847 | Context | If field content of 5001 = 19421[G-alpha], 19451[G-alpha] or 19452[G-alpha], then field 5079 should be present exactly once per field 5001. | I | G-alpha ::= A\|B\|...\|Z; [ ] - optional; Documentation obligation also applies for the named GOP with letter suffix |
| 848 | Context | If field content of 5001 = 19424[G-alpha], 19453[G-alpha] or 19456[G-alpha], then field 5079 should be present at least once per field 5001. | I | G-alpha ::= A\|B\|...\|Z; [ ] - optional; Documentation obligation also applies for the named GOP with letter suffix |
| 850 | Context | Fields 4252 and 4253 may only be transmitted together. | F | |
| 851 | Context | Fields 4255 and 4256 may only be transmitted together. | F | |
| 852 | Context | If field 4255 is filled, field 4252 must also be filled. | F | |
| 853 | Context | In field 4253 GNR must not be transmitted multiple times. In field 4256 GNR must not be transmitted multiple times. | F | Examples: Transmitting code 35401 in FK 4253 and retransmitting code 35401 in FK 4256 is allowed. Transmitting code 35401 in FK 4253 and 35401B in FK 4256 is allowed. Transmitting code 35401 in FK 4253 and retransmitting code 35401 in FK 4253 is not allowed. Transmitting code 35401 in FK 4256 and transmitting code 35401B in FK 4256 is allowed. |
| 854 | Context | If field content of 5001 = 32915[G-alpha], 32916[G-alpha], 32917[G-alpha] or 32918[G-alpha], then at least field 6001 with content not equal "Z01.7" must be present and fields 5077 and 5079 must not be transmitted. | W | G-alpha ::= A\|B\|...\|Z; [ ] - optional; Documentation obligation also applies for the named GOP with letter suffix |
| 856 | Context | If the field content of FK 6001 = "Z01.7", then the field content of FK 6003 must be "G". | W | |
| 859 | Context | If the content of field 8000 = 0101, 0102 or 0104, then: Either field FK 5098 or field FK 5102 must be present. | F | |
| 860 | Context | The content of field 3673 must not be "Z01.7". | W | |
| 864 | Context | The content of field 3010 must be within the timeframe defined by the quarter specification (4101). | W | |
| 868 | Context | If for the GOP in field FK 5001 in the EBM master data the XML element ../gnr_zusatzangaben/gnr_zusatzangaben_liste/gnr_zusatzangabe/@V="5010" is present, then field 5010 must be present once per field 5001. | W | |
| 869 | Context | Provided no prior-quarter case exists (content of FK 4101 = FK 9204 (adt0)): If in a record FK 3010 is present, then for at least one of the (N)BSNRs specified under FK 5098 in the SA "besa" (FK 5098 equals FK 0201), field 0224 (product type version of connector) must be present. | W | |
| 870 | Context | If in a record FK 4103 is present and has value 3, then the content of field 8000 must be 0102. | F | |
| 876 | Context | If FK 3010 is present, then FK 4109 must also be present. | W | |
| 877 | Context | If the field content of FK 4103 = 3, then FK 4115 must be present. | W | For GP referral cases, the day is to be specified as determined by the GP as requiring treatment. |
| 886 | Context | The date in FK 4115 must not be more than 60 days before the date in FK 5000. Note: If the affected record type contains more than one FK 5000, the check is performed against the oldest field content of FK 5000. | W | The user should receive a hint that a relatively old date was entered for the appointment referral day. |
| 887 | Context | The date in field FK 4115 must not be greater than the system date. | W | |
| 888 | Context | If FK 4121 ≠ 3: If for the GOP in field FK 5001 in the EBM master data the XML element ../gnr_zusatzangabe/@V="5050" is present, field FK 5050 must be present. | W | |
| 889 | Context | If FK 4121 ≠ 3: If for the GOP in field FK 5001 in the EBM master data the XML element ../gnr_zusatzangabe/@V="5051" is present, field FK 5051 must be present. | W | |
| 890 | Context | If FK 4121 ≠ 3: If for the GOP in field FK 5001 in the EBM master data the XML element ../gnr_zusatzangabe/@V="5052" is present, field FK 5052 must be present. | W | |
| 891 | Context | If the content of field 5077 = "999999", then at least field 5078 must be present. | W | |
| 892 | Context | If for the GOP in field FK 5001 in the EBM master data the XML element ../gnr_zusatzangabe/@V="5077" is present, then field FK 5077 must be present at least once. | W | |
| 893 | Context | If the content of field 5077 is not equal to "999999", then field 5078 must not be present. | W | |
| 894 | Context | If FK 5050 and FK 5005 are present, then the count of present FK 5050 must equal the value of FK 5005. | W | Examples: FK 5050 is present once and FK 5005 is not present. FK 5050 is present twice and FK 5005 is present with value 002. FK 5050 is present twice and FK 5005 is not present. Note: FK 5005 can only occur with a minimum value of 002. |
| 895 | Context | If FK 4112 is present, then FK 4109 and FK 3010 and FK 4108 and FK 3006 must not be present. | W | |
| 897 | Context | If FK 4235 is present, then FK 4252 and FK 4253 should also be present. | W | |
| 899 | Context | The date of FK 4214 must not be greater than the date of FK 5000. | W | Allowed: FK 5000 equals 20260425; FK 4214 equals 20260425 or 20260424. Not allowed: FK 5000 equals 20260425; FK 4214 equals 20260426. |
| 900 | Context | The date of FK 4214 must not be more than one month and 60 days less than the date of FK 5000. | W | |
| 999* | Special Note | Read by KV, can occur multiple times in any record type | | For practice computing, on return transmission |
