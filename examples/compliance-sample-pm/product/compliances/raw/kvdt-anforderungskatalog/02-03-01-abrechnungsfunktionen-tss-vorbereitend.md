# 2.3 Abrechnungsfunktionen bei den Satzarten 010x

> Quelle: KBV_ITA_VGEX_Anforderungskatalog_KVDT, Version 6.06, 9. Maerz 2026, Seiten 63--80

---

## 2.3 Einleitung

### KP2-500 -- Angabe der abzurechnenden Satzarten 010x bzw. der Scheinuntergruppe beim erstmaligen Kontakt im Quartal

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Beim **erstmaligen Einlesen der Versichertenkarte** eines Versicherten im Quartal muss das System die **Eingabe der abzurechnenden "Satzart 010x" bzw. der "Scheinuntergruppe"** verlangen. Dies kann entweder im direkten Zusammenhang mit dem Einlesevorgang oder beim ersten Erfassen von abrechnungsrelevanten Daten erfolgen.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### KP2-514 -- Ambulante Behandlung (Satzart 0101 mit Scheinuntergruppe 00) bei SKT-Versicherten ohne Versichertenkarte

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

**SKT-Versicherte ohne Versichertenkarte:**

Die Abrechnungssoftware muss sicherstellen, dass zu einem SKT-Versicherten ohne Versichertenkarte (VKNR-Seriennummer 3.-5.Stelle >= 800 oder KTAB != 00) die Satzart 0101 mit der Scheinuntergruppe 00 (Satzart "Ambulante Behandlung") mehrfach im selben Quartal angelegt werden kann, wobei dann gilt, dass bei jeder Anlage einer entsprechenden Satzart der Zeitraum der Gueltigkeit des Abrechnungsscheines in FK 4125 (Gueltigkeitszeitraum von...bis...) erfasst und uebertragen werden muss, sofern die Information ueber die Gueltigkeit vorhanden ist.

**Begruendung:**

SKT-Versicherte ohne Versichertenkarte (z.B. Sozialamt) erhalten unter Umstaenden in einem Quartal mehrere papierne Behandlungsausweise mit Angabe einer eingeschraenkten Gueltigkeit. Fuer jeden Behandlungsausweis muss jeweils ein separater Abrechnungsdatensatz angelegt werden koennen.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

## 2.3.1 Behandlungen auf Grundlage des Terminservice- und Versorgungsgesetzes

Seit Anfang 2016 bieten die Kassenaerztlichen Vereinigungen den Service der Terminservicestelle (TSS) an. Die TSS der jeweiligen Kassenaerztlichen Vereinigung unterstuetzt Patienten mit berechtigtem Vermittlungswunsch dabei, so schnell wie moeglich (maximal 4 Wochen) einen Termin beim Facharzt oder Psychotherapeuten zu vereinbaren.

Fuer Behandlungen, die aufgrund einer Terminvermittlung durch die TSS oder einen Hausarzt zustande gekommen sind, ist eine Verguetung ausserhalb der morbiditaetsbedingten Gesamtverguetung vorgesehen.

Gleiches gilt fuer die Behandlung im Rahmen von offenen Sprechstunden. Hierfuer wurde eine besondere Scheinkennzeichnung mit den Feldern 4103 ("Vermittlungs-/Kontaktart") und 4105 ("Ergaenzende Informationen zur Vermittlungs-/Kontaktart") eingefuehrt und spezifische Regelungen in den KVDT-Anforderungskatalog aufgenommen.

Ueber die TSS koennen auch nicht dringliche Termine vermittelt werden, z. B. wenn der Termin vom Versicherten ueber den eTerminservice der KV gebucht wird, keine Ueberweisung mit dringendem Vermittlungscode vorliegt, bei verschiebbaren Routineuntersuchungen oder in Faellen von Bagatellerkrankungen.

Das Feld 4105 (Ergaenzende Informationen zur Vermittlungs-/Kontaktart) dient zur Uebermittlung weiterer Angaben im Zusammenhang mit der Terminvermittlung. Derzeit existieren keine bundesweit gueltigen Vorgaben fuer eine verpflichtende Belegung des Feldes 4105. Gegebenenfalls bestehen hierzu jedoch regionale Vorgaben der Kassenaerztlichen Vereinigungen.

Fachaerzte profitieren im Fall einer Terminvermittlung durch einen Hausarzt von einer Verguetung der von ihnen durchgefuehrten Leistungen ausserhalb der morbiditaetsbedingten Gesamtverguetung ("HA-Vermittlungsfall"). Die Vermittlungstaetigkeit des Hausarztes wird mittels eines Zuschlages verguetet. Die Abrechnung des Zuschlags erfolgt mit den spezifischen Gebuehrenordnungspositionen 03008 und 04008 des EBM. Voraussetzung fuer die Verguetung des Zuschlags ist die Angabe der Betriebsstaettennummer des Facharztes, bei dem der Termin vermittelt wurde. Hierfuer ist das KVDT-Feld 5003 "(N)BSNR des vermittelten Facharztes" zu verwenden, sodass die Information der Betriebsstaettennummer des Facharztes direkt dem Zuschlag zugeordnet werden kann.

---

### P2-501 -- Anlage weiterer Datensaetze "010x" im Quartal zu demselben Patienten

**Typ:** PFLICHTFUNKTION ADT

Die Software muss es dem Anwender ermoeglichen bei Bedarf weitere beliebige Datensaetze 010x mit gleicher und/oder abweichender Satzart, Scheinuntergruppe anzulegen, auch wenn der Patient im laufenden Quartal bereits erfasst wurde.

**Begruendung:**

Aufgrund der gesonderten Verguetung fuer Behandlungen infolge von Terminvermittlungen bzw. besonderer Konstellation (bspw. offene Sprechstunden) gemaess S 87a Abs. 3 Satz 5 SGB V (i. d. F. des TSVG und GKV-FinStG) sind die abgerechneten Leistungen scheinbezogen zu kennzeichnen.

**Akzeptanzkriterium:**

1. Der Anwender hat die Moeglichkeit fuer einen Patienten im laufenden Quartal bei Bedarf weitere beliebige Datensaetze 010x mit gleicher und/oder abweichender Satzart, Scheinuntergruppe im System zu erfassen.
2. Sofern erneut die Versichertenkarte eingelesen wird, muss ein bereits vorhandenes Einlesedatum in allen Datensaetzen 010x des laufenden Quartals aktualisiert werden (vgl. P2-150).

---

### KP2-502 -- Kennzeichnung der Satzarten 010x bzw. "Scheinuntergruppe" mit der Vermittlungs-/Kontaktart

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software muss dem Anwender die Moeglichkeit geben, bei der Anlage einer weiteren "Satzart" bzw. "Scheinuntergruppe" gemaess P2-501 die Vermittlungs-/Kontaktart anzugeben.

**Begruendung:**

Aufgrund der gesonderten Verguetung fuer Behandlungen infolge von Terminvermittlungen bzw. besonderer Konstellation (bspw. offene Sprechstunden) gemaess S 87a Abs. 3 Satz 5 SGB V (i. d. F. des TSVG und GKV-FinStG) sind die abgerechneten Leistungen scheinbezogen zu kennzeichnen.

