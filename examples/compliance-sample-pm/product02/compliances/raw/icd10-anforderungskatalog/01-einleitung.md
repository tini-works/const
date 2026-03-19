# Chapter 1: Einleitung

> Quelle: KBV_ITA_VGEX_Anforderungskatalog_ICD-10, Version 3.10, 15. August 2025

## 1.1 Hintergrund

Die ICD-10-GM (German Modification) ist das verbindliche Klassifikationssystem fuer die Verschluesselung von Diagnosen in der ambulanten und stationaeren Versorgung (§ 295 SGB V). Der Anforderungskatalog definiert die Anforderungen an Praxisverwaltungssysteme (PVS) bezueglich der Anwendung der ICD-10-GM.

## 1.2 Geltungsbereich

Der Katalog richtet sich an Hersteller von Praxisverwaltungssystemen (PVS), die im Rahmen der vertragsaerztlichen Versorgung eingesetzt werden. Er regelt:

- Die Erfassung und Verwaltung von Diagnosen
- Die Nutzung der ICD-10-GM-Stammdatei (SDICD)
- Die Anwendung des Kodierregelwerks (SDKRW)
- Die Bereitstellung der Kodierhilfe (SDKH)
- Die Darstellung der Verschluesselungsanleitung (SDVA)

## 1.3 Anforderungstypen

| Typ | Kennung | Beschreibung |
|---|---|---|
| Pflichtfunktion | P | Muss implementiert werden |
| Konditionale Pflichtfunktion | KP | Muss implementiert werden, wenn das PVS das zugehoerige Feature unterstuetzt |
| Optionale Funktion | O | Kann implementiert werden |
| Kann-Funktion | K | Informativ, keine Zertifizierungsrelevanz |

## 1.4 Diagnosekategorien

Drei Diagnosekategorien werden unterschieden:

1. **Akutdiagnosen** (FK 6001): Behandlungsdiagnosen des aktuellen Behandlungsfalls
2. **Dauerdiagnosen** (FK 3673): Chronische/langfristige Diagnosen, quartalsuebergreifend
3. **Anamnestische Diagnosen** (FK 3673): Fruehere relevante Diagnosen

## 1.5 Diagnosensicherheit

| Kuerzel | Bedeutung |
|---|---|
| V | Verdacht auf / Zustand nach |
| G | Gesicherte Diagnose |
| A | Ausgeschlossene Diagnose |
| Z | Symptomloser Zustand nach der betreffenden Diagnose |

## 1.6 Stammdateien

Vier Stammdateien werden von der KBV bereitgestellt und muessen vom PVS verwendet werden:

| Stammdatei | Beschreibung | Kapitel |
|---|---|---|
| SDICD | ICD-10-GM-Stammdatei — Kodevalidierung, Texte, Attribute | 3 |
| SDKRW | Kodierregelwerk — automatisierte Plausibilitaetspruefungen | 4 |
| SDKH | Kodierhilfe — Suche, Kodierhinweise, Verweise | 5 |
| SDVA | Verschluesselungsanleitung — Kodierrichtlinien, jaehrliche Aenderungen | 6 |

## 1.7 Dokumenthistorie

| Version | Datum | Aenderungen |
|---|---|---|
| 3.10 | 15.08.2025 | Aktuelle Version, gueltig ab 01.10.2025 |
