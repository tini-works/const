## KVDT Field Directory (Feldverzeichnis)

| Field | Value |
|-------|-------|
| **Source** | KVDT-DSB v6.02 |
| **Section** | 7 |
| **Scope** | Complete directory of all fields defined in the KVDT data transfer format |

### Overview

This field directory describes all fields defined in KVDT. Each field entry contains:
- Field identifier (FK)
- Field name (with substitute value if applicable)
- Content length
- Field type (a = alphanumeric, n = numeric, d = date)
- Record type usage (Vorkommen in Satzart)
- Supplementary description

### Fields

| FK | Field Name | Length | Type | Used In | Description |
|----|-----------|--------|------|---------|-------------|
| 0102 | Softwareverantwortlicher (SV) | ≤ 60 | a | adt0, kad0, sad0 | The software responsible party (SV) is the legal entity or natural person who is accountable to KBV in the legal sense for compliance with the approval criteria. |
| 0103 | Software | ≤ 60 | a | adt0, kad0, sad0, hdrg0 | Name of the approved software or software variant. When using a software variant, its name must be provided. |
| 0104 | Grouper-Software | ≤ 60 | a | hdrg0 | Name of the deployed Grouper software. |
| 0105 | KBV-Prüfnummer | 15–17 | a | adt0, kad0, sad0, hdrg0 | |
| 0111 | Email-Adresse des SV | ≤ 60 | a | adt0, kad0, sad0 | |
| 0121 | Straße des SV | ≤ 60 | a | adt0, kad0, sad0 | |
| 0122 | PLZ des SV | ≤ 7 | a | adt0, kad0, sad0 | |
| 0123 | Ort des SV | ≤ 60 | a | adt0, kad0, sad0 | |
| 0124 | Telefonnummer des SV | ≤ 60 | a | adt0, kad0, sad0 | |
| 0125 | Telefaxnummer des SV | ≤ 60 | a | adt0, kad0, sad0 | |
| 0126 | Regionaler Systembetreuer (SB) | ≤ 60 | a | adt0, kad0, sad0 | The regional system operator (SB) is the legal entity or natural person who performs services on behalf of the software responsible party regarding the approved software. Manual entry by the user is not permitted. |
| 0127 | Straße des SB | ≤ 60 | a | adt0, kad0, sad0 | |
| 0128 | PLZ des SB | ≤ 7 | a | adt0, kad0, sad0 | |
| 0129 | Ort des SB | ≤ 60 | a | adt0, kad0, sad0 | |
| 0130 | Telefonnummer des SB | ≤ 60 | a | adt0, kad0, sad0 | |
| 0131 | Telefaxnummer des SB | ≤ 60 | a | adt0, kad0, sad0 | |
| 0132 | Release-Stand der Software | ≤ 60 | a | adt0, kad0, sad0, hdrg0 | This field is primarily used for transmitting the release version of the software. Additionally, it can be used within the scope of KV-specific contracts for transmitting other information. The field must be able to contain the following information: Characters 1-23: Version number; Character 24: fixed separator "\|"; Characters 25-60: other information. (Note: "\|" = vertical bar, called "Pipe" in programming jargon. On Windows PCs it is produced via the key combination "Alt Gr" and "<".) |
| 0201 | Betriebs- (BSNR) oder Nebenbetriebsstättennummer (NBSNR) | 9 | n | besa, rvsa | |
| 0203 | (N)BSNR-/Krankenhaus-Bezeichnung | ≤ 60 | a | besa | |
| 0205 | Straße der (N)BSNR-/Krankenhaus-Adresse | ≤ 60 | a | besa | |
| 0208 | Telefonnummer | ≤ 60 | a | besa | |
| 0209 | Telefaxnummer | ≤ 60 | a | besa | |
| 0211 | Arztname oder Erläuterung | ≤ 60 | a | besa | |
| 0212 | Lebenslange Arztnummer (LANR) (Ersatzwert: 999999900) | 9 | n | besa | |
| 0213 | Krankenhaus-IK (im Rahmen der ASV-Abrechnung) | 9 | n | besa | |
| 0214 | KV-Bereich | 2 | n | besa | |
| 0215 | PLZ der (N)BSNR-/Krankenhaus-Adresse | ≤ 7 | a | besa | |
| 0216 | Ort der (N)BSNR-/Krankenhaus-Adresse | ≤ 60 | a | besa | |
| 0218 | E-Mail der Betriebsstätte/Praxis/Krankenhaus | ≤ 60 | a | besa | |
| 0219 | Titel des Arztes | ≤ 100 | a | besa | |
| 0220 | Arztvorname | ≤ 45 | a | besa | |
| 0221 | Namenszusatz des Arztes | ≤ 20 | a | besa | |
| 0222 | ASV-Teamnummer | 9 | n | besa | |
| 0223 | Pseudo-LANR für Krankenhausärzte im Rahmen der ASV-Abrechnung | 9 | n | besa | |
| 0224 | Produkttypversion des Konnektors | ≤ 20 | a | besa | The product type version of the connector can be retrieved via the external interface of the Telematikinfrastruktur base application directory service. In the response document of this service, the product type version of the connector is contained in the product information, which is described using the XML schema "ProductInformation.xsd". Further information can be found in the current "Spezifikation Konnektor" and the current document "Übergreifende Spezifikation Operations und Maintenance" from gematik. |
| 0225 | TI-Fachanwendung / TI-Komponente | 1-2 | n | besa | This field is used to identify the TI specialist application or the TI component to which the information in FK 0226 refers. |
| 0226 | Systemunterstützung / Ausstattung der Praxis | 1 | n | besa | This field serves as proof that a primary system is available in a practice site which supports the functional features of the TI specialist application specified in FK 0225 or has supported the TI component specified in FK 0225. This field must be automatically pre-populated. Manual entry by the user must be made possible. |
| 0227 | Ablaufdatum des Konnektorzertifikats | 8 | d | besa | |
| 0228 | Produktname des Konnektors | ≤ 60 | a | besa | |
| 0300 | Abrechnung von (zertifikatspflichtigen) Laborleistungen | 1 | n | rvsa | |
| 0301 | pnSD/uu-Analysen | 1 | n | rvsa | |
| 0302 | Gerätetyp | ≤ 60 | a | rvsa | |
| 0303 | Hersteller | ≤ 60 | a | rvsa | |
| 0304 | Analyt-ID | 3 | n | rvsa | |
| 0305 | RV-Zertifikat | 1 | n | rvsa | |
| 3000 | Patientennummer | ≤ 20 | a | 0101, 0102, 0103, 0104, 0109, hdrg1 | This field is used to transmit the practice-internal patient number. This information can be used within the scope of the ADT validation module error protocol interface; cf. ADT-Prüfmodul-Handbuch. |
| 3003 | Schein-ID | ≤ 60 | a | 0101, 0102, 0103, 0104, 0109 | |
| 3005 | Kennziffer SA | ≤ 27 | a | sad1, sad2, sad3 | |
| 3006 | CDM Version | 5-11 | a | 0101, 0102, 0103, 0104, 0109, hdrg1 | eGK insured person master data schema version (CDM = Common Data Model). On the eGK, the schema version of the insured person master data stored on the card is deposited in the file EF.StatusVD (Element /Version). The actual insured person data is stored on the eGK in several files, for example in file EF.VD. These files also contain the CDM version specification in the "first" line each. Example: `<tns:UC_AllgemeineVersicherungsdatenXML xmlns:tns="http://ws.gematik.de/fa/vsds/UC_AllgemeineVersicherungsdatenXML/v5.2" CDM_VERSION="n.n.n">`. According to gematik, the schema versions of these files are always consistent with each other! The field must be transmitted whenever an eGK has been read. This also applies when data is transferred from a mobile card terminal to a PVS. Manual entry by the user is not required! |
| 3010 | Datum und Uhrzeit der Onlineprüfung und -aktualisierung (Timestamp) | 14 | n | 0101, 0102, 0103, 0104, 0109, hdrg1 | On the eGK, the "Prüfungsnachweis" (proof of verification) is stored in the file EF.PN. The proof of verification can contain the following information: - Timestamp (TS); - Result of online verification and update (E); - Error code (return value) (EC); - Check digit of the specialist service (PZ). These contents must be transmitted unchanged in fields FK 3010-3013 accordingly. Since UTC must be used as the timezone for the Timestamp in Element /PN/TS, this rule also applies to FK 3010. Further information can be found in the current "Implementierungsleitfaden Primärsysteme -- Telematikinfrastruktur (TI)" and the current document "Systemspezifisches Konzept Versichertenstammdatenmanagement (VSDM)" from gematik. Content of Element /PN/TS |
| 3011 | Ergebnis der Onlineprüfung und -aktualisierung | 1 | n | 0101, 0102, 0103, 0104, 0109, hdrg1 | Content of Element /PN/E |
| 3012 | Error-Code | ≤ 5 | n | 0101, 0102, 0103, 0104, 0109, hdrg1 | Content of Element /PN/EC |
| 3013 | Prüfziffer des Fachdienstes | ≤ 128 | a | 0101, 0102, 0103, 0104, 0109, hdrg1 | Content of Element /PN/PZ |
| 3100 | Namenszusatz | ≤ 20 | a | 0101, 0102, 0103, 0104, 0109, hdrg1 | Coding per DEUV, Annex 07 (Table of valid name suffixes) at http://www.gkv-datenaustausch.de/arbeitgeber/deuev/gemeinsame_rundschreiben/gemeinsame_rundschreiben.jsp |
| 3101 | Name | ≤ 45 | a | 0101, 0102, 0103, 0104, 0109, hdrg1 | |
| 3102 | Vorname | ≤ 45 | a | 0101, 0102, 0103, 0104, 0109, hdrg1 | |
| 3103 | Geburtsdatum (Ersatzwert: 00000000) | 8 | n | 0101, 0102, 0103, 0104, 0109, hdrg1 | Transformation recommendation for recording a date of birth in the substitute procedure without physician-patient contact: The date of birth printed in print line 3, position 23-30 in the format "TT.MM.JJ" must be transformed into the form "JJJJMMTT". If JJ <= 3rd-4th digit of the current four-digit year and date entry < system date, then JJJJ = concatenation ('20',JJ), otherwise JJJJ = concatenation ('19',JJ). Dates of birth in the form JJJJMM00, JJJJ0000, and 00000000 are valid date formats. This is due to the issuance of insurance cards with incomplete dates of birth, e.g. without specification of birth month and/or birth day. |
| 3104 | Titel | ≤ 20 | a | 0101, 0102, 0103, 0104, 0109, hdrg1 | |
| 3105 | Versichertennummer | 6-12 | n | 0101, 0102, 0103, 0104, hdrg1 | This field is used to transmit the KVK insured person number. |
| 3107 | Straße | ≤ 46 | a | 0101, 0102, 0103, 0104, 0109, hdrg1 | On the eGK, different structures are defined for recording a street address and/or a PO box address. If both address types are present on an eGK, both the street address (FK 3107, 3109, 3112, 3113, 3114, 3115) and the PO box address (FK 3121-3124) may be present in a record 010x. The street address has priority when printing the personal data field; cf. "Mappingtabelle_KVK" [KBV_ITA_VGEX_Mapping_KVK]. Per the documentation for eGK schema VSD 5.2.0, the following applies to the Element ///Strasse: Specifies the name of the street. If the house number cannot be stored separately, it is permissible to include the house number in the street field. Annex 9.4 (...). If the street name and house number are stored in a single Element ///Strasse on an eGK, they must be transferred unchanged into the field "Straße" (FK 3107). |
| 3108 | Versichertenart | 1 | n | 0101, 0102, 0103, 0104, 0109, hdrg1 | |
| 3109 | Hausnummer | ≤ 9 | a | 0101, 0102, 0103, 0104, 0109, hdrg1 | |
| 3110 | Geschlecht | 1 | a | 0101, 0102, 0103, 0104, 0109, hdrg1 | |
| 3111 | Aufnahmegewicht | ≤ 5 | n | hdrg1 | |
| 3112 | PLZ | ≤ 10 | a | 0101, 0102, 0103, 0104, 0109, hdrg1 | |
| 3113 | Ort | ≤ 40 | a | 0101, 0102, 0103, 0104, 0109, hdrg1 | |
| 3114 | Wohnsitzlaendercode | ≤ 3 | a | 0101, 0102, 0103, 0104, 0109, hdrg1 | Coding per DEUV, Annex 08 (Nationality and country codes for foreign addresses) at http://www.gkv-datenaustausch.de/arbeitgeber/deuev/gemeinsame_rundschreiben/gemeinsame_rundschreiben.jsp |
| 3115 | Anschriftenzusatz | ≤ 40 | a | 0101, 0102, 0103, 0104, 0109, hdrg1 | |
| 3116 | WOP | 2 | n | 0101, 0102, 0103, 0104, hdrg1 | |
| 3119 | Versicherten_ID | 10 | a | 0101, 0102, 0103, 0104, 0109, hdrg1 | The 10-digit invariable part (Versicherten-ID) of the eGK health insurance number. The check digit of the Versicherten-ID is calculated according to the schema in Annex 1 of the guideline "Organisatorische und technische Richtlinien zur Nutzung der Versicherungsnummer nach §147 SGB VI bei Einführung einer neuen Krankenversichertennummer nach § 290 SGB V, Version 1.5". The check digit is determined using a Modulo-10 procedure. The letter is replaced by two digits: A with 0 and 1, B with 0 and 2, ..., and Z with 2 and 6. The digits are multiplied alternately from left to right by 1 and 2. A cross sum of the individual products is computed, followed by a summation of the cross sums. The check digit is the remainder of the integer division of this sum by 10. In the substitute procedure or when scanning printed patient master data (e.g. referral slip in lab), a verification may be performed to avoid typing or OCR reading errors. |
| 3120 | Vorsatzwort | ≤ 20 | a | 0101, 0102, 0103, 0104, 0109, hdrg1 | Coding per DEUV, Annex 06 (Table of valid prefix words) at http://www.gkv-datenaustausch.de/arbeitgeber/deuev/gemeinsame_rundschreiben/gemeinsame_rundschreiben.jsp |
| 3121 | PostfachPLZ | ≤ 10 | a | 0101, 0102, 0103, 0104, 0109, hdrg1 | |
| 3122 | PostfachOrt | ≤ 40 | a | 0101, 0102, 0103, 0104, 0109, hdrg1 | |
| 3123 | Postfach | ≤ 8 | a | 0101, 0102, 0103, 0104, 0109, hdrg1 | This field is used to transmit the PO box **number** without a descriptive keyword. Example: Transmission of PO box number "12345". Wrong: 0173123Postf 12. Wrong: 0173123Postfach. Correct: 014312312345 |
| 3124 | PostfachWohnsitzlaendercode | ≤ 3 | a | 0101, 0102, 0103, 0104, 0109, hdrg1 | Coding per DEUV, Annex 08 (Nationality and country codes for foreign addresses) at http://www.gkv-datenaustausch.de/arbeitgeber/deuev/gemeinsame_rundschreiben/gemeinsame_rundschreiben.jsp |
| 3673 | Dauerdiagnose (ICD-Code) | 3, 5, 6 | a | 0101, 0102, 0103, 0104 | |
| 3674 | Diagnosensicherheit Dauerdiagnose | 1 | a | 0101, 0102, 0103, 0104 | |
| 3675 | Seitenlokalisation Dauerdiagnose | 1 | a | 0101, 0102, 0103, 0104 | |
| 3676 | Diagnosenerläuterung Dauerdiagnose | ≤ 60 | a | 0101, 0102, 0103, 0104 | |
| 3677 | Diagnosenausnahmetatbestand Dauerdiagnosen | ≤ 60 | a | 0101, 0102, 0103, 0104 | |
| 4101 | Quartal | 5 | n | 0101, 0102, 0103, 0104, sad1, sad2, sad3 | |
| 4102 | Ausstellungsdatum | 8 | d | 0101, 0102, 0103, 0109 | |
| 4103 | Vermittlungs-/Kontaktart | 1 | n | 0101, 0102, 0103, 0104 | |
| 4104 | Abrechnungs-VKNR | 5 | n | 0101, 0102, 0103, 0104, 0109, sad1, sad2, sad3, hdrg1 | |
| 4105 | Ergänzende Informationen zur Vermittlungs-/Kontaktart | ≤ 60 | a | 0101, 0102, 0103, 0104 | |
| 4106 | Kostenträger-Abrechnungsbereich (KTAB) | 2 | n | 0101, 0102, 0103, 0104, hdrg1 | |
| 4108 | Zulassungsnummer (mobiles Lesegerät) | ≤ 40 | a | 0101, 0102, 0103, 0104, 0109 | |
| 4109 | letzter Einlesetag der Versichertenkarte im Quartal | 8 | d | 0101, 0102, 0103, 0104, 0109, hdrg1 | |
| 4110 | VersicherungsschutzEnde | 8 | d | 0101, 0102, 0103, 0104, 0109, hdrg1 | Transformation of the KVK field "Bis-Datum der Gültigkeit" in the format "MMJJ" into the form "JJJJMMTT" is necessary, where TT = last possible day of the month and JJJJ = concatenation ('20',JJ); cf. Mappingtabelle_KVK [KBV_ITA_VGEX_Mapping_KVK] |
| 4111 | Kostentraegerkennung | 9 | n | 0101, 0102, 0103, 0104, 0109, sad1, sad2, sad3, hdrg1 | |
| 4112 | eEB vorhanden | 1 | n | 0101, 0102, 0103, 0104, 0109, hdrg1 | |
| 4114 | Vermittlungscode | 14 | a | 0101, 0102, 0103, 0104 | 14-digit referral code, e.g. XN6P-F4HP-Z5KX |
| 4115 | Tag der Terminvermittlung | 8 | d | 0101, 0102, 0103, 0104 | |
| 4121 | Gebührenordnung | 1 | n | 0101, 0102, 0103, 0104, | |
| 4122 | Abrechnungsgebiet | 2 | n | 0101, 0102, 0103, 0104, | |
| 4123 | Personenkreis / Untersuchungskategorie | 2 | n | 0101, 0102, 0103, 0104, | |
| 4124 | SKT-Zusatzangaben | 5 ≤ 60 | a | 0101, 0102, 0103, 0104, hdrg1 | |
| 4125 | Gültigkeitszeitraum von ... bis ... | 16 | n | 0101, 0102, 0104, hdrg1 | |
| 4126 | SKT-Bemerkungen | ≤ 60 | a | 0101, 0102, 0103, 0104, hdrg1 | |
| 4131 | BesonderePersonengruppe | 2 | a | 0101, 0102, 0103, 0104, 0109, hdrg1 | |
| 4132 | DMP-Kennzeichnung | 2 | a | 0101, 0102, 0103, 0104, 0109, hdrg1 | |
| 4133 | VersicherungsschutzBeginn | 8 | d | 0101, 0102, 0103, 0104, 0109, hdrg1 | |
| 4134 | Kostentraegername | ≤ 45 | a | 0101, 0102, 0103, 0104, 0109 | KVK: Objekttag 80, "KrankenKassenName". eGK: 1st priority: Content of Element UC_AllgemeineVersicherungsdatenXML/Versicherter/Versicherungsschutz/Kostentraeger/AbrechnenderKostentraeger/Name. 2nd priority: Content of Element UC_AllgemeineVersicherungsdatenXML/Versicherter/Versicherungsschutz/Kostentraeger/Name. This field must be transmitted when an insurance card has been read. This also applies when data is transferred from a mobile card terminal to a PVS. Manual entry by the user in the substitute procedure is not required, as it is factually not possible. The "Kassenname zur Bedruckung" derived from the KT master file must also not be transmitted. |
| 4202 | Unfall, Unfallfolgen | 1 | n | 0101, 0102, 0103, 0104 | |
| 4204 | eingeschränkter Leistungsanspruch gemäß §16 Abs. 3a SGB V | 1 | n | 0101, 0102, 0103 | This field is used to identify cases with "restricted benefit entitlement per § 16 Absatz 3a SGB V". Form 85 (Nachweis der Anspruchsberechtigung bei Ruhen des Anspruchs gemäß § 16 Absatz 3a SGB V) is issued by the health insurers and serves the contract physician as information about the treatment entitlement. Form 85 replaces the insurance card in these cases, and the "insured person" must be recorded manually in the substitute procedure. Form 6 (Überweisungsschein / referral slip) was extended with a corresponding check box field (restricted benefit entitlement per § 16 Absatz 3a SGB V). The referring contract physician must check this field to inform the physician acting on the referral about the restricted benefit entitlement. The billing physician must transmit this information in their billing by providing the value of field 4204 accordingly. |
| 4205 | Auftrag | ≤ 60 | a | 0102, 0103, sad2 | |
| 4206 | Mutm. Tag der Entbindung | 8 | d | 0101, 0102, 0103 | |
| 4207 | Diagnose/Verdachtsdiagnose | ≤ 60 | a | 0102, 0103 | |
| 4208 | Befund/Medikation | ≤ 60 | a | 0102, 0103 | |
| 4209 | Zusätzliche Angaben zu Untersuchungen | ≤ 60 | a | 0102 | |
| 4214 | Behandlungstag bei IVD-Leistungen | 8 | d | 0102 | |
| 4217 | (N)BSNR des Erstveranlassers | 9 | n | 0102 | |
| 4218 | (N)BSNR des Überweisers | 9 | n | 0102, 0103, sad2, hdrg1 | |
| 4219 | Überweisung von anderen Ärzten (Ersatzwert: unbekannt) | ≤ 60 | a | 0102 | |
| 4220 | Überweisung an (Ersatzwert: kA.) | ≤ 60 | a | 0102, sad2 | (Note: kA = abbreviation for "keine Angabe" / no information) |
| 4221 | Kurativ / Präventiv / ESS / bei belegärztlicher Behandlung | 1 | n | 0102 | |
| 4225 | ASV-Teamnummer des Erstveranlassers | 9 | n | 0102 | |
| 4226 | ASV-Teamnummer des Überweisers | 9 | n | 0102 | |
| 4229 | Ausnahmeindikation | 5 | n | 0102 | Technical identifier for marking near-scarcity cases (Knappschaftsfällen). |
| 4233 | Stationäre Behandlung von ... bis ... | 16 | n | 0103 | |
| 4234 | anerkannte Psychotherapie | 1 | n | 0101, 0102 | Check box field (Ankreuzfeld). |
| 4235 | Datum des Anerkennungsbescheides | 8 | d | 0101, 0102 | Date of the approval notice from the cost bearer. |
| 4236 | Abklärung somatischer Ursachen vor Aufnahme einer Psychotherapie | 1 | n | 0101 | Check box field (Ankreuzfeld). |
| 4239 | Scheinuntergruppe | 2 | n | 0101, 0102, 0103, 0104 | |
| 4241 | Lebenslange Arztnummer (LANR) des Erstveranlassers (Ersatzwert: 999999900) | 9 | n | 0102 | |
| 4242 | Lebenslange Arztnummer des Überweisers (Ersatzwert: 999999900) | 9 | n | 0102, 0103, sad2, hdrg1 | |
| 4243 | Weiterbehandelnder Arzt (Ersatzwert: unbekannt) | ≤ 60 | a | 0104 | |
| 4247 | Antragsdatum (des Anerkennungsbescheides) | 8 | d | 0101, 0102 | |
| 4248 | Pseudo-LANR (für Krankenhausärzte im Rahmen der ASV-Abrechnung) des Erstveranlassers | 9 | n | 0102 | |
| 4249 | Pseudo-LANR (für Krankenhausärzte im Rahmen der ASV-Abrechnung) des Überweisers | 9 | n | 0102 | |
| 4250 | Kombinationsbehandlung aus Einzel- und Gruppentherapie | 1 | n | 0101, 0102 | |
| 4251 | Durchführungsart der Kombinationsbehandlung | 1 | n | 0101, 0102 | |
| 4252 | Gesamtanzahl bewilligter Therapieeinheiten für den Versicherten | ≤ 3 | n | 0101, 0102 | |
| 4253 | Bewilligte GOP für den Versicherten | 5, 6 | a | 0101, 0102 | |
| 4254 | Anzahl der abgerechneten GOPen für den Versicherten | ≤ 3 | n | 0101, 0102 | |
| 4255 | Gesamtanzahl bewilligter Therapieeinheiten für die Bezugsperson | ≤ 3 | n | 0101, 0102 | |
| 4256 | Bewilligte GOP für die Bezugsperson | 5, 6 | a | 0101, 0102 | |
| 4257 | Anzahl der abgerechneten GOPen für die Bezugsperson | ≤ 3 | n | 0101, 0102 | |
| 4261 | Kurart | 1 | n | 0109 | |
| 4262 | Durchführung als Kompaktkur | 1 | n | 0109 | |
| 4263 | genehmigte Kurdauer in Wochen | ≤ 2 | n | 0109 | |
| 4264 | Anreisetag | 8 | d | 0109 | |
| 4265 | Abreisetag | 8 | d | 0109 | |
| 4266 | Kurabbruch am | 8 | d | 0109 | |
| 4267 | Bewilligte Kurverlängerung in Wochen | ≤ 2 | n | 0109 | |
| 4268 | Bewilligungsdatum Kurverlängerung | 8 | d | 0109 | |
| 4269 | Verhaltenspräventive Maßnahmen angeregt | 1 | n | 0109 | |
| 4270 | Verhaltenspräventive Maßnahmen durchgeführt | 1 | n | 0109 | |
| 4271 | Kompaktkur nicht möglich | 1 | n | 0109 | |
| 4272 | Durchführung als Kompaktkur mit Refresher | 1 | n | 0109 | |
| 4275 | Kontakt zur Vorbereitung des Kuraufenthaltes | 1 | n | 0109 | |
| 4276 | Anreisetag als Teil 2 bei Refresher | 8 | d | 0109 | |
| 4277 | Abreisetag als Teil 2 bei Refresher | 8 | d | 0109 | |
| 4278 | Kurabbruch am als Teil 2 bei Refresher | 8 | d | 0109 | |
| 5000 | Leistungstag | 8 | d | 0101, 0102, 0103, 0104, 0109, sad1, sad2, sad3 | |
| 5001 | Gebührennummer (GNR) | ≤ 9 bzw. 5, 6 | a | 0101, 0102, 0103, 0104, 0109, sad1, sad2, sad3 | |
| 5002 | Art der Untersuchung | ≤ 60 | a | 0101, 0102, 0103, 0104 | |
| 5003 | (N)BSNR des vermittelten Facharztes | 9 | n | 0101, 0102, 0103, 0104 | |
| 5005 | Multiplikator | 3 | n | 0101, 0102, 0103, 0104 | This field is used to indicate multiple application of the service recorded in FK 5001. Additionally, the field can indicate multiple application of material/supply costs recorded in FK 5012, if this is individually determined by the responsible Kassenärztliche Vereinigung per fee schedule item. |
| 5006 | Um-Uhrzeit | 4 | n | 0101, 0102, 0103, 0104 | |
| 5008 | DKM | ≤ 3 | n | 0101, 0102, 0103, 0104 | |
| 5009 | freier Begründungstext | ≤ 60 | a | 0101, 0102, 0103, 0104, sad1, sad2, sad3, hdrg1 | |
| 5010 | Chargennummer | ≤ 60 | a | 0101, 0102, 0103, 0104 | |
| 5011 | Sachkosten-Bezeichnung | ≤ 60 | a | 0101, 0102, 0103, 0104, sad1, sad2, sad3 | |
| 5012 | Sachkosten/Materialkosten in Cent | ≤ 10 | n | 0101, 0102, 0103, 0104, sad1, sad2, sad3 | |
| 5013 | Prozent der Leistung | 3 | n | 0101, 0102, 0103, 0104 | |
| 5015 | Organ | ≤ 60 | a | 0101, 0102, 0103, 0104 | |
| 5016 | Name des Arztes | ≤ 60 | a | 0101, 0102, 0103, 0104 | This field is used to transmit physician names that must be stated as justification for a fee schedule number according to the provisions of the EBM. Possible contents of this field are: recipient of the letter, name of the consiliary partner, name of the anesthesiologist. |
| 5017 | Besuchsort bei Hausbesuchen | ≤ 60 | a | 0101, 0102, 0104 | |
| 5018 | Zone bei Besuchen | 2 | a | 0101, 0102, 0104 | |
| 5019 | Erbringungsort/Standort des Gerätes | ≤ 60 | a | 0101, 0102, 0103, 0104 | |
| 5020 | Wiederholungsuntersuchung | 1 | n | 0101, 0102, 0103, 0104 | |
| 5021 | Jahr der letzten Krebsfrüherkennungsuntersuchung | 4 | n | 0101, 0102, 0103, 0104 | |
| 5023 | GO-Nummern-Zusatz | 1 | a | 0101, 0102, 0103, 0104 | |
| 5024 | GNR-Zusatzkennzeichen poststationär erbrachte Leistungen | 1 | a | 0101, 0102, 0103, 0104 | |
| 5025 | Aufnahmedatum | 8 | d | 0101, 0102, 0103, 0104 | |
| 5026 | Entlassungsdatum | 8 | d | 0101, 0102, 0103, 0104 | |
| 5027 | Hybrid-DRG Leistung | 4 | a | hdrg1 | |
| 5028 | Datum Beginn der Leistung | 8 | d | hdrg1 | |
| 5029 | Datum Ende der Leistung | 8 | d | hdrg1 | |
| 5030 | Beatmungsstunden | ≤ 4 | n | hdrg1 | |
| 5034 | OP-Datum | 8 | d | 0101, 0102, 0103, 0104, hdrg1 | |
| 5035 | OP-Schlüssel | ≤ 8 | a | 0101, 0102, 0103, 0104, hdrg1 | |
| 5036 | GNR als Begründung | 5, 6 | a | 0101, 0102, 0103, 0104 | |
| 5037 | Gesamt-Schnitt-Naht-Zeit (Minuten) | ≤ 3 | n | 0101, 0102, 0103, 0104 | |
| 5038 | Komplikation | ≤ 60 | a | 0101, 0102, 0103, 0104 | |
| 5040 | Patientennummer der e-Dokumentation Hautkrebs-Screening | ≤ 8 | a | 0101, 0102, 0103, 0104 | |
| 5041 | Seitenlokalisation OPS | 1 | a | 0101, 0102, 0103, 0104, hdrg1 | |
| 5042 | Mengenangabe KM /AM | ≤ 5 | n | 0101, 0102, 0103, 0104 | |
| 5043 | Maßeinheit KM /AM | 1 | n | 0101, 0102, 0103, 0104 | |
| 5050 | Melde-ID Implantateregister | 10 | a | 0101, 0102, 0103, 0104 | |
| 5051 | Hash-String Implantateregister | ≤ 512 | a | 0101, 0102, 0103, 0104 | |
| 5052 | Hash-Wert Implantateregister | 64 | a | 0101, 0102, 0103, 0104 | |
| 5074 | Name Hersteller/Lieferant | ≤ 60 | a | 0101, 0102, 0103, 0104 | |
| 5075 | Artikel-/Modellnummer | ≤ 60 | a | 0101, 0102, 0103, 0104 | |
| 5076 | Rechnungsnummer | ≤ 60 | a | 0101, 0102, 0103, 0104, sad1, sad2, sad3 | |
| 5077 | HGNC-Gensymbol (Ersatzwert: 999999) | ≤ 20 | a | 0101, 0102, 0103, 0104 | |
| 5078 | Gen-Name | ≤ 60 | a | 0101, 0102, 0103, 0104 | |
| 5079 | Art der Erkrankung | ≤ 60 | a | 0101, 0102, 0103, 0104 | |
| 5098 | (N)BSNR des Ortes der Leistungserbringung | 9 | n | 0101, 0102, 0103, 0104, 0109, sad1, sad2, sad3, hdrg1 | |
| 5099 | Lebenslange Arztnummer (LANR) des Vertragsarztes/Vertragspsychotherapeuten (Ersatzwert: 999999900) | 9 | n | 0101, 0102, 0103, 0104, 0109, sad1, sad2, sad3, hdrg1 | |
| 5100 | ASV-Teamnummer des Vertragsarztes | 9 | n | 0101, 0102, 0104 | |
| 5101 | Pseudo-LANR (für Krankenhausärzte im Rahmen der ASV-Abrechnung) des LE | 9 | n | 0101, 0102, 0104 | |
| 5102 | Krankenhaus-IK (im Rahmen der ASV-Abrechnung) | 9 | n | 0101, 0102, 0104 | |
| 6001 | ICD-Code | 3, 5, 6 | a | 0101, 0102, 0103, 0104, 0109 | |
| 6003 | Diagnosensicherheit | 1 | a | 0101, 0102, 0103, 0104, 0109 | |
| 6004 | Seitenlokalisation | 1 | a | 0101, 0102, 0103, 0104, 0109 | |
| 6006 | Diagnosenerläuterung | ≤ 60 | a | 0101, 0102, 0103, 0104, 0109 | |
| 6008 | Diagnosenausnahmetatbestand | ≤ 60 | a | 0101, 0102, 0103, 0104, 0109 | |
| 6009 | Hauptdiagnose (ICD-10-GM-Kode) | 3, 5, 6 | a | hdrg1 | |
| 6010 | Seitenlokalisation Hauptdiagnose | 1 | a | hdrg1 | |
| 6011 | Nebendiagnose (ICD-10-GM-Kode) | 3, 5, 6 | a | hdrg1 | |
| 6012 | Seitenlokalisation Nebendiagnose | 1 | a | hdrg1 | |
| 8000 | Satzart | 4 | a | alle Satzarten | |
| 9102 | Empfänger | 2 | n | adt0, kad0, sad0 | |
| 9103 | Erstellungsdatum | 8 | d | con0 | |
| 9106 | verwendeter Zeichensatz | 1 | n | con0 | |
| 9115 | Erstellungsdatum ADT-Datenpaket | 8 | d | adt0 | |
| 9116 | Erstellungsdatum KADT-Datenpaket | 8 | d | kad0 | |
| 9117 | Erstellungsdatum Hybrid-DRG-Datenpaket | 8 | d | hdrg0 | |
| 9122 | Erstellungsdatum SADT-Datenpaket | 8 | d | sad0 | |
| 9132 | enthaltene Datenpakete dieser Datei | 1 | n | con0 | This field defines the data packages contained in a KVDT file. Each data package may only be present exactly once per file. The field must be present at least once. |
| 9204 | Abrechnungsquartal | 5 | n | adt0, kad0, sad0 | |
| 9212 | Version der Satzbeschreibung | ≤ 11 | a | adt0, kad0, sad0, hdrg0 | |
| 9250 | AVWG-Prüfnummer der AVS | 15-17 | a | adt0, kad0, sad0 | Verification number of the deployed prescription drug regulatory software (Arzneimittelverordnungssoftware), if available. |
| 9251 | HMV-Prüfnummer | 15-17 | a | adt0, kad0, sad0 | |
| 9260 | Anzahl Teilabrechnungen | 2 | n | adt0 | |
| 9261 | Abrechnungsteil x von y | 2 | n | adt0 | |
| 9901 | Systeminterner Parameter | ≤ 60 | a | alle Satzarten | This field differs from all other fields in that it is read over (skipped) by the Kassenärztliche Vereinigungen. This makes it possible to store data that is only system-internally relevant. This field can be transmitted in any record type at any position in any number, but not as the very first field of a file. |

