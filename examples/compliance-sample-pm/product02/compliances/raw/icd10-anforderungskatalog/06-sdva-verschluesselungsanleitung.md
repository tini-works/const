# Chapter 6: Verschluesselungsanleitung (SDVA)

> Quelle: KBV_ITA_VGEX_Anforderungskatalog_ICD-10, Version 3.10, 15. August 2025
> Abschnitt: 6 Verschluesselungsanleitung-Stammdatei

## Overview

Die Verschluesselungsanleitung-Stammdatei (SDVA) enthaelt die offiziellen Kodierrichtlinien fuer die Anwendung der ICD-10-GM. Sie wird jaehrlich aktualisiert und stellt sicher, dass Aerzte Zugang zu den aktuellen Verschluesselungsregeln haben.

## 6.1 Anforderungen

### P11-700 — Einsatzpflicht SDVA

| Feld | Wert |
|---|---|
| ID | P11-700 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | Das PVS muss die von der KBV bereitgestellte Verschluesselungsanleitung-Stammdatei (SDVA) einsetzen und dem Anwender zugaenglich machen. |

### P11-710 — Gueltigkeit der SDVA

| Feld | Wert |
|---|---|
| ID | P11-710 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | Das PVS muss die Gueltigkeitszeitraeume der SDVA beachten. Zum Jahresbeginn muss die jeweils aktuelle Version bereitgestellt werden. |

### P11-720 — Unveraenderbarkeit der SDVA

| Feld | Wert |
|---|---|
| ID | P11-720 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | Die Inhalte der SDVA duerfen nicht veraendert werden. Die Darstellung im PVS muss den Originalinhalten entsprechen. |

### P11-740 — Anzeige VA zu einem ICD-Kode

| Feld | Wert |
|---|---|
| ID | P11-740 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | Das PVS muss zu einem konkreten ICD-10-GM-Kode die zugehoerige Verschluesselungsanleitung anzeigen koennen (kontextbezogener Aufruf aus der Diagnosenerfassung). |

### P11-750 — Gesamthafte Anzeige VA

| Feld | Wert |
|---|---|
| ID | P11-750 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | Das PVS muss die Verschluesselungsanleitung auch als Gesamtdokument anzeigen koennen (Browse-/Nachschlage-Modus ohne Bezug zu einem konkreten Kode). |

### P11-760 — Jaehrliche Aenderungen

| Feld | Wert |
|---|---|
| ID | P11-760 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | Das PVS muss die jaehrlichen Aenderungen der Verschluesselungsanleitung sichtbar machen koennen (Aenderungsmarkierungen oder separater Aenderungsnachweis). |

---

## Summary

| ID | Type | Short Title |
|---|---|---|
| P11-700 | P | Einsatzpflicht SDVA |
| P11-710 | P | Gueltigkeit SDVA |
| P11-720 | P | Unveraenderbarkeit SDVA |
| P11-740 | P | Anzeige VA zu ICD-Kode |
| P11-750 | P | Gesamthafte Anzeige VA |
| P11-760 | P | Jaehrliche Aenderungen |
