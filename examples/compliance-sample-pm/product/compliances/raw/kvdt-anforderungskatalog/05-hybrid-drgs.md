# 5 Abrechnung von Hybrid-DRGs

> Quelle: KBV_ITA_VGEX_Anforderungskatalog_KVDT, Version 6.06, 9. Marz 2026, Seiten 138-143

Die Verordnung zu einer speziellen sektorengleichen Vergutung (Hybrid-DRG-V) des Bundesministeriums fur Gesundheit (BMG) wurde Ende 2023 veroffentlicht und zum 1. Januar 2024 in Kraft gesetzt.

Die Software setzt mindestens die genannten ADT-Anforderungen fur die Abrechnung von Hybrid-DRGs um:

#### Tabelle 16 -- ADT-Anforderungen fur die Abrechnung von Hybrid-DRGs

| Anforderungsnummer | Anforderungsname | Bemerkung |
|---|---|---|
| P2-05 | Anforderungskatalog zur Anwendung der ICD-10-GM | Ausnahmen siehe KP8-02 |
| P2-20 | Systemdatum | |
| P2-30 | Vordatieren | |
| P2-40 | Ersatzwerte | |
| P2-51 | Benutzer-/Rechteverwaltung | |
| P2-95 | Speicherort der verschlusselten Abrechnungsdatei | |
| P2-98 | Erfassung von Datumsangaben (Felder mit Feldtyp "d" und FKen 4125/4233) | |
| Alle Anforderungen des Kapitels 2.2.1 | | Ausgenommen sind die Vorgaben des Kapitels 2.2.1.11 |
| Alle Anforderungen der Kapitel 2.2.2 & 2.2.3 & 2.2.4 & 2.2.5 & 2.2.6 | | |
| Alle Anforderungen des Kapitels 2.3.9 Patientenquittung | | Anstatt der in den Anforderungen definierten EBM-Ziffern, muss im Zusammenhang mit Hybrid-DRG Leistungen die verfugbaren Information gemass der Stammdatei SDHDRG verwendet werden. |
| P5-10 | Einsatzpflicht des KVDT-Prufmoduls und KBV-Kryptomoduls | |
| P5-30 | Zugang zur unverschlusselten Abrechnungsdatei | |
| Alle Anforderungen des Kapitels 7.1 | | |
| Alle Anforderungen des Kapitels 7.6 | | |

---

### KP8-01 -- Unterstutzung der Satzart HDRG der KVDT-Datensatzbeschreibung

**Typ:** KONDITIONALE PFLICHTFUNKTION HYBRID-DRG

Die Software unterstutzt die Eingabe/Befullung der in der Satzart HDRG definierten Datenfelder gemass der definierten Struktur.

**Begrundung:**

Die Software muss dem Anwender die Moglichkeit bieten, eine Datei zur Abrechnung zu erzeugen, welche den Vorgaben der Satzart HDRG entspricht.

**Akzeptanzkriterium:**

1. Die Software unterstutzt die handische Eingabe, der in der Satzart HDRG definierten Felder bzw. deren automatische Befullung, sofern Datenfelder automatisch befullt (z.B. Ubernahme von Daten aus eingelesen Karten oder durch Ubernahme aus Stammdaten) werden konnen.
   a) Die Einhaltung der Regeln und Kardinalitaten wird von der Software sichergestellt.

**Bedingung:**

Umsetzung der Abrechnung von Hybrid-DRGs gemass der Satzart HDRG.

---

### KP8-02 -- Verschlusselung von Haupt-/ und Nebendiagnose

**Typ:** KONDITIONALE PFLICHTFUNKTION HYBRID-DRG

Die Software muss sicherstellen, dass bei der Eingabe/Auswahl der ICD-10-GM-Kodes der Hauptdiagnose (FK 6009) und/ oder der Nebendiagnose (FK 6011) zur Abrechnung von Hybrid-DRG nur endstandige ICD-10-GM-Kodes verwendet werden. Des Weiteren muss mindestens ein Primarcode verwendet werden.

**Begrundung:**

Gemass Verschlusselungsanleitung der ICD-10-GM ist so spezifisch wie moglich zu kodieren. Dabei sind die endstandigen (terminalen) Schlusselnummern der ICD-10-GM zu verwenden. Eine Ausnahme gibt es fur die Kodierung im Zusammenhang mit den Hybrid-DRG nicht.

