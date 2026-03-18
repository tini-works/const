# 1 Einleitung

## 1.1 Zielbestimmung

Dieser Anforderungskatalog gilt für Software für Vertragsarztpraxen zur Erstellung des KVDT (Kassenärztliche Vereinigung DatenTransfer).

KVDT ermöglicht die gebündelte Übertragung von (Kurärztlichen) Abrechnungsdaten (ADT und KADT), sowie von Daten, die im Rahmen der "Abrechnung von Schwangerschaftsabbrüchen" (SADT) dokumentiert werden.

Vertragsärzte sollen durch das Softwareprodukt in die Lage versetzt werden, den quartalsweisen Abrechnungsverkehr mit ihrer Kassenärztlichen Vereinigung abwickeln sowie vertragsärztliche Formulare korrekt bedrucken zu können. Abrechnungssoftware muss vor ihrem Einsatz durch die KBV zugelassen werden.

Abrechnungssoftware im Sinne des KBV-Prüfverfahrens sind alle Programme oder Programmteile zum Zwecke der Eingabe, Weiterverarbeitung oder Ausgabe von Daten, die im Rahmen der vertragsärztlichen Abrechnung benötigt werden.

## 1.2 Pflichtfunktionen und optionale Funktionen der Software

**Pflichtfunktionen** müssen in der Anwendungssoftware implementiert sein.

**Konditionale Pflichtfunktionen** müssen implementiert werden, wenn alle genannten Bedingungen zu dieser Funktion erfüllt sind.

**Optionale Funktionen** können implementiert werden, wenn alle genannten Bedingungen zu dieser Funktion erfüllt sind.

Die Realisierung aller Pflichtfunktionen, der implementierten optionalen Funktionen sowie der konditionalen Pflichtfunktionen ist im Rahmen des Gutachterverfahrens nachzuweisen.

Weitere Funktionen sind zulässig, sofern sie nicht in Widerspruch zu den im Anforderungskatalog getroffenen Vorgaben und gesetzlichen Regelungen stehen.

### Vorschriftsmäßigkeit

Geprüft wird vertragskonformes Funktionieren der Abrechnungsprogramme im Sinne der gültigen Abrechnungsvorschriften.

### Anforderungstypen

| Typ | Kennzeichnung | ID-Format | Beispiel |
|-----|--------------|-----------|---------|
| PFLICHTFUNKTION | Eindeutige Ident-Nummer **Pn-nn** | P2-05, P5-10, etc. | Pflichtfunktion, muss implementiert werden |
| KONDITIONALE PFLICHTFUNKTION | Eindeutige Ident-Nummer **KPn-nn** | KP2-97, KP2-100, etc. | Muss implementiert werden wenn Bedingungen erfüllt |
| OPTIONALE FUNKTION | Eindeutige Ident-Nummer **Kn-nn** | K2-60, K2-480, etc. | Kann implementiert werden |

## 1.3 Angaben zur Datenübermittlung

Die in diesem Katalog angegebenen Feldkennungen für den Abrechnungsdatensatz beziehen sich auf die Datensatzbeschreibung des KV Datentransfers (KVDT).

Sofern ein anderer Standard der elektronischen Abrechnung bspw. für die Direktabrechnung gemäß § 115b, 116b und 120 Abs. 3 SGB V zutrifft, gelten die entsprechenden Anforderungen für die dort definierten gleichbedeutenden Datenfelder analog.

## 1.4 Begriffe „Vertragsärzte" und „Vertragspsychotherapeuten"

Die Begriffe „Vertragsärzte" und „Vertragspsychotherapeuten" ergeben sich aus dem Wortlaut des § 295 Abs. 1 SGB V. Aus Vereinfachungsgründen werden in diesem Dokument ausschließlich diese Begriffe auch für die weiteren unter § 295 Abs. 4 SGB V genannten Ärzte und Psychotherapeuten verwendet.
