## US-ALLG657 — System must manage a HÄVG-ID per physician (lifelong, person-specific number)

| Field | Value |
|-------|-------|
| **ID** | US-ALLG657 |
| **Traced from** | [ALLG657](../compliances/SV/ALLG657.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E6: General & Documentation](../epics/E6-general-and-documentation.md) |
| **Data Entity** | ARZ |

### User Story

As a practice owner, I want manage a HÄVG-ID per physician (lifelong, person-specific number), so that general compliance requirements are met.

### Acceptance Criteria

1. Given an Arzt record, when HÄVG-ID is entered, then it is persisted as a lifelong person-specific identifier

### Actual Acceptance Criteria

| Status | **Not Implemented** |
|--------|-------------------|

1. No HAVG-ID field was found in the physician/employee data models in `backend-core/service/domains/repos/profile/employee/`.
2. The employee data model contains fields for BSNR, LANR, and other identifiers, but no dedicated HAVG-ID (lifelong, person-specific number) field exists.
3. **Gap**: The system cannot store or manage a HAVG-ID per physician as required.
