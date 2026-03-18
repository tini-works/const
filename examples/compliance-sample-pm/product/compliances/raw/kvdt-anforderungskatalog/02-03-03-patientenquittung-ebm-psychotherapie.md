# 2.3.9 -- 2.3.13: Patientenquittung, Besonderheiten EBM, Psychotherapie, Europäische Krankenversicherung, Suche im Patientenstamm

> **Quelle:** KBV_ITA_VGEX_Anforderungskatalog_KVDT, Version 6.06, 9. März 2026, Seiten 97--120

---

## 2.3.9 Patientenquittung

### 2.3.9.1 Anforderungen zur Patientenquittung

Die Einführung einer Patientenquittung wurde im Rahmen des GMG durch die Änderung des § 305 (2) SGBV zum 1.1.2004 durch den Gesetzgeber beschlossen. Die Vertragsärzte sind damit verpflichtet, Patientenquittungen auf Wunsch des Patienten zu erstellen. Zu diesem Zweck wurden patientenverständliche Leistungstexte definiert, die in der EBM-Stammdatei unter dem tag 'quittungstext' zu finden sind. Beachten Sie auch die Vorgaben zum Einsatz der GO-Stammdatei (SDEBM).

---

### P2-820 -- Leistungsaufstellung

**Typ:** PFLICHTFUNKTION ADT

Auf der Patientenquittung werden diejenigen Leistungen aufgeführt, die der Arzt für die **eigene** Abrechnung ansetzt.

**Akzeptanzkriterien:**

1. Auf der Patientenquittung werden diejenigen Leistungen aufgeführt, die der Arzt für die **eigene** Abrechnung ansetzt.
2. Es werden nur die Leistungen auf der Patientenquittung ausgedruckt, die in der SDEBM enthalten und bewertet sind.
3. Auftragsleistungen (Leistungen, die der Arzt "beauftragt", beispielsweise mittels Muster 10A) werden nicht berücksichtigt.
4. Wurden Leistungen mehrfach erbracht, können diese durch einen Multiplikator zur Gebührenziffer gekennzeichnet werden.
5. Falls der Patient das 15. Lebensjahr noch nicht vollendet hat, muss der Anwender die Möglichkeit haben einzelne Leistungen von der Patientenquittung auszuschließen.
   - a) Ein Hinweis zur Unvollständigkeit der Leistungsaufstellung darf auf der Patientenquittung nicht angezeigt werden.

**Hinweis:**

Für den unter Akzeptanzkriterium 5 genannten Personenkreis verstößt in Analogie der Richtlinie der KBV zur Übermittlung und Speicherung von Daten in die ePA [KBV_Richtlinie_§ 75 Abs 1 Nr. Z SGB V] das Unterlassen der Auflistung von Gebührenordnungspositionen in der Patientenquittung nicht gegen vertragsärztliche Pflichten, sofern dem erhebliche therapeutische Gründe entgegenstehen oder soweit gewichtige Anhaltspunkte für die Gefährdung des Wohles eines Kindes oder eines Jugendlichen vorliegen und die Auflistung von Gebührenordnungspositionen den wirksamen Schutz des Kindes oder Jugendlichen in Frage stellen würde.

---

### P2-830 -- Arztgruppenspezifischer Punktwert

**Typ:** PFLICHTFUNKTION ADT

Die Software muss dem Anwender die Erfassung und Verwaltung des Punktwertes zur Berechnung des voraussichtlichen Arzthonorars auf der Patientenquittung ermöglichen.

**Begründung:**

Vertragliche Grundlage ist § 305 (2) SGB V.

Der Punktwert dient als Grundlage zur Berechnung des voraussichtlichen Arzthonorars auf der Patientenquittung gemäß P2-890. Im Normalfall entspricht der Punktwert dem Orientierungswert.

**Akzeptanzkriterien:**

1. Die Software belegt das Erfassungsfeld mit dem aktuell gültigen Orientierungswert als Defaultwert automatisch vor.

#### Tabelle 10 -- Orientierungswerte in Cent

| Orientierungswert in Cent | gültig ab    |
|---------------------------|-------------|
| 3,5048                    | 01.01.2012  |
| 3,5363                    | 01.01.2013  |
| 10                        | 01.10.2013  |
| 10,13                     | 01.01.2014  |
| 10,2718                   | 01.01.2015  |
| 10,4631                   | 01.01.2016  |
| 10,5300                   | 01.01.2017  |
| 10,6543                   | 01.01.2018  |
| 10,8226                   | 01.01.2019  |
| 10,9871                   | 01.01.2020  |
| 11,1244                   | 01.01.2021  |
| 11,2662                   | 01.01.2022  |
| 11,4915                   | 01.01.2023  |
| 11,9339                   | 01.01.2024  |
| 12,3934                   | 01.01.2025  |
| 12,7404                   | 01.01.2026  |

2. Die Software muss es dem Anwender ermöglichen, den Inhalt dieses Feldes zu verändern.

**Hinweis:**

Ist eine GOP nur in Euro bewertet, ist dieser Eurowert zu verwenden.

---

### P2-840 -- Quotierung; Anteil der nicht vergüteten Leistungen in %

**Typ:** PFLICHTFUNKTION ADT

Aufgrund der Regelungen zur Verhinderung der übermäßigen Ausdehnung seiner Tätigkeit bekommt der Arzt in der Regel nur einen Teil der erbrachten Leistungen vergütet. Auch dieser Sachverhalt soll auf der Patientenquittung abgebildet werden können.

**Konfigurierbarkeit:**

Der Arzt kann dazu einen Erfahrungswert aus den letzten Quartalen angeben. Dieser Wert muss vom PVS verwaltet werden und muss bei der Berechnung des Arzthonorars Berücksichtigung finden.

Für den Fall, dass der Arzt keine Quotierung angibt, soll auf der Patientenquittung unterhalb des ersten Absatzes der folgende (Standard-)Text positioniert werden:

1. *"Der untenstehende Betrag für die von mir erbrachten ärztlichen Leistungen wird wegen der Begrenzung der Finanzmittel der Krankenkassen gegebenenfalls nur zum Teil an mich ausbezahlt. Die Bezahlung wird im Nachhinein von der Krankenkasse soweit vermindert, dass das von Ihrer Krankenkasse zur Verfügung gestellte Geld ausreicht."*

Für den Fall, dass der Arzt eine Quote angibt (z.B. 5%), soll auf der Patientenquittung der Textblock (1) durch den folgenden Textblock ersetzt werden; die Quote wird dabei in den Text eingearbeitet (hier: X):

2. *"Der untenstehende Betrag für die von mir erbrachten ärztlichen Leistungen wird wegen der Begrenzung der Finanzmittel der Krankenkassen gegebenenfalls nur zum Teil an mich ausbezahlt. Die Bezahlung wird im Nachhinein von der Krankenkasse um X % vermindert, damit das von Ihrer Krankenkasse zur Verfügung gestellte Geld ausreicht."*

---

### K2-855 -- Editierbarkeit der Erläuterungstexte und Überschriften

**Typ:** OPTIONALE FUNKTION ADT

Grundsätzlich ist es dem Arzt erlaubt, in Teilen von den Standardformulierungen abzuweichen, sofern die PVS eine entsprechende Funktionalität zur Verfügung stellt.

---

### K2-860 -- Tagesbezogene Patientenquittung

**Typ:** OPTIONALE FUNKTION ADT

**Akzeptanzkriterien:**

1. Unmittelbar nach oder während eines Arzt-Patienten-Kontaktes erfolgt eine Leistungsaufstellung der soeben erbrachten Leistungen mittels einer Patientenquittung (tagesbezogen).
2. Diese Leistungsaufstellung kann auch alle bisher im Quartal erbrachten Leistungen kumulieren (scheingebunden).
3. Falls der Patient das 15. Lebensjahr noch nicht vollendet hat, muss der Anwender die Möglichkeit haben einzelne Leistungen von der Patientenquittung auszuschließen.
   - a) Ein Hinweis zur Unvollständigkeit der Leistungsaufstellung darf auf der Patientenquittung nicht angezeigt werden.

**Hinweis:**

