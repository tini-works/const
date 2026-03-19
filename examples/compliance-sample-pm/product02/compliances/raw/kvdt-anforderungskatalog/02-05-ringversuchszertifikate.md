# 2.5 Übermittlung der "Ringversuchszertifikate"

> Quelle: KBV_ITA_VGEX_Anforderungskatalog_KVDT, Version 6.06, 9. März 2026, Seiten 121-127

---

## 2.5.1 Einsatzbereich

Betroffen von dieser Regelung sind Vertragsarztpraxen, die Laborleistungen selbst erbringen und abrechnen und somit potenziell RV-teilnahmepflichtig sind sowie alle in diesem Zusammenhang zum Einsatz kommenden ambulanten Abrechnungssysteme.

## 2.5.2 Vertragliche Grundlage

Grundlage für die Erfassung der Ringversuchs-Zertifikate ist der § 25 Bundesmantelvertrag -- Ärzte (BMV-Ä), Absatz 7:

"Die Abrechnung von Laborleistungen setzt die Erfüllung der Richtlinien der Bundesärztekammer zur Qualitätssicherung laboratoriumsmedizinischer Untersuchungen gemäß Teil A und B1 sowie ggf. ergänzender Regelungen der Partner der Bundesmantelverträge zur externen Qualitätssicherung von Laborleistungen und den quartalsweisen Nachweis der erfolgreichen Teilnahme an der externen Qualitätssicherung durch die Betriebsstätte voraus.

Sofern für eine Gebührenordnungsposition der Nachweis aus verschiedenen Materialien (z.B. Serum, Urin, Liquor) möglich ist und für diese Materialien unterschiedliche Ringversuche durchgeführt werden, wird in einer Erklärung bestätigt, dass die Gebührenordnungsposition nur für das Material berechnet wird, für das ein gültiger Nachweis einer erfolgreichen Ringversuchsteilnahme vorliegt.

Der Nachweis ist elektronisch an die zuständige Kassenärztliche Vereinigung zu übermitteln."

Die Änderung tritt am 1. Januar 2011 in Kraft.

## 2.5.3 Technische Umsetzung

Die Bestimmung der relevanten Analyte als auch die Erfassung der RV-relevanten Zertifikate sollte weitgehend interaktiv über eine Abfragemaske im Praxisverwaltungssystem (PVS) erfolgen und ist je Betriebstätte zu realisieren. Um den Aufwand für den einzelnen Anwender möglichst gering zu halten, sind zunächst die Randbedingungen zu definieren, um die Auswahl der möglichen Analyte für den Anwender weitgehend zu vereinfachen und mittels Plausibilitätstests gegen die Leistungsdokumentation auch zu unterstützen.

Im Folgenden werden die für die Erfassung notwendigen Anforderungen beschrieben.

---

## 2.5.4 Einsatzpflicht

### P20-010 - Funktion zur Verwaltung von Ringversuchszertifikaten

**Typ:** PFLICHTFUNKTION ADT / RVSA

Jede Abrechnungssoftware, die für die Abrechnung von Laborleistungen gemäß Schlüsseltabelle [S_NVV_RV_ZERTIFIKAT, OID 1.2.276.0.76.3.1.1.5.2.22] verwendet werden könnte, muss eine Funktion anbieten, die es dem Anwender ermöglicht, (mit Unterstützung der über die Schlüsseltabelle verknüpften GOP) die RV-relevanten Analyte zu erfassen und die jeweiligen Zertifikate verwalten zu können.

**Hinweis:**

Die initiale Erfassung könnte bspw. angetriggert werden, sofern in der Abrechnung Labor-Leistungen gemäß Schlüsseltabelle [S_NVV_RV_ZERTIFIKAT, OID 1.2.276.0.76.3.1.1.5.2.22] identifiziert werden oder noch keine oder veraltete Informationen zu den RV-Zertifikaten vorliegen (bspw. Erinnerungsfunktion).

---

## 2.5.5 RV-Teilnahmepflicht

### P20-020 - Abklärung einer möglichen RV-Teilnahmepflicht mittels Abfrage/Konfiguration/Prüfung der Leistungsdokumentation bzgl. Laborleistungen

**Typ:** PFLICHTFUNKTION ADT / RVSA

Die gesicherte RV-Teilnahmepflicht lässt sich erst aus der Gesamtheit der Angaben zu den eingesetzten Materialien, der zu untersuchenden Analyte, unter Einbeziehung der teilweisen oder ausschließlichen Verwendung von unit-use-Reagenzien, als auch den tatsächlich abgerechneten Laborleistungen ableiten.

