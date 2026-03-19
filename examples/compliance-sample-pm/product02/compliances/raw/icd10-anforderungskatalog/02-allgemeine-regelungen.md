# Chapter 2: Allgemeine Regelungen zur ICD-10-GM-Verschluesselung

> Quelle: KBV_ITA_VGEX_Anforderungskatalog_ICD-10, Version 3.10, 15. August 2025
> Abschnitt: 2 Allgemeine Regelungen

## 2.1 Akutdiagnosen (Behandlungsdiagnosen)

### P10-80 — Begriffe Akut-/Dauer-/Anamnestische Diagnosen

| Feld | Wert |
|---|---|
| ID | P10-80 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | Das PVS muss die Begriffe Akutdiagnose, Dauerdiagnose und Anamnestische Diagnose verwenden. Alternative Bezeichnungen, die nicht im Widerspruch stehen, sind zulaessig. |

### P10-90 — Uebertragung Behandlungsdiagnosen

| Feld | Wert |
|---|---|
| ID | P10-90 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | Behandlungsdiagnosen muessen in FK 6001 uebertragen werden. Jede Diagnose besteht mindestens aus ICD-10-GM-Kode und Diagnosensicherheit. Zusaetzlich koennen Seitenlokalisation, Erlaeuterungstext und Ausnahmetatbestand angegeben werden. |

### P10-100 — Akutdiagnosen mit ICD-10-GM kodieren

| Feld | Wert |
|---|---|
| ID | P10-100 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | Bei Akutdiagnosen muss mindestens ein ICD-10-GM-Kode erfasst werden. Freitextdiagnosen ohne ICD-Kode sind nicht zulaessig fuer die Abrechnung. |

### P10-110 — Diagnosensicherheit bei Akutdiagnosen

| Feld | Wert |
|---|---|
| ID | P10-110 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | Bei jeder Akutdiagnose muss eine Diagnosensicherheit (V, G, A, Z) angegeben werden. Das PVS muss die Eingabe erzwingen und darf keinen Defaultwert vorbelegen. |

### P10-111 — Weitere Informationen zur Akutdiagnose

| Feld | Wert |
|---|---|
| ID | P10-111 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | Das PVS muss die Erfassung von Seitenlokalisation (R/L/B), Erlaeuterungstext und Ausnahmetatbestand ermoeglichen, sofern fuer den ICD-Kode relevant. |

## 2.2 Dauerdiagnosen und Anamnestische Diagnosen

### KP10-200 — Kategorisierung Dauer-/Anamnestische Diagnosen

| Feld | Wert |
|---|---|
| ID | KP10-200 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Wenn das PVS Dauerdiagnosen oder Anamnestische Diagnosen unterstuetzt, muss es diese als separate Kategorie fuehren und von Akutdiagnosen unterscheidbar darstellen. |

### KP10-201 — Kennzeichnung in der Patientendokumentation

| Feld | Wert |
|---|---|
| ID | KP10-201 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Dauer- und Anamnestische Diagnosen muessen in der Patientendokumentation als solche erkennbar gekennzeichnet sein. |

### KP10-230 — Uebertragung Dauer-/Anamnestische als Behandlungsdiagnose

| Feld | Wert |
|---|---|
| ID | KP10-230 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Wenn eine Dauerdiagnose oder Anamnestische Diagnose als Behandlungsdiagnose uebernommen wird, muss sie in FK 6001 uebertragen werden (identisch zu Akutdiagnosen). |

### KP10-231 — Diagnosensicherheit bei Dauer-/Anamnestischen Diagnosen

| Feld | Wert |
|---|---|
| ID | KP10-231 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Bei der Uebernahme als Behandlungsdiagnose muss die Diagnosensicherheit geprueft und ggf. aktualisiert werden. Der Anwender muss die DS bestaetigen oder aendern koennen. |

### KP10-232 — Weitere Informationen Dauer-/Anamnestische Diagnosen

| Feld | Wert |
|---|---|
| ID | KP10-232 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Analog zu P10-111 muessen Seitenlokalisation, Erlaeuterungstext und Ausnahmetatbestand auch fuer uebernommene Dauer-/Anamnestische Diagnosen erfassbar sein. |

### KP10-240 — Uebernahme Dauerdiagnosen in die Abrechnung

| Feld | Wert |
|---|---|
| ID | KP10-240 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Dauerdiagnosen koennen als Behandlungsdiagnosen in die Quartalsabrechnung uebernommen werden. Der Anwender muss jede Uebernahme explizit bestaetigen. Die Uebernahme darf nicht vollautomatisch erfolgen (Bewusstseinsentscheidung). |

### O10-270 — Vorauswahl Dauerdiagnosen begrenzen

| Feld | Wert |
|---|---|
| ID | O10-270 |
| Typ | O ADT/BDT |
| Kurzbeschreibung | Optional kann das PVS eine Vorauswahl-Funktion anbieten, die die Menge der zur Uebernahme angebotenen Dauerdiagnosen einschraenkt (z.B. nach Fachgruppe oder Haeufigkeit). |

