# 2.3.7 Leistungsdokumentation

> KBV_ITA_VGEX_Anforderungskatalog_KVDT, Version 6.06, 9. März 2026
> Abschnitte 2.3.7 und 2.3.8

---

## 2.3.7.1 Behandlungstag / GNR

### P2-600 - Anordnung Behandlungstag und GNR
**Typ:** PFLICHTFUNKTION ADT

1. Alle Behandlungstage müssen innerhalb eines Datensatzes „010x" aufsteigend sortiert werden.
2. **Alle** Gebührennummern **eines** Behandlungstages müssen nach dem Leistungstag (FK 5000) jeweils als separates Feld unter der Feldkennung 5001 (Gebührennummer) angeordnet werden.

---

## 2.3.7.2 Begründungstexte / GNR

### P2-610 - Zuordnung von Begründungstexten zu GNRn
**Typ:** PFLICHTFUNKTION ADT

1. Für die Zuordnung von Begründungstexten zu GNRn gilt:
   a) Jeder beliebigen Gebührennummer müssen eine oder mehrere Begründungstexte zugeordnet werden können.
   b) Begründungstexte müssen unter der jeweils vorgeschriebenen Feldkennung übertragen werden können.
   c) Das Abrechnungssystem muss dem Anwender eine Differenzierung der Begründungsarten bei der Leistungserfassung ermöglichen.
   d) Alle Begründungstexte müssen mit der jeweiligen Feldkennung jeweils „hinter" der entsprechenden GNR abgespeichert werden.

2. Für das Feld mit der FK 5012 „Sachkosten/Materialkosten in Cent" gilt zusätzlich:
   a) Enthält der Behandlungstag (FK 5000) keine GNR (FK 5001), muss der FK 5012 aus formalen Gründen die **Pseudo-Gebührennummer** „88999" (FK 5001) vorangehen, wenn nicht eine abweichende Regelung zur Pseudo-GNR unter den Feldkennungen 9410/9411 der KV-Spezifika-Stammdatei definiert ist.
   b) Einige KVen verlangen bei der Abrechnung von Sachkosten vor jeder FK 5012 generell, auch wenn der Behandlungstag eine Gebührennummer enthält, eine der speziellen Pseudo-Gebührennummern für Kosten (FK 5001), welche unter der Feldkennung 9410 in der KV-Spezifika-Stammdatei hinterlegt sind.

3. Wird die über die KV-Spezifika-Stammdatei definierte KV-spezifische Vorgabe zu Punkt 2.b) zur Pseudo-Gebührennummer vom Anwender nicht beachtet, so muss
   a) entweder ein entsprechender **Warnhinweis** unter Verwendung der Angaben aus den Feldkennungen 9410/9411 der KV-Spezifika-Stammdatei ausgegeben
   b) oder die spezielle **Pseudo-Gebührennummer automatisch** übertragen werden, welche als einzige Pseudo-GNR unter der Feldkennung 9410 in der KV-Spezifika-Stammdatei hinterlegt ist,

   falls nicht der FK 5012 eine Gebührennummer vorangeht, zu der in der EBM-Stammdatei `../gnr_zusatzangaben/gnr_zusatzangaben_liste/gnr_zusatzangabe/@V="5012"` hinterlegt ist.

**Hinweis:**

Im Rahmen einer ASV-Abrechnung gelten auch die Anforderungen des Kapitels 3.6.5.1 „Abrechnung von ASV-Leistungen, die nicht Bestandteil des EBM sind" aus [KBV_ITA_VGEX_Datensatzbeschreibung_KVDT].
Die Funktion P2-610 2. b) gilt nicht, falls die FK 5012 im Rahmen der ASV-Abrechnung zur Übertragung von GOÄ-Preisen verwendet wird.

---

### P21-015 - Erfassung und Übertragung der Angaben „Name Hersteller/ Lieferant" im Feld 5074 und „Artikel-/ Modellnummer" im Feld 5075 zu den Sachkosten im Feld 5012
**Typ:** PFLICHTFUNKTION ADT

Die Software muss die Erfassung und Übertragung der Angaben „Name Hersteller/ Lieferant" im Feld 5074 und „Artikel-/ Modellnummer" im Feld 5075 zu den Sachkosten im Feld 5012 in der ADT-Abrechnung ermöglichen.

**Begründung:**

Gemäß der ASV-Abrechnungsvereinbarung müssen die bis zum 31.12.2019 angefallenen Sachkosten um die Angaben „Name Hersteller/ Lieferant" und „Artikel-/ Modellnummer" erweitert werden. Ab dem 01.01.2020 können die Angaben freiwillig im Rahmen der ASV-Abrechnung erfolgen. Ab dem 01.04.2021 kann eine Belegung der Felder auch ohne ASV-Bezug erfolgen.

**Akzeptanzkriterium:**

1. Im Rahmen der ADT-Abrechnung muss der Anwender die Möglichkeit haben, bei vorhandenen Sachkosten, diese durch die Angaben „Name Hersteller/ Lieferant" im Feld 5074 und „Artikel-/ Modellnummer" im Feld 5075 näher zu spezifizieren.
2. In der ADT-Abrechnung können zusätzlich zu den vorhandenen Sachkosten (FK 5012) und der Sachkostenbezeichnung (FK 5011) die Felder 5074 (Name Hersteller/ Lieferant) und 5075 (Artikel-/ Modellnummer) entsprechend der KVDT-Datensatzbeschreibung übertragen werden.

**Hinweis:**

Im Feld 5074 ist grundsätzlich der Name des Herstellers zu übertragen. Ist der Name des Herstellers auf der Rechnung nicht angegeben bzw. nicht bekannt, ist der Name des Lieferanten anzugeben.

---

## 2.3.7.3 Abrechnungsbegründungen bei Berechnung genetischer Untersuchungen

