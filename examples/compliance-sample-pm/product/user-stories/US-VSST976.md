## US-VSST976 — After successful real-data transmission of prescription data, the Vertragssoftware must...

| Field | Value |
|-------|-------|
| **ID** | US-VSST976 |
| **Traced from** | [VSST976](../compliances/SV/VSST976.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | VOD, UBS |

### User Story

As a practice staff, I want after successful real-data transmission of prescription data, the Vertragssoftware display the count of successfully transmitted prescriptions; test transmissions not show counts; deleted prescriptions is excluded from the count, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given successful real-data prescription transmission, when complete, then the count of transmitted prescriptions is shown
2. Given test transmission, then count is not shown
3. Given deleted prescriptions, then they are excluded from the count

### Actual Acceptance Criteria

**Implementation Status:** Not Yet Implemented

**Relevant Codebase Packages:** `api/billing`, `api/pvs_billing`

1. **Billing transmission** -- The `billing` and `pvs_billing` packages handle data transmission.
2. **Gap: Transmission count display** -- The specific display of transmitted prescription count after real-data transmission, exclusion of deleted prescriptions, and suppression of count for test transmissions is not verified.
