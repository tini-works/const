## VERT791 — Module contract prerequisite — main contract must be active before...

| Field | Value |
|-------|-------|
| **ID** | VERT791 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.3 VERT — Contract Participation |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Integration test (API) |
| Matched by | [US-VERT791](../../user-stories/US-VERT791.md) |

### Requirement

Module contract prerequisite — main contract must be active before module contracts can be used

### Acceptance Criteria

1. Given a Modulvertrag, when the Hauptvertrag is not active, then module contract activation is blocked
