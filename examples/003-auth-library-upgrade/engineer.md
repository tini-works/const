# Engineer Inventory — 003 Auth Library Migration

**Boxes to match:** B1 (backward compat), B2 (no code changes), B3 (rollback), B4 (dual-mode), B5 (opt-in issuance), B6 (grace period)

## Flows

| ID | Flow | Matches | Post-grace state |
|----|------|---------|-----------------|
| FLW-30 | Token validation: try v2 → fallback v1 → reject | B1, B4 | Updated: v2 only |
| FLW-31 | Token issuance: check service config → v2 if opted-in, else v1 | B3, B5 | Updated: v2 only |
| FLW-32 | Grace period: v1 tokens valid 30 days post-migration-start | B1, B6 | Archived |

## System Design

| Item | Migration state | Post-grace state |
|------|----------------|-----------------|
| Auth library | v2.0 — dual-mode validator | v2.1 — v2-only, v1 code removed |
| Service config flag | `auth.token_version = v1 \| v2` | Deprecated (always v2) |
| v1 signing key | Retained for grace period | Decommissioned |

## Transition Mechanic

When the library was published, every dependent service was flagged SUSPECT automatically. No spreadsheet, no Slack. Inventory dependency tracking propagated the change.

Each service re-verified independently:
- Service A: day 3 (opted into v2)
- Service B: day 5 (stayed on v1, grace period)
- Service C: day 20 (opted into v2, late)
- Service D: day 22 (blocked by pre-existing test failure, fixed first)
