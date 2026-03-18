# 4 Abrechnung von Schwangerschaftsabbruchen (SADT)

> Quelle: KBV_ITA_VGEX_Anforderungskatalog_KVDT, Version 6.06, 9. Marz 2026, Seiten 135-137

Fur die Abrechnung von Schwangerschaftsabbruchen nach dem Schwangeren- und Familienhilfeanderungsgesetz (SFHAndG) gibt es keine bundeseinheitliche Regelung. Die Abrechnungsregelung von Schwangerschaftsabbruchen im Rahmen des definierten SADT-Datenpaketes ist NRW-spezifisch und ist fur die Kassenarztlichen Vereinigungen Nordrhein und Westfalen-Lippe identisch.

## Ausgangslage:

1. Die Patientin legt der Arztin/dem Arzt eine Kostenubernahmebescheinigung von einer gesetzlichen Krankenkasse vor; dabei kann es sich um eine Krankenkasse handeln, bei der sie nicht GKV-krankenversichert ist.
2. Die Kostenubernahmebescheinigung enthalt die Personalien der Patientin und eine sogenannte Fall-Kennziffer.
3. Die Personalien der Patientin durfen aus datenschutzrechtlichen Grunden nicht fur Abrechnungszwecke an die KV ubermittelt werden. Stattdessen wird die o. g. -- **maximal 27-stellige** -- Fall-Kennziffer ubertragen.
4. Leistungen fur Patientinnen mit Wohnsitz ausserhalb von NRW sind direkt mit der Krankenkasse abzurechnen.
5. Wird fur die Patientin im Rahmen dieser Behandlung eine Uberweisung ausgestellt (i.d.R. an den Anasthesisten), darf im Personalienfeld des Vordrucks nur die Fall-Kennziffer wiedergegeben werden.

---

### K4-10 -- Abzurechnende Satzarten

**Typ:** OPTIONALE FUNKTION SADT

Die Abrechnung von Leistungen zum Schwangerschaftsabbruch erfolgt ausschliesslich mit folgenden Satzarten:

1. Mit Satzart "sad1" werden abgerechnet: die ambulant erbrachten Leistungen des Operateurs
2. Mit Satzart "sad2" werden abgerechnet:
   a) Leistungen des Anasthesisten, welcher auf Uberweisung des Operateurs tatig wird.
   b) Leistungen des Gynakologen, an den der Operateur zur Kontrolluntersuchung uberwiesen hat.
3. Mit Satzart "sad3" werden abgerechnet: belegarztliche Leistungen.

---

### K4-20 -- Plausibilitatsprufungen der Kennziffer-SA im PVS

**Typ:** OPTIONALE FUNKTION SADT

1. Bei unplausiblen Eingaben mussen **Warnhinweise** ausgegeben werden. Die Plausibilitatsprufung erfolgt auf Basis nachfolgender Tabelle:

#### Tabelle 15 -- Plausibilitatsprufungen der Kennziffer-SA im PVS

| Stelle(n) der Kennziffer | Bedeutung | Prufungen |
|---|---|---|
| 1 | Kennzeichnung fur die Herkunft der Patientin: 1 = NRW, 0 = andere Bundeslander | Falls Inhalt der 1. Stelle = 0, ist der Fall direkt mit der zustandigen Krankenkasse abzurechnen |
| 2-7 | Datum der Antragstellung bei der Krankenkasse | Prufung auf Datumsformat, gultiges Format ist TTMMJJ. Datum der Antragstellung <= 1. Leistungstag |
| 8 | Laufende Nr. des Tages | Wertebereich: 1, 2..., 9 |
| 9-15 | IK der Krankenkasse | Prufung uber KT-Stammdatei |
| 16-20 | PLZ der ausstellenden Krankenkasse | Prufung uber PLZ-Stammdatei |
| 21-27 | Alphanumerische interne Kennzeichnung der Krankenkasse | 1 -- 7-stellig |

**Aufbau der 27-stelligen Kennziffer-SA:**

```
Stelle 1              = Kennzeichnung fur die Herkunft der Patientin
Stellen 2-7           = Datum der Antragstellung (TTMMJJ)
Stelle 8              = Lfd Nr. des Tages
Stellen 9-15          = IK der Krankenkasse
Stellen 16-20         = PLZ der Kasse
Stellen 21-27         = alphanum. interne Kennzeichnung der Krankenkasse
```

6. Es muss allerdings moglich sein, auch eine unplausible Kennziffer zu speichern, wenn der Anwender die Eingabe bestatigt.

---

### K4-30 -- Ableitung der VKNR aus dem IK

**Typ:** OPTIONALE FUNKTION SADT

Die zu speichernde VKNR wird abgeleitet aus dem in der Kennziffer-SA (9-15te Stelle) enthaltenen IK. Hierbei gelten die zutreffenden Vorgaben nach Kapitel 2.2.2.1.

---

### K4-40 -- Bedruckung

**Typ:** OPTIONALE FUNKTION SADT

Die Bedruckung des Personalienfeldes des vertragsarztlichen Vordrucks 6 (Uberweisungsschein) erfolgt pseudonymisiert durch Angabe der Kennziffer-SA. Die Kennziffer-SA muss in die Druckzeile 2 (Feld: Nachname) des Personalienfeldes gedruckt werden.

**Beispiel -- Bedruckung des Personalienfeldes:**

```
Krankenkasse bzw. Kostentrager
 BKK fur Testfalle
Name, Vorname des Versicherten
 11010141952870253840123456um

Kostentragerkennung    Versicherten-Nr.    Status
 109528702
Betriebsstatten-Nr.   Arzt-Nr.            Datum
 123456789              123456499           10.10.14
```

**Hinweis zur Blankoformularbedruckung:**

Im Rahmen der Blankoformularbedruckung entfallt der Barcode.

---

### K4-50 -- Speicherung der Personalien der Patientin

**Typ:** OPTIONALE FUNKTION SADT

Fur die eigene Behandlungsdokumentation mussen die Personalien der Patientin gespeichert werden, falls die Dokumentation ausschliesslich elektronisch im PVS erfolgt.

---

### K4-60 -- Automatische und manuelle Zuordnung des Kostentragers

**Typ:** OPTIONALE FUNKTION SADT

Es gelten die zutreffenden Vorgaben nach Kapitel 2.2.2.1 mit folgender Fallunterscheidung:

1. Bei plausiblen Kennziffern wird die zu speichernde VKNR abgeleitet aus dem in der Kennziffer-SA (9-15te Stelle) enthaltenen IK.

7. Bei unplausibler Kennziffer lasst sich der Kostentrager nicht automatisch ableiten. Der Anwender muss daher die Moglichkeit haben, den Kostentrager manuell zuzuordnen.

   **Hinweis:**

   Kasse ist dann manuell aus dem Berechtigungsschein zu ubernehmen.
