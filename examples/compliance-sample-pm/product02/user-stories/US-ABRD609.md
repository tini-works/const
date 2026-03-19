## US-ABRD609 — Permanent diagnoses must be carried over between quarters

| Field | Value |
|-------|-------|
| **ID** | US-ABRD609 |
| **Traced from** | [ABRD609](../compliances/SV/ABRD609.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want permanent diagnoses is carried over between quarters, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given Dauerdiagnosen from previous Quartal, when a new Quartal begins, then all Dauerdiagnosen are automatically carried forward

### Actual Acceptance Criteria

1. The timeline service supports quarter grouping for diagnoses and carry-over for permanent diagnoses (Dauerdiagnosen).
2. The `schein.TakeOverScheinDiagnosis` handles diagnosis carry-over between scheins/quarters.