In erster Instanz ist somit abzuklären, ob überhaupt Laborleistungen gemäß der Schlüsseltabelle [S_NVV_RV_ZERTIFIKAT, OID 1.2.276.0.76.3.1.1.5.2.22] abgerechnet werden, aus denen sich eine evtl. RV-Teilnahmepflicht ergeben könnte.

Zu diesem Zweck soll **automatisiert** gegen die Abrechnung geparst werden, ob potenziell RV-relevante Laborleistungen abgerechnet werden. Sofern dies der Fall ist, sind spätestens im Rahmen der Abrechnung zum Quartalsende die weiteren Parameter gemäß den Funktionen P20-021 bis P20-070 zu dokumentieren.

Alternativ oder zusätzlich soll die Möglichkeit bestehen, die Angabe, ob Laborleistungen in der Betriebsstätte abgerechnet werden, direkt und interaktiv einstellen zu können (am besten per Konfiguration).

Die dokumentierten Parameter sind dauerhaft und editierbar zu speichern und mit dem RVSA-Datensatz im Rahmen der Abrechnung zu übermitteln.

**Hinweis:**

In Folgequartalen muss, sofern sich an dem Leistungsspektrum nichts ändert, keine Änderung an der Konfiguration vorgenommen werden. Es schadet aber nichts, die Einstellungen einmal im Quartal hochzuladen und zu bestätigen.

**Erläuterung:**

Werden grundsätzlich keine Laborleistungen abgerechnet, sind keine weiteren Parameter notwendig.

---

### P20-021 - RV-relevante Materialien (Filterkriterium)

**Typ:** PFLICHTFUNKTION ADT / RVSA

In einem weiteren Schritt sind die RV-relevanten Materialien [S_NVV_RV_MATERIAL, OID 1.2.276.0.76.3.1.1.5.2.21] zu bestimmen.

Es muss ein Dialog/Konfigurationsmöglichkeit/Auswahl möglich sein, unter dem betriebsstättenindividuell die RV-relevanten Materialien, die zum Zwecke der Erbringung von Laboruntersuchungen Verwendung finden, ausgewählt werden können.

Die Auswahl der Materialien muss dauerhaft gespeichert werden und jederzeit editierbar sein.

**Erläuterung:**

Die Angabe zu den verwendeten RV-Materialien erfüllt zwei Zwecke:

1. Zur Bestätigung einer evtl. RV-Teilnahmepflicht mittels Auswahl mindestens eines RV-relevanten Materials und
2. Eingrenzung der potenziell möglichen Analyt-GOP-Kombinationen in der Betriebsstätte für die folgende Analyt-Auswahl (Filter).

Bedingt durch die Struktur des EBM ist es möglich, dass ggf. dokumentierte Laborleistungen, die mit RV-relevanten Analysen verknüpft sein könnten, grundsätzlich auch auf Basis anderer, nicht RV-relevanter Materialien, erbracht worden sind. Die Angabe, ob überhaupt RV-relevante Materialien verwendet wurden, kann daher bereits Aufschluss über die grundsätzliche RV-Teilnahmepflicht geben und könnte daher auch bereits mit der Eingangsfrage, ob grundsätzlich auch Laborleistungen abgerechnet werden, kombiniert werden.

---

## 2.5.6 Abfrage zur Patientennahen Sofortdiagnostik (pnSD) mittels Verwendung von unit-use-Reagenzien (uu)

Bei ausschließlicher (oder teilweiser) Verwendung von unit-use-Reagenzien im Rahmen der patientennahen Sofortdiagnostik sind die in diesem Zusammenhang erbrachten Analysen RV-befreit (d.h. es ist kein Zertifikat notwendig, siehe Erfassung/Verwaltung der Zertifikate).

Bei Einsatz sogenannter "unit-use-Reagenzien" ist zu beachten, dass die in diesem Zusammenhang verwendeten Geräte zu spezifizieren sind.

### KP20-030 - Verwendung von unit-use-Reagenzien im Rahmen einer patientennahen Sofortdiagnostik (pnSD/uu)

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT / RVSA

Sofern die Abrechnungssoftware bei Fachgruppen zum Einsatz kommt, die potenziell pnSD/uu verwenden können, gilt diese Funktion verpflichtend.

Es muss ein Dialog/Konfigurationsmöglichkeit existieren, unter dem der Sachverhalt zur Verwendung von unit-use-Reagenzien (nein, ausschließlich, teilweise) in der Praxis dokumentiert und dauerhaft gespeichert werden kann und editierbar ist.