**Akzeptanzkriterium:**

1. Der Anwender hat die Moeglichkeit bei der Anlage einer "Satzart" bzw. "Scheinuntergruppe" die Vermittlungs-/Kontaktart (FK 4103) auszuwaehlen.
   - a) Wenn der Anwender eine Vermittlungs-/Kontaktart auswaehlt, dann uebertraegt das System diese Information in der Abrechnung in der Feldkennung 4103.
   - b) Dieses Feld darf nicht automatisch vorbelegt werden.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### KP2-503 -- Ergaenzende Information zur Vermittlungs-/Kontaktart

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software muss dem Anwender die Moeglichkeit geben, bei der Angabe der Vermittlungs-/Kontaktart ergaenzende Informationen als Freitext zu uebertragen.

**Begruendung:**

Aufgrund der gesonderten Verguetung fuer Behandlungen infolge von Terminvermittlungen bzw. besonderer Konstellation (bspw. offene Sprechstunden) gemaess S 87a Abs. 3 Satz 5 SGB V (i. d. F. des TSVG und GKV-FinStG) sind die abgerechneten Leistungen scheinbezogen zu kennzeichnen.

**Akzeptanzkriterium:**

1. Der Anwender hat bei der Angabe der Vermittlungs-/Kontaktart (FK 4103) die Moeglichkeit ergaenzende Informationen in der FK 4105 in der Abrechnung zu uebertragen.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### KP2-505 -- Nachweis der Umsetzung der Funktionen 116117 Terminservice Vermittlungscode

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software muss dem Anwender die Funktionen auf Basis der Kapitel 2 "Umsetzung der Spezifikation -- 116117 Terminservice Vermittlungscode" und 3 "Umsetzung der Bedruckung" des Anforderungskataloges Terminservice bereitstellen.

**Begruendung:**

Aufgrund der gesonderten Verguetung fuer Behandlungen infolge von Terminvermittlungen durch die Terminservice sind die abgerechneten Leistungen scheinbezogen zu kennzeichnen und die relevanten Informationen nach den definierten Vorgaben zu uebertragen.

**Akzeptanzkriterium:**

1. Die Software muss die Funktionen gemaess den Kapiteln 2 "Umsetzung der Spezifikation 116117 Terminservice Vermittlungscode" und 3 "Umsetzung der Bedruckung" des Anforderungsdokumentes "Anforderungskatalog Terminservice" in der Version 3.0.0 [KBV_ITA_VGEX_Anforderungskatalog_116117_TSS] umsetzen und dem Anwender im Rahmen der Ausstellung von Ueberweisungen (auf Muster 6 und PTV 11) bereitstellen.
2. Die Software muss das Audit fuer die Anwendung "116117 Terminservice Vermittlungscode" bei der kv.digital erfolgreich abgeschlossen haben. Als Nachweis muss das Audit-Zertifikat bei der KBV im Rahmen des Zertifizierungsverfahrens "116117 Terminservice Vermittlungscode" eingereicht werden.

**Bedingung:**

Umsetzungspflicht besteht fuer alle Systeme mit Arzt-Patienten-Kontakt und Unterstuetzung der Bedruckung des Personalienfeldes.

---

### K2-512 -- Nachweis der Umsetzung der Funktionen TSS-Abrechnungsinformation

**Typ:** OPTIONALE FUNKTION ADT

Die Software kann dem Anwender die Funktionen auf Basis des Kapitels 4 "Umsetzung der Spezifikation -- 116117 Terminservice TSS-Abrechnungsinformation" des Anforderungskataloges Terminservice bereitstellen.

**Begruendung:**

Aufgrund der gesonderten Verguetung fuer Behandlungen infolge von Terminvermittlungen durch die Terminservice sind die abgerechneten Leistungen scheinbezogen zu kennzeichnen und die relevanten Informationen nach den definierten Vorgaben zu uebertragen.

**Akzeptanzkriterium:**

1. Die Software muss die Funktionen gemaess Kapitel 4 "Umsetzung der Spezifikation -- 116117 Terminservice Abrechnungsinformation" des Anforderungsdokumentes "Anforderungskatalog Terminservice" in der Version 3.0.0 [KBV_ITA_VGEX_Anforderungskatalog_116117_TSS] umsetzen und dem Anwender im Rahmen der Erfassung von Patienten, beim Praxismanagement sowie bei der Abrechnung bereitstellen.
2. Die Software muss die Umsetzung der Funktionalitaeten im Rahmen des KBV Zertifizierungsverfahrens "116117 Terminservice Abrechnungsinformation" nachweisen.
3. Die Software muss das Audit fuer die Anwendung "116117 Terminservice Abrechnungsinformation" bei der kv.digital erfolgreich abgeschlossen haben. Als Nachweis muss das Audit-Zertifikat bei der KBV im Rahmen des Zertifizierungsverfahrens "116117 Terminservice Abrechnungsinformation" eingereicht werden.

**Hinweis:**

Eine Umsetzung ist nur fuer Systeme mit Arzt-Patienten-Kontakt sinnvoll.

---

### KP2-512 -- Befuellung der Datenfelder fuer TSS-Abrechnungsinformationen

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software muss dem Anwender die manuelle Moeglichkeit zur Befuellung der TSS-Felder in der Abrechnung bieten.

**Begruendung:**

Aufgrund der gesonderten Verguetung fuer Behandlungen infolge von Terminvermittlungen sind die abgerechneten Leistungen scheinbezogen zu kennzeichnen und die relevanten Informationen nach den definierten Vorgaben zu uebertragen.

**Akzeptanzkriterium:**

1. Die Software stellt sicher, dass der Anwender die KVDT-Feldkennungen 4103, 4114 und 4115 manuell befuellen kann.

**Bedingung:**

Die Umsetzungspflicht besteht fuer alle Systeme mit Arzt-Patienten-Kontakt.

---

### KP2-513 -- Auswahl/Vorschlag zeitgestaffelter Zuschlaege aufgrund vermittelter Termine

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Ist ein Arzt-Patienten-Kontakt aufgrund einer Terminvermittlung zustande gekommen, muss die Software dem Anwender den zeitgestaffelten Zuschlag (nach Altersklassen und Zeitfristen unterschieden) zur Uebernahme in die Abrechnung vorschlagen, sofern vom Anwender die relevanten Informationen erfasst wurden.

**Begruendung:**

Um den Anwender bei der Abrechnung zu unterstuetzen, soll ihm anhand vorliegender Informationen zur Vermittlungs-/Kontaktart (FK 4103), dem Tag der Terminvermittlung (FK 4115) und dem Leistungstag (FK 5000) der passende zeitgestaffelte Zuschlag angezeigt/vorgeschlagen werden.

**Akzeptanzkriterium:**

1. Die Software ermoeglicht die automatische Zuordnung des zeitgestaffelten Zuschlags (einer GOP) nach Altersklassen und Zeitfristen und schlaegt dem Anwender die Uebernahme des zeitgestaffelten Zuschlags in die Abrechnung anhand des folgenden Algorithmus/Entscheidungsbaums vor:
   - a) Die zeitgestaffelten Zuschlaege muessen in der GO-Stammdatei, der fuer den Anwender durch die zustaendigen KV, die Kennzeichnung zum Setzen durch die Praxis (SDEBM XML-Element `../kv/kennzeichen/arztpraxis/@V = true`) haben.

