# 7 Stammdateien der KBV

> Quelle: KBV_ITA_VGEX_Anforderungskatalog_KVDT, Version 6.06, 9. Maerz 2026, Seiten 146-160

## 7.1 Kostentraeger-Stammdatei (SDKT) (EHD-Format)

**Hinweis:**

Mit dem Update "Datenkommunikation in der Arztpraxis" fuer das 1.Quartal 2008 stellt die KBV die Kostentraeger-Stammdatei im EHD-Format zur Verfuegung. Die neue Stammdatei ist seit dem 01.04.2008 verpflichtend einzusetzen. Die gueltige Kostentraeger-Stammdatei wird jeweils zur Mitte des zweiten Monats im Quartal auf der Internetseite der KBV und auf dem Update Server mit dem Regelupdate zur Verfuegung gestellt.

**Beispiel:**

| | |
|---|---|
| VERSAND KT-Stammdatei | Mitte 2. Quartal 200x |
| EINSATZ KT-Stammdatei in der Praxis | spaetestens Beginn 3. Quartal 200x |

### 7.1.1 Verbindlichkeit und Gueltigkeit der SDKT

---

### P6-20 - Einsatz / Verbindlichkeit / Gueltigkeit / Update

**Typ:** PFLICHTFUNKTION ADT

1. Der Einsatz der jeweils aktuell gueltigen KT-Stammdatei **muss** im Zusammenhang mit der Quartalsabrechnung und der Bedruckung/Ausstellung von vertragsaerztlichen Formularen erfolgen. Durch geeignete organisatorische Massnahmen muss sichergestellt werden, dass die Anwender rechtzeitig zum Quartalsbeginn jeweils die aktuell gueltige Kostentraeger-Stammdatei im Rahmen ihrer Abrechnungssoftware einsetzen koennen.
2. **Update zur KT-Stammdatei**
   Mit einem Update zur KT-Stammdatei muss spaetestens mit Beginn des neuen Quartals die neue KT-Stammdatei eingesetzt werden, auch wenn die Abrechnung des Vorquartals noch nicht abgeschlossen ist.

---

### K6-30 - Aenderungsdatei

**Typ:** OPTIONALE FUNKTION ADT

Der Einsatz der auf der Internetseite der KBV bei Bedarf bereitgestellten Aenderungsdatei zur KT-Stammdatei ist freigestellt.

1. Ist eine mit der Aenderungsdatei unter `/kostentraeger/@V` uebermittelte Abrechnungs-VKNR in der KT-Stammdatei beim Anwender **nicht vorhanden**, dann wird der entsprechende Aenderungsdatensatz der KT-Stammdatei hinzugefuegt.
2. Ist eine mit der Aenderungsdatei unter `/kostentraeger/@V` uebermittelte Abrechnungs-VKNR in der KT-Stammdatei beim Anwender **vorhanden**, dann wird der entsprechende KT-Stammsatz durch den Aenderungsdatensatz ueberschrieben (ersetzt).

---

### P6-40 - Felder mit "amtlichen" Charakter

**Typ:** PFLICHTFUNKTION ADT

1. Die folgenden Felder des KT-Stamm- bzw. der KT-Aenderungssatzes mit den Feldkennungen:
   a) `/kostentraeger/@V`,
   b) `/kostentraeger/kt_abrechnungsbereich_liste/kt_abrechnungsbereich/bedruckungsname/@V`,
   c) `/kostentraeger/ik_liste/ik/@V`,
   d) `/kostentraeger/gebuehrenordnung/@V`,
   e) `/kostentraeger/kt_abrechnungsbereich_liste/kt_abrechnungsbereich/@V`,
   f) `/kostentraeger/bezeichnung/suchname/@V`,
   g) `/kostentraeger/ortssuchname_liste/ortssuchname/@V`,
   h) `/kostentraeger/gueltigkeit/@V`
   i) `/kostentraeger/ik_liste/ik/gueltigkeit/@V`,
   j) `/kostentraeger/existenzbeendigung/aufnehmender_kostentraeger/@V`,
   k) `/kostentraeger/unz_kv_geltungsbereich_liste/unz_kv_geltungsbereich/@V` **und**
   l) `/kostentraeger/kt_abrechnungsbereich_liste/kt_abrechnungsbereich/gueltigkei t/@V`

   haben einen "amtlichen" Charakter, d. h. sie duerfen fuer den Anwender nicht veraenderbar sein (nur Anzeigefelder!).

2. Die Adressfelder (`/kostentraeger/adresse_liste/adresse/*`) koennen unter Beachtung der Formatvorgaben beliebig veraendert werden.
   a) Die vorgenommenen Adressaenderungen eines Kostentraegers, die in einer Folgeversion der KT-Stammdatei nicht enthalten sind, muessen auch nach dem Einspielen der neuen KT-Stammdaten im PVS erhalten bleiben.
   b) Die Software kennzeichnet den Kostentraeger, wenn bei ihm manuelle Korrekturen vorgenommen wurden, und gibt dem Anwender die Moeglichkeit die Originaldaten gemaess KT-Stammdatei wieder zu hinterlegen/aktivieren.

### 7.1.2 Temporaere Erweiterung

#### 7.1.2.1 Temporaere Erweiterung durch den Anwender

---

### P6-45 - Temporaere Erweiterung der KT-Stammdatei

**Typ:** PFLICHTFUNKTION ADT

Nach Massgabe der im Kapitel 2.2.2.1.7 aufgefuehrten Vorgaben darf die KT-Stammdatei temporaer erweitert werden:

1. Da neue Kassengruendungen nach Redaktionsschluss der fuer das Folgequartal gueltigen KT-Stammdatei erfolgen koennen, muessen neue Kostentraeger als **temporaere Kostentraeger-Stammsaetze** der KT-Stammdatei hinzugefuegt werden koennen, unabhaengig davon, ob ein IK ueber eine Versichertenkarte eingelesen oder (in Analogie zum Ersatzverfahren) manuell erfasst wurde.
2. Ein IK darf zu einem bestehenden KT-Stammsatz hinzugefuegt werden.

#### 7.1.2.2 Temporaere Erweiterung durch den Softwareverantwortlichen

---

### K6-46 - Temporaere Erweiterung der KT-Stammdatei durch den Softwareverantwortlichen

**Typ:** OPTIONALE FUNKTION ADT

Die von der KBV gelieferte aktuelle KT-Stammdatei kann bereits mit einem Update an die Anwender seitens des Softwareverantwortlichen **temporaer** erweitert werden. Es koennen sowohl neue Kostentraeger-Stammsaetze als auch neue IKs zu einem bestehenden KT-Stammsatz hinzugefuegt werden.

---

### P6-51 - "Dummy"-Datensatz (VKNR 74799)

**Typ:** PFLICHTFUNKTION ADT

Die Software stellt sicher, dass der Kostentraeger mit der VKNR 74799 im Rahmen der Abrechnung nicht an die KVen uebermittelt wird.

**Begruendung:**

Zu Testzwecken wurde fuer die gematik der Kostentraeger mit der VKNR 74799 in die Kostentraegerstammdatei aufgenommen.

**Akzeptanzkriterium:**

1. Die Software verarbeitet eGKs mit dem Kostentraeger (VKNR = 74799). Dazu gehoeren bspw. das Einlesen und die Uebernahme der Versichertendaten.
2. Die Software unterstuetzt die Bedruckung/Ausstellung von vertragsaerztlichen Formularen mit den Daten des Kostentraegers (VKNR = 74799) **nicht**.
3. Die Software stellt sicher, dass der Kostentraeger nicht in die Abrechnungsdatei geschrieben und uebertragen wird.

---

## 7.2 KV-Spezifika-Stammdateien (SDKV)

Mit den KV-Spezifika-Stammdateien werden spezielle Bedingungen der Kassenaerztlichen Vereinigungen definiert. Eventuelle Updates zu den KV-Spezifika-Stammdateien werden -- analog zur KT-Stammdatei -- quartalsweise mit dem Regelupdate der KBV "Datenkommunikation in der Arztpraxis,..." veroeffentlicht.

**Die KV-Spezifika-Stammdatei uebersteuert die KT-Stammdatei!**

---

### P6-100 - Einsatzpflicht KV-Spezifika-Stammdatei

**Typ:** PFLICHTFUNKTION ADT

1. Durch geeignete organisatorische Massnahmen ist sicherzustellen, dass dem Anwender rechtzeitig zum Quartalsbeginn jeweils die aktuell gueltige KV-Spezifika-Stammdatei fuer die Abrechnungssoftware zur Verfuegung steht.
2. Alle KV-spezifischen Angaben der jeweils zustaendigen KV muessen im Abrechnungssystem beim Anwender verfuegbar sein.
3. Die Abrechnungssoftware darf dem Anwender nur Zugriff auf die Vorgaben der zustaendigen Kassenaerztlichen Vereinigung gewaehren.

### 7.2.1 Verbindlichkeit und Gueltigkeit der SDKV

---

### P6-110 - Verbindlichkeit der KV-Spezifika-Stammdatei

**Typ:** PFLICHTFUNKTION ADT

Die bestehenden Datensaetze der ausgelieferten KV-Spezifika-Stammdatei der KBV duerfen fuer den Anwender nicht veraenderbar sein.

---

### P6-120 - Gueltigkeit der KV-Spezifika-Stammdatei / Update

**Typ:** PFLICHTFUNKTION ADT

Die im aktuellen Quartal ausgelieferte (Update-) Version der KV-Spezifika-Stammdateien gilt fuer den Einsatz ab dem Folgequartal (**nicht** fuer das aktuelle Abrechnungsquartal) und muss zu Beginn des Folgequartals eingesetzt werden (frueher nicht!).

**Anmerkung:**

Die fruehestmoegliche Einsatzmoeglichkeit der **Kostentraeger**-Stammdatei ist anders geregelt. Wegen der "Historienfuehrung" in der KT-Stammdatei darf diese Datei direkt nach Auslieferung zum Einsatz gelangen.

**Beispiel SDKV:**

| | |
|---|---|
| VERSAND | Mitte 2. Quartal 20xx |
| EINSATZ in der Praxis | Beginn 3. Quartal 20xx (frueher nicht!!) |

### 7.2.2 Besondere Funktionen

---

### P6-130 - Zulaessige Kostentraegerabrechnungsbereiche

**Typ:** PFLICHTFUNKTION ADT

Es duerfen nur die Datenpakete in einer KVDT-Datei gespeichert werden, die unter den Feldkennungen 9135 und 9138 aufgefuehrt sind. Der zulaessige Zeitrahmen (Inhalt der Feldkennung 9136 und 9137) ist hierbei zu beruecksichtigen.

---

### P6-140 - Zulaessige Kostentraegerabrechnungsbereiche

**Typ:** PFLICHTFUNKTION ADT

Nur die unter der Feldkennung 4106 der Satzart "kvx2" aufgefuehrten KT-Abrechnungsbereiche (KTAB) duerfen im Rahmen der ADT-Abrechnung verwendet werden.

---

### P6-145 - Zulaessige Scheinuntergruppe und zulaessige Abrechnungsgebiete

