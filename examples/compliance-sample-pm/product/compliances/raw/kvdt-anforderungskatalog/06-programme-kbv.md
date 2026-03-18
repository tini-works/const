# 6 Programme der KBV

> Quelle: KBV_ITA_VGEX_Anforderungskatalog_KVDT, Version 6.06, 9. Maerz 2026, Seiten 144-145

## 6.1 KVDT-Pruefmodul, KBV-Kryptomodul

Die KBV liefert allen Entwicklern von Abrechnungssoftware ein KVDT-Pruefmodul und ggf. ein Update fuer das KBV-Kryptomodul fuer die Abrechnung des Folgequartals jeweils zur Mitte des 2. Monats im Quartal:

1. XPM-KVDT-Pruefmodul
2. XPM-KVDT-Pruefmodul in der Stand-Alone-Version mit integriertem Kryptomodul (Pruefassistent)

---

### P5-10 - Einsatzpflicht des KVDT-Pruefmoduls und KBV-Kryptomoduls

**Typ:** PFLICHTFUNKTION ADT

Durch geeignete organisatorische Massnahmen muss sichergestellt werden, dass die Anwender rechtzeitig zur Abrechnung jeweils das aktuell gueltige KVDT-Pruefmodul und KBV-Kryptomodul (XKM) im Rahmen ihrer Software einsetzen koennen.

**Begruendung:**

Zur Sicherstellung der Datenqualitaet und Gewaehrleistung der Abrechnungsverarbeitung muss das KVDT-Pruefmodul zur Pruefung der Abrechnungsdateien zum Einsatz kommen.

Ebenfalls muss zur Gewaehrleistung des Datenschutzes und aufgrund der verschiedenen Wege zur Einreichung der Abrechnungsdaten jede Abrechnungsdatei mit den definierten Abrechnungsschluesseln verschluesselt werden.

**Akzeptanzkriterium:**

1. Die Software stellt sicher, dass der Anwender rechtzeitig zur Abrechnung die aktuell gueltige Version des KBV-Kryptomodul (XKM) einsetzen kann.
2. Die Software stellt sicher, dass
   a) fuer die Abrechnung von ADT-, KADT- und/oder SADT-Datenpaket stets der gueltige Abrechnungsschluessel "Oeffentlich_KV_VXX.pub" (Arbeitsmodus "Abrechnungs_Verschluesselung") verwendet wird.
   b) fuer die Abrechnung des HDRG-Datenpakets stets der gueltige Abrechnungsschluessel "Oeffentlich_HDRG_VXX.pub" (Arbeitsmodus "HDRG_Verschluesselung") verwendet wird.
3. Die Software stellt sicher, dass der Anwender rechtzeitig zur Abrechnung die aktuell gueltige Version des KVDT-Pruefmodul (KVDT-XPM) einsetzen kann.
4. Alternativ zu den Akzeptanzkriterium 1. und 3. kann die Software dem Anwender rechtzeitig zur Abrechnung die aktuell gueltige Version des KBV-Pruefassistenten zur Verfuegung stellen.

**Hinweis:**

Sofern die Software dem Anwender den KBV-Pruefassistenten zur Verfuegung stellt, stellt der Pruefassistent die korrekte Verwendung der Schluessel sicher.

---

### P5-20 - Kommunikationssatz

**Typ:** PFLICHTFUNKTION ADT

Der vom KVDT-Pruefmodul erzeugte **Kommunikationssatz** muss der KVDT-Datei (fuer Abrechnungen von ADT-, KADT- und SADT-Datenpaketen) vor der Verschluesselung angehaengt werden.

**Hinweis:**

Bei der Abrechnung HDRG-Datenpaketen wird an die Abrechnungsdatei kein Kommunikationssatz angehaengt.

**Anmerkung:**

Nach der Pruefung der KVDT-Datei erzeugt das **KVDT-Pruefmodul (XPM)** den sogenannten **Kommunikationssatz**. Der Kommunikationssatz enthaelt Informationen zum vorangegangenen Prueflauf. Name und Ort dieser Kommunikationsdatei koennen ueber den Schalter "Kommunikationssatz" in der Konfigurationsdatei des KVDT-Pruefmoduls festgelegt werden, siehe Kapitel "Kommunikationssatz", Dokument KVDT-spezifische Ergaenzung zum Handbuch KBV-Pruefmodul XPM [KBV_ITA_AHEX_Handbuch_Pruefmodul_KVDT].

Im Rahmen der Verschluesselung kann auch das **Kryptomodul (XKM)** den Kommunikationssatz der KVDT-Datei "anhaengen". Dazu muss die Komusatz.txt-Datei (bei Standardkonfiguration) ueber den optionalen Parameter -i oder den Schalter Pruefinfo dem Kryptomodul uebergeben werden, siehe [KBV_ITA_AHEX_Handbuch_Kryptomodul].

Beim Einsatz des KBV-Pruefassistenten wird die Komusatz.txt-Datei bei unveraenderter Standardkonfiguration automatisiert angehangen.

---

### P5-30 - Zugang zur unverschluesselten Abrechnungsdatei

**Typ:** PFLICHTFUNKTION ADT

Wird die von der KBV zur Verfuegung gestellte Stand-Alone-Version des XPM eingesetzt, muss sichergestellt sein, dass der Anwender auf Dateisystemebene Zugang zur ungeprueften und unverschluesselten Abrechnungsdatei hat, die vom PVS nach dem Abrechnungslauf erzeugt wurde.

**Anmerkung:**

Die vom PVS erzeugte Abrechnungsdatei wird als Input fuer das Stand-Alone-Version XPM benoetigt.
