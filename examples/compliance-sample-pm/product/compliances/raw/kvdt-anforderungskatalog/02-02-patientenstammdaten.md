# 2.2 Patientenstammdaten erfassen und verarbeiten

> Quelle: KBV_ITA_VGEX_Anforderungskatalog_KVDT, Version 6.06, 9. Maerz 2026

Dieses Kapitel beschreibt die Vorgaben zur Verarbeitung von Patientenstammdaten:

a) wenn die Eingabe von Patientenstammdaten ueber das Einlesen einer KVK oder eGK **(im Folgenden Versichertenkarte)** erfolgt,
b) wenn die Eingabe von Patientenstammdaten nicht ueber das Einlesen einer Versichertenkarte erfolgt, sondern (z.B. von einem Behandlungsausweis) manuell ueber Tastatur oder ueber Scanner oder ueber ein anderes Eingabemedium erfolgt.

## Daten eines Versichertendatensatzes

**Persoenliche Versichertendaten:**
- Geburtsdatum
- Vorname
- Name
- Geschlecht
- Vorsatzwort
- Namenszusatz
- Titel
- Versichertennummer bzw. Versicherten_ID
- Kostentraegername
- Kostentraegerkennung

**Geschuetzte Versichertendaten:**
- Besondere Personengruppe
- DMP_Kennzeichnung

**Strassenadresse:**
- PLZ
- Ort
- Strasse
- Hausnummer
- Anschriftenzusatz
- Wohnsitzlaendercode

**Postfachadresse:**
- PostfachPLZ
- PostfachOrt
- Postfach
- PostfachWohnsitzlaendercode

**Allgemeine Versichertendaten:**
- Versichertenart
- WOP(-Kennzeichen)
- Versicherungsschutz Beginn (JJJJMMTT)
- Versicherungsschutz Ende (JJJJMMTT)

Detaillierte Informationen ueber die technischen Einzelheiten der Daten der KVK entnehmen Sie bitte dem **"Merkblatt Krankenversichertenkarte".**

Informationen zu den Daten der eGK sind auf der Webseite der gematik zu finden.

Die Daten einer Versichertenkarte koennen in das Personalienfeld eines Behandlungsausweises gedruckt werden (z.B. Ueberweisungsschein). Liegt keine Versichertenkarte vor (z.B. bei Einsendepraxen), sind die gedruckten Versichertendaten des Behandlungsausweises Grundlage fuer die weitere Verarbeitung.

---

## 2.2.1 Patientenstammdaten ueber das Einlesen einer Versichertenkarte erfassen

### 2.2.1.1 Einsatz von mobilen und stationaeren Terminals

Beide Kartentypen (eGK und KVK) koennen durch die mobilen und stationaeren Terminals verarbeitet und die Datensaetze mittels RS232-, LAN- oder USB-Schnittstelle an das Abrechnungssystem uebergeben werden. Ein PVS muss daher mindestens eine der genannten Schnittstellen unterstuetzen.

Die Datensaetze der KVK muessen fuer die weitere Verarbeitung im Rahmen der KV-Abrechnung in die eGK-Struktur konvertiert werden.

Als Hilfestellung fuer die notwendige Konvertierung wird eine "Mappingtabelle_KVK" [KBV_ITA_VGEX_Mapping_KVK] zur Verfuegung gestellt.

Die Bedruckung des Personalienfeldes aller vertragsaerztlichen Formulare erfolgt gemaess den Bedruckungsvorschriften in Kapitel "Bedruckung des Personalienfeldes" in der "Mappingtabelle_KVK" [KBV_ITA_VGEX_Mapping_KVK].

---

### KP2-100 - Einsatz zertifizierter Lesegeraete

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Alle Terminals muessen auf Anforderung an jedes Abrechnungssystem in mindestens einer Schnittstelle (RS232, LAN, USB) angebunden werden koennen.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### 2.2.1.2 Krankenversichertenkarte als Berechtigungsnachweis zur Inanspruchnahme aerztlicher Leistungen ab 01.01.2015 ungueltig

Gemaess Anlage 4a BMV-Ae (Vereinbarung zum Inhalt und zur Anwendung der elektronischen Gesundheitskarte, Par. 4 Einfuehrung der elektronischen Gesundheitskarte) verliert die Krankenversichertenkarte (KVK) - unabhaengig vom aufgedruckten Gueltigkeitsdatum der KVK - endgueltig zum Jahresende 2014 ihre Funktion als Berechtigungsnachweis zur Inanspruchnahme aerztlicher Leistungen von Versicherten gesetzlicher Krankenkassen.

Ab dem 1. Januar 2015 gilt fuer gesetzlich Krankenversicherte nur noch die elektronische Gesundheitskarte als Berechtigungsnachweis zur Inanspruchnahme aerztlicher Leistungen.

Unbenommen davon sind fuer Versicherte der Sonstigen Kostentraeger weiterhin Krankenversichertenkarten als Berechtigungsnachweis zur Inanspruchnahme aerztlicher Leistungen zulaessig.

Nachfolgend eine Auflistung der eindeutigen Unterscheidungsmerkmale der Kostentraegerarten anhand der Abrechnungs-VKNR (FK 4104) und des Kostentraeger-Abrechnungsbereichs (KTAB, FK 4106):

**Kostentraeger der Gesetzlichen Krankenversicherung (GKV):**
- Es gilt: Die Seriennummer der VKNR (3. - 5. Stelle des Feldes 4104) ist immer < 800 und der Kostentraeger-Abrechnungsbereich ist immer = 00 (Primaerabrechnung).
- Die Krankenversichertenkarten der Versicherten dieser Kostentraeger sind ab 01.01.2015 **ungueltig**.

**Sonstige Kostentraeger (SKT):**

Wir unterscheiden im Rahmen der Abrechnung:

- **"originaere" Sonstige Kostentraeger** (z.B. JVA, Bundeswehr, Feuerwehr, Sozialaemter) als eigenstaendige Kassen mit eindeutigem VKNR-Seriennummern-Kontingent:
  - Es gilt: Die Seriennummer der VKNR ist immer >= 800 und Kostentraeger-Abrechnungsbereich kann 00 - 09 sein.
  - Die Krankenversichertenkarten der Versicherten dieser Kostentraeger sind ueber den 01.01.2015 hinaus **gueltig**.
  - Beispiel: Postbeamtenkrankenkasse, VKNR 61850

- Zum anderen koennen GKV-Kostentraeger als "aushelfende Kassen" aufgrund vertraglicher Bestimmungen (auf KV-Ebene) als "Sonstige" (Besondere) Kostentraeger auftreten:
  - Es gilt: Die Seriennummer der VKNR ist immer < 800 und der Kostentraeger-Abrechnungsbereich immer ungleich 00.
  - Die Krankenversichertenkarten der Versicherten dieser Kostentraeger sind ab 01.01.2015 **ungueltig**.
  - Beispiel: Kostentraeger IKK Nord, Abrechnung erfolgt im Rahmen des Sozialversicherungsabkommens (SVA), VKNR: 01**310**, Seriennummern-Kontingent 301 - 399 (= Kassenart "Innungskrankenkassen (IKK)") **und** Kostentraeger-Abrechnungsbereich: **01** (= Kennzeichen fuer Sozialversicherungsabkommen)

#### Tabelle 2 - Einlesen einer KVK in Abhaengigkeit von der VKNR-Seriennummer und KTAB

| 3. - 5. Stelle der VKNR / KTAB | =00 | !=00 |
|---|---|---|
| >= 800 | KVK gueltig | KVK gueltig |
| < 800 | KVK ungueltig | KVK ungueltig |

---

### KP2-101 - Krankenversichertenkarte als Berechtigungsnachweis zur Inanspruchnahme aerztlicher Leistungen ungueltig - Ausnahmeregelung fuer "originaere" Sonstige Kostentraeger (VKNR-Seriennummer 3.-5. Stelle >= 800)

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software stellt sicher, dass das Einlesen einer Krankenversichertenkarte (KVK) bei gesetzlich Versicherten mit einer Fehlermeldung abgelehnt wird.

**Begruendung:**

Seit dem 1. Januar 2015 gilt ausschliesslich die elektronische Gesundheitskarte als Berechtigungsnachweis fuer die Inanspruchnahme aerztlicher Leistungen bei gesetzlich Versicherten und loest damit die KVK ab.

**Akzeptanzkriterium:**

1. Das System muss das Einlesen der KVK bei gesetzlich Versicherten mit einer Fehlermeldung ablehnen, wenn die Stellen 3 - 5 des Feldes 4104 < 800.
   a) Eine automatische Weiterverarbeitung der abgelehnten Daten erfolgt nicht.
   b) Der Anwender hat die Moeglichkeit in eigenem Ermessen und in Kenntnis moeglicher Regressforderungen, zum Zwecke der Abrechnung und Ausstellung von vertragsaerztlichen Formularen Bedruckung, die Kartendaten manuell im PVS zu erfassen (siehe KP2-102). Die Behandlung und Abrechnung erfolgt dabei unter Beachtung der Anlage 4a BMV-Ae (Vereinbarung zum Inhalt und zur Anwendung der elektronischen Gesundheitskarte).
2. Das System muss das Einlesen und die automatische Weiterverarbeitung der KVK bei "originaeren" Sonstigen Kostentraegern unterstuetzen, wenn die Stellen 3 - 5 des Feldes 4104 >= 800 und der Inhalt des Feldes 4106 (KTAB) = 00 - 09 ist.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

**Hinweis:**

Diese Anforderungen gelten auch bei der Uebernahme von Versichertenkarten-Datensaetzen aus einem mobilen Kartenterminal.

#### Tabelle 3 - Zusammenfassung: Einlesen einer KVK in Abhaengigkeit von der VKNR-Seriennummer

| 3. - 5. Stelle der VKNR / KTAB | Einlesen der KVK | Manuelle Erfassung |
|---|---|---|
| >= 800 (KTAB = 00 bis 09) | KVK gueltig. Das Einlesen der KVK muss dem Anwender erlaubt werden. | Die manuelle Erfassung der Daten muss dem Anwender ermoeglicht werden. Die Behandlung und Abrechnung erfolgen im Ermessen des Arztes. |
| < 800 (KTAB = 00 bis 09) | KVK ungueltig. Das Einlesen der KVK muss mit einer Fehlermeldung (s. KP2-101) abgelehnt werden. | Die manuelle Erfassung der Daten muss dem Anwender ermoeglicht werden. Die Behandlung und Abrechnung erfolgen im Ermessen des Arztes. |

Wird im Folgenden der Begriff KVK verwendet, so sind stets nur die KVK von "originaeren" Sonstigen Kostentraegern gemeint.

Zum 1. Januar 2025 wird die Heilfuersorge der Bundespolizei fuer erste Mitglieder eGKs gemaess dem Schema fuer gesetzlich Versicherte ausgeben. Somit darf von der Software das Einlesen von eGKs fuer einen Versicherten eines Sonstigen Kostentraegers nicht verhindert werden.

> Hinweis: Die VKNR muss ueber die KT-Stammdatei aus dem IK der Versichertenkarte abgeleitet/ermittelt werden.

---

### KP2-102 - Kartendaten der abgelehnten Krankenversichertenkarte werden in kopierbarer Form angezeigt

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software ermoeglicht dem Anwender das Anzeigen der Kartendaten einer abgelehnten Krankenversichertenkarte (entsprechend KP2-101) in "kopierbarer" Form.

**Begruendung:**

Der Anwender muss die Moeglichkeit haben sich die abgelehnten Kartendaten in "kopierbarer" Form anzuzeigen, um beispielsweise Datenverluste nach der Uebernahme von Versichertenkarten-Datensaetzen aus einem mobilen Kartenterminal zu vermeiden.

**Akzeptanzkriterium:**

1. Mit Ablehnung der Krankenversichertenkarte entsprechend KP2-101 kann sich der Anwender die abgelehnten Kartendaten in "kopierbarer" Form anzeigen lassen. Eine automatische Uebernahme der Kartendaten ins "Ersatzverfahren" (gemaess Abschnitt 2.2.3.1 Definition Ersatzverfahren) ist nicht erlaubt.
2. Ein "Einlesedatum" gemaess P2-140 darf in diesem Fall nicht erzeugt werden.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### P2-105 - Konvertierung der KVK-Daten in eGK-/KVDT-konforme Strukturen

**Typ:** PFLICHTFUNKTION ADT

Die Software muss die Datenfelder der Krankenversichertenkarte (KVK) fuer die weitere Bearbeitung im Rahmen der Abrechnung gemaess den Anforderungen der Mappingtabelle_KVK transformieren.

**Begruendung:**

Vertragliche Grundlage dieser Anforderung sind die Anlage 4a BMV-Ae sowie die Technische Anlage zu Anlage 4a (BMV-Ae).

**Akzeptanzkriterium:**

1. Die Software muss alle erforderlichen Anforderungen gemaess der Mappingtabelle_KVK in der jeweils aktuellen Version umsetzen, vgl. [KBV_ITA_VGEX_Mapping_KVK].

**Hinweis:**

Fuer die weitere Verarbeitung und die darauf aufsetzenden weiteren Pflichtfunktionen wird davon ausgegangen, dass jeweils ein valider eGK-Datensatz gemaess Mappingtabelle_KVK, sei es durch das Einlesen einer eGK oder durch die korrekte Konvertierung der KVK-Datenfelder, vorliegt.

Unabhaengig davon, ob die Daten originaer von einer eingelesenen eGK stammen oder durch Einlesen und anschliessende Konvertierung einer KVK erzeugt wurden, wird im Folgenden - soweit moeglich - der Begriff "Versichertenkarte" verwendet.

---