**Erläuterung:**

Die Realisierung dieser Funktion ist u.U. bei reinen LIS irrelevant und muss dann auch nicht zwingend realisiert werden (daher als konditionale Pflichtfunktion realisiert). Im RVSA-Datensatz ist dann das Feld FK 0301 standardmäßig mit dem Inhalt "0" zu übertragen.

---

### KP20-031 - Erfassung Gerätetyp und Hersteller bei pnSD/uu

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT / RVSA

Wird der Einsatz von pnSD/uu unter KP20-030 bestätigt, muss die Erfassung mind. eines Gerätetyps und inkl. der Angabe des Herstellers erzwungen werden. Prinzipiell muss auch die Angabe mehrerer Geräte unterstützt werden.

Die Angaben sind dauerhaft und editierbar zu speichern.

---

## 2.5.7 Auswahl der betriebsstättenindividuellen RV-Analyte

### P20-040 - Betriebsstättenindividuelle RV-Analyte

**Typ:** PFLICHTFUNKTION ADT / RVSA

Auf Basis der verwendeten Materialien ist eine darauf zugeschnittene Auswahl der potenziell relevanten RV-Analyte zu ermöglichen, die betriebsstättenindividuell erbracht werden.

Die Auswahl der Analyt-GOP-Kombinationen ist dauerhaft und editierbar zu speichern.

**Hinweis:**

Sofern eine Tabellenansicht zur Auswahl der Analyte gewählt wird, kann die Anforderung zur Abfrage der RV-Materialien gemäß P20-021 bspw. auch so umgesetzt werden, indem ein Material-Filter angeboten wird und der Anwender per Benutzerführung auf diesen Filter gelenkt wird.

**Erläuterung:**

Die gemäß Schlüsseltabelle mit den RV-relevanten Analyten verknüpften GOP können bedingt durch die Struktur des EBM zusätzlich mit anderen, nicht RV-relevanten Analyten und/oder Materialien verknüpft sein. Die Zuordnung ist hier nicht eindeutig möglich. Somit sind im Ergebnis der Plausibilisierung nur vage Hinweise auf zu vermutende Implausibilitäten oder unvollständige Angaben möglich. Für die jeweilige Entscheidung/Auswahl ist daher stets eine Interaktion durch den Anwender notwendig und wenig automatisierbar.

---

### P20-041 - Validierung der RV-Analyte mittels Abgleich mit bereits dokumentierten und abzurechnenden Laborleistungen

**Typ:** PFLICHTFUNKTION ADT / RVSA

Zur Validierung der betriebsstättenindividuellen Analyte soll ein Abgleich mit der Leistungsdokumentation möglich sein. Dabei soll die Abrechnung (Achtung: betriebsstättenbezogen!) auf potenzielle GOP geparst werden, die gemäß Schlüsseltabelle [S_NVV_RV_ZERTIFIKAT, OID 1.2.276.0.76.3.1.1.5.2.22] mit RV-Analyten verknüpft sind. Die somit potenziell relevanten Analyte sind unter Berücksichtigung der zuvor getroffenen Angaben zu den verwendeten RV-Materialien farblich hervorzuheben (nicht zu verwechseln mit einer Vorbelegung!).

**Hinweis:**

Analog zur Validierung der RV-Analyte gegen die Leistungsdokumentation kann dieselbe Funktionalität genutzt werden, um den Anwender bei der Auswahl der Analyte zu unterstützen. Somit wäre es möglich, grundsätzlich vor der Markierung der relevanten Analyte eine Validierung gegen die Leistungsdokumentation durchzuführen, um potenziell relevante Analyte farblich hervorzuheben und den Anwender somit auf die wahrscheinlichsten Analyte zu lenken.

Dieses "Vorschlagsverfahren" bietet sich insbesondere gegen Quartalsende an, wenn die Leistungsdokumentation das gesamte Leistungsspektrum abbildet. Praktisch könnte das Leistungsspektrum mit zusätzlichen Informationen aus Vorquartalen erfasst werden.

**Erläuterung:**

Die farbliche Hervorhebung darf auf keinen Fall so interpretiert werden können, dass dies als Fehler erkannt wird; es soll nur eine visuelle Unterstützung darstellen. Die GOP können grundsätzlich auch mit beliebig anderen, nicht RV-relevanten Materialien kombinierbar sein und könnten daher auch ohne RV-Zertifikat legitim abgerechnet werden.

