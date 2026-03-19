## ADT Data Package — Overview and Special Notes

| Field | Value |
|-------|-------|
| **Source** | KVDT-DSB v6.02 |
| **Section** | 3.1-3.3, 3.6 |
| **Scope** | ADT billing data package structure and special handling rules |

### Purpose

The ADT data package enables the transmission of contract-physician billing data.

### Record Types

| Record | Satzart |
|--------|---------|
| ADT-Datenpaket-Header | adt0 |
| ADT-Datenpaket-Abschluss | adt9 |
| Ambulante Behandlung (Outpatient Treatment) | 0101 |
| Ueberweisung (Referral) | 0102 |
| Belegaerztliche Behandlung (Hospital-Based Physician Treatment) | 0103 |
| Notfalldienst/Vertretung/Notfall (Emergency Service/Substitution/Emergency) | 0104 |

### Ordering Rules

The sequence, quantity, and position of records within the ADT data package are as follows:

- Record "adt0" occurs exactly once. It must be placed as the first record of the ADT data package.
- Records "0101", "0102", "0103", "0104" follow the "adt0" record in any number and any order.
- Record "adt9" occurs exactly once per ADT data package. It must be placed as the last record of the ADT data package.

### Field Categories

A data record of record types "0101 - 0104" consists of fields with the following identifiers:

| Prefix | Category |
|--------|----------|
| 8xxx | Global fields (Satzglobale Felder) |
| 3xxx | Patient fields (Patientenfelder) |
| 4xxx | Record-type-specific fields (Satzartspezifische Felder) |
| 5xxx | Service fields (Leistungsfelder) |
| 367x / 6xxx | Diagnosis fields (Diagnosefelder) |

### Special Notes

#### 3.6.1 — In-Vitro Diagnostic Order to Specialist Physician

Billing of in-vitro diagnostic services based on a referral form for in-vitro diagnostic services as order services (Form 10) may only use record type 0102 with Scheinuntergruppe "27" (= referral form for in-vitro diagnostic order services).

Field FK 4217 ((N)BSNR of the initial requester) is only transmitted when a further referral was initiated based on the referral of the initial requester.

If both field FK 4217 and field FK 4218 ((N)BSNR of the referrer) are transmitted in the data record simultaneously, they must differ from each other.

Alternatively to field FK 4217, a field FK 4225 (ASV team number of the initial requester) may be transmitted when the further referral was initiated based on the referral of the initial requester.

**Note:** An ASV team may include multiple specialist physicians who perform the in-vitro diagnostic services as members. All members of an ASV team receive the same ASV team number. It is not mandatory that a specialist physician added as a member of an ASV team performs all in-vitro diagnostic services of an order. A further referral of in-vitro diagnostic services within an ASV team is therefore not fundamentally excluded. In such cases, it is permissible to transmit an identical ASV team number in field FK 4225 and field FK 4226.

In fields FK 4217 and FK 4218, only (subsidiary) practice site numbers of physicians participating in contract-physician care may be transmitted. In fields FK 4225 and FK 4226, only ASV team numbers may be transmitted.

Field FK 4219 serves to clearly distinguish from fields FK 4218 and FK 4226. Field FK 4219 is transmitted when a referral is made by a service provider without a BSNR, e.g., a referral from other physicians (e.g., dentists, military physicians, etc.).

In addition to the (N)BSNR or ASV team number, the "Lebenslange Arztnummer (LANR)" or, for ASV billing, the "Lebenslange Arztnummer (LANR)" or "Pseudo-LANR for hospital physicians" is required. Accordingly, the field pairs 4217/4241, 4218/4242 or 4225/4241, 4226/4242 or 4226/4249 must be transmitted.

#### 3.6.2 — Laboratory Order to Laboratory Community

Laboratory communities are shared facilities of contract physicians that serve the purpose of performing laboratory-medical analyses on a regular basis in the same commercially used facility. Laboratory communities bill directly with the responsible regional physicians' association and receive a practice site number for this purpose. The fee notice for the laboratory community is broken down by its member participants. From the perspective of contract physicians participating in the laboratory community, the laboratory community constitutes a subsidiary practice site. The contract physicians affiliated with it receive the same subsidiary practice site number for this subsidiary practice site. The physician who orders the laboratory service acts as the performing physician and must therefore identify the billing of the laboratory community by providing the physician number and the (subsidiary) practice site number of the ordering practice. Form 10A is to be used for ordering laboratory services from laboratory communities.

