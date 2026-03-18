# 2.7 Unterstützung im Rahmen der digitalen Übermittlung der Überweisung (Muster 6)

> Quelle: KBV_ITA_VGEX_Anforderungskatalog_KVDT, Version 6.06, 9. März 2026, Seiten 129-132

---

### K26-01 - Umfang der Umsetzung des elektronischen Auftrags mittels des digitalen Musters 6 in der Arzt-zu-Arzt-Kommunikation

**Typ:** OPTIONALE FUNKTION DIGITALES MUSTER 6: ÜBERWEISUNGSSCHEIN

Zur Umsetzung des elektronischen Auftrags digitales Muster 6 in der Arzt-zu-Arzt-Kommunikation sind von der Software alle das digitale Muster 6 in der Arzt-zu-Arzt-Kommunikation betreffenden Anforderungen zu realisieren, sofern sich die Software-Hersteller für die freiwillige Umsetzung entscheiden.

**Begründung:**

Die Umsetzung des digitalen Musters 6 in der Arzt-zu-Arzt-Kommunikation ergibt sich aus der Kombination mehrerer Anforderungen. Die Anforderung K26-01 bündelt diese.

**Akzeptanzkriterium:**

1. Die Software muss folgende Anforderungen erfüllen:
   - a) K26-02
   - b) K26-03
   - c) K26-04
   - d) K26-05
   - e) K26-06
   - f) K26-07
   - g) K26-08

---

### K26-02 - Automatisierte Befüllung des digitalen Musters 6 in der Arzt-zu-Arzt-Kommunikation

**Typ:** OPTIONALE FUNKTION DIGITALES MUSTER 6: ÜBERWEISUNGSSCHEIN

Bei der Erstellung des elektronischen Auftrags befüllt die Software das digitale Muster automatisiert.

**Begründung:**

Um den Arzt in seiner Arbeit zu unterstützen, muss das System die Daten für die Erstellung des elektronischen Auftrags automatisiert in das digitale Muster übernehmen.

**Akzeptanzkriterium:**

1. Bei der Erstellung des elektronischen Auftrags entsprechend Anforderung K26-03 muss die Software die Felder des digitalen Musters automatisch befüllen.
2. Vor der automatisierten Befüllung werden dem Arzt die Daten angezeigt und er hat die Möglichkeit, die Daten zu ändern. Ausgenommen von dieser Änderungsmöglichkeit sind die Daten der Versichertenkarte (siehe Auflistung "Daten eines Versichertendatensatzes" im Kapitel 2.2).
3. Der Anwender darf die PDF-Datei des digitalen Musters nicht manuell befüllen.

---

### K26-03 - Erstellen des digitalen Musters 6 in der Arzt-zu-Arzt-Kommunikation

**Typ:** OPTIONALE FUNKTION DIGITALES MUSTER 6: ÜBERWEISUNGSSCHEIN

Die Software muss zur Beauftragung in der Arzt-zu-Arzt-Kommunikation nach den Vorgaben des BMV-Ä (siehe: [KBV_BMV-Ä]), der Anlage 2b des BMV-Ä (siehe: [KBV_BMVÄ_Anlage_2b]) sowie des technischen Handbuchs digitale Vordrucke (siehe: [KBV_ITA_VGEX_Technisches_Handbuch_DiMus]) ein digitales Muster 6 erstellen.

**Begründung:**

Die Vordruck-Vereinbarung digitale Vordrucke ([KBV_BMVÄ_Anlage_2b]) sowie die Vereinbarung Telekonsil ([KBV_BMV_Ä_Anlage 31a]) regeln die Anforderungen an die elektronische Beauftragung des radiologischen Telekonsils sowie die Anforderungen an den Überweisungsschein von Arzt zu Arzt als solchen.

**Akzeptanzkriterium:**

