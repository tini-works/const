# PM Inventory — 003 Auth Library Migration

**Source:** Security mandate — JWT v1 → v2, 30-day deadline.

**Customer:** Downstream service teams — "I don't want my service to break."

## Requirements

| ID | Requirement | External source | Downstream match | Status |
|----|-------------|----------------|-----------------|--------|
| REQ-301 | Backward-compatible migration window | Security mandate + team safety | Engineer → FLW-30, FLW-32 | PROVEN |
| REQ-302 | No code changes beyond version bump | Downstream team expectation | Engineer → API unchanged | PROVEN |
| REQ-303 | Per-service rollback capability | Risk mitigation | Engineer → FLW-31, DevOps → DEP-32 | PROVEN |
| REQ-304 | Dual-mode validation window | Engineer discovery | Engineer → FLW-30 | PROVEN |
| REQ-305 | Per-service opt-in for v2 issuance | Engineer discovery | Engineer → FLW-31 | PROVEN |
| REQ-306 | 30-day v1 token grace period | Engineer discovery | Engineer → FLW-32 | PROVEN (archived) |
| REQ-307 | Service D test suite repair | Discovered during migration | Service D backlog | Filed |

## Boxes

| Box | Direction | Content | Status |
|-----|-----------|---------|--------|
| B1 | PM → Engineer | Backward compat during transition | PROVEN |
| B2 | PM → Engineer | No consumer code changes | PROVEN |
| B3 | PM → Engineer | Per-service rollback | PROVEN |
| B4 | Engineer → PM | Dual-mode validation (v2 try, v1 fallback) | PROVEN |
| B5 | Engineer → PM | Per-service opt-in for v2 issuance | PROVEN |
| B6 | Engineer → PM | v1 valid for 30 days | PROVEN (archived) |

## Observations

- REQ-307 is a bonus finding. The migration didn't cause Service D's failure — it exposed pre-existing rot. PM's inventory grew because sanity reconciliation surfaced something already broken.
- "Who is the customer?" matters. Here it's downstream teams, not end users. PM still faces outward — the "outside" is just other teams in this case.
