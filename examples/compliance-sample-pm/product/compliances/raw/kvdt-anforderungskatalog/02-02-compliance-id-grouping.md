# Section 2.2 Patientenstammdaten - Compliance ID Grouping

> Quelle: KBV_ITA_VGEX_Anforderungskatalog_KVDT, Version 6.06, 9. Maerz 2026
> Abschnitt: 2.2 Patientenstammdaten erfassen und verarbeiten

## Group 1: Patient Card Read-in (Versichertenkarte einlesen)

Requirements for reading patient data from eGK/KVK via card terminals.

| Compliance ID | Type | Description |
|---|---|---|
| KP2-100 | KP ADT | Einsatz zertifizierter Lesegeraete - terminal binding via RS232/LAN/USB |
| KP2-101 | KP ADT | KVK ab 01.01.2015 ungueltig - reject KVK for GKV (VKNR 3-5 < 800), allow for originaere SKT (>= 800) |
| KP2-102 | KP ADT | Abgelehnte KVK-Kartendaten in kopierbarer Form anzeigen (no auto-transfer to EV) |
| P2-105 | P ADT | Konvertierung KVK-Daten in eGK-/KVDT-konforme Strukturen (Mappingtabelle_KVK) |
| KP2-121 | KP ADT | BPol-Versicherte: nach eGK-Einlesen keine veralteten KVKs mehr zulassen |
| P2-120 | P ADT | "Amtliche" Felder - eingelesene Versichertendaten unveraendert speichern und uebertragen |
| P2-135 | P ADT | WOP-Kennzeichen von der Versichertenkarte uebernehmen (Transformationsvorschriften) |
| P2-136 | P ADT | Name des Kostentraegers von der Versichertenkarte (Prioritaet AbrechnenderKostentraeger) |
| P2-140 | P ADT | Einlesedatum erzeugen, anzeigen, speichern (FK 4109, amtlicher Charakter) |
| P2-150 | P ADT | Legitimation von Leistungen im laufenden Quartal mittels Einlesedatum |
| P2-166 | P ADT | Ueberpruefung der Leistungspflicht des Kostentraegers (Versicherungsschutz Beginn/Ende) |
| P2-170 | P ADT | Uebernahme der eingelesenen Daten in die Patientenstammdaten (inkl. Delta-Anzeige) |
| P2-180 | P ADT | Zulassungsnummer des mobilen Lesegeraetes uebertragen (FK 4108) |
| KP2-185 | KP ADT | Pruefungsnachweis nach VSDM-Aktualisierung uebertragen (EF.PN, FK 3010-3013) |
| KP2-190 | KP ADT | Zuzahlungsbefreiung nach Jahreswechsel loeschen |
| KP2-191 | KP ADT | Automatische Zuzahlungsbefreiung fuer Kinder/Jugendliche unter 18 |
| KP2-195 | KP ADT | Trennung Patientendaten ambulant/stationaer |
| KP2-300 | KP ADT | Abgleich Versichertendaten beim Einlesen (keine Duplikate, kein Ueberschreiben) |
| KP2-310 | KP ADT | Abgleich Versichertendaten nach Kassenwechsel (Warnhinweis, feldspezifische Anzeige) |

## Group 2: Patient Creation Manually / Ersatzverfahren (EV)

Requirements for manual entry of patient data (no card available).