Für alle humangenetischen Leistungen, die gemäß den EBM-Abrechnungsbestimmungen die Angabe eines HGNC-Gensymbols und/oder der Art der Erkrankung erfordern und ab dem 3. Quartal 2025 durchgeführt und abgerechnet werden, gilt die Verpflichtung zur Verwendung der HGNC-Kodierung. Diese Regelung gilt auch für die Abrechnung von humangenetischen Leistungen als „Nachzüglerfälle" aus vorherigen Quartalen. Sollten beispielsweise humangenetische Leistungen vor dem 01.07.2025 erbracht und erst mit der Abrechnung im dritten Quartal 2025 abgerechnet werden, müssen diese Leistungen ebenfalls mit HGNC kodiert werden. Dies ergibt sich daraus, dass in der KVDT-Datensatzbeschreibung die Feldkennungen für OMIM-Kodierung gestrichen wurden.

Die online Bereitstellung älterer OMIM-Stammdateien nach dem 01.07.2025 ist zu unterbinden.

### KP2-621 - Einsatz der HGNC-Schlüsseltabelle zur Kodierung von genetischen Leistungen
**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Gemäß den EBM-Abrechnungsbestimmungen zu genetischen Leistungen müssen im Rahmen der Abrechnung diese mit HGNC-Gensymbolen kodiert werden.

**Begründung:**

Die Anforderung resultiert aus den EBM-Abrechnungsbestimmungen zu genetischen Leistungen.

**Akzeptanzkriterium:**

1. Das Softwaresystem muss die Daten der HGNC-Schlüsseltabelle (OID) im System vorhalten.
2. Der Anwender muss die Möglichkeit haben, nach einem HGNC-Gensymbol zu suchen und ggf. den gewählten Wert als Abrechnungsbegründung leistungsbezogen zu einer GOP automatisch in das Feld 5077 (HGNC-Gensymbol) zu übernehmen.
3. Das Softwaresystem muss das vom Anwender eingegebene HGNC-Gensymbol während der Eingabe (Echtzeitprüfung) auf Existenz gegen die Werte der HGNC-Schlüsseltabellen (Element `/key/@DN`) prüfen.
   a) Falls das zu dokumentierende HGNC-Gensymbol **nicht** in der Schlüsseltabelle enthalten ist, gilt folgendes:
      i. Systemseitig erfolgt ein Warnhinweis, dass das eingegebene HGNC-Gensymbol nicht in der Schlüsseltabelle existiert.
      ii. In diesem Fall muss das Softwaresystem sicherstellen, dass der Ersatzwert „999999" im jeweiligen KVDT-Feld 5077 übertragen wird.
      iii. Beim Eintrag des Ersatzwertes „999999" in Feld 5077 muss der Anwender im Feld 5078 (Gen-Name) einen Freitext zur Bezeichnung des Gens angeben.
   b) Falls das dokumentierte HGNC-Gensymbol in der Schlüsseltabelle enthalten ist, darf der Anwender **nicht** die Möglichkeit haben das Feld 5078 zu befüllen.
4. Die Software überträgt mit der Abrechnung das vom Anwender zu einer Leistung angegebene „HGNC-Gensymbol" im Feld 5077.
5. Die Software überträgt mit der Abrechnung den vom Anwender zu einer Leistung angegebene „Gen-Name" im Feld 5078, sofern ein Wert vorhanden ist.
6. Falls in der [EBM-Stammdatei] zu einer GOP unter `../gnr_zusatzangaben/gnr_zusatzangaben_liste/gnr_zusatzangabe` der Wert V="5077" (HGNC-Gensymbole) hinterlegt ist und das HGNC-Gensymbol als Begründungstyp ausgewählt wird, muss das Softwaresystem folgendes sicherstellen:
   a) Das Softwaresystem muss vom Anwender die Angabe mindestens eines HGNC-Gensymboles fordern.
7. Der Vertragsarzt bzw. der PVS-Hersteller hat keine Möglichkeit die Schlüsseltabelle, um zusätzliche HGNC-Symbole zu erweitern.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung ist Software, die ausschließlich für die Abrechnung von Laborgemeinschafts-Leistungen aus dem EBM-Abschnitt 32.2 verwendet wird (gemäß § 25 Abs. 2 und 3 BMV-Ä).

Software, die diesem Kriterium unterliegt, unterstützt ausschließlich die Abrechnung der Satzart 0102 mit der Scheinuntergruppe 28.

**Erläuterung der HGNC-Schlüsseltabelle:**

Die HGNC-Schlüsseltabelle beinhaltet eine Vielzahl von Schlüssel-Wert-Paaren.

Die Attribute des XML-Elementes key haben die folgende Bedeutung:

- **V** = Dieses Attribut enthält die ID des Eintrages. Eine ID kann wie folgt aufgebaut sein:
  - `HGNC:[XXXXX]` = Dies entspricht der originären HGNC-ID. Der Ausdruck [XXXXX] kann eine beliebig lange numerische Zeichenfolge sein.
  - `KBV:[XXXXX]::[XXXXX]` = Dies entspricht der von der KBV vergebenen ID des Eintrags, welche die KBV ergänzt hat. Die Ausdrücke [XXXXX] entsprechen dem Zahlenwert der HGNC-ID.
  - `KBV:999999` = ID des Ersatzwertes
- **DN** = Dieses Attribut gibt immer ein Gen an. Dabei ist zu beachten, dass es sich entweder um ein einzelnes Gen oder um ein Fusionsgen handeln kann. Der Inhalt ist wie folgt aufgebaut:
  - Ein einzelnes Gen: Eine beliebige Zeichenfolge
  - Ein Fusionsgen: Zwei beliebige Zeichenfolgen (Abbildung von Genen gemäß HGNC-Nomenklatur) mit dem Trennzeichen „::" gemäß HGNC-Konvention zur Kennzeichnung eines Fusionsgens.
  - Ersatzwert: 999999
- **S** = Der Inhalt dieses Attributes ist die OID (1.2.276.0.76.3.1.1.5.2.117) der Schlüsseltabelle.
- **SV** = Der Inhalt dieses Attributes ist die Versionsnummer der Schlüsseltabelle. Mit jeder Aktualisierung der Schlüsseltabelle wird die Versionsnummer angepasst.

---

### KP2-622 - Definition und Verwaltung von HGNC-Gensymbol-Ketten
**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Das Softwaresystem ermöglicht dem Anwender die Erfassung, Verwaltung und den Einsatz von HGNC-Gensymbol-Ketten. HGNC-Gensymbol-Ketten sind mehrere zu einer Gruppe zusammengefasste HGNC-Gensymbole.

