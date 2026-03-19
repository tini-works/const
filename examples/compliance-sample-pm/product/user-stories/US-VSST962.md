## US-VSST962 — The Hilfsmittelkatalog and catalog searches must be strictly sorted by...

| Field | Value |
|-------|-------|
| **ID** | US-VSST962 |
| **Traced from** | [VSST962](../compliances/SV/VSST962.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | VOD, KAT |

### User Story

As a practice staff, I want the Hilfsmittelkatalog and catalog searches is strictly sorted by Produktgruppe, Anwendungsort, Untergruppe, Produktart, including when using a custom catalog, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given the Hilfsmittelkatalog, when a search is performed, then results are sorted strictly by Produktgruppe, Anwendungsort, Untergruppe, Produktart

### Actual Acceptance Criteria

**Implementation Status:** Implemented

**Relevant Codebase Packages:** `api/himi`

1. **Hierarchical catalog structure** -- The `himi` API provides searches organized by Produktgruppe (SearchGruppe), Anwendungsort (SearchOrt/SearchOrtByGruppe), Untergruppe (SearchUnterByGruppeOrt), and Produktart (SearchArt/SearchProductByBaseAndArt).
2. **Structured navigation** -- The `BaseHimiSearch` struct with Gruppe/Ort/Unter fields enforces the hierarchical sort order in catalog navigation.
