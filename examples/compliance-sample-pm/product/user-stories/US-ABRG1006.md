## US-ABRG1006 — System must show hint about KV services when patient has...

| Field | Value |
|-------|-------|
| **ID** | US-ABRG1006 |
| **Traced from** | [ABRG1006](../compliances/SV/ABRG1006.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want show hint about KV services when patient has contract participation, so that billing submissions are accepted without rejection.

### Acceptance Criteria

1. Given a Patient with Selektivvertrag-Teilnahme, when KV-Leistungen are documented, then a hint about contract participation is shown

### Actual Acceptance Criteria

1. Partially implemented. The timeline validation system includes validators for both KV (`service_code/kv/`) and SV (`service_code/sv/`) tracks. The `PreParticipationValidator` in `backend-core/service/timeline_validation/service/validation_timeline/validations/service_code/sv/preparticipation.validator.go` checks contract participation. A specific hint shown when KV services are documented for a patient with active contract participation was not explicitly found but may be covered by the KV precondition validators.