### KP10-250 — Uebernahme Anamnestische Diagnosen in die Abrechnung

| Feld | Wert |
|---|---|
| ID | KP10-250 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Anamnestische Diagnosen koennen als Behandlungsdiagnosen uebernommen werden. Gleiche Regeln wie KP10-240: explizite Bestaetigung erforderlich, keine automatische Uebernahme. |

### O10-260 — Pool Anamnestische Diagnosen begrenzen

| Feld | Wert |
|---|---|
| ID | O10-260 |
| Typ | O ADT/BDT |
| Kurzbeschreibung | Optional kann der Pool der Anamnestischen Diagnosen begrenzt werden (analog zu O10-270 fuer Dauerdiagnosen). |

## 2.3 Allgemeine Kodierungsregeln

### O10-300 — Anwenderdefinierte Kuerzel

| Feld | Wert |
|---|---|
| ID | O10-300 |
| Typ | O ADT/BDT |
| Kurzbeschreibung | Optional kann das PVS anwenderdefinierte Kuerzel (Synonyme/Mappings) fuer ICD-10-GM-Kodes bereitstellen. Diese Kuerzel duerfen nur als Eingabehilfe dienen und muessen intern auf gueltige ICD-10-GM-Kodes aufgeloest werden. |

### P10-320 — Kein automatisches Hinzufuegen von Diagnosen

| Feld | Wert |
|---|---|
| ID | P10-320 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | Das PVS darf keine Diagnosen automatisch und ohne Wissen des Anwenders dem Behandlungsfall hinzufuegen. Jede Diagnose muss durch bewusste Aktion des Anwenders angelegt werden. |

### KP10-330 — Strichergaenzung (4./5. Stelle)

| Feld | Wert |
|---|---|
| ID | KP10-330 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Wenn ein ICD-Kode 4- oder 5-stellig verschluesselbar ist, muss das PVS den Anwender auf die Moeglichkeit/Pflicht zur Strichergaenzung hinweisen (gemaess SDICD-Attribut). Das PVS muss die Erfassung der tieferen Stelle ermoeglichen. |

### KP10-350 — Z01.7 Befreiung

| Feld | Wert |
|---|---|
| ID | KP10-350 |
| Typ | KP ADT/BDT |
| Kurzbeschreibung | Bei Verwendung des Kodes Z01.7 (Laboruntersuchung) gelten besondere Abrechnungsregeln. Das PVS muss den Anwender auf die Befreiungsregelung hinweisen. |

### O10-360 — Uebernahme ICD-Kodes von externen Systemen

| Feld | Wert |
|---|---|
| ID | O10-360 |
| Typ | O ADT/BDT |
| Kurzbeschreibung | Optional kann das PVS ICD-Kodes aus externen Systemen (z.B. Laborsoftware, Krankenhaus-IS) uebernehmen. Bei der Uebernahme muessen die gleichen Validierungsregeln gelten wie bei manueller Eingabe. |

### P10-375 — Diagnoseklartext anzeigen

| Feld | Wert |
|---|---|
| ID | P10-375 |
| Typ | P ADT/BDT |
| Kurzbeschreibung | Das PVS muss zu jedem erfassten ICD-10-GM-Kode den zugehoerigen Klartext (aus der SDICD) anzeigen. Der Klartext muss in der Patientendokumentation und auf Formularen sichtbar sein. |

---

## Summary

| ID | Type | Short Title |
|---|---|---|
| P10-80 | P | Begriffe Akut/Dauer/Anamnestisch |
| P10-90 | P | Uebertragung Behandlungsdiagnosen FK 6001 |
| P10-100 | P | Akutdiagnosen mit ICD-10-GM kodieren |
| P10-110 | P | Diagnosensicherheit erzwingen |
| P10-111 | P | SL/Erlaeuterung/Ausnahmetatbestand |
| KP10-200 | KP | Kategorisierung Dauer/Anamnestisch |
| KP10-201 | KP | Kennzeichnung in Patientendoku |
| KP10-230 | KP | Uebertragung als Behandlungsdiagnose |
| KP10-231 | KP | DS bei Dauer/Anamnestisch |
| KP10-232 | KP | Weitere Info Dauer/Anamnestisch |
| KP10-240 | KP | Uebernahme Dauerdiagnosen in Abrechnung |
| O10-270 | O | Vorauswahl Dauerdiagnosen |
| KP10-250 | KP | Uebernahme Anamnestische in Abrechnung |
| O10-260 | O | Pool Anamnestische begrenzen |
| O10-300 | O | Anwenderdefinierte Kuerzel |
| P10-320 | P | Kein automatisches Hinzufuegen |
| KP10-330 | KP | Strichergaenzung 4-/5-stellig |
| KP10-350 | KP | Z01.7 Befreiung |
| O10-360 | O | Uebernahme ICD von extern |
| P10-375 | P | Diagnoseklartext anzeigen |
