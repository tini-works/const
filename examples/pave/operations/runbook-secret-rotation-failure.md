# Runbook: Secret Rotation Failure

**Severity:** P1 — Notify During Business Hours
**SLA:** Acknowledge within 1 hour, resolve within 4 hours
**Last tested:** 2025-11-10 — Simulated rotation failure in staging: blocked Vault access for the Secrets Engine, verified alert fired and old secrets remained valid via sidecar cache.
**Last triggered:** 2025-10-22 — Vault maintenance window overlapped with Team Sentry's scheduled Redis credential rotation. Rotation failed, old credential remained valid. Resolved after Vault came back online.

### Traceability

| Link | Reference |
|------|-----------|
| **Triggered by:** | Alert: [Secret Rotation Failure](./monitoring-alerting.md#p1----notify-during-business-hours) (`pave_secret_rotation_failure_total` increase) |
| **Watches:** | [Secrets Engine](../architecture/architecture.md#secrets-engine), [ADR-011: Runtime secrets injection via sidecar](../architecture/adrs.md#adr-011-runtime-secrets-injection-via-sidecar), [ADR-012: Secrets rotation event bus](../architecture/adrs.md#adr-012-secrets-rotation-event-bus) |
| **Proves:** | [US-014: Secrets rotation without redeploy](../product/user-stories.md#us-014-secrets-rotation-without-redeploy), [US-015: Secrets rotation audit trail](../product/user-stories.md#us-015-secrets-rotation-audit-trail) |
| **Detects:** | [TC-701: Secrets rotation zero downtime](../quality/test-suites.md#tc-701-secrets-rotation--zero-downtime), [TC-703: Rotation event published to consumers](../quality/test-suites.md#tc-703-rotation-event-published-to-consumers), [TC-705: Alert — service using expired secret](../quality/test-suites.md#tc-705-alert--service-using-expired-secret) |
| **Confirmed by** | Sasha Petrov (DevOps/SRE), 2025-11-10 — rotation failure simulation in staging |

---

## Detection

How you'll know:

- Alert: `pave_secret_rotation_failure_total` increased
- Alert: `pave_secret_expired_in_use > 0` (services still running with old secret after rotation window)
- Secrets Engine logs: `rotation failed` entries
- Team reports: "Our service can't connect to the database after credential rotation"

---

## Immediate Assessment

### 1. Which Secret Failed to Rotate?

```bash
# Check the Secrets Engine logs
kubectl logs deployment/pave-secrets-engine -n pave-system --tail=100 | \
  grep -E "rotation.*fail|error.*rotate"

# Check the rotation failure metric for details
curl -s http://pave-secrets-engine.pave-system:8085/metrics | \
  grep pave_secret_rotation_failure_total
```

### 2. Which Services Are Affected?

```bash
# Check which services consume this secret
pave secrets consumers <secret-path>
# Example output:
# team-falcon/checkout-api — using version 3 (current: 4, EXPIRED in 2 hours)
# team-falcon/payment-service — using version 4 (current)
# team-atlas/billing-api — using version 3 (current: 4, EXPIRED in 2 hours)

# Check the dashboard
# D5: Secrets & Vault Dashboard — "Services Using Expired Secrets" table
```

### 3. Is the Old Secret Still Valid?

This is the critical question. If the old secret is still valid, services continue working — the rotation just didn't propagate. If the old secret was revoked, services are down or will be down soon.

| Scenario | Urgency | Action |
|----------|---------|--------|
| Old secret still valid, new secret exists in Vault | Low — fix propagation | Re-trigger rotation event |
| Old secret still valid, new secret NOT in Vault | Medium — Vault issue | Fix Vault, then rotate |
| Old secret revoked/expired, services using cached copy | High — time-limited | Sidecar cache TTL is 5 min. Services will fail when cache expires. |
| Old secret revoked/expired, services already failing | Critical — outage | Manual secret injection or emergency rotation |

---

## Resolution

### Scenario: Vault Was Temporarily Unavailable

The most common case. Vault had a maintenance window or brief outage.

```bash
# 1. Verify Vault is back
vault status

# 2. Re-trigger the rotation
pave secrets rotate <secret-path> --force

# 3. Verify consumers picked up the new secret
pave secrets consumers <secret-path>
# All services should show "current" version
```

### Scenario: Rotation Event Not Delivered

The secret was rotated in Vault, but the event bus didn't notify consumers.

```bash
# 1. Check the event bus (Redis pub/sub)
kubectl exec -it pave-redis-master-0 -n pave-system -- \
  redis-cli subscribe pave:secrets:rotation
# (Ctrl+C after a few seconds — just checking if the channel exists)

# 2. Re-publish the rotation event
pave secrets notify <secret-path>

# 3. If the event bus is broken, force sidecars to re-fetch
# Each sidecar polls Vault on its cache TTL (5 min default).
# If you can't wait, restart the affected service pods:
kubectl rollout restart deployment/<service> -n <namespace>
```

### Scenario: Sidecar Injection Failed

The service was deployed without a secrets sidecar. It's using baked-in or environment-variable secrets.

```bash
# Check if the sidecar is present
kubectl get pod <pod-name> -n <namespace> -o jsonpath='{.spec.containers[*].name}'
# Expected: "app pave-secrets-sidecar"
# If sidecar is missing: redeploy the service through Pave

pave deploy <service> --env production --commit <current-commit>
# This redeploy will inject the sidecar via the admission webhook
```

### Scenario: Services Are Down — Emergency Manual Rotation

If services are already failing because the old secret expired:

```bash
# 1. Generate a new secret value
NEW_PASSWORD=$(openssl rand -base64 32)

# 2. Update the secret in Vault
vault kv put secret/pave/<service>/db password=$NEW_PASSWORD

# 3. Update the actual backend (e.g., database password)
# This depends on what kind of secret it is:
# - Database: ALTER USER ... PASSWORD '...' in PostgreSQL
# - Redis: CONFIG SET requirepass ...
# - API key: update in the provider's dashboard

# 4. Force sidecars to pick up the new secret
# Restart affected pods
kubectl rollout restart deployment/<service> -n <namespace>

# 5. Verify services are healthy
kubectl get pods -n <namespace> | grep <service>
curl -sf <service-health-endpoint>
```

---

## Verification

After resolving:

```bash
# 1. No services using expired secrets
pave secrets consumers <secret-path>
# All should show current version

# 2. D5: Secrets & Vault Dashboard
# "Services Using Expired Secrets" table should be empty

# 3. Rotation failure alert should clear
# pave_secret_rotation_failure_total stops incrementing

# 4. If services were restarted, verify they're healthy
kubectl get pods -n <namespace> | grep <service>
```

---

## Prevention

1. **Schedule rotations outside Vault maintenance windows.** Check with the infrastructure team before scheduling rotations.
2. **Monitor sidecar injection.** The `pave_sidecar_injection_failure_total` metric (P2 alert) catches services deployed without the sidecar — these will fail silently at rotation time.
3. **Test rotation regularly.** Don't wait for the 90-day rotation cycle to discover the mechanism is broken. Run a test rotation monthly in staging.
4. **Non-K8s stacks:** Gridline services (Docker Compose) don't have the sidecar. Their rotation path is different and less automated. Track separately.

### Known Gap

Rotation for non-K8s stacks (Gridline, Docker Compose adapter) is not yet automated. Rotation for these services is manual: update Vault, restart the service. This is a known gap from Round 8 — tracked as a follow-up to [US-014](../product/user-stories.md#us-014-secrets-rotation-without-redeploy).

---

## Escalation

| Time | If | Escalate to |
|------|------|-------------|
| +0 min | Rotation failure alert | On-call engineer (Pave team) |
| +0 min | Vault is sealed/unreachable | Infrastructure team (their on-call) |
| +1 hour | Services still using expired secrets | Marcus Chen + affected team leads |
| +2 hours | Services are down due to expired secrets | P0 — full incident response |