### KP2-121 - Uebertragung eGK-Daten bei Versicherten der BPol

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software muss sicherstellen, dass sobald fuer einen Versicherten der Bundespolizei Heilfuersorge (BPol) eine eGK eingelesen wurde, keine weiteren veralteten KVKs mehr eingelesen werden koennen.

**Begruendung:**

Der Kostentraeger Bundespolizei Heilfuersorge plant die alten KVKs durch aktuelle eGKs zu ersetzen.

**Akzeptanzkriterium:**

1. Wenn fuer einen Versicherten der BPol (VKNR = 74860) erstmalig eine eGK eingelesen wurde, dann lehnt die Software zukuenftig das Einlesen einer veralteten KVK (auch fuer die VKNR 27860) im laufenden Quartal sowie allen weiteren Quartalen ab und weist den Anwender darauf hin, dass der Versicherte bereits eine eGK besitzt.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

**Hinweis:**

Im Rahmen der eGK-Ausgabe hat die BPol die neue VKNR = 74860 eingefuehrt, bis zum vollstaendigen Austausch aller KVKs innerhalb eines Uebergangszeitraums bleibt in der Kostentraegerstammdatei auch die VKNR 27860 gueltig.

Der Kostentraeger mit der VKNR 27860 wird zum 1. Oktober 2025 in der Kostentraegerstammdatei als ungueltig gekennzeichnet. Bitte beachten Sie in diesem Zusammenhang die Anforderung P2-230.

---

### 2.2.1.3 "Amtliche" Felder

### P2-120 - Verarbeitung und Anzeige der Versichertendaten nach dem Einlesen einer Versichertenkarte

**Typ:** PFLICHTFUNKTION ADT

Falls Versichertendatensaetze von einer Versichertenkarte eingelesen werden, muss das System die Daten der Versichertenkarte im selben Quartal als "amtliche" Daten behandeln. Diese Daten muessen unveraendert gespeichert und mit der Abrechnung uebertragen werden.

**Begruendung:**

Durch eine Aenderung von eingelesenen Versichertendatensaetzen einer gueltigen Versichertenkarte, koennte es im weiteren Abrechnungsprozess zu Ablehnungen des Abrechnungsdatensatzes durch die Krankenkassen kommen.

**Akzeptanzkriterium:**

1. Nach dem erfolgreichen Einlesen eines Versichertendatensatzes von einer Versichertenkarte gemaess den Vorgaben der "Technischen Anlage zur Anlage 4a" und dem Erzeugen eines Einlesedatums gemaess der Anforderung P2-140 haben die nachfolgenden Daten einer Versichertenkarte "amtlichen" Charakter:

#### Tabelle 4 - "Amtliche" Felder

| Persoenliche Versichertendaten | Geschuetzte Versichertendaten | Strassenadresse | Postfachadresse | Allgemeine Versichertendaten |
|---|---|---|---|---|
| Geburtsdatum | Besondere Personengruppe | PLZ | PostfachPLZ | Versichertenart |
| Vorname | DMP_Kennzeichnung | Ort | PostfachOrt | WOP (-Kennzeichen) |
| Name | | Strasse | Postfach | Versicherungsschutz Beginn (JJJJMMTT) |
| Geschlecht | | Hausnummer | PostfachWohnsitzlaendercode | Versicherungsschutz Ende (JJJJMMTT) |
| Vorsatzwort | | Anschriftenzusatz | | |
| Namenszusatz | | Wohnsitzlaendercode | | |
| Titel | | | | |
| Versichertennummer bzw. Versicherten_ID | | | | |
| Kostentraegername | | | | |
| Kostentraegerkennung | | | | |

   a) Im Rahmen des Einlesevorganges muessen die folgenden Anforderungen beachtet werden:
      - i. P2-105
      - ii. P2-135
      - iii. P2-136
      - iv. P2-170
      - v. KP2-310
      - vi. P2-470 (Ausnahme der "Amtlichkeit" beim Einlesen einer KVK fuer die Angabe des Geschlechts)
      - vii. Vorgaben des Kapitels "2.2.2.1 Zuordnung des Kostentraegers (VKNR, IK und Krankenkassenname)"

2. Die Software muss die Felder mit "amtlichem" Charakter unveraendert und patientenbezogen anzeigen, speichern und mit der Abrechnung uebertragen.
   a) Die Software muss bedienungs- und programmtechnisch eine Aenderung der Felder mit amtlichem Charakter ausschliessen.
3. Die "Amtlichkeit" der in Tabelle 4 aufgefuehrten Daten gilt bis zum Ablauf des Quartals, in dem die Versichertenkarte eingelesen wurde.
4. Falls ein erfolgreicher Einlesevorgang einer Versichertenkarte stattgefunden hat, muss die Software die automatische Uebernahme der Versichertendaten ins Ersatzverfahren (gemaess Abschnitt 2.2.3.1 Definition Ersatzverfahren) zum Zwecke der Datenaenderung unterbinden.

**Hinweis:**

Fuer Akzeptanzkriterium (2) gilt:
Auch wenn die Patientendaten nicht mehr aktuell sind, muessen diese ohne Aenderung in der Abrechnung uebertragen werden.

Bei der Ausstellung von vertragsaerztlichen Formularen ist zu beachten, welche Adressdaten fuer die Ausstellung zu verwenden sind. Es wird unterschieden zwischen Ueberweisungs- und Abrechnungsscheinen und den uebrigen vertragsaerztlichen Formularen (siehe P7-81 / P7-82, "Anforderungskatalog Formularbedruckung" [KBV_ITA_VGEX_Anforderungskatalog_Formularbedruckung]).

Beachten Sie bitte auch die Anforderungen P2-140, P2-150, KP2-557 und P2-558.

---

### 2.2.1.4 Das WOP-Kennzeichen

### P2-135 - Uebernahme des WOP-Kennzeichens von der Versichertenkarte

**Typ:** PFLICHTFUNKTION ADT

Die Software muss die Transformationsvorschriften fuer das WOP(-Kennzeichen) gemaess den Anforderungen der "Technischen Anlage zur Anlage 4a" einhalten und dem Anwender die manuelle Erfassung eines WOP-Kennzeichens ermoeglichen.

**Begruendung:**

Vertragliche Grundlage dieser Anforderung sind die Anlage 4a BMV-Ae sowie die Technische Anlage zu Anlage 4a (BMV-Ae).

Das WOP darf zur Vermeidung von Fehlzuweisungen nicht programmtechnisch bestimmt werden.

**Akzeptanzkriterium:**

1. Falls eine Krankenversichertenkarte (KVK) eingelesen wird, muss die Software den Inhalt des Feldes "VKNR/WOP" (Objekttag ,8F') entsprechend den Vorgaben der "Technischen Anlage zur Anlage 4a" [KBV_ITA_VGEX_Mapping_KVK] transformieren und im Feld 3116 uebertragen. (vgl. auch P2-105).
   a) Wenn kein WOP-Kennzeichen auf der KVK codiert ist, dann wird das Feld 3116 nicht uebertragen.
2. Falls eine eGK eingelesen wird, muss die Software den Inhalt des Elements `../WOP` entsprechend den Vorgaben der "Technischen Anlage zur Anlage 4a" in das Feld 3116 uebernehmen. (vgl. auch P2-105)
3. Die Software muss dem Anwender im Rahmen der manuellen Erfassung die Moeglichkeit bieten, das WOP-Kennzeichen manuell zu erfassen. (vgl. auch P2-400)
   a) Die Software belegt das Eingabefeld des WOP-Kennzeichens nicht vor (beispielsweise anhand der PLZ des Versicherten).
4. Die Software muss das vom Anwender erfasste WOP-Kennzeichen im Feld 3116 uebertragen.

**Hinweis:**

Aufgrund von Speicherplatzproblemen erfolgte auf der Krankenversichertenkarte eine Doppelbelegung des VKNR-Feldes (Objekttag ,8F', VKNR bzw. WOP-Kennzeichen), sodass alternativ auch ein Wohnort-Kennzeichen (WOP) im Format 000nn (nn = KV-Bereich) enthalten sein kann.

---

### 2.2.1.5 Name des Kostentraegers von der Versichertenkarte

### P2-136 - Name des Kostentraegers von der Versichertenkarte

**Typ:** PFLICHTFUNKTION ADT

Die Software muss die Transformationsvorschriften fuer den Namen des Kostentraegers gemaess den Anforderungen der "Technischen Anlage zur Anlage 4a" einhalten.

**Begruendung:**

Die vertragliche Grundlage dieser Anforderung sind die Anlage 4a BMV-Ae sowie die Technische Anlage zu Anlage 4a (BMV-Ae).

**Akzeptanzkriterium:**

1. Falls eine KVK eingelesen wird, muss die Software den Inhalt des Feldes "KrankenKassenName" (Objekttag ,80') entsprechend den Vorgaben der "Technischen Anlage zur Anlage 4a" [KBV_ITA_VGEX_Mapping_KVK] in das Feld 4134 uebernehmen. (vgl. auch P2-105)
2. Falls eine eGK eingelesen wird, muss die Software den Inhalt des Elements `../Name` entsprechend den Vorgaben der "Technischen Anlage zur Anlage 4a" in das Feld 4134 uebernehmen unter Beachtung der nachfolgenden Prioritaetenregelung:
   - **Prioritaet 1:** Inhalt von Element `UC_AllgemeineVersicherungsdatenXML/Versicherter/Versicherungsschutz/Kostentraeger/AbrechnenderKostentraeger/Name`
   - **Prioritaet 2:** Inhalt von Element `UC_AllgemeineVersicherungsdatenXML/Versicherter/Versicherungsschutz/Kostentraeger/Name` (vgl. auch P2-105)
3. Die Software darf den Kostentraegernamen von der Versichertenkarte nicht zur Ausstellung von vertragsaerztlichen Formularen verwenden, sondern muss die Regelungen der Anforderungen P2-210, P2-220, P2-260 oder P2-270 beachten.
4. Die Software ermoeglicht es dem Anwender nicht, diese Daten im Rahmen der manuellen Erfassung zu erfassen.

**Hinweis:**

Das KVDT-Feld 4134 ("Kostentraegername") kann nur in einer Satzart 010x nur vorhanden sein, wenn tatsaechlich eine Versichertenkarte eingelesen wurde.

Der Kostentraegername muss beim Einlesen einer Versichertenkarte immer - unabhaengig von der Scheinuntergruppe - uebertragen werden. Die Funktionen P2-120 und P2-136 haben Vorrang vor Kontext-Regel 777 der KVDT-Datensatzbeschreibung.

Die Einschraenkung auf bestimmte Scheinuntergruppen in der Regel 777 resultiert aus der Anforderung P2-140 (8).

---

### 2.2.1.6 Einlesedatum

### P2-140 - "Einlesedatum" erzeugen, anzeigen und speichern

**Typ:** PFLICHTFUNKTION ADT

1. Im Anschluss an einen erfolgreichen Lesevorgang einer Versichertenkarte durch ein **stationaeres** Lesegeraet wird vom Betriebssystem automatisch ein Systemdatum bereitgestellt.
2. Das Systemdatum darf nur bei einem erfolgreichen Einlesevorgang einer Versichertenkarte erzeugt, angezeigt und weiterverarbeitet werden.
3. Das Systemdatum wird als "Einlesedatum" der Versichertenkarte (= "letzter Einlesetag der Versichertenkarte im Quartal", FK 4109) am Bildschirm angezeigt.
4. Das Einlesedatum hat "amtlichen Charakter" und ist ein Lesefeld. Es darf dem Anwender nicht moeglich sein, dieses Feld zu veraendern.
5. Das Einlesedatum darf nur unter den o.a. Bedingungen in die Patientenstammdaten uebernommen und gespeichert werden.
6. Fuer die Abrechnung wird das Einlesedatum im Feld "Letzter Einlesetag der Versichertenkarte im Quartal" (FK 4109 des (x)ADT-Datenpaketes) gespeichert.
7. Es darf **keine Moeglichkeit** bestehen, das Einlesedatum zu generieren oder manuell einzugeben, wenn die Eingabe von Versichertendaten manuell ueber Tastatur (z.B. beim Ersatzverfahren), ueber Scanner oder ueber ein anderes Eingabemedium erfolgt.
8. Wird mittels Satzart 8215 "Auftrag" (LDT 3) das Feld 4109 "letzter Einlesetag der Versichertenkarte im Quartal" in die Patientendokumentation eines Abrechnungssystems importiert, darf es dem Anwender nicht moeglich sein, den Inhalt des Feldes 4109 zu veraendern.
9. Nach der Uebernahme des Versichertenkarten-Datensatzes aus einem **mobilen** Kartenterminal (Rueckgabecode 9500 oder 9501 bei RESET_CT) wird das **Einlesedatum** nicht durch das Systemdatum bereitgestellt, sondern aus dem Datenobjekt Einlesedatum (tag ,91') uebernommen, wie auch die **Zulassungsnummer** des mobilen Kartenterminals aus dem Datenobjekt Zulassungsnummer (tag ,92'), vgl. Kapitel "Mobiles Einsatzszenario" gemaess "Mappingtabelle_KVK" [KBV_ITA_VGEX_Mapping_KVK] und auch P2-180.

---

### P2-150 - Legitimation von Leistungen im laufenden Quartal mittels Einlesedatum

**Typ:** PFLICHTFUNKTION ADT

Falls in einem Quartal mehrere Arzt-Patienten-Kontakte stattfinden und kein Wechsel der Besonderen Personengruppe nach P2-535 oder Kassenwechsel nach P2-530 oder Versichertenartwechsel nach P2-540 vorliegt, muss die Software den letzten Einlesetag der Versichertenkarte im Quartal (FK 4109) automatisch anpassen.

**Begruendung:**

Zur Kennzeichnung, ob im Rahmen der Behandlung zum Nachweis der Anspruchsberechtigung gemaess Par. 13 BMV-Ae eine elektronische Gesundheitskarte vorgelegt und eingelesen wurde, muss das Einlesedatum im Rahmen der Abrechnung uebermittelt werden.

**Akzeptanzkriterium:**

1. Falls im laufenden Quartal Leistungen fuer denselben Versicherten, von demselben Arzt erbracht werden, kein Wechsel der Besonderen Personengruppe nach P2-535 oder Kassenwechsel nach P2-530 oder Versichertenartwechsel nach P2-540 vorliegt und **kein** Einlesedatum zu den Satzarten 010x vorhanden ist, dann muss die Software beim Einlesen der Versichertenkarte im laufenden Quartal das Einlesedatum in alle Satzarten des ADT-Datenpaketes "010x" in die FK 4109 befuellen und uebertragen.
2. Falls im laufenden Quartal Leistungen fuer denselben Versicherten, von demselben Arzt erbracht werden, kein Wechsel der Besonderen Personengruppe nach P2-535 oder Kassenwechsel nach P2-530 oder Versichertenartwechsel nach P2-540 vorliegt und **ein** Einlesedatum zu den Satzarten 010x bereits vorhanden ist, dann muss die Software beim Einlesen der Versichertenkarte im laufenden Quartal die FK 4109 fuer alle Satzarten des ADT-Datenpaketes "010x" mit dem neuen Einlesedatum ueberschreiben und uebertragen.
3. Der Einlesetag (FK 4109) von ADT-Datenpaketen "010x" aus den Vorquartalen darf von der Software nicht angepasst werden.

**Hinweise:**

1. Beachten Sie bitte auch die Vorgaben zum Besondere Personengruppen- (P2-535), Kassen- (P2-530) und Versichertenartwechsel (P2-540) sowie die Vorgaben zur Aenderung von amtlichen Versichertendaten unter Kapitel 2.3.5.
2. Der Versichertennachweis wird unter o. a. Voraussetzungen mit einem im laufenden Quartal erzeugten Einlesedatum erbracht. Der "letzte Einlesetag der Versichertenkarte im Quartal" legitimiert daher automatisch alle Leistungen im laufenden Quartal.

---

### 2.2.1.7 Ueberpruefung der Leistungspflicht des Kostentraegers

### P2-166 - Ueberpruefung der Leistungspflicht des Kostentraegers

**Typ:** PFLICHTFUNKTION ADT

Die Abrechnungssoftware muss beim Einlesen einer Versichertenkarte die Leistungspflicht des Kostentraegers durch Ueberpruefung des "Versicherungsschutzes" (eGK: Elemente `//Versicherungsschutz/Beginn` bzw. `//Versicherungsschutz/Ende` bzw. KVK: Objekttag ,8D' "GueltigkeitsDatum") sicherstellen. Hierbei sind grundsaetzlich folgende Faelle zu unterscheiden:

**Fall 1)**

Beim Einlesen der Daten einer eGK gilt:

a) Falls das Einlesedatum (FK 4109) >= VersicherungsschutzBeginn und - sofern ein entsprechendes Element auf der eGK vorhanden ist - <= VersicherungsschutzEnde, dann gilt:
   Diese Karte ist gueltig. Das Einlesen der Daten dieser Versichertenkarte muss moeglich sein. Eine Abrechnung von Leistungen und die Ausstellung vertragsaerztlicher Formulare sind zulaessig.

b) Falls das Einlesedatum (FK 4109) < VersicherungsschutzBeginn oder - sofern ein entsprechendes Element auf der eGK vorhanden ist - > VersicherungsschutzEnde, dann gilt:
   Das Einlesen der Daten dieser Versichertenkarte muss mit einer entsprechenden Fehlermeldung abgelehnt werden. Diese Karte ist ungueltig.

