## US-VERT1876 — Standard import rules must be applied during data synchronization

| Field | Value |
|-------|-------|
| **ID** | US-VERT1876 |
| **Traced from** | [VERT1876](../compliances/SV/VERT1876.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want standard import rules is applied during data synchronization, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a Datensynchronisation, when import runs, then standard import rules are applied to all incoming records


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** The PTV import service in `service.go` applies standard import rules during data synchronization. The `ParticipantClassifier.Classify` method applies classification rules (auto-import, conflict, missing, same-eGK) to all incoming records. `ImportParticipants` processes them according to these rules.