**Typ:** PFLICHTFUNKTION ADT

1. Nur die unter der Feldkennung 4239 der Satzart "kvx2" aufgefuehrten Scheinuntergruppen duerfen im Rahmen der ADT-Abrechnung verwendet werden.
2. Nur die unter der Feldkennung 4122 der Satzart "kvx2" aufgefuehrten Abrechnungsgebiete duerfen mit der entsprechenden Scheinuntergruppe im Rahmen der ADT-Abrechnung verwendet werden.

### 7.2.3 Hinweise zur Satzart "kvx3" (SKT-Abrechnungs-Zusatzangaben)

---

### P6-150 - Handling der Felder 9402, 9403 und 9404

**Typ:** PFLICHTFUNKTION ADT

Die unter den Feldern

a) 9402 (zusaetzlich erforderliche, zulaessige Werte in Feld "4123" (Personenkreis/Untersuchungskategorie))
b) 9403 (erforderliche Zusatzangabe in Feld "4124" (SKT-Zusatzangabe)) und
c) 9404 (zusaetzlich erforderliche Abrechnungsinformation SKT)

in Satzart "kvx3" der KV-Spezifika-Stammdatei geforderten zusaetzlichen Angaben im Rahmen der ADT-Abrechnung von SKT-Faellen muessen nur dann durch den Anwender erfolgen, wenn die Information(en) in der Arztpraxis auch tatsaechlich vorliegen (z. B. umgedruckt auf einem papierenen Abrechnungsschein, beispielsweise Ausdruck der SKT-Zusatzangabe in Druckzeile 6 im Feld "Versicherten-Nr." des Personalienfeldes).

Die gemaess den Definitionen in den Feldern 9402, 9403 und 9404 der KV-Spezifika-Datei geforderten Angaben in den Feldern "4123", "4124", "4125" bzw. "4126" der ADT-Datei sind also im Sinne der KVDT-Datensatzbeschreibung zur Abrechnung keine Muss-Felder!

Der Anwender muss systemseitig mittels Warnhinweis zur Erfassung der zusaetzlichen erforderlichen Abrechnungsinformation(en) gemaess der FKen 9402, 9403, 9404, Satzart "kvx3" aufgefordert werden. Eine Weiterverarbeitung muss nach dem Warnhinweis jederzeit moeglich sein. Eine "abrechnungsverhindernde" Fehlermeldung und/oder die Erfassung und Uebertragung bzw. automatische Generierung und Uebertragung von undefinierten "Ersatzwerten" ist nicht zulaessig.

**Anmerkung:**

Eine KV kann ueber die Satzart "kvx8" eine Praezisierung zu den SKT-Angaben veranlassen; jedoch sind diese Angaben nicht programmtechnisch auswertbar (z.B.: Aktenzeichen bei Sozialaemtern ist unbedingt erforderlich)

---

### P6-160 - Versichertenkarte und Satzart "kvx3"

**Typ:** PFLICHTFUNKTION ADT

Falls die Daten einer Versichertenkarte Grundlage fuer die Abrechnung sind -- unabhaengig davon, ob die Versichertenkarte eingelesen oder im Ersatzverfahren erfasst wird - darf die Software, die mit der Satzart "kvx3" definierten Zusatzangaben bzw. Restriktionen nicht anwenden.

**Begruendung:**

Seit dem 01.04.2000 wurden Versichertenkarten auch fuer Besondere Personengruppen (z.B. BVG) der "Sonstigen Kostentraeger" (vgl. Definition aus 2.2.1.2) als Ersatz fuer die "papierenen" Abrechnungsscheine eingefuehrt.

Diese Versichertenkarten enthalten grundsaetzlich keine zusaetzlichen SKT-Abrechnungsinformationen, wie z. B. die Angabe eines Aktenzeichens. Die ggf. mit der Satzart "kvx3" definierten Zusatzangaben liegen in einer Arztpraxis entsprechend faktisch nicht vor und sind in diesen speziellen Faellen fuer die Abrechnung auch nicht relevant (vgl. Datensatzbeschreibung SDKV, Kapitel Erlaeuterung zur Satzart "kvx3" [KBV_ITA_VGEX_Datensatzbeschreibung_SDKV]). Die mit der Satzart "kvx3" geforderten Zusatzangaben und Restriktionen bzgl. zulaessiger Satzarten und zulaessiger Versichertenart gelten entsprechend in diesen Faellen nicht.

**Akzeptanzkriterium:**

1. Die Software zeigt einen (Warn-)Hinweis zur Erfassung der zusaetzlich erforderlichen Abrechnungsinformationen bzw. Restriktionen gemaess der Satzart "kvx3" an, wenn:
   a) Feld FK 4109 nicht vorhanden ist **und**
   b) die Seriennummer der VKNR >= 800 (und der Kostentraegerabrechnungsbereich (KTAB) = 00 - 09) oder die Seriennummer der VKNR < 800 und der KTAB != 00 ist **und**
   c) weder Feld FK 3105 noch Feld FK 3119 vorhanden ist.

---

## 7.3 Arztverzeichnis-Stammdatei (SDAV)

Die Arztverzeichnis-Stammdatei (SDAV) auf Grundlage der Datensatzbeschreibung SDAV0308.nn wird in der KBV anhand des Bundesarztregisters erzeugt und enthaelt ausschliesslich Betriebsstaetten- und Arztnummern ueber die zu einem Stichtag zur vertragsaerztlichen Abrechnung berechtigten Personen und Einrichtungen.

Sie dient im Wesentlichen der Qualitaetssteigerung der Abrechnungsdaten, die im Rahmen der Laborabrechnung erstellt werden.