Für den unter Akzeptanzkriterium 3 genannten Personenkreis verstößt in Analogie der Richtlinie der KBV zur Übermittlung und Speicherung von Daten in die ePA [KBV_Richtlinie_§ 75 Abs 1 Nr. Z SGB V] das Unterlassen der Auflistung von Gebührenordnungspositionen in der Patientenquittung nicht gegen vertragsärztliche Pflichten, sofern dem erhebliche therapeutische Gründe entgegenstehen oder soweit gewichtige Anhaltspunkte für die Gefährdung des Wohles eines Kindes oder eines Jugendlichen vorliegen und die Auflistung von Gebührenordnungspositionen den wirksamen Schutz des Kindes oder Jugendlichen in Frage stellen würde.

---

### P2-870 -- Quartalsbezogene Patientenquittung

**Typ:** PFLICHTFUNKTION ADT

Falls mit dem Patienten der Versand einer Quartalsquittung vereinbart wird, muss die Software dem Anwender die Möglichkeit zur Kennzeichnung eines Behandlungsfalls für den Quittungsversand bieten. Die Software muss eine Funktionalität anbieten, die den sequenziellen Ausdruck aller gekennzeichneten Quartalsquittungen am Quartalsende automatisiert ermöglicht.

**Hinweis:**

Zur Unterstützung des Praxispersonals kann optimalerweise der Einzug der Versandkosten und der Aufwandspauschale gemäß § 305 Abs. 2 SGB V in Höhe von 1 Euro zuzüglich Versandkosten dokumentiert werden.

---

### P2-880 -- Zeilenlänge der Leistungslegenden

**Typ:** PFLICHTFUNKTION ADT

Aufgrund der Tabellenform ist die Zeilenlänge der Leistungslegenden auf max. 40 Zeichen beschränkt (siehe Abbildung 3).

Ist die Leistungslegende länger als 40 Zeichen, muss ein Zeilenumbruch erfolgen.

---

### P2-890 -- Inhalt und Layout der Patientenquittung

**Typ:** PFLICHTFUNKTION ADT

Eine einheitliche Gestaltung der Patientenquittung wird angestrebt. Folgende Informationen und Layoutvorgaben muss die Patientenquittung realisieren:

#### Tabelle 11 -- Inhalt und Layout der Patientenquittung

| Betreff / Feldname | Erläuterung / Vorgabe / Formel |
|---|---|
| Papierformat | DIN A4 |
| Schriftart | Beliebige Monospace-Schriften |
| Schriftgröße | 12 CPI |
| Zeilenabstand | Einzeilig |
| Adressfeld | Struktur und Position der Patientenadresse nach DIN 5008 |
| Kassenname | Kassenname zur Bedruckung (siehe KTS) |
| Versichertennummer | |
| Absender | Praxisadresse / Arztstempel |
| Ausstellungsdatum | Tagesdatum |
| Betreff | Leistungs- und Kosteninformation |
| Erläuternder Text | Liebe Patientin, lieber Patient, zu Ihrer Information erhalten Sie nachstehend eine Aufstellung über die ärztlichen Leistungen, die für Sie im unten genannten Zeitraum erbracht wurden, und über die Behandlungskosten, die als ärztliches Honorar voraussichtlich geltend gemacht werden können. Die Behandlungskosten sind durch Zahlungen Ihrer Krankenkasse abgegolten. Dies ist keine Rechnung. |
| Text zur Quotierung (Standardtext) | Der untenstehende Betrag für die von mir erbrachten ärztlichen Leistungen wird wegen der Begrenzung der Finanzmittel der Krankenkassen gegebenenfalls nur zum Teil an mich ausbezahlt. Die Bezahlung wird im Nachhinein von der Krankenkasse soweit vermindert, dass das von Ihrer Krankenkasse zur Verfügung gestellte Geld ausreicht. |
| **oder bei Eingabe von X:** | |
| Text zur Quotierung (Quote bekannt) | Der untenstehende Betrag für die von mir erbrachten ärztlichen Leistungen wird wegen der Begrenzung der Finanzmittel der Krankenkassen gegebenenfalls nur zum Teil an mich ausbezahlt. Die Bezahlung wird im Nachhinein von der Krankenkasse um X % vermindert, damit das von Ihrer Krankenkasse zur Verfügung gestellte Geld ausreicht. |
| Behandlungszeitraum | Behandlungsdatum oder Behandlungsquartal |
| Punktwert | (gemäß P2-830) |
| Leistungsaufstellung | In Tabellenform: Tag / GNR / Kurzbeschreibung / Punkte / Honorar. **Ausnahmen:** Bei EBM-Leistungen, bei welchen keine Punkte in der GO-Stammdatei hinterlegt sind, kann der Eintrag in der Spalte Punkte weggelassen oder durch "-" ersetzt werden. Wenn in der Patientenquittung nur EBM-Leistungen enthalten sind, für welche keine Punkte in der GO-Stammdatei hinterlegt sind, kann alternativ auch die folgende Tabellenform verwendet werden: Tag / GNR / Kurzbeschreibung / Honorar |
| Summenzeile | Kosten für ärztliche Leistungen in EUR |
| Erstattung durch Ihre Krankenkasse in EUR | **K * (100% - X)** mit X = Anteil der nicht vergüteten Leistungen, K = Kosten für ärztliche Leistungen in EUR |
| Fußnoten | (siehe Beispiel) |
| Seitennummerierung | Fortlaufend |
| Bei Folgeseiten | Name und Ausstellungsdatum in Kopfzeile |

---

### 2.3.9.2 Muster für eine Patientenquittung

*(Abbildung 3: Patientenquittung, Stand: 2. Quartal 2017)*

Beispiel-Layout:

```
Dr. med. K. Mustermann . Teststraße 3 . 12345 Teststadt

Herrn
Hans Testmann
Teststraße 10
12345 Teststadt

DAK Testkasse Teststadt
Versicherten-Nr.: 123456789012

                                                        15.05.2017
Leistungs- und Kosteninformation

Liebe Patientin, lieber Patient,

zu Ihrer Information erhalten Sie nachstehend eine Aufstellung über die ärztlichen
Leistungen, die für Sie im unten genannten Zeitraum erbracht wurden, und über die
Behandlungskosten, die als ärztliches Honorar voraussichtlich geltend gemacht werden
können. Die Behandlungskosten sind durch Zahlungen Ihrer Krankenkasse abgegolten.
Dies ist keine Rechnung.

Der untenstehende Betrag für die von mir erbrachten ärztlichen Leistungen wird wegen
der Begrenzung der Finanzmittel der Krankenkassen gegebenenfalls nur zum Teil an mich
ausbezahlt. Die Bezahlung wird im Nachhinein von der Krankenkasse um 5 % vermindert,
damit das von Ihrer Krankenkasse zur Verfügung gestellte Geld ausreicht.

Behandlungszeitraum: April bis Juni 2017 (2. Quartal 2017)

Punktwert: 10,53 Cent

Tag          GNR    Kurzbeschreibung                          Punkte  Honorar in EUR
02.05.2017   06211  Behandlungskomplex vom 6. bis zum            127        13,37
                    vollendeten 59. Lebensjahr
             06333  Binokulare Untersuchung des gesamten          51         5,37
                    Augenhintergrundes
15.05.2017   06310  Fortlaufende Tonometrie                       88         9,27

Kosten für ärztliche Leistungen in EUR                                      28,01
                                                                           ======
Erstattung durch Ihre Krankenkasse in EUR                                   26,61
```

---

## 2.3.10 Besonderheiten des aktuell gültigen EBM

### 2.3.10.1 Simultaneingriffe bei Operationsleistungen (Kapitel 31.2 und 36.2)

### K2-900 -- Höchstbewertete Leistung, Gesamt-Schnitt-Naht-Zeit, Zuschläge

**Typ:** OPTIONALE FUNKTION ADT

Bei Simultaneingriffen ist nach den Vorgaben des EBM nur die höchstbewertete Leistung abzurechnen. Weitere Eingriffe werden durch die GSNZ (Gesamt-Schnitt-Naht-Zeit; FK 5037) und durch die Abrechnung von Zeitzuschlägen berücksichtigt.

Die PVS kann dem Arzt **zur Unterstützung** die höchstbewertete Leistung zur Abrechnung anbieten. Die Zeitzuschläge berechnen sich dann aus der Differenz zwischen der GSNZ und der tatsächlichen SNZ des Haupteingriffs.

Für die Abrechnung müssen **beide Angaben**, die GSNZ und die Zuschlagleistung(en), übertragen werden.

**Beispiel:**

Folgende Eingriffe sind vorgenommen worden:

#### Tabelle 12 -- Beispiel Simultaneingriff

