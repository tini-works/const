## US-VSST622 — The Vertragssoftware must provide a function to confirm the currency...

| Field | Value |
|-------|-------|
| **ID** | US-VSST622 |
| **Traced from** | [VSST622](../compliances/SV/VSST622.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want the Vertragssoftware provide a function to confirm the currency of employment status/type; the confirmation date is stored in the 'Datum letzte Ueberpruefung' field, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given the employment data confirmation function, when the user confirms currency, then the current date is stored in 'Datum letzte Ueberpruefung'

### Actual Acceptance Criteria

**Implementation Status:** Not Yet Implemented

**Relevant Codebase Packages:** `api/patient_profile`

1. **Patient profile** -- The `patient_profile` package provides data management.
2. **Gap: Employment confirmation with timestamp** -- The specific 'Datum letzte Ueberpruefung' field and the confirmation function for employment data currency are not verified in the patient profile data model.
