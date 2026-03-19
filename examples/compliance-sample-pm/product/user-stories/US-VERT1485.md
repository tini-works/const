## US-VERT1485 — PTV import must be supported

| Field | Value |
|-------|-------|
| **ID** | US-VERT1485 |
| **Traced from** | [VERT1485](../compliances/SV/VERT1485.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want pTV import is supported, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a valid PTV file, when import is triggered, then all participation records are imported and persisted


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** `ImportParticipants` processes classified participants: auto-imports matched patients, handles conflicts with user prompts, and persists all imported records. The import tracker (`ImportHistoryTracker`) manages the full import lifecycle with status tracking.
