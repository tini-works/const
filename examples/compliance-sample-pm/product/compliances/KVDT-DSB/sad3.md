## sad3 -- SADT Hospital-based Physician Treatment

| Field | Value |
|-------|-------|
| **Satzart** | sad3 |
| **German Name** | SADT-belegarztliche Behandlung |
| **Source** | KVDT-DSB v6.02 |
| **Section** | 5.4.5 |
| **Data Package** | SADT |
| **Refer** | [sad0](sad0.md), [sad9](sad9.md), [sad1](sad1.md), [sad2](sad2.md), [sadt-feldtabelle](sadt-feldtabelle.md), [sadt-regeltabelle](sadt-regeltabelle.md) |

### Purpose

Record type for hospital-based physician (Belegarzt) treatment billing within the SADT data package. Contains the same service fields as sad1 but identifies inpatient treatment by a contracted physician using hospital beds.

### Field Table (Satztabelle)

| FK | Occ | Field Name | Type | Condition | Notes |
|----|-----|-----------|------|-----------|-------|
| 8000 | 1 | Record type (Satzart) | M | | Record type "sad3" |
| 3005 | 1 | SA identifier (Kennziffer SA) | M | | |
| 4101 | 1 | Quarter (Quartal) | M | | Quarter of the treatment case, QJJJJ |
| 4104 | 1 | Billing VKNR (Abrechnungs-VKNR) | M | | |
| 4111 | 1 | Cost carrier identifier (Kostentraegerkennung) | M | | Concatenation ('10', positions 9-15 from FK 3005) |
| 5000 | n | Service date (Leistungstag) | M | | Date of the rendered service |
| 5001 | n | Fee schedule number (GNR) | m | | Fee schedule number, see Section 4.5.1 |
| 5009 | n | Free-text justification (freier Begrundungstext) | k | | |
| 5012 | n | Material costs in cents (Sachkosten/Materialkosten in Cent) | k | | |
| 5011 | n | Material cost description (Sachkosten-Bezeichnung) | m | | |
| 5076 | 1 | Invoice number (Rechnungsnummer) | k | | |
| 5098 | 1 | (N)BSNR of service location ((N)BSNR des Ortes der Leistungserbringung) | M | Regel 732 | |
| 5099 | 1 | Lifetime physician number (LANR) of contracted physician/psychotherapist (Lebenslange Arztnummer (LANR) des Vertragsarztes/Vertragspsychotherapeuten) | M | Regel 733 | |