**Begründung:**

Durch die Verwendung von HGNC-Gensymbol-Ketten soll der Aufwand der Abrechnungsdokumentation für umfangreiche genetische Untersuchungen verringert werden.

**Akzeptanzkriterium:**

1. Jede HGNC-Gensymbol-Kette muss einen eindeutigen Identifikator besitzen.
2. HGNC-Gensymbol-Ketten sind im Softwaresystem Patientenunabhängig anzulegen.
3. Bei der Anlage von HGNC-Gensymbol-Ketten dürfen nur gültige HGNC-Gensymbole laut der aktuellen HGNC-Schlüsseltabelle verwendet werden.
   a) d.h., das Softwaresystem muss die vom Anwender eingegebenen bzw. ausgewählten HGNC-Gensymbole, während der Eingabe bzw. Auswahl, für die HGNC-Gensymbol-Kette auf Existenz in der HGNC-Schlüsseltabelle überprüfen (Echtzeitprüfung). Die HGNC-Gensymbole müssen einem Wert der Datei (Element `/key/@DN`) entsprechen.
4. Der Anwender hat im Softwaresystem die Möglichkeit sich alle definierten HGNC-Gensymbol-Ketten anzeigen zulassen.
5. Der Anwender hat im Softwaresystem die Möglichkeit eigen definierte HGNC-Gensymbol-Ketten zu bearbeiten:
   a) weitere HGNC-Gensymbole zu einer definierten HGNC-Gensymbol-Kette hinzufügen,
   b) HGNC-Gensymbole aus einer Kette entfernen oder
   c) die gesamte HGNC-Gensymbol-Kette entfernen.
6. Im Rahmen des Quartalswechsels bzw. beim Einspielen einer neuen HGNC-Schlüsseltabelle muss das Softwaresystem automatisch alle definierten HGNC-Gensymbol-Ketten daraufhin überprüfen, dass nur gültige HGNC-Gensymbole verwendet werden.
   a) Wenn das Softwaresystem feststellt, dass einzelne HGNC-Gensymbole einer Kette laut der HGNC-Schlüsseltabelle nicht mehr gültig sind, dann muss der Anwender aufgefordert werden die HGNC-Gensymbol-Kette zu aktualisieren.

---

### KP2-623 - Verwendung von HGNC-Gensymbol-Ketten zur Abrechnungsdokumentation
**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Das Softwaresystem bietet dem Anwender die Möglichkeit definierte HGNC-Gensymbol-Ketten im Rahmen der Leistungsdokumentation einzusetzen.

**Begründung:**

Durch die Verwendung von HGNC-Gensymbol-Ketten soll der Aufwand der Abrechnungsdokumentation für umfangreiche genetische Untersuchungen verringert werden.

**Akzeptanzkriterium:**

1. Es dürfen nur HGNC-Gensymbol-Ketten verwendet werden, welche gemäß der Anforderung KP2-622 definiert wurden.
2. Der Anwender muss eine HGNC-Gensymbol-Kette zu einer abzurechnenden GOP zuordnen können. Das Softwaresystem muss die einzelnen enthaltenen HGNC-Gensymbole automatisch in je ein Feld 5077 übertragen.
3. Nach Übernahme einer HGNC-Gensymbol-Kette in die Leistungsdokumentation hat der Anwender die Möglichkeit zu einer abzurechnenden GOP weitere HGNC-Gensymbole (gemäß der Anforderung KP2-621) und/oder weitere HGNC-Gensymbol-Ketten zu ergänzen.

---

### KP2-624 - Erfassung der Art der Erkrankung
**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Das Softwaresystem bietet dem Anwender die Möglichkeit, die Art der Erkrankung im Rahmen der Leistungsdokumentation zu erfassen und mit der Abrechnung zu übertragen.

**Begründung:**

Die Anforderung resultiert aus den EBM-Abrechnungsbestimmungen für die GOPen 11233, 11511 bis 11513, 11516 bis 11518, 11521, 11522, 19421 und 19424, 19451 bis 19453 und 19456.

**Akzeptanzkriterium:**

1. Die Software ermöglicht dem Anwender im Rahmen der Leistungsdokumentation die Angabe der „Art der Erkrankung" (FK 5079) als Freitext.
2. Die Software überträgt mit der Abrechnung, die vom Anwender zu einer Leistung angegebene „Art der Erkrankung" im Feld 5079.
3. Falls der Anwender mehrere Einträge (Anzahl >1) zur „Art der Erkrankung" vornimmt, muss das Feld 5079 ebenfalls mehrfach (Anzahl > 1) in die Abrechnungsdatei übertragen werden.

---

### KP2-612 - Übermittlung der Art der Erkrankung zur Abrechnungstransparenz für die GOP 11233[G-alpha]
**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software muss die Angabe der Art der Erkrankung (FK 5079) zur GOP 11233[G-alpha] ermöglichen.

**Begründung:**

Gemäß EBM-Abrechnungsbestimmungen zu der GOP 11233[G-alpha] ist die „Art der Erkrankung" anzugeben.

**Akzeptanzkriterium:**

Es gelten alle Vorgaben der Funktion KP2-624 unter Beachtung der folgenden Kriterien:

1. Die Software muss vom Anwender bei der Erfassung der GOP 11233[G-alpha] im Rahmen der Leistungsdokumentation **genau** eine Angabe „Art der Erkrankung" (FK 5079) fordern.
2. Die Software überträgt mit der Abrechnung für die Leistung GOP 11233[G-alpha] die zur Leistung vom Anwender angegebene „Art der Erkrankung" im Feld FK 5079.
3. Die Software überträgt mit der Abrechnung für die Leistung GOP 11233[G-alpha] nicht das Feld FK 5077.

> **Beispiel:**
>
> Konstellation 1:
> - ...5001  11233
> - ...5005  08
> - ...5079  obligat: Art der Erkrankung

---

