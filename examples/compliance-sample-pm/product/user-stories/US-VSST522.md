## US-VSST522 — arriba target path

| Field | Value |
|-------|-------|
| **ID** | US-VSST522 |
| **Traced from** | [VSST522](../compliances/SV/VSST522.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | ARR, PVS |

### User Story

As a practice staff, I want arriba target path, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given arriba integration configured, when the user triggers arriba, then the correct target path is resolved and opened

### Actual Acceptance Criteria

**Implementation Status:** Implemented

**Relevant Codebase Packages:** `api/arriba`, `service/arriba`

1. **arriba target path resolution** -- The `arriba` API package (`backend-core/app/app-core/api/arriba/`) implements `StartArriba` with patient context. The `backend-core/service/arriba/` service contains the arriba CLI integration (`arribadoc-cli-arriba-lib-3.12.0`) with path configuration.
2. **Configuration management** -- The arriba service includes `arriba.go` and `arriba_service.go` with path builder logic in `builder.go`.
