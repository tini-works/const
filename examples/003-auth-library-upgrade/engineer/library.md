# Engineer — Auth Library Design

## The constraint

Security mandates migration from JWT v1 (old signing algorithm) to v2 (new signing algorithm, new token format). 30-day deadline. Four services depend on this library. A flag-day cutover violates PM's commitments.

The library must handle the transition internally so consumers don't have to.

## Library lifecycle

The library ships twice:

| Version | What it does | When |
|---------|-------------|------|
| v2.0 | Dual-mode: validates both v1 and v2 tokens. Issues v1 or v2 based on service config. | Day 0 — transition starts |
| v2.1 | Single-mode: validates v2 only. v1 fallback removed. Config flag deprecated. | Day 30 — grace period expires |

v2.0 is the migration vehicle. v2.1 is the cleanup.

## Token validation flow (FLW-30)

During transition (v2.0):
```
Incoming token
    --> Try v2 validation (new algorithm, new format)
        --> Success: accept, return claims
        --> Fail: try v1 validation (old algorithm, old format)
            --> Success: accept, return claims, log "v1-fallback"
            --> Fail: reject (invalid token)
```

After transition (v2.1):
```
Incoming token
    --> v2 validation only
        --> Success: accept
        --> Fail: reject
```

**Verify:** In staging with v2.0 deployed, issue a v1 token and a v2 token. Send both to any service. Both should return 200 with valid claims. The v1 token response should include a `x-token-version: v1` header and produce a `v1-fallback` log entry. After v2.1 is deployed, the v1 token should return 401.

## Token issuance flow (FLW-31)

```
Service requests token issuance
    --> Read service config: auth.token_version
        --> "v2": issue v2 token (new algorithm, new format)
        --> "v1" (or absent): issue v1 token (old algorithm, old format)
```

The config flag is the opt-in mechanism. Default is v1 — no service is forced into v2 without explicitly choosing it.

**Verify:** In staging, set Service A's config to `auth.token_version = v2`. Request a token from Service A's auth endpoint. Decode the token — it should use the v2 signing algorithm and format. Set Service B's config to `v1` (or remove the flag). Service B's tokens should still be v1.

## Grace period mechanic (FLW-32)

v1 signing keys are retained for 30 days from migration start. During this window:
- v2.0 library can validate v1 tokens using the retained keys
- Any service still issuing v1 tokens produces valid tokens

At day 30:
- v1 signing keys are decommissioned (DevOps removes them from all environments)
- v2.1 library ships with v1 validation code removed

**Verify:** Check that v1 signing keys exist in staging key store. Validate a v1 token — should succeed. After key decommission (simulated in staging), validate the same v1 token — should fail with `signing-key-not-found`.

## Migration config

Each service carries one config entry:

```yaml
# Service config
auth:
  token_version: v1   # Options: v1, v2. Default: v1.
```

That's it. No other changes. The library's public API is identical between v1.x and v2.0 — same function signatures, same return types, same error codes. The config flag is the only new surface.

**Verify:** Diff the public API types between v1.x and v2.0. `diff lib/v1.x/types.d.ts lib/v2.0/types.d.ts` should show no changes to exported interfaces.

## What goes suspect if this changes

- If the v2 signing algorithm is found to have vulnerabilities --> FLW-30, FLW-31 go suspect; may need to extend v1 grace period
- If a service needs custom claims in v2 tokens --> FLW-31 goes suspect; library API may need to change (violating commitment 2)
- If grace period is shortened --> FLW-32 goes suspect; services still on v1 may lose validation mid-flight
- If new services are added during transition --> they enter with v1 default, but need to be added to QA tracking