Gemass Verschlusselungsanleitung der ICD-10-GM und den Deutschen Kodierrichtlinien (DKR) (D012 Mehrfachkodierung) mussen Sekundarkodes mit den sog. Primarcodes kombiniert werden und konnen nicht alleinstehen.

**Akzeptanzkriterium:**

1. Die Software stellt sicher, dass der eingegebene ICD-10-GM-Kode fur die Hauptdiagnose (6009) und/oder Nebendiagnose(n) (6011) in der ICD-10-GM-Stammdatei [SDICD] (das XML-Element `../diagnosen_liste/diagnose/icd-code/@V`) existiert.
2. Die Software stellt sicher, dass bei der kodierten Hauptdiagnose und/oder Nebendiagnosen mindestens ein Primarcode angegeben wird. Falls ausschliesslich ICD-Kodes mit den Notationskennzeichen (\*) oder (!) (sog. Sekundarkodes) vorliegen, muss die Software folgendes sicherstellen:
   a) Erzeugen eines Hinweises, dass die Angabe eines Primarcodes erforderlich ist.
   b) Unterbinden der Ubertragung der ausschliesslichen Sekundarkodes in die Abrechnungsdatei.
3. Die Software stellt sicher, dass der ICD-10-GM-Kode nicht mit einem "-" endet. Falls ein ICD-10-GM-Kode mit "-" endet, muss die Software folgendes sicherstellen:
   a) Erzeugen eines Hinweises, aus dem hervorgeht, dass der ICD-10-GM-Kode nicht endstandig ist und daher nicht zur Abrechnung verwendet werden darf.
   b) Unterbinden einer Ubertragung des nicht endstandigen ICD-10-GM-Kodes in die Abrechnungsdatei.

**Bedingung:**

Umsetzung der Abrechnung von Hybrid-DRGs gemass der Satzart HDRG.

---

### KP8-03 -- OP-Schlussel bei Hybrid-DRG Leistungen

**Typ:** KONDITIONALE PFLICHTFUNKTION HYBRID-DRG

Die Software muss sicherstellen, dass zu jedem Hybrid-DRG ein Operationen-Schlussel gemass der OPS-Stammdatei ubertragen wird.

**Begrundung:**

Hybrid-DRG Leistungen mussen immer mit einem offiziellen OPS-Schlussel kodiert sein.

**Akzeptanzkriterium:**

1. Die Software stellt sicher, dass zu jeder Hybrid-DRG Leistung (FK 5027) mindestens ein OPS-Kode in der FK 5035 ubertragen wird.
2. Die Software muss fur den eingegebenen OPS-Kode folgendes sicherstellen:
   a) der OPS-Kodes muss in OPS-Stammdatei (XML-Element `../opscode_liste/opscode/@V`) existieren
   b) der OPS-Kode muss noch gultig sein (Datum liegt nicht vor oder nach dem Gultigkeitszeitraum des XML-Elements `../opscode_liste/opscode/gueltigkeit/@V`)
   c) Falls der eingegebene OPS-Kode in der Stammdatei mit einer Seitenlokalisation definiert (`../opscode_liste/opscode/kzseite/@V="J"`), ist, muss das System vom Anwender die Angabe der Seitenlokalisation fordern.
      i. Dabei muss das System dem Anwender die entsprechenden Seitenlokalisationen zur Auswahl vorschlagen.
      ii. Das System ubertragt die Angabe der Seitenlokalisation in der FK 5041.

**Bedingung:**

Umsetzung der Abrechnung von Hybrid-DRGs gemass der Satzart HDRG.

---

### KP8-04 -- Unterstutzung des Exportes der Abrechnungsdatei

**Typ:** KONDITIONALE PFLICHTFUNKTION HYBRID-DRG

Die Software bietet dem Anwender die Moglichkeit, jederzeit eine Abrechnungsdatei zur Abrechnung von Hybrid-DRG zu erzeugen.

**Begrundung:**

Die Abrechnung der Hybrid-DRG ist nicht an den Quartalsbezug gekoppelt und muss daher zu einem beliebigen Zeitpunkt moglich sein.