---

### P6-200 - Einsatzpflicht SDAV

**Typ:** PFLICHTFUNKTION ADT

Durch geeignete organisatorische Massnahmen ist sicherzustellen, dass allen Anwendern, die Laborauftragsfaelle (Muster 10 bzw. 10A) abrechnen, die gueltige Arztverzeichnis-Stammdatei (SDAV) auf Grundlage der Datensatzbeschreibung SDAV0308.nn fuer die Abrechnungssoftware zur Verfuegung steht.

**Anmerkung:**

Die SDAV-Lieferung soll dazu beitragen, den Bestand an Betriebsstaetten- und Arztnummern im Labor/in der Laborgemeinschaft so aktuell wie moeglich zu halten. Das ist insbesondere von Bedeutung, wenn die Zuordnung des ueberweisenden Arztes nicht direkt durch die Erfassung der Abrechnungsnummer vom Laborauftragsschein, sondern durch indirekte Schluessel erfolgt.

---

## 7.4 PLZ-Stammdatei der KBV

Zur **Qualitaetssicherung** der **durch Ersatzverfahren** aufgenommenen Postleitzahlen, welche in den Abrechnungsdatensaetzen ueber Feld 3112 bzw. 3121 uebertragen werden, wird die PLZ-Stammdatei der KBV fuer den **verpflichtenden Einsatz in den Arztpraxen** vorgeschrieben. Fuer amtliche Postleitzahlen von der Versichertenkarte gilt diese Pruefung nicht.

Eventuelle Updates zur PLZ-Stammdatei werden quartalsweise mit dem Regelupdate der KBV veroeffentlicht.

---

### P6-400 - Einsatzpflicht der PLZ-Stammdatei

**Typ:** PFLICHTFUNKTION ADT

Durch geeignete organisatorische Massnahmen ist sicherzustellen, dass rechtzeitig zum Quartalsbeginn Pruefungen mit der jeweils aktuell gueltigen Postleitzahl-Stammdatei der KBV in die Abrechnungssoftware implementiert sind.

---

### P6-410 - Unveraenderbarkeit der PLZ-Stammdatei

**Typ:** PFLICHTFUNKTION ADT

Die bestehenden Datensaetze der PLZ-Stammdatei der KBV duerfen fuer den Anwender nicht veraenderbar sein.

---

### P6-420 - Gueltigkeit der PLZ-Stammdatei

**Typ:** PFLICHTFUNKTION ADT

Die im aktuellen Quartal ausgelieferte (Update-) Version der PLZ-Stammdatei der KBV kann bereits im laufenden Quartal eingesetzt werden; der Einsatz dieser PLZ-Stammdatei muss jedoch spaetestens mit Beginn des Folgequartals erfolgen. Die ausgelieferte Version der PLZ-Stammdatei gilt so lange, bis eine neue Version geliefert wird.

---

## 7.5 GO-Stammdatei

### 7.5.1 Zielbestimmung

Mit der Einfuehrung des EBM2000plus wurde eine GO-Stammdatei zur Verfuegung gestellt (Einfuehrungstermin 1.4.2005). Zweck der EBM-Stammdatei [KBV_ITA_VGEX_Datensatz_SDEBM] in der jeweiligen EBM-Version ist es, die EBM-spezifischen Inhalte, Bedingungen und Regeln sowie die kv-spezifischen Besonderheiten zu den Gebuehrenziffern in EDV-verarbeitbarer Form abzubilden.

Arztpraxen sollen dadurch in die Lage versetzt werden, aktuelle Bestimmungen zur Gebuehrenordnung mit Einbeziehung spezieller Regeln anwenden zu koennen. Eine hoehere Qualitaet der Abrechnungsdaten und praezisere Kalkulationen koennen somit erzielt werden.

Darueber hinaus wurde durch die Definition patientengerechter Leistungstexte die Grundlage fuer die Patientenquittung geschaffen.

### 7.5.2 Lieferung der Stammdaten durch die jeweilige KV

Es wird eine EBM-Stammdatei mit dem bundeseinheitlichen GNR-Stamm geben, sowie von den KVen modifizierte und um die KV-spezifischen GNRn und Inhalte erweiterten Stammdateien.

Weder fuer die korrekte Umsetzung der Schnittstellenbeschreibung sowie deren Inhalte kann ein Gewaehrleistungsanspruch geltend gemacht werden.

### 7.5.3 Geltungsbereich

Die Implementierung der EBM-spezifischen Inhalte ist dem jeweiligen Systemhaus freigestellt. Es besteht keine Verpflichtung, Pruefungen und Regeln nach Massgabe der SDEBM vollstaendig zu implementieren.

### 7.5.4 Einsatzpflicht

Aufgrund der Einbindung der gesetzlich geforderten Patientenquittungstexte in die GO-Stammdatei besteht eine Einsatzpflicht derselben.

### 7.5.5 Umgang mit der EBM-Stammdatei

---

### P6-700 - Einsatzpflicht

**Typ:** PFLICHTFUNKTION ADT

Durch geeignete organisatorische Massnahmen ist sicherzustellen, dass dem Anwender rechtzeitig zu Quartalsbeginn jeweils die aktuell gueltige Datengrundlage der SDEBM innerhalb des Abrechnungssystems zur Verfuegung steht.

---

### P6-710 - Gueltigkeitsquartal

**Typ:** PFLICHTFUNKTION ADT

Die zum Update-Termin ausgelieferte EBM-Stammdatei ist fuer den Einsatz des Folgequartals bestimmt (Gueltigkeitszeitraum im Header definiert).