2. Wenn ein Schein eines Patienten als TSS-Akutfall (FK 4103 gleich 2) gekennzeichnet ist und der Tag der Terminvermittlung (FK 4115) vorliegt und die Versicherten-, Grund- und Konsiliarpauschale (VP/GP/KP) gesetzt ist, dann muss die Software folgendes zur Uebernahme vorschlagen:
   - a) Wenn FK 5000 minus FK 4115 kleiner gleich 1 Kalendertag ist, dann wird der Schein um den Zuschlag mit dem Zusatzkennzeichen A ergaenzt.
   - b) Wenn FK 5000 minus FK 4115 groesser 1 Kalendertag ist, dann erhaelt der Anwender die folgende Warnmeldung:
     - i. Warnmeldung: *"Der Patient wurde nicht am aktuellen Tag oder Folgetag behandelt und ist folglich nicht als TSS-Akutfall kennzeichenbar."*

3. Wenn ein Schein eines Patienten als TSS-Terminfall, HA-Vermittlungsfall oder Routine-Termin (FK 4103 gleich 1, 3 oder 6) gekennzeichnet ist und der Tag der Terminvermittlung (FK 4115) vorliegt und die Versicherten-, Grund- und Konsiliarpauschale (VP/GP/KP) gesetzt ist, dann muss die Software folgendes zur Uebernahme vorschlagen:
   - a) Wenn FK 5000 minus FK 4115 kleiner **gleich** 4 Kalendertage ist, dann wird der Schein um den zeitgestaffelten Zuschlag mit dem Zusatzkennzeichen B ergaenzt.
   - b) Wenn FK 5000 minus FK 4115 groesser 4 Kalendertage und kleiner **gleich** 14 Kalendertage ist, dann wird der Schein um den zeitgestaffelten Zuschlag mit dem Zusatzkennzeichen C ergaenzt.
   - c) Wenn FK 5000 minus FK 4115 groesser 14 Kalendertage und kleiner **gleich** 35 Kalendertage ist, dann wird der Schein um den zeitgestaffelten Zuschlag mit dem Zusatzkennzeichen D ergaenzt.
   - d) Wenn FK 5000 minus FK 4115 groesser 35 Kalendertage ist, dann erhaelt der Anwender die folgende Warnmeldung:
     - i. Warnmeldung: *"Es ist kein zeitgestaffelter Zuschlag mehr abrechenbar, da die 35-Kalendertage-Frist verstrichen ist."*

4. Die Software muss dem Anwender die Moeglichkeit bieten, die Uebernahme des zeitgestaffelten Zuschlags in die Abrechnung zu bestaetigen.
   - a) Der vorgeschlagene zeitgestaffelte Zuschlag kann vom Anwender immer uebersteuert werden.

**Bedingung:**

Die Umsetzungspflicht besteht fuer alle Systeme mit Arzt-Patienten-Kontakt.

**Hinweis:**

Die Funktion KP2-513 muss nicht im unmittelbaren Nachgang einer Terminzuordnung durchlaufen werden, sondern kann vielmehr nach dem Setzen der Versicherten-, Grund- und Konsiliarpauschale (VP/GP/KP) erfolgen. Die Leistungen der VP/GP/KP koennen anhand der EBM-Stammdateien programmatisch daran erkannt werden, dass die Gebuehrennummer der entsprechenden VP/GP/KP in der Grundleistungsliste (SDEBM XML-Element `../gnr/regel/grundleistungen_liste/..`) der Zuschlagsleistungen fuer Terminvermittlung enthalten ist. Diese Zuschlagsleistungen koennen anhand des Vorkommens des Begriffs "TSS-Terminvermittlung" im Kurztext identifiziert werden (SDEBM XML-Element `../gnr/allgemein/legende/kurztext/..`). Bei der Auswahl der passenden Zuschlagsleistung ist ggf. die Altersklasse des Patienten gemaess Anforderung P6-804 zu beruecksichtigen.

#### Beispiel HA-Vermittlungsfall:

| Erfasste FK | Wert | Erlaeuterung |
|---|---|---|
| 4103 | 3 (HA-Vermittlungsfall) | Die GNR 10211 ist in der Grundleistungsliste folgender Leistungen enthalten: 10215, 10220, 10227 und 10228, 10228A bis 10228H. Die GNR 10228(X) stellen Zuschlagsleistungen fuer Terminvermittlungen dar. Die GNR 10228C wird ausgewaehlt, da die Behandlung 7 Kalendertage nach Feststellung der Behandlungsnotwendigkeit erfolgt. Unter Beruecksichtigung der Altersklasse des Patienten wird der Schein um den Zuschlag 10911C ergaenzt. |
| 4115 | 9. Maerz 2023 (Tag der Feststellung der Behandlungsnotwendigkeit) |  |
| 5000 | 16. Maerz 2023 |  |
| 5001 | 10211 (Hautaerztliche Grundpauschale 6. bis 59. Lebensjahr) |  |
| *Ergaenzte FK* | | |
| 5001 | 10911C | |

#### Beispiel TSS-Terminfall:

| Erfasste FK | Wert | Erlaeuterung |
|---|---|---|
| 4103 | 1 (TSS-Terminfall) | Die GNR 25214 ist in der Grundleistungsliste folgender Leistungen enthalten: 01434, 01444, 01450, 01640, 01641, 01670, 25215, 25230, 25230A bis 25230H und 37302. Die GNR 25230(X) stellen Zuschlagsleistungen fuer Terminvermittlungen dar. Die GNR 25230D wird ausgewaehlt, da die Behandlung 21 Kalendertage nach der Vermittlung erfolgt. |
| 4115 | 9. Maerz 2023 |  |
| 5000 | 30. Maerz 2023 |  |
| 5001 | 25214 (Konsiliarpauschale nach strahlentherapeutischer Behandlung) |  |
| *Ergaenzte FK* | | |
| 5001 | 25230D | |

Finden im Behandlungsfall ausschliesslich Arzt-Patienten-Kontakte im Rahmen einer Videosprechstunde gemaess Anlage 31b zum BMV-Ae statt, dann koennen vom Anwender anstelle der Zusatzkennzeichen A, B, C und D die Kennzeichen E, F, G, H gesetzt werden (4.3.1 Absatz 5 Nr. 2 der Allgemeinen Bestimmungen des EBM). Dieser Fall muss gemaess 4.3.1 Absatz 5 Nr. 5 der Allgemeinen Bestimmungen des EBM gegenueber der Kassenaerztlichen Vereinigung zusaetzlich mit der GOP 88220 gekennzeichnet werden. Die Software kann dem Anwender geeignete Moeglichkeiten zur Unterstuetzung anbieten.

---

### KP2-511 -- Uebertragung der Betriebsstaettennummer als Begruendung zu einer GOP bei der Vermittlung eines Termines durch den Hausarzt bei einem Facharzt

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software muss dem Anwender die Moeglichkeit bieten, bei der Vermittlung eines Termines zu einem Facharzt die Betriebsstaettennummer dieses Facharztes als Begruendung zu einer GOP zu uebertragen.

**Begruendung:**

