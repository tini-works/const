# Chapter 9: Referenzierte Dokumente

> Quelle: KBV_ITA_VGEX_Anforderungskatalog_ICD-10, Version 3.10, 15. August 2025
> Abschnitt: 9 Referenzierte Dokumente

## Normative Referenzen

| Dokument | Beschreibung |
|---|---|
| ICD-10-GM | Internationale statistische Klassifikation der Krankheiten und verwandter Gesundheitsprobleme, German Modification — herausgegeben vom BfArM |
| SGB V § 295 | Abrechnung aerztlicher Leistungen — Pflicht zur Diagnosenverschluesselung |
| KBV_ITA_VGEX_Anforderungskatalog_KVDT | Anforderungskatalog zum KVDT — Abrechnungsdatentraeger |
| KBV_ITA_VGEX_Datensatzbeschreibung_KVDT | Datensatzbeschreibung des KVDT |
| KBV_ITA_VGEX_Datensatzbeschreibung_BDT | Datensatzbeschreibung des BDT |

## Stammdateien

| Stammdatei | Kennung | Beschreibung |
|---|---|---|
| ICD-10-GM-Stammdatei | SDICD | ICD-Kodes, Klartexte, Attribute (Geschlecht, Alter, Meldepflicht etc.) |
| Kodierregelwerk-Stammdatei | SDKRW | Automatisierte Kodierregeln mit Bedingung/Pruefung/Fehlerbehandlung |
| Kodierhilfe-Stammdatei | SDKH | Suchbegriffe, Synonyme, Kodierhinweise, Verweise |
| Verschluesselungsanleitung-Stammdatei | SDVA | Offizielle Kodierrichtlinien, jaehrlich aktualisiert |

## Feldkennungen (FK)

| FK | Beschreibung | Kontext |
|---|---|---|
| 6001 | Behandlungsdiagnose (ICD-10-GM-Kode) | Akutdiagnosen, uebernommene Dauer-/Anamnestische |
| 3673 | Dauerdiagnose / Anamnestische Diagnose | Quartalsuebergreifende Speicherung |
| 6003 | Diagnosensicherheit | V, G, A, Z |
| 6004 | Seitenlokalisation | R, L, B |
| 6006 | Erlaeuterungstext zur Diagnose | Freitext |
| 6008 | Ausnahmetatbestand | Abrechnungsausnahme |

## Verwandte Anforderungskataloge

| Katalog | Relevanz |
|---|---|
| Anforderungskatalog KVDT | Patientenstammdaten, Abrechnungssaetze, Feldkennungen |
| Anforderungskatalog EBM | Leistungsziffern und deren Bezug zu Diagnosenverschluesselung |
| Anforderungskatalog BDT | Behandlungsdatentraeger fuer Datenaustausch |
| Pruefpaket ICD-10-GM | Testszenarien fuer die Zertifizierung |
