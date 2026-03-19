## SADT Rule Table (Regeltabelle)

| Field | Value |
|-------|-------|
| **Source** | KVDT-DSB v6.02 |
| **Section** | 5.5.2 |
| **Scope** | Validation rules for SADT data package |

Rules marked with asterisk (*) are relevant only for the case preparation software of the Kassenarztlichen Vereinigungen, not for billing software. Rules marked with hash (#) have special validation behavior.

### Rules

| R-Nr | Category | Check | Status | Description |
|------|----------|-------|--------|-------------|
| 016 | Format | QJJJJ | F | Q = Quarter, JJJJ = Year |
| 017 | Format | nnmmm | F | nn = KV identifier, mmm = serial number. Value range nn: 01 = KV Schleswig-Holstein, 02 = KV Hamburg, 03 = KV Bremen, 06 = Aurich, 07 = Braunschweig, 08 = Gottingen, 09 = Hannover, 10 = Hildesheim, 11 = Luneburg, 12 = Oldenburg, 13 = Osnabruck, 14 = Stade, 15 = Verden, 16 = Wilhelmshaven, 17 = KV Niedersachsen, 18 = Dortmund, 19 = Munster, 20 = KV Westfalen-Lippe, 21 = Aachen, 24 = Dusseldorf, 25 = Duisburg, 27 = Koln, 28 = LinkerNiederrhein, 31 = Ruhr, 37 = Bergisch-Land, 38 = KV Nordrhein, 39 = Darmstadt, 40 = Frankfurt/Main, 41 = Giessen, 42 = Kassel, 43 = Limburg, 44 = Marburg, 45 = Wiesbaden, 46 = KV Hessen, 47 = Koblenz, 48 = Rheinhessen, 49 = Pfalz, 50 = Trier, 51 = KV Rheinland-Pfalz, 52 = KV Baden-Wurttemberg, 53 = Mannheim, 54 = Pforzheim, 55 = Karlsruhe, 56 = Baden-Baden, 57 = Freiburg, 58 = Konstanz, 59 = Offenburg, 60 = Freiburg, 61 = Stuttgart, 62 = Reutlingen, 63 = Munchen Stadt und Land, 64 = Oberbayern, 65 = Oberfranken, 66 = Mittelfranken, 67 = Unterfranken, 68 = Oberpfalz, 69 = Niederbayern, 70 = Schwaben, 71 = KV Bayerns, 72 = KV Berlin, 73 = KV Saarland, 74 = KBV, 78 = KV Mecklenburg-Vorpommern, 79 = Potsdam, 80 = Cottbus, 81 = Frankfurt/Oder, 83 = KV Brandenburg, 85 = Magdeburg, 86 = Halle, 87 = Dessau, 88 = KV Sachsen-Anhalt, 89 = Erfurt, 90 = Gera, 91 = Suhl, 93 = KV Thuringen, 94 = Chemnitz, 95 = Dresden, 96 = Leipzig, 98 = KV Sachsen, 99 = KBV-Pseudo-Nummer |
| 031 | Format | [a]aaaMMJJ.nn | F | [a]aaa = data package abbreviation, MM = Month, JJ = Year, nn = sub-version number |
| 048 | Format | ndddddddnnnnnnnnnnnna[a][a][a][a][a] | F | Allowed contents: Position 1 = 0, 1; Positions 2-7 = TTMMJJ; Positions 8-20 = numeric; Positions 21-27 = alphanumeric |
| 049 | Format | kknnnnnnmm | F | kk = allowed content per Regel 162, mm = [undefined] |
| 050 | Format | Nnnnnnmff | F | m = check digit, where "nnnnnn" must not equal "555555"; ff = allowed content per Anlage 35 of BAR key directory, tolerated substitute value for digits 8-9: 00. Procedure for determining the check digit see footnote 5. |
| 052 | Format | a/n[n][n]/JJMM/nn/aaa | F | a = [V, X, Y, Z], n = numeric, JJ = Year, MM = Month, aaa = alphanumeric |
| 162 | allowed content | 01-03, 06-21, 24, 25, 27, 28, 31, 37-73, 78-81, 83, 85-88, 93-96, 98, 99 | F | Allowed UKV/OKV identifiers in the practice establishment numbers + Knappschaft |
| 201 | Existence check | Kassendatei (insurance fund file) | I | Billing VKNR present and 5 digits |
| 202 | Existence check | Kassendatei (insurance fund file) | I | Health insurance number (IK) present and 9 digits |
| 203* | Existence check | GO-Stammdatei (fee schedule master file) | - | |
| 204# | Existence check | Anbieterstammdatei (provider master file) | W | Check number exists and valid |
| 212 | allowed content | not equal to 74799 | F | Cost carrier with VKNR 74799 must not be transmitted in billing to the KVen |
| 213# | Existence check | Anbieterstammdatei (provider master file) | F | Extended existence check: If check number not in provider master file, then: (1st month of validity (/JJMM/) + validity duration in months (/MM/) + 12 months) >= value in field "Abrechnungsquartal" (FK 9204) |
| 304 | Context | Date <= machine date | F | Avoidance of erroneous entries |
| 324 | Context | The content of field 5000 must lie within the time period defined by the quarter specification (4101) | F | |
| 523 | allowed content | sad0, sad9, sad1, sad2, sad3 | F | |
| 524 | allowed content | 18, 19, 20, 21, 24, 25, 27, 28, 31, 37 | F | Recipient of the billing: UKV identifier |
| 709 | Context | If the 1st position of FK 3005 = "0", then no billing via SADT is possible. | W | The certificate is then to be settled directly with the cost carrier. |
| 710 | Context | Content of FK 5012 <= 999999 | W | Check for realistic material costs |
| 732 | Context | The value in FK 5098 must match one of the values from FK 0201 (SA "besa"), provided no prior-quarter case exists (content of FK 4101 = FK 9204 (sad0)). | F | No check against Besa record for late billing cases. |
| 733 | Context | The value in FK 5099 must match one of the values from FK 0212 (SA "besa"), provided the value in FK 5099 is not "999999900" (content of FK 4101 = FK 9204 (sad0)). | F | No check against Besa record for late billing cases. |
| 762 | Context | The (substitute) value "888888800" is obsolete and inadmissible as field content of FK 0212, 4241, 4242, 5099. | F | |
| 815 | Context | If the content of field 8000 = sad0, then the content of field 9212 must match the current version specification. | W | |
| 999* | special notes | Read by KV, can appear in any record type multiple times | | For Praxiscomp. For return transmission |
