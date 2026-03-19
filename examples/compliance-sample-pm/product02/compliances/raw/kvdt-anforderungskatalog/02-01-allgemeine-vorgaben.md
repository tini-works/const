# 2 Vertragsärztliche Abrechnung (ADT)

**Grundsatz**

Soweit nicht nachfolgend abweichend beschrieben, gelten die für manuelle Abrechnung erlassenen Vorschriften auch bei EDV-Einsatz.

## 2.1 Allgemeine Vorgaben

### 2.1.1 Weitere verbindliche Dokumente

---

### P2-05 - Anforderungskatalog zur Anwendung der ICD-10-GM

**Typ:** PFLICHTFUNKTION ADT

Die Software setzt die Anforderungen bzgl. Anwendung der ICD-10-GM korrekt um.

**Begründung:**

Vertragsärzte und Vertragspsychotherapeuten sind gemäß § 295, Abs. 1 SGB V, Satz 1, 2, 3 zum Kodieren nach ICD-10-GM verpflichtet.

**Akzeptanzkriterium:**

1. Die Software setzt alle erforderlichen Anforderungen des Anforderungskataloges "Anforderungskatalog zur Anwendung der ICD-10-GM", vgl. [KBV_ITA_VGEX_Anforderungskatalog_ICD-10] um.

---

### P2-06 - Anforderungskatalog Formularbedruckung

**Typ:** PFLICHTFUNKTION ADT

Der "Anforderungskatalog Formularbedruckung" [KBV_ITA_VGEX_Anforderungskatalog_Formularbedruckung] gilt verbindlich für Software für Vertragsarztpraxen (PVS), welche zur Erstellung der vertragsärztlichen Abrechnung zugelassen ist.

---

### 2.1.2 Vollständigkeit der Eingabe aller Stamm- und Bewegungsdaten

---

### P2-10 - Vollständigkeit der Eingabe aller Stamm- und Bewegungsdaten

**Typ:** PFLICHTFUNKTION ADT

Die Bedieneroberfläche der Abrechnungssoftware muss eine lückenlose und korrekte Eingabe aller in den Datensatzbeschreibungen abrechnungsrelevanten Stamm- und Bewegungsdaten ermöglichen.

---

### 2.1.3 Systemdatum, Vordatieren

---

### P2-20 - Systemdatum

**Typ:** PFLICHTFUNKTION ADT

Das Systemdatum ist grundsätzlich über das Betriebssystem vorgegeben. Eine Änderung des Systemdatums durch den Anwender verstößt gegen die Grundsätze ordnungsgemäßer Datenverarbeitung. Die Bereitstellung einer Funktion in der Anwendungssoftware, die eine Veränderung des Systemdatums ermöglicht, ist unzulässig.

**Anmerkung:**

Jeder Anwender mit den Rechten eines Systemadministrators besitzt die Möglichkeit zur Veränderung des Systemdatums. Vor diesem Hintergrund wird nicht erwartet, dass das Systemdatum durch den Arzt unveränderbar sein muss. Diese Forderung wäre jenseits der praktischen Realität und würde den Einsatz eines durch die Funkuhr gespeisten Zeitmoduls im Praxiscomputer voraussetzen. Vielmehr wird Wert darauf gelegt, dass nicht an diversen Stellen der Anwendungssoftware Funktionen zur Änderung des Systemdatums angeboten werden, die von jedem Benutzer nach Belieben aktiviert werden können. Normalerweise sollte eine Datumsänderung ausschließlich auf Betriebssystemebene möglich sein und zwar nur für entsprechend autorisierte Personen.

---

### P2-30 - Vordatieren

**Typ:** PFLICHTFUNKTION ADT

Die Abrechnungssoftware muss sicherstellen, dass über das Systemdatum hinaus **vordatierte** GNRn und ICD-10-GM-Codes nicht erfasst werden können. Zusätzlich zur Fehlermeldung muss die Abrechnungssoftware derartige Eingaben verweigern.

---

### 2.1.4 Ersatzwerte

---

### P2-40 - Ersatzwerte

**Typ:** PFLICHTFUNKTION ADT

Ein **Ersatzwert** ist ein Feldinhalt, der nur dann zu übertragen ist, wenn tatsächlich **kein** Wert für ein in der Tabelle aufgeführtes Muss-Feld in der Praxis vorliegt. Der Ersatzwert ist nicht mit einem **Defaultwert** zu verwechseln. Ersatzwerte für die u. a. Felder sind in Kapitel 7 "Feldverzeichnis" der KVDT-Datensatzbeschreibung [KBV_ITA_VGEX_Datensatzbeschreibung_KVDT] definiert.

Die in der Tabelle 1 genannten Felder dürfen **nicht** standardmäßig - d.h. nicht automatisch ohne Einzelbestätigung - mit den Ersatzwerten belegt werden.

**Tabelle 1 - Ersatzwerte**