**Fall 2)**

Beim Einlesen der Daten einer KVK gilt:

Es muss eine Transformation des KVK-Feldes, Objekttag ,8D', "GueltigkeitsDatum" im Format "MMJJ" in die Form "JJJJMMTT" erfolgen, wobei TT = letzter moeglicher Tag des Monats und JJJJ = Verkettung ('20',JJ). Diese Angabe muss dann unter der FK 4110 ("VersicherungsschutzEnde") in der ADT-Abrechnung uebertragen werden, vgl. "Mappingtabelle_KVK" [KBV_ITA_VGEX_Mapping_KVK]

a) Falls das Einlesedatum (FK 4109) <= VersicherungsschutzEnde, dann gilt: Das Einlesen der Daten dieser Versichertenkarte muss moeglich sein. Diese Karte ist gueltig. Eine Abrechnung von Leistungen und die Ausstellung vertragsaerztlicher Formulare sind zulaessig.

b) Falls das Einlesedatum (FK 4109) > VersicherungsschutzEnde, dann gilt: Das Einlesen der Daten dieser Versichertenkarte muss mit einer entsprechenden Fehlermeldung abgelehnt werden. Diese Karte ist ungueltig.

**Fall 1) und Fall 2)**

Diese Anforderungen gelten auch bei der Uebernahme von Versichertenkarten-Datensaetzen aus einem mobilen Kartenterminal.

**Fall 1) (b) und Fall 2) (b)**

Eine direkte Weiterverarbeitung der Daten der Versichertenkarte zum Zwecke der ADT-Abrechnung und Ausstellung vertragsaerztlicher Formulare zu Lasten dieses Kostentraegers ist **nicht** zulaessig.

Mit Ablehnung der Versichertenkarte muss der Anwender die Moeglichkeit erhalten, sich die abgelehnten Kartendaten in "kopierbarer Form" gemaess KP2-102 anzeigen zu lassen. Ein "Einlesedatum" gemaess P2-140 darf nicht erzeugt werden.

Die Behandlung und Abrechnung erfolgt im Ermessen des Arztes unter Beachtung der Anlage 4a BMV-Ae ("Vereinbarung zum Inhalt und zur Anwendung der elektronischen Gesundheitskarte").

---

### 2.2.1.8 Uebernahme von Versichertendaten in die Patientenstammdaten

### P2-170 - Uebernahme der eingelesenen Daten in die Patientenstammdaten

**Typ:** PFLICHTFUNKTION ADT

Wurden die fuer das laufende Quartal gueltigen Abrechnungsinformationen der Versichertenkarte eingelesen, muessen die entsprechenden Daten in die Patientenstammdaten uebernommen werden koennen.

Dabei muss die Software sicherstellen, dass dem Anwender nach dem Lesen der eGK mit Hilfe des Konnektors und vor der Uebernahme der Versichertendaten die vollstaendigen Aenderungen im Vergleich zu bereits vorhandenen Patientenstammdaten angezeigt werden, siehe Anforderung "VSDM-A_2538 PS: Anzeige Delta VSD" aus dem Implementierungsleitfaden der gematik.

> **VSDM-A_2538 PS: Anzeige Delta VSD**
>
> Das Primaersystem SOLL dem Benutzer nach dem Lesen der VSD von der eGK und vor der Uebernahme/Speicherung geaenderte VSD im Vergleich zu bereits vorhandenen Patientenstammdaten anzeigen.

**Begruendung:**

In Anlage 4a des BMV-Ae Anhang 1, Nr. 1.5 ist definiert, dass nur Daten von Karten uebernommen werden muessen, wenn die Feldauspraegungen der "Technischen Anlage zur Anlage 4a" entsprechen.

---

### 2.2.1.9 Uebertragung der Zulassungsnummer des mobilen Lesegeraetes in ein Abrechnungssystem

### P2-180 - Uebertragung der Zulassungsnummer des mobilen Lesegeraetes in ein Abrechnungssystem (KVDT)

**Typ:** PFLICHTFUNKTION ADT

1. Werden die Versichertenkarten-Daten durch ein mobiles Lesegeraet (Rueckgabecode 9500 oder 9501 bei RESET_CT) in ein Abrechnungssystem uebertragen, muss die Zulassungsnummer des mobilen Kartenterminals (tag ,92' des erweiterten VDT) in der jeweiligen Satzart 010x des KVDT uebertragen werden (FK 4108), vgl. auch P2-140 (9) bzw. Kapitel "Mobiles Einsatzszenario" gemaess "Mappingtabelle_KVK" [KBV_ITA_VGEX_Mapping_KVK].
2. Ist bereits eine Zulassungsnummer vorhanden, wird diese durch die aktuell zu uebertragende Zulassungsnummer ueberschrieben (nur eine Zulassungsnummer pro Datensatz "010x").
3. Die Software muss, wenn dieselbe Versichertenkarte derselben Kasse desselben Versicherten von demselben Arzt im laufenden Quartal beim 1. APK ueber ein mobiles Lesegeraet eingelesen wurde, und dann bei einem weiteren APK nochmals ueber ein stationaeres Lesegeraet eingelesen wird, das bereits vorhandene Einlesedatum (Feld FK 4109) in der jeweiligen Satzart "010x" ueberschreiben (vgl. auch P2-150). Die Software uebertraegt mit der Abrechnung nicht das Feld FK 4108 ("Zulassungsnummer").

---

### 2.2.1.10 Uebertragung Pruefungsnachweis nach VSDM-Aktualisierung

### KP2-185 - Uebertragung Pruefungsnachweis nach VSDM-Aktualisierung

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software muss die Uebertragung des "Pruefungsnachweises nach VSDM-Aktualisierung" in die ADT-Abrechnung ermoeglichen.

**Begruendung:**

Der "Pruefungsnachweis nach VSDM-Aktualisierung" wird fuer den Vertragsarzt / Vertragspsychotherapeuten bei durchgefuehrter Onlinepruefung und -aktualisierung erzeugt. Die Bereitstellung des Nachweises der Durchfuehrung der Onlineaktualisierung auf der eGK (= "Pruefungsnachweis") regelt Par. 291b Absatz 2 SGB V. Die Angabe und Uebermittlung des Pruefungsnachweises als Bestandteil der zu uebermittelnden Abrechnungsunterlagen an die zustaendige KV ist in Par. 295 SGB V geregelt.

**Grundlagen:**

Der Pruefungsnachweis ist ein Datensatz, der bei einer durchgefuehrten Onlinepruefung und - aktualisierung auf der eGK gespeichert und dem PVS uebergeben wird. Der Pruefungsnachweis wird auf der eGK in der Datei EF.PN abgelegt. Im Pruefungsnachweis koennen die folgenden Inhalte abgebildet werden:

- Timestamp
- Ergebnis der Onlinepruefung und -aktualisierung
- Error-Code (Rueckgabewert)
- Pruefziffer des Fachdienstes

Weitere Informationen zum Pruefnachweis entnehmen Sie der Webseite der gematik.

**Akzeptanzkriterium:**

1. Falls eine eGK eingelesen und eine Onlinepruefung durchgefuehrt wurde (entsprechend ist eine aktuelle Datei EF.PN auf der eGK vorhanden), muss die Software den Pruefungsnachweis in die Abrechnung uebernehmen und speichern.
   **Hinweis:** Der Pruefungsnachweis ist mit einem nur dem Anwender bekannten symmetrischen Schluessel verschluesselt. Es darf nur der Pruefungsnachweis, fuer den durch den Anwender eine Aktualisierung erfolgte, in das PVS uebernommen werden. Damit der Pruefungsnachweis gelesen werden kann, muss bei der Kommunikation mit dem Konnektor das Flag "Pruefnachweis lesen" gesetzt sein.
2. Die Software darf den Pruefungsnachweis nicht uebertragen, wenn die Daten von einem mobilen Kartenterminal uebernommen werden.
3. Sollte beim Einlesen im Quartal ein Pruefungsnachweis zurueckgegeben werden, der den Status 1 oder 2 besitzt, wird bei allen weiteren Einlesevorgaengen zwar eine Online-Pruefung und ggf. eine Aktualisierung der VSD durchgefuehrt werden, jedoch wird kein weiterer Pruefungsnachweis - betrifft die Feldkennungen 3010, 3011, 3012 und 3013 - in die Abrechnung uebernommen.
4. Falls beim ersten Einlesen im Quartal ein Pruefungsnachweis zurueckgegeben wird, der den Status 3 bis 6 hat, wird beim naechsten Einlesevorgang eine Online-Pruefung und ggf. Aktualisierung der VSD durchgefuehrt werden. Wenn der neue Pruefungsnachweis den Status 1 oder 2 hat, dann wird der bereits vorhandene Pruefungsnachweis - betrifft die Feldkennungen 3010, 3011, 3012 und 3013 - in der Abrechnung im aktuellen Quartal ueberschrieben.
5. Die Software uebertraegt den Pruefungsnachweis wie folgt mit der Abrechnung im jeweiligen Datensatz "010x":
   a) Inhalt von Element `/PN/TS` in Feld FK 3010 ("Datum und Uhrzeit der Onlinepruefung und -aktualisierung (Timestamp)")
   b) Inhalt von Element `/PN/E` in Feld FK 3011 ("Ergebnis der Onlinepruefung und -aktualisierung")
   c) Inhalt von Element `/PN/EC` in Feld FK 3012 ("Error-Code")
   d) Inhalt von Element `/PN/PZ` in Feld FK 3013 ("Pruefziffer des Fachdienstes"), wobei die Software sicherstellen muss, dass die base64-codierte Pruefziffer ohne Zeilenumbruch ("CR" und "LF") als Feldinhalt uebertragen wird.
6. Der letzte angeforderte Pruefungsnachweis - gemaess der Akzeptanzkriterien 3 und 4 - muss in allen Datensaetzen "010x" des laufenden Quartals patientenbezogen uebernommen und uebertragen werden.
   Die Software ermoeglicht es dem Anwender nicht, diese Daten im Rahmen der manuellen Erfassung zu erfassen.
   **Anmerkung:** Dies bedeutet, dass im Rahmen der Falltrennung durch Besondere Personengruppe-, Kassen- und Statuswechsel (siehe Kapitel 2.3.4 Besondere Personengruppen-, Kassen- und Statuswechsel) immer der gleiche Pruefungsnachweis pro Patienten und Quartal uebertragen wird.
