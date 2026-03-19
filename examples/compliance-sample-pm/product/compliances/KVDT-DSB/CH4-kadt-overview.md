## KADT Data Package -- Overview

| Field | Value |
|-------|-------|
| **Source** | KVDT-DSB v6.02 |
| **Chapter** | 4 -- KADT-Datenpaket |
| **Data Package** | KADT |
| **Refer** | [kad0](kad0.md), [kad9](kad9.md), [0109](0109.md), [kadt-feldtabelle](kadt-feldtabelle.md), [kadt-regeltabelle](kadt-regeltabelle.md) |

### 4.1 Purpose (Zielsetzung)

The KADT data package is used to transmit spa physician billing (kurarztliche Abrechnung). This billing option exists only for primary health insurance funds (Primarkassen) and substitute health insurance funds (Ersatzkassen), not for other cost carriers (Sonstige Kostentrager). The spa physician settles directly with those cost carriers.

The destination for spa physician billing is the spa physician administrative office at the Kassenarztlichen Vereinigung Westfalen-Lippe in Dortmund. This applies to all spa physicians in Germany.

The legal basis is the "Contract on spa physician treatment" (Vertrag uber die kurarztliche Behandlung) agreed between the central associations of health insurance funds and the KBV with participation of the Verbandes Deutscher Badearzte.

### 4.2 Overview (Ubersicht)

The following KADT record types are defined:

| Record Type Description | Satzart |
|--------------------------|---------|
| KADT Data Package Header | kad0 |
| KADT Data Package Closing | kad9 |
| Spa Physician Treatment | 0109 |

### 4.3 Ordering (Anordnung)

The sequence, count, and position of record types within the KADT data package are as follows:

- Record "kad0" appears once. It must be placed as the first record of the KADT data package.
- Record "0109" follows record "kad0" in any number.
- Record "kad9" appears once per KADT data package. It must be placed as the last record of the KADT data package.

### 4.4 Record Type Structure

A record of Satzart "0109" consists of fields with the following identifiers:

- "8xxx" -- Record-global fields (Satzglobale Felder)
- "3xxx" -- Patient fields (Patientenfelder)
- "4xxx" -- Record-type-specific fields (Satzartspezifische Felder)
- "5xxx" -- Service fields (Leistungsfelder)
- "6xxx" -- Diagnosis fields (Diagnosefelder)

### 4.5 Special Notes (Besondere Hinweise)

#### 4.5.1 Notes on Fields 5000, 5001, 6001, 6003, 6004, and 6006

Both the date of the medical service for an intercurrent illness and the "date of the performed follow-up examination" must be transmitted under FK 5000. For each follow-up examination, a FK 5001 with pseudo fee schedule number "00001U" must be transmitted.

Under field identifier 6001 -- optionally in conjunction with fields 6003, 6004, 6006, 6008 -- both the spa diagnoses and the diagnoses for intercurrent illnesses must be transmitted. See also Chapter 4.8, illustration "Kurarztschein-Ruckseite".

### 4.6 Accompanying Documents (Begleitpapiere)

To ensure proper forwarding of the billing file to the billing office, every billing must be accompanied by an explanation whose structure and format is specified by the spa physician administrative office.

### 4.8 Printed Form "Kurarztschein" (Spa Physician Certificate)

The "Kurarztschein" (spa physician certificate) is the official printed form used for documenting spa physician treatment. It has a front side (Vorderseite) containing insurance fund information, patient details, type of ambulatory preventive care, compact spa designation, duration, spa location, permanent medication, and physician signature. The back side (Ruckseite) contains arrival/departure dates, dates of examinations/patient contacts per S 14 of the spa physician contract (up to 12 entries), early termination date, extension approval, diagnoses, findings, risk factors, behavioral preventive measures (initiated/performed), and whether compact spa was not possible.