---

### P6-720 - Aenderungs- und Erweiterbarkeit

**Typ:** PFLICHTFUNKTION ADT

Die Software muss dem Anwender die Moeglichkeit bieten die EBM-Datengrundlage zu aendern bzw. zu erweitern.

**Begruendung:**

Aufgrund von Vertragsabschluessen im Laufe des Quartals bzw. Fehlern in der ausgelieferten EBM-Stammdatei koennen Erweiterungs- bzw. Korrekturmassnahmen im Datenstamm notwendig werden, um Abrechnungsprobleme zu vermeiden.

**Akzeptanzkriterium:**

1. Die Software muss dem Anwender die Moeglichkeit bieten, die EBM-Datengrundlage zu aendern bzw. zu erweitern.

**Hinweis:**

Korrekturmassnahmen oder Erweiterungen der EBM-Datengrundlage duerfen bei Bedarf auch vom Softwarehaus als Service fuer ihre Anwender durchgefuehrt werden.

---

### P6-740 - Historisierung, Quartalsbezug

**Typ:** PFLICHTFUNKTION ADT

Die EBM-Stammdatei beinhaltet keine Historisierung. Eine Historisierungsfunktion, die beispielsweise noch bei der Abrechnung von Vorquartalsfaellen Sinn macht, ist durch das Abrechnungssystem zu realisieren.

Die EBM-Stammdatei ist "quartalstreu" einzusetzen.

---

### P6-750 - KV-spezifische EBM-Stammdateien

**Typ:** PFLICHTFUNKTION ADT

Die Software muss dem Anwender als primaere EBM-Datengrundlage die Daten der EBM-Stammdatei seiner zustaendigen KV zur Verfuegung stellen.

**Begruendung:**

Die Softwarehaeuser erhalten im Rahmen des Quartalsupdate sowohl die regionalen, um KV-spezifische Gebuehrennummern und Inhalte erweiterten EBM-Stammdateien aller Kassenaerztlichen Vereinigungen als auch die bundeseinheitliche EBM-Stammdatei der KBV.

Bedingt durch den definierten EBM-Lieferprozess koennen allerdings in der bundeseinheitlichen EBM-Stammdatei auch kurzfristig getroffene Beschluesse des Bewertungsausschusses im Gegensatz zu den regionalen EBM-Stammdateien beruecksichtigt sein.

**Akzeptanzkriterium:**

1. Die Software stellt dem Anwender als primaere EBM-Datengrundlage die Daten der EBM-Stammdatei seiner zustaendigen KV zur Verfuegung.
2. Falls der Anwender eine Gebuehrennummer im Rahmen der Abrechnung zur Leistungsdokumentation erfasst, welche in der regionalen EBM-Stammdatei nicht existiert, kann die Software auf die bundeseinheitliche EBM-Stammdatei zugreifen.

---

### K6-760 - Anzeigefunktion

**Typ:** OPTIONALE FUNKTION ADT

Die Software zeigt dem Anwender in geeigneter Weise die essenziellen Inhalte der EBM-Stammdatei an.

### 7.5.6 Anwendung der EBM-Stammdatei

---

### K6-770 - Echtzeitpruefungen

**Typ:** OPTIONALE FUNKTION ADT

Sofern gegen (Pruef-)Bedingungen der EBM-Stammdatei verstossen wird, darf die Software systemseitige Aenderungen von vom Anwender im Rahmen der Leistungsdokumentation dokumentierten GNRn in Echtzeit durchfuehren.

**Begruendung:**

Aerzte duerfen im Rahmen der Leistungserfassung unterstuetzt werden, um Fehleingaben zu vermeiden und um die Qualitaet der Abrechnungsdaten zu erhoehen.

**Akzeptanzkriterium:**

1. Sofern gegen (Pruef-)Bedingungen (Sektion `//gnr/bedingung/` der EBM-Stammdatei) verstossen wird, darf die Software systemseitige Aenderungen von vom Anwender im Rahmen der Leistungsdokumentation dokumentierten GNRn in Echtzeit -- zum Zeitpunkt der Erfassung von Leistungen -- durchfuehren.
2. Der Anwender muss die systemseitigen Aenderungen zur Leistungsdokumentation zum Zeitpunkt der Aenderungen erkennen und zuruecknehmen koennen.

**Hinweis:**

Systemseitige Aenderungen (GNR streichen, hinzufuegen, ersetzen) bzgl. der vom Anwender dokumentierten Leistungen duerfen durch Echtzeitpruefungen **nicht** erfolgen, wenn Regelmechanismen der EBM-Stammdatei (Sektion `//gnr/regel/` der EBM-Stammdatei) zugrunde liegen. Auswirkungen dieser Regelpruefung auf die Leistungsdokumentation duerfen lediglich **hinweisenden Charakter** haben.

---

### K6-780 - Abschluss-Pruefungen

**Typ:** OPTIONALE FUNKTION ADT

Bezogen auf die verschiedenen Bezugszeitraeume (Behandlungstag, Zyklusfall, ...) sind Abschluss-Pruefungen zulaessig.

1. Systemseitige Aenderungen von GNRn (bzgl. der vom Anwender dokumentierten GNRn) duerfen durch Abschlusspruefungen auf Basis der (Pruef-)Bedingungen und von Regeln der EBM-Stammdatei erfolgen.
2. Der Anwender muss systemseitige Aenderungen zur Leistungsdokumentation erkennen und ggf. zuruecknehmen koennen.
3. Die Speicherung von Leistungen in die ADT-Abrechnungsdatei muss auch **gegen die (Pruef-)Bedingungen und Regeln** der EBM-Stammdatei moeglich sein.

