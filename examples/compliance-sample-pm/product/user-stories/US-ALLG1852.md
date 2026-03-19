## US-ALLG1852 — If physician has MEDIVERBUND-ID but no specialist VP-ID, system must...

| Field | Value |
|-------|-------|
| **ID** | US-ALLG1852 |
| **Traced from** | [ALLG1852](../compliances/SV/ALLG1852.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E6: General & Documentation](../epics/E6-general-and-documentation.md) |
| **Data Entity** | ARZ, PM |

### User Story

As a practice owner, I want if physician has MEDIVERBUND-ID but no specialist VP-ID, system retrieve it via HPM, so that general compliance requirements are met.

### Acceptance Criteria

1. Given an Arzt with MEDIVERBUND-ID but no specialist VP-ID, when triggered, then the system retrieves it via HPM

### Actual Acceptance Criteria

| Status | **Not Implemented** |
|--------|-------------------|

1. Similar to US-ALLG1851, no VP-ID retrieval logic for specialists with MEDIVERBUND-ID was found.
2. No HPM endpoint call exists to retrieve specialist VP-ID based on MEDIVERBUND-ID.
3. **Gap**: The system does not automatically retrieve a specialist VP-ID via HPM when a physician has a MEDIVERBUND-ID but no VP-ID.
