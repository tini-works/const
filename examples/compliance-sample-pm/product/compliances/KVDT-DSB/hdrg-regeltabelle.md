## HDRG Rule Table (Regeltabelle)

| Field | Value |
|-------|-------|
| **Source** | KVDT-DSB v6.02 |
| **Section** | 6.5.5 |
| **Scope** | Validation rules for HDRG data package |

Rules marked with asterisk (*) are relevant only for the case preparation software of the Kassenarztlichen Vereinigungen, not for billing software. Rules marked with hash (#) have special validation behavior. Rule 539 is shown with strikethrough in the source, indicating it is deprecated.

### Rules

| R-Nr | Category | Check | Status | Description |
|------|----------|-------|--------|-------------|
| 017 | Format | nnmmm | F | nn = KV identifier, mmm = serial number. Value range nn: 01 = KV Schleswig-Holstein, 02 = KV Hamburg, 03 = KV Bremen, 06 = Aurich, 07 = Braunschweig, 08 = Gottingen, 09 = Hannover, 10 = Hildesheim, 11 = Luneburg, 12 = Oldenburg, 13 = Osnabruck, 14 = Stade, 15 = Verden, 16 = Wilhelmshaven, 17 = KV Niedersachsen, 18 = Dortmund, 19 = Munster, 20 = KV Westfalen-Lippe, 21 = Aachen, 24 = Dusseldorf, 25 = Duisburg, 27 = Koln, 28 = Linker Niederrhein, 31 = Ruhr, 37 = Bergisch-Land, 38 = KV Nordrhein, 39 = Darmstadt, 40 = Frankfurt/Main, 41 = Giessen, 42 = Kassel, 43 = Limburg, 44 = Marburg, 45 = Wiesbaden, 46 = KV Hessen, 47 = Koblenz, 48 = Rheinhessen, 49 = Pfalz, 50 = Trier, 51 = KV Rheinland-Pfalz, 52 = KV Baden-Wurttemberg, 53 = Mannheim, 54 = Pforzheim, 55 = Karlsruhe, 56 = Baden-Baden, 57 = Freiburg, 58 = Konstanz, 59 = Offenburg, 60 = Freiburg, 61 = Stuttgart, 62 = Reutlingen, 63 = Munchen Stadt und Land, 64 = Oberbayern, 65 = Oberfranken, 66 = Mittelfranken, 67 = Unterfranken, 68 = Oberpfalz, 69 = Niederbayern, 70 = Schwaben, 71 = KV Bayerns, 72 = KV Berlin, 73 = KV Saarland, 74 = KBV, 78 = KV Mecklenburg-Vorpommern, 79 = Potsdam, 80 = Cottbus, 81 = Frankfurt/Oder, 83 = KV Brandenburg, 85 = Magdeburg, 86 = Halle, 87 = Dessau, 88 = KV Sachsen-Anhalt, 89 = Erfurt, 90 = Gera, 91 = Suhl, 93 = KV Thuringen, 94 = Chemnitz, 95 = Dresden, 96 = Leipzig, 98 = KV Sachsen, 99 = KBV-Pseudo-Nummer |
| 021 | Format | JJJJMMTT | F | TT=Day; MM=Month; JJJJ=Year. Additionally allowed value range: JJJJMM00, JJJJ0000, 00000000 |
| 023 | Format | JJJJMMTT | W | TT=Day; MM=Month; JJJJ=Year |
| 024 | Format | ann, ann.n, ann.nn | F | |
| 031 | Format | [a]aaaMMJJ.nn | F | [a]aaa = data package abbreviation, MM = Month, JJ = Year, nn = sub-version number |
| 049 | Format | Kknnnnnnmm | F | kk = allowed content per Regel 162, nnnnn = serial number, mm = [undefined] |
| 052 | Format | a/n[n][n]/JJMM/nn/aaaa | F | a = [V, X, Y, Z], n = numeric, JJ = Year, MM = Month, aaaa = alphanumeric |
| 053 | Format | nnnnnn[n][n][n][n][n][n] | F | n = numeric |
| 054 | Format | annnnnnnP | F | a = A-Z (without Umlaut), n = numeric, P = check digit (numeric). Procedure for determining the check digit. |
| 055 | Format | n[n][n].n[n][n].n[n][n] | F | n = numeric |
| 056 | Format | nnnnnnmff | W | nnnnnn = ID, where "nnnnnn" must not equal "555555"; m = check digit; ff = allowed content per Anlage 35 of BAR key directory, tolerated substitute value for digits 8-9: 00. Procedure for determining the check digit see footnote 5. |
| 058 | Format | JJJJMMTTJJJJMMTT | F | TT = Day, MM = Month, JJJJ = Year |
| 060 | Format | JJJJMMTThhmmss | F | JJJJ = Year, MM = Month, TT = Day, hh = Hour, mm = Minute, ss = Second |
| 066 | Format | anna | F | a = A-Z (without Umlaut) [uppercase only], n = numeric (0-9) |
| 110 | allowed content | R, L, B | F | |
| 116 | allowed content | 1, 3, 5 | F | |
| 142 | allowed content | 1 | F | |
| 162 | allowed content | 01-03, 06-21, 24, 25, 27, 28, 31, 37-73, 78-81, 83, 85-88, 93-96, 98, 99 | F | UKV/OKV identifiers in practice establishment numbers + Knappschaft |
| 174 | allowed content | 00, 01, 02, 03, 04, 05, 06, 07, 08, 09 | F | |
| 178 | allowed content | R, L | F | |
| 201 | Existence check | Kassendatei (insurance fund file) | I | Billing VKNR present and 5 digits |
| 202 | Existence check | Kassendatei (insurance fund file) | I | Health insurance number (IK) present and 9 digits |
| 212 | allowed content | not equal to 74799 | F | Cost carrier with VKNR 74799 must not be transmitted in billing to the KVen |
| 221 | Existence check | Check whether the transmitted value is contained in the master file for Hybrid-DRGs (SDHDRG). | W | |
| 223 | Existence check | OPS master file (OPS-Stammdatei) | F | OPS code (content FK 5035) in element ../opscode_liste/opscode/@V |
| 304 | Context | Date <= machine date | F | Avoidance of erroneous entries |
| 307 | Context | If FK 4109 and FK 3119 are present, FK 3006 must be present. | W | Explanation on page 162 |
| 308 | Context | Field content of FK 3006 >= 5.2.0 | W | |
| 314 | Context | Date of birth (FK 3103) <= Surgery date (FK 5034) | W | Avoidance of erroneous entries |
| 321 | Context | If FK 4110 is present, then: Surgery date (FK 5034) <= Insurance coverage end (FK 4110) | W | Avoidance of erroneous entries |
| 322 | Context | If FK 4133 is present, then: Surgery date (FK 5034) >= Insurance coverage start (FK 4133) | W | Avoidance of erroneous entries |
| 364 | Context | If field 4125 is present, then the date of field 5034 (surgery date) must lie within the time period defined by field 4125 (validity period from ... to ...). | W | Avoidance of erroneous entries |
| 365 | Context | If field 4125 is present, then the date of field 5028 (service start date) must lie within the time period defined by field 4125 (validity period from ... to ...). | W | Avoidance of erroneous entries |
| 366 | Context | If field 4125 is present, then the date of field 5029 (service end date) must lie within the time period defined by field 4125 (validity period from ... to ...). | W | Avoidance of erroneous entries |
| 390 | Context | If the insured person's age <= 1 year (FK 5028 (service start date) - FK 3103 (date of birth)), then field 3111 (admission weight) must be present. | W | |
| 493 | Context | If for the ICD code (FK 6009/6011) in SDICD the elements "untere_altersgrenze" and/or "obere_altersgrenze" exist, then the age calculated from date of birth FK 3103 must be above the "untere_altersgrenze" and below the "obere_altersgrenze". The content of element "altersbezug_fehlerart" is "m". *) Maximum age is checked at service start date (5028) and minimum age at service end date (5029). | W | SDICD |
| 494 | Context | If for the ICD code (FK 6009/6011) in SDICD the element "krankheit_in_mitteleuropa_sehr_selten" with content V="j" exists, then warning "Please check coding: Diagnoses of this code are very rare in Central Europe." | W | SDICD |
| 498 | Context | If for a diagnosis (FK 6009/6011) in SDICD the element "schlusselnummer_mit_inhalt_belegt" with content "n" exists, it must not be transmitted | F | SDICD |
| 499 | Context | The content of FK 6009/6011 must be present as element "icd_code" and with child element "abrechenbar" with content V="j" in SDICD. | F | SDICD |
| 528 | allowed content | 1, 2, 3, 4, 5, 6 | F | |
| 534 | allowed content | 00, 04, 06, 07, 08, 09 | F | |
| 536 | allowed content | 00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58 | F | |
| 537 | allowed content | not equal to T555558879 | F | |
| 538 | allowed content | M, W, X, D | F | |
| ~~539~~ | ~~allowed content~~ | ~~00, 04, 06, 07, 09~~ | ~~F~~ | (deprecated/strikethrough in source) |
| 623 | allowed content | hdrg0, hdrg9, hdrg1 | F | |
| 706 | Context | If the value of FK 5028 < "20260101", then the allowed value range of FK 5041 equals Regel 110 (R, L, B). If the value of FK 5028 >= "20260101", then the allowed value range of FK 5041 equals Regel 178 (R, L). | F | For treatment cases up to and including 31.12.2025 the OPS laterality value range can be L, R and B. For treatment cases from 01.01.2026 the OPS laterality value range can be L and R. |
| 735 | Context | If for a diagnosis (FK 6009/6011) the "notationskennzeichen" (SDICD) with content "*" or "!" exists (= secondary code), at least one ICD code FK 6009/6011 without "notationskennzeichen" (SDICD) or, if present, with content "+" (= primary code) must be present. | F | SDICD |
| 734 | Context | If the cost carrier belongs to KT-Gruppe 75 (element /kostentraegergruppe (kts)), then the content of field 4124 must match the format "TTMMJJannnnn". | W | Plausibility check of person identifier for federal Bundeswehr SKT |
| 737 | Context | If for an ICD code (field content FK 6009 or 6011) in SDICD the element "geschlechtsbezug" exists and the content of element "geschlechtsbezug_fehlerart" = "k", then the gender in FK 3110 (if 3110 is not X, D) must match the specification under element "geschlechtsbezug" (SDICD). | W | If the patient gender does not match the specification in element "geschlechtsbezug", the PVS should alert the user. (cf. KBV_ITA_VGEX_Anforderungskatalog_ICD-10, P10-470). SDICD |
| 764 | Context | The (substitute) value "888888800" is obsolete and inadmissible as field content of 4242 and 5099. | F | |
| 775 | Context | If FK 4109 and FK 3006 are present, then field 4133 must be present. | F | |
| 776 | Context | If FK 4109 is present and the content of positions 3-5 of field 4104 < 800, then field 3119 must be present. If FK 4109 is present and the content of positions 3-5 of field 4104 >= 800, then either field 3105 or field 3119 must be present. | F | |
| 778 | Context | If field content of FK 4131 = "07" or "08", then field content of FK 4106 must be "01" or "09". | F | |
| 779 | Context | If field content of FK 4131 = "06", then field content of FK 4106 must be "02" or "09". | F | |
| 780 | Context | If field content of FK 4131 = "04", then field content of FK 4106 must be "00" or "09". | F | |
| 784 | Context | If FK 4109 and FK 3006 are present, then field 3114 and/or field 3124 must be present. | F | |
| 790 | Context | If FK 4109 is present and FK 3006 is not present, then the content of positions 3-5 of FK 4104 must be >= 800. | F | KVK since 01.01.2015 only allowed for "originaren" SKT |
| 818 | Context | If field content of FK 4131 = "09", then field content of FK 4106 should be "00" or "09". | W | |
| 824 | Context | If the content of field 8000 = hdrg0, then the content of field 9212 must match the current version specification. | W | |
| 827 | Context | If field 4109 is present and field 4131 = 00, then field content of 4106 must be 00 or 09. | W | |
| 876 | Context | If FK 3010 is present, then FK 4109 must also be present. | W | |
| 895 | Context | If FK 4112 is present, then FK 4109 and FK 3010 and FK 3006 must not be present. | W | |
| 896 | Context | If FK 5030 is present, it must not be filled with a value > 0. | W | If ventilation is required, the service is grouped as DRG and not as Hybrid-DRG. |
| 898 | Context | If FK 4109 is present, then format rule 021 applies to the content of field 3103. If FK 4109 is not present, then format rule 023 applies to the content of field 3103. | see Regel 021, 023 | |
| 999* | special notes | Read by KV, can appear in any record type multiple times | | For Praxiscomp. For return transmission |
