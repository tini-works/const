## US-VSST523 — arriba invocation

| Field | Value |
|-------|-------|
| **ID** | US-VSST523 |
| **Traced from** | [VSST523](../compliances/SV/VSST523.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want arriba invocation, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given arriba integration, when invoked with patient context, then arriba launches with the correct patient data

### Actual Acceptance Criteria

**Implementation Status:** Implemented

**Relevant Codebase Packages:** `api/arriba`, `service/arriba`

1. **arriba invocation with patient context** -- The `ArribaApp` interface provides `StartArriba(request *StartArribaRequest)` accepting a `PatientID`. The service launches arriba with the correct patient data context.
2. **Session management** -- `UpdateArribaSessions` and `RemoveArriba` methods handle arriba session lifecycle.
3. **Event notification** -- `EventStartArribaApp` notifies the client of launch success/failure.