### KP2-613 - Übermittlung von HGNC-Gensymbol und der Art der Erkrankung zur Abrechnungstransparenz für die GOPen 11511[G-alpha], 11512[G-alpha], 11516[G-alpha] bis 11518[G-alpha] und 11521[G-alpha]
**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software muss die Angabe des HGNC-Gensymbols (FK 5077) und die Art der Erkrankung (FK 5079) zu den GOPen 11511[G-alpha], 11512[G-alpha], 11516[G-alpha] bis 11518[G-alpha] und 11521[G-alpha] ermöglichen.

**Begründung:**

Die Berechnung der GOPen 11511, 11512, 11516 bis 11518 und 11521 setzt die Begründung, die die Art der Erkrankung enthält, und die Angabe der Art der Untersuchung (HGNC-Gensymbol) voraus.

**Akzeptanzkriterium:**

Es gelten alle Vorgaben der FunktionKP2-621 und KP2-624 unter Beachtung der folgenden Kriterien:

1. Das Softwaresystem muss vom Anwender bei der Erfassung der o.g. GOPen im Rahmen der Leistungsdokumentation **genau** eine Angabe eines HGNC-Gensymbols (FK 5077) **und** einer „Art der Erkrankung" (FK 5079) fordern. Der Anwender darf nicht die Möglichkeit haben mehrere HGNC-Gensymbole bzw. mehrere Angaben zur „Art der Erkrankung" für eine Leistungsziffer zu erfassen und in die Abrechnung zu übertragen.

> **Beispiele:**
>
> Konstellation 1:
> - ...5001  11511
> - ...5005  08
> - ...5077  A1BG  (HGNC-Gensymbol)
> - ...5079  obligat: Art der Erkrankung
>
> Konstellation 2:
> - ...5001  11511
> - ...5005  03
> - ...5077  999999  (Ersatzwert)
> - ...5078  obligat: Gen-Name

---

### KP2-614 - Übermittlung von HGNC-Gensymbol und der Art der Erkrankung zur Abrechnungstransparenz für die GOPen 11513[G-alpha] und 11522[G-alpha]
**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software muss die Angabe des HGNC-Gensymbols (FK 5077) und die Art der Erkrankung (FK 5079) zu den GOPen, 11513[G-alpha] und 11522[G-alpha] ermöglichen.

**Begründung:**

Die Berechnung der GOPen 11513 und 11522 setzt die Begründung, die die Art der Erkrankung enthält, und die Angabe der Art der Untersuchung (HGNC-Gensymbol) voraus.

**Akzeptanzkriterium:**

Es gelten alle Vorgaben der Funktionen KP2-621 und KP2-624 unter Beachtung der folgenden Kriterien:

1. Das Softwaresystem muss vom Anwender bei der Erfassung der GOPen 11513[G-alpha] und 11522[G-alpha] im Rahmen der Leistungsdokumentation **mindestens** eine Angabe eines „HGNC-Gensymbols" (FK 5077) **und** eine Angabe der „Art der Erkrankung" (FK 5079) fordern.
   a) Der Anwender kann zu den genannten GOPen auch mehrere HGNC-Gensymbole und mehrere Angaben zur „Art der Erkrankung" angegeben/eintragen.
   b) Werden mehrere Angaben zur „Art der Erkrankung" eingetragen, so muss das Softwaresystem das Feld 5079 mehrfach in die Abrechnungsdatei übertragen.
2. Für die Eintragung von mehreren HGNC-Gensymbolen zu den genannten GOPen können HGNC-Gensymbol-Ketten nach der Funktion KP2-623 verwendet werden.

> **Beispiele:**
>
> Konstellation 1:
> - ...5001  11513
> - ...5005  08
> - ...5077  A1CF (HGNC-Gensymbol)
> - ...5077  A2M  (HGNC-Gensymbol)
> - ...5079  obligat: Art der Erkrankung
> - ...5079  obligat: Art der Erkrankung
>
> Konstellation 2:
> - ...5001  11513
> - ...5005  03
> - ...5077  999999  (Ersatzwert)
> - ...5078  obligat: Gen-Name
> - ...5079  obligat: Art der Erkrankung

---

### KP2-615 - Übermittlung von HGNC-Gensymbol und der Art der Erkrankung und eines ICD-10-GM-Kodes zur Abrechnungstransparenz für die GOPen 19424[G-alpha], 19453[G-alpha] und 19456[G-alpha]
**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software muss die Angabe des HGNC-Gensymbols (FK 5077), der Art der Erkrankung (FK 5079) und die Angabe eines gültigen ICD-10-GM-Kodes (FK 6001) zu den GOPen 19424[G-alpha], 19453[G-alpha] und 19456[G-alpha] ermöglichen.

**Begründung:**

Gemäß EBM-Abrechnungsbestimmungen zu den GOPen 19424[G-alpha], 19453[G-alpha] und 19456[G-alpha] sind die „Art der Untersuchung (Gensymbol nach HGNC)" und die „Art der Erkrankung gemäß der Kodierung nach ICD-10-GM", die „Art der Erkrankung" kann angegeben werden.

**Akzeptanzkriterium:**

Es gelten alle Vorgaben der Funktionen KP2-621, KP2-624 und KP2-618 unter Beachtung der folgenden Kriterien:

1. Das Softwaresystem muss vom Anwender bei der Erfassung der GOPen 19424[G-alpha], 19453[G-alpha] und 19456[G-alpha] im Rahmen der Leistungsdokumentation **mindestens** eine Angabe des „HGNC-Gensymbols" (FK 5077) fordern. Der Anwender kann zu den genannten GOPen auch mehrere „HGNC-Gensymbole" (FK 5077) eintragen.
2. Bei den GOPen 19424[G-alpha], 19453[G-alpha] und 19456[G-alpha] muss nicht zwingend die „Art der Erkrankung" (FK 5079) erfasst werden. Jedoch muss dem Anwender die Erfassung einer oder mehrere „Arten der Erkrankungen" möglich sein.
3. Für die Eintragung von mehreren HGNC-Gensymbolen zu den genannten GOPen können HGNC-Gensymbol-Ketten nach der Funktionen KP2-623 verwendet werden.

