# Data Model — Pave Deploy Platform

All tables use PostgreSQL. Timestamps are UTC. UUIDs for primary keys. Append-only for audit-critical tables.

---

## Entity Relationship Overview

```
teams 1──┬──N services
          │
          └──N roles (M:N with users via team × environment)

services 1──┬──N deploys
             │
             └──N drift_events

deploys 1──┬──N deploy_events (event-sourced queue)
            │
            ├──1 canary_sessions (optional)
            │
            ├──1 approvals (optional, PCI only)
            │
            └──N audit_log entries

secret_rotations ──N services (M:N via service_name)
```

---

## Core Tables

### teams

> **Read by:** [`GET /services`](api-spec.md#get-services), [`GET /access/{team}`](api-spec.md#get-accessteam), [`GET /metrics/health/{team}`](api-spec.md#get-metricshealthteam)
> **Stories:** [US-009](../product/user-stories.md#us-009-rbac-per-team-x-environment)
> **If schema changes:** Re-verify RBAC team scoping, service registry team filter, metrics team aggregation.
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-08-15

```sql
CREATE TABLE teams (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        VARCHAR(100) NOT NULL,
    slug        VARCHAR(50) NOT NULL UNIQUE,  -- URL-safe identifier
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

---

### services

Service registry. One record per service. Links to team and tracks current `pave.yaml` state.

> **Read by:** [`GET /services`](api-spec.md#get-services), [`GET /services/{name}`](api-spec.md#get-servicesname), [`POST /deploys`](api-spec.md#post-deploys) (validation)
> **Written by:** [`PUT /services/{name}/config`](api-spec.md#put-servicesnameconfig), [`pave init`](../experience/cli-spec.md#pave-init)
> **Stories:** [US-007](../product/user-stories.md#us-007-service-definition-schema--paveyaml), [US-016](../product/user-stories.md#us-016-pci-deploy-approval-workflow)
> **If schema changes:** Re-verify service registry endpoints, deploy validation (service lookup), RBAC service-team binding, pci_scoped flag check for approval gates (ADR-014), runtime adapter selection (ADR-005).
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-08-15

```sql
CREATE TABLE services (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(100) NOT NULL UNIQUE,
    team_id         UUID NOT NULL REFERENCES teams(id),
    runtime         VARCHAR(20) NOT NULL DEFAULT 'kubernetes',
        -- 'kubernetes', 'docker-compose', 'ecs'
    pci_scoped      BOOLEAN NOT NULL DEFAULT FALSE,   -- ADR-014: triggers approval gate
    pave_yaml_hash  VARCHAR(100),                     -- SHA256 of current pave.yaml
    repo_url        VARCHAR(500),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_services_team ON services (team_id);
CREATE INDEX idx_services_name ON services (name);
```

**`pci_scoped`:** Set from `pave.yaml` during `PUT /services/{name}/config`. When `true`, production deploys require approval (ADR-013). Changes to this field are audited.

---

### deploys

The central deploy record. One per deploy attempt (including rollbacks).

> **Read by:** [`GET /deploys/{id}`](api-spec.md#get-deploysid), [`GET /deploys`](api-spec.md#get-deploys), [`GET /metrics/deploys`](api-spec.md#get-metricsdeploys)
> **Written by:** [`POST /deploys`](api-spec.md#post-deploys), Deploy Engine (status updates), Canary Controller (auto-rollback)
> **Stories:** [US-001](../product/user-stories.md#us-001-atomic-single-commit-deploys), [US-002](../product/user-stories.md#us-002-instant-rollback-under-2-minutes), [US-008](../product/user-stories.md#us-008-full-deploy-audit-trail), [US-012](../product/user-stories.md#us-012-deploy-health-dashboard), [US-013](../product/user-stories.md#us-013-deploy-classification)
> **If schema changes:** Re-verify all deploy lifecycle endpoints, CLI status/list output, dashboard deploy views, metrics calculations, canary session FK, approval FK, audit log metadata.
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-12-01

```sql
CREATE TABLE deploys (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    service_name    VARCHAR(100) NOT NULL,
    commit_sha      VARCHAR(40) NOT NULL,
    environment     VARCHAR(20) NOT NULL,          -- 'dev', 'staging', 'production'
    deployer_id     UUID NOT NULL,
    status          VARCHAR(20) NOT NULL DEFAULT 'queued',
        -- 'queued', 'building', 'deploying', 'deployed', 'failed',
        -- 'rolled_back', 'cancelled', 'awaiting_approval'
    deploy_type     VARCHAR(20),                   -- 'feature', 'config', 'infra', 'trivial' (ADR-010)
    is_rollback     BOOLEAN NOT NULL DEFAULT FALSE,
    rollback_target VARCHAR(40),                   -- commit SHA of previous known-good deploy
    rollback_of     UUID REFERENCES deploys(id),   -- if this is a rollback, reference to original deploy
    is_bypass       BOOLEAN NOT NULL DEFAULT FALSE, -- ADR-009: break-glass deploy

    queued_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    started_at      TIMESTAMPTZ,
    completed_at    TIMESTAMPTZ,
    duration_seconds INTEGER,

    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_deploys_service_env ON deploys (service_name, environment);
CREATE INDEX idx_deploys_status ON deploys (status);
CREATE INDEX idx_deploys_deployer ON deploys (deployer_id);
CREATE INDEX idx_deploys_created ON deploys (created_at);
CREATE INDEX idx_deploys_service_env_status ON deploys (service_name, environment, status)
    WHERE status NOT IN ('deployed', 'failed', 'cancelled', 'rolled_back');
```

**`rollback_target`:** Computed at queue time — the `commit_sha` of the most recent successful deploy for this service+environment. Used by `POST /deploys/{id}/rollback` to know what to roll back to.

**`deploy_type`:** Classified after build by the Metrics Collector (ADR-010). NULL until classification runs. Used for metrics aggregation and dashboard filtering.

**Partial index `idx_deploys_service_env_status`:** Covers "is there an active deploy for this service?" check — used to prevent concurrent deploys to the same service+environment.

---

### deploy_events

Event-sourced deploy queue (ADR-008). Append-only. The `deploys` table status is derived from the latest event.

> **Read by:** [`GET /deploys/{id}/events`](api-spec.md#get-deploysidevents), [`GET /queue`](api-spec.md#get-queue) (state derivation)
> **Written by:** Pave API (on every deploy state transition)
> **Stories:** [US-011](../product/user-stories.md#us-011-deploy-queue-resilience)
> **If schema changes:** Re-verify queue state derivation, queue recovery procedure, deploy event log endpoint, and Redis cache invalidation.
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-09-15

```sql
CREATE TABLE deploy_events (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    deploy_id   UUID NOT NULL REFERENCES deploys(id),
    event_type  VARCHAR(50) NOT NULL,
        -- 'deploy.queued', 'deploy.started', 'deploy.building',
        -- 'deploy.deploying', 'deploy.completed', 'deploy.failed',
        -- 'deploy.cancelled', 'deploy.rolled_back'
    payload     JSONB NOT NULL DEFAULT '{}',
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Append-only: no UPDATE or DELETE
REVOKE UPDATE, DELETE ON deploy_events FROM pave_app;

CREATE INDEX idx_deploy_events_deploy ON deploy_events (deploy_id, created_at);
CREATE INDEX idx_deploy_events_type ON deploy_events (event_type, created_at);
```

**Why event-sourced?** The mutable `deploy_queue` table was locked for 4 hours during the RBAC migration (BUG-003). Event sourcing eliminates mutable queue state — the queue is derived from events. Table locks on an append-only table don't block reads of already-written events.

See [tech design: event-sourced queue](tech-design-event-sourced-queue.md) for the derivation algorithm and recovery procedure.

---

### roles

RBAC: role × team × environment (ADR-006).

> **Read by:** [`GET /access/{team}`](api-spec.md#get-accessteam), RBAC middleware (every API request)
> **Written by:** [`POST /access/{team}/grant`](api-spec.md#post-accessteamgrant), [`DELETE /access/{team}/revoke`](api-spec.md#delete-accessteamrevoke)
> **Stories:** [US-009](../product/user-stories.md#us-009-rbac-per-team-x-environment)
> **If schema changes:** Re-verify RBAC enforcement middleware, role grant/revoke endpoints, audit log for role changes, and SOC2 audit queries.
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-09-01

```sql
CREATE TABLE roles (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL,
    team_id     UUID NOT NULL REFERENCES teams(id),
    environment VARCHAR(20) NOT NULL,           -- 'dev', 'staging', 'production'
    role        VARCHAR(20) NOT NULL,           -- 'viewer', 'deployer', 'approver', 'admin'
    granted_by  UUID NOT NULL,
    granted_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    revoked_at  TIMESTAMPTZ,                    -- soft revocation
    UNIQUE(user_id, team_id, environment) WHERE revoked_at IS NULL
);

CREATE INDEX idx_roles_user ON roles (user_id) WHERE revoked_at IS NULL;
CREATE INDEX idx_roles_team_env ON roles (team_id, environment) WHERE revoked_at IS NULL;
```

**Partial unique constraint:** Only one active role per user/team/environment. Revoked roles keep their history for audit trail but don't conflict with new grants.

**Role check (in RBAC middleware):**
```sql
SELECT role FROM roles
WHERE user_id = $user_id
  AND team_id = (SELECT team_id FROM services WHERE name = $service_name)
  AND environment = $environment
  AND revoked_at IS NULL;
```

---

### audit_log

Immutable, append-only audit trail (ADR-007).

> **Read by:** [`GET /audit/log`](api-spec.md#get-auditlog), [Dashboard: Audit Log](../experience/dashboard-specs.md#audit-log-view)
> **Written by:** All Pave components (on every auditable action)
> **Stories:** [US-008](../product/user-stories.md#us-008-full-deploy-audit-trail)
> **If schema changes:** Re-verify audit log query endpoint, dashboard audit log view, SOC2 audit export, and all audit log write points across services.
> **Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-09-01

```sql
CREATE TABLE audit_log (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    actor_id      UUID NOT NULL,
    actor_name    VARCHAR(255) NOT NULL,          -- denormalized for query independence
    action        VARCHAR(50) NOT NULL,
        -- 'deploy.queued', 'deploy.completed', 'deploy.failed', 'deploy.rolled_back',
        -- 'canary.started', 'canary.promoted', 'canary.aborted',
        -- 'rbac.granted', 'rbac.revoked',
        -- 'drift.detected', 'drift.resolved',
        -- 'secret.rotated', 'secret.expired_alert',
        -- 'approval.requested', 'approval.approved', 'approval.rejected', 'approval.escalated'
    resource_type VARCHAR(50) NOT NULL,           -- 'deploy', 'service', 'role', 'drift', 'secret', 'approval'
    resource_id   VARCHAR(255) NOT NULL,
    metadata      JSONB,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Append-only: no UPDATE or DELETE
REVOKE UPDATE, DELETE ON audit_log FROM pave_app;

CREATE INDEX idx_audit_action ON audit_log (action, created_at);
CREATE INDEX idx_audit_actor ON audit_log (actor_id, created_at);
CREATE INDEX idx_audit_resource ON audit_log (resource_type, resource_id, created_at);
CREATE INDEX idx_audit_created ON audit_log (created_at);
```

**Denormalized `actor_name`:** Audit log queries should not join to a user table. If an actor is renamed or deleted, the audit log still shows the name at the time of the action.

**Metadata JSONB examples:**
```json
// deploy.completed
{ "service": "checkout-api", "environment": "production", "commit_sha": "abc123f", "deploy_type": "feature", "duration_seconds": 125 }

// rbac.granted
{ "team": "falcon", "environment": "production", "role": "deployer", "user_name": "New Engineer" }

// secret.rotated
{ "secret_path": "secret/data/pave/checkout-api/production", "key": "redis-password", "old_version": 5, "new_version": 6 }
```

---

## Drift & Canary Tables

### drift_events

Records every detected drift (ADR-002).

> **Read by:** [`GET /drift/status`](api-spec.md#get-driftstatus), [`GET /drift/{id}`](api-spec.md#get-driftid), [`GET /drift/history`](api-spec.md#get-drifthistory)
> **Written by:** Drift Detector (on mismatch), [`POST /drift/{id}/resolve`](api-spec.md#post-driftidresolve)
> **Stories:** [US-003](../product/user-stories.md#us-003-drift-detection)
> **If schema changes:** Re-verify drift status endpoint, drift resolution flow, deploy pause logic, and Slack alert formatting.
> **Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-07-15

```sql
CREATE TABLE drift_events (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    service_name    VARCHAR(100) NOT NULL,
    environment     VARCHAR(20) NOT NULL,
    expected_state  JSONB NOT NULL,               -- fingerprint from Pave's last deploy
    actual_state    JSONB NOT NULL,               -- fingerprint from K8s API
    diff_summary    TEXT NOT NULL,
    detected_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    resolved_at     TIMESTAMPTZ,
    resolved_by     UUID,
    resolution_action VARCHAR(20)                 -- 'accept', 'revert'
);

CREATE INDEX idx_drift_service ON drift_events (service_name, environment);
CREATE INDEX idx_drift_unresolved ON drift_events (detected_at) WHERE resolved_at IS NULL;
```

**State fingerprint JSONB:**
```json
{
  "image_digest": "sha256:abc...",
  "env_hash": "sha256:def...",
  "replicas": 3,
  "resource_limits": { "cpu": "500m", "memory": "512Mi" }
}
```

---

### canary_sessions

Tracks each canary rollout (ADR-003).

> **Read by:** [`GET /deploys/{id}/canary/metrics`](api-spec.md#get-deploysidcanarymetrics)
> **Written by:** Canary Controller
> **Stories:** [US-004](../product/user-stories.md#us-004-canary-deploy-with-traffic-splitting), [US-005](../product/user-stories.md#us-005-auto-rollback-on-error-threshold)
> **If schema changes:** Re-verify canary metrics endpoint, canary promote/abort endpoints, auto-rollback trigger, and dashboard canary status view.
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-08-01

```sql
CREATE TABLE canary_sessions (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    deploy_id           UUID NOT NULL REFERENCES deploys(id),
    baseline_deploy_id  UUID NOT NULL REFERENCES deploys(id),
    traffic_split       JSONB NOT NULL,           -- {"canary": 5, "baseline": 95}
    status              VARCHAR(20) NOT NULL DEFAULT 'active',
        -- 'active', 'promoted', 'aborted', 'auto_rollback'
    metrics_snapshot    JSONB,                    -- latest metrics comparison
    auto_promote        BOOLEAN NOT NULL DEFAULT TRUE,
    observation_window  INTERVAL NOT NULL DEFAULT '15 minutes',
    checks_passed       INTEGER NOT NULL DEFAULT 0,
    checks_failed       INTEGER NOT NULL DEFAULT 0,
    started_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at        TIMESTAMPTZ,
    abort_reason        TEXT
);

CREATE INDEX idx_canary_deploy ON canary_sessions (deploy_id);
CREATE INDEX idx_canary_active ON canary_sessions (status) WHERE status = 'active';
```

**`metrics_snapshot` JSONB:**
```json
{
  "canary": { "error_rate": 0.012, "p99_latency_ms": 145, "request_count": 523 },
  "baseline": { "error_rate": 0.008, "p99_latency_ms": 120, "request_count": 9937 },
  "comparison": { "error_rate_ratio": 1.5, "latency_ratio": 1.21, "verdict": "healthy" }
}
```

---

## Approval & Secrets Tables

### approvals

Deploy approval records for PCI-scoped services (ADR-013).

> **Read by:** [`GET /approvals/{id}`](api-spec.md#get-approvalsid), [`GET /approvals`](api-spec.md#get-approvals)
> **Written by:** [`POST /approvals`](api-spec.md#post-approvals) (deploy pipeline), [`POST /approvals/{id}/approve`](api-spec.md#post-approvalsidapprove), [`POST /approvals/{id}/reject`](api-spec.md#post-approvalsidreject)
> **Stories:** [US-016](../product/user-stories.md#us-016-pci-deploy-approval-workflow), [US-017](../product/user-stories.md#us-017-30-minute-sla-on-approvals)
> **If schema changes:** Re-verify approval create/approve/reject endpoints, Slack notification formatting, SLA tracking, escalation logic, and audit log for approval events.
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-11-15

```sql
CREATE TABLE approvals (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    deploy_id       UUID NOT NULL REFERENCES deploys(id),
    gate_type       VARCHAR(20) NOT NULL DEFAULT 'pci',  -- extensible for future gates
    approver_id     UUID,
    status          VARCHAR(20) NOT NULL DEFAULT 'pending',
        -- 'pending', 'approved', 'rejected', 'escalated', 'expired'
    comment         TEXT,
    requested_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    resolved_at     TIMESTAMPTZ,
    escalated_at    TIMESTAMPTZ,
    sla_deadline    TIMESTAMPTZ NOT NULL
);

CREATE INDEX idx_approvals_deploy ON approvals (deploy_id);
CREATE INDEX idx_approvals_pending ON approvals (status, sla_deadline) WHERE status = 'pending';
```

**SLA tracking:** A background job checks pending approvals every minute. If `NOW() > sla_deadline` and status is still `pending`, the approval is escalated: secondary approvers are notified, the Slack channel gets an alert, and `escalated_at` is set.

---

### secret_rotations

Tracks every secret rotation event (ADR-012).

> **Read by:** [`GET /secrets/rotations`](api-spec.md#get-secretsrotations), [`GET /secrets/{service}`](api-spec.md#get-secretsservice)
> **Written by:** [`POST /secrets/{service}/{key}/rotate`](api-spec.md#post-secretsservicekeyrotate), Secrets Engine (on pickup confirmation)
> **Stories:** [US-014](../product/user-stories.md#us-014-secrets-rotation-without-redeploy), [US-015](../product/user-stories.md#us-015-secrets-rotation-audit-trail)
> **If schema changes:** Re-verify rotation endpoint, secrets status endpoint, pickup confirmation logic, and expired secret alerting.
> **Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-10-20

```sql
CREATE TABLE secret_rotations (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    secret_path         VARCHAR(500) NOT NULL,
    secret_key          VARCHAR(100) NOT NULL,
    service_name        VARCHAR(100) NOT NULL,
    old_version         INTEGER NOT NULL,
    new_version         INTEGER NOT NULL,
    rotated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    rotated_by          UUID NOT NULL,
    pickup_confirmed_at TIMESTAMPTZ           -- NULL until sidecar confirms new version
);

CREATE INDEX idx_rotations_service ON secret_rotations (service_name, rotated_at);
CREATE INDEX idx_rotations_unconfirmed ON secret_rotations (rotated_at)
    WHERE pickup_confirmed_at IS NULL;
```

**`pickup_confirmed_at`:** Set when the Secrets Engine polls the sidecar health endpoint and confirms it's running the new secret version. If NULL after 5 minutes, an alert fires (TC-705).

---

## Design Notes

### Why no separate `users` table?

Pave authenticates via corporate SSO. User identity (UUID, name, email) comes from the SSO token. We store `user_id` as a UUID FK but don't maintain a local user table — the SSO directory is the source of truth. The `audit_log` denormalizes `actor_name` so audit queries don't depend on SSO availability.

### Why `service_name` as VARCHAR instead of FK?

The `deploys`, `drift_events`, and `secret_rotations` tables reference services by name (VARCHAR), not by UUID FK. This is intentional: services can be deregistered, but their deploy history, drift events, and rotation records must persist. A FK would require soft-delete on services and complicate cleanup.

### Index strategy

- Partial indexes (e.g., `WHERE revoked_at IS NULL`, `WHERE status = 'pending'`) keep index sizes small for hot-path queries
- Composite indexes on `(service_name, environment)` cover the most common deploy lookup pattern
- The `audit_log` has four indexes because it serves four different query patterns (by action, by actor, by resource, by time)

### Table growth projections

| Table | Growth rate | Partitioning needed? |
|-------|-----------|---------------------|
| deploys | ~500/month (20 teams × ~25 deploys) | Not yet |
| deploy_events | ~2,500/month (~5 events per deploy) | Not yet |
| audit_log | ~5,000/month | Partition by month when > 100K rows (flagged for Round 11) |
| drift_events | ~50/month | No |
| canary_sessions | ~100/month | No |
| approvals | ~30/month (3 PCI services) | No |
| secret_rotations | ~20/month | No |