| Compliance ID | Type | Description |
|---|---|---|
| P2-400 | P ADT | Ersatzverfahren anwenden - alle Erfassungsfelder gemaess Tabelle 5 bereitstellen, Mindestangaben sicherstellen |
| P2-401 | P ADT | Defaultwert Besondere Personengruppe "00" im EV |
| P2-402 | P ADT | Defaultwert DMP-Kennzeichen "00" im EV |
| P2-403 | P ADT | Naehere Informationen zur DMP-Kennzeichnung anzeigen |
| KP2-404 | KP ADT | Empfang einer elektronischen Ersatzbescheinigung (eEB) via KIM/FHIR |
| KP2-405 | KP ADT | Abrechnung mit eEB als Versicherungsnachweis (FK 4112 = 1) |
| P2-410 | P ADT | IK-basierte Identifizierung eines KT-Stammsatzes im EV/manueller Erfassung |
| P2-420 | P ADT | Programmierte Suchhilfen (Kassensuchname, Ortssuchname, VKNR) bei Nichtvorlage IK |
| P2-430 | P ADT | Geburtsdatum mit besonderem Wertebereich (JJJJMMTT, JJJJMM00, JJJJ0000, 00000000) |
| P2-440 | P ADT | Sonstige Kostentraeger im ADT - Zusatzangaben gemaess KV-Spezifika (kvx3) |
| P2-452 | P ADT | Sonstiger Kostentraeger "Bundeswehr" - Personenkennziffer, VKNR 79868/79869 |
| P2-460 | P ADT | PLZ-Existenzpruefung ueber PLZ-Stammdatei bei KTAB=00 im EV |
| P2-470 | P ADT | Geschlecht (FK 3110) - Transformationsvorschriften und manuelle Erfassung |
| K2-480 | K ADT | Fiktive Versicherte - Kennzeichnung und Unterbindung der Abrechnung |

## Group 3: Schein Management (Satzarten 010x)

Requirements for billing case assignment and Kostentraeger processing.

| Compliance ID | Type | Description |
|---|---|---|
| P2-320 | P ADT | KTAB (FK 4106) setzen in Abhaengigkeit von Besonderer Personengruppe (FK 4131) |
| P2-325 | P ADT | Hinweis bei Besonderer Personengruppe "09" (AsylbLG Par. 4/6) |
| KP2-500 | KP ADT | Angabe der Satzart 010x / Scheinuntergruppe beim erstmaligen Kontakt im Quartal |
| KP2-514 | KP ADT | Ambulante Behandlung (SA 0101, SUG 00) bei SKT-Versicherten ohne Karte - mehrfach anlegbar mit FK 4125 |

## Shared Infrastructure: KT-Stammdatei (Kostentraeger lookup)

These requirements define the Kostentraeger resolution logic used by **both** card read-in and manual/EV workflows.

| Compliance ID | Type | Description |
|---|---|---|
| P2-200 | P ADT | IK als Suchschluessel - 9-stelliges IK identifiziert Kostentraeger-Stammsatz, VKNR ableiten |
| P2-210 | P ADT | FALL 1 - IK gueltig: Abrechnungs-VKNR ableiten, IK patientenbezogen speichern, Bedruckungsname verwenden |
| P2-220 | P ADT | FALL 2 - Fusion: aufnehmender Kostentraeger ermitteln, VKNR neu / IK alt, Fusionskette |
| P2-230 | P ADT | FALL 3 - Kostentraeger aufgeloest: Fehlermeldung, keine Abrechnung/Formulare |
| P2-260 | P ADT | FALL 6 - IK ungueltig/abgelaufen: Warnhinweis, Abrechnung auf Anwender-Entscheidung |
| P2-265 | P ADT | FALL 7 - Kostentraeger nicht in KV zulaessig: Fehlermeldung, keine Abrechnung |
| P2-270 | P ADT | FALL 8 - Unbekanntes IK: Warnhinweis, temporaerer KT-Stammsatz anlegen |
| P2-275 | P ADT | Temporaere Datensaetze zur KT-Stammdatei (VKNR, KTAB, Bedruckungsname, GO) |
| K2-276 | K ADT | Bestehende KT-Stammsaetze erweitern (IK + KTAB hinzufuegen) |
| P2-285 | P ADT | FALL 10 - KT-Abrechnungsbereich aufgeloest: Fehlermeldung, keine Abrechnung |

---

## Summary

| Group | Count | ID Range |
|---|---|---|
| Patient Card Read-in | 19 | KP2-100 ... KP2-310 |
| Patient Creation Manually (EV) | 14 | P2-400 ... K2-480 |
| Schein Management | 4 | P2-320, P2-325, KP2-500, KP2-514 |
| Shared: KT-Stammdatei | 10 | P2-200 ... P2-285 |
| **Total** | **47** | |

> **Note:** KT-Stammdatei requirements (P2-200 through P2-285) are shared infrastructure.
> They are invoked during card read-in (via P2-120 referencing Chapter 2.2.2.1) and during
> manual/EV entry (via P2-410 and P2-420 referencing Chapter 2.2.2.1). They are listed
> separately because they serve both paths equally.