| OPS | Kategorie | Kalkulatorische Schnitt-Naht-Zeit [min] | Tatsächliche Schnitt-Naht-Zeit [min] | EBM-Ziffer |
|---|---|---|---|---|
| 5-791.g5 | D4 | 60 | 30 | 31134 |
| 5-791.g8 | D4 | 60 | | 31134 |
| 5-791.gh | D3 | 45 | | 31133 |

Die GSNZ hat beispielsweise 135 min betragen. Abzüglich der SNZ des Haupteingriffes ergeben sich 105 min, die zusätzlich als Zeitzuschläge (7x31138) abgerechnet werden können (7x15min = 105min).

Um zu kennzeichnen, dass es sich um einen Simultaneingriff handelt, sind in der Abrechnung zu der höchstbewerteten Leistung die erfolgten OP-Eingriffe durch die entsprechenden OP-Schlüssel zu dokumentieren, die GSNZ anzugeben und die Anzahl der Zeitzuschläge abzurechnen.

**KVDT-Auszug:**

```
5000...
5001 31134
5035 5-791.g5
5041 L
5035 5-791.g8
5041 R
5035 5-791.gh
5041 B
5037 135
5098 123456789
5099 999999900
5001 31138
5005 7
...
```

---

### 2.3.10.2 Doppelfunktion der OP-Schlüssel als Abrechnungsbegründung und zur Dokumentation nach § 295 SGB V

### KP2-910 -- OP-Schlüssel als Abrechnungsbegründung -- Echtzeitprüfung

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Falls OP-Leistungen der Kapitel 31.2 bzw. 36.2 des EBM als GOP (GOP; FK 5001) erfasst werden, muss das System die Angabe von OP-Schlüsseln (OPS-Code; FK 5035) als Abrechnungsbegründung verlangen.

Für Dokumentationszwecke und auch als Abrechnungsbegründung muss zu den OP-Leistungen des Kapitel 31.2 bzw. 36.2 des EBM i.d.R. die Angabe von OP-Schlüsseln erfolgen.

**Begründung:**

Für Leistungen des ambulanten Operierens gilt per Gesetz seit dem 01.04.2005 der Operationen und Prozedurenschlüssel in der jeweils gültigen Fassung auch für den ambulanten Bereich und muss zu Dokumentations- und Abrechnungszwecken angewendet werden.

**Akzeptanzkriterien:**

Falls in der [EBM-Stammdatei] zu einer GOP unter `.../gnr_zusatzangaben/gnr_zusatzangaben_liste/gnr_zusatzangabe` der Wert `V="5035"` (OP-Schlüssel) hinterlegt ist und der OPS-Code als Begründungstyp ausgewählt wird, muss das System folgendes sicherstellen:

1. Das System muss vom Anwender die Angabe eines OPS-Codes fordern.
2. Das System muss den eingegebenen OPS-Code auf Korrektheit überprüfen und in der Abrechnungsdatei unter der **FK 5035** übertragen.
   - a) Ob ein OPS-Code als Abrechnungsbegründung einer GOP gilt, wird durch die Zuordnung eines OPS-Codes zu einer GOP in der [EBM-Stammdatei] unter `.../begruendungen_liste/ops_liste` determiniert.
   - b) Falls der vom Anwender eingegebene OPS-Code in der [EBM-Stammdatei] mit einer Seitenlokalisation "L" oder "R" definiert ist (unter `.../begruendungen_liste/ops_liste/.../ops/seite`), muss das System vom Anwender die Angabe der Seitenlokalisation fordern. Dabei muss das System dem Anwender die entsprechenden Seitenlokalisationen zur Auswahl vorschlagen. Das System überträgt die Angabe der Seitenlokalisation in der FK 5041.
   - c) Falls der vom Anwender eingegebene OPS-Code in der [EBM-Stammdatei] mit einer Seitenlokalisation "P" definiert ist (unter `.../begruendungen_liste/ops_liste/.../ops/seite`), muss der OPS-Code zweimal (in zwei Feldkennungen FK 5035) automatisch von der Software in der Abrechnung übertragen werden. Dabei muss das System automatisch einmal die Seitenlokalisationen "L" und einmal "R" angeben. Das System überträgt die Angabe der Seitenlokalisation in der FK 5041.
3. Falls keiner vom Anwender erfassten OPS-Codes in der [EBM-Stammdatei] der GOP zugeordnet (vgl. Akzeptanzkriterium 2 a)) ist, muss das System einen entsprechenden Hinweis anzeigen.
   - a) Das System muss eine Übernahme des/der OPS-Codes in die Abrechnungsdatei in FK 5035 nach dem Hinweis trotzdem ermöglichen.
   - b) Falls der OPS-Code 5-983 zusätzlich zu den laut der [EBM-Stammdatei] definierten OPS-Codes für eine Leistungsziffer angegeben wird, muss das System auf die Anzeige eines Hinweises verzichten.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

**Hinweise:**

- Die in der ambulanten vertragsärztlichen Versorgung zur Abrechnung einer Leistung als Abrechnungsbegründung angebbaren OPS-Codes sind in der GOS durch die Hinterlegung der entsprechenden OPS-Codes ersichtlich.
- Bei Simultaneingriffen müssen OPS-Codes für alle erfolgten Eingriffe dokumentiert werden.
- Unbenommen davon sind alle aktuell gültigen OPS-Codes in der OPS-Stammdatei [SDOPS] der KBV bereitgestellt und können von Ärzten grundsätzlich zur Dokumentation und Abrechnung einer Leistung angegeben werden.
- Das Akzeptanzkriterium 2c) findet erst für Behandlungsfälle ab dem 1. Januar 2026 Anwendung.

---

### KP2-912 -- GNR-Begründung als Alternative zum OPS

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Anstelle der Leistungen der Kleinchirurgie, können auch die höherbewerteten Kategorie-1-Leistungen des Kapitels 31.2 bzw. 36.2 abgerechnet werden, wenn diese Leistungen in Narkose bei Kindern bis zum vollendeten 12. Lebensjahr erbracht werden.

Da für die Begründung der Kategorie-1-Leistungen in diesen Fällen kein OPS zugrunde liegt, muss ein Abrechnungssystem sicherstellen, dass diese alternativ mit der GNR der Kleinchirurgie begründet und mittels FK 5036 in die Abrechnung übertragen werden kann.

**Hinweis:**

In der GOS ist dieser Sachverhalt bei den relevanten Kategorie-1-Leistungen durch die Zusatzbedingung "5036" (Begründungs-GNR) abgebildet, wobei die zulässigen Ziffern der Kleinchirurgie, die als Begründung verwendet werden können, unter der Begründungs-Liste aufgeführt sind.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### 2.3.10.3 Erforderlicher ICD-Code

### P2-920 -- ICD-Code als Abrechnungsbegründung

**Typ:** PFLICHTFUNKTION ADT

Sofern zu einer EBM-Leistung die ICD-Klassifikation durch die GO-Stammdatei explizit gefordert wird, muss das Abrechnungssystem bei der Erfassung der Leistung prüfen, ob die geforderte Diagnose in den FK 6001 oder 3673 existiert und ggf. einen Warnhinweis anzeigen, der die geforderten ICD-Codes erwähnt. Wenn keiner der geforderten ICD-Codes eingegeben wird, darf die Eingabe der EBM-Ziffer nicht abgewiesen werden.

**Begründung:**

Um den Anwender bei der Planung und Abrechnung von Leistungen zu unterstützen, die nur bei Begründung durch mindestens eine bestimmte Behandlungsdiagnose berechnungsfähig sind, weist die Software den Anwender bei der Erfassung auf die Liste der begründungsfähigen Diagnosen hin.

**Akzeptanzkriterien:**

1. Falls der Anwender eine EBM-Leistung mit einer Gebührennummer erfasst, zu der in der EBM-Stammdatei eine aktive Liste von begründungsfähigen Diagnosen (SDEBM XML-Element `../gnr/bedingung/begruendungen_liste/icd_liste` mit `../gnr/bedingung/begruendungen_liste/icd_liste/@V='true'`) hinterlegt ist und falls keiner der in der Liste enthaltenen ICD-10-GM-Kodes für die Abrechnungsfelder "ICD-Code" oder "Dauerdiagnose (ICD-Code)" (FK 6001 bzw. 3673) erfasst wird, muss die Abrechnungssoftware dem Anwender einen Warnhinweis mit dem Inhalt dieser Liste anzeigen, dass die Leistung nur bei Begründung durch mindestens einer dieser Behandlungsdiagnosen berechnungsfähig ist.
2. Die Software muss dem Anwender im durch Akzeptanzkriterium 1. beschriebenen Fall die Möglichkeit zur Erfassung der EBM-Leistung geben, falls dieser nicht mindestens einen der ICD-10-GM-Kodes aus der Liste der begründungsfähigen Diagnosen für die Abrechnungsfelder "ICD-Code" oder "Dauerdiagnose (ICD-Code)" (FK 6001 bzw. 3673) erfasst hat.

