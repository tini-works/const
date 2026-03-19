## VERT686 — Contract-specific features must be gated by contract support

| Field | Value |
|-------|-------|
| **ID** | VERT686 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.3 VERT — Contract Participation |
| **Status** | TBC |
| **Goals** | BG-1a, BG-3 |
| **Verification Method** | Integration test (API) |
| Matched by | [US-VERT686](../../user-stories/US-VERT686.md) |

### Requirement

Contract-specific features must be gated by contract support

### Acceptance Criteria

1. Given a Vertrag not supporting a specific feature, when the user attempts to use it, then access is blocked
