## US-VSST518 — The Vertragssoftware must allow transmission of prescription data for prescriptions...

| Field | Value |
|-------|-------|
| **ID** | US-VSST518 |
| **Traced from** | [VSST518](../compliances/SV/VSST518.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | VOD, VTG |

### User Story

As a practice staff, I want the Vertragssoftware allow transmission of prescription data for prescriptions whose documentation date precedes the contract-specific transmission start date, provided the prescriptions were documented after the contract-specific Verordnungsdaten documentation start date, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given Verordnungen documented after the contract documentation start date but before the transmission start date, when transmission is triggered, then those prescriptions are included

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/billing`, `api/pvs_billing`, `api/contract`

1. **Date-based filtering** -- The `billing` and `pvs_billing` packages support date-range filtering for billing data. Contract-specific dates are managed in the `contract` package.
2. **Gap: GueltigAbReferenzdatum enforcement** -- While the contract package stores contract definitions with dates, the specific enforcement of including Verordnungen documented after the contract documentation start date but before the transmission start date requires verification against Selektivvertragsdefinition metadata.