---

## 2.5.8 Kennzeichnung der Zertifikate je Material-Analyt-GOP-Kombination bzw. alternative Kennzeichnung pnSD/uu

### P20-050 - Kennzeichnung der RV-Zertifikate bzw. pnSD/uu als Alternative

**Typ:** PFLICHTFUNKTION ADT / RVSA

Auf Basis der betriebsstättenindividuellen Material-Analyt-GOP-Kombinationen ist eine weitere Funktionalität zu implementieren, sodass jeweils eine Angabe zum Vorhandensein des RV-Zertifikates verwaltet werden kann -- bspw. als Optionsfeld -- mit folgenden Ausprägungen:

- a) Zertifikat vorhanden
- b) Zertifikat nicht vorhanden
- c) pnSD/uu

Grundsätzlich ist davon auszugehen, dass die zur Erbringung der Analysen erforderlichen RV-Zertifikate vorliegen, sodass alle Analysen mit dem Defaultwert "Zertifikat vorhanden" vorbelegt sind und einmalig zu bestätigen sind.

Daneben soll es möglich sein, dass auch die anderen Ausprägungen "Zertifikat nicht vorhanden" als auch "pnSD/uu" mit einer Aktion gesamthaft für alle Analysen übernommen werden können.

Ferner muss es möglich sein, einzelne Zertifikate abweichend zu einer gesamthaften Markierung einzeln zu kennzeichnen.

Die betriebsstättenindividuellen RV-Zertifikate sind dauerhaft und editierbar zu speichern.

In Abhängigkeit von der Ausprägung der FK 0301 (siehe KP20-030) sind die RV-Zertifikate (FK 0305) mit folgenden Defaultwerten zu belegen:

#### Tabelle 14 - Defaultwerte für RV-Zertifikate in Abhängigkeit der pnSD/uu-Info

| pnSD/uu-Info (FK 0301) | | Defaultwert für RV-Zertifikat (FK 0305) | |
|---|---|---|---|
| **Code** | **Bedeutung** | **Code** | **Bedeutung** |
| 0 | kein pnSD/uu | 1 | Zertifikat vorhanden |
| 1 | ausschließlich pnSD/uu | 2 | pnSD/uu-Analyse |
| 2 | teilweise pnSD/uu | 1 | Zertifikat vorhanden |

**Beispiel:**

Das unit-use-Kriterium wurde mit "teilweise" angegeben. Alle relevanten RV-Analyte sind zunächst mit "Zertifikat vorhanden" markiert. Für drei Analyte führt die Praxis jedoch unit-use-Analysen durch und es liegt kein Zertifikat für diese Analyte vor. Die entsprechenden Analyte sind durch den Anwender auf "pnSD/uu" zu setzen.

---

## 2.5.9 Controlling-Funktionen

### P20-060 - Zertifikatsübersicht

**Typ:** PFLICHTFUNKTION ADT / RVSA

An exponierter Stelle, z.B. in Zusammenhang mit einer evtl. bereits realisierten Abrechnungsstatistik o. ä., soll der Anwender explizit über eine Statistik mit mindestens folgenden Inhalten verfügen können:

- a) betriebsstättenindividuelle Material-Analyt-Kombinationen, für die jeweils ein Zertifikat vorliegt,
- b) betriebsstättenindividuelle Material-Analyt-Kombinationen, für die jeweils kein Zertifikat vorliegt,
- c) betriebsstättenindividuelle Material-Analyt-Kombinationen, die ausschließlich im Rahmen pnSD/uu untersucht werden,
- d) andere Material-Analyt-Kombinationen, die in der Betriebsstätte offensichtlich nicht untersucht werden.

> **Fußnote 42:** pnSD/uu = patientennahe Sofortdiagnostik mittels unit-use

---

### K20-061 - Druckfunktion der Zertifikatsübersicht

**Typ:** OPTIONALE FUNKTION ADT / RVSA

Optional können die Inhalte aus P20-060 ausgedruckt werden.

---

## 2.5.10 Elektronische Übertragung

### P20-070 - Übertragung des RVSA-Datensatzes (KVDT)

**Typ:** PFLICHTFUNKTION ADT / RVSA

Im Rahmen der Abrechnung und Erzeugung der KVDT-Abrechnungsdatei (ADT) ist der RVSA-Datensatz gemäß den Vorgaben der KVDT-Datensatzbeschreibung [KBV_ITA_VGEX_Datensatzbeschreibung_KVDT] zu generieren.