> **Beispiel:**
>
> Konstellation 1:
> - ...5001  19424
> - ...5005  08
> - ...5077  BRAF  (HGNC-Gensymbol)
> - ...5077  KBV:999999  (Ersatzwert)
> - ...5078  obligat: Gen-Name
> - ...5079  optional: Art der Erkrankung
> - ...5079  optional: Art der Erkrankung
> - ...
> - ...6001  obligat: ICD-10-GM-Kode
> - ...6003  obligat: G
>
> Konstellation 2:
> - ...5001  19453
> - ...5005  03
> - ...5077  999999  (Ersatzwert)
> - ...5078  obligat: Gen-Name
> - ...5077  999999  (Ersatzwert)
> - ...5078  obligat: Gen-Name
> - ...5079  optional: Art der Erkrankung
> - ...
> - ...6001  obligat: ICD-10-GM-Kode
> - ...6003  obligat G

---

### KP2-616 - Übermittlung von HGNC-Gensymbol und der Art der Erkrankung und eines ICD-10-GM-Kodes zur Abrechnungstransparenz für die GOPen 19421[G-alpha], 19451[G-alpha] und 19452[G-alpha]
**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software muss die Angabe HGNC-Gensymbol (FK 5077), die Angabe „Art der Erkrankung" (FK 5079) und die Angabe eines gültigen ICD-10-GM-Kodes (FK 6001) zu den GOPen 19421[G-alpha], 19451[G-alpha] und 19452[G-alpha] ermöglichen.

**Begründung:**

Gemäß EBM-Abrechnungsbestimmungen zu den GOPen 19421[G-alpha], 19451[G-alpha], und 19452[G-alpha] sind die „Art der Untersuchung (HGNC-Gensymbol)" und die „Art der Erkrankung gemäß der Kodierung nach ICD-10-GM" anzugeben, die „Art der Erkrankung" kann angegeben werden.

**Akzeptanzkriterium:**

Es gelten alle Vorgaben der Funktionen KP2-621, KP2-624 und KP2-618 unter Beachtung der folgenden Kriterien:

1. Das Softwaresystem muss vom Anwender bei der Erfassung der GOPen 19421[G-alpha], 19451[G-alpha] und 19452[G-alpha] im Rahmen der Leistungsdokumentation **genau** eine Angabe des HGNC-Gensymbols (FK 5077) fordern.
2. Bei den GOPen 19421[G-alpha], 19451[G-alpha] und 19452[G-alpha] muss nicht zwingend die „Art der Erkrankung" (FK 5079) erfasst werden. Jedoch muss dem Anwender die Erfassung **genau einer** „Art der Erkrankung" ermöglicht werden.

---

### KP2-617 - Übermittlung eines ICD-10-GM-Kodes zur Abrechnungstransparenz für die GOPen 11302[G-alpha], 11303[G-alpha], 19402[G-alpha], 32901[G-alpha], 32902[G-alpha], 32904[G-alpha], 32906[G-alpha], 32908[G-alpha], 32910[G-alpha], 32911[G-alpha], 32915[G-alpha], 32916[G-alpha], 32917[G-alpha] und 32918[G-alpha]
**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software muss die Angabe einer „Art der Erkrankung gemäß der Kodierung nach ICD-10-GM" zu den GOPen 11302[G-alpha], 11303[G-alpha], 19402[G-alpha], 32901[G-alpha], 32902[G-alpha], 32904[G-alpha], 32906[G-alpha], 32908[G-alpha], 32910[G-alpha], 32911[G-alpha], 32915[G-alpha], 32916[G-alpha], 32917[G-alpha] und 32918[G-alpha] ermöglichen.

**Begründung:**

Gemäß EBM-Abrechnungsbestimmungen zu den GOPen 11302[G-alpha], 11303[G-alpha], 19402[G-alpha], 32901[G-alpha], 32902[G-alpha], 32904[G-alpha], 32906[G-alpha], 32908[G-alpha], 32910[G-alpha], 32911[G-alpha], 32915[G-alpha], 32916[G-alpha], 32917[G-alpha] und 32918[G-alpha] ist die „Art der Erkrankung gemäß der Kodierung nach ICD-10-GM" anzugeben.

**Akzeptanzkriterium:**

1. Es gelten alle Vorgaben der Funktion KP2-618.
2. Die Software überträgt mit der Abrechnung für die Leistung der o.g. GOPen nicht die Felder FK 5070 und FK 5077 und FK 5079.

---

### KP2-618 - Übermittlung eines ICD-10-GM-Kodes zur Abrechnungstransparenz für die Funktionen KP2-615, KP2-616 und KP2-617
**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software muss die Angabe einer „Art der Erkrankung gemäß der Kodierung nach ICD-10-GM" zu den GOPen 11302[G-alpha], 11303[G-alpha], 19402[G-alpha], 19421[G-alpha], 19424[G-alpha], 19451[G-alpha], 19452[G-alpha], 19453[G-alpha], 19456[G-alpha], 32901[G-alpha], 32902[G-alpha], 32904[G-alpha], 32906[G-alpha], 32908[G-alpha], 32910[G-alpha], 32911[G-alpha], 32915[G-alpha], 32916[G-alpha], 32917[G-alpha] und 32918[G-alpha] ermöglichen.

**Begründung:**

Gemäß EBM-Abrechnungsbestimmungen zu den GOPen 11302[G-alpha], 11303[G-alpha], 19402[G-alpha], 19421[G-alpha], 19424[G-alpha], 19451[G-alpha], 19452[G-alpha], 19453[G-alpha], 19456[G-alpha], 32901[G-alpha], 32902[G-alpha], 32904[G-alpha], 32906[G-alpha], 32908[G-alpha], 32910[G-alpha], 32911[G-alpha], 32915[G-alpha], 32916[G-alpha], 32917[G-alpha] und 32918[G-alpha] ist die „Art der Erkrankung gemäß der Kodierung nach ICD-10-GM" anzugeben.

**Akzeptanzkriterium:**

1. Das Softwaresystem muss vom Anwender bei der Erfassung der o.g. GOPen im Rahmen der Leistungsdokumentation die Angabe eines gültigen „ICD-10-GM-Kodes" (ungleich dem ICD-10-GM-Kodes „Z01.7") mit der „Diagnosesicherheit" fordern.
2. Die Software überträgt mit der Abrechnung für die o.g. Leistungen den vom Anwender angegebenen „ICD-10-GM-Kode" im Feld 6001 und die „Diagnosensicherheit" im Feld 6003.

