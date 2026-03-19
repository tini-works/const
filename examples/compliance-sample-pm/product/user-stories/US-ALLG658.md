## US-ALLG658 — For FaV, system must manage a MEDIVERBUND-ID per physician (8-digit...

| Field | Value |
|-------|-------|
| **ID** | US-ALLG658 |
| **Traced from** | [ALLG658](../compliances/SV/ALLG658.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E6: General & Documentation](../epics/E6-general-and-documentation.md) |
| **Data Entity** | ARZ |

### User Story

As a practice owner, I want for FaV, system manage a MEDIVERBUND-ID per physician (8-digit numeric), so that general compliance requirements are met.

### Acceptance Criteria

1. Given a FaV-Arzt record, when MEDIVERBUND-ID is entered, then the 8-digit numeric ID is persisted

### Actual Acceptance Criteria

| Status | **Not Implemented** |
|--------|-------------------|

1. No MEDIVERBUND-ID field was found in the physician/employee data models.
2. The codebase references MEDIVERBUND only in AKA XML contract definitions and test data CSV files, not as a managed physician identifier.
3. **Gap**: The system does not store or manage an 8-digit numeric MEDIVERBUND-ID per physician for FaV contracts.
