# PM Inventory — Auth Library Migration (JWT v1 → v2)

**Mandate:** Security team requires JWT v2 adoption. 30-day deadline.
**Customer:** Downstream service teams (A, B, C, D). Promise: "we won't break your service."

## Requirements

| ID | Requirement | Source | Status |
|----|-------------|--------|--------|
| REQ-301 | Backward-compatible migration window (dual-mode validation) | Security mandate + downstream safety | PROVEN |
| REQ-302 | No code changes required by consuming services beyond version bump | Downstream team expectation | PROVEN |
| REQ-303 | Per-service rollback via config flag (no redeploy) | Risk mitigation | PROVEN |
| REQ-304 | Per-service opt-in for v2 token issuance | Engineering recommendation | PROVEN |
| REQ-305 | 30-day grace period for in-flight v1 tokens | Engineering recommendation | PROVEN |
| REQ-306 | Post-grace: all v1 tokens rejected, keys decommissioned | Security mandate | PROVEN |
| REQ-307 | Service D test suite repair | **Discovered during migration** | Filed to Service D backlog |

## Contracts with Downstream Teams

| Service | Agreed | Delivered |
|---------|--------|-----------|
| Service A | Zero downtime, opt-in when ready | Opted in day 3 |
| Service B | Grace period covers late adoption | Running on grace, verified day 5 |
| Service C | Same as A | Opted in day 20 |
| Service D | Same as A | **Blocked by pre-existing broken tests** — fixed day 22 |

## REQ-307: The Service D Story

Migration didn't break Service D. Service D was already broken. The migration's re-verification step forced Service D to run their test suite, which exposed pre-existing test rot. PM filed this to Service D's backlog — it's their debt, not our defect. Migration continued after they fixed it.
