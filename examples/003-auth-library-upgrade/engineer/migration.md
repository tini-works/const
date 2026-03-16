# Engineer — Migration Tracking

## Service migration status

Four services depend on the auth library. Each migrates independently.

| Service | Library version | Token version config | Opted in to v2 | Day |
|---------|----------------|---------------------|----------------|-----|
| Service A | v2.0 | `auth.token_version = v2` | Yes | Day 1 |
| Service B | v2.0 | `auth.token_version = v1` | No (used grace period, switched day 28) | Day 28 |
| Service C | v2.0 | `auth.token_version = v2` | Yes | Day 20 |
| Service D | v2.0 | `auth.token_version = v1` | Blocked, then yes | Day 22 (after test fix) |

**Verify:** For each service, check the deployed config in the service's environment variables or config store. `auth.token_version` should match the table above. After day 30, all should be `v2`.

## Migration timeline

```
Day 0:  Auth library v2.0 published. All services flagged SUSPECT.
Day 1:  Service A bumps to v2.0, sets token_version=v2. Re-verified. PROVEN.
Day 3:  Service B bumps to v2.0, keeps token_version=v1. Re-verified on v1 path. PROVEN.
Day 5:  Service D bumps to v2.0, attempts re-verification. Tests fail. BLOCKED.
Day 7:  Service D investigation: test failures predate migration. REQ-307 filed.
Day 20: Service C bumps to v2.0, sets token_version=v2. Re-verified. PROVEN.
Day 22: Service D fixes pre-existing test rot. Re-verified on v1. PROVEN.
Day 28: Service B switches token_version to v2. Re-verified. PROVEN.
Day 30: Grace period expires. v1 signing keys decommissioned.
        Auth library v2.1 published. v1 code removed.
        All services on v2. Migration complete.
```

## Dependency chain

```
Auth library (v2.0/v2.1)
    |
    +--> Service A (identity provider)
    |       Uses: token issuance + validation
    |       Impact if library breaks: all downstream auth fails
    |
    +--> Service B (API gateway)
    |       Uses: token validation only
    |       Impact if library breaks: all API requests rejected
    |
    +--> Service C (background jobs)
    |       Uses: service-to-service token issuance + validation
    |       Impact if library breaks: job queue stalls
    |
    +--> Service D (legacy integration)
            Uses: token validation only
            Impact if library breaks: legacy system disconnected
            Note: pre-existing test rot discovered during migration (REQ-307)
```

**Verify:** Run `npm ls @company/auth-lib` (or equivalent) in each service's repo. All should show v2.0 (transition) or v2.1 (post-transition). No service should remain on v1.x after day 30.

## Post-migration cleanup (v2.1)

After day 30, the library ships v2.1 which removes:
- v1 validation fallback code from FLW-30
- v1 issuance path from FLW-31
- `auth.token_version` config flag (deprecated, ignored if present)
- v1 signing key references

**Verify:** After v2.1 deploy, grep service configs for `auth.token_version`. Flag should be absent or ignored. Send a v1-format token to any service — should return 401, not 200.

## What goes suspect if this changes

- If any service is discovered that wasn't in the dependency chain --> it enters as SUSPECT; timeline may need extension
- If Service D's REQ-307 fix reveals deeper issues --> Service D's PROVEN status goes suspect
- If v2.1 introduces regressions from removing v1 code --> all services go suspect; may need to re-publish v2.0 as hotfix
