# ICD-10-GM Anforderungskatalog - Compliance ID Grouping

> Quelle: KBV_ITA_VGEX_Anforderungskatalog_ICD-10, Version 3.10, 15. August 2025

## Group 1: Diagnosis Entry & Coding (Akutdiagnosen)

Core requirements for entering and coding acute diagnoses with ICD-10-GM.

| Compliance ID | Type | Description |
|---|---|---|
| P10-80 | P ADT/BDT | Begriffe Akut-/Dauer-/Anamnestische Diagnosen verwenden |
| P10-90 | P ADT/BDT | Uebertragung Behandlungsdiagnosen in FK 6001 |
| P10-100 | P ADT/BDT | Akutdiagnosen muessen mit ICD-10-GM kodiert werden |
| P10-110 | P ADT/BDT | Diagnosensicherheit (V/G/A/Z) erzwingen, kein Default |
| P10-111 | P ADT/BDT | Weitere Informationen: SL, Erlaeuterungstext, Ausnahmetatbestand |
| P10-320 | P ADT/BDT | Kein automatisches Hinzufuegen von Diagnosen |
| P10-375 | P ADT/BDT | Diagnoseklartext aus SDICD anzeigen |
| O10-300 | O ADT/BDT | Anwenderdefinierte Kuerzel (Synonyme/Mappings) |
| O10-360 | O ADT/BDT | Uebernahme ICD-Kodes von externen Systemen |

## Group 2: Dauerdiagnosen & Anamnestische Diagnosen

Requirements for managing chronic and historical diagnoses across quarters.

| Compliance ID | Type | Description |
|---|---|---|
| KP10-200 | KP ADT/BDT | Kategorisierung Dauer-/Anamnestische als separate Kategorie |
| KP10-201 | KP ADT/BDT | Kennzeichnung in der Patientendokumentation |
| KP10-230 | KP ADT/BDT | Uebertragung als Behandlungsdiagnose in FK 6001 |
| KP10-231 | KP ADT/BDT | Diagnosensicherheit pruefen/aktualisieren bei Uebernahme |
| KP10-232 | KP ADT/BDT | Weitere Informationen (SL/Erlaeuterung) bei Uebernahme |
| KP10-240 | KP ADT/BDT | Uebernahme Dauerdiagnosen — explizite Bestaetigung, nicht automatisch |
| KP10-250 | KP ADT/BDT | Uebernahme Anamnestische — explizite Bestaetigung, nicht automatisch |
| O10-270 | O ADT/BDT | Vorauswahl Dauerdiagnosen begrenzen |
| O10-260 | O ADT/BDT | Pool Anamnestische Diagnosen begrenzen |
| KP10-330 | KP ADT/BDT | Strichergaenzung (4./5. Stelle) Hinweis |
| KP10-350 | KP ADT/BDT | Z01.7 Befreiungsregelung |

## Group 3: SDICD Validation (ICD-10-GM-Stammdatei)

Requirements for validating ICD codes against the master data file.

| Compliance ID | Type | Description |
|---|---|---|
| P10-400 | P ADT/BDT | Einsatzpflicht SDICD |
| P10-410 | P ADT/BDT | Gueltigkeit — aktuelle Version zum Quartalsbeginn |
| P10-420 | P ADT/BDT | Inhaltliche Unveraenderbarkeit |
| P10-430 | P ADT/BDT | Existenzpruefung ICD-Kode |
| P10-440 | P ADT/BDT | Nicht abrechenbare Kodes ablehnen |
| P10-450 | P ADT/BDT | Kode ohne Inhalt ablehnen |
| P10-460 | P ADT/BDT | Sekundaerkodes (Kreuz-Stern) pruefen |
| P10-470 | P ADT/BDT | Geschlechtsbezug pruefen |
| P10-480 | P ADT/BDT | Altersgruppenbezug pruefen |
| P10-490 | P ADT/BDT | Seltene Diagnosen Mitteleuropa — Hinweis |
| P10-500 | P ADT/BDT | IfSG-Meldepflicht — Hinweis |
| O10-510 | O ADT/BDT | IfSG-Abrechnungsbesonderheit |
| KP10-540 | KP ADT/BDT | Freitext-Suche in SDICD |
| O10-541 | O ADT/BDT | ICD-Favoritenlisten |
| KP10-542 | KP ADT/BDT | Ungeeignet als Dauerdiagnose — Hinweis |

## Group 4: Kodierregelwerk (SDKRW) — Rule Engine

Requirements for the automated coding rule engine.

