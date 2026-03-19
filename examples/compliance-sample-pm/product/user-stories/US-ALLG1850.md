## US-ALLG1850 — System must manage VP-ID types per physician (GP "H", specialist...

| Field | Value |
|-------|-------|
| **ID** | US-ALLG1850 |
| **Traced from** | [ALLG1850](../compliances/SV/ALLG1850.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want manage VP-ID types per physician (GP "H", specialist "F", care team "B"), so that general compliance requirements are met.

### Acceptance Criteria

1. Given an Arzt record, when VP-ID is assigned, then the correct type (H/F/B) is stored per physician role

### Actual Acceptance Criteria

| Status | **Not Implemented** |
|--------|-------------------|

1. No VP-ID fields (types H for GP, F for specialist, B for care team) were found in the physician/employee data models.
2. The employee data model in `backend-core/service/domains/repos/profile/employee/` does not contain VP-ID type management.
3. **Gap**: The system cannot store or manage VP-ID types per physician as required.