---

### 2.3.10.4 Überweisung bei Betreuungsleistungen (Kapitel 31.4)

### K2-930 -- OP-Datum und Betreuungsleistung als Auftrag

**Typ:** OPTIONALE FUNKTION ADT

Sollen Betreuungsleistungen per Überweisung erbracht werden, muss für den weiterbehandelnden Arzt das OP-Datum in das vorgesehene Feld (auf dem Überweisungsschein!) und die genaue Leistungsziffer der Betreuungsleistung als Auftrag angegeben werden.

Die PVS kann hierbei unterstützend tätig werden.

---

### 2.3.10.5 Abrechnung von Betreuungsleistungen

### K2-940 -- Abrechnung von Betreuungsleistungen

**Typ:** OPTIONALE FUNKTION ADT

Für die Abrechnung von Betreuungsleistungen aus Kapitel 31.4 gelten folgende Vorgaben:

1. Betreuungsleistungen sind innerhalb von 21 Tagen nur einmal berechnungsfähig.
2. Als Abrechnungsbegründung ist das OP-Datum unter der FK 5034 anzugeben.

---

## 2.3.11 Besonderheiten bei der Psychotherapie

### 2.3.11.1 Angabe von Leistungen

### KP2-941 -- Angaben von Leistungen in einer Psychotherapie

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software muss dem Anwender im Rahmen der Abrechnung von Psychotherapie-Leistungen die Möglichkeit geben, neben den Abrechnungsdaten zusätzliche Daten der Psychotherapie-Leistungen zu übertragen.

**Begründung:**

Der Anwender muss die Möglichkeit haben, die Abrechnungsdaten zu Psychotherapie-Leistungen in den vorgegebenen Feldern zu erfassen und zu übertragen.

**Akzeptanzkriterien:**

1. Der Anwender hat im Rahmen der Abrechnung von Psychotherapie-Leistungen die Möglichkeit die Felder 4234, 4235, 4236, 4247, 4250, 4251, 4252, 4253, 4254, 4255, 4256 und 4257 wie in der [KBV_ITA_VGEX_Datensatzbeschreibung_KVDT] definiert, zu übertragen.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### 2.3.11.2 Kombinationsbehandlung durch zwei Psychotherapeuten

### KP2-942 -- Spezifizierung der Kombinationsbehandlung durch zwei Psychotherapeuten

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software stellt bei einer Kombinationsbehandlung durch zwei Psychotherapeuten im Rahmen der Psychotherapie sicher, dass der Anwender die Kombinationsbehandlung explizit als "Einzeltherapie-Anteil bei Durchführung durch zwei Psychotherapeuten" (FK 4251 = 3) oder als "Gruppentherapie-Anteil bei Durchführung durch zwei Psychotherapeuten" (FK 4251 = 4) spezifiziert.

**Begründung:**

Aufgrund der Änderung von Vorgaben der Anlage 1 des BMV-Ä (Psychotherapie-Vereinbarung) und Überarbeitung des Musters PTV 2, muss der Anwender im Rahmen der Kombinationsbehandlung durch zwei Psychotherapeuten seinen Anteil entweder als "Einzeltherapie-Anteil" oder als "Gruppentherapie-Anteil" bestimmen.

**Akzeptanzkriterien:**

1. Bei der Dokumentation der Kombinationsbehandlung durch zwei Psychotherapeuten muss der Anwender explizit angeben, ob es sich bei seinem Anteil der Kombinationsbehandlung um
   - a) "Einzeltherapie-Anteil bei Durchführung durch zwei Psychotherapeuten" (FK 4251 = 3)
   - b) oder "Gruppentherapie-Anteil bei Durchführung durch zwei Psychotherapeuten" (FK 4251 = 4)
   handelt.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### 2.3.11.3 Kombinationsbehandlung in einer psychotherapeutischen Berufsausübungsgemeinschaft

### KP2-943 -- Kombinationsbehandlung durch zwei Psychotherapeuten in einer psychotherapeutischen Berufsausübungsgemeinschaft

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software stellt sicher, dass bei Kombinationsbehandlung durch zwei Psychotherapeuten in einer psychotherapeutischen Berufsausübungsgemeinschaft das LANR-Feld mit der FK 4299 im Psychotherapie-Informationsblock (ab Feld 4235 bis einschließlich 4257) übertragen wird.

**Begründung:**

Bei der Ausführung einer Kombinationsbehandlung durch zwei Psychotherapeuten in einer psychotherapeutischen Berufsausübungsgemeinschaft kann ohne die explizite Angabe der jeweiligen LANR im Psychotherapie-Informationsblock die Zuordnung der abgerechneten GOPen zu den Psychotherapeuten nicht sichergestellt werden.

**Akzeptanzkriterien:**

1. Bei der Kombinationsbehandlung durch zwei Psychotherapeuten in einer psychotherapeutischen Berufsausübungsgemeinschaft wird das LANR-Feld mit der FK 4299 im Psychotherapie-Informationsblock übertragen.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### 2.3.11.4 Vergütungssystematik der psychotherapeutischen Gruppentherapie

### KP2-944 -- Übertragung der psychotherapeutischen Gruppentherapie

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software stellt sicher, dass bei der Bewilligung einer beantragten Psychotherapie mit den GOPen 3550X, 3551X, 3552X, 3553X, 3554X, 3555X, 3570X und 3571X die jeweiligen tatsächlichen GOPen laut EBM in der Abrechnung in das Feld 4253 (Bewilligte GOP für den Versicherten) bzw. das Feld 4256 (Bewilligte GOP für die Bezugsperson) übernommen werden.

**Begründung:**

Die Höhe der Bewertung richtet sich nach der Anzahl der Teilnehmer. Infolgedessen gibt es für jedes Psychotherapieverfahren als Gruppentherapie jeweils sieben GOPen für die Kurzzeittherapie und sieben GOPen für die Langzeittherapie. Sobald ein Psychotherapieverfahren für die Kurzzeittherapie oder die Langzeittherapie bewilligt wird, sind die dazugehörigen sieben GOPen ebenso bewilligt.

**Akzeptanzkriterien:**

1. Wenn eine Psychotherapie mit den GOPen 3550X, 3551X, 3552X, 3553X, 3554X, 3555X, 3570X oder 3571X beantragt und bewilligt wurde, wird im Rahmen der Abrechnung aus diesen genannten GOPen, durch das Einsetzen der möglichen Teilnehmeranzahl 3, 4, 5, 6, 7, 8 und 9 für die Variable X, jeweils sieben GOPen erstellt, die automatisch im Feld 4253 (Bewilligte GOP für den Versicherten) bzw. im Feld 4256 (Bewilligte GOP für die Bezugsperson) übertragen werden.
2. Der Anwender kann die als Default eingestellte automatische Übernahme deaktivieren.
3. Der Anwender kann manuell aus den möglichen sieben GOPen für das jeweils bewilligte Verfahren die zu übernehmenden GOPen auswählen.
4. Der Anwender hat die Möglichkeit bereits eingetragene GOPen zu bearbeiten (GOP streichen bzw. hinzufügen).

**Beispiel:**

*Szenario 1) Automatische Übernahme der GOPen für das Verfahren **ohne** Anwendereingriff*
- Psychotherapeut beantragt die Gruppenleistung 3550X für den Versicherten.
- Bei der Bewilligung der Gruppenleistung 3550X werden automatisch die GOPen 35503, 35504, 35505, 35506, 35507, 35508 und 35509 im Feld 4253 übertragen.

