## US-VERT1484 — Validation must run before PTV import

| Field | Value |
|-------|-------|
| **ID** | US-VERT1484 |
| **Traced from** | [VERT1484](../compliances/SV/VERT1484.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | TNV, PAT |

### User Story

As a practice owner, I want validation run before PTV import, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a PTV-Import, when initiated, then validation runs first and blocks import if errors are found


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** `GetParticipantsByDoctor` runs validation before import: it checks for quarter ordering (`ErrorCode_PTV_Import_Older_Than_Latest` blocks import of older quarters), cross-references doctor contracts, and classifies participants (conflicts, missing, auto-import). `ImportParticipants` only proceeds after classification.