**Akzeptanzkriterium:**

1. Die Software bietet dem Anwender die Moglichkeit, jederzeit eine Abrechnungsdatei zu erstellen.
   a) Der Anwender hat die Moglichkeit auszuwahlen, welche Hybrid-DRG Abrechnungsfalle in der Abrechnungsdatei enthalten sein sollen.
   b) Die Software pruft die erzeugte Abrechnungsdaten (Satzart Hybrid-DRG) gegen das stets aktuelle KVDT-Prufmodul.
      i. Nach erfolgreicher Prufung verschlusselt die Software die Abrechnungsdatei (Hybrid-DRG) mit dem Modus "Hybrid-DRG" des XKM in der stets aktuellen Version und dem stets aktuellen Schlussel.

      **Hinweis:** Alternativ zum Prufmodul und dem XKM kann auch der Prufassistent eingesetzt werden.

   c) Die Software markiert die abgerechneten Abrechnungsfalle entsprechend in der Software.
2. Der Anwender muss die Moglichkeit haben, sich den Pfad der erzeugten Abrechnungsdatei anzeigen zu lassen.

**Bedingung:**

Umsetzung der Abrechnung von Hybrid-DRGs gemass der Satzart HDRG.

---

### KP8-05 -- 1ClickAbrechnung fur Hybrid-DRGs auf Basis von KIM

**Typ:** KONDITIONALE PFLICHTFUNKTION HYBRID-DRG

Die Software muss dem Anwender eine Funktion zur Ubertragung der Hybrid-DRG Abrechnung auf Basis von KIM bereitstellen.

**Begrundung:**

Mit der Abrechnung des ersten Quartals 2025 kann 1ClickHybridDRG uber KIM zur Ubermittlung der Hybrid-DRG Abrechnung verwendet werden, sofern die jeweilige Kassenarztliche Vereinigung das Verfahren unterstutzt.

**Akzeptanzkriterium:**

1. Die Software stellt dem Anwender zur Abrechnung von Hybrid-DRG Leistungen die Funktionen gemass des folgenden Anforderungsdokumentes bereit:
   a) "1ClickHybridDRG" in der stets aktuellen Version [Spezifikation_1ClickHybridDRG]

**Bedingung:**

Umsetzung der Abrechnung von Hybrid-DRGs gemass der Satzart HDRG.

---

### K8-06 -- Einbindung der Stammdatei Hybrid-DRG

**Typ:** OPTIONALE PFLICHTFUNKTION HYBRID-DRG

In der Software mussen die Daten der gultigen Hybrid-DRG-Stammdatei der KBV zur Verwendung hinterlegt sein.

**Begrundung:**

Um Praxen bei der Abrechnung von Hybrid-DRG Leistungen zu unterstutzen, konnen Softwaresysteme die Daten der Stammdatei Hybrid-DRG (SDHDRG) einbinden. Die SDHRG bildet die Daten der Anlagen 1 und 2 der Hybrid-DRG-Vergutungsvereinbarung ab.

Es gilt zu beachten, dass mit den Daten der SDHDRG nicht die Funktionen eines Groupers ersetzt werden konnen.

**Akzeptanzkriterium:**

1. Die Stammdatei Hybrid-DRG gemass [KBV_ITA_VGEX_Schnittstelle_SDHDRG] ist in der Software eingebunden und wird in der gultigen Version verwendet.
   a) Die Software pruft, ob die in der FK 5027 angegebene Hybrid-DRG als Inhalt des XML-Elementes `.../leistungsbereich/hybrid_drg_liste/hybrid_drg/@V` in der aktuellen Stammdatei vorhanden ist.
      i. Falls die vom Anwender eingegebene Hybrid-DRG in der Stammdatei nicht vorhanden ist, muss die Software dem Anwender mit einer Warnung darauf hinweisen.
   b) Die Software kann dem Anwender auf Basis der Stammdatei weitere Hilfestellung anbieten.
   c) Die Software muss sicherstellen, dass die jeweils fur einen Zeitpunkt aktuelle ausgelieferte SDHDRG in der Software zur Verfugung steht.
   d) Die Software muss dem Anwender die Moglichkeit bieten, sich den Gultigkeitsstand der eingebundenen Stammdatei anzeigen zu lassen.