In the practice site data record "besa", the members of the laboratory community must also be listed with their (N)BSNR, LANR, and, if applicable, ASV team number and address.

Billing of laboratory communities is done in record type 0102 with Scheinuntergruppe "28" (= request form for laboratory services at laboratory communities).

In field 4218, only (subsidiary) practice site numbers of contract physicians may be transmitted. In field 4226, only ASV team numbers may be transmitted.

In addition to the (N)BSNR or ASV team number, the "Lebenslange Arztnummer (LANR)" is also required, i.e., it is a field pair 4218/4242 or 4226/4242 to be transmitted.

The identification of billed services (FK 5098, 5099) must be identical to the referrer's practice site number and LANR (FK 4218, 4242). If the referral is initiated by an "ASV physician" (= field FK 4226 is present), a field 5100 with the ASV team number must additionally be transmitted alongside fields 5098, 5099.

The (N)BSNR should be determined from a corresponding practice-specific "LG member directory" or can optionally be taken from the contract physician stamp printed on Form 10A.

**Important Note:** In the practice site data record "besa", the BSNR of the billing-generating practice site (= laboratory community) must always be transmitted as the first BSNR (FK 0201), since the assignment to the corresponding KV-specific master data file is done via the XPM check using characters 1-2 of the content of the first FK 0201 of the besa data record.

#### 3.6.3 — General Notes on In-Vitro Diagnostic Orders

Field 4221 must be transmitted when a referral for in-vitro diagnostic services per Form 10 or a laboratory order per Form 10A is present (SUG 27 or 28).

Only for Scheinuntergruppen 27 and 28 may field 4229 be present.

Only for Scheinuntergruppe "27" may field 4217 or field 4225 be present.

#### 3.6.4 — Handling of Laboratory Orders from Knappschaft Physicians

If a contract physician, acting in their capacity as a Knappschaft physician, issues a referral for laboratory tests for a patient of the Knappschaft, they also use printed Forms 10 or 10A (if the KV-specific requirements define "99" as the Knappschaft designation). A special identification is therefore required so that the costs of these laboratory tests are not charged against the contract-physician economic efficiency bonus.

The following procedure applies in these cases: The Knappschaft physician marks the relevant laboratory orders by entering the technical identifier 87777 in the applicable field as a code (corresponding to ADT field 4229).

#### 3.6.5 — Integration of ASV Billing into the ADT Data Package

For the ASV billing, the definition of additional ASV-specific fields in the ADT data package was largely avoided.

Exceptions:

- Field "ASV-Teamnummer" (FK 0222) added in the container record type "Betriebsstaettendaten (besa)"
- Field "ASV-Teamnummer des Vertragsarztes" (FK 5100) added in ADT record types "Ambulante Behandlung (0101)", "Ueberweisung (0102)", and "Notfalldienst/Vertretung/Notfall (0104)"
- Field "Pseudo-LANR fuer Krankenhausaerzte im Rahmen der ASV-Abrechnung" (FK 0223) added in the container record type "Betriebsstaettendaten (besa)"
- Field "Pseudo-LANR (fuer Krankenhausaerzte im Rahmen der ASV-Abrechnung) des LE" (FK 5101) added in ADT record types "Ambulante Behandlung (0101)", "Ueberweisung (0102)", and "Notfalldienst/Vertretung/Notfall (0104)"
- Field "ASV-Teamnummer des Erstveranlassers" (FK 4225) added in ADT record type "Ueberweisung (0102)"
- Field "ASV-Teamnummer des Ueberweisers" (FK 4226) added in ADT record type "Ueberweisung (0102)"
- Field 4248 "Pseudo-LANR (fuer Krankenhausaerzte im Rahmen der ASV-Abrechnung) des Erstveranlassers" added in ADT record type "Ueberweisung (0102)"
- Field 4249 "Pseudo-LANR (fuer Krankenhausaerzte im Rahmen der ASV-Abrechnung) des Ueberweisers" added in ADT record type "Ueberweisung (0102)"
- Field 0213 "Krankenhaus-IK (im Rahmen der ASV-Abrechnung)" added in the container record type "Betriebsstaettendaten (besa)" for transmitting the IK number of the hospital
- Field 5102 "Krankenhaus-IK (im Rahmen der ASV-Abrechnung)" added in ADT record types "Ambulante Behandlung (0101)", "Ueberweisung (0102)", and "Notfalldienst/Vertretung/Notfall (0104)"