---

## 8 Referenced Documents (Referenzierte Dokumente)

| # | Reference | Document |
|---|-----------|----------|
| 1 | [KBV_ITA_VGEX_Anforderungskatalog_KVDT] | Anforderungskatalog KVDT (KVDT Requirements Catalog), current version |
| 2 | [KBV_ITA_VGEX_Mapping_KVK] | Mappingtabelle KVK -- eGK (Mapping Table KVK to eGK), current version |
| 3 | [KBV_IA_VGEX_Anforderungskatalog_Formularbedruckung] | Anforderungskatalog Formularbedruckung (Form Printing Requirements Catalog), current version |
| 4 | [KBV_ASV_AV_Anlage 6] | Annex 6 to the agreement per § 116b Abs. 6 Satz 12 SGB V on the form and content of the billing procedure and the required pre-prints for ambulatory specialist care (ASV-AV) |
| 5 | [KBV_ASV] | KBV website topic page on ambulatory specialist care (Ambulante Spezialfachärztliche Versorgung) |
| 6 | [HDRG_Verordnung] | Regulation on a special cross-sector equal remuneration (Hybrid-DRG-Verordnung) |
| 7 | [BAEK_Rili_Labormedizin] | Guideline of the Bundesärztekammer (German Medical Association) on quality assurance of laboratory medical examinations |
