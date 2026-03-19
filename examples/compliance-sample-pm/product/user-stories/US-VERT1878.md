## US-VERT1878 — During a full import (Vollimport), all data from the PTV...

| Field | Value |
|-------|-------|
| **ID** | US-VERT1878 |
| **Traced from** | [VERT1878](../compliances/SV/VERT1878.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice owner, I want during a full import (Vollimport), all data from the PTV is automatically transferred to the Vertragssoftware if the patient can be uniquely matched by eGK-Nummer; defined exception cases (unmatched eGK, status conflicts) is handled separately with user prompts, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a Vollimport with patient data, when patients match by eGK-Nummer, then data is auto-transferred
2. Given an exception case (no eGK match, status conflict), then the system prompts the user for manual resolution


### Actual Acceptance Criteria

**Status: Implemented**

1. **Met.** The `ImportParticipants` function handles auto-transfer for patients matched by eGK-Nummer (via `SameEgk` classification in `ParticipantClassifier`). The `AutoImport` category handles automatic transfers.
2. **Met.** Exception cases (unmatched eGK in `Missing`, status conflicts in `Conflict`) are classified separately and saved for user resolution via `SaveClassifiedParticipants`. The import can complete with `isPending=true` when conflicts remain unresolved.