| Compliance ID | Type | Description |
|---|---|---|
| KP10-610 | KP ADT/BDT | Einsatzpflicht SDKRW |
| KP10-620 | KP ADT/BDT | Gueltigkeit SDKRW |
| KP10-630 | KP ADT/BDT | Unveraenderbarkeit SDKRW |
| KP10-640 | KP ADT/BDT | Aenderungshinweise bei Update |
| KP10-650 | KP ADT/BDT | Konfiguration behandlungsfallbezogen |
| KP10-660 | KP ADT/BDT | Konfiguration quartalsuebergreifend |
| KP10-700 | KP ADT/BDT | Ausfuehrung behandlungsfallbezogen |
| KP10-710 | KP ADT/BDT | Validierung — Bedingung/Pruefung/Fehlerbehandlung |
| KP10-720 | KP ADT/BDT | Ausfuehrung quartalsuebergreifend |
| KP10-730 | KP ADT/BDT | Validierung quartalsuebergreifend |
| KP10-740 | KP ADT/BDT | Uebersichtsanzeige Regelverletzungen |
| KP10-750 | KP ADT/BDT | Hinweis und Korrekturvorschlag |
| KP10-760 | KP ADT/BDT | DELETE-Korrektur |
| KP10-770 | KP ADT/BDT | REPLACE-Korrektur |
| KP10-780 | KP ADT/BDT | ADD-Korrektur |
| KP10-790 | KP ADT/BDT | Abbruch der Regelausfuehrung |

## Group 5: Kodierhilfe (SDKH) — Search & Assistance

Requirements for the coding assistance and search functionality.

| Compliance ID | Type | Description |
|---|---|---|
| O11-10 | O ADT/BDT | Einsatz SDKH (optional, aktiviert KP11-xx) |
| KP11-20 | KP ADT/BDT | Gueltigkeit SDKH |
| KP11-30 | KP ADT/BDT | Unveraenderbarkeit SDKH |
| O11-40 | O ADT/BDT | Patientenunabhaengige Recherche |
| KP11-41 | KP ADT/BDT | Patientenbezogene Recherche |
| KP11-50 | KP ADT/BDT | Suchverfahren (Freitext + Kode) |
| KP11-60 | KP ADT/BDT | Anzeige Suchergebnis |
| KP11-90 | KP ADT/BDT | Kodierhinweise anzeigen |
| KP11-110 | KP ADT/BDT | Verweis auf anderen ICD-Kode |
| KP11-140 | KP ADT/BDT | Uebernahme in Abrechnung |

## Group 6: Verschluesselungsanleitung (SDVA)

Requirements for displaying official coding instructions.

| Compliance ID | Type | Description |
|---|---|---|
| P11-700 | P ADT/BDT | Einsatzpflicht SDVA |
| P11-710 | P ADT/BDT | Gueltigkeit SDVA |
| P11-720 | P ADT/BDT | Unveraenderbarkeit SDVA |
| P11-740 | P ADT/BDT | Anzeige VA zu ICD-Kode (kontextbezogen) |
| P11-750 | P ADT/BDT | Gesamthafte Anzeige VA (Browse-Modus) |
| P11-760 | P ADT/BDT | Jaehrliche Aenderungen sichtbar machen |

---

## Summary

| Group | Count | ID Range |
|---|---|---|
| Diagnosis Entry & Coding | 9 | P10-80 ... O10-360 |
| Dauerdiagnosen & Anamnestische | 11 | KP10-200 ... KP10-350 |
| SDICD Validation | 15 | P10-400 ... KP10-542 |
| Kodierregelwerk (SDKRW) | 16 | KP10-610 ... KP10-790 |
| Kodierhilfe (SDKH) | 10 | O11-10 ... KP11-140 |
| Verschluesselungsanleitung (SDVA) | 6 | P11-700 ... P11-760 |
| **Total** | **67** | |

## Cross-Group Dependencies

```
Group 1 (Diagnosis Entry)
  ├── depends on → Group 3 (SDICD Validation) for code validation
  ├── triggers → Group 4 (SDKRW) for rule-based validation
  └── uses → Group 5 (SDKH) for search/assistance

Group 2 (Dauerdiagnosen)
  ├── feeds into → Group 1 (via KP10-230 Uebernahme)
  └── depends on → Group 3 (SDICD) for KP10-542 suitability check

Group 4 (SDKRW)
  └── produces corrections → DELETE/REPLACE/ADD back to Group 1

Group 5 (SDKH)
  └── produces codes → KP11-140 Uebernahme back to Group 1

Group 6 (SDVA)
  └── informational → supports all groups via coding guidelines
```

> **Note:** Groups 3-6 represent the four KBV master data files (SDICD, SDKRW, SDKH, SDVA).
> Group 3 (SDICD) is mandatory. Group 4 (SDKRW) and Group 5 (SDKH) are conditionally mandatory.
> Group 6 (SDVA) is mandatory. All master data files share the pattern: Einsatzpflicht → Gueltigkeit → Unveraenderbarkeit.