---

### K6-790 - Existenzpruefung

**Typ:** OPTIONALE FUNKTION ADT

Ist die GNR0 nicht in der Stammdatei vorhanden, dann gilt:

1. Es erfolgt ein Warnhinweis,
2. Die GNR0 darf nur mit besonderer Quittierung im Abrechnungsdatensatz gespeichert werden,
3. Die Aufnahme der GNR in den Stammsatz muss moeglich sein.

---

### K6-800 - Pruefungen gegen die SDEBM

**Typ:** OPTIONALE FUNKTION ADT

Existiert eine GNR0 in der EBM-Stammdatei, empfiehlt sich folgende Pruefreihenfolge fuer die Kategorien:

1. Bedingungen,
2. KV-Bedingungen,
3. Regeln

Sofern mehrere Regeln fuer eine GNR existieren, gilt prinzipiell der EBM-Grundsatz, dass fuer den Arzt bestmoeglich beregelt wird. Die Reihenfolge der Regeln kann also relevant sein.

**Hinweis:**

EBM-Zusatznummern sind abgeleitete Varianten von bundeseinheitlichen Gebuehrennummern (GNR) im Wertebereich 00001-88999, entsprechend gekennzeichnet durch einen Zusatz im Wertebereich A-Z (= Buchstabensuffix).

Es gilt der Grundsatz, dass alle in der EBM-Stammdatei abgebildeten Regeln und Bezuege zu einer GNR vornehmlich mit der 5-stelligen Ziffer ohne Buchstaben-Suffix angegeben werden, jedoch alle Zusatznummern mit Buchstaben-Suffix mit gleicher 5-stelliger Ziffer einschliessen. Der Buchstaben-Suffix ist somit fuer die Regeln und Bezuege zu einer Ziffer irrelevant, sofern er nicht explizit angegeben wird und keine von der 5-stelligen GNR abweichenden Regeln oder Bezuege angegeben sind. Dies gilt auch fuer den impliziten Bezug auf die aktuelle Ziffer bei der Anzahlbedingung.

Ob dieser Grundsatz generell auch fuer die KV-spezifischen EBM-Zusatznummer im Wertebereich 89.000 bis 99.999 und zusaetzliche KV-spezifische GNR mit dem Attribut `ehd/body/gnr_liste/gnr/@USE <> 74` gilt, sollte vor einer moeglichen Implementierung von entsprechenden GNR-Pruefungen mit der jeweils zustaendigen Kassenaerztlichen Vereinigung eroertert werden.

---

### P6-801 - Geschlechtsbezug einer GOP bei "unbestimmtem" und "diversem" Geschlecht

**Typ:** PFLICHTFUNKTION ADT

Falls das Geschlecht eines Patienten "unbestimmt" oder "divers" ist, darf die Software nicht ueberpruefen, ob zu der vom Anwender im Rahmen der Leistungsdokumentation angegebenen GOP ein Geschlechtsbezug in der GO-Stammdatei definiert ist und eine Uebereinstimmung dieser Geschlechtsangaben vorliegt.

**Begruendung:**

Grundlage ist Paragraph 22, Abs. 3 des Personenstandsgesetzes.

Personen mit Varianten der Geschlechtsentwicklung koennen weder dem weiblichen noch dem maennlichen Geschlecht zugeordnet werden. In diesem Fall kann ein Patient ein 'unbestimmtes' oder 'diverses' Geschlecht besitzen. Daher koennen Patienten mit "unbestimmten oder diversen Geschlecht" nicht grundsaetzlich von geschlechtsspezifischen Leistungen ausgeschlossen werden.

**Akzeptanzkriterium:**

1. Falls das Geschlecht eines Patienten "unbestimmt" oder "divers" ist (Inhalt des Feldes FK 3110 gleich X bzw. D), ermoeglicht die Software dem Anwender die Eingabe einer GOP auch bei abweichender Geschlechtsdefinition zu dieser GOP im V-Attribut des Elements `/gnr/bedingung/administrative_gender_cd` der GO-Stammdatei.
   a) Die Software zeigt keinen Warnhinweis an und uebertraegt mit der Abrechnung die vom Anwender angegebene GOP.

### 7.5.7 Abrechnungsunterstuetzung

---

### P6-804 - Abrechnungsunterstuetzung bei vorhandenen Sub-GOPen

**Typ:** PFLICHTFUNKTION ADT

Die Software muss die altersklassenunspezifischen Versichertenpauschalen- und die Zusatzpauschalen bei Terminvermittlung automatisch in die altersklassenspezifischen Zusatznummern unter Verwendung der EBM-Stammdatei umsetzen.

**Begruendung:**

Im EBM wurden zum 1. Oktober 2013 altersabhaengige Versichertenpauschalen fuer Haus- und Kinderaerzte ("altersklassenspezifische kodierte Zusatznummern") eingefuehrt. Zum 1. September 2019 und 1. Januar 2023 wurden weitere altersabhaengige Zusatzpauschalen fuer die Behandlung aufgrund einer Terminvermittlung ebenfalls in Form altersklassenspezifisch kodierter Zusatznummern eingefuehrt.

Gemaess den Beschluessen im Bewertungsausschuss nach Paragraph 87 Abs. 1 Satz 1 SGB V muss eine automatisierte Umsetzung dieser Pauschalen in die altersklassenspezifischen Zusatznummern erfolgen. Im Rahmen der Abrechnung duerfen ausschliesslich die altersklassenspezifisch differenzierten Versichertenpauschalen und Zusatzpauschalen uebertragen werden.

**Akzeptanzkriterium:**