7. Da die Kommunikation zwischen PVS und Konnektor die Voraussetzung fuer die Uebertragung des Pruefnachweises ist, muss der Nachweis des erfolgreich durchlaufenen Bestaetigungsverfahrens der gematik - Bestaetigung der Konformitaet des Primaersystems zur Konnektorschnittstelle fuer den Funktionsumfang VSDM eingereicht werden.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### 2.2.1.11 Kennzeichnung eines Patienten als "gebuehrenfrei"

### KP2-190 - Ueberpruefung der Zuzahlungsbefreiung nach Jahreswechsel

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software stellt sicher, dass die Zuzahlungsbefreiung fuer einen Patienten spaetestens nach erfolgtem Jahreswechsel systemseitig geloescht wird.

**Begruendung:**

Versicherte der gesetzlichen Krankenkassen muessen sich an den Ausgaben fuer ihre Gesundheit in Form von Zuzahlungen beteiligen. Wenn die Zuzahlungen die persoenliche Belastungsgrenze erreicht haben, erfolgt eine Zuzahlungsbefreiung fuer das laufende Jahr. Dies ist vom Arzt auf den entsprechenden Verordnungsformularen zu kennzeichnen.

**Akzeptanzkriterium:**

1. Hat ein Patient den Nachweis fuer die Zuzahlungsbefreiung erbracht und wird dies innerhalb des PVS als "gebuehrenfrei" verwaltet, wird spaetestens nach erfolgtem Jahreswechsel die Kennzeichnung "gebuehrenfrei" systemseitig fuer den Patienten geloescht.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### KP2-191 - Automatische Zuzahlungsbefreiung fuer Kinder und Jugendliche

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software stellt sicher, dass gesetzlich versicherte Patienten unter 18 Jahren im System, mit Ausnahme von Muster 4 (Verordnung einer Krankenbefoerderung), automatisch als "gebuehrenfrei" verwaltet werden.

**Begruendung:**

Fuer Kinder und Jugendliche unter 18 Jahren liegt keine Zuzahlungspflicht vor. Deshalb koennen Patienten unter 18 Jahren automatisch als "gebuehrenfrei" gekennzeichnet werden. Eine Ausnahme bilden Fahrkosten. Hier sind Kinder und Jugendliche unter 18 Jahren nicht automatisch von Zuzahlungen zu befreien.

**Akzeptanzkriterium:**

1. Patienten unter 18 Jahren werden im PVS automatisch als "gebuehrenfrei" verwaltet.
   a) Dabei ist zu beruecksichtigen, dass die automatische Zuzahlungsbefreiung zu Beginn des Quartals endet, in welchem der Patient das 18. Lebensjahr vollendet hat. (Gilt fuer GKV-Kassen mit 3.-5. Stelle der VKNR < 800)
2. Bei Eintritt des Patienten in die Zuzahlungspflicht wird der Anwender vom PVS ueber die Aenderung informiert.
3. In Muster 4 muss der Anwender explizit angeben, ob eine Zuzahlungsbefreiung fuer den Patienten vorliegt bzw. nicht vorliegt.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### 2.2.1.12 Speichern von Patientendaten im PVS

### KP2-195 - Trennung der Patientendaten des ambulanten und stationaeren Bereichs

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Abrechnungssoftware, die im ambulanten und im stationaeren Bereich eingesetzt werden kann, muss sicherstellen, dass Patientenstammdaten im stationaeren und ambulanten Bereich getrennt voneinander verarbeitet werden.

**Erlaeuterung:**

Wird die Abrechnung im stationaeren Bereich durchgefuehrt, muss fuer die Direktabrechnung mit der Krankenkasse immer das Hauptkassen-IK der Krankenkasse und nicht das von der Versichertenkarte eingelesene IK (gemaess P2-200 (4)) herangezogen werden. Fuer die KV-Abrechnung im ambulanten Bereich muss das gemaess "Mappingtabelle KVK" [KBV_ITA_VGEX_Mapping_KVK] interpretierte IK von der Versichertenkarte verwendet werden.

Der Hintergrund dieser Anforderung ist die Unterscheidung in die Bereiche Direktabrechnung mit der Krankenkasse (z. B. fuer stationaere Leistungen und Leistungen des ambulanten Operierens am Krankenhaus nach Par. 115b SGB V etc.) und der KV-Abrechnung.

**Beispiel:**

Wenn ein Patient im stationaeren Bereich behandelt wurde und dort seine Versichertenkarte eingelesen und die Daten in der Abrechnungssoftware verarbeitet wurden, der Patient aber spaeter im ambulanten Bereich weiterbehandelt wird, dann muss die Versichertenkarte erneut eingelesen und die Daten muessen separat verarbeitet werden.

---

## 2.2.2 Einsatz der universellen KT-Stammdatei (ehd)

### 2.2.2.1 Zuordnung des Kostentraegers (VKNR, IK und Krankenkassenname)

**IK als Suchschluessel**

### P2-200 - IK als Suchschluessel fuer einen Kostentraeger

**Typ:** PFLICHTFUNKTION ADT

1. Die 9-stellige Krankenkassennummer (IK) der Versichertenkarte muss als Suchschluessel fuer einen Kostentraeger verwendet werden, unabhaengig davon, ob
   a) das IK ueber die Versichertenkarte eingelesen
   b) oder (z.B. im Ersatzverfahren) manuell erfasst wird (siehe P2-410).
2. Ist das IK (unter Element `/kostentraeger/ik_liste/ik/@V`) in der KT-Stammdatei vorhanden, dann muss ein Kostentraeger-Stammsatz (`/kostentraeger/@V` der KT-Stammdatei(=VKNR)) eindeutig identifiziert werden koennen.
3. Die VKNR von der **Krankenversichertenkarte** darf nicht fuer die Abrechnung verwendet werden.
4. Wenn ein Element `////AbrechnenderKostentraeger/Kostentraegerkennung` auf der eGK existiert, muss verpflichtend dieses IK als Suchschluessel fuer einen Kostentraeger (vgl. "Mappingtabelle_KVK" [KBV_ITA_VGEX_Mapping_KVK]) und fuer die weitere Verarbeitung und Ausstellung der vertragsaerztlichen Formulare gemaess der nachfolgenden Fallunterscheidungen verwendet werden.

**Darueber hinaus gelten folgende FALLUNTERSCHEIDUNGEN:**

---

**IK ist gueltig**

### P2-210 - FALL 1 - IK ist gueltig

**Typ:** PFLICHTFUNKTION ADT

- IK_v sei ein IK von der Versichertenkarte und unter Element `/kostentraeger/ik_liste/ik/@V` in der KT-Stammdatei vorhanden
- LQ sei Leistungsquartal
- Der KV-Bereich des jeweiligen Anwenders sei nicht als Inhalt von `/kostentraeger/unz_kv_geltungsbereich_liste/unz_kv_geltungsbereich/@V` (nicht zulaessiger KV-Geltungsbereich) definiert
- KTAB_y sei ein dem Patienten zuzuordnender KT-Abrechnungsbereich

**Falls**

LQ liegt innerhalb von `/kostentraeger/gueltigkeit/@V` **und** von `/kostentraeger/ik_liste/ik/gueltigkeit/@V` **und** von `/kostentraeger/kt_abrechnungsbereich_liste/kt_abrechnungsbereich/gueltigkeit/@V`

**dann gilt:**

1. Der ueber das IK identifizierte Kostentraeger ist mit KTAB_y abrechenbar.
2. **IK_v** muss als eindeutiger Schluessel zur Identifikation des Kostentraegers verwendet werden.
3. Im Hinblick auf die ADT-Abrechnung muss ueber die KT-Stammdatei der KBV aus dem IK der Versichertenkarte (`kostentraeger/ik_liste/ik/@V`) die zugehoerige **Abrechnungs-VKNR** (`/kostentraeger/@V`) abgeleitet werden, unter der die ADT-Abrechnung (FK 4104 des ADT-Datenpaketes) erfolgt.
4. Das **IK_v** muss **patientenbezogen** gespeichert werden.
5. Der aus der KT-Stammdatei abgeleitete "Kassenname zur Bedruckung" (`/kostentraeger/kt_abrechnungsbereich_liste/kt_abrechnungsbereich/bedruckungsname/@V`) **muss** zur Ausstellung vertragsaerztlicher Formulare verwendet werden.

**Hinweis:**
Der Kostentraegername von der Versichertenkarte, der unter der FK 4134 in der ADT-Abrechnung uebertragen wird, **darf** zur Ausstellung vertragsaerztlicher Formulare **grundsaetzlich nicht** verwendet werden!
Vgl. auch Funktion P2-136 "Name des Kostentraegers von der Versichertenkarte" **und** Funktion "P2-220 (FALL 2 - Aufnehmender Kostentraeger, Fusion)", Ziffer (4).

---

**Aufnehmender Kostentraeger, Fusion**

### P2-220 - FALL 2 - Aufnehmender Kostentraeger, Fusion

**Typ:** PFLICHTFUNKTION ADT

- IK_v sei ein IK von der Versichertenkarte und unter Element `/kostentraeger/ik_liste/ik/@V` in der KT-Stammdatei vorhanden
- LQ sei Leistungsquartal
- KTAB_y sei ein dem Patienten zuzuordnender KT-Abrechnungsbereich

**Falls**

LQ liegt oberhalb des Gueltigkeitszeitraumes `/kostentraeger/gueltigkeit/@V` **und** `/kostentraeger/existenzbeendigung/@V="F"`

**dann gilt:**

1. Der Kostentraeger ist fusioniert. Der aufnehmende Kostentraeger ist durch `/kostentraeger/existenzbeendigung/aufnehmender_kostentraeger/@V` mit dem entsprechenden Datensatz verlinkt.
2. Die Abrechnungsfaehigkeit des aufnehmenden Kostentraegers mit KTAB_y muss durch Weiterverarbeitung analog zu "Fall 1 - IK ist gueltig" (siehe Funktion P2-210) ueberprueft werden. Es gelten die KTAB des **aufnehmenden** Kostentraegers. Fuer die Weiterverarbeitung sind dementsprechend die Eigenschaften des aufnehmenden Kostentraeges relevant.
3. Fuer die ADT-Abrechnung gilt unter Beruecksichtigung von Ziffer (2):
   a) "VKNR" des **aufnehmenden** (neuen) Kostentraegers ist zu verwenden.
   b) "IK" des **urspruenglichen** (alten) Kostentraegers ist zu verwenden.
   c) Sofern eine Versichertenkarte eingelesen wurde, gilt zusaetzlich Funktion P2-136 "Name des Kostentraegers von der Versichertenkarte".
4. Fuer die Ausstellung der vertragsaerztlichen Formulare gilt unter Beruecksichtigung von Ziffer (2):
   a) "Kassenname zur Bedruckung" des **aufnehmenden** (neuen) Kostentraegers ist zu verwenden.
   b) "IK" des **urspruenglichen** (alten) Kostentraegers ist zu verwenden.

**Beispiel Fusion:**

| urspruenglicher Kostentraeger | aufnehmender Kostentraeger |
|---|---|
| VKNR 13407, IK 102522653, existenzbeendigung V="F", aufnehmender_kostentraeger V="49402" | VKNR 49402, IK 106431685 |

Versichertenkarte IK: 102522653

In die KVDT-Abrechnungsdatei wird uebertragen:
- IK (FK 4111): 102522653
- VKNR (FK 4104): 49402
- Kostentraegername (von der Versichertenkarte (FK 4134)): BKK DER PARTNER

Fuer die Ausstellung wird verwendet:
- IK: 102522653
- Kassenname: pronova BKK (fuer bspw. KTAB="00")

**Beispiel Fusionskette:**

Ist der aufnehmende Kostentraeger wiederum selbst beendet und besitzt einen aufnehmenden Kostentraeger, spricht man von einer sog. "Fusionskette". Systemseitig wird dann das Ende der Fusionskette ermittelt, bis keine Existenzbeendigung mehr durch Fusion angezeigt wird.

Beispiel mit Fusionskette (VKNR 61402 -> 07423 -> 72601):

Versichertenkarte IK: 109920865

In die KVDT-Abrechnungsdatei wird uebertragen:
- IK (FK 4111): 109920865
- VKNR (FK 4104): 72601
- Kostentraegername (von der Versichertenkarte (FK 4134)): DIE BKK POST

Fuer die Ausstellung wird verwendet:
- IK: 109920865
- Kassenname: BARMER (fuer bspw. KTAB="00")

---

**Kostentraeger aufgeloest**

### P2-230 - FALL 3 - Kostentraeger aufgeloest

**Typ:** PFLICHTFUNKTION ADT

Die Software muss die Gueltigkeit eines Kostentraegers (konkret: die moegliche Aufloesung eines Kostentraegers) ueberpruefen.

**Begruendung:**

Diese Anforderung resultiert aus Par. 11, Absatz 1 und 2 der Anlage 6 BMV-Ae (Vertrag ueber den Datenaustausch auf Datentraegern).

**Akzeptanzkriterium:**

1. Die Software prueft nach den folgenden Bedingungen:
   a) IK_v sei ein IK von der Versichertenkarte und unter Element `/kostentraeger/ik_liste/ik/@V` in der KT-Stammdatei vorhanden
   b) LQ sei Leistungsquartal
   **Falls**
   - die Gueltigkeit des Kostentraegers unter `/kostentraeger/gueltigkeit/@V` abgelaufen **und**
   - der Kostentraeger aufgeloest ist `/kostentraeger/existenzbeendigung/@V="A"`, **dann**
   - ist das letzte abrechenbare Quartal des Kostentraegers unter `/kostentraeger/existenzbeendigung/letztes_quartal/@V` definiert.
   Wenn LQ oberhalb des letzten abrechenbaren Quartals liegt, **dann gilt:**