Die an der vertragsaerztlichen Versorgung teilnehmenden Aerzte sind verpflichtet bei der Abrechnung von Leistungen fuer die Vermittlung eines aus medizinisch dringend erforderlichen Behandlungstermins die Arztnummer des Facharztes, bei dem der Termin vermittelt wurde, zu uebermitteln (vgl. S 295 Absatz 1 Satz 1 Nr. 3 SGB V). Die Operationalisierung erfolgt mittels spezifischer Gebuehrenordnungspositionen des EBM und der Angabe der Betriebsstaettennummer des Facharztes, bei dem der Termin vermittelt wurde.

**Akzeptanzkriterium:**

1. Die Software bietet dem Anwender im Rahmen der Vermittlung eines Termines zu einem Facharzt die Moeglichkeit, die Betriebsstaettennummer dieses Facharztes als Begruendung zu einer GOP in die Abrechnung zu uebertragen.
2. Die Software muss es dem Anwender ermoeglichen
   - a) die Betriebsstaettennummer als Freitext einzugeben oder
   - b) die Betriebsstaettennummer als Suchergebnis zu kopieren und einzufuegen, zum Beispiel von der [KBV_Kollegensuche] oder
   - c) die Betriebsstaettennummer aus den Daten nach KP2-508 zu uebernehmen.
3. Die Software uebertraegt die angegebene Betriebsstaettennummer in die Abrechnung in Feld 5003.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### K2-506 -- Anbindung des Webservice-Kollegensuche

**Typ:** OPTIONALE FUNKTION ADT

Die Software kann dem Anwender die Funktionen auf Basis des KBV-Webservices "Kollegensuche" im Rahmen der Arztsuche zur Verfuegung stellen.

**Begruendung:**

Aerzte sollen bei der Suche nach anderen Aerzten unterstuetzt werden. Hierzu stellt die KBV den Webservice "Kollegensuche" bereit, der dazu verwendet werden kann.

**Akzeptanzkriterium:**

1. Die Software verwendet den Webservice-Kollegensuche gemaess dem Dokument:
   - "Webservice-Kollegensuche der KBV" in der stets aktuellen Version [KBV_ITA_VGEX_SST_Kollegensuche]
2. Die Software erfuellt die folgenden Anforderungen:
   - KP2-507
   - KP2-508
   - KP2-509

---

### KP2-507 -- Suchfunktion fuer die Kollegensuche

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software stellt dem Anwender Suchfunktionen auf Grundlage der Daten in der "Kollegensuche" zur Verfuegung.

**Begruendung:**

Aerzte sollen bei der Suche nach anderen Aerzten unterstuetzt werden. Hierzu stellt die KBV den Webservice "Kollegensuche" bereit, der dazu verwendet werden kann.

**Akzeptanzkriterium:**

1. Die Software bietet dem Anwender mindestens die in Kapitel 6 "Festlegungen fuer das PVS" des Dokumentes [KBV_ITA_VGEX_SST_Kollegensuche] genannten Suchfunktionen.
2. Die Software muss dem Anwender die Suchergebnisse in geeigneter Weise anzeigen.
   - a) Die Software muss dem Anwender die Moeglichkeit bieten, sich alle Informationen zu einem Datensatz anzeigen zulassen.

**Bedingung:**

Die Anforderung K2-506 wurde umgesetzt.

---

### KP2-508 -- Uebernahme von Daten in die Abrechnung

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software ermoeglicht dem Anwender eine Betriebsstaettennummer aus einem Suchergebnis in der "Kollegensuche" in die Abrechnung zu uebernehmen.

**Begruendung:**

Aerzte sollen bei der Suche nach anderen Aerzten unterstuetzt werden. Hierzu stellt die KBV den Webservice "Kollegensuche" bereit, der dazu verwendet werden kann.

**Akzeptanzkriterium:**

1. Die Software muss es dem Anwender ermoeglichen, die Betriebsstaettennummer aus einem Datensatz des Suchergebnisses per KP2-507 bzw. aus der Favoritenliste per KP2-509 in der Abrechnung als Begruendung zu einer GOP gemaess KP2-511 anzugeben.

**Bedingung:**

Die Anforderung K2-506 wurde umgesetzt.

---

### KP2-509 -- Anlegen einer Favoritenliste

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software muss dem Anwender das Anlegen einer Favoritenliste ermoeglichen. In der Favoritenliste muss der Anwender die Moeglichkeit haben, auf die wesentlichen Daten zur Terminvermittlung zuzugreifen.

**Begruendung:**

Aerzte sollen bei der Suche nach anderen Aerzten unterstuetzt werden. Hierzu stellt die KBV den Webservice "Kollegensuche" bereit, der dazu verwendet werden kann.

**Akzeptanzkriterium:**

1. Die Software muss dem Anwender die Anlage einer "Favoritenliste" ermoeglichen.
2. Die Software muss dem Anwender die Moeglichkeit bieten, einzelne Datensaetze des Suchergebnisses auf Basis der Anforderung KP2-507 als Favorit zu markieren.

**Bedingung:**

Die Anforderung K2-506 wurde umgesetzt.

---

## 2.3.2 Abrechnungsvorbereitende Funktionen

### P2-510 -- Abrechnungsvorbereitung

**Typ:** PFLICHTFUNKTION ADT

Folgende abrechnungsvorbereitende Funktionen muss die Abrechnungssoftware enthalten:

1. Die Durchfuehrung von **Probeabrechnungen** ist fuer den Anwender jederzeit moeglich.
2. Die Erstellung von **Tageskontrolllisten** ist fuer den Anwender jederzeit moeglich. Tageskontrolllisten beinhalten eine Uebersicht ueber Arzt-Patientenkontakte an einem Kalendertag mit Angaben zu den Patientenpersonalien, den erbrachten Leistungen und den Diagnosen.
3. Der Anwender muss die Moeglichkeit haben, seine **Abrechnung schrittweise** - bzw. auf das gesamte Quartal verteilt -- **richtigzustellen**.

---

## 2.3.3 Quartalsuebergang

### P2-520 -- Quartalsuebergang

**Typ:** PFLICHTFUNKTION ADT

Die Software muss dem Anwender die Bearbeitung von Abrechnungsdaten aus verschiedenen Quartalen quartalstreu ermoeglichen.

**Begruendung:**

Da die Zeitraeume zur Einreichung der Abrechnung nicht direkt auf den Quartalsgrenzen liegen, muss die Software dem Anwender die Bearbeitung von Abrechnungsdaten aus verschiedenen Quartalen quartalstreu ermoeglichen.

**Akzeptanzkriterien:**

1. Die Software muss die Moeglichkeit bieten das Vorquartal auch in Folgequartalen abzurechnen.
2. Falls die Bearbeitung des Vorquartals noch nicht vollstaendig abgeschlossen ist, muss die Software die Moeglichkeit bieten, das Vorquartal auch in einem Folgequartal zu bearbeiten.
3. Falls die Dateneingabe fuer das neue Quartal stattfindet, waehrend die Abrechnung eines Vorquartals noch nicht abgeschlossen wurde, muss die Software alle Daten zu den Satzarten "010x" mehrfach quartalstreu halten. Dies gilt insbesondere fuer das Datum des letzten Einlesetags der Versichertenkarte im Quartal (FK 4109).

