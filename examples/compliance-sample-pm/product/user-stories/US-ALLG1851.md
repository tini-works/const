## US-ALLG1851 — If physician has HÄVG-ID but no GP VP-ID, system must...

| Field | Value |
|-------|-------|
| **ID** | US-ALLG1851 |
| **Traced from** | [ALLG1851](../compliances/SV/ALLG1851.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want if physician has HÄVG-ID but no GP VP-ID, system retrieve it via HPM endpoint, so that general compliance requirements are met.

### Acceptance Criteria

1. Given an Arzt with HÄVG-ID but no GP VP-ID, when triggered, then the system retrieves the VP-ID via HPM

### Actual Acceptance Criteria

| Status | **Not Implemented** |
|--------|-------------------|

1. The HPM REST client at `backend-core/pkg/hpm_rest/` and `backend-core/pkg/hpm_service/` provides endpoints for various HPM operations, but no specific VP-ID retrieval endpoint was found.
2. No logic exists to detect a physician with HAVG-ID but missing GP VP-ID and trigger automatic retrieval via HPM.
3. **Gap**: The system does not automatically retrieve a GP VP-ID via HPM when a physician has a HAVG-ID but no VP-ID.
