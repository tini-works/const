## US-ALLG1018 — Software modules must only be distributed when they fulfill all...

| Field | Value |
|-------|-------|
| **ID** | US-ALLG1018 |
| **Traced from** | [ALLG1018](../compliances/SV/ALLG1018.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E6: General & Documentation](../epics/E6-general-and-documentation.md) |
| **Data Entity** | PVS, KAT |

### User Story

As a practice owner, I want software modules only be distributed when they fulfill all contract-specific AKA requirements, so that general compliance requirements are met.

### Acceptance Criteria

1. Given a software module for distribution, when AKA requirements are checked, then distribution is blocked if any requirement is unmet

### Actual Acceptance Criteria

| Status | **Not Implemented** |
|--------|-------------------|

1. This is a release process/distribution policy requirement, not a runtime code feature.
2. No automated AKA requirement verification gate was found in the build or release pipeline.
3. **Gap**: A formal process or automated check must be established to verify all contract-specific AKA requirements are met before software module distribution.