| Bezeichnung | FK |
|---|---|
| Geburtsdatum | 3103 |
| Überweisung von anderen Ärzten | 4219 |
| Überweisung an | 4220 |
| Weiterbehandelnder Arzt | 4243 |
| LANR des Erstveranlassers | 4241 |
| LANR des Überweisers | 4242 |
| LANR des Vertragsarztes/Vertragspsychotherapeuten | 5099 |
| HGNC-Gensymbol | 5077 |

**Hinweis zu Feld "ICD-10-GM-Code"**

Die KVDT-Abrechnungssoftware, welche für die Abrechnung gemäß §57a (2) BMV-Ä^3 eingesetzt wird, darf ab dem 01.01.2020 anstelle eines krankheitsspezifischen Diagnoseschlüssels nach ICD-10-GM auch die standardmäßige Übertragung des ICD-10-GM-Kodes "Z01.7" (= Laboruntersuchung), im Sinne eines Ersatz-/Defaultwertes, im Feld "ICD-Code" (FK 6001) unterstützen, vgl. [KBV_ITA_VGEX_Anforderungskatalog_ICD-10], KP10-350 (Befreiung von der Verschlüsselungspflicht mit einem krankheitsspezifischen Diagnoseschlüssel nach ICD-10-GM).

> ^3 §57a BMV-Ä, (2):
> In den nachfolgend aufgeführten Konstellationen kann anstelle des jeweils spezifischen Diagnoseschlüssels nach ICD-10-GM regelhaft im Sinne eines Ersatzwertes der ICD-10-Kode Z01.7 Laboruntersuchung angegeben werden:
> 1. Für Arztfälle in einer Arztpraxis, in denen in-vitro-diagnostische Untersuchungen der Abschnitte 11.4, 19.3, 19.4, 32.2, 32.3 EBM oder entsprechende Untersuchungen im Abschnitt 1.7 oder 8.5 des EBM ohne unmittelbaren Arzt-Patienten-Kontakt durchgeführt werden, es sei denn, im EBM sind für die Abrechnung der Gebührenordnungspositionen speziellere Regelungen getroffen.
> 2. Fallunabhängig für Fachärzte für Pathologie, Fachärzte für Neuropathologie, Fachärzte für Laboratoriumsmedizin sowie Fachärzte für Mikrobiologie und Infektionsepidemiologie.

---

### 2.1.5 Benutzer- und Betriebsstättenverwaltung

---

### P2-51 - Benutzer-/Rechteverwaltung

**Typ:** PFLICHTFUNKTION ADT

Ein PVS muss eine Benutzer- und Rechteverwaltung realisieren, sodass im Rahmen der KV-Abrechnung alle Leistungen jeweils einem Leistungsort und einem Vertragsarzt/Vertragspsychotherapeuten zugeordnet werden können.

---

### P2-52 - Betriebsstättenverwaltung

**Typ:** PFLICHTFUNKTION ADT

Ein PVS muss je Betriebsstättennummer alle in dieser Betriebsstätte tätigen Ärzte mit Angabe der LANR verwalten und diese Informationen im Rahmen der KV-Abrechnung im besa-Datensatz gemäß KVDT-Datensatzbeschreibung [KBV_ITA_VGEX_Datensatzbeschreibung_KVDT] übermitteln. Wird ein PVS an mehreren Standorten betrieben (mobil oder vernetzt), ist neben der Benutzeranmeldung darüber hinaus eine Betriebsstättenzuordnung zu realisieren.

---

### P2-53 - Teil-/ Betriebsstättenabrechnung

**Typ:** PFLICHTFUNKTION ADT

Standardmäßig erfolgt die Abrechnung betriebsstättenbezogen. Der Dateiname der KVDT-Abrechnungsdatei wird aus der Betriebsstättennummer (FK 0201, besa-Datensatz) gebildet (siehe KVDT-Datensatzbeschreibung [KBV_ITA_VGEX_Datensatzbeschreibung_KVDT]).

**Hinweis:**

Abweichend von dem Standardfall kann die Software dem Anwender den Export von Teilabrechnungen auf Grundlage weiterer Kriterien wie beispielsweise nach der LANR (FK 5099), nach GOPen (FK 5001), VKNR+KTAB-Kombination usw. ermöglichen.

---

### K2-60 - Gesamtabrechnung über mehrere Betriebsstätten

**Typ:** OPTIONALE FUNKTION ADT

Eine Gesamtabrechnung über mehrere Betriebsstätten ist unter folgenden Voraussetzungen zulässig:

1. Alle gemeinsam abrechnenden Betriebsstätten setzen die gleiche PVS ein,
2. Im besa-Datensatz sind sowohl alle in der Abrechnung relevanten Betriebsstätten inkl. der dort jeweils tätigen Ärzte mit LANR aufgelistet.

Dabei ist es unerheblich, ob die Gesamt-Abrechnungsdatei aus einer zentralen Datenbasis heraus erzeugt wurde oder aber die Datenpakete aus den einzelnen Abrechnungsdateien der Betriebsstätten zusammengeführt worden sind.

