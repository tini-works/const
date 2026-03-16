# DevOps — Auth Migration Operations

## Deployment strategy

### DEP-30: Canary — v2 token issuance at 5% traffic

Before any service flips `auth.token_version = v2`, the auth library's v2 issuance path is tested with 5% of traffic on the first adopting service (Service A).

**What to watch:** Error rates on authenticated endpoints. v2 tokens should be accepted by all services running v2.0 library (dual-mode validation handles them).

**Rollback trigger:** v2 validation failure rate >0.5% during canary window.

**Verify:** During Service A's canary rollout, check the metrics dashboard. 5% of Service A's issued tokens should be v2 format. Error rate on downstream services receiving those tokens should be 0%. If it's not, the canary is catching a real problem.

### DEP-31: Circuit breaker — v2 validation failure fallback

If v2 token validation fails at a rate >0.1%, the library's dual-mode validator automatically prioritizes v1 validation first instead of v2-first.

This is built into the library, not the infrastructure. The circuit breaker is a code path, not a load balancer rule.

```
Normal mode (v2-first):
    try v2 --> fail --> try v1 --> fail --> reject

Circuit breaker tripped (v1-first):
    try v1 --> fail --> try v2 --> fail --> reject
```

The circuit breaker resets after 5 minutes of <0.01% v2 failure rate.

**Verify:** In staging, deploy a service with intentionally malformed v2 signing config. Send 1000 requests. After ~10 v2 failures (>0.1%), the library should flip to v1-first mode. Check logs for `circuit-breaker-tripped` entry. Fix the config. After 5 minutes of clean traffic, logs should show `circuit-breaker-reset`.

### DEP-32: Rollback — per-service config flag revert

Any service can revert from v2 to v1 issuance by changing one config value:

```yaml
# Revert to v1
auth:
  token_version: v1
```

No redeployment. Config is read at runtime. The service starts issuing v1 tokens on the next request after config change.

**Verify:** In staging, set a service to `token_version = v2`. Verify it issues v2 tokens. Change config to `v1` without restarting the service. Verify the next issued token is v1 format. Latency of config pickup should be <10 seconds.

---

## Observability

### OBS-30: Token ratio dashboard — v1 vs v2 across all services

**What it watches:** Percentage of v1 vs v2 tokens being issued and validated, broken down by service.

**Why it matters:** This is the migration's pulse. The ratio should trend from 100% v1 toward 100% v2 over 30 days. A sudden drop back to v1 means a service rolled back (expected and fine) or the circuit breaker tripped (investigate).

**Expected progression:**
```
Day 0:  100% v1 / 0% v2
Day 1:  ~75% v1 / ~25% v2   (Service A on v2)
Day 20: ~50% v1 / ~50% v2   (Service C joins v2)
Day 28: ~25% v1 / ~75% v2   (Service B switches)
Day 30: 0% v1 / 100% v2     (grace period over, all on v2)
```

**Verify:** Open the token ratio dashboard in Grafana (or equivalent). Filter by service. Each service's line should show a step-change from v1 to v2 at the day they opted in. The aggregate line should trend upward continuously.

### OBS-31: Alert — v2 validation failure rate >0.1%

**What it watches:** Rate of v2 token validation failures across all services.

**Threshold:** >0.1% of v2 validation attempts over a 5-minute window.

**Why it matters:** v2 validation failures during transition could mean: bad signing key distribution, token format mismatch, or clock skew on token expiry. The circuit breaker (DEP-31) handles it automatically, but the alert ensures humans investigate.

**Verify:** In staging, introduce a signing key mismatch on one service. Send v2 tokens to it. Alert should fire within 5 minutes. Fix the key. Alert should clear.

### OBS-32: Alert — v1 token usage after grace period expiry

**What it watches:** Any v1-format token being presented to any service after day 30.

**Threshold:** >0 (any v1 token activity is an anomaly post-grace).

**Why it matters:** After grace period, v1 tokens should not exist. If they appear, either:
- A client cached a long-lived v1 token (token TTL misconfiguration)
- v1 signing keys weren't fully decommissioned
- A service is still running v2.0 instead of v2.1

**Verify:** After day 30 (simulated in staging by removing v1 signing keys), send a v1 token to any service. The request should fail (401), and OBS-32 should fire. If it doesn't fire, the alert is misconfigured.

---

## Migration timeline from ops view

```
Day 0:  Publish auth library v2.0.
        Deploy v1+v2 signing keys to all environments.
        Enable OBS-30, OBS-31.
        All services flagged SUSPECT.

Day 1:  Service A canary (DEP-30) at 5% v2 traffic.
        Monitor error rates. Clean --> promote to 100%.

Day 3:  Service B on v2.0 library, stays on v1 issuance.
        OBS-30 shows Service B still 100% v1. Expected.

Day 5:  Service D attempts upgrade. Tests fail. BLOCKED.
        No ops action needed — this is a code issue, not infra.

Day 20: Service C opts in to v2.
        OBS-30 shows ratio shift.

Day 22: Service D unblocked after test fix. Opts in.

Day 28: Service B switches to v2. Last v1 holdout gone.
        OBS-30 approaching 100% v2.

Day 30: Grace period expires.
        REMOVE v1 signing keys from all environments.
        Publish auth library v2.1 (v1 code removed).
        Enable OBS-32.
        Deactivate circuit breaker (no v1 to fall back to).

Post:   OBS-32 in steady state (should never fire).
        OBS-30 locked at 100% v2.
        OBS-31 active for ongoing v2 health.
```

**Verify:** Walk the timeline in staging by simulating each day's config changes. At each step, confirm the relevant OBS signal shows the expected state. On day 30, confirm v1 key removal and OBS-32 activation.

---

## Environment parity

| Environment | v1 signing key | v2 signing key | Auth library version | Purpose |
|------------|---------------|---------------|---------------------|---------|
| Staging | Present (days 0-30), removed after | Present | v2.0 then v2.1 | Full migration rehearsal |
| Load test | Present | Present | v2.0 | Mixed v1/v2 traffic at production scale |
| Production | Present (days 0-30), removed after | Present | v2.0 then v2.1 | Real migration |

**Verify:** For each environment, check the key store. `list-signing-keys --env staging` should show both keys during transition, only v2 after day 30.

## What goes suspect if this changes

- If a new service is discovered that depends on auth --> OBS-30 needs a new service panel; migration timeline may need extension
- If v2 signing key needs rotation --> OBS-31 may spike during rotation; circuit breaker may trip
- If grace period is extended past 30 days --> OBS-32 activation date shifts; v1 key decommission postponed
- If the monitoring stack itself degrades --> all OBS signals go suspect; migration decisions lose visibility
