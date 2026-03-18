# Chapter 4: Kodierregelwerk (SDKRW)

> Quelle: KBV_ITA_VGEX_Anforderungskatalog_ICD-10, Version 3.10, 15. August 2025
> Abschnitt: 4 Kodierregelwerk-Stammdatei

## Overview

Das Kodierregelwerk (SDKRW) definiert automatisierte Plausibilitaetspruefungen fuer ICD-10-GM-Kodierungen. Jede Kodierregel besteht aus drei Bloecken:

1. **Bedingungsblock**: Definiert, wann die Regel greift (ICD-Kode, Diagnosensicherheit, Kontext)
2. **Pruefungsblock**: Definiert die durchzufuehrende Pruefung
3. **Fehlerbehandlungsblock**: Definiert die Reaktion (Hinweis, Korrekturvorschlag mit DELETE/REPLACE/ADD)

## 4.1 Grundlegende Anforderungen

### KP10-610 — Einsatzpflicht SDKRW

| Feld | Wert |
|---|---|
| ID | KP10-610 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Wenn das PVS Diagnosenvalidierung unterstuetzt, muss die von der KBV bereitgestellte Kodierregelwerk-Stammdatei (SDKRW) eingesetzt werden. |

### KP10-620 — Gueltigkeit der SDKRW

| Feld | Wert |
|---|---|
| ID | KP10-620 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Das PVS muss die Gueltigkeitszeitraeume der SDKRW beachten. Zum Quartalsbeginn muss die jeweils gueltige Version eingesetzt werden. |

### KP10-630 — Unveraenderbarkeit der SDKRW

| Feld | Wert |
|---|---|
| ID | KP10-630 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Die Inhalte der SDKRW duerfen nicht veraendert werden. Herstellereigene Erweiterungen muessen getrennt gefuehrt werden. |

### KP10-640 — Aenderungshinweise

| Feld | Wert |
|---|---|
| ID | KP10-640 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Bei Aktualisierung der SDKRW muss das PVS den Anwender ueber Aenderungen informieren koennen (z.B. neue/geaenderte/entfallene Regeln). |

## 4.2 Konfiguration

### KP10-650 — Konfiguration behandlungsfallbezogen

| Feld | Wert |
|---|---|
| ID | KP10-650 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Der Anwender muss die behandlungsfallbezogene Ausfuehrung des Kodierregelwerks konfigurieren koennen (z.B. ein-/ausschalten, Zeitpunkt der Pruefung). |

### KP10-660 — Konfiguration quartalsuebergreifend

| Feld | Wert |
|---|---|
| ID | KP10-660 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Der Anwender muss die quartalsuebergreifende Ausfuehrung des Kodierregelwerks konfigurieren koennen (Pruefung ueber alle Faelle eines Quartals). |

## 4.3 Ausfuehrung und Validierung

### KP10-700 — Ausfuehrung behandlungsfallbezogen

| Feld | Wert |
|---|---|
| ID | KP10-700 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Das PVS muss die Kodierregeln behandlungsfallbezogen ausfuehren koennen. Pruefung aller Diagnosen eines Behandlungsfalls gegen die SDKRW. |

### KP10-710 — Validierung gegen Kodierregeln

| Feld | Wert |
|---|---|
| ID | KP10-710 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Bei der Ausfuehrung muessen die Kodierregeln vollstaendig abgearbeitet werden. Der Bedingungsblock wird gegen die vorliegenden Diagnosen geprueft, der Pruefungsblock ausgefuehrt, und bei Regelverstoss der Fehlerbehandlungsblock aktiviert. |

### KP10-720 — Ausfuehrung quartalsuebergreifend

| Feld | Wert |
|---|---|
| ID | KP10-720 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Das PVS muss die Kodierregeln quartalsuebergreifend ausfuehren koennen (Pruefung aller Diagnosen eines Patienten im Quartal). |

### KP10-730 — Validierung quartalsuebergreifend

| Feld | Wert |
|---|---|
| ID | KP10-730 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Die quartalsuebergreifende Validierung muss alle Behandlungsfaelle eines Patienten im Quartal beruecksichtigen und die gleiche Regellogik wie KP10-710 anwenden. |

## 4.4 Ergebnisdarstellung und Korrekturen

### KP10-740 — Uebersichtsanzeige

| Feld | Wert |
|---|---|
| ID | KP10-740 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Das PVS muss eine Uebersicht aller Regelverletzungen anzeigen koennen (Liste der betroffenen Diagnosen mit Regeltext und Korrekturvorschlag). |

### KP10-750 — Hinweis und Korrekturvorschlag

| Feld | Wert |
|---|---|
| ID | KP10-750 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Bei einer Regelverletzung muss das PVS den Hinweistext der Regel anzeigen und den Korrekturvorschlag prasentieren. Der Anwender entscheidet ueber Annahme oder Ablehnung. |

### KP10-760 — DELETE-Korrektur

| Feld | Wert |
|---|---|
| ID | KP10-760 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Bei Korrekturtyp DELETE muss das PVS die betroffene Diagnose loeschen koennen (nach Bestaetigung durch den Anwender). |

### KP10-770 — REPLACE-Korrektur

| Feld | Wert |
|---|---|
| ID | KP10-770 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Bei Korrekturtyp REPLACE muss das PVS die betroffene Diagnose durch den vorgeschlagenen Kode ersetzen koennen (nach Bestaetigung durch den Anwender). |

### KP10-780 — ADD-Korrektur

| Feld | Wert |
|---|---|
| ID | KP10-780 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Bei Korrekturtyp ADD muss das PVS eine zusaetzliche Diagnose hinzufuegen koennen (nach Bestaetigung durch den Anwender). Typisch fuer Kreuz-Stern-Ergaenzungen. |

### KP10-790 — Abbruch

| Feld | Wert |
|---|---|
| ID | KP10-790 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Der Anwender muss die Ausfuehrung des Kodierregelwerks jederzeit abbrechen koennen, ohne dass bereits angenommene Korrekturen rueckgaengig gemacht werden. |

---

## Summary

| ID | Type | Short Title |
|---|---|---|
| KP10-610 | KP | Einsatzpflicht SDKRW |
| KP10-620 | KP | Gueltigkeit SDKRW |
| KP10-630 | KP | Unveraenderbarkeit SDKRW |
| KP10-640 | KP | Aenderungshinweise |
| KP10-650 | KP | Konfiguration behandlungsfallbezogen |
| KP10-660 | KP | Konfiguration quartalsuebergreifend |
| KP10-700 | KP | Ausfuehrung behandlungsfallbezogen |
| KP10-710 | KP | Validierung gegen Kodierregeln |
| KP10-720 | KP | Ausfuehrung quartalsuebergreifend |
| KP10-730 | KP | Validierung quartalsuebergreifend |
| KP10-740 | KP | Uebersichtsanzeige |
| KP10-750 | KP | Hinweis und Korrekturvorschlag |
| KP10-760 | KP | DELETE-Korrektur |
| KP10-770 | KP | REPLACE-Korrektur |
| KP10-780 | KP | ADD-Korrektur |
| KP10-790 | KP | Abbruch |
