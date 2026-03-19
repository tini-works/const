## US-VSST623 — The Vertragssoftware must integrate the Hilfsmittelkatalog provided via AKA-Basisdatei to...

| Field | Value |
|-------|-------|
| **ID** | US-VSST623 |
| **Traced from** | [VSST623](../compliances/SV/VSST623.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want the Vertragssoftware integrate the Hilfsmittelkatalog provided via AKA-Basisdatei to assist with medical device selection; if the software has its own catalog, it may be used provided the described functions are implemented, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given the AKA Hilfsmittelkatalog, when the system loads, then the catalog is available for Hilfsmittel selection with the specified search and display functions

### Actual Acceptance Criteria

**Implementation Status:** Implemented

**Relevant Codebase Packages:** `api/himi`, `service/himi`

1. **Hilfsmittelkatalog integration** -- The `himi` API package implements comprehensive Hilfsmittel catalog functionality with the `SearchGruppe`, `SearchOrt`, `SearchArt`, `SearchOrtByGruppe`, `SearchUnterByGruppeOrt`, `SearchProductByBaseAndArt`, and `SearchHimiMatchingTable` methods.
2. **HIMI service** -- The `backend-core/service/himi/` domain service provides the Hilfsmittel catalog data backend.
3. **Prescription support** -- `Prescribe` and `GetPrescribe` methods handle Hilfsmittel prescriptions with print support.