*Szenario 2) Automatische Übernahme der GOPen für das Verfahren **mit** Anwendereingriff*
- Der Anwender beantragt die Gruppenleistung 3550X für den Versicherten.
- Die Gruppenleistung 3550X für den Versicherten wird bewilligt.
- Der Anwender deaktiviert die als Default eingestellte automatische Übernahme.
- Im Rahmen der Abrechnung werden dem Anwender die möglichen GOPen 35503, 35504, 35505, 35506, 35507, 35508 und 35509 für die bewilligte Gruppenleistung 3550X angezeigt.
- Der Anwender wählt manuell die GOPen 35508 und 35509 aus.
- Die GOPen 35508 und 35509 werden im Feld 4253 übertragen.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### 2.3.11.5 Berechnung Tagesprofil

### K2-947 -- Berechnung Tagesprofil

**Typ:** OPTIONALE FUNKTION ADT

Falls die Software dem Anwender die Möglichkeit bietet Tagesprofile zu erstellen, muss gemäß den Angaben im Anhang 3 des EBM zu den psychotherapeutischen Leistungen 30931[G-alpha], 30932[G-alpha], 35140[G-alpha], 35141[G-alpha], 35150[G-alpha], 35151[G-alpha], 35152[G-alpha], 35401[G-alpha], 35402[G-alpha], 35405[G-alpha], 35411[G-alpha], 35412[G-alpha], 35415[G-alpha], 35421[G-alpha], 35422[G-alpha], 35425[G-alpha], 35431[G-alpha], 35432[G-alpha] und 35435[G-alpha] als Berechnungsgrundlage nicht die Prüfzeit (in Minuten), sondern die Kalkulationszeit (in Minuten) gemäß Anhang 3 zum EBM verwendet werden.

**Begründung:**

Diese Anforderung resultiert aus den Angaben des Anhang 3 des EBM zu den betroffenen psychotherapeutischen Leistungen (vgl. Beschluss des Bewertungsausschusses in seiner 439. Sitzung am 19. Juni 2019 zur Änderung des EBM mit Wirkung zum 1. Juli 2019).

**Akzeptanzkriterien:**

1. Die Software verwendet bei der Erstellung eines Tagesprofils bei den GOPen 30931[G-alpha], 30932[G-alpha], 35140[G-alpha], 35141[G-alpha], 35150[G-alpha], 35151[G-alpha], 35152[G-alpha], 35401[G-alpha], 35402[G-alpha], 35405[G-alpha], 35411[G-alpha], 35412[G-alpha], 35415[G-alpha], 35421[G-alpha], 35422[G-alpha], 35425[G-alpha], 35431[G-alpha], 35432[G-alpha] und 35435[G-alpha] als Prüfzeit die Kalkulationszeit (in Minuten) gemäß Anhang 3 zum EBM.

**Hinweis:**

Für die Erstellung eines Quartalsprofils muss als Berechnungsgrundlage regelgerecht die Prüfzeit zu den o.g. GOPen verwendet werden. In der EBM-Stammdatei ist sowohl die Prüfzeit im Element `//pruefzeit/@V` als auch die Kalkulationszeit im Element `//zeitbedarf_liste/zeit/@V` vorhanden.

---

### 2.3.11.6 Ausdruck der Muster PTV 3 und PTV 10

### KP2-960 -- Aufruf des Musters PTV 3

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software ermöglicht den Aufruf der PDF-Vorlage für Muster "PTV 3" direkt aus dem System.

**Begründung:**

Der Anwender muss die Möglichkeit haben das Dokument über die Software aufzurufen und zu drucken.

**Akzeptanzkriterien:**

1. Der Anwender kann bei Bedarf die PDF-Vorlage des Musters "PTV 3" [EXT_ITA_AHEX_PTV3] direkt aus der Software aufrufen.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### KP2-961 -- Ausdruck des Musters PTV 3

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software ermöglicht den Ausdruck der PDF-Vorlage Muster "PTV 3".

**Begründung:**

Der Anwender muss die Möglichkeit haben das Dokument über die Software aufzurufen und zu drucken.

**Akzeptanzkriterien:**

1. Der Anwender kann die PDF-Vorlage des Musters "PTV 3" [EXT_ITA_AHEX_PTV3] direkt aus dem System drucken.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### KP2-962 -- Aufruf des Musters PTV 10

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software ermöglicht den Aufruf der PDF-Vorlage für Muster "PTV 10" direkt aus dem System.

**Begründung:**

Der Anwender muss die Möglichkeit haben das Dokument über die Software aufzurufen und zu drucken.

**Akzeptanzkriterien:**

1. Der Anwender kann bei Bedarf die PDF-Vorlage des Musters "PTV 10" [EXT_ITA_AHEX_PTV10] direkt aus der Software aufrufen.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### KP2-963 -- Ausdruck des Musters PTV 10

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software ermöglicht den Ausdruck der PDF-Vorlage Muster "PTV 10".

**Begründung:**

Der Anwender muss die Möglichkeit haben das Dokument über die Software aufzurufen und zu drucken.

**Akzeptanzkriterien:**

1. Der Anwender kann die PDF-Vorlage des Musters "PTV 10" [EXT_ITA_AHEX_PTV10] direkt aus dem System drucken.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### 2.3.11.7 Beendigungsmitteilung für Psychotherapie

Gemäß § 17 Absatz 7 Psychotherapie-Vereinbarung ist der Psychotherapeut verpflichtet, die Beendigung der Richtlinientherapie anzuzeigen. Hierzu muss der Anwender die Pseudo-GOPen 88130 oder 88131 über die Quartalsabrechnung übermitteln:

- **Pseudo-GOP 88130:** Kennzeichnung für Beendigung einer Psychotherapie nach § 15 Psychotherapie-Richtlinie **ohne** anschließende Rezidivprophylaxe
- **Pseudo-GOP 88131:** Kennzeichnung für Beendigung einer Psychotherapie nach § 15 Psychotherapie-Richtlinie **mit** anschließender Rezidivprophylaxe.

Die Übermittlung muss nach § 17 Absatz 7 der Psychotherapie-Vereinbarung "unverzüglich", also in dem Quartal erfolgen, in dem das Therapieende liegt. Die Pseudo-GOP muss dem Datum zugeordnet werden, an dem die letzte Therapieeinheit (Stunde) stattgefunden hat.

Kann ein Therapieende noch nicht sicher abgesehen werden, ist eine Übermittlung der Kennzeichnung auch in den zwei darauffolgenden Quartalen zulässig.

Wird eine Psychotherapie länger als 6 Monate unterbrochen ist nach § 17 Absatz 6 Psychotherapie-Vereinbarung weiterhin eine formlose Begründung der Therapiepause an die Krankenkasse erforderlich. Die Übermittlung der Kennzeichnung erfolgt in diesem Fall dann (nach der Wiederaufnahme der Behandlung) mit der regulären Beendigung der Psychotherapie.

**Beispielhafte Behandlungskonstellationen für eine unverzügliche Übermittlung der Kennzeichnung:**

- a) Ein/e Patient/in beendet die Psychotherapie in Absprache mit der/dem Psychotherapeuten/in regulär im 2. Quartal eines Jahres; das Therapiekontingent wird vollständig ausgeschöpft; es wird keine Rezidivprophylaxe vereinbart. --> Übertragung der Pseudo-GOP 88130 mit der Abrechnung für das 2. Quartal.
- b) Ein/e Patient/in beendet die Psychotherapie in Absprache mit der/dem Psychotherapeuten/in regulär im 2. Quartal eines Jahres nach der 55. von 60 bewilligten Stunden; es wird eine Rezidivprophylaxe für die Reststunden vereinbart (Reststunden: 5, können innerhalb von 2 Jahren nach Therapieende durchgeführt werden). --> Übertragung der Pseudo-GOP 88131 mit der Abrechnung für das 2. Quartal dieses Jahres.

**Beispielhafte Behandlungskonstellationen für eine spätere Übermittlung der Kennzeichnung in einem darauffolgenden Quartal:**

- c) Ein/e Patient/in bricht die Psychotherapie ohne Absprache mit der/dem Psychotherapeuten/in kurz vor Ende des 2. Quartals ab, es besteht ein Restkontingent --> Übertragung von 88130 oder 88131 im 3. oder spätestens 4. Quartal dieses Jahres (Für den Fall der Wiederaufnahme der Psychotherapie durch die Patientin / den Patienten erfolgt die Meldung nach regulärer Beendigung wie in Beispiel a).
- d) Ein/e Patient/in beendet die Psychotherapie in Absprache mit der/dem Psychotherapeut/in kurz vor Ende des 2. Quartals, es besteht ein Restkontingent; es wird keine Rezidivprophylaxe, aber die Möglichkeit vereinbart, sich vor dem Ablauf von 6 Monaten zu melden --> Übertragung eines "Pseudo-Behandlungsfalles" mit der GOP der 88130 oder 88131 im 4. Quartal (Für den Fall der Wiederaufnahme der Psychotherapie durch die Patientin / den Patienten erfolgt die Meldung nach regulärer Beendigung wie in Beispiel a).