Die Gesamt-Abrechnungsdatei setzt sich aus der Betriebsstättennummer der abrechnungserzeugenden / zusammenführenden Betriebsstätte (= Absender) zusammen.

---

### P2-65 - Pseudoarztnummern für die Lebenslange Arztnummer (LANR)

**Typ:** PFLICHTFUNKTION ADT

Die Software muss dem Anwender die Möglichkeit bieten eine Pseudoarztnummer zu verwenden.

**Begründung:**

Vertragliche Grundlage dieser Anforderung ist die Richtlinie der KBV nach § 75 Absatz 7 SGB V zur Vergabe der Arzt-, Betriebs- sowie der Praxisnetznummern in Verbindung mit der Anlage 6 BMV-Ä (Vertrag über den Datenaustausch), § 4 "Art und Inhalt der Daten der Weiteren Leistungserbringer".

**Akzeptanzkriterium:**

1. Die Software muss dem Anwender die Möglichkeit bieten, die Pseudoarztnummer "999999900" zu erfassen und zu speichern.
2. Im Rahmen der ADT-Abrechnung muss die Software fähig sein, die Pseudoarztnummer in den Feldern 4241, 4242 und 5099 zu übertragen.
3. Die Software muss bei der Bedruckung/Ausstellung vertragsärztlicher Formulare in diesen Fällen die Pseudoarztnummer verwenden können.

**Hinweis:**

Ergänzend ist die Funktion P2-40 zu beachten.

---

### P2-66 - Übertragung der kompatibilitätsrelevanten Anteile der Produkttypversion des Konnektors

**Typ:** PFLICHTFUNKTION ADT

Die Software muss die Übertragung der "kompatibilitätsrelevanten Anteile der Produkttypversion des Konnektors" in die ADT-Abrechnung ermöglichen.

**Begründung:**

Das Vorhalten und die bedarfsweise Nutzung eines Konnektors in einer Vertragsarztpraxis entsprechend einer bestimmten Produkttypversion stellt eine notwendige Voraussetzung für die Erstattung der Pauschalen gemäß Anlage 32 BMV-Ä durch die zuständige Kassenärztliche Vereinigung dar, welche diesen nachzuweisen ist. Darüber hinaus haben nach § 341 Absatz 6 SGB V die an der vertragsärztlichen Versorgung teilnehmenden Leistungserbringer gegenüber den jeweils zuständigen Kassenärztlichen Vereinigungen nachzuweisen, dass sie über die für den Zugriff auf die elektronische Patientenakte erforderlichen Komponenten und Dienste verfügen. Mit der Übertragung der "Produkttypversion des Konnektors" in die ADT-Abrechnung wird den Kassenärztlichen Vereinigungen eine einfache Möglichkeit der Prüfung dieser Voraussetzung und zum Erhalt dieses Nachweises zur Verfügung gestellt.

**Grundlagen:**

Die Produkttypversion des Konnektors kennzeichnet die Version des Produkttyps Konnektor der Telematikinfrastruktur, deren kompatibilitätsrelevanten Anteile über die Außenschnittstelle der Basisanwendung Dienstverzeichnisdienst erfasst werden können [gematik Spezifikation Konnektor]. Im Antwortdokument dieses Dienstes sind die kompatibilitätsrelevanten Anteile der Produkttypversion des Konnektors im Element `<ProductTypeVersion>` der Produktinformation enthalten, welche eine Kurzbeschreibung des Konnektormodells darstellt und mittels des XML-Schemas "ProductInformation.xsd" beschrieben wird [gematik Übergreifende Spezifikation Operations und Maintenance]. Weitere Informationen zur Produkttypversion entnehmen Sie den Spezifikationen auf der Webseite der gematik.

**Akzeptanzkriterium:**

1. Die Software muss die kompatibilitätsrelevanten Anteile der Produkttypversion des in einer (Neben-)Betriebsstätte betriebenen Konnektors in die Abrechnung übernehmen und in Feld FK 0224 im Betriebsstättendaten-Datensatz ("besa") pro Betriebsstättennummer bzw. Krankenhaus-IK in der KVDT-Datei speichern, falls diese Information über die Außenschnittstelle abrufbar ist.
   - a) Der innerhalb des Abrechnungsquartals in Tagesschritten aktuelle verfügbare Wert muss übernommen werden.
   - b) Falls in einer (Neben-)Betriebsstätte mehr als ein Konnektor betrieben wird, müssen die kompatibilitätsrelevanten Anteile der Produkttypversion mit dem zahlenmäßig höchsten Wert übernommen werden.
2. Die Software ermöglicht es dem Anwender nicht, die kompatibilitätsrelevanten Anteile der Produkttypversion manuell zu erfassen.

---

### P2-67 - Übertragung des Nachweises zur Unterstützung von TI-Fachanwendungen und der Ausstattung mit TI-Komponenten

