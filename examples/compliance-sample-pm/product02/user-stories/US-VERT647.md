## US-VERT647 — System must block services/diagnoses documented outside the patient's contract activation...

| Field | Value |
|-------|-------|
| **ID** | US-VERT647 |
| **Traced from** | [VERT647](../compliances/SV/VERT647.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want block services/diagnoses documented outside the patient's contract activation window, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a Leistung dated outside the Teilnahme-Aktivierungsfenster, when saved, then the system blocks with a date-range error


### Actual Acceptance Criteria

**Status: Not Implemented**

1. **Not met.** No evidence of date-range validation logic that blocks services/diagnoses documented outside the patient's contract activation window (Teilnahme-Aktivierungsfenster). The Schein and billing services do not contain explicit activation-window enforcement.