2. Systemseitig erfolgt eine **Fehlermeldung**, dass dieser Kostentraeger aufgeloest ist.
3. Die Software unterstuetzt keine direkte Weiterverarbeitung zum Zwecke der ADT-Abrechnung zu Lasten dieses Kostentraegers.
4. Die Software unterstuetzt nicht die Ausstellung vertragsaerztlicher Formulare zu Lasten dieses Kostentraegers bzw. den Ausdruck von BFB-Formularen.

---

**IK ungueltig**

### P2-260 - FALL 6 - IK ungueltig/abgelaufen

**Typ:** PFLICHTFUNKTION ADT

- IK_v sei ein IK von der Versichertenkarte und unter Element `/kostentraeger/ik_liste/ik/@V` in der KT-Stammdatei vorhanden
- LQ sei Leistungsquartal

**Falls**

LQ liegt oberhalb des Gueltigkeitszeitraumes `/kostentraeger/ik_liste/ik/gueltigkeit@V`

**dann gilt:**

1. Systemseitig erfolgt ein **WARNHINWEIS**, dass das vorliegende IK auf der Versichertenkarte ungueltig ist.
2. Falls der Anwender dennoch mit dem ungueltigem IK abrechnen moechte, muss das Abrechnungssystem dies ermoeglichen. Hierbei muss die Abrechnungsfaehigkeit des Kostentraegers mit dem zuzuordnenden KT-Abrechnungsbereich analog zu den Verarbeitungsroutinen gemaess "FALL 1 - IK ist gueltig" (siehe Funktion P2-210) ueberprueft werden.

---

**Kostentraeger nicht in KV zulaessig**

### P2-265 - FALL 7 - Kostentraeger nicht in KV zulaessig

**Typ:** PFLICHTFUNKTION ADT

Die Software muss die Gueltigkeit eines Kostentraegers in dem, fuer die Arztpraxis massgeblichen, KV-Bereich ueberpruefen.

**Begruendung:**

Diese Anforderung resultiert aus Regelungen durch regionale Vertraege zwischen einem der Kostentraeger und der/den Kassenaerztlichen Vereinigung(en).

Aufgrund dieser regionalen Vertraege kann ein Kostentraeger lediglich in einem (oder mehreren) KV-Bereich(en), und nicht grundsaetzlich bundesweit abgerechnet werden.

Bei diesen Kostentraegern wird der/die "nicht zulaessige(n) KV-Geltungsbereich(e)" im Element `"////unz_kv_geltungsbereich"` der Kostentraeger-Stammdatei explizit angegeben. Dies kann vor allem im Bereich der Sonstigen Kostentraeger (SKT) vorkommen.

**Akzeptanzkriterium:**

1. Die Software prueft nach den folgenden Bedingungen:
   a) IK_v sei ein IK von der Versichertenkarte und unter Element `/kostentraeger/ik_liste/ik/@V` in der KT-Stammdatei vorhanden.
   **Falls**
   der fuer die Arztpraxis massgebliche KV-Bereich unter `/kostentraeger/unz_kv_geltungsbereich_liste/unz_kv_geltungsbereich/@V` aufgefuehrt ist,
   **dann gilt:**
2. Systemseitig erfolgt eine **Fehlermeldung**, dass eine Abrechnung mit dem Kostentraeger in dem unter `kostentraeger/unz_kv_geltungsbereich_liste/unz_kv_geltungsbereich/@V` aufgefuehrten KV-Bereich unzulaessig ist.
3. Die Software unterstuetzt keine direkte Weiterverarbeitung zum Zwecke der ADT-Abrechnung zu Lasten dieses Kostentraegers.
4. Die Software unterstuetzt nicht die Ausstellung vertragsaerztlicher Formulare zu Lasten dieses Kostentraegers bzw. den Ausdruck von BFB-Formularen.

---

**Unbekanntes IK - temporaere Erweiterung KT-Stammdatei**

### P2-270 - FALL 8 - unbekanntes IK

**Typ:** PFLICHTFUNKTION ADT

IK_v sei ein IK von der Versichertenkarte und nicht in der KT-Stammdatei vorhanden (d.h. **IK_v** entspricht keinem IK unter Element `/kostentraeger/ik_liste/ik/@V` in der KT-Stammdatei).

**Dann gilt:**

1. Systemseitig erfolgt ein **WARNHINWEIS** mit der Aufforderung, sich mit der jeweiligen Kassenaerztlichen Vereinigung in Verbindung zu setzen.
2. **Temporaerer Stammsatz:**
   Auf Basis der auf der vorgelegten Versichertenkarte vorhandenen bzw. zusaetzlich von der Kassenaerztlichen Vereinigung uebermittelten Informationen werden die erforderlichen Angaben zu dem betreffenden Kostentraeger
   a) manuell als **temporaerer KT-Stammsatz** angelegt
   b) oder zu einem bestehenden Stammsatz das entsprechende **IK ergaenzt**.

**Anmerkung:**

Bei dem "unbekannten" IK handelt es sich vermutlich um einen neuen Kostentraeger.

---

### P2-275 - Temporaere Datensaetze zur KT-Stammdatei

**Typ:** PFLICHTFUNKTION ADT

Neue Kostentraeger muessen als temporaere Kostentraeger-Stammsaetze der KT-Stammdatei/Datenbank hinzugefuegt werden koennen.

1. Erforderliche Angaben fuer die Abrechnung sind neben dem gueltigen IK
   a) **Abrechnungs-VKNR** (`/kostentraeger/@V`)
   b) **KT-Abrechnungsbereich** (`/kostentraeger/kt_abrechnungsbereich_liste/kt_abrechnungsbereich/@V`)
   c) **Kassenname zur Bedruckung** (`/kostentraeger/kt_abrechnungsbereich_liste/kt_abrechnungsbereich/bedruckungsname/@V`)
   d) **Gebuehrenordnung** (`/kostentraeger/gebuehrenordnung/@V`)
2. Weitere Angaben zu dem manuell erzeugten Kostentraegerersatz sind darueber hinaus not-wendig, wenn der Anwender im gleichen Leistungsquartal den Kostentraeger nochmals ueber eine Suche (z.B. ueber den Kassensuchnamen `/kostentraeger/bezeichnung/suchname/@V` **und** Ortssuchnamen `/kostentraeger/ortssuchname_liste/ortssuchname/@V` ueber die KT-Stammdatei ausfindig machen moechte.
3. Bei manueller Eingabe der Abrechnungs-VKNR muessen systemseitig folgende Pruefungen durchgefuehrt werden:
   a) Laenge: 5-stellig
   b) Typ: numerisch
   c) Format-Regel: 017
4. Temporaere Datensaetze zur KT-Stammdatei **aus dem Vorquartal** duerfen der neuen KT-Stammdatei automatisch zugeordnet werden, wenn die entsprechenden IKs der temporaeren Datensaetze im Update zur neuen KT-Stammdatei **nicht** enthalten sind.
5. Der Anwender muss die Moeglichkeit haben, temporaere Stammsaetze zu veraendern bzw. KTAB's zu ergaenzen.
6. Wenn ein temporaer angelegtes IK zur KT-Stammdatei des Anwenders nicht in der Folgeversion der KT-Stammdatei enthalten ist, darf dieses IK der neuen KT-Stammdatei automatisch zugeordnet werden.

---

### K2-276 - bestehende KT-Stammsaetze erweitern

**Typ:** OPTIONALE FUNKTION ADT

1. Ist die zu einem "unbekannten IK" von der Kassenaerztlichen Vereinigung uebermittelte Abrechnungs-VNKR bereits in der amtlichen KT-Stammdatei vorhanden, dann darf dieses IK dem entsprechenden Stammsatz in der amtlichen KT-Stammdatei zusammen mit dem zugehoerigen KT-Abrechnungsbereich hinzugefuegt werden.
2. Fehlerhaft vorgenommene Erweiterungen muessen vom Anwender korrigiert werden koennen.

---

**KT-Abrechnungsbereich aufgeloest**

### P2-285 - FALL 10 - KT-Abrechnungsbereich aufgeloest

**Typ:** PFLICHTFUNKTION ADT

Die Software muss die Gueltigkeit eines Kostentraegers (konkret: die Gueltigkeit eines Kostentraeger-Abrechnungsbereichs zum vorliegenden Kostentraeger) ueberpruefen.

**Begruendung:**

Diese Anforderung resultiert aus vertraglichen Regelungen zwischen einem der Kostentraeger und der/den Kassenaerztlichen Vereinigung(en).

Der Kostentraeger-Abrechnungsbereich gibt die vertragliche Vereinbarung oder gesetzliche Regelung an, auf dessen Basis eine Abrechnung vollzogen werden soll.

**Akzeptanzkriterium:**

1. Die Software prueft nach den folgenden Bedingungen:
   a) IK_v sei ein IK von der Versichertenkarte und unter `/kostentraeger/ik_liste/ik/@V` in der KT-Stammdatei vorhanden
   b) LQ sei Leistungsquartal
   c) KTAB_y sei ein dem Patienten zuzuordnender KT-Abrechnungsbereich und es existiere ein Gueltigkeitsquartal des KT-Abrechnungsbereichs `/kostentraeger/kt_abrechnungsbereich_liste/kt_abrechnungsbereich/gueltigkeit/@V`.
   **Falls**
   **LQ liegt oberhalb des Gueltigkeitszeitraumes** `/kostentraeger/kt_abrechnungsbereich_liste/kt_abrechnungsbereich/gueltigkeit/@V`
   **dann gilt:**
2. Systemseitig erfolgt eine **Fehlermeldung**, dass der Kostentraeger-Abrechnungsbereich zum vorliegenden Kostentraeger nicht mehr gueltig ist.
3. Die Software unterstuetzt keine direkte Weiterverarbeitung zum Zwecke der ADT-Abrechnung zu Lasten dieses Kostentraegers mit diesem KT-Abrechnungsbereich.
4. Die Software unterstuetzt nicht die Ausstellung vertragsaerztlicher Formulare zu Lasten dieses Kostentraegers mit diesem KT-Abrechnungsbereich bzw. den Ausdruck von BFB-Formularen.

---

### 2.2.2.2 Abgleich der Versichertendaten

### KP2-300 - Abgleich der Versichertendaten beim Einlesen

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software stellt beim Einlesen der Versichertenkarte durch den Abgleich mit bereits gespeicherten Patientendaten systemseitig sicher, dass eine korrekte Identifikation erfolgt. Es duerfen weder Stammsaetze doppelt angelegt noch unbewusst ueberschrieben werden.

**Begruendung:**

Ein Abgleich der Versichertendaten mit bereits gespeicherten Patientendaten ist beim Einlesen der Versichertenkarte notwendig, um
- eine vorhandene Patientenstammdatei zum Patienten zu identifizieren
- redundante Patientenstammdatei zu einem Patienten zu vermeiden
- eine bereits vorhandene Patientenstammdatei nicht unbewusst zu ueberschreiben

**Akzeptanzkriterium:**

1. Beim Einlesen der Versichertenkarte stellt die Software durch den Abgleich mit bereits gespeicherten Patientendaten systemseitig
   a) die Identifikation einer bereits vorhandenen Patientenstammdatei zum Patienten,
   b) die Vermeidung von redundanten Patientenstammdatei zu einem Patienten sowie
   c) die Vermeidung von faelschlicherweisen Ueberschreibungen von Patientenstammdaten
   sicher.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

**Hinweis:**

Die folgende Suchstrategie wird zur Identifikation von bereits vorhandenen Patientendaten empfohlen:

1. IK, Versicherten-ID bzw. Versichertennummer, wenn nicht vorhanden oder nicht eindeutig...
2. Name, Vorname, Geburtsdatum, wenn nicht vorhanden ...
3. Anwenderorientierte Auswahlverfahren (Auswahlfenster)

> Falls eine eGK eingelesen wird, ist es ausreichend, als erstes Suchkriterium lediglich die Versicherten_ID (aus Element ../Versicherten_ID) - ohne IK - zu verwenden.
> Dabei sind Umlaute gleich zu behandeln, d.h. ue = ue.

---

### KP2-310 - Abgleich der Versichertendaten nach Kassenwechsel

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software stellt beim Kassenwechsel (vgl. P2-530) eines im System vorhandenen Patienten sicher, dass unmittelbar nach dem Einlesen der neuen Versichertenkarte der Anwender auf den Kassenwechsel hingewiesen wird.

**Begruendung:**

Der Anwender ist ueber den Kassenwechsel des bereits im System vorhandenen Versicherten zu informieren, sodass im Rahmen der Abgleichroutine Angaben von Feldern nicht unbewusst ueberschrieben werden.

**Akzeptanzkriterium:**

1. Bei einem Kassenwechsel eines im System vorhandenen Patienten wird unmittelbar nach dem Einlesen der neuen Versichertenkarte
   a) der Anwender, durch einen Warnhinweis, auf den Kassenwechsel hingewiesen
   b) jedes einzelne Feld - definiert in der [KBV_ITA_VGEX_Mapping_KVK] - der Versichertenkarte wird mit den Bestandsdaten im PVS abgeglichen. Bei Abweichungen der Daten sind die Unterschiede feldspezifisch in der Stammdatenmaske anzuzeigen.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### 2.2.2.3 Besonderheiten bei Kostentraegerabrechnungsbereich (FK 4106) / Versichertenkarten mit Angaben zu einer Besonderen Personengruppe (FK 4131)