---

### P2-521 -- Abrechenbarkeit von "Nachzuegler"-Faellen

**Typ:** PFLICHTFUNKTION ADT

Die Software muss dem Anwender die Moeglichkeit bieten, Behandlungsfaelle aus Vorquartalen (sogenannte "Nachzueglerfaelle") in die aktuelle Quartalsabrechnung zu uebernehmen.

**Begruendung:**

Zu nachtraeglichen Abrechnungen von Behandlungsfaellen aus vorherigen Quartalen muessen Anwender die Moeglichkeiten haben diese Behandlungsfaelle in eine aktuelle Abrechnung zu integrieren.

**Akzeptanzkriterium:**

1. Falls das Quartal des Behandlungsfalles (FK 4101) vor dem aktuellen Abrechnungsquartal (FK 9204) liegt und der Fall nicht abgerechnet wurde, muss die Software dem Anwender eine Abrechnung als Nachzueglerfall im aktuellen Quartal ermoeglichen.

---

## 2.3.4 Besondere Personengruppen-, Kassen- u. Statuswechsel

### P2-530 -- Kassenwechsel im Quartal

**Typ:** PFLICHTFUNKTION ADT

Falls sich im laufenden Quartal die Kombination von Abrechnungs-VKNR (FK 4104) und Kostentraeger-Abrechnungsbereich (KTAB) (FK 4106) eines Patienten aendert, muss die Software automatisch einen neuen Datensatz "010x" fuer die Abrechnung anlegen.

**Begruendung:**

Die Kombination von VKNR und KTAB identifiziert einen Kostentraeger eindeutig.

**Akzeptanzkriterium:**

1. Falls sich die VKNR (FK 4104) -KTAB (FK 4106) -Kombination eines Patienten im laufenden Quartal aendert, muss die Software einen weiteren Datensatz "010x" erzeugen.
   - a) Die Software darf keinen neuen Datensatz "010x" anlegen, wenn sich nur die Kostentraegererkennung (FK 4111), jedoch nicht auch gleichzeitig die Abrechnungs-VKNR aendert.
2. Die Software kann den Anwender ueber die Neuanlage eines Datensatzes "010x" informieren.
3. Bei der Anlage des neuen Datensatzes aufgrund eines Kassenwechsels darf keine Aenderungen des bereits vorhandenen Einlesedatums der Versichertenkarte (FK 4109) mehr stattfinden. Eine Aktualisierung des Einlesedatums findet nur noch fuer den neusten Datensatz statt.
   - a) Die Software muss das Einlesedatum fuer die jeweiligen Faelle "datensatzgetreu" (ggf. mehrfach) speichern und uebertragen (vgl. P2-150).

**Hinweis:**

Nach dieser Vorgabe muss es moeglich sein, dass fuer denselben Patienten in demselben Quartal zu einer Betriebsstaette/Arztnummer mehrere Kostentraeger abrechenbar sind.

**Beispiel:**

**Fall 1)**
- Altes IK: 105180009
- Alte VKNR: 72601
- Neues IK: 104940005
- Neue VKNR: 72601
- --> **Kein weiterer** Datensatz "010x" notwendig.

**Fall 2)**
- Altes IK: 101580004
- Alte VKNR: 72601
- Neues IK: 108077500
- Neue VKNR: 02605
- --> **Weiterer** Datensatz "010x" notwendig.

---

### P2-535 -- Besondere Personengruppen - Wechsel im Quartal

**Typ:** PFLICHTFUNKTION ADT

Falls sich im laufenden Quartal die Besondere Personengruppe (FK 4131) desselben Patienten derselben Kasse aendert, muss die Software automatisch einen neuen Datensatz "010x" fuer die Abrechnung anlegen.

**Begruendung:**

Die Behandlung der durch eine Besondere Personengruppe (FK 4131) gekennzeichneten Patienten fuehrt grundsaetzlich zu spezifischen Verguetungs- und/oder Abrechnungsregelungen ab dem Zeitpunkt des Bekanntwerdens der Zugehoerigkeit zu der jeweiligen Besonderen Personengruppe (FK 4131), sodass eine Trennung der Abrechnungsdaten erforderlich ist.

**Akzeptanzkriterium:**

1. Falls sich die Besondere Personengruppe (FK 4131) eines Patienten im laufenden Quartal aendert, muss die Software einen weiteren Datensatz "010x" erzeugen.
2. Die Software kann den Anwender ueber die Neuanlage eines Datensatzes "010x" informieren.
3. Bei der Anlage des neuen Datensatzes aufgrund der Aenderung der Besonderen Personengruppe darf keine Aenderungen des bereits vorhandenen Einlesedatums der Versichertenkarte (FK 4109) mehr stattfinden. Eine Aktualisierung des Einlesedatums findet nur noch fuer den neusten Datensatz statt.
   - a) Die Software muss das Einlesedatum fuer die jeweiligen Faelle "datensatzgetreu" (ggf. mehrfach) speichern und uebertragen (vgl. P2-150).

---

### P2-540 -- Statuswechsel im Quartal

**Typ:** PFLICHTFUNKTION ADT

Falls sich im laufenden Quartal die Versichertenart (FK 3108) desselben Patienten derselben Kasse aendert, muss die Software automatisch einen neuen Datensatz "010x" fuer die Abrechnung anlegen.

**Begruendung:**

Gemaess S 21 Absatz 1 Satz 4 BMV-Ae ist im Fall eines Wechsels der Versichertenart im Quartal die Versichertenart bei der Abrechnung zu Grunde zu legen, die bei Quartalsbeginn besteht. Zur Dokumentation des Wechsels der Versichertenart erfolgt eine Trennung der Datensaetze.

**Akzeptanzkriterium:**

1. Falls sich die Versichertenart (FK 3108) eines Patienten im laufenden Quartal aendert, muss die Software einen weiteren Datensatz "010x" erzeugen.
2. Das System kann den Anwender ueber die Neuanlage eines Datensatzes "010x" informieren.
3. Bei der Anlage des neuen Datensatzes aufgrund der Aenderung der Versichertenart darf keine Aenderungen des bereits vorhandenen Einlesedatums der Versichertenkarte (FK 4109) mehr stattfinden. Eine Aktualisierung des Einlesedatums findet nur noch fuer den neusten Datensatz statt.
   - a) Die Software muss das Einlesedatum fuer die jeweiligen Faelle "datensatzgetreu" (ggf. mehrfach) speichern und uebertragen (vgl. P2-150).

---

### P2-556 -- Aenderung (bzw. weiteres) Abrechnungsgebiet im Quartal

**Typ:** PFLICHTFUNKTION ADT

Falls im laufenden Quartal bei demselben Patienten derselben Kasse eine Kennzeichnung mit einem weiteren Abrechnungsgebiet (FK 4122) notwendig wird, muss die Software automatisch einen neuen Datensatz "010x" fuer die Abrechnung anlegen.

**Begruendung:**

Mit der Kennzeichnung des Abrechnungsgebietes werden die abgerechneten Leistungen aufgrund spezifischer vertraglicher oder gesetzlicher Anforderungen zusammengefasst und koennen so der Arztpraxis gesondert verguetet bzw. den Krankenkassen in Rechnung gestellt werden.

