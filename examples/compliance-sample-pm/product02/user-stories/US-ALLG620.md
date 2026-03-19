## US-ALLG620 — Audit module communication must work

| Field | Value |
|-------|-------|
| **ID** | US-ALLG620 |
| **Traced from** | [ALLG620](../compliances/SV/ALLG620.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want audit module communication work, so that general compliance requirements are met.

### Acceptance Criteria

1. Given the Prüfmodul integration, when triggered, then communication between PVS and Prüfmodul succeeds

### Actual Acceptance Criteria

| Status | **Not Implemented** |
|--------|-------------------|

1. There is no standalone Prufmodul integration or communication layer in the codebase.
2. The system communicates with HPM (HAVG-Prufmodul) via REST calls in `backend-core/pkg/hpm_rest/` and `backend-core/pkg/hpm_service/`, but these are for HPM-specific operations (version info, enrollment, billing), not a generic Prufmodul communication interface.
3. **Gap**: No dedicated Prufmodul communication protocol or handshake mechanism exists as described by the compliance requirement.
