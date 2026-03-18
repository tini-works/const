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

### User Story

As a practice staff, I want the Vertragssoftware support retroactive transmission of prescription data from the GueltigAbReferenzdatum specified in the Selektivvertragsdefinition's UebermittlungVerordnungsdaten metadata element; if a GueltigBisReferenzdatum is specified, retroactive transmission not exceed that date, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given prescription data, when retroactive transmission is triggered, then data from the GueltigAbReferenzdatum is included
2. Given a GueltigBisReferenzdatum, then data beyond that date is excluded