1. Das System erstellt nach den Vorgaben des technischen Handbuchs digitale Vordrucke [KBV_ITA_VGEX_Technisches_Handbuch_DiMus] das digitale Muster 6 im Rahmen der Arzt-zu-Arzt-Kommunikation. Dies umfasst insbesondere:
   - a) Bei der Erstellung des Musters 6 werden alle benötigten PDF-Formularfelder entsprechend den Vorgaben aus dem Kapitel "2.10 Formularfelder" sowie dem Kapitel "3.1.2 Formularfelder digitales Muster 6" befüllt. Dabei werden auch die Vorgaben zu den Eigenschaften der PDF-Formularfelder, wie im technischen Handbuch beschrieben, eingehalten.
   - b) Die Hinweise zur Dateibenennung sind entsprechend Kapitel "2.5 Dateinamen" zu berücksichtigen.
   - c) Die auf dem Muster notwendige digitale Signatur entspricht den Vorgaben aus Kapitel "2.7 Qualifizierte elektronische Signatur".
   - d) Die KBV-Prüfnummer ist entsprechend Kapitel "2.10.7 KBV-Prüfnummer" auf dem digitalen Muster 6 aufgebracht.
   - e) Das Datei-Format des digitalen Musters wurde nicht verändert und entspricht dem PDF/A-2a Format. Die Vorgaben aus Kapitel "2.8 (Datei-) Format der digitalen Muster (PDF/A-2a)" wurden eingehalten.
   - f) Die Werte der Metadaten des digitalen Musters 6 entsprechend Tabelle 2 des Kapitels "2.9 Metadaten" wurden nicht geändert.
   - g) Die Werte der Metadaten entsprechend Tabelle 1 des Kapitels "2.9 Metadaten" wurden im Rahmen der Befüllung des Personalienfeldes mit den jeweiligen Werten befüllt.

---

### K26-04 - Senden des digitalen Musters 6 in der Arzt-zu-Arzt-Kommunikation (Musters 6)

**Typ:** OPTIONALE FUNKTION DIGITALES MUSTER 6: ÜBERWEISUNGSSCHEIN

Die Software muss dem Anwender eine Funktion bieten, so dass dieser das nach Anforderung K26-03 erstellte digitale Muster über einen sicheren Übertragungsweg versenden kann.

**Begründung:**

Um den Arzt in seiner Arbeit adäquat zu unterstützen und die sensiblen Daten vor unberechtigten Zugriff zu schützen, muss das System dem Anwender die Übertragung des digitalen Musters über einen sicheren Übertragungsweg ermöglichen.

**Akzeptanzkriterium:**

1. Dem Anwender wird es ermöglicht, das erstellte digitale Muster auf einem sicheren Übertragungsweg (siehe K26-05) zu versenden.
2. Eine entsprechende Umsetzung dieser Funktion hat der Software-Hersteller im Rahmen der ergänzenden Erklärung bestätigt.

---

### K26-05 - Verwendung eines sicheren Übertragungsweges für das digitale Muster 6 in der Arzt-zu-Arzt-Kommunikation (Musters 6)

**Typ:** OPTIONALE FUNKTION DIGITALES MUSTER 6: ÜBERWEISUNGSSCHEIN

Die Software darf zur Übertragung des digitalen Musters 6 in der Arzt-zu-Arzt-Kommunikation nur den sicheren Übertragungswege KIM nutzen.

**Begründung:**

Im BMV-Ä sind für die Übermittlung von digitalen Mustern nur Übertragungswege zulässig, welche die Anforderungen aus §3 Nummer 1 der Anlage 2b des BMV-Ä erfüllen. Damit darf die Software auch nur solche Übertragungswege integrieren und dem Vertragsarzt zur Nutzung anbieten.

**Akzeptanzkriterium:**

1. Das Softwaresystem muss für den Versand und Empfang des digitalen Musters 6 im PDF/A-Standard den Fachdienst KIM der Telematikinfrastruktur einsetzen.

**Hinweis:**

Es wird empfohlen die Spezifikation der KIM Anwendung "DiMus" [DiMus] der kv.digital umzusetzen.

---

### K26-06 - Empfang des elektronischen Auftrags digitale Muster 6 in der Arzt-zu-Arzt-Kommunikation

**Typ:** OPTIONALE FUNKTION DIGITALES MUSTER 6: ÜBERWEISUNGSSCHEIN

Die Software muss dem Anwender eine Funktion bieten, so dass dieser ein digitales Muster über einen sicheren Übertragungsweg empfangen kann. Das empfangene digitale Muster 6 erfüllt die Vorgaben des technischen Handbuchs digitale Vordrucke (siehe: [KBV_ITA_VGEX_Technisches_Handbuch_DiMus])

