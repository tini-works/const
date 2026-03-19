## US-VERT1481 — ICode must be enterable and saveable

| Field | Value |
|-------|-------|
| **ID** | US-VERT1481 |
| **Traced from** | [VERT1481](../compliances/SV/VERT1481.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want iCode is enterable and saveable, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a Teilnahmevorgang, when the user enters an ICode, then the value is persisted and associated with the participation record


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** ICode (RetrievalCode) is enterable and persisted in the PTV import flow. `GetCodePtvByDoctor` retrieves the stored ICode. `createPtvImport` stores `RetrievalCode` in the `PtvImport` record. The `GetPtvContractByDoctorRequest` accepts `Code` (ICode) as input.
