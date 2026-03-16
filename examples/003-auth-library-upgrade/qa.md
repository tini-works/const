# QA Inventory — Auth Library Migration (JWT v1 → v2)

This is service-level migration tracking, not feature verification.

## Service Verification Status

| Service | Status | Token mode | Verified |
|---------|--------|-----------|----------|
| Service A | PROVEN | v2 issued + validated | Day 3 |
| Service B | PROVEN | v1 issued, v1 fallback validated | Day 5 |
| Service C | PROVEN | v2 issued + validated | Day 20 |
| Service D | PROVEN | v1 fallback validated (after test fix) | Day 22 |

## Timeline

```
Day 0:   Auth library v2.0 published → all 4 services marked SUSPECT
Day 3:   Service A re-verified
Day 5:   Service B re-verified
Day 8:   Service D discovered BLOCKED — test suite already broken before migration
Day 20:  Service C re-verified
Day 22:  Service D test suite fixed, re-verified
Day 30:  Grace period expired, v1 decommissioned
```

## Service D: Pre-existing Rot

Service D failed re-verification on day 8. Root cause: their test suite had pre-existing failures unrelated to the auth migration. The migration didn't break Service D — it forced them to run tests they hadn't been running. Fixed by Service D team. Re-verified day 22. Filed as REQ-307 in PM inventory.

## Post-Migration Regression

| Test | Mechanism | Expected |
|------|-----------|----------|
| v1 token submitted to any service | Automated regression: v1 token → expect 401 | Reject after day 30 |
| v1 token ratio in production | OBS-32 alert (DevOps) | Zero after day 30 |