1. Falls der Anwender eine Versichertenpauschale oder eine Zusatzpauschale fuer die Behandlung aufgrund einer Terminvermittlung zur Leistungsdokumentation ansetzt und die Pauschale in altersklassenspezifische Zusatznummern differenziert ist, muss die Software diese Pauschale in die altersklassenspezifisch differenzierte Zusatznummer automatisch umsetzen. Die Software beruecksichtigt die hinterlegten Altersregeln in Abhaengigkeit vom Alter des Patienten unter Beachtung der Regelung in der Allgemeinen Bestimmung 4.3.5 des EBM.
   a) Falls aufgrund einer unvollstaendigen oder fehlenden Angabe des Geburtsdatums des Patienten die Altersgruppe automatisch nicht eindeutig bestimmt werden kann (z.B., wenn das Geburtsdatum unbekannt ist), dann muss das System dem Anwender die Moeglichkeit geben, die Leistungssubstitution manuell durchzufuehren.
2. Das System muss die Leistungssubstitution fuer den Anwender transparent gestalten.

**Hinweis:**

Die altersklassenspezifische Kennzeichnung erfolgt innerhalb der Regel "sub_gop_liste" zur Versicherten- und Zusatzpauschale in der EBM-Stammdatei. Die Regel ist innerhalb eines bestimmten Bezugsraums gueltig und definiert die Zusatznummern in Abhaengigkeit von Altersbedingungen (`"./regel/sub_gop_liste/bezugsraum/gnr/altersbedingung_liste/"`).

### 7.5.8 Bedingungen und Auswirkungen der Prueffunktionen /Pruefmechanismen

---

### P6-810 - Protokollierung und Anzeige der Aenderungen zur Leistungsdokumentation

**Typ:** PFLICHTFUNKTION ADT

Wird eine systemseitige Aenderung zur Leistungsdokumentation auf Basis der Abrechnungsfaehigkeitspruefungen vorgenommen, muessen die Aenderungen protokolliert und angezeigt werden koennen.

---

### P6-820 - Ruecknahme von Aenderungen

**Typ:** PFLICHTFUNKTION ADT

Manuelle oder systemseitige Aenderungen zur Leistungsdokumentation muessen vom Anwender wieder rueckgaengig gemacht werden koennen.

---

### P6-830 - Speicherung entgegen den Pruefbedingungen /Regeln

**Typ:** PFLICHTFUNKTION ADT

Die Speicherung von Leistungen in die ADT-Abrechnungsdatei muss auch **entgegen den Bedingungen und Regeln** der EBM-Stammdatei moeglich sein.

---

## 7.6 Operationen- und Prozedurenschluesselstammdatei (SDOPS)

Die OPS-Stammdatei ([SDOPS]) der KBV auf Basis der Schnittstellenbeschreibung SDOPS wird ueber das Quartalsupdate der KBV zur Verfuegung gestellt.

Fuer die Einbindung in die Software kann die OPS-Stammdatei unter Beruecksichtigung der inhaltlichen Unveraenderbarkeit (siehe KP6-860) strukturell angepasst werden, z.B. durch Ueberfuehrung in ein relationales Datenbankformat.

### 7.6.1 Integration der OPS-Stammdatei

---

### KP6-840 - Einsatzpflicht

**Typ:** KONDITIONALE PFLICHTFUNKTION

In der Software muessen die Daten der gueltigen OPS-Stammdatei zur Verwendung in der Software hinterlegt werden.

**Begruendung:**

Im Paragraph 295, Absatz 1 SGB V ist geregelt, dass die Verschluesselung von durchgefuehrten Operationen und sonstige Prozeduren mit der jeweils gueltigen Fassung des Prozedurenschluessels zu erfolgen hat. Die bereitgestellte Version der SDOPS repraesentiert die jeweils gueltige Fassung der Prozedurenschluessel zur Anwendung im Geltungsbereich des Paragraph 295 SGB V.

**Akzeptanzkriterium:**

1. Die OPS-Stammdatei gemaess [SDOPS] der KBV ist in der Software eingebunden und wird in der gueltigen Version verwendet.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### KP6-850 - Gueltigkeit

**Typ:** KONDITIONALE PFLICHTFUNKTION

Die im aktuellen Quartal bereitgestellte Version der OPS-Stammdatei gilt fuer den Einsatz mit Beginn des Folgequartals, solange bis eine neue Version der OPS-Stammdatei zur Verfuegung steht.

**Begruendung:**

Im Paragraph 295, Absatz 1 SGB V ist geregelt, dass die Verschluesselung von durchgefuehrten Operationen und sonstige Prozeduren mit der jeweils gueltigen Fassung des Prozedurenschluessels zu erfolgen hat. Die bereitgestellte Version der SDOPS repraesentiert die jeweils gueltige Fassung der Prozedurenschluessel zur Anwendung im Geltungsbereich des Paragraph 295 SGB V.

**Akzeptanzkriterium:**

1. Die Software stellt sicher, dass die jeweils von der KBV im aktuellen Quartal ausgelieferte OPS-Stammdatei mit Beginn des Folgequartals eingesetzt wird und solange im Einsatz ist, bis eine neue Version der OPS-Stammdatei zur Verfuegung steht.
2. Die Software muss dem Anwender die Moeglichkeit bieten, sich den Gueltigkeitsstand der eingebundenen Stammdatei anzeigen zu lassen.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### KP6-860 - Inhaltliche Unveraenderbarkeit

**Typ:** KONDITIONALE PFLICHTFUNKTION

Die Datensaetze der OPS-Stammdatei [SDOPS] duerfen inhaltlich nicht veraendert werden.

