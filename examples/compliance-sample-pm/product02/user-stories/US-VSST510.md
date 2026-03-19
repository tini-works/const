## US-VSST510 — In addition to KBV AVWG function P2-130, the Vertragssoftware must...

| Field | Value |
|-------|-------|
| **ID** | US-VSST510 |
| **Traced from** | [VSST510](../compliances/SV/VSST510.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want in addition to KBV AVWG function P2-130, the Vertragssoftware is capable of performing regular medication database updates at least every 14 days, but no less than quarterly, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given the medication database, when an update cycle runs, then updates are applied at least every 14 days or quarterly at minimum

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/medicine`, `api/medicine_kbv`, `api/etl`

1. **Medication database integration** -- The `medicine` and `medicine_kbv` API packages provide full medication catalog access with search, lookup, and KBV-compliant data structures.
2. **Catalog update mechanism** -- The `medicine` service in `backend-core/service/medicine/` provides medication data management. The system supports catalog imports via ETL (`backend-core/service/etl/`).
3. **Gap: Automated 14-day update cycle** -- While medication data can be imported, the automated scheduling of updates every 14 days (or quarterly minimum) is a deployment/operations concern. The AVWG P2-130 update frequency enforcement is not verified as an automated scheduled task within the codebase.