**Begründung:**

Um den Arzt in seiner Arbeit adäquat zu unterstützen, muss das System dem Anwender den Empfang des digitalen Musters über einen sicheren Übertragungsweg ermöglichen.

**Akzeptanzkriterium:**

1. Dem Anwender wird es ermöglicht, ein digitales Muster 6 über den sicheren Übertragungsweg (siehe K26-05) zu empfangen.
2. Eine entsprechende Umsetzung dieser Funktion hat der Softwarehersteller im Rahmen der ergänzenden Erklärung bestätigt.

---

### K26-07 - Auslesen des empfangenen elektronischen Auftrags für das digitale Muster 6 in der Arzt-zu-Arzt-Kommunikation

**Typ:** OPTIONALE FUNKTION DIGITALES MUSTER 6: ÜBERWEISUNGSSCHEIN

Die Software muss in der Lage sein, aus dem nach K26-06 empfangenen digitalen Muster 6 in der Arzt-zu-Arzt-Kommunikation die Daten entsprechend den Vorgaben des technischen Handbuchs digitale Muster (siehe: [KBV_ITA_VGEX_Technisches_Handbuch_DiMus]) auszulesen.

**Begründung:**

Um den Arzt in seiner Arbeit zu unterstützen, muss das System die Inhalte aus dem empfangenen Muster zur weiteren Verwendung korrekt auslesen können.

**Akzeptanzkriterium:**

1. Das System liest aus dem empfangenen digitalen Auftrag die Inhalte entsprechend den Vorgaben des technischen Handbuchs digitale Vordrucke [KBV_ITA_VGEX_Technisches_Handbuch_DiMus]. Dies umfasst insbesondere:
   - a) Die qualifizierte elektronische Signatur des Musters wird entsprechend Kapitel "2.7 Qualifizierte elektronische Signatur" geprüft.
   - b) Alle benötigten PDF-Formularfelder werden entsprechend den Vorgaben aus dem Kapitel "2.10 Formularfelder" sowie dem Kapitel "3.1.2 Formularfelder digitales Muster 6" des Dokumentes ausgelesen.
   - c) Alle benötigten Metadaten werden entsprechend den Vorgaben aus Kapitel "2.9 Metadaten" sowie dem Kapitel "3.1.1 Metadaten digitales Muster 6" ausgelesen.
   - d) Die Hinweise zur Dateibenennung sind entsprechend Kapitel "2.5 Dateinamen" des Dokumentes berücksichtigt.

---

### K26-08 - Verarbeitung der ausgelesenen Daten des empfangenen digitalen Musters 6 in der Arzt-zu-Arzt-Kommunikation

**Typ:** OPTIONALE FUNKTION DIGITALES MUSTER 6: ÜBERWEISUNGSSCHEIN

Die Software übernimmt die Daten aus dem digitalen Muster automatisiert ins System und verarbeitet sie wie im Akzeptanzkriterium dargestellt.

**Begründung:**

Um den Arzt in seiner Arbeit zu unterstützen, muss das System die Inhalte aus dem empfangenen Muster korrekt verarbeiten.

**Akzeptanzkriterium:**

Das System übernimmt die Daten des digitalen Musters fallgetreu (siehe KP2-570) in die Abrechnung. Dies bedeutet:

1. Dem Anwender wird die Möglichkeit gegeben, einen neuen Abrechnungsfall (im ADT-Datenpaket mit der Satzart 0102) anzulegen.
2. In diesem Abrechnungsfall wird kein Einlesedatum erzeugt.
3. Die Versichertendaten sowie die weiteren Daten des digitalen Musters werden automatisiert in den Abrechnungsfall übernommen. Dabei gelten die sich aus der KVDT-Datensatzbeschreibung ableitenden Regelungen, so dass die Datenübernahme bei digitalen Mustern unter denselben Regeln abläuft wie die Datenübernahme bei Papiermustern.
4. Die Daten des digitalen Musters, für die keine Übernahmeregelung aus der KVDT-Datensatzbeschreibung vorliegt, werden automatisiert und fallbezogen an die entsprechende Stelle im System übernommen. Es gelten dabei die Übernahmeregelungen aus Datenübernahme von Papiermustern.
5. Die übernommenen Daten sind für den Anwender jederzeit änderbar.
