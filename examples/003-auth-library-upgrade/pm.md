# PM — Auth Library Migration (v1 to v2)

## The customer's words

> "I don't want my service to break. I don't want to rewrite auth code. I don't want a flag day."

The customer here is downstream service teams. They don't care about signing algorithms or token formats. They care that their service keeps working and that they're not forced into a synchronized cutover.

## What we committed to

### 1. Migration is backward-compatible during transition

No service breaks the day the library ships. v1 tokens continue to work for 30 days. Services adopt v2 on their own schedule.

Negotiated with Engineer. Engineer surfaced that backward compatibility requires dual-mode validation — the library must try v2 first, fall back to v1. This isn't free. It's deliberate design, not a version bump.

**Verify:** Engineer's FLW-30 (validation flow) accepts both v1 and v2 tokens. DevOps' OBS-30 shows v1/v2 token ratio moving over time, not flipping all at once. QA's per-service verification confirms each service works on whichever token version it's using.

### 2. No code changes beyond a version bump

Downstream teams update their dependency version. That's it. No API changes, no new configuration required, no migration guide to follow.

The `auth.token_version` config flag is optional — it defaults to v1 during transition, and the library handles the rest.

**Verify:** Engineer's library design shows identical public API surface between v1.x and v2.0. QA's service verification for Services A-D confirms each passed with only a version bump.

### 3. Per-service rollback without redeployment

Any service can revert to v1 behavior by flipping `auth.token_version` back to `v1`. No redeploy. No coordination with other teams.

**Verify:** DevOps' DEP-32 describes the config flag revert. QA's Service B stayed on v1 until day 28 — proof that holding back is a valid, supported path.

### 4. Dual-mode validation window (from Engineer)

Engineer surfaced this. Backward compatibility means the library actively validates both token formats for 30 days. PM accepted because the alternative — a flag day — violates commitment 1.

**Verify:** Engineer's FLW-30 shows the try-v2-then-v1 flow. DevOps' DEP-31 (circuit breaker) falls back to v1 if v2 validation spikes failures.

### 5. Per-service opt-in for v2 issuance (from Engineer)

Each service chooses when to start issuing v2 tokens. No central coordination. This is what makes "no flag day" real.

**Verify:** Engineer's FLW-31 checks the per-service config flag before deciding which token version to issue. QA confirmed Service A opted in on day 1, Service C on day 20 — both valid paths.

### 6. 30-day v1 grace period (from Engineer)

v1 tokens remain valid for 30 days from migration start. After that, v1 signing keys are decommissioned.

**Verify:** Engineer's FLW-32 defines the grace period. DevOps' OBS-32 alerts if v1 tokens appear after expiry. QA's VP-30 regression test confirms no service accepts v1 post-grace.

## Per-service contracts

| Service | Commitment to them | Their obligation | Status |
|---------|-------------------|-----------------|--------|
| Service A | Bump version, keep working. Opt in to v2 whenever ready. | Run auth integration tests. | Opted in day 1. Proven. |
| Service B | Same. v1 tokens valid for 30 days. No pressure. | Run auth integration tests. | Stayed v1 until day 28. Proven. |
| Service C | Same. | Run auth integration tests before deadline. | Opted in day 20. Proven. |
| Service D | Same. | Run auth integration tests. | Tests were already broken. See REQ-307. Proven after fix. |

## REQ-307: Service D's pre-existing rot

The migration didn't break Service D. Service D was already broken. Their test suite had failures before the library upgrade. The migration's suspect-flag mechanism exposed it — when the auth library changed, all services were marked SUSPECT and required re-verification. Service D couldn't re-verify because their tests didn't pass on the *old* library either.

This is sanity reconciliation catching a correctness gap that predated the migration. Filed as an independent issue for the Service D team.

**Verify:** Service D's test history shows failures before the auth library change was published. The migration was the trigger for discovery, not the cause.

## What goes suspect if things change

- If the 30-day grace period is shortened or extended --> commitments 1, 4, 6 go suspect; all per-service timelines need re-evaluation
- If a new service (Service E) is discovered that depends on the auth library --> it enters as SUSPECT and needs verification
- If the v2 token format changes after initial release --> all services re-enter SUSPECT; dual-mode validation may need to become tri-mode
- If security team changes the signing algorithm requirement --> Engineer's library design goes suspect, all flows need re-verification