**Akzeptanzkriterium:**

1. Falls bei einem Patienten im laufenden Quartal eine Kennzeichnung mit einem weiteren Abrechnungsgebiet (FK 4122) notwendig wird, muss die Software einen weiteren Datensatz "010x" erzeugen.
2. Das System kann den Anwender ueber die Neuanlage eines Datensatzes "010x" informieren.
3. Falls die Versichertenkarte erneut eingelesen wird, muss ein bereits vorhandenes Einlesedatum in allen Datensaetzen "010x" mit unterschiedlichem Abrechnungsgebiet des laufenden Quartals aktualisiert werden (vgl. P2-150).

---

## 2.3.5 Aenderung von amtlichen Versichertendaten

Die amtlichen Daten von der Versichertenkarte sind fuer die Abrechnung zu verwenden. Fuer die Arztpraxis sind dagegen diejenigen Daten interessant, unter der ein Patient erreichbar ist.

Fuer die PVS empfiehlt es sich daher, u.U. zwei Datensaetze zu verwalten: z.B. die amtliche Versichertenkarten-Adresse und die reale Wohnadresse des Versicherten.

### 2.3.5.1 Aenderung von amtlichen Versichertendaten

### KP2-557 -- Abrechnungsrelevante Aenderungen von amtlichen Versichertendaten im Quartal

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Falls sich im laufenden Quartal bei demselben Patienten auf der Versichertenkarte die amtlichen Versichertendaten des Geburtsdatums, des Geschlechts, des Namens oder der Adresse aendern, muss die Software diese Aenderungen fuer die Abrechnung uebernehmen.

**Begruendung:**

Aenderungen von Melderegisterdaten von Versicherten fuehren zu Anpassungen der amtlichen Versichertendaten auf den Versicherungskarten. Entweder werden fuer die Versicherten neue Versichertenkarten ausgestellt oder die Versichertendaten werden durch das Online-VSDM auf der eGK aktualisiert.

**Akzeptanzkriterium:**

1. Die Software muss die amtlichen Felder gemaess Tabelle 4 von der Versichertenkarte unveraendert uebernehmen.
2. Falls im laufenden Quartal bei demselben Patienten die Besondere Personengruppe (P2-535), die Kasse (P2-530) und die Versichertenart (P2-540) unveraendert bleiben, muss die Software die Aenderungen der amtlichen Felder 3100, 3101, 3102, 3103, 3104, 3107, 3109, 3110, 3112, 3113, 3114, 3115, 3120, 3121, 3122, 3123 und 3124 aufgrund einer Namens-, Geschlechts-, Geburtsdatums- oder Adressaenderung beim Einlesen der Versichertenkarte automatisch in alle vorhandenen Datensaetze "010x" des Patienten des laufenden Quartals uebernehmen.
3. Falls die automatische Datenuebernahme nach Akzeptanzkriterium (2) erfolgt, darf die Software automatisch keinen neuen Datensatz "010x" anlegen.
4. Falls die automatische Datenuebernahme nach Akzeptanzkriterium (2) erfolgt, muss die Software das Einlesedatum in allen zum Versicherten gehoerenden Datensaetzen "010x" des laufenden Quartals aktualisieren.

**Hinweis:**

#### Tabelle 7 -- Abrechnungsrelevante Aenderungen von amtlichen Versichertendaten im Quartal

| Ereignis | Laufendes Quartal | Vorquartale |
|---|---|---|
| Aenderungen der amtlichen Versichertendaten wegen Namens-/Geschlechts-/Geburtsdatums-/Adresswechsel | Alle Datensaetze "010x" inkl. Einlesedatum aktualisieren | Quartalstreue Datenhaltung (P2-520) |
| Aenderungen der amtlichen Versichertendaten wegen Namens-/Geschlechts-/Geburtsdatums-/Adresswechsel bei gleichzeitigem Besondere Personengruppen-, Kassen- bzw. Statuswechsel | Keine Aktualisierung bereits vorhandener Datensaetze (P2-530 bis P2-540) | Quartalstreue Datenhaltung (P2-520) |

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### 2.3.5.2 Namens- und/oder Adressaenderungen abweichend von der Versichertenkarte

### P2-558 -- Praxisrelevante Namens- und Adressaenderungen

**Typ:** PFLICHTFUNKTION ADT

Die Software muss bei Namens- und/oder Adressaenderungen im laufenden Quartal, die von den Daten auf der Versichertenkarte abweichen, faehig sein die abweichenden Daten zu speichern und zu verwalten, darf diese jedoch nicht in die Abrechnungsdatei uebertragen.

**Begruendung:**

Bei der Abrechnung muessen die amtlichen Daten von der Versichertenkarte verwendet werden, da die Versicherten-/Vertragsdaten auch so zur Abrechnung kommen muessen, wie sie bei den Krankenkassen gemeldet sind.

**Akzeptanzkriterien:**

1. Falls sich fuer einen Versicherten Namens- und/oder Adressaenderungen im laufenden Quartal ergeben, die von den Angaben auf der Versichertenkarte abweichen,
   - a) muss die Software diese Namens- und Adressdaten separat speichern und verwalten
   - b) darf die Software diese Daten nicht zum Zwecke der Abrechnung uebertragen. Die Software muss zum Zwecke der Abrechnung die amtlichen Daten von der Versichertenkarte uebertragen (siehe P2-120)
   - c) muss die Software die Anforderungen KP7-81 sowie KP7-82 gemaess dem Anforderungskatalog [KBV_ITA_VGEX_Anforderungskatalog_Formularbedruckung] umsetzen/beachten.

---

## 2.3.6 Besonderheiten beim Ueberweisungsschein (Muster 6, 10 bzw. 39)

### KP2-560 -- "Auftrag" (Feld FK 4205) bei Muster 6 und Muster 10

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software muss dem Anwender die Eingabe, Speicherung und Uebertragung des "originaeren Auftragstextes" des ueberweisenden Arztes aus den Zeilen "Auftrag" der Muster 6 und Muster 10 ermoeglichen.

**Begruendung:**

Gemaess "Richtlinien der Kassenaerztlichen Bundesvereinigung fuer den Einsatz von IT-Systemen in der Arztpraxis zum Zweck der Abrechnung gemaess S 295 Abs. 4 SGB V", S 1 Datenverarbeitungstechnisches Abrechnungsverfahren, Absatz 1 muessen alle fuer die Abrechnung relevanten Daten elektronisch uebertragen werden koennen.

Gemaess [KBV_Erlaeuterung_Vordrucke], vgl., Muster 6, Punkt 8. bzw. Muster 10, Punkt 13. darf der den Auftrag ausfuehrende Arzt nur die Leistungen durchfuehren, die unter "Auftrag" angegeben sind.

Rechtsgrundlage ist des Weiteren S 297 Abs. 2 SGB V.

**Akzeptanzkriterium:**