**Behandlungskonstellationen die *keine* Übermittlung einer Kennzeichnung mittels Pseudo-GOPen 88130 oder 88131 erfordern:**

- e) Eine Rezidivprophylaxe wird beendet --> Weder Übertragung der Pseudo-GOP 88130 noch 88131 mit der Abrechnung erforderlich.
- f) Eine Psychotherapie wird aus demselben Behandlungsanlass weitergeführt bzw. soll weitergeführt werden (z. B. mit Kurzzeittherapie 2 oder mit Langzeittherapie aufgrund eines Umwandlungs- oder Fortführungsantrags) --> Weder Übertragung der Pseudo-GOP 88130 noch 88131 mit der Abrechnung erforderlich. Die Übermittlung erfolgt erst mit der regulären (vollständigen) Beendigung der Psychotherapie.

Die Software soll den Psychotherapeuten auf die Verpflichtung zur Anzeige des "Therapieendes" erinnern, indem sie zu bestimmten Zeitpunkten auf die mögliche Übermittlung einer Kennzeichnung über die Quartalsabrechnung mittels der Pseudo-GOPen 88130 und/oder 88131 hinweist. Die nachfolgende Tabelle 13 gibt eine Übersicht darüber, unter welchen Bedingungen diese Hinweise bzgl. der jeweiligen GOP gegeben werden sollen.

#### Tabelle 13 -- Erinnerungsfunktion: Hinweise auf die Angabe der Pseudo-GOP 88130 bzw. 88131

| Hinweis auf Pseudo-GOP | Anzahl vergangener Quartale ohne APK | Zeitpunkt der Hinweisgabe | Restkontingent vorhanden | Anforderungsfunktion |
|---|---|---|---|---|
| 88130 | * | Leistungserfassung | Nein | KP2-965 |
| 88130 | 0 | Abrechnungserstellung | Nein | KP2-965 |
| 88130 | 1 und 2 | Abrechnungserstellung | Nein | KP2-966 |
| 88130 und 88131 | 2 und mehr | Abrechnungserstellung | Ja | KP2-967 |
| 88131 | * | Leistungserfassung von Rezidivprophylaxe | ** | KP2-968 |
| 88131 | 0 | Abrechnungserstellung | Ja | KP2-970 |
| 88131 | 1 | Abrechnungserstellung | Ja | KP2-971 |

\* Die Anzahl der vergangenen Quartale ohne APK ist für die Erinnerungsfunktion unerheblich, falls die Hinweisgabe während der Leistungserfassung erfolgt.

\*\* Die Höhe des Restkontingents nach der Leistungserfassung ist für die Erinnerungsfunktion gemäß KP2-968 unerheblich.

Diese Erinnerungsfunktion ist allgemein davon abhängig, ob ein Restkontingent besteht, in welchem Quartal der letzte APK stattfand und ob eine Leistung erfasst wurde. Weitere spezifische Bedingungen und Details sind in den Anforderungsfunktionen KP2-965, KP2-966, KP2-967, KP2-968, KP2-970 sowie KP2-971 beschrieben.

---

### KP2-964 -- Berechnung des aktuell bestehenden quartalsübergreifenden Restkontingents einer bewilligten Psychotherapie

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Um den Psychotherapeuten bei der Erfassung und Übertragung einer Beendigungsmitteilung mit der Pseudo-GOP 88130 bzw. 88131 über die Quartalsabrechnung zu unterstützen, muss die Software das aktuell bestehende quartalsübergreifende Restkontingent einer bewilligten Psychotherapie berechnen können.

**Begründung:**

Diese Anforderung resultiert aus § 17 Abs. 7 der Psychotherapie-Vereinbarung (Anlage 1 BMV-Ä).

**Akzeptanzkriterien:**

1. Die Software muss unmittelbar nach der Leistungserfassung und bei der Abrechnungserstellung das aktuell bestehende quartalsübergreifende Restkontingent einer bewilligten Psychotherapie berechnen.
2. Die Software muss dem Anwender die Möglichkeit bieten, bereits in Vorquartalen abgerechnete Leistungen, welche von der zuständigen Kassenärztlichen Vereinigung nicht akzeptiert worden sind, zu kennzeichnen, damit sie von weiteren Berechnungen des Restkontingents ausgeschlossen werden.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

**Hinweis:**

Das aktuell bestehende Restkontingent einer bewilligten Psychotherapie wird quartalsübergreifend berechnet. Es bildet sich aus der Differenz zwischen dem bewilligten Kontingent psychotherapeutischer Leistungen als Anzahl in Summe bewilligter Therapieeinheiten und den tatsächlich geleisteten Therapieeinheiten als Anzahl in Summe abgerechneter Gebührenordnungspositionen. Eine Gebührenordnungsposition entspricht im Regelfall einer Therapieeinheit. Bei Gruppentherapiesitzungen von weniger als 100 Minuten aber mindestens 50 Minuten Dauer (hälftige Sitzungen), die anhand entsprechender bundeseinheitlich kodierter Zusatzkennzeichen gekennzeichnet sind, entsprechen zwei gekennzeichnete Gebührenordnungspositionen einer Therapieeinheit. Diese hälftigen Leistungen können daran erkannt werden, dass die Punktzahl der entsprechenden GOP mit Buchstaben-Suffix genau der Hälfte der Punktezahl der Basis-GOP ohne Buchstaben-Suffix entspricht. Das Kontingent ist unabhängig davon, ob Einzeltherapie, Gruppentherapie oder eine der Kombinationsbehandlungen durchgeführt wird. Die Berücksichtigung einer abgerechneten Gebührenordnungsposition erfolgt unabhängig von der zeitlichen Reihenfolge von Leistung und deren Bewilligung durch die Krankenkasse.

---

### KP2-965 -- Erinnerungsfunktion bei bewilligter Psychotherapie ohne Restkontingent im laufenden Quartal

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Falls im laufenden Quartal unmittelbar nach der Leistungserfassung kein Restkontingent zu der bewilligten Psychotherapie besteht, muss die Software den Anwender auf die Angabe der Pseudo-GOP 88130 hinweisen.

**Begründung:**

Diese Anforderung resultiert aus § 17 Abs. 7 der Psychotherapie-Vereinbarung (Anlage 1 BMV-Ä).

**Akzeptanzkriterien:**

1. Falls im laufenden Quartal unmittelbar nach der Leistungserfassung kein Restkontingent zu der bewilligten Psychotherapie besteht, muss die Software den Anwender auf die Angabe der Pseudo-GOP 88130 hinweisen.
2. Die Software muss es dem Anwender bei bestehender Psychotherapie gemäß 1. ermöglichen, einen sogenannten "Pseudo-Behandlungsfall" zur alleinigen Übertragung der Pseudo-GOP 88130 bzw. 88131 zu erfassen und im Rahmen der ADT-Abrechnung zu übertragen.
   - a) Wenn der Patient in dem entsprechenden Quartal nicht in der Praxis war und auch keinen Kontakt mit der Praxis hatte, dann muss die Anlage dennoch möglich sein.
      - i. In diesem Fall darf nur die Pseudo-GOP 88130 oder 88131 übertragen werden.
      - ii. In diesem Fall soll der Anwender darauf hingewiesen werden, dass der ICD-10-GM-Kode aus dem letzten Behandlungsfall zur Kodierung dieses Falles verwendet werden kann.
   - b) Die Software übernimmt kein Einlesedatum.
   - c) Die Software übernimmt keine Daten, die das Einlesen einer Versichertenkarte bedingen (Felder FKen 3006, 3010, 3011, 3012, 3013 sowie 4134).
