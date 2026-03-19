# 1 Fundamentals (Grundlagen)

| Field | Value |
|-------|-------|
| **Source** | KVDT-DSB v6.02 |
| **Section** | Chapter 1 (pages 8-19) |
| **Scope** | Foundational concepts for the KVDT dataset description |

## 1.1 Purpose (Zielsetzung)

This KVDT dataset description enables the bundled transmission of:

- Billing data (ADT)
- Short-term medical billing data (KADT)
- Billing data for pregnancy termination NRW (SADT)

from a medical practice to the respectively responsible Association of Statutory Health Insurance Physicians (Kassenaerztliche Vereinigung). The dataset description is designed so that additional data packages can be added to the "Container Model" as needed.

**With regard to statutory and contractual provisions as well as decisions of the medical self-governing bodies, changes to these guidelines remain reserved.**

## 1.2 Storage Structure (Struktur der Speicherung)

A **file** consists of **data packages** and **container records**. The following **data packages** are defined:

- **ADT** -- Billing Data Package (Abrechnungs-Datenpaket)
- **KADT** -- Short-term Medical Billing Data Package (Kuraerztliches Abrechnungs-Datenpaket)
- **SADT** -- Pregnancy Termination Data Package (Schwangerschaftsabbruch-Datenpaket)

A **data package** is subdivided into **records** (Saetze). The following **records** are defined:

### Container Records

| Record | ID |
|--------|----|
| Container-Header | "con0" |
| Container-Closing | "con9" |
| Practice Site Data | "besa" |
| Proficiency Test Certificates | "rvsa" |

### ADT Data Package

| Record | ID |
|--------|----|
| ADT Data Package Header | "adt0" |
| ADT Data Package Closing | "adt9" |
| Outpatient Treatment | "0101" |
| Referral | "0102" |
| Hospital-based Treatment | "0103" |
| Emergency Service / Substitution / Emergency | "0104" |

### KADT Data Package

| Record | ID |
|--------|----|
| KADT Data Package Header | "kad0" |
| KADT Data Package Closing | "kad9" |
| Short-term Medical Treatment Billing | "0109" |

### SADT Data Package

| Record | ID |
|--------|----|
| SADT Data Package Header | "sad0" |
| SADT Data Package Closing | "sad9" |
| SADT Outpatient Treatment | "sad1" |
| SADT Referral | "sad2" |
| SADT Hospital-based Treatment | "sad3" |

### HDRG Data Package

| Record | ID |
|--------|----|
| HDRG Data Package Header | "hdrg0" |
| HDRG Data Package Closing | "hdrg9" |
| HDRG Data Package Record | "hdrg1" |

A **record** is subdivided into **fields**. Fields are defined per record (see record tables and field tables).

A **field** is the smallest unit of a file. It consists of:

| Component | Size |
|-----------|------|
| Length specification of the field | 3 Bytes |
| Field identifier (Feldkennung) | 4 Bytes |
| Actual field content | Variable (see field table) |
| Field-end marker CR/LF | 2 Bytes (ASCII 13 = CR, ASCII 10 = LF) |

## 1.3 High-Level Structure (Grobstruktur)

A **file** is composed of container records ("con0", "con9", "besa", "rvsa") and data packages:

```
File
  ADT Data Package
  KADT Data Package
  SADT Data Package
```

A **data package** is composed of multiple **records**:

```
Data Package
  Record 1
  ...
  Record n
```

A **record** is subdivided into **fields**:

```
Record
  Field 1
  ...
  Field n
```

Each **field** has the following structure:

```
Field
  Length
  Identifier (Kennung)
  Content (Inhalt)
  End CR/LF
```

## 1.4 Storage Schemas (Speicherung)

### KVDT High-Level Schema for ADT, KADT, and SADT Billing

| Record | ID |
|--------|----|
| Container-Header | "con0" |
| Practice Site Data | "besa" |
| Proficiency Test Certificates | "rvsa" |
| Data Package 1 | |
| ... | |
| Data Package m | |
| Container-Closing | "con9" |

### KVDT High-Level Schema for HDRG Billing

| Record | ID |
|--------|----|
| Container-Header "con0" | "con0" |
| HDRG Data Package | |
| Container-Closing | "con9" |

