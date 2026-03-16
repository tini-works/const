# QA Inventory — 003 Auth Library Migration

**Approach:** Service-level re-verification tracking, not single-feature verification paths.

## Proof Registry — Service Verification

| Service | Status | Detail | Day |
|---------|--------|--------|-----|
| Service A | PROVEN | v2 tokens, backward compat confirmed | 3 |
| Service B | PROVEN | v1 tokens, grace period confirmed | 5 |
| Service C | PROVEN | v2 tokens, opted-in late | 20 |
| Service D | PROVEN | v1 tokens, pre-existing test issue fixed first | 22 |

## Timeline

```
Day 0:  Library published → all 4 services flagged SUSPECT
Day 3:  Service A re-verified ✓
Day 5:  Service B re-verified ✓
Day 8:  Service D discovered BLOCKED (unrelated broken tests)
Day 20: Service C re-verified ✓
Day 22: Service D fixed pre-existing issue, re-verified ✓
Day 30: Grace period expired, v1 decommissioned
```

## Bonus Finding: Service D

Service D's tests were already broken before the migration. The migration didn't break them — the SUSPECT flag forced re-verification, which exposed the pre-existing rot. Sanity reconciliation caught a correctness gap that predated the change.

## Post-Migration Verification

| ID | Path | Mechanism | Degradation signal |
|----|------|-----------|-------------------|
| VP-30 | No service accepts v1 tokens after grace | Regression test: v1 token → 401 | Alert if v1 tokens in production after day 30 |
