## sad1 -- SADT Ambulatory Treatment

| Field | Value |
|-------|-------|
| **Satzart** | sad1 |
| **German Name** | SADT-ambulante Behandlung |
| **Source** | KVDT-DSB v6.02 |
| **Section** | 5.4.3 |
| **Data Package** | SADT |
| **Refer** | [sad0](sad0.md), [sad9](sad9.md), [sad2](sad2.md), [sad3](sad3.md), [sadt-feldtabelle](sadt-feldtabelle.md), [sadt-regeltabelle](sadt-regeltabelle.md) |

### Purpose

Record type for ambulatory treatment billing within the SADT data package. Contains treatment case identification, service data with fee schedule numbers, material costs, and service location identifiers.

### Field Table (Satztabelle)

| FK | Occ | Field Name | Type | Condition | Notes |
|----|-----|-----------|------|-----------|-------|
| 8000 | 1 | Record type (Satzart) | M | | Record type "sad1" |
| 3005 | 1 | SA identifier (Kennziffer SA) | M | | |
| 4101 | 1 | Quarter (Quartal) | M | | Quarter of the treatment case, QJJJJ |
| 4104 | 1 | Billing VKNR (Abrechnungs-VKNR) | M | | |
| 4111 | 1 | Cost carrier identifier (Kostentraegerkennung) | M | | Concatenation ('10', positions 9-15 from FK 3005) (footnote: CONCAT method) |
| 5000 | n | Service date (Leistungstag) | M | | Date of the rendered service |
| 5001 | n | Fee schedule number (GNR) | m | | Fee schedule number, see Section 4.5.1 |
| 5009 | n | Free-text justification (freier Begrundungstext) | k | | |
| 5012 | n | Material costs in cents (Sachkosten/Materialkosten in Cent) | k | | |
| 5011 | n | Material cost description (Sachkosten-Bezeichnung) | m | | |
| 5076 | 1 | Invoice number (Rechnungsnummer) | k | | |
| 5098 | 1 | (N)BSNR of service location ((N)BSNR des Ortes der Leistungserbringung) | M | Regel 732 | |
| 5099 | 1 | Lifetime physician number (LANR) of contracted physician/psychotherapist (Lebenslange Arztnummer (LANR) des Vertragsarztes/Vertragspsychotherapeuten) | M | Regel 733 | |
