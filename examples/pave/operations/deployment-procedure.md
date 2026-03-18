# Deployment Procedure — Pave Deploy Platform

Last updated: 2025-11-01
Owner: Sasha Petrov (DevOps/SRE)

### Traceability

| Deployed Service | Architecture Reference | Infrastructure |
|-----------------|----------------------|----------------|
| Pave API | [architecture.md — Pave API](../architecture/architecture.md#pave-api) | [infrastructure.md — Pave API](./infrastructure.md#pave-api) |
| Deploy Engine | [architecture.md — Deploy Engine](../architecture/architecture.md#deploy-engine) | [infrastructure.md — Deploy Engine](./infrastructure.md#deploy-engine) |
| Canary Controller | [architecture.md — Canary Controller](../architecture/architecture.md#canary-controller) | [infrastructure.md — Canary Controller](./infrastructure.md#canary-controller) |
| Drift Detector | [architecture.md — Drift Detector](../architecture/architecture.md#drift-detector) | [infrastructure.md — Drift Detector](./infrastructure.md#drift-detector) |
| Secrets Engine | [architecture.md — Secrets Engine](../architecture/architecture.md#secrets-engine) | [infrastructure.md — Secrets Engine](./infrastructure.md#secrets-engine) |
| Approval Service | [architecture.md — Approval Service](../architecture/architecture.md#approval-service) | [infrastructure.md — Approval Service](./infrastructure.md#approval-service) |
| Metrics Collector | [architecture.md — Metrics Collector](../architecture/architecture.md#metrics-collector) | [infrastructure.md — Metrics Collector](./infrastructure.md#metrics-collector) |
| Notification Service | [architecture.md — Notification Service](../architecture/architecture.md#notification-service) | [infrastructure.md — Notification Service](./infrastructure.md#notification-service) |
| Database migrations | [data-model.md](../architecture/data-model.md) | [infrastructure.md — PostgreSQL](./infrastructure.md#postgresql) |
| **Post-deploy monitoring:** | [monitoring-alerting.md](./monitoring-alerting.md) — error rate auto-rollback ties to [US-001](../product/user-stories.md#us-001-atomic-single-commit-deploys) |
| **Confirmed by** | Sasha Petrov (DevOps/SRE), 2025-11-01 — walked full pipeline, verified rollback matrix, staging deploy tested end-to-end |

---

## The Meta Problem

Pave deploys itself. This is the intended steady-state — it's the strongest proof that Pave works. But it creates a bootstrap problem: if Pave is down, how do you deploy the fix?

Two modes:
1. **Normal mode:** Pave deploys Pave (same pipeline as any other service)
2. **Bootstrap mode:** Direct `kubectl apply` when Pave is unavailable — see [Bootstrap Procedure](#bootstrap-procedure)

The bootstrap procedure is the most operationally critical section of this document.

---

## CI/CD Pipeline (Normal Mode)

Pave uses Pave. The platform team's services are registered in Pave like any other team's services. This is deliberate — it forces us to eat our own cooking.

### Pipeline Overview

```
Developer pushes to feature branch
    |
    v
+-----------------------------------+
|  1. Build & Lint                  |
|     - go build ./...              |
|     - golangci-lint               |
|     - Duration: ~1 min            |
+-----------------------------------+
    |
    v
+-----------------------------------+
|  2. Unit Tests                    |
|     - go test ./...               |
|     - Coverage threshold: 80%     |
|     - Duration: ~2 min            |
+-----------------------------------+
    |
    v
+-----------------------------------+
|  3. Integration Tests             |
|     - Testcontainers (PG, Redis)  |
|     - API contract tests          |
|     - Deploy engine E2E           |
|     - Duration: ~5 min            |
+-----------------------------------+
    |
    v
+-----------------------------------+
|  4. Security Scan                 |
|     - govulncheck                 |
|     - Container image scan        |
|     - SAST (static analysis)      |
|     - Duration: ~2 min            |
+-----------------------------------+
    |
    v
+-----------------------------------+
|  5. Build Container Image         |
|     - Docker build (multi-stage)  |
|     - Tag: git SHA                |
|     - Push to internal registry   |
|     - Duration: ~2 min            |
+-----------------------------------+
    |
  PR merge to main
    |
    v
+-----------------------------------+
|  6. Deploy to Staging             |
|     - pave deploy pave-api        |
|       --env staging               |
|       --commit <sha>              |
|     - Smoke tests on staging      |
|     - Duration: ~5 min            |
+-----------------------------------+
    |
  Manual approval (Sasha or Kai)
    |
    v
+-----------------------------------+
|  7. Deploy to Production          |
|     - Blue-green for Pave API     |
|     - Canary for other services   |
|     - Duration: ~10 min           |
+-----------------------------------+
    |
    v
+-----------------------------------+
|  8. Post-Deploy Verification      |
|     - Smoke tests against prod    |
|     - Monitor error rate 15 min   |
|     - Auto-rollback if errors > 1%|
+-----------------------------------+
```

### Who Can Deploy Pave to Production

Only the platform team (`team: pave-platform` in RBAC). Specifically:
- Sasha Petrov (DevOps/SRE) — primary deployer
- Kai Tanaka (Senior Platform Engineer) — secondary
- Marcus Chen (Platform Lead) — emergency only

This is enforced by Pave's own RBAC ([ADR-006](../architecture/adrs.md#adr-006-rbac-model--team-x-environment-matrix)).

---

## Production Deploy Strategy

### Pave API — Blue-Green

The Pave API is the front door. A bad deploy here blocks all other deploys. Blue-green gives us instant rollback.

```
1. Current "blue" pods serving traffic
2. Deploy "green" pods with new version
3. Wait for readiness probes to pass
4. Switch Service selector to green
5. Monitor error rate for 5 minutes
6. If clean: scale down blue
7. If errors: switch selector back to blue (< 30 seconds)
```

Implementation: two Kubernetes Deployments (`pave-api-blue`, `pave-api-green`), one Service with selector switching.

**Rollback time:** < 30 seconds (selector switch only). No image pull, no pod scheduling.

### Deploy Engine — Rolling Update

Standard rolling update. maxUnavailable: 0, maxSurge: 1. The deploy queue drains to the remaining pod during the update.

Deploy Engine changes are lower risk than API changes — they don't affect the request path for CLI/dashboard interactions.

### Other Services — Rolling Update

Canary Controller, Drift Detector, Secrets Engine, Approval Service, Metrics Collector, Notification Service all use standard rolling updates. Single-replica services have brief unavailability during rollout (~10 seconds). Acceptable because none of these are in the critical deploy request path.

### Canary for Pave's Own Changes

When we make changes that affect the deploy path (API request handling, deploy execution), we canary Pave's own changes:

```bash
pave deploy pave-api --env production --canary 10
# Routes 10% of API traffic to the new version
# Monitors error rate for 10 minutes
# If error rate delta > 0.5%: auto-rollback
# If clean: promote to 100%
```

We use our own canary infrastructure to validate Pave changes. This is the strongest signal that canary deploys work correctly.

---

## Database Migrations

Database migrations run as Kubernetes Jobs, not inside application pods. This prevents a failed migration from crashing the application.

### Migration Procedure

```bash
# 1. Run migration in staging first
kubectl apply -f migrations/job-<version>.yaml --namespace pave-staging
kubectl logs job/migrate-<version> -n pave-staging --follow

# 2. Verify staging is healthy
pave status pave-api --env staging

# 3. Run migration in production
kubectl apply -f migrations/job-<version>.yaml --namespace pave-system
kubectl logs job/migrate-<version> -n pave-system --follow

# 4. Verify production is healthy
pave status pave-api --env production
```

### Migration Safety Rules

1. **All migrations must be backward-compatible.** The old application version must work with the new schema. Deploy schema changes and application changes separately.
2. **No `ALTER TABLE ... ADD CONSTRAINT` on tables > 1M rows without `NOT VALID` + separate `VALIDATE CONSTRAINT`.** The deploy_events table has 2M+ rows. A blocking ALTER would lock the deploy queue. This is what caused the Round 6 incident ([BUG-003](../product/user-stories.md#bug-003-deploy-queue-corruption-during-rbac-migration)).
3. **All migrations must include a rollback script.** Every `up.sql` has a corresponding `down.sql`.
4. **Test the migration against a production-size dataset in staging before applying to production.** Staging has a recent anonymized snapshot of production.

### Round 6 Lesson

The RBAC migration added a foreign key constraint to the `deploy_queue` table with a full table lock. The table had 500K rows. The lock held for 4 hours. Nobody could deploy. Three teams had P1 fixes waiting.

Post-incident change: all migrations that touch the `deploy_queue`, `deploy_events`, or `audit_log` tables require Sasha's explicit sign-off and must be tested against production-volume data in staging.

See: [Runbook: Deploy Queue Corruption](./runbook-deploy-queue-corruption.md)

---

## Rollback Procedures

### Application Rollback (Normal — Pave is Up)

```bash
# Rollback the last deploy
pave rollback pave-api --env production

# Rollback to a specific version
pave rollback pave-api --env production --to <commit-sha>
```

Rollback is a deploy of the previous version. Same blue-green / rolling update mechanics. Rollback time: < 2 minutes for Pave API (blue-green switch), < 5 minutes for other services (rolling update).

Rollback traces through the full audit log. See [US-002](../product/user-stories.md#us-002-instant-rollback-under-2-minutes).

### Application Rollback (Pave is Down — Bootstrap)

See [Bootstrap Procedure](#bootstrap-procedure) below.

### Database Rollback

```bash
# Run the down migration
kubectl apply -f migrations/rollback-<version>.yaml --namespace pave-system
kubectl logs job/rollback-<version> -n pave-system --follow
```

If the down migration fails or doesn't exist: restore from WAL backup. RPO: ~1 minute. RTO: ~30 minutes.

---

## Bootstrap Procedure

**When to use:** Pave is down and cannot deploy itself.

**Who can execute:** Sasha Petrov, Kai Tanaka, or Marcus Chen. Must have `kubectl` access to the `pave-system` namespace (break-glass credentials stored in Vault, paper backup in the safe).

**Audit requirement:** Every action taken during bootstrap mode must be logged in the incident channel and retroactively recorded in Pave's audit log after recovery.

### Step-by-Step

```bash
# 1. Confirm Pave is actually down (not just slow)
kubectl get pods -n pave-system
kubectl logs deployment/pave-api -n pave-system --tail=50

# 2. Identify the fix
# - If it's a bad deploy: identify the last known good image tag
# - If it's a database issue: identify the blocking query/migration
# - If it's infrastructure: check node health, PV status, etc.

# 3. Build the fix image (if needed)
# CI still works even when Pave is down — it's a separate system
# Push to the registry manually:
docker build -t registry.internal/pave-api:<fix-sha> .
docker push registry.internal/pave-api:<fix-sha>

# 4. Apply directly via kubectl
kubectl set image deployment/pave-api-blue \
  pave-api=registry.internal/pave-api:<fix-sha> \
  -n pave-system

# Wait for rollout
kubectl rollout status deployment/pave-api-blue -n pave-system

# 5. Verify Pave is back
curl -s http://pave.internal/api/healthz
pave status pave-api --env production

# 6. Log the bootstrap action
# Post in #pave-incidents Slack channel:
# WHO: <your name>
# WHEN: <timestamp>
# WHAT: kubectl set image ... (exact command)
# WHY: <link to incident>
# ROLLBACK SHA: <previous image tag>
```

### Bootstrap Access

Break-glass `kubectl` credentials are:
- **Primary:** Stored in Vault at `secret/pave/break-glass/kubeconfig`. Accessible to Sasha, Kai, Marcus via their personal Vault tokens.
- **Backup:** Printed kubeconfig in sealed envelope, in the office safe. For when Vault is also down.

The kubeconfig has a 24-hour TTL and is regenerated weekly by a CronJob. It grants `edit` access to `pave-system` namespace only.

### After Bootstrap Recovery

1. Record all manual actions in Pave's audit log via the admin API:
   ```bash
   curl -X POST http://pave.internal/api/admin/audit \
     -H "Authorization: Bearer $ADMIN_TOKEN" \
     -d '{
       "action": "bootstrap_deploy",
       "actor": "sasha.petrov",
       "target": "pave-api",
       "details": "Manual kubectl deploy during Pave outage",
       "incident_ref": "INC-042",
       "timestamp": "2025-09-10T14:30:00Z"
     }'
   ```
2. Run drift detection to confirm Pave's expected state matches reality:
   ```bash
   pave drift-check --all --env production
   ```
3. Write incident post-mortem.

---

## Pre-Deploy Checklist

Before every production deploy of Pave:

- [ ] Staging deploy succeeded and smoke tests passed
- [ ] If database migration: tested against production-volume data in staging
- [ ] If database migration touching deploy_queue/deploy_events/audit_log: Sasha signed off
- [ ] No active P0/P1 incidents in progress
- [ ] No other Pave deploy in progress (one at a time)
- [ ] Deploy window: business hours (09:00–17:00), Mon–Thu preferred. Friday deploys require explicit justification.
- [ ] On-call engineer is aware and available for the next 2 hours

---

## Post-Deploy Monitoring

After every production deploy, the deployer watches for 15 minutes:

| Check | Tool | Threshold |
|-------|------|-----------|
| Pave API error rate | [D1: Pave Operations Overview](./monitoring-alerting.md#d1-pave-operations-overview) | > 1% for 2 min = auto-rollback |
| Deploy Engine health | [D2: Deploy Pipeline Dashboard](./monitoring-alerting.md#d2-deploy-pipeline-dashboard) | Any deploy failures = investigate |
| Deploy queue depth | [D2](./monitoring-alerting.md#d2-deploy-pipeline-dashboard) | Increasing = something stuck |
| Pave API latency (p95) | [D1](./monitoring-alerting.md#d1-pave-operations-overview) | > 500ms = investigate |
| Active pod count | `kubectl get pods -n pave-system` | All pods Running and Ready |

If any threshold is breached: rollback immediately, then investigate. Don't debug in production with a half-working deploy.