**Typ:** PFLICHTFUNKTION ADT

Die Software muss die Übertragung eines Nachweises zur Unterstützung der Funktionsmerkmale von TI-Fachanwendungen bzw. der Ausstattung mit TI-Komponenten durch ein in der Betriebsstätte zur Verfügung stehendes Primärsystem in die ADT-Abrechnung ermöglichen.

**Begründung:**

Damit die zuständigen Kassenärztlichen Vereinigungen (KVen) die Festlegungen zur Auszahlung der TI-Pauschalen aus der "Festlegung des Vereinbarungsinhalts durch das Bundesministerium für Gesundheit gemäß § 378 Absatz 2 Satz 2 in Verbindung mit Absatz 3 und 4 des Fünften Buches Sozialgesetzbuch (SGB V)" sicherstellen können, ist es notwendig, dass im Rahmen der Abrechnung die notwendigen Informationen aus den Praxen übermittelt werden.

**Akzeptanzkriterium:**

1. Die Software muss grundsätzlich bei der ADT-Abrechnung die TI-Fachanwendung / TI-Komponente (FK 0225) mit den Werten "eRezept" (1), "NFDM" (3), "eMP" (4), "KIM" (5), "eAU" (6) "eArztbrief" (7), "Kartenterminal" (8), "SMC-B" (9), "eHBA" (10), "eVDGA" (12) und TIM (13) automatisch vorbelegen und es dem Anwender ermöglichen, diese vor der Übernahme in die ADT-Abrechnung zur Kenntnis zu nehmen.
2. Die Software muss die Informationen, ob ein in der Betriebsstätte zur Verfügung stehendes Primärsystem die Funktionsmerkmale der TI-Fachanwendungen eRezept, NFDM, eMP, KIM, eAU, eArztbrief, eVDGA und TIM unterstützt sowie ob in der Betriebsstätte mindestens ein Kartenterminal, mindestens eine SMC-B und mindestens ein eHBA verfügbar ist, jeweils im Feld FK 0226 (Systemunterstützung / Ausstattung der Praxis) automatisch vorbelegen und es dem Anwender ermöglichen, diese vor der Übernahme in die ADT-Abrechnung zur Kenntnis zu nehmen.
   - a) Die innerhalb des Abrechnungsquartals in Tagesschritten aktuelle verfügbare Information muss vorbelegt werden.
   - b) Falls die Software keine Unterstützung der jeweiligen TI-Fachanwendung anbietet bzw. die Betriebsstätte nicht mit der jeweiligen TI-Komponente ausgestattet ist (FK 0226 = 0) und im Vorquartal für die gleiche Betriebsstättennummer bzw. Krankenhaus-IK der Wert "ja" (1) in der ADT-Abrechnung erfasst worden ist, muss der Wert "ja" (1) vorbelegt werden.
   - c) Falls die Software keine Unterstützung der jeweiligen TI-Fachanwendung anbietet bzw. die Betriebsstätte nicht mit der jeweiligen TI-Komponente ausgestattet ist (FK 0226 = 0) und im Vorquartal für die gleiche Betriebsstättennummer bzw. Krankenhaus-IK der Wert "nein" (0) oder kein Wert in der ADT-Abrechnung erfasst worden ist, muss der Wert "nein" (0) vorbelegt werden.
   - d) Wenn ein Anwender die Ausprägungen (Kombination FK 0225 und 0226) zu den Funktionsmerkmalen der TI-Fachanwendung / TI-Komponente nicht aktiv zur Kenntnis genommen hat und sich diese Ausprägungen im Gegensatz zu den übermittelten Werten der Abrechnung des vorangegangenen Quartals geändert haben, dann weist die Software den Anwender auf diese Änderungen vor der Übertragung des ADT-Abrechnungsdatensatzes hin.
3. Die Software ermöglicht es dem Anwender nicht, die gemäß Akzeptanzkriterium 1. vorbelegten Werte der TI-Fachanwendung / TI-Komponente (FK 0225) vor der Speicherung der Daten im Betriebsstättendaten-Datensatz ("besa") pro Betriebsstättennummer bzw. Krankenhaus-IK in der KVDT-Datei anzupassen.
4. Die Software muss es dem Anwender ermöglichen, die gemäß Akzeptanzkriterium 2. vorbelegten Werte der Systemunterstützung / Ausstattung der Praxis (FK 0226) vor der Speicherung der Daten im Betriebsstättendaten-Datensatz ("besa") pro Betriebsstättennummer bzw. Krankenhaus-IK in der KVDT-Datei anzupassen.
5. Die Software muss die Informationen, ob ein in der Betriebsstätte zur Verfügung stehendes Primärsystem die Funktionsmerkmale der TI-Fachanwendung ePA unterstützt, zur spezifischen Erfassung automatisch vorbelegen und es dem Anwender ermöglichen, diese vor der Übernahme in die ADT-Abrechnung zur Kenntnis zu nehmen und **anzupassen**.
   - a) Als mögliche Werte für die Unterstützung sind die Ausprägungen für "keine ePA Unterstützung", und "Unterstützung von ePA Stufe 3 (ePA4all)" zu verwenden.
   - b) Die innerhalb des Abrechnungsquartals in Tagesschritten aktuelle verfügbare Information muss vorbelegt werden.
   - c) Falls die Software keine Unterstützung der TI-Fachanwendung ePA anbietet, dann übernimmt die Software die Auswahl des Anwenders aus dem Vorquartal.
      - i. Sofern kein Wert aus dem Vorquartal bekannt ist, belegt die Software "keine ePA Unterstützung" vor.
   - d) Wenn ein Anwender die Angabe zum Funktionsmerkmale der TI-Fachanwendung ePA nicht aktiv zur Kenntnis genommen hat und sich die Ausprägung im Gegensatz zum übermittelten Wert der Abrechnung des vorangegangenen Quartals geändert hat, dann weist die Software den Anwender auf die Änderung vor der Übertragung des ADT-Abrechnungsdatensatzes hin.