---

### Tabelle 8 - Abrechnungsbegründungen bei Berechnung genetischer Untersuchungen

Übersicht zu den Anforderungen KP2-612 bis KP2-618:

| GOP | Art der Erkrankung | HGNC-Gensymbol | ICD-10-GM-Kode | Funktion |
|---|---|---|---|---|
| 11233 | jeweils genau eine Angabe | Keine Übertragung | Keine Besonderheit | KP2-612 |
| 11511, 11512, 11516, 11517, 11518, 11521 | jeweils genau eine Angabe | jeweils genau eine Angabe | Keine Besonderheit | KP2-613 |
| 11513, 11522 | mindestens eine Angabe | mindestens eine Angabe | Keine Besonderheit | KP2-614 |
| 19424, 19453, 19456 | optionale Angabe | mindestens eine Angabe | mindestens eine Angabe eines gültigen ICD-10-GM | KP2-615 (KP2-618) |
| 19421, 19451, 19452 | genau eine optionale Angabe | jeweils genau eine Angabe | mindestens eine Angabe eines gültigen ICD-10-GM | KP2-616 (KP2-618) |
| 11302, 11303, 19402, 32901, 32902, 32904, 32906, 32908, 32910, 32911, 32915, 32916, 32917, 32918 | Keine Übertragung | Keine Übertragung | mindestens eine Angabe eines gültigen ICD-10-GM | KP2-617 (KP2-618) |

---

## 2.3.7.4 Abrechnungsbegründungen bei Berechnung von Besuchen

### KP2-625 - Abrechnungsbegründungen bei Berechnung von Besuchen außerhalb der Arztpraxis
**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software ermöglicht dem Anwender die Erfassung von Abrechnungsbegründungen im Rahmen der Leistungsdokumentation von Besuchen außerhalb der Arztpraxis.

**Begründung:**

Bei einem (Haus-)Besuch eines Versicherten durch den Anwender ist die Abrechnung von zusätzlichem „Wegegeld" möglich.

Um „Wegegeld" vergütet zu bekommen, ist entweder die Angabe einer Zone, der einfachen Entfernung in Kilometern oder des Besuchsortes bzw. die Angabe einer KV-spezifischen Gebührennummer im Rahmen der Abrechnung durch den Anwender erforderlich.

Konkret obliegt dies der Regelungshoheit der Kassenärztlichen Vereinigungen.

**Akzeptanzkriterium:**

1. Die Software stellt dem Anwender entsprechende Eingabefelder zur Erfassung der Informationen bei Besuchen außerhalb der Arztpraxis zur Verfügung. Diese sind:

### Tabelle 9 - Abrechnungsbegründungen bei Berechnung von Besuchen

| Bezeichnung | ADT-Feldkennung |
|---|---|
| Doppelkilometer (DKM) | 5008 |
| Besuchsort bei Hausbesuchen | 5017 |
| Zone bei Besuchen | 5018 |

2. Die Software überträgt die vom Anwender erfassten Angaben gemäß Tabelle 9 im Rahmen der Abrechnung.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

## 2.3.7.5 Leistungskette

### K2-620 - Leistungskette
**Typ:** OPTIONALE FUNKTION ADT

Der Einsatz von Leistungsketten zum Zwecke der Abrechnung ist unter folgenden Bedingungen zulässig:

Jede GNR einer Kette kann erst **nach Einzelquittierung** durch den Anwender in die Abrechnung übernommen werden. Dies gilt für alle Formen der Dateneingabe (z. B. Beleglesung, Digitalisierbrett, Tastatur, Scanner) bzw. auch bei der programmierten Beregelung.

**Eine Leistungskette liegt vor,**

- wenn mit einer Aktion der Leistungsdokumentation eines Patienten mehrere GNRn zugewiesen werden können;
- wenn mit einer Aktion mehrerer Patienten-Leistungsdokumentationen eine oder mehrere GNRn zugewiesen werden können.

**Ausnahme:**

Hiervon ausgenommen sind die Pflichtfunktion(en) P50-01, P50-02 und P50-03 des Anforderungskataloges [KBV_ITA_VGEX_Anforderungskatalog_eArztbrief].

**Anmerkung für Einsendepraxen:**

Eine Einzelquittierung von Leistungen einer Leistungskette bei Einsendepraxen ist dann erbracht, wenn die abzurechnende Gebührennummer durch ein abrechnungsrelevantes Resultat belegt wird.

Abrechnungsrelevante Resultate sind:

- manuell erfasste oder online eingespeiste Messwerte,
- manuell erfasste oder zu bestätigende vordefinierte Ergebnisse in Textform,
- manuell erfasste oder zu bestätigende vordefinierte abrechnungssteuernde Zeichen als Bestätigung einer erbrachten Leistung.

---

## 2.3.7.6 Tagtrennung

### P2-630 - Tagtrennung
**Typ:** PFLICHTFUNKTION ADT

Folgen nach einem ersten Arzt-Patientenkontakt an demselben Behandlungstag weitere Arzt-Patientenkontakte, entscheidet der Anwender nach den Bestimmungen des EBM, ob eine **Tagtrennung** durchzuführen ist.

Für die Funktion „Tagtrennung" gilt:

1. Eine automatische „Tagtrennung" durch das Abrechnungssystem ist **nicht** zulässig, vielmehr muss das Abrechnungssystem dem Anwender eine explizite Funktion „TAGTRENNUNG" anbieten.
2. Wird eine Tagtrennung durchgeführt, muss ein weiterer Behandlungstag mit demselben Datum (FK 5000) und allen im Rahmen dieses Arzt-Patientenkontaktes erbrachten Gebührennummern übertragen werden.
3. Wird eine Tagtrennung durchgeführt, so muss das Abrechnungssystem sicherstellen, dass
   a) für die **erste** GNR des **ersten** Arzt-Patientenkontaktes eine Uhrzeit (FK 5006) nachgetragen werden kann,
   b) für **weitere** Arzt-Patientenkontakte die Angabe einer Uhrzeit (FK 5006) zur jeweils **ersten** GNR erfolgen **muss**.
