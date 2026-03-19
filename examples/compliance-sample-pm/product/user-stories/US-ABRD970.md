## US-ABRD970 — Care facility name and location must be required for home...

| Field | Value |
|-------|-------|
| **ID** | US-ABRD970 |
| **Traced from** | [ABRD970](../compliances/SV/ABRD970.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E1: Billing Documentation](../epics/E1-billing-documentation.md) |
| **Data Entity** | SVC, BST |

### User Story

As a practice doctor, I want care facility name and location is required for home visit services, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Hausbesuch-Leistung, when facility name/location is missing, then validation blocks submission

### Actual Acceptance Criteria

1. Implemented -- `ABRD970Validator` checks CareFacility Name and Ort with test coverage.
2. Part of the billing validation pipeline.