6. Die Software überträgt pro Betriebsstättennummer bzw. Krankenhaus-IK die aus Akzeptanzkriterium 5. ermittelten Werte wie folgt in die Abrechnung:
   - a) Entweder "keine ePA Unterstützung":
      - i. FK 0225 = 11
      - ii. FK 0226 = 0
   - b) Oder "Unterstützung von ePA Stufe 3 (ePA4all)":
      - i. FK 0225 = 11
      - ii. FK 0226 = 1

**Hinweis:**

Die Vorbelegung bzw. Anpassung der Feldkennungen kann einzeln pro Betriebsstättennummer bzw. Krankenhaus-IK oder für eine Gruppe von Betriebsstättennummern bzw. Krankenhaus-IK gesammelt erfolgen, die z.B. von der Software nach technischen und/oder durch den Anwender nach administrativen Gesichtspunkten zusammengestellt werden.

Da sich das Feld 0226 gemäß den Vorgaben der KVDT-Datensatzbeschreibung eine Hierarchiestufe tiefer direkt unterhalb des Feldes 0225 befindet, bilden die bedingten Pflichtfelder 0225 und 0226 immer ein Paar. Gemäß den Akzeptanzkriterien 1., 2., 5. und 6. müssen pro Betriebsstätte zwölf Paare in der Abrechnung übertragen werden, wobei das Feld 0225 die Werte "eRezept" (1), "NFDM" (3), "eMP" (4), "KIM" (5), "eAU" (6), "eArztbrief" (7), "Kartenterminal" (8), "SMC-B" (9), "eHBA" (10), "ePA Stufe 3" (11), "eVDGA" (12) bzw. TIM (13) aufweisen muss.

Die nachfolgenden drei Beispiele demonstrieren die Unterstützung der TI-Fachanwendungen mit der Belegung der Felder 0225 und 0226 für eine Betriebsstätte.

**Beispiel 1:** (ePA Stufe 3 - ja, alle TI-Fachanwendungen - ja)

| FK | Wert |
|---|---|
| 0225 | 11 |
| 0226 | 1 |
| 0225 | 1 |
| 0226 | 1 |
| 0225 | 3 |
| 0226 | 1 |
| 0225 | 4 |
| 0226 | 1 |
| 0225 | 5 |
| 0226 | 1 |
| 0225 | 6 |
| 0226 | 1 |
| 0225 | 7 |
| 0226 | 1 |
| 0225 | 8 |
| 0226 | 1 |
| 0225 | 9 |
| 0226 | 1 |
| 0225 | 10 |
| 0226 | 1 |
| 0225 | 12 |
| 0226 | 1 |
| 0225 | 13 |
| 0226 | 1 |

Erläuterung: ePA Stufe 3 - ja, eRezept - ja, NFDM - ja, eMP - ja, KIM - ja, eAU - ja, eArztbrief - ja, Kartenterminal - ja, SMC-B - ja, eHBA - ja, eVDGA - ja, TIM - ja

**Beispiel 2:** (ePA Stufe 3 - nein (keine Unterstützung), gemischte Unterstützung)

| FK | Wert |
|---|---|
| 0225 | 11 |
| 0226 | 0 |
| 0225 | 1 |
| 0226 | 1 |
| 0225 | 3 |
| 0226 | 0 |
| 0225 | 4 |
| 0226 | 1 |
| 0225 | 5 |
| 0226 | 1 |
| 0225 | 6 |
| 0226 | 0 |
| 0225 | 7 |
| 0226 | 1 |
| 0225 | 8 |
| 0226 | 1 |
| 0225 | 9 |
| 0226 | 1 |
| 0225 | 10 |
| 0226 | 1 |
| 0225 | 12 |
| 0226 | 0 |
| 0225 | 13 |
| 0226 | 0 |

