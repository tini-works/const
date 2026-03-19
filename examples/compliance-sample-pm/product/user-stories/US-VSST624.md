## US-VSST624 — The Vertragssoftware must support Hilfsmittel searches by: product search, application...

| Field | Value |
|-------|-------|
| **ID** | US-VSST624 |
| **Traced from** | [VSST624](../compliances/SV/VSST624.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want the Vertragssoftware support Hilfsmittel searches by: product search, application location, subgroup, product type, manufacturer, product name, and keyword (THESAURUS); catalog search is the preferred path, with direct entry not shown as equivalent, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a Hilfsmittel search, when the user enters search criteria (product, application location, subgroup, type, manufacturer, name, keyword), then matching results are returned
2. Given the UI, then catalog search is the primary path, not direct entry

### Actual Acceptance Criteria

**Implementation Status:** Implemented

**Relevant Codebase Packages:** `api/himi`

1. **Multi-criteria search** -- The `HimiApp` interface provides: `SearchGruppe` (product group), `SearchOrt` (application location), `SearchArt` with types THESAURUS/PRODUCT_GROUP/LOCATION/PRODUCT_TYPE/MANUFACTURER, `SearchOrtByGruppe`, `SearchUnterByGruppeOrt` (subgroup), and `SearchProductByBaseAndArt`.
2. **Search type enum** -- `SearchArtType` supports THESAURUS, PRODUCT_GROUP, LOCATION, PRODUCT_TYPE, MANUFACTURER covering all required search criteria.
3. **Catalog-first workflow** -- The search API structure prioritizes catalog-based search over direct entry.