4. Wird die über die KV-Spezifika-Stammdatei definierte KV-spezifische Vorgabe zu Punkt 3.a) zur Tagtrennung vom Anwender nicht beachtet, so muss ein **Warnhinweis** ausgegeben werden.
5. Wird die Vorgabe zu Punkt 3.b) zur Tagtrennung vom Anwender nicht beachtet, muss eine **Fehlermeldung** ausgegeben werden.

> **Beispielhafter Auszug aus einem Datensatz:**
>
> - ... **5000**  20160106  Behandlungstag
> - **... 5001**  **01210** erste GNR des ersten Arzt-Patientenkontaktes
> - ... 5006  1100 Uhrzeitangabe
> - ...5098  ...
> - ...5099  ...
> - ... 5001  ...
> - ... 5005  ...
> - ...5098  ...
> - ...5099  ...
> - ... **5000**  20160106  Behandlungstag
> - **... 5001**  **01214**  erste GNR des zweiten Arzt-Patientenkontaktes
> - ... 5006  1300 Uhrzeitangabe
> - ...5098  ...
> - ...5099  ...
> - ... 5001  ...
> - ...5098  ...
> - ...5099  ...
> - ... **5000**  20160106  Behandlungstag
> - **... 5001**  **01214**  erste GNR des dritten Arzt-Patientenkontaktes
> - ... 5006  1800 Uhrzeitangabe
> - ...5098  ...
> - ...5099  ...
> - ... 5001  ...
> - ...5098  ...
> - ...5099  ...
> - ...

---

## 2.3.7.7 Leistungskennzeichnung

### P2-641 - Kennzeichnung von Leistungen
**Typ:** PFLICHTFUNKTION ADT

Die Software muss dem Anwender die Kennzeichnung von GOPen im Rahmen der Leistungsdokumentation mit einer „(Neben-) Betriebsstättennummer des Ortes der Leistungserbringung" (BSNR) und mit einer „Lebenslangen Arztnummer des Leistungserbringers" (LANR) ermöglichen.

**Begründung:**

In Umsetzung des Vertragsarztrechtsänderungsgesetzes muss jede abgerechnete Leistung mit der „(Neben-) Betriebsstättennummer des Ortes der Leistungserbringung" und der „Lebenslangen Arztnummer des Leistungserbringers" gekennzeichnet werden.

Im Rahmen der ASV-Abrechnung durch Krankenhausärzte kann die Arzt-Kennzeichnung mit einer „Pseudo-LANR für Krankenhausärzte" erfolgen, vgl. § 2 Nr. 25 ASV-AV i. V. m. Anlage 3 ASV-AV.

**Akzeptanzkriterium:**

1. Die Software muss dem Anwender ermöglichen die GOPen, die im Rahmen der Leistungsdokumentation erfasst wurden, mit einer Betriebsstättennummer und einer Lebenslangen Arztnummer zu kennzeichnen.
2. Die Software überträgt mit der Abrechnung die zur GOP angegebene (Neben-) Betriebsstättennummer in Feld FK 5098 und die LANR in Feld FK 5099 oder die Pseudo-LANR in Feld 5101.

---

## 2.3.7.8 Beregelung

### K2-650 - Programmierte Beregelung
**Typ:** OPTIONALE FUNKTION ADT

Abrechnungsbestimmungen die Gebührenordnung dürfen programmiertechnisch umgesetzt werden (z. B. Nicht-Nebeneinander-Berechnung von Positionen, u. ä.). Als systemseitige Reaktion auf erkannte Fehler dürfen:

1. Fehlermeldungen ausgegeben werden,
2. fehlerhaft angesetzte GNR eliminiert werden,
3. GNRn im Rahmen der programmierten Beregelung automatisch ersetzt oder hinzugefügt werden. Dabei sind die Vorgaben für die Handhabung von Leistungsketten zu beachten.

Der abrechnende Arzt trägt stets die Verantwortung für die korrekte Anwendung der Gebührenordnung.

---

## 2.3.7.9 Chargennummer / GOP

### KP2-651 - Übertragung der Chargennummer bei Schutzimpfungen gegen SARS-CoV-2
**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Bei der Übermittlung der GOPen für die Erbringung einer Schutzimpfung gegen SARS-CoV-2 muss zu jeder erbrachten GOP die Chargennummer für Impfdosis erfasst und übermittelt werden.

**Begründung:**

Gemäß § 13 Abs. 5 Nr. 10 Infektionsschutzgesetz - IfSG muss zu jeder Schutzimpfung gegen SARS-CoV-2 die Chargennummer von den Kassenärztlichen Vereinigung an das Robert Koch-Institut übermittelt werden.

**Akzeptanzkriterium:**

1. Das Softwaresystem muss vom Anwender bei der Erfassung einer GOP (in FK 5001) im Rahmen der Leistungsdokumentation die Angabe der „Chargennummer" (FK 5010) fordern, wenn zu der GOP in der EBM-Stammdatei `../gnr_zusatzangaben/gnr_zusatzangaben_liste/gnr_zusatzangabe/@V="5010"` hinterlegt ist.
2. Das Softwaresystem muss dem Anwender die Erfassung der „Chargennummer" (FK 5010) auch bei nicht unter Akzeptanzkriterium 1 genannten GOPen (in FK 5001) ermöglichen.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

**Hinweis:**

Softwaresysteme können ihre Anwender bei der Erfassung von Chargennummern durch geeignete Maßnahmen wie bspw. Einscannen von Etiketten, Barcodes oder die mehrfache Verwendung von erfassten Chargennummern unterstützen.

---

## 2.3.7.10 Implantateregister

### KP2-652 - Erfassung und Übertragung der Information zum Implantateregister nach erfolgreicher Eintragung eines eingesetzten Implantats im Implantateregister des BMGs
**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software muss es dem Anwender ermöglichen, zu einem eingesetzten Implantat die Mel-de-ID, den „Hash-String" sowie den „Hash-Wert" der Meldebestätigung des Implantateregisters nach erfolgreicher Eintragung im Implantateregister leistungsbezogen in der Abrechnung zu übertragen.

**Begründung:**

