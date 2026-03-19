## US-VSST1548 — The Vertragssoftware must support retroactive transmission of prescription data from...

| Field | Value |
|-------|-------|
| **ID** | US-VSST1548 |
| **Traced from** | [VSST1548](../compliances/SV/VSST1548.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | VOD, VTG |

### User Story

As a practice staff, I want the Vertragssoftware support retroactive transmission of prescription data from the GueltigAbReferenzdatum specified in the Selektivvertragsdefinition's UebermittlungVerordnungsdaten metadata element; if a GueltigBisReferenzdatum is specified, retroactive transmission not exceed that date, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given prescription data, when retroactive transmission is triggered, then data from the GueltigAbReferenzdatum is included
2. Given a GueltigBisReferenzdatum, then data beyond that date is excluded

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/contract`, `api/billing`, `api/pvs_billing`

1. **Contract metadata** -- The `contract` package manages Selektivvertragsdefinition including date-range metadata.
2. **Billing date filtering** -- The `billing` and `pvs_billing` packages support date-range-based billing processing.
3. **Gap: GueltigAbReferenzdatum / GueltigBisReferenzdatum enforcement** -- The specific enforcement of retroactive transmission boundaries using GueltigAbReferenzdatum and GueltigBisReferenzdatum from the UebermittlungVerordnungsdaten metadata element needs verification.
