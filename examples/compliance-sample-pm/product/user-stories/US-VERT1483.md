## US-VERT1483 — Conflicts in patient master data must be flagged

| Field | Value |
|-------|-------|
| **ID** | US-VERT1483 |
| **Traced from** | [VERT1483](../compliances/SV/VERT1483.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | PAT, STD, EGK |

### User Story

As a practice owner, I want conflicts in patient master data is flagged, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given Stammdaten conflicts between eGK and PVS, when detected, then the user is alerted with a conflict resolution prompt


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** The `ParticipantClassifier` in `participant_classifier.go` categorizes participants into `AutoImport`, `Conflict`, `Missing`, and `SameEgk` groups. Conflicts (including Stammdaten mismatches between eGK/PVS data and HPM data) are flagged for user resolution during the PTV import flow.