1. Falls eine Ueberweisung nach Muster 6 mit markiertem Ankreuzfeld "Ausfuehrung von Auftragsleistungen" (= Satzart 0102 mit Scheinuntergruppe 21) oder nach Muster 10 (= Satzart 0102 mit Scheinuntergruppe 27) erfasst wird, muss die Software vom Anwender, die Uebernahme des originaeren Auftragstextes des ueberweisenden Arztes aus den Zeilen "Auftrag" des jeweiligen Musters fordern.
2. Die Software uebertraegt mit der Abrechnung den vom Anwender angegebenen Auftragstext im Feld FK 4205 (Auftrag).
3. Die Software belegt das Erfassungsfeld nicht mit einem Defaultwert (wie z.B. "Laboruntersuchung") vor bzw. uebertraegt mit der Abrechnung nicht standardmaessig einen Defaultwert (wie z.B. "Laboruntersuchung").
4. Falls eine Ueberweisung nach Muster 6 mit einer von (1) abweichenden Scheinuntergruppe erfasst wird, muss die Software dem Anwender die Erfassung eines ggf. vorhandenen Auftragstextes ebenfalls ermoeglichen. Eine Uebertragung durch die Software erfolgt analog (2).
5. Falls mittels der Satzart 8215 "Auftrag" (LDT 3) Auftragsinformationen in die Software importiert werden, darf die Software, den Inhalt automatisch ins Feld FK 4205 (KVDT) mit der Abrechnung uebertragen.
6. Die Software darf den Anwender mittels Auswahllisten als Eingabehilfe unter folgenden Bedingungen unterstuetzen:
   - a) Die Software muss es dem Anwender ermoeglichen, diese Auswahllisten zu pflegen.
   - b) Das sichtbare Erfassungsfeld ist zunaechst leer, es wird kein voreingestellter Wert angezeigt.
   - c) Ein aus einer Auswahlliste uebernommener Eintrag muss durch den Anwender jederzeit aenderbar sein.

**Bedingung:**

Die Umsetzungspflicht besteht fuer alle Systeme, die den ADT-Datensatz "Ueberweisung" (Satzart 0102) unterstuetzen.

---

### KP2-561 -- "Auftrag" (Feld FK 4205) bei Muster 39

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software muss dem Anwender die Eingabe, Speicherung und Uebertragung des "originaeren Auftragstextes" des ueberweisenden Gynaekologen aus dem Bereich "Auftrag" des Musters 39 ermoeglichen.

**Begruendung:**

Am 1. Januar 2020 ist das organisierte Programm zur Frueherkennung von Zervix-Karzinomen gestartet. Die Grundlage bildet die Richtlinie fuer organisierte Krebsfrueherkennungsprogramme (oKFE-RL). Die differenzierte (Teil-)Beauftragung (konkret: Zytologie oder KO-Test oder HPV-Test) im Primaerscreening oder in der Abklaerungsdiagnostik uebertraegt der ueberweisende Gynaekologe im Bereich Auftrag auf dem Musters 39.

**Akzeptanzkriterium:**

1. Falls ein Muster 39 (= Satzart 0102 mit Scheinuntergruppe 21) vom Anwender erfasst wird, soll die Software vom Anwender die Uebernahme der Auftragsinformationen des ueberweisenden Gynaekologen aus dem Bereich "Auftrag" des Musters 39 fordern.
   - a) Die Software fordert den Anwender im Rahmen der haendischen Erfassung auf die folgenden Informationen einzugeben oder auszuwaehlen:
     - i. Erstens fuer die "Abrechnungsart":
       - P = fuer Primaerscreening
       - A = fuer Abklaerungsdiagnostik
     - ii. Zweitens fuer den "Auftrag":
       - Zyto = zytologische Untersuchung
       - HPV = HPV-Test
       - KoTest = Ko-Test
     - Die Software setzt kombiniert die beiden Informationen mit einem Bindestrich "-" zur Uebertragung in die Abrechnung im Feld FK 4205 (bspw. "P-HPV")
   - b) Die Software kann dem Anwender auch die direkte Erfassung der Wert P-HPV, P-Zyto, P-KoTest, A-HPV, A-Zyto oder A-KoTest ermoeglichen
2. Die Software belegt das Erfassungsfeld nicht mit einem Defaultwert (wie z.B. "Zytologische Untersuchung") vor bzw. uebertraegt mit der Abrechnung nicht standardmaessig einen Defaultwert (wie z.B. "Zytologische Untersuchung").
3. Falls mittels der Satzart 8215 "Auftrag" (LDT 3) Auftragsinformationen in die Software importiert werden, darf die Software den Inhalt aus den Feldern FK 8630 und FK 8629 des Objektes "Obj_0034 (Obj_Krebsfrueherkennung Zervix-Karzinom (Muster 39))" verbunden mit einem Bindestrich "-" automatisch in das Feld FK 4205 (KVDT) uebernehmen und mit der Abrechnung uebertragen.

**Bedingung:**

Die Umsetzungspflicht besteht fuer alle Systeme, die den ADT-Datensatz "Ueberweisung" (Satzart 0102) unterstuetzen.

---

### KP2-562 -- "Ausstellungsdatum" (FK 4102) bei Muster 10 und 10A

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Im Fall einer Ueberweisung fuer in-vitro-diagnostische Auftragsleistungen mittels Muster 10 oder einer Laborueberweisung mittels Muster 10a, muss im Rahmen der Abrechnung das Ausstellungsdatum im Feld 4102 im Abrechnungsdatensatz uebertragen werden.

**Begruendung:**

Zur zeitlichen Zuordnung des Behandlungsfalls im Laborclearing ist es erforderlich, dass das Ausstellungsdatum (FK 4102) bei Muster 10 und Muster 10A uebertragen wird.

**Akzeptanzkriterium:**

1. Die Software fordert den Anwender dazu auf im Rahmen von Auftraegen zur in-vitro-Diagnostik das Ausstellungsdatum vom jeweiligen Muster zu erfassen.
2. Die Software muss im Rahmen der Erfassung pruefen, dass das Ausstellungsdatum kleiner gleich dem Systemdatum ist.
   - a) Wenn das Ausstellungsdatum groesser als das Systemdatum ist, dann weist die Software die Eingabe mit einer Fehlermeldung ab.
3. Die Software uebertraegt das Ausstellungsdatum im Feld 4102 im Rahmen der Abrechnung.

**Bedingung:**

Die Umsetzungspflicht besteht fuer alle Systeme, die den ADT-Datensatz "Ueberweisung" (Satzart 0102) unterstuetzen.

**Hinweis:**

Bei der Uebermittlung eines Laborauftrages mittels LDT 3, kann als Ausstellungdatum (FK 4102 im KVDT) der Wert aus der Feldkennung 8213 (Timestamp_Erstellung_Untersuchungsanforderung) im Objekt Auftragsinformation aus LDT 3 entnommen werden.

---

### KP2-565 -- "Behandlungstag bei IVD-Leistungen" (Feld FK 4214) bei Muster 10, 10A und 39

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Im Fall einer Ueberweisung in-vitro-diagnostischer Leistungen (IVD-Leistungen) mittels Muster 10 oder 39, soll im Rahmen der Abrechnung der Behandlungstag bei IVD-Leistungen im Feld FK 4214 ("Behandlungstag bei IVD-Leistungen") im Abrechnungsdatensatz uebertragen werden. Die Regelung gilt entsprechend fuer bezogene Leistungen nach Abschnitt 32.2 EBM mittels Muster 10A.

**Begruendung:**