### P2-320 - Setzen des Kostentraegerabrechnungsbereiches (KTAB; FK 4106) in Abhaengigkeit von der Besonderen Personengruppe (FK 4131)

**Typ:** PFLICHTFUNKTION ADT

Das System muss den Anwender, abhaengig von der eingelesenen bzw. erfassten Besonderen Personengruppe bei der Auswahl des KTABs unterstuetzen.

**Begruendung:**

Die Behandlung der durch eine Besondere Personengruppe gekennzeichneten Patienten fuehrt zu spezifischen Verguetungs- und/oder Abrechnungsregelungen.

**Akzeptanzkriterium:**

1. Das System muss bei Kennzeichnungen der besonderen Personengruppen (FK 4131) sicherstellen, dass der KTAB (FK 4106) nur eine bestimmte Werteauspraegung besitzen darf:
   a) Falls der Inhalt der FK 4131 = "00" ist, dann kann der Inhalt der FK 4106 einer der erlaubten Werte "00", "01", "02", "03", "04", "05", "06", "07", "08" oder "09" sein.
   b) Falls der Inhalt der FK 4131 = "04" ist, dann muss der Inhalt der FK 4106 entweder "00" oder "09" sein.
   c) Falls der Inhalt der FK 4131 = "06" ist, dann muss der Inhalt der FK 4106 entweder "02" oder "09" sein.
   d) Falls der Inhalt der FK 4131 = "07" oder "08" ist, dann muss der Inhalt der FK 4106 entweder "01" oder "09" sein.
2. Eine automatische Vorbelegung des Inhaltes der FK 4106 durch das System **ist moeglich**:
   a) Falls der Inhalt der FK 4131 = "00" ist, dann muss bei einer automatischen Vorbelegung der FK 4106 der Inhalt gleich "00" sein.
   b) Falls der Inhalt der FK 4131 = "04" ist, dann muss bei einer automatischen Vorbelegung der FK 4106 der Inhalt gleich "00" sein.
   c) Falls der Inhalt der FK 4131 = "06", dann muss bei einer automatischen Vorbelegung der FK 4106 der Inhalt gleich "02" sein.
   d) Falls der Inhalt der FK 4131 = "07" oder "08", dann muss bei einer automatischen Vorbelegung der FK 4106 der Inhalt gleich "01" sein.
3. Eine automatische Vorbelegung des Inhaltes zu FK 4106 durch das System **ist erforderlich**:
   a) Falls der Inhalt der FK 4131 = "09" ist, dann muss eine automatische Vorbelegung der FK 4106 mit dem Inhalt gleich "00" erfolgen.
4. Der Anwender muss die Moeglichkeit haben die nach Akzeptanzkriterium 2 und 3 vorbelegten Werte zu aendern.

---

### P2-325 - Hinweis bei Besonderer Personengruppe "09"

**Typ:** PFLICHTFUNKTION ADT

Die Software muss den Anwender ueber den eingeschraenkten Leistungsanspruch der Empfaenger von Gesundheitsleistungen nach den Par.Par. 4 und 6 AsylbLG informieren.

**Begruendung:**

Par.Par. 4 und 6 des Asylbewerberleistungsgesetzes (AsylbLG) regeln den Umfang von Gesundheitsleistungen fuer Asylbewerber. Der Umfang von Gesundheitsleistungen von Asylbewerbern (Anspruchsberechtigte mit weniger als 15 Monaten Aufenthaltsdauer) und gesetzlich-krankenversicherten (GKV)-Patienten unterscheidet sich, und sollte bei der Leistungserbringung vom Anwender beachtet werden.

**Akzeptanzkriterium:**

1. Falls eine eGK mit der besonderen Personengruppe "09" eingelesen (nach erfolgtem Mapping laut der "Technischen Anlage zur Anlage 4a" [KBV_ITA_VGEX_Mapping_KVK]) wird, muss die Software den Anwender unmittelbar auf die Beachtung des eingeschraenkten Leistungsanspruches der Empfaenger von Gesundheitsleistungen nach den Par.Par. 4 und 6 AsylbLG hinweisen.
2. Dies gilt auch, wenn die Daten von einem mobilen Kartenterminal in ein PVS uebernommen werden.
3. Der Anwender soll auch bei der manuellen Erfassung entsprechender Faelle analog (1) informiert werden.
4. Der Anwender muss die Funktion deaktivieren koennen, standardmaessig soll diese Funktion aktiviert sein.
5. Der Hinweis darf den Workflow des Arztes nicht unterbrechen.

---

## 2.2.3 Patientenstammdaten "manuell" erfassen

Neben dem Einlesen einer Versichertenkarte existieren weitere Moeglichkeiten, Patientenstammdaten zu erfassen, z.B.:

- Patientenstammdaten manuell ueber Tastatur eingeben (z.B. bei Versicherten der Sonstigen Kostentraeger ohne KVK oder bei Muster 85),
- gedruckte Patientenstammdaten (z.B. Ueberweisungsschein im Labor) scannen und interpretieren.

### 2.2.3.1 Definition Ersatzverfahren

Das Ersatzverfahren ist eine besondere Form der "manuellen" Erfassung von Patientenstammdaten und wird wie folgt definiert:

**Ersatzverfahren** liegt vor, wenn

- der Arzt noch nicht am VSDM nach Punkt 1.3 (der Anlage 4a BMV-Ae, Anhang 1) teilnimmt und der Versicherte darauf hinweist, dass sich die zustaendige Krankenkasse, die Versichertenart oder die Besondere Personengruppe geaendert hat, die Karte dies aber noch nicht beruecksichtigt,
- die Karte defekt ist,
- eine fuer das Einlesen der Karte erforderliche Komponente defekt ist,
- die Karte nicht benutzt werden kann, weil fuer Haus- und Heimbesuche kein entsprechendes Geraet zur Verfuegung steht und keine bereits in der Arztpraxis mit den Daten der elektronischen Gesundheitskarte vorgefertigten Formulare verwendet werden koennen oder
- die VSDs von der eGK falsch sind und nicht uebernommen werden muessen (Anlage 4a BMV-Ae, Anhang 1, Punkt 1.5).
- bei einer Untersuchung oder Behandlung eines Patienten bis zum vollendeten 3. Lebensmonat noch keine eGK vorgelegt werden kann (Anlage 4a BMV-Ae, Anhang 1, Punkt 2.8).
- die elektronische Ersatzbescheinigung (eEB) (Anlage 4a BMV-Ae, Anhang 1 Punkt 2.9), aufgrund der nicht Vorlage der erforderlichen Karte, zum Einsatz kam.

Im Ersatzverfahren sind sinnigemaess nach Punkt 2.5 der Anlage 4a BMV-Ae, Anhang 1 mindestens folgende Angaben zu erfassen und im Rahmen der ADT-Abrechnung zu uebertragen:

- 2.5.1 IK (FK 4111).
- 2.5.2 Vorname (FK 3102), Name (FK 3101), Geburtsdatum (FK 3103)
- 2.5.3 Versichertenart (FK 3108)
- 2.5.4 PLZ (FK 3112) oder PostfachPLZ (FK 3121)
- 2.5.5 nach Moeglichkeit Versicherten-ID (FK 3119). Beziehungsweise bei Sonstigen Kostentraegern die Versichertennummer (FK 3105), vgl. KP2-101

Diese eingeschraenkte Erfassung und Uebertragung von Versichertendaten im Rahmen der ADT-Abrechnung, die das Ersatzverfahren erlaubt, findet keine Anwendung im Rahmen der "manuellen" Erfassung eines Nachweises zur berechtigten Inanspruchnahme aerztlicher Leistungen (z.B. Laborueberweisung, Muster 85). In diesen Faellen ist immer eine Vollerfassung der Versichertendaten des Personalienfeldes durch den Anwender erforderlich.

Zudem koennen die Daten im Ersatzverfahren verwendet werden, wenn die im Rahmen des VSDM bereitgestellten Daten nicht den Felddefinitionen und Auspraegungen in Nummer 2.2.1 der Technischen Anlage zu Anlage 4a BMV-Ae entsprechen.

Ansonsten gilt grundsaetzlich unabhaengig vom Erfassungsverfahren, dass alle vorhandenen Versichertendaten umfassend und unveraendert in ein Abrechnungssystem zu uebernehmen und im Rahmen der Abrechnung zu uebertragen sind.

---

### P2-400 - "Ersatzverfahren" anwenden bzw. Versichertendaten "manuell" erfassen

**Typ:** PFLICHTFUNKTION ADT

Die Software muss beim Ersatzverfahren und in allen Faellen, in denen keine Versichertenkarte vorgelegt wird oder werden kann, die Eingabe, Speicherung und Uebertragung saemtlicher vorhandener Versichertendaten in die Abrechnung ermoeglichen.

**Begruendung:**

Gemaess "Richtlinien der Kassenaerztlichen Bundesvereinigung fuer den Einsatz von IT-Systemen in der Arztpraxis zum Zweck der Abrechnung gemaess Par. 295 Abs. 4 SGB V, Par. 1 Datenverarbeitungstechnisches Abrechnungsverfahren, Absatz 1 muessen alle fuer die Abrechnung relevanten Daten elektronisch uebertragen werden koennen.

Rechtsgrundlage im Rahmen der "Auftrags- und Konsiliaruntersuchung" ist des Weiteren Anlage 4a BMV-Ae, Anhang 1, Punkt 3 sowie im Rahmen der "Datenuebernahme ohne persoenlichen Arzt-Patienten-Kontakt" Anlage 4a BMV-Ae, Anhang 1, Punkt 4.

Rechtsgrundlagen fuer ein Ersatzverfahren sind Anlage 4a BMV-Ae, Anhang 1, Punkte 2.4 und 2.5 sowie Anlage 4a BMV-Ae, Anhang 1, Punkt 2.3.

**Akzeptanzkriterium:**

1. Die Software stellt dem Anwender alle Erfassungsfelder zur Verfuegung. Diese sind:

#### Tabelle 5 - Datenangaben im Ersatzverfahren / "manuelle" Erfassung von Versichertendaten

| Bezeichnung | FK gem. ADT | Mindestangabe |
|---|---|---|
| Namenszusatz | 3100 | |
| Vorsatzwort | 3120 | |
| Name | 3101 | X |
| Vorname | 3102 | X |
| Geburtsdatum | 3103 | X |
| Titel | 3104 | |
| Versichertennummer (nur zulaessig bei Sonstigen Kostentraegern, vgl. KP2-101) | 3105 | |
| Versicherten_ID | 3119 | |
| VersicherungsschutzBeginn | 4133 | |
| VersicherungsschutzEnde | 4110 | |
| Kostentraegerkennung | 4111 | X |
| WOP | 3116 | |
| DMP-Kennzeichnung | 4132 | X (vgl. P2-402) |
| BesonderePersonengruppe | 4131 | X (vgl. P2-401) |
| Versichertenart | 3108 | X |
| Geschlecht | 3110 | X |
| Strassenadresse: | | |
| Strasse | 3107 | |
| PLZ | 3112 | X |
| Ort | 3113 | |
| Hausnummer | 3109 | |
| Wohnsitzlaendercode | 3114 | |
| Postfachadresse: | | |
| PostfachPLZ | 3121 | X |
| PostfachOrt | 3122 | |
| Postfach | 3123 | |
| PostfachWohnsitzlaendercode | 3124 | |
| Sonstige Kostentraeger ohne Versichertenkarte: | | |
| Personenkreis/Untersuchungskategorie | 4123 | |
| SKT-Zusatzangaben | 4124 | |
| SKT-Bemerkungen | 4126 | |
| Gueltigkeitszeitraum von ... bis ... | 4125 | |

> Es reicht also, wenn als 5-stellige numerische Ziffernkette erfasste Postleitzahl des Patienten in der SDPLZ existiert.
> Es ist ausreichend, wenn entweder die PLZ der Strassenadresse oder die PLZ der Postfachadresse vorhanden ist.

2. Die Software stellt sicher, dass die in Tabelle 5 genannten Mindestangaben vom Anwender erfasst werden.
3. Die Software weist mit einem Hinweis den Anwender daraufhin, alle in Tabelle 5 genannten Daten erfasst werden koennen und sofern vorhanden erfasst werden sollen. Die Hinweisgabe soll ohne Unterbrechung des Workflows erfolgen.
4. Die Software uebertraegt die vom Anwender erfassten Versichertendaten gemaess Tabelle 5 in die Abrechnung.

**Hinweis:**

Fuer die Weiterverarbeitung der o.a. Daten gelten - mit Ausnahme der Restriktionen zur "Amtlichkeit" - grundsaetzlich die gleichen Vorgaben, wie sie auch bei einem Einlesevorgang ueber ein Kartenterminal beachtet werden muessen.

Der Hinweis in Akzeptanzkriterium 3. kann bspw. in Form eines einzelnen Hinweistextes erfolgen oder in einer anderen passenden Form.

---

### KP2-404 - Unterstuetzung des Empfangs einer elektronischen Ersatzbescheinigung (eEB) von Krankenkassen

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Die Software muss den Empfang einer eEB von Krankenkassen gemaess den Regelungen der Technischen Anlage eEB [TA_eEB] unterstuetzen.

**Begruendung:**

Der Gesetzgeber hat im Zuge der Anpassung des Par. 291 Absatz 9 SGB V festgelegt, dass eine versicherte Person, die bei dem ersten Arzt-Patienten-Kontakt im Quartal keine elektronische Gesundheitskarte vorlegen kann, ersatzweise einen Nachweis der Berechtigung zum Leistungsanspruch ueber eine von ihrer Krankenkasse angebotene Benutzeroberflaeche elektronisch anfordern kann.