2. Die Software muss dem Anwender die Moglichkeit bieten sich die Daten gemass der SDHRG anzeigen zulassen.

---

### KP8-07 -- Hinweis zum Feld "Beatmungsstunden" (FK 5030)

**Typ:** KONDITIONALE PFLICHTFUNKTION HYBRID-DRG

Die Software muss den Anwender daruber informieren, dass Leistungen nicht als Hybrid-DRG-Leistung vergutet werden, sofern im Feld 5030 (Beatmungsstunden) ein Wert grosser "0" in die Abrechnungsdatei ubertragen wird.

**Begrundung:**

Leistungen, die Beatmungsstunden enthalten, werden nicht in eine Hybrid-DRG gruppiert, da es sich in den Fallen um eine DRG-Leistung handelt. Somit konnen solche Leistungen nicht als Hybrid-DRG abgerechnet und vergutet werden.

**Akzeptanzkriterium:**

1. Falls bei der Erfassung von Hybrid-DRG-Leistungen der Anwender einen Wert > "0" in das Feld 5030 (Beatmungsstunden) eintragt, muss die Software auf folgende Punkte in Form einer Warnmeldung hinweisen:
   a) Hybrid-DRG-Leistungen, die Beatmungsstunden beinhalten, werden nicht als Hybrid-DRG-Leistung vergutet, weil in dem Fall keine Hybrid-DRG vorliegt.
   b) Beatmungszeiten, die wahrend einer Narkose anfallen, sind nicht in der Abrechnung anzugeben.

**Bedingung:**

Umsetzung der Abrechnung von Hybrid-DRGs gemass der Satzart HDRG.

---

### KP8-08 -- Hinweis zu den Feldern "Datum Beginn der Leistung" (FK 5028) und "Datum Ende der Leistung" (FK 5029)

**Typ:** KONDITIONALE PFLICHTFUNKTION HYBRID-DRG

Die Software muss den Anwender daruber informieren, dass Leistungen nicht als Hybrid-DRG-Leistung vergutet werden, sofern der Abstand zwischen dem Datum im Feld 5028 (Datum Beginn der Leistung) und dem Datum im Feld 5029 (Datum Ende der Leistung) grosser als 2 Tage ist.

**Begrundung:**

In der ambulanten Behandlung durfen Beginn- und Enddatum nicht mehr als zwei Tage auseinanderliegen. Sobald der Abstand grosser als zwei Tage ist, erfolgt keine Gruppierung in eine Hybrid-DRG.

**Akzeptanzkriterium:**

1. Falls bei der Erfassung von Hybrid-DRG-Leistungen die Differenz zwischen dem Datum in Feld 5029 (Ende der Leistung) und dem Datum in Feld 5028 (Beginn der Leistung) grosser als 2 ist, muss die Software den Anwender mit einer Warnmeldung darauf hinweisen, dass bei Hybrid-DRG-Leistungen Beginn- und Enddatum nicht mehr als zwei Tage auseinanderliegen durfen.

**Bedingung:**

Umsetzung der Abrechnung von Hybrid-DRGs gemass der Satzart HDRG.

**Hinweis:**

Massgeblich fur die Ermittlung der Verweildauer ist die Zahl der Belegungstage. Belegungstage sind der Aufnahmetag sowie jeder weitere Tag des Krankenhausaufenthalts ohne den Verlegungs- oder Entlassungstag aus dem Krankenhaus; wird ein Patient oder eine Patientin am gleichen Tag aufgenommen und verlegt oder entlassen, gilt dieser Tag als Aufnahmetag.

**Beispiel:**

1. Aufnahme am: 17.02.2026 (FK 5028)
   Entlassung am: 18.02.2026 (FK 5029)
   => es wird keine Warnung angezeigt (Verweildauer = 1 Tag)

2. Aufnahme am: 17.02.2026 (FK 5028)
   Entlassung am: 19.02.2026 (FK 5029)
   => es wird keine Warnung angezeigt (Verweildauer = 2 Tag)

3. Aufnahme am: 17.02.2026 (FK 5028)
   Entlassung am: 20.02.2026 (FK 5029)
   => es wird **eine** Warnung angezeigt (Verweildauer = 3 Tag)