Erläuterung: ePA Stufe 3 - nein (keine Unterstützung), eRezept - ja, NFDM - ja, eMP - nein, KIM - ja, eAU - nein, eArztbrief - ja, Kartenterminal - ja, SMC-B - ja, eHBA - ja, eVDGA - nein, TIM - nein

**Beispiel 3:** (ePA Stufe 3 - ja, gemischte Unterstützung)

| FK | Wert |
|---|---|
| 0225 | 11 |
| 0226 | 1 |
| 0225 | 1 |
| 0226 | 1 |
| 0225 | 3 |
| 0226 | 0 |
| 0225 | 4 |
| 0226 | 1 |
| 0225 | 5 |
| 0226 | 1 |
| 0225 | 6 |
| 0226 | 1 |
| 0225 | 7 |
| 0226 | 0 |
| 0225 | 8 |
| 0226 | 1 |
| 0225 | 9 |
| 0226 | 1 |
| 0225 | 10 |
| 0226 | 1 |
| 0225 | 12 |
| 0226 | 1 |
| 0225 | 13 |
| 0226 | 1 |

Erläuterung: ePA Stufe 3 - ja, eRezept - nein, NFDM - ja, eMP - nein, KIM - ja, eAU - ja, eArztbrief - nein, Kartenterminal - ja, SMC-B - ja, eHBA - ja, eVDGA - ja, TIM - ja

---

### P2-68 - Übertragung des Ablaufdatums des Konnektorzertifikats und Anzeige von Gerätezertifikaten

**Typ:** PFLICHTFUNKTION ADT

Die Software muss dem Anwender das Ablaufdatum des im Konnektor gespeicherten Zertifikats anzeigen und dieses Datum in der ADT-Abrechnung übertragen.

**Begründung:**

Die Kassenärztlichen Vereinigungen können mit dieser Information die Praxen im Zusammenhang mit dem Ablauf des Konnektorzertifikats durch geeignete Maßnahmen unterstützen.

**Akzeptanzkriterium:**

1. Die Software setzt die Anforderung A_22917, A_22918, A_22969 sowie A_13533-01 nach den Vorgaben der gematik [gematik Implementierungsleitfaden Primärsysteme Telematikinfrastruktur] sowie die Anforderung TIP1-A_4695-03 nach den Vorgaben der gematik [Spezifikation Konnektor] um.
2. Die Software liest aus dem in einer (Neben-)Betriebsstätte eingesetzten Konnektor das Ablaufdatum des Konnektorzertifikats aus und überträgt das Datum im Feld FK 0227 ("Ablaufdatum des Konnektorzertifikats").

**Hinweis:**

Es kann vorkommen, dass in einer (Neben-)Betriebsstätte mehr als ein Konnektor vorhanden ist. Es sollte bei der Übertragung in der Abrechnung der Konnektor ausgewählt werden, der dem Akzeptanzkriterium 1 b) der Anforderung P2-66 entspricht. Wenn alle in einer (Neben-)Betriebsstätte vorhandenen Konnektoren die gleichen kompatibilitätsrelevanten Anteile der Produkttypversion aufweisen, dann überträgt die Software das frühste Ablaufdatum. Die Anzeige sollte die Ablaufdaten aller vorhandenen Konnektoren übersichtlich darstellen.

---

### P2-69 - Übertragung des Produktnamens des Konnektors

**Typ:** PFLICHTFUNKTION ADT

Die Software muss dem Anwender den Produktnamen des Konnektors anzeigen und diese Information in der ADT-Abrechnung übertragen.

**Begründung:**

Die Kassenärztlichen Vereinigungen können mit dieser Information die Praxen durch geeignete Maßnahmen unterstützen.

**Akzeptanzkriterium:**

1. Die Software muss den Produktnamen des in einer (Neben-)Betriebsstätte betriebenen Konnektors in die Abrechnung übernehmen und in Feld FK 0228 im Betriebsstättendaten-Datensatz ("besa") pro Betriebsstättennummer bzw. Krankenhaus-IK in der KVDT-Datei speichern, falls diese Information über die Außenschnittstelle abrufbar ist.
   - a) Der innerhalb des Abrechnungsquartals in Tagesschritten aktuellste verfügbare Wert muss übernommen werden.
   - b) Falls in einer (Neben-)Betriebsstätte mehr als ein Konnektor betrieben wird, muss der Produktname eines Konnektors mit dem zahlenmäßig höchsten Wert der Produkttypversion übernommen werden.
2. Die Software ermöglicht es dem Anwender nicht, den Produktnamen des Konnektors manuell zu erfassen.

**Grundlagen:**

Der Produktname des Konnektors kennzeichnet den Namen des Produkts mit dem Produkttyp Konnektor der Telematikinfrastruktur, der über die Außenschnittstelle der Basisanwendung Dienstverzeichnisdienst erfasst werden können [gematik Spezifikation Konnektor]. Im Antwortdokument dieses Dienstes ist der Produktname des Konnektors im Element `<ProductName>` der Produktinformation enthalten, welche eine Kurzbeschreibung des Konnektormodells darstellt und mittels des XML Schemas "ProductInformation.xsd" beschrieben wird [gematik Übergreifende Spezifikation Operations und Maintenance].

