# 2.6 ASV-Abrechnung

> Quelle: KBV_ITA_VGEX_Anforderungskatalog_KVDT, Version 6.06, 9. März 2026, Seiten 127-128

---

## 2.6.1 Vertragliche Grundlage

Vertragliche Grundlage für die ASV-Abrechnung ist § 6, Absatz 3 der "Vereinbarung gemäß § 116b Abs. 6 Satz 12 SGB V über Form und Inhalt des Abrechnungsverfahrens sowie die erforderlichen Vordrucke für die ambulante spezialfachärztliche Versorgung (ASV-AV)" ([KBV_ASV_Abrechnungsvereinbarung]) zwischen dem GKV-Spitzenverband und der Deutschen Krankenhausgesellschaft e. V. sowie der Kassenärztlichen Bundesvereinigung:

*"Das Nähere zu den technischen Vorgaben für die Praxisverwaltungssystemhersteller für die Abrechnung von ambulanten spezialfachärztlichen Leistungen der an der vertragsärztlichen Versorgung teilnehmenden ASV-Berechtigten bei Beauftragung der Kassenärztlichen Vereinigung gemäß § 116b Abs. 6 Satz 1 SGB V regelt die KBV."*

**Hinweis:**

Das Institut des Bewertungsausschusses veröffentlicht auf seiner Webseite ([IDB_ASV]) maschinell verarbeitbare Listen (bspw. CSV-Dateien), welche die abrechnungsfähigen Leistungen der ASV abbilden. Diese Dateien basieren auf den Appendizes, in denen der Gemeinsame Bundesausschuss (G-BA) den Behandlungsumfang für jede ASV-Indikation definiert.

---

### P21-001 - Realisierungspflicht ASV-Abrechnung

**Typ:** PFLICHTFUNKTION ADT / ASV-ABRECHNUNG

Die Software muss die Erfassung, Speicherung und Übermittlung von Leistungen im Rahmen der ASV ermöglichen.

**Begründung:**

Vertragliche Grundlage ist § 6, Absatz 3 der ASV-AV in Verbindung mit § 116b, Absatz 6, Satz 12 SGB V.

**Akzeptanzkriterium:**

1. Die Software muss es dem Anwender ermöglichen, Leistungen im Rahmen der ASV zu erfassen und zu speichern.
2. Die Software überträgt Leistungen, welche im Rahmen der ASV erfasst wurden, in den Abrechnungsdatensatz nach den Vorgaben des Abschnitts "Integration der ASV-Abrechnung in das ADT-Datenpaket" aus [KBV_ITA_VGEX_Datensatzbeschreibung_KVDT].
3. Die Software beachtet bei der ~~Bedruckung~~ Ausstellung vertragsärztlicher Formulare die Vorschriften des Abschnitts "Ambulante spezialärztliche Versorgung (ASV)" aus [KBV_ITA_VGEX_Anforderungskatalog_Formularbedruckung].

---

### P21-005 - Anlage und Verwaltung von ASV-Teamnummer(n)

**Typ:** PFLICHTFUNKTION ADT / ASV-ABRECHNUNG

Die Software muss dem Anwender die Anlage und Verwaltung seiner ASV-Teamnummer(n) in den Betriebsstätten-Stammdaten ermöglichen.

**Begründung:**

Vertragliche Grundlage ist § 6, Absatz 3 der ASV-AV in Verbindung mit § 116b, Absatz 6, Satz 12 SGB V.

Ein Vertragsarzt/Vertragspsychotherapeut kann Mitglied in mehreren ASV-Teams sein und muss somit ggf. mehrere ASV-Teamnummern anlegen und verwalten können.

Des Weiteren können mehrere Vertragsärzte/Vertragspsychotherapeuten einer Betriebsstätte Mitglied in einem oder mehreren ASV-Teams sein.

**Akzeptanzkriterium:**

1. Die Software muss es jedem Anwender ermöglichen, seine ASV-Teamnummer(n) in den Betriebsstätten-Stammdaten anzulegen und zu verwalten.
2. Die Software überträgt mit der Abrechnung die vom Anwender angegebene(n) ASV-Teamnummer(n) im Feld FK 0222 (ASV-Teamnummer) im "Betriebsstättendaten-Datensatz ("besa") der KVDT-Datei.

---

### P21-010 - Kennzeichnung von GOPen mit einer ASV-Teamnummer

**Typ:** PFLICHTFUNKTION ADT / ASV-ABRECHNUNG

Die Software muss dem Anwender die Kennzeichnung von GOPen im Rahmen der Leistungsdokumentation mit einer ASV-Teamnummer ermöglichen.

**Begründung:**

Vertragliche Grundlage ist § 6, Absatz 3 der ASV-AV in Verbindung mit § 116b, Absatz 6, Satz 12 SGB V.

**Akzeptanzkriterium:**

1. Die Software muss es dem Anwender ermöglichen, GOPen, die der Anwender im Rahmen der Leistungsdokumentation erfasst, mit einer definierten ASV-Teamnummer zu kennzeichnen.
2. Die Software überträgt mit der Abrechnung die zur GOP angegebene ASV-Teamnummer in Feld FK 5100 (ASV-Teamnummer des Vertragsarztes).
