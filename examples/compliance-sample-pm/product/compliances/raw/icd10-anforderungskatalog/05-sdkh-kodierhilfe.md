# Chapter 5: Kodierhilfe (SDKH)

> Quelle: KBV_ITA_VGEX_Anforderungskatalog_ICD-10, Version 3.10, 15. August 2025
> Abschnitt: 5 Kodierhilfe-Stammdatei

## Overview

Die Kodierhilfe-Stammdatei (SDKH) unterstuetzt den Anwender bei der Diagnosenverschluesselung durch Suchfunktionen, Kodierhinweise und Verweise auf verwandte ICD-Kodes. Sie ergaenzt die SDICD um praxisnahe Suchalgorithmen und kontextbezogene Informationen.

## 5.1 Grundlegende Anforderungen

### O11-10 — Einsatz der SDKH

| Feld | Wert |
|---|---|
| ID | O11-10 |
| Typ | O ADT/BDT |
| Kurzbeschreibung | Der Einsatz der Kodierhilfe-Stammdatei (SDKH) ist optional. Wenn das PVS die SDKH einsetzt, gelten die folgenden Anforderungen KP11-20 bis KP11-140. |

### KP11-20 — Gueltigkeit der SDKH

| Feld | Wert |
|---|---|
| ID | KP11-20 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Wenn die SDKH eingesetzt wird, muss das PVS die Gueltigkeitszeitraeume beachten und die jeweils aktuelle Version verwenden. |

### KP11-30 — Unveraenderbarkeit der SDKH

| Feld | Wert |
|---|---|
| ID | KP11-30 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Die Inhalte der SDKH duerfen nicht veraendert werden. Herstellereigene Erweiterungen muessen getrennt von den Originaldaten gefuehrt werden. |

## 5.2 Recherche und Suche

### O11-40 — Patientenunabhaengige Recherche

| Feld | Wert |
|---|---|
| ID | O11-40 |
| Typ | O ADT/BDT |
| Kurzbeschreibung | Optional kann das PVS eine patientenunabhaengige Recherche in der SDKH anbieten (Nachschlagewerk ohne Bezug zu einem konkreten Patienten). |

### KP11-41 — Patientenbezogene Recherche

| Feld | Wert |
|---|---|
| ID | KP11-41 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Wenn die SDKH eingesetzt wird, muss eine patientenbezogene Recherche moeglich sein (Suche im Kontext eines Behandlungsfalls mit Uebernahme in die Dokumentation). |

### KP11-50 — Suchverfahren

| Feld | Wert |
|---|---|
| ID | KP11-50 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Die SDKH-Suche muss mindestens Freitextsuche und ICD-Kode-Suche unterstuetzen. Die Suche soll in Diagnosebezeichnungen, Synonymen und Schlagwoertern der SDKH erfolgen. |

### KP11-60 — Anzeige Suchergebnis

| Feld | Wert |
|---|---|
| ID | KP11-60 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Suchergebnisse muessen den ICD-Kode, den Klartext und ggf. vorhandene Kodierhinweise anzeigen. Die Ergebnisliste muss navigierbar sein. |

## 5.3 Kodierhinweise und Verweise

### KP11-90 — Kodierhinweise anzeigen

| Feld | Wert |
|---|---|
| ID | KP11-90 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Zu einem ICD-Kode vorhandene Kodierhinweise (aus SDKH) muessen dem Anwender angezeigt werden koennen. Kodierhinweise enthalten praxisrelevante Informationen zur korrekten Verschluesselung. |

### KP11-110 — Verweis auf anderen ICD-Kode

| Feld | Wert |
|---|---|
| ID | KP11-110 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Wenn die SDKH Verweise auf alternative oder ergaenzende ICD-Kodes enthaelt, muessen diese dem Anwender angezeigt und navigierbar sein (z.B. "Siehe auch...", Kreuz-Stern-Paare). |

### KP11-140 — Uebernahme in die Abrechnung

| Feld | Wert |
|---|---|
| ID | KP11-140 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Ein ueber die SDKH gefundener ICD-Kode muss direkt als Behandlungsdiagnose in den aktuellen Behandlungsfall uebernommen werden koennen. Bei der Uebernahme gelten die gleichen Validierungsregeln wie bei manueller Eingabe. |

---

## Summary

| ID | Type | Short Title |
|---|---|---|
| O11-10 | O | Einsatz SDKH (optional) |
| KP11-20 | KP | Gueltigkeit SDKH |
| KP11-30 | KP | Unveraenderbarkeit SDKH |
| O11-40 | O | Patientenunabhaengige Recherche |
| KP11-41 | KP | Patientenbezogene Recherche |
| KP11-50 | KP | Suchverfahren |
| KP11-60 | KP | Anzeige Suchergebnis |
| KP11-90 | KP | Kodierhinweise anzeigen |
| KP11-110 | KP | Verweis auf anderen ICD-Kode |
| KP11-140 | KP | Uebernahme in Abrechnung |
