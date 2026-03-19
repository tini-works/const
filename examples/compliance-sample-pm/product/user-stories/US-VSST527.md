## US-VSST527 — KBV AVWG prescription catalog must be enforced

| Field | Value |
|-------|-------|
| **ID** | US-VSST527 |
| **Traced from** | [VSST527](../compliances/SV/VSST527.md) |
| **Source** | AKA Q1-26-1, KBV AVWG |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | VOD, MED, KAT |

### User Story

As a practice staff, I want kBV AVWG prescription catalog is enforced, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a Verordnung, when a drug is prescribed, then AVWG catalog rules are enforced and violations are flagged

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/medicine_kbv`, `api/medicine`, `api/coding_rule`, `api/catalog_sdebm`

1. **Medication catalog integration** -- The `medicine_kbv` package implements KBV-compliant medication rules. The `catalog_sdebm` and medication catalogs provide drug reference data.
2. **AVWG rule enforcement** -- The `medicine` service handles prescription validation. The `coding_rule` package provides rule-based validation.
3. **Gap: Full AVWG catalog enforcement** -- While KBV medication rules are integrated, the specific AVWG prescription catalog enforcement (P2-130 and related) needs verification for completeness against all catalog rules.