3. Wenn keine Versichertenkarte eingelesen wurde, soll die Software den Anwender durch die automatische Übernahme der Versichertendaten aus dem Patientenstamm in den Datensatz nach (2) unterstützen.
4. Die Software muss bei Psychotherapien analog 1., bei denen keine Pseudo-GOP 88130 eingetragen ist, mindestens im Rahmen der Abrechnungserstellung an die Erfassung und Übermittlung einer "Beendigungsmitteilung mit der Pseudo-GOP 88130" erinnern.
5. Die Software muss dem Anwender ermöglichen, auf eine Übertragung einer "Beendigungsmitteilung mit der Pseudo-GOP 88130" im laufenden Quartal zu verzichten, falls mindestens eine der folgenden Bedingungen erfüllt ist:
   - a) Ein Folgeantrag für die Fortführung der Psychotherapie wurde bzw. wird gestellt.
   - b) Die Psychotherapie wird länger als 6 Monate unterbrochen und eine formlose Begründung für die Unterbrechung nach § 17 Absatz 6 Psychotherapievereinbarung an die Krankenkasse übermittelt. Die Software stellt dem Anwender eine Möglichkeit zur Verfügung dies in der Patientendokumentation zu hinterlegen.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### KP2-966 -- Erinnerungsfunktion bei bewilligter Psychotherapie ohne Restkontingent aus einem Vorquartal

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Falls aus einem Vorquartal eine bewilligte Psychotherapie ohne Restkontingent und ohne Übermittlung einer Pseudo-GOP 88130 bzw. 88131 besteht, soll die Software den Anwender in den zwei nachfolgenden Quartalen auf die Angabe der Pseudo-GOP 88130 hinweisen.

**Begründung:**

Diese Anforderung resultiert aus § 17 Abs. 7 der Psychotherapie-Vereinbarung (Anlage 1 BMV-Ä).

**Akzeptanzkriterien:**

1. Falls aus einem Vorquartal eine bewilligte Psychotherapie ohne Restkontingent und ohne Übermittlung einer Pseudo-GOP 88130 bzw. 88131 oder ohne eine Kennzeichnung nach Akzeptanzkriterium (4) besteht, muss die Software den Anwender spätestens im Rahmen der Abrechnungserstellung für jeweils zwei nachfolgende Quartale auf die Angabe der Pseudo-GOP 88130 hinweisen, sofern die Pseudo-GOP im laufenden Quartal noch nicht erfasst worden ist.
   - a) Dem Anwender sollen nur bewilligte Psychotherapien ohne Restkontingent ab dem 01.01.2020 angezeigt werden.
2. Es gelten die Akzeptanzkriterien 2, 3 und 4 der Funktion KP2-965.
3. Die Software muss dem Anwender ermöglichen, auf eine Übertragung einer "Beendigungsmitteilung mit der Pseudo-GOP 88130 bzw. 88131" aus einem Vorquartal zu verzichten, falls mindestens eine der folgenden Bedingungen erfüllt ist:
   - a) Ein Folgeantrag für die Fortführung der Psychotherapie wurde bzw. wird gestellt.
   - b) Die Psychotherapie wird länger als 6 Monate unterbrochen und eine formlose Begründung für die Unterbrechung nach § 17 Absatz 6 Psychotherapie-Vereinbarung an die Krankenkasse übermittelt. Die Software stellt dem Anwender eine Möglichkeit zur Verfügung dies in der Patientendokumentation zu hinterlegen.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### KP2-967 -- Erinnerungsfunktion bei bewilligter Psychotherapie mit Restkontingent und ohne APK seit zwei Quartalen

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Falls eine bewilligte Psychotherapie mit Restkontingent besteht und kein APK seit zwei Quartalen stattgefunden hat, muss die Software den Anwender auf die Angabe der Pseudo-GOP 88130 bzw. 88131 hinweisen.

**Begründung:**

Diese Anforderung resultiert aus § 17 Abs. 7 der Psychotherapie-Vereinbarung (Anlage 1 BMV-Ä).

**Akzeptanzkriterien:**

1. Falls zu einer bestehenden bewilligten Psychotherapie mit Restkontingent seit mindestens zwei Quartalen kein APK stattgefunden hat, soll die Software den Anwender jedes Quartal spätestens im Rahmen der Abrechnungserstellung auf die Angabe der Pseudo-GOP 88130 bzw. 88131 hinweisen, sofern die Pseudo-GOP im laufenden Quartal noch nicht erfasst worden ist.
   - a) Dem Anwender sollen nur bewilligte Psychotherapie mit Restkontingent angezeigt werden.
2. Es gelten die Akzeptanzkriterien 2, 3 und 4 der Funktion KP2-966.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### KP2-968 -- Hinweis bei Abrechnung einer Richtlinientherapie als Rezidivprophylaxe bei fehlender Beendigungsmitteilung nach Pseudo-GOP 88131

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Falls der Anwender im Rahmen der Leistungsdokumentation einer bewilligten Psychotherapie eine GOP zur Rezidivprophylaxe erfasst und im Behandlungsverlauf keine Pseudo-GOP 88131 übermittelt wurde, muss die Software den Anwender auf die fehlende "Beendigungsmitteilung mit der Pseudo-GOP 88131" hinweisen.

**Begründung:**

Diese Anforderung resultiert aus § 17 Abs. 7 der Psychotherapie-Vereinbarung i. V. m. § 20 Abs. 3 und 6 Psychotherapie-Vereinbarung.

**Akzeptanzkriterien:**

1. Falls der Anwender im Rahmen der Leistungsdokumentation einer bewilligten Psychotherapie eine GOP zur Rezidivprophylaxe (siehe [KBV_ITA_AHEX_Codierungstabelle_PT_Rezidiv]) erfasst und im Behandlungsverlauf keine Pseudo-GOP 88131 übermittelt wurde, weist die Software den Anwender unmittelbar auf diesen Sachverhalt hin und ermöglicht eine Dokumentation der GOP 88131.

**Hinweistext:**

*"Achtung: Sie möchten eine Richtlinientherapie als Rezidivprophylaxe durchführen/abrechnen. Voraussetzung hierfür ist eine Beendigungsmitteilung für die Richtlinientherapie mit Pseudo-GOP 88131 (§ 17 Abs.7 Psychotherapie-Vereinbarung). Es wurde im bisherigen Behandlungsverlauf keine Beendigung mit der Pseudo-GOP 88131 übermittelt."*

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### K2-969 -- Erstellung und Ausdruck von Listen bewilligter Psychotherapien mit fehlender Beendigungsmitteilung mit der Pseudo-GOP 88130 bzw. 88131

**Typ:** OPTIONALE FUNKTION ADT

Die Software kann dem Anwender die Möglichkeit bieten, Listen bewilligter Psychotherapien mit fehlender Beendigungsmitteilung mit der Pseudo-GOP 88130 bzw. 88131 jeweils analog des Akzeptanzkriteriums 1. der Funktionen KP2-965, KP2-966, KP2-967, KP2-968, KP2-970 und KP2-971 zu erstellen und zu drucken.

**Begründung:**

Der Anwender soll die Möglichkeit haben, Listen bewilligter Psychotherapien mit fehlender Beendigungsmitteilung mit der Pseudo-GOP 88130 bzw. 88131 zu erstellen und zu drucken.

**Akzeptanzkriterien:**

1. Der Anwender kann Listen bewilligter Psychotherapien mit fehlender Beendigungsmitteilung jeweils analog des Akzeptanzkriteriums (1) der Funktionen KP2-965, KP2-966, KP2-967, KP2-968, KP2-970 und KP2-971 erstellen und ausdrucken.

---

### KP2-970 -- Erinnerungsfunktion bei bewilligter Psychotherapie mit Restkontingent und APK im Abrechnungsquartal

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Falls für eine bewilligte Psychotherapie Leistungen erfasst wurden und am Quartalsende ein Restkontingent zu der bewilligten Psychotherapie besteht und sich eine Rezidivprophylaxe anschließen kann, soll die Software den Anwender auf die Angabe der Pseudo-GOP 88131 hinweisen.

**Begründung:**

Diese Anforderung resultiert aus § 17 Abs. 7 der Psychotherapie-Vereinbarung (Anlage 1 BMV-Ä).

**Akzeptanzkriterien:**

1. Die Software muss den Anwender mindestens im Rahmen der Abrechnungserstellung auf die mögliche Erfassung und Übermittlung einer "Beendigungsmitteilung mit der Pseudo-GOP 88131" hinweisen, falls
   - b) die Dauer der bereits durchgeführten Behandlung mindestens 40 Therapieeinheiten beträgt und
   - c) im Abrechnungsquartal für eine bewilligte Psychotherapie Leistungen erfasst wurden und
   - d) keine Pseudo-GOP 88130 bzw. 88131 erfasst worden ist und
   - e) die Psychotherapie nicht unterbrochen ist.
