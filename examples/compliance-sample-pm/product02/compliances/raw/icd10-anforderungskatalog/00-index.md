# KBV Anforderungskatalog ICD-10-GM - Index

> Quelle: KBV_ITA_VGEX_Anforderungskatalog_ICD-10, Version 3.10, 15. August 2025
> Gueltigkeitsdatum: ab 01.10.2025
> Dokumentenstatus: In Kraft

## Document Overview

This catalog defines the requirements for PVS (Praxisverwaltungssysteme) regarding ICD-10-GM diagnosis coding per § 295 SGB V for ambulatory billing in Germany. It covers:

- General rules for diagnosis entry and categorization
- ICD-10-GM master data file (SDICD) requirements
- Coding rule engine (SDKRW - Kodierregelwerk) requirements
- Coding assistance (SDKH - Kodierhilfe) requirements
- Coding instructions (SDVA - Verschluesselungsanleitung) requirements

## Table of Contents

| File | Chapter | Title | Compliance IDs |
|---|---|---|---|
| [01-einleitung.md](01-einleitung.md) | 1 | Einleitung | - |
| [02-allgemeine-regelungen.md](02-allgemeine-regelungen.md) | 2 | Allgemeine Regelungen | 20 |
| [03-sdicd-stammdatei.md](03-sdicd-stammdatei.md) | 3 | ICD-10-GM-Stammdatei (SDICD) | 15 |
| [04-sdkrw-kodierregelwerk.md](04-sdkrw-kodierregelwerk.md) | 4 | Kodierregelwerk (SDKRW) | 16 |
| [05-sdkh-kodierhilfe.md](05-sdkh-kodierhilfe.md) | 5 | Kodierhilfe (SDKH) | 10 |
| [06-sdva-verschluesselungsanleitung.md](06-sdva-verschluesselungsanleitung.md) | 6 | Verschluesselungsanleitung (SDVA) | 6 |
| [07-ablaufdiagramme.md](07-ablaufdiagramme.md) | 7 | Ablaufdiagramme | - |
| [08-diagnosekategorien.md](08-diagnosekategorien.md) | 8 | Diagnosekategorien | - |
| [09-referenzen.md](09-referenzen.md) | 9 | Referenzierte Dokumente | - |
| [compliance-id-grouping.md](compliance-id-grouping.md) | - | Compliance ID Grouping Analysis | 67 total |

## Compliance ID Summary

| Prefix | Type | Count |
|---|---|---|
| P10-xxx | Pflichtfunktion (ADT/BDT) | 11 |
| KP10-xxx | Konditionale Pflichtfunktion (ADT/BDT) | 20 |
| O10-xxx | Optionale Funktion (ADT/BDT) | 5 |
| P11-xxx | Pflichtfunktion (ADT/BDT) | 4 |
| KP11-xxx | Konditionale Pflichtfunktion (ADT/BDT) | 6 |
| O11-xxx | Optionale Funktion (ADT/BDT) | 2 |
| **Total** | | **67** |

## Requirement Types

- **P** (Pflichtfunktion): Mandatory function — must be implemented
- **KP** (Konditionale Pflichtfunktion): Conditionally mandatory — must be implemented if the PVS supports the related feature
- **O** (Optionale Funktion): Optional — may be implemented
- **K** (Kann-Funktion): May-function (informational)

## Key Abbreviations

| Abbr | Full |
|---|---|
| SDICD | ICD-10-GM-Stammdatei |
| SDKRW | Kodierregelwerk-Stammdatei |
| SDKH | Kodierhilfe-Stammdatei |
| SDVA | Verschluesselungsanleitung-Stammdatei |
| DS | Diagnosensicherheit (V/G/A/Z) |
| SL | Seitenlokalisation (R/L/B) |
| FK | Feldkennung |
| ADT | Abrechnungsdatentraeger |
| BDT | Behandlungsdatentraeger |
| eGK | elektronische Gesundheitskarte |
