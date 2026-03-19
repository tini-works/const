# 3 Kurarztliche Abrechnung (KADT)

> Quelle: KBV_ITA_VGEX_Anforderungskatalog_KVDT, Version 6.06, 9. Marz 2026, Seiten 133-134

Mit der Satzart 0109 (Kurarztliche Behandlung) des KADT-Datenpaketes wird eine "KADT"-Abrechnung auf Basis des Formulars "Kurarztschein -- Behandlungsausweis fur kurarztliche Behandlung" gegenuber der Kassenarztlichen Vereinigung unter Beachtung der Angaben der jeweils aktuell gultigen KV-Spezifika-Stammdatei der **KV Westfalen-Lippe** moglich.

Mit der vollstandigen Realisierung der Satzart 0109 des KADT-Datenpaketes ergibt sich auch die Notwendigkeit der korrekten Online-Anbindung von Versicherten-Kartenlesegeraten.

Es gelten die Vorgaben der Kapitel 1, 2, 3, 5, 6 und 7 mit folgenden Ausnahmen:

1. Kapitel 2.2.7 mit Ausnahme der Kapitel 2.3.2 (Abrechnungsvorbereitende Funktionen) und Kapitel 2.3.7.1 (Behandlungstag/GNR)
2. Kapitel 7.5 (GO-Stammdatei);
3. Kapitel "Muster 1 (Arbeitsunfahigkeitsbescheinigung)", Kapitel "Besonderheiten bei Arbeitsunfallen", "Anforderungskatalog Formularbedruckung" [KBV_ITA_VGEX_Anforderungskatalog_Formularbedruckung]
4. alle Funktionen, welche die Abrechnung "Sonstiger Kostentrager" betreffen.

## Erlauterungen zum Quartalsbezug

Eine ambulante Kur unterscheidet sich in einem Punkt wesentlich von der vertragsarztlichen Quartalsabrechnung: Ein Quartalswechsel innerhalb der Kur hat keine Auswirkungen. Weder muss die Versichertenkarte erneut eingelesen werden, noch sind an die Angabe "Letzter Einlesetag der Versichertenkarte im Quartal" (FK 4109) Einschrankungen zu knupfen. Das Feld "Quartal" (FK 4101) ist im Abrechnungsdatensatz nicht vorhanden.

Eine ambulante Kur wird abgerechnet,

- wenn sie beendet ist und
- noch nicht abgerechnet wurde.

**Beispiel:**

Anreisetag: 20.9.2011
Abreisetag: 10.10.2011
Abrechnung dieser Kur erfolgt vollstandig im Abrechnungsquartal 4/2011.

Zusatzlich gilt:

---

### P2.6-10 -- Ausschluss Sonstiger Kostentrager

**Typ:** PFLICHTFUNKTION KADT

Soll eine Kurarztliche Abrechnung uber einen Sonstigen Kostentrager abgewickelt werden, dann gilt:

1. Systemseitig erfolgt ein **WARNHINWEIS**, dass eine Abrechnung mit Sonstigen Kostentrager mittels KVDT nicht moglich ist.

   **Hinweis:**

   Die Kurarztliche Abrechnung erfolgt dann direkt mit dem Kostentrager.

2. Eine Weiterverarbeitung zum Zwecke der KADT-Abrechnung darf mit Sonstigen Kostentragern **nicht moglich sein**.

3. Eine Bedruckung von vertragsarztlichen Formularen muss mit Sonstigen Kostentragern **moglich** sein.

---

### P2.6-20 -- Leistungsdokumentation mittels Pseudo-Gebuhrennummer 00001U

**Typ:** PFLICHTFUNKTION KADT

Bedingt durch die Pauschalierung der Kurarztlichen Abrechnung werden keine Leistungen abgerechnet.

Der Nachweis uber die erfolgten Behandlungen erfolgt durch die Dokumentation der Leistungstage, jeweils unter Angabe der Pseudo-Ziffer "00001U".

**Hinweis:**

Auch interkurrente Erkrankungen, Sachkosten etc. sind durch die Pauschalierung berucksichtigt.

---

### P2.6-30 -- KV-Spezifika-Stammdatei der KV Westfalen-Lippe bei Kurarztlicher Abrechnung

**Typ:** PFLICHTFUNKTION KADT

Dem Anwender mussen die fur die Abrechnung kurarztlicher Leistungen relevanten Angaben der jeweils gultigen KV-Spezifika-Stammdatei der **KV Westfalen-Lippe** zur Verfugung stehen.