Im Implantateregistergesetz (IRegG) sowie in der Implantateregister-Betriebsverordnung (IRe-gBV) ist festgelegt, dass Gesundheitseinrichtungen nach einer implantatbezogenen Maßnahme dem Implantateregister die Daten übermitteln müssen. Die Arztpraxen müssen als Nach-weis für diese Meldung in der Abrechnung die Melde-ID, den „Hash-String" sowie den „Hash-Wert" der Meldebestätigung des Implantateregisters übertragen.

**Akzeptanzkriterium:**

1. Die Software muss dem Anwender die Möglichkeit bieten, eine oder mehrere „Melde-IDs" inkl. des jeweiligen „Hash-Strings" und „Hash-Wertes" aus der Meldebestätigung des Implantateregisters leistungsbezogen zu erfassen.
2. Das Softwaresystem muss vom Anwender bei der Erfassung einer GOP (in FK 5001) im Rahmen der Leistungsdokumentation die Angabe der „Melde-ID Implantateregister" (FK 5050) fordern, wenn zu der GOP in der EBM-Stammdatei `../gnr_zusatzangaben/gnr_zusatzangaben_liste/gnr_zusatzangabe/@V="5050"` hinterlegt ist.
3. Das Softwaresystem muss vom Anwender bei der Erfassung einer GOP (in FK 5001) im Rahmen der Leistungsdokumentation die Angabe des „Hash-Strings Implantateregister" (FK 5051) fordern, wenn zu der GOP in der EBM-Stammdatei `../gnr_zusatzangaben/gnr_zusatzangaben_liste/gnr_zusatzangabe/@V="5051"` hinterlegt ist.
4. Das Softwaresystem muss vom Anwender bei der Erfassung einer GOP (in FK 5001) im Rahmen der Leistungsdokumentation die Angabe des „Hash-Wertes Implantateregister" (FK 5052) fordern, wenn zu der GOP in der EBM-Stammdatei `../gnr_zusatzangaben/gnr_zusatzangaben_liste/gnr_zusatzangabe/@V="5052"` hinterlegt ist.
5. Die Software kann die Anwender ergänzend zu Akzeptanzkriterium 1 und unter Berücksichtigung der Akzeptanzkriterien 2, 3 und 4 bei der Erfassung dahingehend unterstützen, dass sie die „Melde-IDs" inkl. des jeweiligen „Hash-Strings" und „Hash-Werte" nach der Meldung einer implantatbezogenen Maßnahme aus der Meldebestätigung des Implantateregisters automatisch in die Felder „Melde-ID Implantateregister" (FK 5050), „Hash-String Implantateregister" (FK 5051) und „Hash-Wert Implantateregister" (FK 5052) übernimmt.
   a) Wenn eine automatische Erfassung erfolgt, dann kann die Software die manuelle Anpassung der automatisch übernommenen Werte unterbinden.
6. Die Software überträgt die „Melde-ID der Meldebestätigung des Implantateregisters" in der Abrechnung in der Feldkennung 5050.
   a) Wenn der Anwender mehr als eine Melde-ID erfasst, dann überträgt die Software jede Melde-ID in einer separaten Feldkennung 5050 in der Abrechnung.
   b) Die Software stellt sicher, dass zu jeder Melde-ID (FK 5050) auch die Kindelemente „Hash-String Implantateregister" (FK 5051) und „Hash-Wert Implantateregister" (FK 5052) übertragen werden.
7. Die Software überträgt den „Hash-String der Meldebestätigung des Implantateregisters" in der Abrechnung in der Feldkennung 5051.
8. Die Software überträgt den „Hash-Wert der Meldebestätigung des Implantateregisters" in der Abrechnung in der Feldkennung 5052.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

**Hinweis:**

Unter [BMG_Implantatenregister_Spezifikation] sind die technischen Informationen zur Anbindung an das Implantateregister veröffentlicht.

Sofern ab dem ersten Quartal 2025 Nachzüglerfälle aus dem Jahr 2023/2024 abgerechnet werden sollen und dafür die Übertragung der Daten des Implantateregisters fachlich notwendig ist, müssen die Daten in der ab dem ersten Quartal 2025 gültigen Struktur übertragen werden.

---

# 2.3.8 Card für Privatversicherte

### P2-790 - PKV-Card -- Ausschluss für die GKV-Abrechnung
**Typ:** PFLICHTFUNKTION ADT

1. Unmittelbar nach dem Einlesen einer „Card für Privatversicherte" muss systemseitig ein Hinweis erfolgen, dass eine Privatversicherung vorliegt.
2. Die eingelesenen Daten einer „Card für Privatversicherte" dürfen nicht in die Verarbeitungsroutinen zur KVDT-Abrechnung einfließen.

**Hinweis:**

Eine PKV-Card ist bei den KVK-Speicherkarten an den mit Nullen gefüllten Datenfeldern für die VKNR und das IK erkennbar.

Eine PKV-Card ist bei einer eGK am Inhalt des Informationselements Version_XML des Containers EF.StatusVD erkennbar [gematik Speicherstrukturen der eGK für die Fachanwendung VSDM], dass die Versichertenstammdaten-Schema-Version enthält.

---

## Tabelle 10 - Orientierungswerte in Cent

> Hinweis: Diese Tabelle gehört zu Anforderung P2-830 (Arztgruppenspezifischer Punktwert) aus Abschnitt 2.3.9 Patientenquittung, wird aber hier referenziert, da sie für die Bewertung von Leistungen relevant ist.

| Orientierungswert in Cent | gültig ab |
|---|---|
| 3,5048 | 01.01.2012 |
| 3,5363 | 01.01.2013 |
| 10 | 01.10.2013 |
| 10,13 | 01.01.2014 |
| 10,2718 | 01.01.2015 |
| 10,4631 | 01.01.2016 |
| 10,5300 | 01.01.2017 |
| 10,6543 | 01.01.2018 |
| 10,8226 | 01.01.2019 |
| 10,9871 | 01.01.2020 |
| 11,1244 | 01.01.2021 |
| 11,2662 | 01.01.2022 |
| 11,4915 | 01.01.2023 |
| 11,9339 | 01.01.2024 |
| 12,3934 | 01.01.2025 |
| 12,7404 | 01.01.2026 |