**Hinweis:**

Es kann vorkommen, dass in einer Betriebsstätte mehr als ein Konnektor vorhanden ist. Es sollte bei der Übertragung in der Abrechnung der Konnektor ausgewählt werden, der dem Akzeptanzkriterium 1 b) der Anforderung P2-66 entspricht. Die Anzeige sollte die Produktnamen aller vorhandenen Konnektoren übersichtlich darstellen.

Falls die Zeichenanzahl des Produktnamens des Konnektors größer ist als die maximale Länge des Felds FK 0228, ist der Produktname bei der Übernahme auf mehrere Feldinstanzen aufzuteilen.

---

### P2-70 - Eindeutigkeit der LANR pro (N)BSNR

**Typ:** PFLICHTFUNKTION ADT

Die Software muss sicherstellen, dass eine LANR pro (N)BSNR in der ADT-, SADT- und KADT-Abrechnung nur einmal übertragen wird.

**Begründung:**

Wenn eine LANR pro (N)BSNR in der Abrechnung mehrmals bspw. mit unterschiedlich Arztnamen übertragen wird, kann es zu Ablehnungen der Abrechnungsdaten seitens der KVen kommen.

**Akzeptanzkriterium:**

1. Die Software muss sicherstellen, dass bei der ADT-, SADT- und KADT-Abrechnung in den Feldpaaren 0201/0212 des besa-Datensatzes die LANR (FK 0212) nur einmal pro BSNR (FK 0201) vorkommen darf.

**Hinweis:**

Diese Anforderung regelt lediglich die Übertragung der LANRs im besa-Datensatz der ADT-, SADT- und KADT-Abrechnung und stellt keine Vorgabe zur Stammdatenpflege in der Software dar.

Es ist daher weiterhin zulässig, dass bspw. Weiterbildungsassistenten einem verantwortlichen Arzt in der Stammdatenpflege zugeordnet werden, damit Leistungen, die der Weiterbildungsassistent erbringt, dem verantwortlichen Arzt in der Abrechnung zugeordnet werden können.

---

### P2-71 - Eindeutigkeit (N)BSNR

**Typ:** PFLICHTFUNKTION ADT

Die Software muss sicherstellen, dass eine (N)BSNR in der ADT-, SADT- und KADT-Abrechnung im Besa-Datensatz nur einmal übertragen wird.

**Begründung:**

Da unter einer (N)BSNR im Besa-Datensatz mehrere in der (N)BSNR tätige Ärzte angegeben werden können, ist die mehrfache Übertragung der (N)BSNR im Besa-Datensatz nicht notwendig.

**Akzeptanzkriterium:**

1. Die Software muss sicherstellen, dass bei der ADT-, SADT- und KADT-Abrechnung eine BSNR nur einmal in der Feldkennung 0201 des besa-Datensatzes vorkommt.

---

### 2.1.6 Einsatz eines zertifizierten Arzneimittelverordnungssystems gemäß Arzneimittelwirtschaftlichkeitsgesetz (AVWG)

Mit Wirkung ab 01.07.2008 wird in der ambulanten Versorgung, sofern Verordnungen mittels datenbankgestützter Software vorgenommen werden, der Einsatz eines zertifizierten Arzneimittelverordnungssystems (AVS) gemäß AVWG vorausgesetzt.

Für die Abrechnungssoftware gelten in diesem Zusammenhang folgende Anforderungen:

---

### P2-80 - Erfassung und Übertragung der AMV-Prüfnummer

**Typ:** PFLICHTFUNKTION ADT

Die Abrechnungssoftware

1. muss gegenüber dem Anwender den Einsatz einer AMV zertifizierten Software abfragen und die Erfassung der KBV-Prüfnummer der AMV zertifizierten Software zwecks Übertragung mittels KVDT (FK 9250) ermöglichen **oder**
2. überträgt die KBV-Prüfnummer des AVS automatisiert mittels KVDT (FK 9250), sofern dies möglich ist.

---

### 2.1.7 Onlineabrechnungsdienste der KVen

---

### P2-95 - Speicherort der verschlüsselten Abrechnungsdatei

**Typ:** PFLICHTFUNKTION ADT

Der Anwender muss, um die Onlineabrechnungsmöglichkeiten der KVen leichter nutzen zu können, durch das Softwarehaus bzw. System folgendermaßen unterstützt werden:

1. Alle Dokumentationen zum PVS, z. B. Anwenderhandbuch, Online-Hilfe, müssen um die Information ergänzt werden, an welcher Stelle im Dateisystem die verschlüsselte KVDT-Abrechnungsdatei gespeichert wird.
2. Der Anwender muss darüber hinaus systemseitig durch die Bereitstellung einer Funktion zum Auffinden der verschlüsselten Abrechnungsdatei im Dateisystem unterstützt werden. Diese Funktion sollte den Anwender bestmöglich unterstützen, z. B: direkt zur Abrechnungsdatei führen bzw. einen Aufruf eines Dateiexplorers mit korrekt voreingestelltem Pfad bzw. eines Links ermöglichen. Ausreichend wäre allerdings auch eine "Funktion", die es dem Anwender ermöglicht, direkt auf die entsprechende Information gemäß a) der Online-Hilfe zuzugreifen.

---

### P2-97 - 1ClickAbrechnung auf Basis von KIM

**Typ:** PFLICHTFUNKTION ADT

Die Software muss dem Anwender eine Funktion für die Übertragung der Onlineabrechnung auf Basis von KIM bereitstellen.

**Begründung:**

Mit der Abrechnung des ersten Quartals 2024 kann 1Click über KIM zur Übermittlung der Abrechnung verwendet werden, sofern die jeweilige Kassenärztliche Vereinigung das Verfahren unterstützt.

**Akzeptanzkriterium:**

1. Die Software stellt dem Anwender zur Abrechnung ab dem ersten Quartals 2024 die Funktionen gemäß des folgenden Anforderungsdokumentes bereit:
   - a) "1ClickAbrechnung V2.1" in der stets aktuellen Version [Spezifikation_1Click_KIM].
2. Die Software muss das Bestätigungsverfahren der gematik gemäß [gematik Implementierungsleitfaden Primärsysteme Telematikinfrastruktur] erfolgreich durchgeführt werden und als Nachweis muss das Bestätigungsschreiben - Bestätigung der Konformität des Primärsystems zur Konnektorschnittstelle: Funktionsumfang KIM - bei der KBV im Rahmen der Zertifizierung "1ClickAbrechnung" eingereicht werden.

---

### 2.1.8 Erfassung von Datumsangaben

---

### P2-98 - Erfassung von Datumsangaben (Felder mit Feldtyp "d" und FKen 4125/4233)

**Typ:** PFLICHTFUNKTION ADT

Die Software muss die vom Anwender eingegebenen Datumsangaben auf Gültigkeit prüfen. Ungültige Datumsangaben werden vom Softwaresystem abgewiesen.

**Begründung:**

Inkorrekte Datumsangaben führen zu Problemen im Abrechnungsprozess.

**Akzeptanzkriterium:**

1. Die Software erlaubt dem Anwender ausschließlich die Erfassung von gültigen Datumsangaben.
2. Die Software überträgt mit der Abrechnung das vom Anwender angegebene Datum im Format JJJJMMTT unter Beachtung des definierten Wertebereichs in den entsprechenden Feldern.
3. Anforderungen (1) und (2) gelten auch für die Felder FK 4125 (Gültigkeitszeitraum von ... bis) und FK 4233 (Stationäre Behandlung von ... bis...), es gilt allerdings das Datumsformat JJJJMMTTJJJJMMTT.

**Beispiel:**

| Eingabe | Abrechnungsdatei |
|---|---|
| Falsch: 29.02.2015 | ~~20150229~~ |
| Falsch: 32.06.2015 | ~~20150632~~ |
| Falsch: 31.04.2015 | ~~20150431~~ |
| Korrekt: 02.02.2015 | 20150202 |

---

### 2.1.9 Vorbelegung der Gebührenordnung

---

### P2-99 - Vorbelegung der Gebührenordnung (Feld 4121)

**Typ:** PFLICHTFUNKTION ADT

Die Software muss eine automatische Vorbelegung der vom Anwender zu erfassenden Angabe der Gebührenordnung (FK 4121) durchführen.

**Begründung:**

Inkorrekte Angaben der Gebührenordnung führen zu Problemen im Abrechnungsprozess. Die erfasste Gebührenordnung muss derjenigen entsprechen, welche dem Kostenträger zugeordnet ist, zu dessen Lasten die abgerechneten Leistungen in Anspruch genommen werden. Die Vorbelegung mit dem entsprechenden Wert aus der Kostenträger-Stammdatei unterstützt die Anwender bei der Erfassung der korrekten Angaben.

**Akzeptanzkriterium:**

1. Die Software muss grundsätzlich bei der ADT-Abrechnung die Gebührenordnung (FK 4121) automatisch vorbelegen. Es muss der Wert des Attributs `/kostentraeger/gebuehrenordnung/@V`^4 des Kostenträgers vorgelegt werden, dessen Attribut `/kostentraeger/@V` der ermittelten Abrechnungs-VKNR (FK 4104) entspricht.
2. Die Software ermöglicht es dem Anwender nicht, den vorbelegten Wert der Gebührenordnung (FK 4121) vor der Übernahme der Daten des Abrechnungsdatensatzes in die ADT-Abrechnung anzupassen.

> ^4 Die XPath-Ausdrücke beziehen sich in dem Kapitel 2.1.9 auf die Elemente der Kostenträger-Stammdatei.