### Example KVDT Detailed Schema (ADT, KADT, and SADT Billing)

| Record Description | Record Type |
|--------------------|-------------|
| Container-Header | "con0" |
| Practice Site Data | "besa" |
| Proficiency Test Certificates | "rvsa" |
| ADT Data Package Header | "adt0" |
| Case a | "010r" |
| ... | |
| Case z | "010r" |
| ADT Data Package Closing | "adt9" |
| KADT Data Package Header | "kad0" |
| Record 1 | "0109" |
| ... | |
| Record n | "0109" |
| KADT Data Package Closing | "kad9" |
| SADT Data Package Header | "sad0" |
| Record 1 | "sadr" |
| ... | |
| Record n | "sadr" |
| SADT Data Package Closing | "sad9" |
| Container-Closing | "con9" |

### Example HDRG Detailed Schema

| Record Description | Record Type |
|--------------------|-------------|
| Container-Header | con0 |
| Hybrid-DRG Data Package Header | hdrg0 |
| Record 1 | hdrg1 |
| ... | |
| Record n | hdrg1 |
| Hybrid-DRG Data Package Closing | hdrg9 |
| Container-Closing | con9 |

## 1.5 Record and Record Table (Satz und Satztabelle)

### 1.5.1 Record Structure (Satzaufbau)

Every record begins with a field "8000" which contains the record type. Based on the record type, the corresponding record table is consulted.

| EXAMPLE FOR THE STRUCTURE OF A DATA RECORD | | | |
|-----|------|------|-------|
| **Length** | **Identifier** | **Content (Example)** | **End** |
| 013 | 8000 | 0101 | CR/LF |
| 011 | 3000 | 21 | CR/LF |
| ... | ... | ... | ... |

### 1.5.2 Record Tables (Satztabellen)

The record tables serve to validate the record structure. Each record table specifies the permissible fields of the record type and their arrangement. Fields are designated with a field identifier (FK).

**Note:**

Fields are to be transmitted according to their arrangement in the record table, taking into account the information in the "Occurrence" column.

**Exception** for ADT record types "010x" and KADT record type "0109": Fields with field identifiers 5000-5019 are to be transmitted chronologically or in context. In particular, the arrangement of service days (contents of field 5000) must be in ascending order within the ADT data package.

Each field has an entry with the following information:

| Content | Meaning | Example |
|---------|---------|---------|
| Field Identifier (FK) | Permissible field identifier | 8000 |
| Occurrence (Vorkommen) | Count per record, see explanation below | 1 |
| Field Content (Feldinhalt) | Field designation | Record Type |
| Field Type (Feldart) | Mandatory/Optional indicator (m, M, K, k), see Section 1.5.3 | M |
| Condition (Bedingung) | Rule xxx (Note: only context rules where the condition for the field's presence is specified) | Rule 302 |
| Explanation (Erlaeuterung) | Notes on the field | Record type "Referral" |

The "Occurrence" column describes the **hierarchy** of individual fields within a record and additionally specifies the permissible frequency of a field relative to the parent field or record in the hierarchy:

- FK 3101 -- Occurrence level 1 = 1: Field 3101 can occur once per record "0101"
- FK 5000 -- Occurrence level 1 = n: Field 5000 can occur any number of times per record "0101"
- FK 5001 -- Occurrence level 2 = n: Field 5001 can occur any number of times per field 5000
- FK 5002 -- Occurrence level 3 = 1: Field 5002 can occur only once per field 5001
- FK 5009 -- Occurrence level 3 = n: Field 5009 can occur any number of times per field 5001

### 1.5.3 Field Types (Feldarten)

The "Field Type" column indicates whether a field must be present in a record or not, and whether its presence is tied to a specific condition (specified in the "Condition" column).

**M = Unconditional mandatory field**

An unconditional mandatory field must be present in a record. If the "Occurrence" column allows multiple or n-fold occurrence, this field must occur at least once in the record.

**m = Conditional mandatory field**

For a conditional mandatory field, its existence is tied to a specific condition (see "Conditions" column) or to the occurrence of a referenced field at a higher hierarchy level (see "Occurrence" column). A conditional mandatory field **must** be present in a record when either a condition in the "Conditions" column is present and fulfilled, or the field referenced at a higher hierarchy level exists.

**K = Optional field (Kannfeld)**

An optional field may appear in a record, with its occurrence not tied to any conditions. However, if corresponding information is present, it must be represented in the associated field, with proof of the presence of the information -- unlike conditional mandatory fields -- not being programmatically verifiable.

**k = Conditional optional field**

For a conditional optional field, its existence is tied to a specific condition (see "Conditions" column) or to the occurrence of a referenced field at a higher hierarchy level (see "Occurrence" column). A conditional optional field **may** be present in a record when either a condition in the "Conditions" column is present and fulfilled, or the field referenced at a higher hierarchy level exists.

**Note on implementation obligation:**

For a developer seeking KBV certification: fundamentally, regardless of field types, **all** fields of a data package must be implemented if certification for that data package is sought.

## 1.6 Field and Field Table (Feld und Feldtabelle)

### 1.6.1 Field Structure (Feldaufbau)

The actual units of information are the fields. Every field has the same structure. All information is represented as ASCII characters. Based on the field identifier, the corresponding entry in the field table is consulted.

| **Field Part** | **Length** | **Meaning** |
|---------------|-----------|-------------|
| Length | 3 Bytes | Field length in bytes |
| Identifier | 4 Bytes | Field identifier |
| Content | Variable | Billing information |
| End | 2 Bytes | ASCII 13 = CR (carriage return) + ASCII 10 = LF (line feed) |

For length calculation of a field, the rule applies: **Field Content + 9**

In this context, note that "empty" fields are not permitted, i.e., fields without content (e.g., "0094207") or with only spaces (e.g., "0114207 ") must not be transmitted.

### 1.6.2 Field Table (Feldtabelle)

There is only one record-type-independent field table per data package. The field table serves to validate the field contents of the data record. Each entry in the field table describes the content of the corresponding data field. In the field table, an entry with the following information exists for each defined field identifier.

Some validations can be performed immediately based on the field table entry, while further validations must branch to the **rule table** (Regeltabelle) or subordinate tables. In the field table, each entry is uniquely assigned to one field.

**Note:** Representation of dependencies on the KV-Specifika master file

The entries "kvx0", "kvx1", "kvx2", or "kvx3" in the Rule column of the field table are references to the corresponding record types of the KV-Specifika master file. The relevant field content of the KVDT file depends on KV-specific requirements. Before storing the relevant field content in the KVDT file, the corresponding record type "kvxn" (n=0, 1, 2, 3) of the respective KV-Specifika master file must be evaluated.

| Content | Meaning | Example |
|---------|---------|---------|
| FK | Field identifier, identification | 8000 |
| Field Designation (Feldbezeichnung) | Name of the field | Record-ID |
| Length# | Field length in bytes, see explanation below | 4 |
| Type* | Field type, see explanation below | a |
| Rule | Reference to rule table and/or reference to KV-Specifika master file | 110, kvx3 |
| Allowed Contents and Their Meaning | Allowed values and meaning | |
| Example | Possible field content | 0102 |

**#** The "Length of Field Content" column specifies how many characters (bytes) a field content may consist of. A numeric value (n) indicates a fixed length, with alternative lengths expressed by specifying different numeric values (n, m). The less-than-or-equal sign with a subsequent numeric value (<=n) restricts the field content to a maximum length.

**\*** The following **field types** are defined:

- **n = numeric**: For fixed lengths, the field must be padded with leading zeros. For variable lengths, no leading zeros may be transmitted.
- **a = alphanumeric**: An alphanumeric data field of length "<= n" (characters) must be implemented by a billing system such that the field can accept "n" characters. If fewer characters are entered in such a field, the transmission of leading or subsequent spaces is not permitted (Example: FK 3101, Length <= 45, Type a).
- **d = numeric date** in format YYYYMMDD, where DD = 01-31, MM = 01-12, YYYY = 0001-9999

## 1.7 Rule Table (Regeltabelle)

The logical relationships between data record fields, field table, and rule table are described by the following schema:

```
Field in Data Record:  [ Length | Field Identifier | Content | Field End ]
                                    |
                                    v
Field Table:           [ FK | Designation | Length | Type | Rule Number ]
                                                             |
                                                             v
Rule Table:                                        [ Rule Number | Rule Content ]
```

A separate rule table exists for each data package.

Each entry in the rule table describes a concrete rule. A rule defines permissible formats, allowed contents (value ranges), or agreements about possible contexts of specific fields. In the rule table, an entry with the following information exists for each rule number.

| Content | Meaning | Example |
|---------|---------|---------|
| Rule Number (R-Nr) | Identification | 106 |
| Category | Type of rule (format, content, existence, context checks, special notes) | Allowed Content |
| Check (Pruefung) | Rule content | 1, 2, 3 |
| Check Status (Pruefstatus) | Type of error message (W = Warning, F = Error, I = Info), see note | F |
| Explanation (Erlaeuterung) | Explanation | - |

## 1.8 Character Set (Zeichensatz)

The specified standard according to ISO 8859-15 corresponds to the eGK standard, so that no character set conversions are necessary upon reading.

Of the characters contained in the standard, only those explicitly listed in the character set table are permitted as field content, with the following restriction:

The characters "CR" and "LF" ("Carriage Return" = ASCII 13, "Line Feed" = ASCII 10) serve as field-end markers during data transmission. They must never be transmitted as field content.

### 1.8.1 Character Set Table of ISO 8859-15

The full ISO 8859-15 character set table is applicable, organized by decimal (0-255) and hexadecimal (00-FF) values, covering:

- Control characters (0-31)
- Standard ASCII printable characters (32-127): SP, !, ", #, $, %, &, ', (, ), *, +, etc.
- Extended Latin characters (128-255) including: accented vowels, special characters for European languages
- Notable characters: Euro sign at position 164 (0xA4), German sharp-s at position 223 (0xDF)
- CR at position 13 (0x0D) and LF at position 10 (0x0A) reserved as field-end markers

## 1.9 The Billing File (Die Abrechnungsdatei)

### 1.9.1 Wire-bound Electronic Billing

According to section 1 of the "Guidelines of the National Association of Statutory Health Insurance Physicians for the Use of IT Systems in Medical Practices for the Purpose of Billing" pursuant to § 295 Abs. 4 SGB V, the transmission of (billing) data must be performed electronically via wire-bound means. Additionally, the possibility must exist to copy the billing file to a data carrier for transport to a separate practice PC.

### 1.9.2 File Name Structure (Aufbau des Dateinamens)

The file name is composed as follows:

`Zhhnnnnnnnnn_TT.MM.JJJJ_hh.mm.eee`

| Component | Meaning |
|-----------|---------|
| **Z** | ISO 8859-15 Code |
| **hh** | Contained data packages in hexadecimal representation |
| **nnnnnnnnn** | The 9-digit (secondary) practice site number (NBSNR) (**1st priority**) or the hospital IK (in the context of ASV billing) (**2nd priority**) of the respective location where the billing file is created |
| **TT.MM.JJJJ_hh.mm** | Timestamp |
| **eee** | File extension CON (= default value) |

Positions 2 and 3 of the file name are used for encoding the data package content in hexadecimal form.

| Data Package | Hex Encoding Value |
|-------------|-------------------|
| ADT | 0x01 |
| KADT | 0x04 |
| SADT | 0x20 |
| Hybrid-DRG | 0x30 |

In the hexadecimal representation, "0x" is not written into the file name.

The content of positions 2 and 3 of the file name is formed by adding the data packages contained in the KVDT file. Example: ADT + KADT = 0x01 + 0x04 = 0x05 (hexadecimal).

Hybrid-DRG data packages must not be mixed with other data packages.

**Example:**

- `Z05721113456_19.01.2019_11.57.CON` -- KVDT file contains ADT and KADT data packages, NBSNR 721113456, ISO 8859-15
- `Z30721113456_19.01.2019_11.57.CON` -- KVDT file contains Hybrid-DRG data package, NBSNR 721113456, ISO 8859-15

---

**Note:** The KVDT does not permit splitting a data package across multiple files. Considering the transmission capability of further data packages to be defined, more data packages (8 total) can be represented in hexadecimal form than in decimal form (only 6).
