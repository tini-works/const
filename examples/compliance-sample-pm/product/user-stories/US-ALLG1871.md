## US-ALLG1871 — Participation return data must be displayable for HZV contracts (informational...

| Field | Value |
|-------|-------|
| **ID** | US-ALLG1871 |
| **Traced from** | [ALLG1871](../compliances/SV/ALLG1871.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E6: General & Documentation](../epics/E6-general-and-documentation.md) |
| **Data Entity** | TE, VTG |

### User Story

As a practice owner, I want participation return data is displayable for HZV contracts (informational only), so that general compliance requirements are met.

### Acceptance Criteria

1. Given HZV-Teilnahme return data, when received, then the data is displayed to the user as informational content

### Actual Acceptance Criteria

| Status | **Partially Implemented** |
|--------|--------------------------|

1. Patient participation (Teilnahme) functionality exists at `backend-core/service/domains/internal/patient_participation/service.go` with a comprehensive `Service` that handles enrollment, HPM communication, and contract lookups.
2. Doctor participation is managed via `backend-core/service/domains/internal/doctor_participate/`.
3. The system handles participation data exchange with HPM via REST calls.
4. **Gap**: There is no dedicated display of HZV participation return data as informational content. The participation service handles enrollment workflows but does not specifically expose a read-only informational view of return data for HZV contracts.
