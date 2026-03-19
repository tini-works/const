## KADT Rule Table (Regeltabelle)

| Field | Value |
|-------|-------|
| **Source** | KVDT-DSB v6.02 |
| **Section** | 4.7.2 |
| **Scope** | Validation rules for KADT data package |

Rules marked with asterisk (*) are relevant only for the case preparation software of the Kassenarztlichen Vereinigungen, not for billing software. Rules marked with hash (#) have special validation behavior.

### Rules

| R-Nr | Category | Check | Status | Description |
|------|----------|-------|--------|-------------|
| 016 | Format | QJJJJ | F | Q = Quarter, JJJJ = Year |
| 017 | Format | nnmmm | F | nn = KV identifier, mmm = serial number. Value range nn: 01 = KV Schleswig-Holstein, 02 = KV Hamburg, 03 = KV Bremen, 06 = Aurich, 07 = Braunschweig, 08 = Gottingen, 09 = Hannover, 10 = Hildesheim, 11 = Luneburg, 12 = Oldenburg, 13 = Osnabruck, 14 = Stade, 15 = Verden, 16 = Wilhelmshaven, 17 = KV Niedersachsen, 18 = Dortmund, 19 = Munster, 20 = KV Westfalen-Lippe, 21 = Aachen, 24 = Dusseldorf, 25 = Duisburg, 27 = Koln, 28 = LinkerNiederrhein, 31 = Ruhr, 37 = Bergisch-Land, 38 = KV Nordrhein, 39 = Darmstadt, 40 = Frankfurt/Main, 41 = Giessen, 42 = Kassel, 43 = Limburg, 44 = Marburg, 45 = Wiesbaden, 46 = KV Hessen, 47 = Koblenz, 48 = Rheinhessen, 49 = Pfalz, 50 = Trier, 51 = KV Rheinland-Pfalz, 52 = KV Baden-Wurttemberg, 53 = Mannheim, 54 = Pforzheim, 55 = Karlsruhe, 56 = Baden-Baden, 57 = Freiburg, 58 = Konstanz, 59 = Offenburg, 60 = Freiburg, 61 = Stuttgart, 62 = Reutlingen, 63 = Munchen Stadt und Land, 64 = Oberbayern, 65 = Oberfranken, 66 = Mittelfranken, 67 = Unterfranken, 68 = Oberpfalz, 69 = Niederbayern, 70 = Schwaben, 71 = KV Bayerns, 72 = KV Berlin, 73 = KV Saarland, 74 = KBV, 78 = KV Mecklenburg-Vorpommern, 79 = Potsdam, 80 = Cottbus, 81 = Frankfurt/Oder, 83 = KV Brandenburg, 85 = Magdeburg, 86 = Halle, 87 = Dessau, 88 = KV Sachsen-Anhalt, 89 = Erfurt, 90 = Gera, 91 = Suhl, 93 = KV Thuringen, 94 = Chemnitz, 95 = Dresden, 96 = Leipzig, 98 = KV Sachsen, 99 = KBV-Pseudo-Nummer |
| 021 | Format | JJJJMMTT | F | TT=Day; MM=Month; JJJJ=Year. Additionally allowed value range: JJJJMM00, JJJJ0000, 00000000 |
| 022 | Format | ann, ann.n, ann.nn, ann.n- | F | |
| 031 | Format | [a]aaaMMJJ.nn | F | [a]aaa = data package abbreviation, MM = Month, JJ = Year, nn = sub-version number |
| 042 | Format | nnnnn, nnnnn[G-alpha] | F | |
| 049 | Format | kknnnnnnmm | F | kk = allowed content per Regel 162, mm = [undefined] |
| 050 | Format | Nnnnnnmff | F | m = check digit, where "nnnnnn" must not equal "555555"; ff = allowed content per Anlage 35 of BAR key directory, tolerated substitute value for digits 8-9: 00. Procedure for determining the check digit see footnote 5. |
| 052 | Format | a/n[n][n]/JJMM/nn/aaa | F | a = [V, X, Y, Z], n = numeric, JJ = Year, MM = Month, aaa = alphanumeric |
| 054 | Format | annnnnnnP | F | a = A-Z (without Umlaut), n = numeric, P = check digit (numeric). Procedure for determining the check digit. |
| 055 | Format | n[n][n].n[n][n].n[n][n] | F | n = numeric |
| 060 | Format | JJJJMMTThhmmss | F | JJJJ = Year, MM = Month, TT = Day, hh = Hour, mm = Minute, ss = Second |
| 101 | allowed content | 1 | F | 1 = Field checked = Yes |
| 106 | allowed content | 1, 2, 3 | F | |
| 109 | allowed content | V, Z, A, G | F | |
| 110 | allowed content | R, L, B | F | |
| 116 | allowed content | 1, 3, 5 | F | |
| 142 | allowed content | 1 | F | |
| 162 | allowed content | 01-03, 06-21, 24, 25, 27, 28, 31, 37-73, 78-81, 83, 85-88, 93-96, 98, 99 | F | UKV/OKV identifiers in the practice establishment numbers + Knappschaft |
| 165 | allowed content | kad0, kad9, 0109 | F | |
| 166 | allowed content | 20 | F | |
| 168 | allowed content | 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 | F | |
| 174 | allowed content | 00, 01, 02, 03, 04, 05, 06, 07, 08, 09 | F | |
| 201 | Existence check | Kassendatei (insurance fund file) | I | Billing VKNR present and 5 digits |
| 202 | Existence check | Kassendatei (insurance fund file) | I | Health insurance number (IK) present and 9 digits |
| 203* | Existence check | GO-Stammdatei (fee schedule master file) | - | |
| 204# | Existence check | Anbieterstammdatei (provider master file) | W | Check number exists and valid |
| 212 | allowed content | not equal to 74799 | F | Cost carrier with VKNR 74799 must not be transmitted in billing to the KVen |
| 213# | Existence check | Anbieterstammdatei (provider master file) | F | Extended existence check: If check number not in provider master file, then: (1st month of validity (/JJMM/) + validity duration in months (/MM/) + 12 months) > = value in field "Abrechnungsquartal" (FK 9204) |
| 304 | Context | Date <= machine date | F | Avoidance of erroneous entries |
| 308 | Context | Field content of FK 3006 >= 5.2.0 | W | |
| 313 | Context | Date of birth <= service date | F | Avoidance of erroneous entries |
| 315 | Context | If FK 4110 is present, then: Service date (FK 5000) <= Insurance coverage end (FK 4110) | W | Avoidance of erroneous entries |
| 316 | Context | Service date (FK 5000) >= Arrival date (FK 4264) | F | |
| 317 | Context | If FK 4272 is not present, then: Service date (FK 5000) <= Departure date (FK 4265) | F | |
| 318 | Context | If FK 4272 is not present and FK 4266 is present, then: Service date (FK 5000) <= Early termination date (FK 4266) | F | |
| 382 | Context | Only if content of 4261 = 1 or 2, may field 4262 or 4272 be present | F | |
| 383 | Context | Only if field 4262 or 4272 is present, may field 4271 be present | F | |
| 489 | Context | If for the ICD code (FK 6001/3673) in SDICD the elements "untere_altersgrenze" and/or "obere_altersgrenze" exist, then the age calculated from date of birth FK 3103 must be above the "untere_altersgrenze" and below the "obere_altersgrenze". The content of element "altersbezug_fehlerart" is "m". *) Maximum age is checked at quarter start and minimum age at quarter end. | W | SDICD |
| 490 | Context | If for the ICD code (FK 6001/3673) in SDICD the element "krankheit_in_mitteleuropa_sehr_selten" with content V="j" exists, then warning "Please check coding: Diagnoses of this code are very rare in Central Europe." | W | SDICD |
| 491 | Context | If for the ICD code (FK 6001/3673) in SDICD the element "geschlechtsbezug" exists and the content of "geschlechtsbezug_fehlerart" with V="m" is defined, and this condition does not match the patient gender (FK 3110), then FK 6008 or 3677 must be present | W | SDICD |
| 492 | Context | If for a diagnosis (FK 6001/3673) in SDICD the element "schlusselnummer_mit_inhalt_belegt" with content "n" exists, it must not be transmitted | F | SDICD |
| 528 | allowed content | 1, 2, 3, 4, 5, 6 | F | |
| 530 | allowed content | 00, 04 | F | |
| 533 | allowed content | M, W, U, X, D | F | |
| 536 | allowed content | 00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58 | F | |
| 537 | allowed content | not equal to T555558879 | F | |
| 728 | Context | The content of FK 6001/3673 must be present as element "icd_code" and with content V="j" of child element "abrechenbar" in SDICD. | F | SDICD |
| 729 | Context | If for a diagnosis (FK 6001/3673) the "notationskennzeichen" (SDICD) with content "*" or "!" exists (= secondary code), at least one ICD code FK 6001/3673 without "notationskennzeichen" (SDICD) or, if present, with content "+" (= primary code) must be present. | F | SDICD |
| 730 | Context | The value in FK 5098 must match one of the values from FK 0201 (SA "besa"), provided no prior-quarter case exists (content of FK 5000 within FK 9204 (kad0)). | F | Check against Besa record for current quarter cases (not for prior-quarter cases) |
| 731 | Context | The value in FK 5099 must match one of the values from FK 0212 (SA "besa"), provided the value in FK 5099 is not "999999900" (if content of FK 5000 within FK 9204 (kad0)). | W | Check against Besa record for current quarter cases (not for prior-quarter cases) |
| 761 | Context | If for the ICD code (FK 6001/3673) in SDICD the elements "untere_altersgrenze" and/or "obere_altersgrenze" exist, then the age calculated from date of birth FK 3103 must be above the "untere_altersgrenze" and below the "obere_altersgrenze". The content of element "altersbezug_fehlerart" is "k". | W | SDICD |
| 762 | Context | The (substitute) value "888888800" is obsolete and inadmissible as field content of FK 0212, 4241, 4242, 5099. | F | |
| 791 | Context | If FK 4109 is present, then fields 3006, 3119, 4133 and 4134 must be present. | F | KVK for GKV insured persons inadmissible since 01.01.2015 |
| 814 | Context | If the content of field 8000 = kad0, then the content of field 9212 must match the current version specification. | W | |
| 817 | Context | If for an ICD code (field content FK 6001 or 3673) in SDICD the element "geschlechtsbezug" exists and the content of element "geschlechtsbezug_fehlerart" = "k" and no field 6008/3677 is present, then the gender in FK 3110 (if 3110 is not U, X, D) must match the specification under element "geschlechtsbezug" (SDICD). | W | SDICD |
| 856 | Context | If the field content of FK 6001 = "Z01.7", then the field content of FK 6003 must be "G". | W | |
| 865 | Context | Online check date/time and update timestamp (FK 3010) >= Arrival date (FK 4264) | W | |
| 866 | Context | If FK 4272 is not present, then: Online check date/time and update timestamp (FK 3010) <= Departure date (FK 4265). If FK 4272 is present, then: Online check date/time and update timestamp (FK 3010) <= Departure date as part 2 for refresher (FK 4277) | W | |
| 867 | Context | If field identifier 4266 is present, then field identifier Online check date/time and update timestamp (FK 3010) <= Early termination date (FK 4266). If field identifier 4278 is present, then field identifier Online check date/time and update timestamp (FK 3010) <= Early termination date as part 2 for refresher (FK 4278) | W | |
| 876 | Context | If FK 3010 is present, then FK 4109 must also be present. | W | |
| 879 | Context | If field 4272 is present, then fields 4276 and 4277 may be present. | W | |
| 880 | Context | If field 4272 is present, field 4278 may be present. | W | |
| 881 | Context | Either FK 4262 or FK 4272 or neither must be set. | W | |
| 882 | Context | If FK 4272 is present, then: Service date (FK 5000) can be in the following time periods: 1. FK 5000 must >= FK 4264 and <= 4265; 2. FK 5000 must >= 4276 and <= 4277 | W | Covers the case of a compact spa as refresher. The insured comes for the first and second part of the spa. |
| 883 | Context | If FK 4272 and FK 4266 are present, then: Service date (FK 5000) can be in the following time periods: 1. FK 5000 must >= FK 4264 and <= 4265 and <= 4266; 2. FK 5000 must >= 4276 and <= 4277 | W | Covers the case of a compact spa as refresher. The insured comes for the first and second part of the spa. However, the first part is terminated early. |
| 884 | Context | If FK 4272 and FK 4278 are present, then: Service date (FK 5000) can be in the following time periods: 1. FK 5000 must >= FK 4264 and <= 4265; 2. FK 5000 must >= 4276 and <= 4277 and <= 4278 | W | Covers the case of a compact spa as refresher. The insured comes for the first and second part of the spa. However, the second part is terminated early. |
| 885 | Context | If FK 4272 and FK 4266 and FK 4278 are present, then: Service date (FK 5000) can be in the following time periods: 1. FK 5000 must >= FK 4264 and <= 4265 and <= 4266; 2. FK 5000 must >= 4276 and <= 4277 and <= 4278 | W | Covers the case of a compact spa as refresher. The insured comes for the first and second part of the spa. However, both the first and second part are terminated early. |
| 895 | Context | If FK 4112 is present, then FK 4109 and FK 3010 and FK 4108 and FK 3006 must not be present. | W | |
| 999* | special notes | Read by KV, can appear in any record type multiple times | | For Praxiscomp. For return transmission |

### Note: Printed Form "Kurarztschein" (Section 4.8, p145)

The "Kurarztschein" (spa physician certificate) is the official accompanying document for spa physician billing. Its front side contains fields for health insurance fund, patient name/DOB, cost carrier ID, insured person number, status, practice number, physician number, date, type of ambulatory preventive care (3 checkboxes), compact spa checkbox, spa location, duration in weeks, permanent medication (yes/no/which), treatment history, preventive care fitness, notes/restrictions, behavioral preventive measures recommended (yes/no), date and physician stamp/signature. The back side documents arrival date, departure date, early termination date, extension approval (weeks, via phone/letter/fax, date), up to 12 examination/patient contact dates per S 14 of the spa physician contract, diagnoses/impairments/functional disorders/findings/risk factors/regulation-/well-being disorders, behavioral preventive measures (initiated/performed), and compact spa not possible checkbox.