Die Vertragspartner des Bundesmantelvertrag-Aerzte (BMV-Ae) haben entsprechende Regelungen getroffen, welche das Verfahren zur Uebermittlung der Ersatzbescheinigung in elektronischer Form ermoeglichen - kurz elektronischen Ersatzbescheinigung (eEB). Die allgemeinen Vorgaben hierzu sind in den Anlagen 4a und 4b BMV-Ae enthalten.

Grundsaetzlich sieht das Verfahren vor, dass Versicherte ueber die App ihrer Krankenkasse die Uebermittlung der Versichertendaten (nach Par. 291a Abs. 2 und 3 SGB V) an eine ausgewaehlte Praxis veranlassen koennen. Die Krankenkassen uebermitteln die Daten nach Anforderung als (FHIR-)Datensatz unmittelbar ueber die sichere Kommunikation im Medizinwesen (KIM) an die ausgewaehlte Arztpraxis.

**Akzeptanzkriterium:**

1. Die Software stellt dem Anwender die Funktionen gemaess der Technischen Anlage eEB [TA_eEB] zur Verfuegung.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

**Hinweis:**

Die Regelungen gemaess der Technischen Anlage eEB koennen ab sofort eingesetzt werden und muessen **spaetestens ab Juli 2025** in den Arztpraxen zur Verfuegung stehen.

---

### KP2-405 - Abrechnung von Leistungen mit der elektronischen Ersatzbescheinigung (eEB) als Versicherungsnachweis

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Bei der Uebernahme der Versichertendaten aus einer eEB muss die Software den Wert 1 in das Feld "eEB vorhanden" (FK 4112) uebertragen.

**Begruendung:**

Die Feldkennung 4112 in der Abrechnung dient zur Nachvollziehbarkeit der eEB als Quelle der Versichertendaten.

**Akzeptanzkriterium:**

1. Wenn die Versichertendaten aus einer eEB uebernommen werden, dann kennzeichnet die Software den jeweiligen Datensatz der Abrechnung mit dem Wert 1 in der FK 4112.
2. Wenn die Versichertendaten nicht aus einer eEB uebernommen werden, muss die Software sicherstellen, dass die FK 4112 nicht in dem jeweiligen Datensatz der Abrechnung uebertragen wird.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### P2-401 - "Defaultwert" Besondere Personengruppe im Rahmen des Ersatzverfahrens

**Typ:** PFLICHTFUNKTION ADT

Im Rahmen des Ersatzverfahrens wird fuer die Besondere Personengruppe der Defaultwert "00" uebertragen.

**Begruendung:**

Da die Uebertragung der Besonderen Personengruppe seit dem 1. Juli 2018 verpflichtend ist, soll der Anwender bei der Erfassung im Ersatzverfahren unterstuetzt werden.

Erfolgt nach einem Kassenwechsel die Erfassung im Ersatzverfahren (z.B. weil die neue eGK noch nicht zugestellt wurde), muss - unabhaengig von der Belegung des Feldes bei der alten Kasse - die Vorbelegung mit dem Defaultwert "00" erfolgen.

**Akzeptanzkriterium:**

1. Im Rahmen des Ersatzverfahrens wird die Besondere Personengruppe (FK 4131) wie folgt vorbelegt:
   a) Wenn fuer den Patienten in der Software bereits ein Wert vorhanden ist (bspw. aus dem Vorquartal), dann wird das Eingabefeld der Besonderen Personengruppe mit dem bereits vorhandenen Wert vorbelegt.
   b) Wenn fuer den Patienten in der Software kein Wert oder der Patient noch nicht in der Software vorhanden ist oder bei gleichzeitigem Kassenwechsel (vgl. P2-530), dann wird die Besondere Personengruppe mit dem Defaultwert "00" fuer die Abrechnung vorbelegt (eine Anzeige im Eingabefeld ist nicht zwingend erforderlich).
2. Der Anwender kann im Rahmen des Ersatzverfahrens den vorbelegten Wert ueberschreiben.
3. Wenn der Anwender im Rahmen der Dateneingabe keine Besondere Personengruppe eingibt, dann uebertraegt die Software entweder vorrangig den bereits bekannten Wert oder den Defaultwert "00" in der FK 4131 in die Abrechnung.

---

### P2-402 - "Defaultwert" DMP-Kennzeichen im Rahmen des Ersatzverfahrens

**Typ:** PFLICHTFUNKTION ADT

Im Rahmen des Ersatzverfahrens wird fuer das DMP-Kennzeichen der Defaultwert "00" uebertragen.

**Begruendung:**

Da die Uebertragung des DMP-Kennzeichens seit dem 1. Juli 2018 verpflichtend ist soll der Anwender bei der Erfassung im Ersatzverfahren unterstuetzt werden.

Erfolgt nach einem Kassenwechsel die Erfassung im Ersatzverfahren (z.B. weil die neue eGK noch nicht zugestellt wurde), muss - unabhaengig von der Belegung des Feldes bei der alten Kasse - die Vorbelegung mit dem Defaultwert "00" erfolgen.

**Akzeptanzkriterium:**

1. Im Rahmen des Ersatzverfahrens wird das DMP-Kennzeichen (FK 4132) wie folgt vorbelegt:
   a) Wenn fuer den Patienten in der Software bereits ein Wert vorhanden ist (bspw. aus dem Vorquartal), dann wird das Eingabefeld des DMP-Kennzeichens mit dem bereits vorhandenen Wert vorbelegt.
   b) Wenn fuer den Patienten in der Software kein Wert oder der Patient noch nicht in der Software vorhanden ist oder bei gleichzeitigem Kassenwechsel (vgl. P2-530), dann wird das DMP-Kennzeichen mit dem Defaultwert "00" fuer die Abrechnung vorbelegt (eine Anzeige im Eingabefeld ist nicht zwingend erforderlich).
2. Der Anwender kann im Rahmen des Ersatzverfahrens den vorbelegten Wert ueberschreiben.
3. Wenn der Anwender im Rahmen der Dateneingabe kein DMP-Kennzeichen eingibt, dann uebertraegt die Software entweder vorrangig den bereits bekannten Wert oder den Defaultwert "00" in der FK 4132 in der Abrechnung.

---

### P2-403 - Naehere Informationen zur DMP-Kennzeichnung

**Typ:** PFLICHTFUNKTION ADT

Das System muss sicherstellen, dass dem Anwender die Bedeutung zu den Werten der DMP-Kennzeichnung im Feld FK 4132 zur Verfuegung gestellt werden.

**Begruendung:**

Der Anwender soll bei der Identifikation der DMPs, in denen ein Versicherter ggf. eingeschrieben ist, unterstuetzt werden.

**Akzeptanzkriterium:**

1. Der Anwender muss die Moeglichkeit haben, sich die Bedeutung eines DMP-Kennzeichens anzeigen zu lassen.

**Hinweis:**

Unter [S_KBV_DMP] werden alle zulaessigen DMP-Kennzeichen sowie deren Bedeutung veroeffentlicht.

Softwarehersteller koennen mit der Anzeige des Wertes auch immer die Bedeutung mit anzeigen.

---

### 2.2.3.2 Suchhilfen IK / Identifizierung eines KT-Stammsatzes

### P2-410 - Identifizierung eines KT-Stammsatzes und Weiterverarbeitung im Rahmen der manuellen Erfassung bzw. im Ersatzverfahren

**Typ:** PFLICHTFUNKTION ADT

Die Software unterstuetzt den Anwender im Rahmen der manuellen Erfassung bzw. im Ersatzverfahren bei der Identifikation eines Kostentraegers in der Kostentraeger-Stammdatei.

**Begruendung:**

Diese Anforderung resultiert aus Par. 1 der Anlage 6 BMV-Ae (Vertrag ueber den Datenaustausch auf Datentraegern). Der Anwender muss einen Kostentraeger in der Kostentraeger-Stammdatei zur Ueberpruefung der Abrechnungsfaehigkeit dieses Kostentraegers identifizieren koennen.

**Akzeptanzkriterium:**

1. Falls ein IK zur Identifikation eines Kostentraegers vorliegt, muss die Software dem Anwender die Moeglichkeit bieten, ueber die manuelle Eingabe dieses IKs einen Kostentraeger in der KT-Stammdatei zu identifizieren (vgl. auch P2-200).
2. Die Software stellt dem Anwender darueber hinaus weitere Suchkriterien wie VKNR, Kassenname, Kassensuchname und/oder Ortssuchname zur Identifizierung eines Kostentraegers in der KT-Stammdatei zur Verfuegung.
3. Falls ein Kostentraeger identifiziert werden konnte, muss die Software zur Ueberpruefung der Abrechnungsfaehigkeit dieses Kostentraegers mit einem KT-Abrechnungsbereich und fuer die Verarbeitung des Kassennamens und der VKNR alle Vorgaben und Fallunterscheidungen gemaess Kapitel 2.2.2.1 umsetzen.

---

### P2-420 - Programmierte Suchhilfen zur Identifikation eines Kostentraegers bei Nichtvorlage eines IK

**Typ:** PFLICHTFUNKTION ADT

Die Software unterstuetzt den Anwender im Rahmen der manuellen Erfassung bzw. im Ersatzverfahren bei der Suche und Auswahl des korrekten Kostentraegers.

**Begruendung:**

Aufgrund der hohen Anzahl von moeglichen Kostentraegern fuer die Abrechnung muss der Anwender bei Auswahl eines Kostentraegers unterstuetzt werden, um moegliche Abrechnungsprobleme zu verhindern.

**Akzeptanzkriterium:**

1. Liegt **kein** IK zur Identifikation eines Kostentraegers vor, dann gilt:
   a) Der Anwender muss **mindestens** die Moeglichkeit haben ueber
      - den "Kassensuchnamen" laut der KT-Stammdatei (XML-Element: `/kostentraeger/bezeichnung/suchname/@V`) **und/oder**
      - den "Ortssuchnamen" laut der KT-Stammdatei (XML-Element: `/kostentraeger/ortssuchname_liste/ortssuchname/@V`) oder
      - der 5-stelligen VKNR einen Kostentraeger
      zu suchen.
   b) Enthaelt der von dem Anwender ausgewaehlte Kostentraeger mehrere gueltige IKs (`/kostentraeger/ik_liste/ik/@V`), so ist stets das sogenannte "Abrechnungs-IK" zur Abrechnung bzw. zur Ausstellung der vertragsaerztlichen Formulare zu verwenden (Das XML-Element enthaelt das Attribut `R="abrechnungs_ik"`)
      **Hinweis:** Diese Vorgabe gilt nicht, wenn vom Anwender ein IK im Rahmen der Identifizierung des KT-Stammsatzes gemaess P2-410 manuell erfasst wurde!
   c) Ist ein Kostentraeger vom Anwender ausgewaehlt, dann gelten zur Ueberpruefung der Abrechnungsfaehigkeit eines Kostentraegers mit einem KT-Abrechnungsbereich und fuer die Verarbeitung des Kassennamens und der VKNR die Vorgaben und Fallunterscheidungen gemaess Kapitel 2.2.2.1.

**Hinweis:**

In den Datensaetzen der von der KBV ausgelieferten KT-Stammdatei koennen vom Softwareverantwortlichen oder von der Praxis spezielle Suchfelder ergaenzt werden, die das schnelle Auffinden eines Kostentraegers zusaetzlich erleichtern.

**Hinweis zur Verwendung des Kostentraegers mit der VKNR 38825:**

Fuer die Arzneimittelrezepte (Muster 16) fuer den Bezug von Corona-Impfstoffen durch die Arztpraxen ist der Kostentraeger "Bundesamt fuer Soziale Sicherung" (VKNR 38825) zu verwenden, ab dem 1. Juli 2021 muss das IK 103609999 (besitzt das Attribut `R="abrechnungs_ik"`) zur Ausstellung verwendet werden.

---

### 2.2.3.3 Geburtsdatum mit besonderem Wertebereich

### P2-430 - Geburtsdatum mit besonderem Wertebereich

**Typ:** PFLICHTFUNKTION ADT

Ein Geburtsdatum kann ausserhalb des ueblichen Datumsformats liegen; daher gilt:

Ein Geburtsdatum muss mit seinem definierten Wertebereich vollstaendig erfasst und verarbeitet werden koennen.

**Wertebereich** FK 3103 (Geburtsdatum) im KVDT: JJJJMMTT, JJJJMM00, JJJJ0000, 00000000

---

## 2.2.4 Besonderheiten bei Versicherten der Sonstigen Kostentraeger

### 2.2.4.1 Zusatzangaben

### P2-440 - Sonstige Kostentraeger im ADT

**Typ:** PFLICHTFUNKTION ADT

Die von der jeweils zustaendigen Kassenaerztlichen Vereinigung geforderten Zusatzangaben bei der Abrechnung Sonstiger Kostentraeger - gemaess Satzart "kvx3" der KV-Spezifika-Stammdatei - muessen vom Anwender verwendet (erfasst und uebertragen) werden koennen.

**Anmerkung:**

Fuer die Handhabung der sonstigen Kostentraeger in der ADT-Abrechnung gibt es **keine bundeseinheitlichen Regelungen**. Beispielsweise gibt es spezielle Sonstige Kostentraeger, die nicht bundesweit, sondern nur in einer Kassenaerztlichen Vereinigung abgerechnet werden duerfen.

Allgemeine Abrechnungsvorgaben zu einem Sonstigen Kostentraeger werden mit dem jeweiligen Kostentraeger-Stammsatz festgelegt. Jede Kassenaerztliche Vereinigung definiert ihre zusaetzlich erforderlichen Abrechnungsinformationen in einer KV-Spezifika-Stammdatei (SDKV).

### 2.2.4.2 Bundesweit gueltiger Sonstiger Kostentraeger

Fuer den nachfolgend definierten bundesweit gueltigen Sonstigen Kostentraeger wurde vertraglich eine **verbindliche** elektronische Abrechnung mittels KVDT/ADT vereinbart. Fuer diesen SKT gelten besondere Anforderungen/Hinweise, die nachfolgend definiert sind.