Otherwise, existing fields of the ADT data package are used per the following table for transmitting ASV billing information:

| FK | Field Name | Usage in ASV Billing | Examples |
|----|-----------|----------------------|----------|
| 5001 | GNR | For EBM GOPs or "pseudo codes" for ASV services outside of EBM per Section 3.6.5.1 | 50200, 88500 |
| 5011 | Sachkosten-Bezeichnung | For material cost descriptions or the GOAe number of the rendered service per Section 3.6.5.1 | 5489 |
| 5012 | Sachkosten/Materialkosten in Cent | For material costs in cents or the price in cents per GOAe number per Section 3.6.5.1 | 52458 |
| 6006 | Diagnosenerlaeuterung | For service documentation (if specified in the ASV guideline), e.g., the TNM status with R and G code per UICC staging, a statement of tumor disease progression | rT1N2M1G2R1 |

#### 3.6.5.1 — Billing of ASV Services Not Part of the EBM

Since 01.01.2015, pursuant to the resolution of the supplemented extended Evaluation Committee per § 87 Abs. 5a SGB V for the remuneration of services of outpatient specialist medical care per § 116b Abs. 6 Satz 8 SGB V, **2. Verguetung der ASV-Leistungen** and Annex 5 to the agreement per § 116b Abs. 6 Satz 12 SGB V on the form and content of the billing procedure and the required printed forms for outpatient specialist medical care (ASV-AV) services that are not part of the EBM, these can be transmitted via KVDT/ADT billing to the respective regional physicians' association.

ASV physicians billing these services enter a pseudo code in their billing in field 5001 (GNR / fee schedule number) and identify them with their ASV team number in field 5100 (ASV team number of the contract physician).

Additionally, the GOAe number of the rendered service must be recorded in field 5011 (Sachkosten-Bezeichnung) and the price in field 5012 (Sachkosten/Materialkosten) in cents.

Remuneration of services follows the GOAe (fee schedule for physicians) with the ASV-specific fee rates (laboratory services 1x, technical services 1.2x, and other medical services 1.5x fee rate).

The agreed pseudo codes and further information (e.g., practice messages for informing ASV clients) can be found on the KBV website ([KBV_ASV]).

**Example:**

Service in Section 2 of the Appendix Gastrointestinal Tumors: PET/PET-CT

- Pseudo-GOP: 88500 — Content of field 5001
- GOAe number: 5489 — Content of field 5011
- Base rate: 437.15 EUR
- Price: 437.15 EUR * 1.2 = 524.58 EUR = 52458 Cent — Content of field 5012

GOAe number 5489 corresponds to a service in Section O; the multiplier 1.2 applies.

#### 3.6.5.2 — Specifying Tumor Stage / TNM Status and/or Progression

To document the progression of a severe disease course in individual cases, this is done per the codings specified in **Anlage 6 TNM-Status** to the agreement per § 116b Abs. 6 Satz 12 SGB V on the form and content of the billing procedure and the required printed forms for outpatient specialist medical care (ASV-AV), cf. [KBV_ASV_AV_Anlage 6].

The basis is the international classification of tumor stages — UICC for short.

The 11-character TNM status contains the mandatory entries: r (recurrence) T (tumor classification) N (lymph node metastases) M (distant metastases) G (grading) and R (residual tumor), where each value must be filled in.

Progression is indicated by specifying values 0 or 1.

Both entries are transmitted in field 6006 (Diagnosenerlaeuterung).

If both the TNM status and progression are documented, they must be separated by a suitable separator character; the TNM status must come first.

**Note:** Both the TNM status entry and the progression entry can also be made separately.

**Examples:**
- TNM status without progression: rT1N2M1G2R1
- TNM status with progression: rT1N2M1G2R1+1
- Progression without TNM status: 1