**Begruendung:**

Im Paragraph 295, Absatz 1 SGB V ist geregelt, dass die Verschluesselung von durchgefuehrten Operationen und sonstige Prozeduren mit der jeweils gueltigen Fassung des Prozedurenschluessels zu erfolgen hat. Die bereitgestellte Version der [SDOPS] repraesentiert die jeweils gueltige Fassung der Prozedurenschluessel zur Anwendung im Geltungsbereich des Paragraph 295 SGB V.

**Akzeptanzkriterium:**

1. Die Software stellt sicher, dass die Daten der OPS-Stammdatei [SDOPS] vom Anwender inhaltlich nicht veraendert werden koennen.
2. Die Software stellt sicher, dass die Daten der OPS-Stammdatei der KBV waehrend ggf. notwendiger Transformationen zum Beispiel in ein anderes Format inhaltlich nicht veraendert werden.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

### 7.6.2 Funktionale Anforderungen/ Anwendung der OPS-Stammdatei

---

### KP6-870 - Existenzpruefung

**Typ:** KONDITIONALE PFLICHTFUNKTION

Die Software muss pruefen und sicherstellen, dass ein vom Anwender eingegebener OP-Schluessel in der aktuellen OPS-Stammdatei vorhanden ist.

**Begruendung:**

Im Paragraph 295, Absatz 1 SGB V ist geregelt, dass die Verschluesselung von durchgefuehrten Operationen und sonstige Prozeduren mit der jeweils gueltigen Fassung des Prozedurenschluessels zu erfolgen hat. Die bereitgestellte Version der SDOPS repraesentiert die jeweils gueltige Fassung der Prozedurenschluessel zur Anwendung im Geltungsbereich des Paragraph 295 SGB V.

**Akzeptanzkriterium:**

1. Die Software prueft, ob der angegebene OP-Schluessel als Inhalt des XML-Elementes `../opscode_liste/opscode/@V` der aktuellen OPS-Stammdatei vorhanden ist.
2. Falls der vom Anwender eingegebene OP-Schluessel in der OPS-Stammdatei nicht vorhanden ist, muss die Software folgendes sicherstellen:
   a) Das fuer den Anwender ersichtlich ist, dass der OP-Schluessel nicht in der OPS-Stammdatei existiert und daher nicht zur Abrechnung verwendet werden darf.
   b) Unterbinden einer Uebertragung des nicht vorhandenen OPS-Schluessels in die Abrechnungsdatei.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### KP6-871 - Seitenlokalisation zum OP-Schluessel

**Typ:** PFLICHTFUNKTION ADT

Die Software muss pruefen und sicherstellen, dass ein dokumentierter OPS nicht ohne Seiten-lokalisation uebermittelt wird, wenn der OPS-Code eine Seitenlokalisation erfordert.

**Begruendung:**

Im Paragraph 295, Absatz 1 SGB V ist geregelt, dass die Verschluesselung von durchgefuehrten Operationen und sonstige Prozeduren mit der jeweils gueltigen Fassung des Prozedurenschluessels zu erfolgen hat. Die bereitgestellte Version der [SDOPS] repraesentiert die jeweils gueltige Fassung der Prozedurenschluessel zur Anwendung im Geltungsbereich des Paragraph 295 SGB V.

**Akzeptanzkriterium:**

1. Die Software prueft und stellt sicher, dass ein dokumentierter OPS-Code nicht ohne Seitenlokalisation uebermittelt wird, wenn der OPS eine Seitenlokalisation erfordert:
   a) Wenn ein zu dokumentierender OPS-Code in der OPS-Stammdatei [SDOPS] mit dem Kennzeichen `../opscode_liste/opscode/kzseite` gleich "J" definiert ist, muss die Software sicherstellen, dass in der Abrechnung zu dem OPS-Code **eine** Seitenlokalisation mittels FK 5041 uebertragen wird. (siehe auch KP2-910, 2))
   b) Wenn ein zu dokumentierender OPS-Code in der OPS-Stammdatei [SDOPS] mit dem Kennzeichen `../opscode_liste/opscode/kzseite` gleich "N" definiert ist, muss die Software sicherstellen, dass in der Abrechnung **keine** Seitenlokalisation mittels FK 5041 uebertragen wird.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### KP6-872 - Seitenlokalisation zum OP-Schluessel 5-622.5

**Typ:** PFLICHTFUNKTION ADT

Die Software muss sicherstellen, dass bei dem OPS-Code 5-662.5 immer eine Seitenlokalisation uebermittelt wird.

**Begruendung:**

Die Abweichung der Seitenangabe im Anhang 2 bzw. in der GO-Stamm beruht auf dem Beschluss des Bewertungsausschusses nach Paragraph 87 Abs. 1 Satz 1 SGB V zur Aenderung des Einheitlichen Bewertungsmasstabes (EBM) in seiner 167. Sitzung (schriftliche Beschlussfassung), mit Wirkung zum 1. Januar 2009, in der sich darauf verstaendigt wurde, dass bei der Angabe des OPS 5-622.5 im vertragsaerztlichen Versorgungsbereich eine entsprechende Angabe der Seitenlokalisation R (rechts) bzw. L (links) zur Spezifizierung der operativen Massnahme anzugeben ist.

**Akzeptanzkriterium:**

1. Die Software stellt sicher, dass bei dem OPS-Code 5-622.5 immer eine Seitenangabe gefordert und uebertragen wird.
   a) Die Seitenangabe wird in der FK 5041 uebertragen.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

**Hinweis:**

Die Regelungen der Anforderung KP6-871 greifen fuer den OPS-Code 5-622.5 nicht.
