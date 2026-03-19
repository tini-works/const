## VERT647 — System must block services/diagnoses documented outside the patient's contract activation...

| Field | Value |
|-------|-------|
| **ID** | VERT647 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.3 VERT — Contract Participation |
| **Status** | TBC |
| **Goals** | BG-1a, BG-2 |
| **Verification Method** | Integration test (API) |
| Matched by | [US-VERT647](../../user-stories/US-VERT647.md) |

### Requirement

System must block services/diagnoses documented outside the patient's contract activation window

### Acceptance Criteria

1. Given a Leistung dated outside the Teilnahme-Aktivierungsfenster, when saved, then the system blocks with a date-range error