2. Die Software kann die Hinweisgabe gemäß Akzeptanzkriterium 1. von weiteren u. g. Kriterien abhängig machen.
3. Die Software überträgt mit der ADT-Abrechnung die vom Anwender angegebene Pseudo-GOP 88130 bzw. 88131 im Feld 5001.

**Kriterium:**

Die Software kann folgende Kriterien benutzen (gemäß Richtlinie des Gemeinsamen Bundesausschusses über die Durchführung der Psychotherapie (Psychotherapie-Richtlinie)), um zu entscheiden, ob sich eine Rezidivprophylaxe anschließen kann:

1. Angabe in den Patientendaten, ob eine Rezidivprophylaxe nach dem Abschluss der Langzeittherapie durchgeführt werden soll
2. Behandlungsdauer der Psychotherapie (vgl. Psychotherapie-Richtlinie [GBA_RiLi_Psychotherapie], §14 (3), Satz 1, 2)
3. Alter des Versicherten (vgl. Psychotherapie-Richtlinie, §1 (4), Satz 1)
4. Vorliegen einer geistigen Behinderung des Versicherten (vgl. Psychotherapie-Richtlinie, §1 (4), Satz 5)
5. Höhe des Restkontingents (vgl. Psychotherapie-Richtlinie, §14 (3), Satz 1, 2)

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### KP2-971 -- Erinnerungsfunktion bei bewilligter Psychotherapie mit Restkontingent aus einem Vorquartal

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Falls aus einem Vorquartal eine bewilligte Psychotherapie mit Restkontingent ohne Übermittlung einer Pseudo-GOP 88130 bzw. 88131 besteht und sich eine Rezidivprophylaxe anschließen kann, soll die Software den Anwender im nachfolgenden therapiefreien Quartal auf die Angabe der Pseudo-GOP 88131 hinweisen.

**Begründung:**

Diese Anforderung resultiert aus § 17 Abs. 7 der Psychotherapie-Vereinbarung (Anlage 1 BMV-Ä).

**Akzeptanzkriterien:**

1. Die Software muss mindestens im Rahmen der Abrechnungserstellung auf die mögliche Erfassung und Übermittlung einer "Beendigungsmitteilung mit der Pseudo-GOP 88131" hinweisen, falls
   - a) die Dauer der bereits durchgeführten Behandlung mindestens 40 Therapieeinheiten beträgt und
   - b) die letzte Leistung für diese bewilligte Psychotherapie im Vorquartal erfasst worden ist und
   - c) die Pseudo-GOP 88130 bzw. 88131 noch nicht übermittelt oder erfasst worden ist oder keine Kennzeichnung gemäß KP2-966 Akzeptanzkriterium 4. erfolgte und
   - d) die Psychotherapie nicht unterbrochen ist.
2. Die Software kann die Hinweisgabe gemäß Akzeptanzkriterium 1. von weiteren u. g. Kriterien abhängig machen.
3. Es gelten die Akzeptanzkriterien 2. und 3. und 4. der Funktion KP2-966.

**Kriterium:**

Die Software kann folgende Kriterien benutzen (gemäß Richtlinie des Gemeinsamen Bundesausschusses über die Durchführung der Psychotherapie (Psychotherapie-Richtlinie)), um zu entscheiden, ob sich eine Rezidivprophylaxe anschließen kann:

1. Angabe in den Patientendaten, ob eine Rezidivprophylaxe nach dem Abschluss der Langzeittherapie durchgeführt werden soll
2. Behandlungsdauer der Psychotherapie (vgl. Psychotherapie-Richtlinie [GBA_RiLi_Psychotherapie], §14 (3), Satz 1, 2)
3. Alter des Versicherten (vgl. Psychotherapie-Richtlinie, §1 (4), Satz 1)
4. Vorliegen einer geistigen Behinderung des Versicherten (vgl. Psychotherapie-Richtlinie, §1 (4), Satz 5)
5. Höhe des Restkontingents (vgl. Psychotherapie-Richtlinie, §14 (3), Satz 1, 2)

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### KP2-972 -- Erfassung einer Unterbrechung einer laufenden bewilligten Psychotherapie

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Falls eine laufende bewilligte Psychotherapie unterbrochen wird, soll die Software dem Anwender die Möglichkeit bieten, diese Information zu erfassen und im System zu speichern.

**Begründung:**

Diese Anforderung resultiert aus § 10 Abs. 6 und 7 der Psychotherapie-Vereinbarung (Anlage 1 BMV-Ä).

**Akzeptanzkriterien:**

1. Die Software muss dem Anwender die Möglichkeit bieten, das Startdatum der Unterbrechung einer laufenden bewilligten Psychotherapie und das Vorliegen einer formlosen Begründung an die Krankenkasse gemäß § 17 Absatz 6 der Psychotherapie-Vereinbarung zu erfassen und im System zu speichern.
2. Die Software muss dem Anwender die Möglichkeit bieten, das Enddatum der Unterbrechung einer laufenden bewilligten Psychotherapie zu erfassen und im System zu speichern.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

## 2.3.12 Patientenerklärung Europäische Krankenversicherung

Zum Nachweis der Kostenübernahme einer medizinischen Leistung für eine im EU-bzw. EWR-Ausland oder der Schweiz versicherten Person bedarf es der Vorlage der Europäische Krankenversicherungskarte (EHIC) oder der Provisorische Ersatzbescheinigung (PEB) sowie der Patientenerklärung Europäische Krankenversicherung ([EXT_ITA_AHEX_Erklaerung_EHIC_PEB]).

---

### KP2-945 -- Aufruf der Patientenerklärung Europäische Krankenversicherung

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software ermöglicht den Aufruf der PDF-Vorlage für die "Patientenerklärung Europäische Krankenversicherung" direkt aus dem System.

**Begründung:**

Der Anwender muss die Möglichkeit haben das Dokument über die Software aufzurufen und zu drucken.

**Akzeptanzkriterien:**

1. Der Anwender kann bei Bedarf die PDF-Vorlage ([EXT_ITA_AHEX_Erklaerung_EHIC_PEB]) der "Patientenerklärung Europäische Krankenversicherung" direkt aus der Software aufrufen.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### KP2-946 -- Ausdruck der Patientenerklärung Europäische Krankenversicherung

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software ermöglicht den Ausdruck der PDF-Vorlage "Patientenerklärung Europäische Krankenversicherung" sowohl im Ganzen als auch in Teilen.

**Begründung:**

Der Anwender muss die Möglichkeit haben das Dokument über die Software aufzurufen und zu drucken.

**Akzeptanzkriterien:**

1. Der Anwender kann
   - a) die PDF-Vorlage der "Patientenerklärung Europäische Krankenversicherung" im Ganzen **oder**
   - b) auch Teile der PDF-Vorlage
   direkt aus dem System drucken.
2. Die Software druckt auf jeder einzelnen Seite der Patientenerklärung unter den Vertragsarztstempel die ADT-Prüfnummer (PRF.NR.) aus dem Verfahren KVDT an die Position:
   - a) Die Prüfnummer muss an der definierten Position in Arial, Schriftgröße 5 aufgedruckt werden.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

**Hinweis:**

Das Formular "Patientenerklärung Europäische Krankenversicherung" ist gemäß der Anlage 20 zum Bundesmantelvertrag-Ärzte (Vereinbarung zur Anwendung der Europäischen Krankenversicherungskarte) ausschließlich mittels zertifizierter Software und eines Druckers vom Vertragsarzt selbst in der Praxis zu erzeugen.

---

## 2.3.13 Suche im Patientenstamm

### P2-948 -- Suche im Patientenstamm

**Typ:** PFLICHTFUNKTION ADT

Die Software muss dem Anwender eine Funktion zur Suche und Identifikation bereits vorhandener Patientenstammdaten im Patientenstamm anbieten.

**Begründung:**

Aus Datenschutzgründen kann es im Rahmen der KV-Arzt-Kommunikation vorkommen, dass kein Patientenname, sondern beispielsweise nur die Versicherten-ID verwendet wird.

**Akzeptanzkriterien:**

1. Die Software muss dem Anwender die Möglichkeit bieten, über die Eingabe mindestens folgender Suchkriterien bereits vorhandene Patienten im Patientenstamm zu suchen:
   - a) Versicherten-ID
   - b) Versichertennummer
   - c) SKT-Zusatzangabe
   - d) Geburtsdatum