#### 1.1.2.2.1 Sonstiger Kostentraeger "Bundeswehr"

### P2-452 - Sonstiger Kostentraeger "Bundeswehr"

**Typ:** PFLICHTFUNKTION ADT

Naeheres ist geregelt im "Vertrag ueber die aerztliche Versorgung von Soldaten der Bundeswehr / Untersuchungen zur Durchfuehrung der allgemeinen Wehrpflicht sowie Untersuchungen zur Vorbereitung von Personalentscheidungen und betriebs- und fuersorgeaerztliche Untersuchungen" zwischen Bundesministerium der Verteidigung / KBV ([Vertrag_Bundeswehr_KBV]).

Im Zusammenhang mit der elektronischen Abrechnung des bundesweit gueltigen SKT Bundeswehr ist folgendes zu beachten:

1. Die Zuordnung der Kostentraeger muss manuell erfolgen. Je nach Typ des Behandlungsscheins (Ueberweisungsschein fuer Ueberweisungsauftraege der Bundeswehr (Vordruck San/Bw/0217) oder Ueberweisungsschein zur Feststellung der Wehrdienstfaehigkeit (Vordruck San/Bw/0117)) muss die Behandlung zu Lasten folgender Kostentraeger erfolgen:

#### Tabelle 6 - Zuordnung sonstiger Kostentraeger "Bundeswehr"

| Behandlungsscheintyp | Kostentraeger |
|---|---|
| Ueberweisungsschein fuer Ueberweisungsauftraege der Bundeswehr (Par. 75 Abs. 3 SGB V) | VKNR: 79868, Suchname: BA fuer PM der Bundeswehr, Ref. I 2.3.5, Kurzname: BUNDESWEHR |
| Ueberweisungsschein zur Feststellung der Wehrdienstfaehigkeit (WE) (Par. 75 Abs. 3 SGB V) | VKNR: 79869, Suchname: BA fuer PM der Bundeswehr, Ref. I 2.3.5, Kurzname: BUNDESWEHR MUSTERG |

2. Die "Personenkennziffer" ist gemaess den Einstellungen der KV-Spezifika (kvx3) als SKT-Zusatzangabe unter der FK 4124 (SKT-Zusatzangaben) zu erfassen und zu uebertragen. Die "Personenkennziffer" muss dem Format "TTMMJJannnnn" entsprechen. Gemaess Par. 3 Ueberweisungsverfahren, Absatz (5) des o.g. Vertrages duerfen Vertragsaerzte seit 1. Januar 2013 Ueberweisungen fuer Laborleistungen, zytologische Leistungen und Roentgenleistungen, sowie fuer anaesthesiologische Leistungen im Rahmen ambulanter Operationen ausstellen. Eine sonstige Weiterueberweisung an einen anderen Vertragsarzt oder Vertragspsychotherapeuten ist ausserhalb des Notfalls nicht ohne weiteres zulaessig, vgl. Par. 3 Ueberweisungsverfahren.

   In diesem Zusammenhang ist zu beachten, dass die "Personenkennziffer" gemaess P7-45 "Ausdruck Inhalt des Feldes 4124 (SKT-Zusatzangaben", "Anforderungskatalog Formularbedruckung" [KBV_ITA_VGEX_Anforderungskatalog_Formularbedruckung] grundsaetzlich im Format "TTMMJJannnnn" im Feld "Versicherten-Nr." des Personalienfeldes auszudrucken ist.

3. Gemaess den Einstellungen der KV-Spezifika (kvx3) ist ggf. eine "Abweichende Gueltigkeitsdauer" zu erfassen und unter der FK 4125 (Gueltigkeitszeitraum von ... bis ...) zu uebertragen.

---

## 2.2.5 Postleitzahl des Wohnsitzes des Patienten (bei Ersatzverfahren)

### P2-460 - Existenzpruefung ueber PLZ-Stammdatei der KBV bei KTAB=00

**Typ:** PFLICHTFUNKTION ADT

Die in das Feld 3112 und/oder 3121 zu uebertragende Postleitzahl des Patienten muss auf Existenz gegen die **PLZ-Stammdatei der KBV** nur dann geprueft werden, wenn die Postleitzahl manuell durch **Ersatzverfahren** erfasst wurde; der ADT-Abrechnungsdatensatz also kein Einlesedatum (FK 4109) enthaelt und zusaetzlich der Kostentraeger-Abrechnungsbereich (KTAB, FK 4106) **mit "00"** definiert ist.

Liegt ein Ersatzverfahren vor und ist somit eine Existenzpruefung erforderlich, ist folgende Fallunterscheidung zu beachten:

**Fall a)**

Falls die in der Abrechnungssoftware vorliegende Postleitzahl des Patienten in der PLZ-Stammdatei (Referenzierung Feld 0150) **existiert**, muss diese in das Feld 3112 bzw. 3121 des ADT-Abrechnungsdatensatzes uebernommen werden. Die Existenzpruefung erfolgt unabhaengig davon, ob es sich um eine auslaendische Postleitzahl handelt oder nicht.

**Fall b)**

Falls die in der Abrechnungssoftware vorliegende Postleitzahl des Patienten in der PLZ-Stammdatei (Referenzierung Feld 0150) **nicht existiert**, dann

1. muss ein Warnhinweis erfolgen, dass diese vorliegende Postleitzahl des Patienten nicht in der PLZ-Stammdatei existiert und entsprechend geaendert werden muss.
2. darf die vorliegende Postleitzahl nicht in den ADT-Abrechnungsdatensatz uebertragen werden.
3. muss der Anwender eine geeignete Korrektur nach folgender Massgabe vornehmen:
   a) Wohnt der Patient im Inland, muss eine dem Patienten zugehoerige Postleitzahl in den ADT-Abrechnungsdatensaetzen uebertragen werden, die in der PLZ-Stammdatei der KBV existiert.
      Falls keine "gueltige" PLZ ermittelt werden kann, dann wird in den ADT-Abrechnungsdatensatz in das Feld 3112 bzw. 3121 (PLZ/PostfachPLZ) die Postleitzahl des Praxissitzes des behandelnden Arztes (Inhalt Feld 0215, Satzart "besa") uebernommen.
      **Hinweis:** Sofern eine "neu vergebene" Postleitzahl des Patienten vorliegt, die noch nicht in der PLZ-Stammdatei enthalten ist und die Postleitzahl des Praxissitzes des behandelnden Arztes entspricht, dann muss die "alte" Postleitzahl des Standortes in das Feld 3112 bzw. 3121 uebernommen werden. In diesem Fall ist es ausreichend, wenn die Software den Anwender entsprechend darauf hinweist und der Anwender die "alte" PLZ manuell erfasst.
   b) Wohnt der Patient im Ausland, dann wird in den ADT-Abrechnungsdatensatz in das Feld 3112 (PLZ) als Postleitzahl-Dummy fuenfmal die Neun (99999) geschrieben. (Die auslaendische Postleitzahl des Patienten wird also in diesem Fall durch 99999 ersetzt.)
      **Hinweis:** Dieser Ersatzwert dient ausschliesslich Abrechnungszwecken, die tatsaechliche PLZ des Patienten muss gespeichert werden.

**Wichtiger Hinweis:**

Die Postleitzahl, die im Rahmen des Wohnortprinzips in den ADT-Abrechnungsdatensatz uebernommen wird, ist eine reine Verwaltungsinformation.

D.h. der Arzt muss NICHT in seiner medizinischen Patientendokumentation die PLZ des Patienten (z.B. fuer den Briefversand oder noch schlimmer: fuer den Notfall) komplett durch eine Pseudonummer ersetzen. Die Anwendungssoftware muss sicherstellen, dass in diesen Faellen in der Patientendokumentation (= Karteikarte) die reale PLZ des Patienten gespeichert ist. Diese reale Postleitzahl ist auch bei dem Ausdruck des Personalienfeldes von vertragsaerztlichen Formularen zu verwenden.

---

## 2.2.6 Geschlecht des Patienten

### P2-470 - Geschlecht (FK 3110)

**Typ:** PFLICHTFUNKTION ADT

Die Software muss die Transformationsvorschriften fuer das Geschlecht gemaess den Anforderungen der "Technischen Anlage zur Anlage 4a" einhalten und dem Anwender die manuelle Erfassung einer Geschlechtsangabe ermoeglichen.

**Begruendung:**

Die vertragliche Grundlage dieser Anforderung sind die Anlage 4a BMV-Ae sowie die "Technische Anlage zu Anlage 4a" (BMV-Ae).

**Akzeptanzkriterium:**

1. Die Software belegt das Eingabefeld des Geschlechts (Feld 3110) nicht mit einem Defaultwert vor.
   a) Eine automatisierte Bestimmung des Geschlechts anhand des Vornamens oder weiterer identifizierender Merkmale kann von der Software als Unterstuetzung des Anwenders durchgefuehrt werden. Der Anwender muss jederzeit die Moeglichkeit haben den vorgeschlagenen Wert ueberschreiben zu koennen.
2. Falls eine eGK eingelesen wird, muss die Software den Inhalt des Elements `../Geschlecht` entsprechend den Vorgaben der "Technischen Anlage zur Anlage 4a" [KBV_ITA_VGEX_Mapping_KVK] in das Feld 3110 uebernehmen. (vgl. auch P2-105)
3. Falls eine KVK eingelesen wird muss die Software vom Anwender die Eingabe einer Geschlechtsangabe fordern.
4. Im Rahmen der manuellen Erfassung bzw. beim Ersatzverfahren, muss die Software vom Anwender die Eingabe einer Geschlechtsangabe fordern.
5. Die Software muss das vom Anwender erfasste Geschlecht im Feld 3110 uebertragen.

---

## 2.2.7 Fiktive Versicherte

### K2-480 - Unterbindung der Uebernahme von Daten fiktiver Versicherter

**Typ:** OPTIONALE FUNKTION ADT

Damit Anwender die Moeglichkeiten haben, neue Funktionen in der Software oder allgemein das Verhalten der Software zu testen, muss der Anwender die Moeglichkeiten haben, fiktive Versicherte zu hinterlegen. Fuer fiktive Versicherte ist eine Abrechnung von Leistungen zu unterbinden.

**Begruendung:**

Krankenkassen, welche bspw. den Praxen fuer Anbindungstests von TI-Fachanwendungen im Wirkbetrieb Daten von fiktiven Versicherten zur Verfuegung stellen, erwarten, dass fuer diese fiktiven Versicherten keine realen vertragsaerztliche Leistungen abgerechnet werden. Um sicherzustellen, dass eine versehentliche Abrechnung von Leistungen fuer fiktive Versicherte nicht erfolgt, soll die Software die Uebernahme von Abrechnungsdaten fiktiver Versicherter in die ADT-Abrechnungsdatensaetze unterbinden.

**Akzeptanzkriterium:**

1. Die Software muss dem Anwender bei der manuellen Erfassung von Patientenstammdaten die Moeglichkeit bieten, diese Daten als fiktiv zu kennzeichnen.
   a) Mit den als fiktiv gekennzeichneten Versicherten koennen alle Funktionen der Software genutzt werden.
2. Die Software muss die Uebernahme von erfassten Leistungen fuer fiktive Versicherte in die ADT-Abrechnungsdatensaetze im Rahmen der KV-Abrechnung automatisch unterbinden, ohne eine Bestaetigung des Anwenders einzuholen.

---

## 2.3 Abrechnungsfunktionen bei den Satzarten 010x

> Hinweis: Die folgenden Anforderungen KP2-500 und KP2-514 gehoeren formal zu Kapitel 2.3, werden hier aber dokumentiert, da sie im direkten Kontext der Patientenstammdatenverarbeitung stehen.

### KP2-500 - Angabe der abzurechnenden "Satzarten 010x" bzw. der "Scheinuntergruppe" beim erstmaligen Kontakt im Quartal

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

Beim **erstmaligen Einlesen der Versichertenkarte** eines Versicherten im Quartal muss das System die **Eingabe der abzurechnenden "Satzart 010x" bzw. der "Scheinuntergruppe"** verlangen. Dies kann entweder im direkten Zusammenhang mit dem Einlesevorgang oder beim ersten Erfassen von abrechnungsrelevanten Daten erfolgen.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.

---

### KP2-514 - Ambulante Behandlung (Satzart 0101 mit Scheinuntergruppe 00) bei SKT-Versicherten ohne Versichertenkarte

**Typ:** KONDITIONALE PFLICHTFUNKTION ADT

**SKT-Versicherte ohne Versichertenkarte:**

Die Abrechnungssoftware muss sicherstellen,

dass zu einem SKT-Versicherten ohne Versichertenkarte (VKNR-Seriennummer 3.-5.Stelle >= 800 oder KTAB != 00) die Satzart 0101 mit der Scheinuntergruppe 00 (Satzart "Ambulante Behandlung") mehrfach im selben Quartal angelegt werden kann, wobei dann gilt, dass bei jeder Anlage einer entsprechenden Satzart der Zeitraum der Gueltigkeit des Abrechnungsscheines in FK 4125 (Gueltigkeitszeitraum von...bis...) erfasst und uebertragen werden muss, sofern die Information ueber die Gueltigkeit vorhanden ist.

**Begruendung:**

SKT-Versicherte ohne Versichertenkarte (z.B. Sozialamt) erhalten unter Umstaenden in einem Quartal mehrere papierne Behandlungsausweise mit Angabe einer eingeschraenkten Gueltigkeit. Fuer jeden Behandlungsausweis muss jeweils ein separater Abrechnungsdatensatz angelegt werden koennen.

**Bedingung:**

Ausgenommen von der Umsetzung dieser Anforderung sind Softwaresysteme ohne APK.
