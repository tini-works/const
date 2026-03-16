# QA — Auth Migration Proofs

This is service-level verification, not feature testing. Four services, each independently proving they work with the new auth library. The suspect-flag-on-change mechanism drives the workflow.

---

## How the suspect flag worked

When Engineer published auth library v2.0, every service depending on it was automatically marked SUSPECT. Each service had to re-verify independently before returning to PROVEN.

This is not manual tracking. The inventory dependency chain fires the flag. If the auth library changes, all consumers go suspect. No exceptions, no "we probably don't need to re-test."

```
Auth library v2.0 published
    --> Service A: SUSPECT
    --> Service B: SUSPECT
    --> Service C: SUSPECT
    --> Service D: SUSPECT

Each service re-verifies independently:
    Run auth integration tests against new library
    --> Pass: SUSPECT --> PROVEN
    --> Fail: SUSPECT --> BLOCKED (investigate)
```

**Verify:** Check the inventory log. All four services should show a SUSPECT entry timestamped at library publish time, and a PROVEN (or BLOCKED-then-PROVEN) entry timestamped at their re-verification time.

---

## Service verification timeline

| Service | Day flagged SUSPECT | Day verified | Result | Token path verified | Notes |
|---------|-------------------|-------------|--------|-------------------|-------|
| Service A | 0 | 1 | PROVEN | v2 issuance + v2 validation | Early adopter. No issues. |
| Service B | 0 | 3 | PROVEN | v1 issuance + dual-mode validation | Stayed on v1 for 25 days. Valid path. |
| Service C | 0 | 20 | PROVEN | v2 issuance + v2 validation | Late but within deadline. |
| Service D | 0 | 22 | PROVEN (after BLOCKED) | v1 validation only | Tests were broken before migration. See below. |

**Verify:** For each service, the re-verification test run should be in CI. Check the test run at the "Day verified" timestamp — it should pass against auth library v2.0.

---

## Service D: pre-existing rot exposed (REQ-307)

Service D's re-verification failed on day 5. Investigation revealed:
- Test failures were present in Service D's main branch *before* the auth library change
- The migration didn't break Service D — it forced Service D to run tests they hadn't been running
- Root cause: test fixtures had drifted from actual API responses months earlier

The suspect flag is what caught this. Without mandatory re-verification, Service D's rot would have continued undetected.

**Verify:** Check Service D's CI history. Test failures should be visible in runs predating the auth library v2.0 publish date. The fix commit (around day 20) should address test fixture drift, not auth-related code.

---

## VP-30: Post-migration regression — no service accepts v1 tokens

**What we're proving:** After grace period expiry and v2.1 deployment, no service in the fleet accepts v1-format tokens.

**Run:**
1. Generate a valid v1-format token using the old signing algorithm and the (now-decommissioned) v1 signing key
2. Send it to each service's authenticated endpoint:
   - `POST /api/service-a/protected` with v1 token in Authorization header
   - `POST /api/service-b/protected` with v1 token
   - `POST /api/service-c/protected` with v1 token
   - `POST /api/service-d/protected` with v1 token
3. Assert: all four return 401 Unauthorized
4. Generate a valid v2 token
5. Send to all four services
6. Assert: all four return 200

**If it breaks:** OBS-32 (v1 token usage after grace period) should fire. If a service is still accepting v1 tokens, it means either:
- The service didn't upgrade to v2.1, or
- v1 signing keys weren't properly decommissioned from that service's environment

**Verify:** Run VP-30 in staging after simulating key decommission. All v1 requests should return 401. Run it again in production after the real decommission on day 30.

---

## Coverage

| PM Commitment | Verified by | Degradation signal |
|--------------|-------------|-------------------|
| 1. Backward-compatible migration | Service timeline (all verified during transition) | Any service failing auth during transition window |
| 2. No code changes beyond version bump | All 4 service verifications passed with bump only | Service failing after only a version bump |
| 3. Per-service rollback | Service B's v1 path + DevOps DEP-32 | Config flag revert doesn't restore v1 behavior |
| 4. Dual-mode validation | Services A (v2) and B (v1) both PROVEN simultaneously | v1 fallback in FLW-30 stops working |
| 5. Per-service opt-in | Services adopted on days 1, 3, 20, 22 | Service forced into v2 without opt-in |
| 6. Grace period | Service B on v1 until day 28, still valid | v1 tokens rejected before day 30 |
| Regression (post-migration) | VP-30 | OBS-32 fires (v1 tokens accepted after grace) |

Every commitment has a service-level proof. The suspect-flag mechanism provided the tracking. VP-30 guards against v1 resurrection.
