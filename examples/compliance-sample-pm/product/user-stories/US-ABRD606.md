## US-ABRD606 — Service lookup must filter by IK assignment

| Field | Value |
|-------|-------|
| **ID** | US-ABRD606 |
| **Traced from** | [ABRD606](../compliances/SV/ABRD606.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E1: Billing Documentation](../epics/E1-billing-documentation.md) |
| **Data Entity** | SVC, PAT |

### User Story

As a practice doctor, I want service lookup filter by IK assignment, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Patient with a specific IK-Zuordnung, when the user searches Leistungen, then only services matching that IK are shown

### Actual Acceptance Criteria

1. The `billing.GetBillableEncounters` retrieves encounters filtered by patient and contract context including IK-based assignment.
2. The timeline service supports filtering by patient insurance context.
3. The `billing.GetContractTypeByIds` provides contract metadata including IK assignment.