Nach den Allgemeinen Bestimmungen 3.8.5 des EBM gilt fuer in-vitro-diagnostische Leistungen der Tag der Probenentnahme als Behandlungstag. Fuer die Anwendung von Abrechnungsbestimmungen (z. B. "einmal je Behandlungstag") ist somit - unabhaengig vom Tag, an dem alle obligaten Leistungsinhalte vollstaendig durchgefuehrt wurden (Leistungstag) - auf den Tag der Probenentnahme abzustellen.

Wird die Laborleistung vom behandelnden Arzt im Praxislabor selbst durchgefuehrt, entspricht der Leistungstag in der Regel dem Behandlungstag. Bei veranlassten in-vitro-diagnostischen Leistungen liegt der Leistungstag ein bis mehrere teilweise voneinander abweichende Tage nach dem Tag der Probennahme durch den behandelnden Arzt.

**Akzeptanzkriterium:**

1. Falls eine Ueberweisung nach den folgenden Kriterien erfasst wird:
   - a) Muster 10 (= Satzart 0102 mit Scheinuntergruppe 27) oder
   - b) Muster 10A (= Satzart 0102 mit Scheinuntergruppe 28) oder
   - c) Muster 39a (= Satzart 0102 mit Scheinuntergruppe 21)

   muss die Software vom Anwender die Uebernahme des Behandlungstages des Ueberweisers anfordern, falls sie diesen nicht bei der Erfassung des Behandlungstages gemaess den Akzeptanzkriterien (3) und (4) unterstuetzt.

2. Die Software uebertraegt mit der Abrechnung den vom Anwender erfassten Behandlungstag im Feld FK 4214.

3. Der Wert des Behandlungstages bei IVD-Leistungen muss bei einer automatischen Erfassung durch die Software entweder dem Probenentnahmedatum oder dem Ausstellungsdatum der Ueberweisung oder dem Probeneingangsdatum in der Einsendepraxis entsprechen. Dabei gilt die folgende Prioritaet:
   1. Probenentnahmedatum
   2. sofern das Probenentnahmedatum nicht bekannt ist:
      - a) Entweder das Ausstellungsdatum
      - b) Oder das Probeneingangsdatum.

4. Die Software kann die Erfassung des Behandlungstages bei IVD-Leistungen wie folgt unterstuetzen:
   - a) Falls ein Probenentnahmedatum zu einer Ueberweisung nach Akzeptanzkriterium 1 bekannt ist, kann die Software das Probenentnahmedatum fuer den Anwender wie folgt automatisch erfassen und im Feld FK 4214 ("Behandlungstag bei IVD-Leistungen") mit der Abrechnung uebertragen:
     - i. Falls die Auftragsinformationen mittels der Satzart 8215 "Auftrag" (LDT 3) in die Software importiert werden und in der Satzart 8215 das Feld FK 8219 (Timestamp_Materialabnahme_entnahme) im Objekt Obj_Material (Obj_0037) vorhanden ist, kann der Wert des Feldes FK 7278 (Datum des Timestamp) im Objekt Obj_Timestamp (Obj_0054) erfasst und uebertragen werden.
     - ii. Falls die Auftragsinformationen mittels der BFB-Formulare 10/E oder 10L/E oder 10A/E erfolgt, kann der Behandlungstag aus dem Barcodefeld "Abnahmedatum" erfasst und uebernommen werden:
       - Muster 10/E Barcodefeld 38
       - Muster 10L/E Barcodefeld 38
       - Muster 10A/E Barcodefeld 36
     - iii. Falls die Uebernahme der Auftragsinformationen mittels der digitalen Muster 10 oder 10A erfolgt, kann der Wert des Behandlungstages aus dem Feld 8219_Abnahmedatum erfasst und uebertragen werden.
   - b) Falls kein Probenentnahmedatum zu einer Ueberweisung vorhanden ist, kann die Software das Ausstellungsdatum statt dem Probeneingangsdatum fuer den Anwender wie folgt automatisch erfassen und im Feld FK 4214 ("Behandlungstag bei IVD-Leistungen") mit der Abrechnung uebertragen:
     - i. Falls die Auftragsinformationen mittels der Satzart 8215 "Auftrag" (LDT 3) in die Software importiert werden und in der Satzart 8215 das Feld FK 8213 (Timestamp_Erstellung_Untersuchungsanforderung) im Objekt Obj_Auftragsinformation (Obj_0013) zur Verfuegung steht, kann der Wert des Feldes FK 7278 (Datum des Timestamp) im Objekt Obj_Timestamp (Obj_0054) erfasst und uebertragen werden.
     - ii. Falls die Uebernahme der Auftragsinformationen mittels der BFB-Formulare 10/E oder 10L/E oder 10A/E oder 39a/E erfolgt, kann der Wert des Behandlungstages aus dem Barcodefeld des Ausstellungsdatums erfasst und uebertragen werden:
       - Muster 10/E Barcodefeld 20
       - Muster 10L/E Barcodefeld 20
       - Muster 10A/E Barcodefeld 18
       - Muster 39a/E Barcodefeld 18
     - Falls die Uebernahme der Auftragsinformationen mittels der digitalen Muster 10 oder 10A oder 39a erfolgt, kann der Wert des Behandlungstages aus dem Feld 4102_Ausstellungsdatum erfasst und uebertragen werden.
   - c) Falls kein Probenentnahmedatum zu einer Ueberweisung vorhanden ist, kann die Software das Ausstellungsdatum statt dem Probeneingangsdatum fuer den Anwender automatisch erfassen und im Feld FK 4214 ("Behandlungstag bei IVD-Leistungen") mit der Abrechnung uebertragen.

5. Der Anwender muss bei der automatischen Uebernahme des Datums fuer das Feld FK 4214 die Moeglichkeit haben, dieses Datum anzupassen.

6. Sofern die Erfassung des Datums fuer das Feld FK 4214 manuell vom Anwender vorgenommen wird, zeigt die Software dem Anwender die Prioritaeten nach Akzeptanzkriterium 3 an.

7. Wenn das Datum der FK 4214 groesser als ist als das Datum der FK 5000, muss die Software dem Anwender einen Warnhinweis anzeigen. Das Datum der FK 4214 darf nicht in der Zukunft liegen.

8. Wenn das Datum der FK 4214 mehr als 60 Tage (einen Monat) kleiner ist als das Datum der FK 5000 muss die Software dem Anwender einen Warnhinweis anzeigen. Der Abstand zwischen FK 4214 (Behandlungstag bei IVD-Leistungen) und FK 5000 (Leistungstag) sollte nicht groesser als 60 Tage (einen Monat) sein.

**Bedingung:**

Die Umsetzungspflicht besteht fuer alle Systeme, die den ADT-Datensatz "Ueberweisung" (Satzart 0102) unterstuetzen.

---

### KP2-570 -- Mehrere Ueberweisungsscheine desselben Patienten

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Liegen mehrere Ueberweisungsscheine desselben Patienten fuer dasselbe Quartal vor, dann muessen separate Abrechnungsdatensaetze angelegt werden koennen.

**Bedingung:**

Die Umsetzungspflicht besteht fuer alle Systeme, die den ADT-Datensatz "Ueberweisung" (Satzart 0102) unterstuetzen.
