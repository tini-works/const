# API Specification — Pave Deploy Platform

Base URL: `https://pave.internal.example.com/api/v1`

All endpoints require HTTPS (mTLS for CLI, OAuth for dashboard). All request/response bodies are JSON. Timestamps are ISO 8601 UTC. IDs are UUIDs.

---

## Authentication

| Client | Auth Method | Details |
|--------|------------|---------|
| CLI | mTLS + API token | Client certificate from `pave auth login` + short-lived bearer token |
| Dashboard | OAuth 2.0 / SSO | Corporate SSO, session-based JWT |
| Slack Bot | Slack OAuth | Bot token, verified via Slack signing secret |
| Internal services | mTLS | Mutual TLS between Pave components |

All requests include `X-Request-Id` header for tracing.

---

## 1. Deploy Lifecycle

### POST /deploys

Create a new deploy request. This enqueues the deploy; execution happens asynchronously.

> **Matches:** [CLI: `pave deploy`](../experience/cli-spec.md#pave-deploy), [Dashboard: Deploy Button](../experience/dashboard-specs.md#deploy-trigger)
> **Proven by:** [TC-101](../quality/test-suites.md#tc-101-atomic-deploy--single-commit), [TC-104](../quality/test-suites.md#tc-104-multi-commit-deploy--rejected), [TC-401](../quality/test-suites.md#tc-401-rbac--team-member-deploys-to-allowed-env), [TC-402](../quality/test-suites.md#tc-402-rbac--team-member-blocked-from-prod)
> **If this changes:** CLI deploy command, dashboard deploy trigger, RBAC enforcement, audit log write, and canary initiation all become suspect.
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-06-20

**Request:**
```json
{
  "service_name": "checkout-api",
  "commit_sha": "abc123f",
  "environment": "production",
  "canary": false,
  "canary_traffic_percent": null
}
```

**Response (201 — queued):**
```json
{
  "id": "uuid",
  "service_name": "checkout-api",
  "commit_sha": "abc123f",
  "environment": "production",
  "status": "queued",
  "deployer": {
    "id": "uuid",
    "name": "Kai Tanaka"
  },
  "queued_at": "2025-09-15T14:30:00Z",
  "deploy_type": null,
  "estimated_duration_seconds": 120
}
```

`deploy_type` is null at queue time — classified after build (ADR-010).

**Response (403 — RBAC denied):**
```json
{
  "error": "permission_denied",
  "message": "You do not have deploy access to checkout-api in production.",
  "required_role": "deployer",
  "team": "falcon",
  "environment": "production"
}
```

**Response (409 — deploy in progress):**
```json
{
  "error": "deploy_in_progress",
  "message": "checkout-api already has an active deploy in production.",
  "active_deploy_id": "uuid",
  "active_deploy_status": "building"
}
```

**Response (422 — invalid commit):**
```json
{
  "error": "invalid_commit",
  "message": "Commit abc123f not found in the repository for checkout-api."
}
```

---

### GET /deploys/{id}

Get deploy details and current status.

> **Matches:** [CLI: `pave status`](../experience/cli-spec.md#pave-status), [Dashboard: Deploy Detail](../experience/dashboard-specs.md#deploy-detail-view)
> **Proven by:** [TC-101](../quality/test-suites.md#tc-101-atomic-deploy--single-commit), [TC-103](../quality/test-suites.md#tc-103-deploy-record--commit-sha-present)
> **If this changes:** CLI status output, dashboard deploy detail view, and canary metrics display become suspect.
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-06-20

**Response (200):**
```json
{
  "id": "uuid",
  "service_name": "checkout-api",
  "commit_sha": "abc123f",
  "environment": "production",
  "status": "deployed",
  "deploy_type": "feature",
  "deployer": {
    "id": "uuid",
    "name": "Kai Tanaka"
  },
  "rollback_target": "def456a",
  "is_rollback": false,
  "queued_at": "2025-09-15T14:30:00Z",
  "started_at": "2025-09-15T14:30:05Z",
  "completed_at": "2025-09-15T14:32:10Z",
  "duration_seconds": 125,
  "canary": null,
  "approval": null
}
```

---

### GET /deploys

List deploys with filters.

> **Matches:** [Dashboard: Deploy Queue](../experience/dashboard-specs.md#deploy-queue-view), [CLI: `pave list`](../experience/cli-spec.md#pave-list)
> **Proven by:** [TC-601](../quality/test-suites.md#tc-601-dashboard--success-rate-calculation)
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-06-20

**Query parameters:**
- `service` — filter by service name
- `environment` — filter by environment
- `status` — filter by status (queued, building, deploying, deployed, failed, rolled_back)
- `team` — filter by team slug
- `deploy_type` — filter by classification (feature, config, infra, trivial)
- `since` — ISO 8601 timestamp, deploys after this time
- `limit` — max results (default 50, max 200)
- `offset` — pagination offset

**Response (200):**
```json
{
  "deploys": [
    {
      "id": "uuid",
      "service_name": "checkout-api",
      "commit_sha": "abc123f",
      "environment": "production",
      "status": "deployed",
      "deploy_type": "feature",
      "deployer": { "id": "uuid", "name": "Kai Tanaka" },
      "completed_at": "2025-09-15T14:32:10Z"
    }
  ],
  "total_count": 142,
  "limit": 50,
  "offset": 0
}
```

---

### POST /deploys/{id}/rollback

Trigger a rollback for a deploy. Creates a new deploy with the rollback target commit.

> **Matches:** [CLI: `pave rollback`](../experience/cli-spec.md#pave-rollback)
> **Proven by:** [TC-102](../quality/test-suites.md#tc-102-rollback--redeploy-previous-commit)
> **If this changes:** CLI rollback command, canary auto-rollback, and rollback target tracking become suspect.
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-06-20

**Request:**
```json
{
  "reason": "Error rate spike after deploy"
}
```

**Response (201):**
```json
{
  "id": "uuid-new-deploy",
  "service_name": "checkout-api",
  "commit_sha": "def456a",
  "environment": "production",
  "status": "queued",
  "is_rollback": true,
  "rollback_of": "uuid-original-deploy",
  "reason": "Error rate spike after deploy"
}
```

**Response (409 — no rollback target):**
```json
{
  "error": "no_rollback_target",
  "message": "This is the first deploy for checkout-api in production. No rollback target exists."
}
```

---

### GET /deploys/{id}/logs

Stream deploy logs (build output, deploy output).

> **Matches:** [CLI: `pave logs`](../experience/cli-spec.md#pave-logs), [Dashboard: Deploy Logs](../experience/dashboard-specs.md#deploy-log-viewer)
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-07-01

**Query parameters:**
- `stream` — if `true`, uses SSE for real-time log streaming
- `phase` — filter by phase (`build`, `deploy`, `verify`)

**Response (200 — non-streaming):**
```json
{
  "deploy_id": "uuid",
  "phases": [
    {
      "phase": "build",
      "started_at": "2025-09-15T14:30:05Z",
      "completed_at": "2025-09-15T14:31:00Z",
      "lines": [
        { "timestamp": "2025-09-15T14:30:05Z", "level": "info", "message": "Building image from commit abc123f" },
        { "timestamp": "2025-09-15T14:30:55Z", "level": "info", "message": "Image built: registry.internal/checkout-api:abc123f" }
      ]
    },
    {
      "phase": "deploy",
      "started_at": "2025-09-15T14:31:00Z",
      "completed_at": "2025-09-15T14:32:10Z",
      "lines": [
        { "timestamp": "2025-09-15T14:31:00Z", "level": "info", "message": "Applying Kubernetes manifests" },
        { "timestamp": "2025-09-15T14:32:05Z", "level": "info", "message": "Rollout complete: 3/3 pods ready" }
      ]
    }
  ]
}
```

---

### GET /deploys/{id}/events

Get the event log for a deploy (event-sourced queue — ADR-008).

> **Proven by:** [TC-503](../quality/test-suites.md#tc-503-queue-state--derived-not-stored)
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-09-15

**Response (200):**
```json
{
  "deploy_id": "uuid",
  "events": [
    { "event_type": "deploy.queued", "payload": { "position": 1 }, "created_at": "2025-09-15T14:30:00Z" },
    { "event_type": "deploy.started", "payload": {}, "created_at": "2025-09-15T14:30:05Z" },
    { "event_type": "deploy.building", "payload": { "image_tag": "abc123f" }, "created_at": "2025-09-15T14:30:06Z" },
    { "event_type": "deploy.deploying", "payload": {}, "created_at": "2025-09-15T14:31:00Z" },
    { "event_type": "deploy.completed", "payload": { "duration_seconds": 125 }, "created_at": "2025-09-15T14:32:10Z" }
  ]
}
```

---

## 2. Service Registry

### GET /services

List all registered services.

> **Matches:** [Dashboard: Service Registry](../experience/dashboard-specs.md#service-registry), [CLI: `pave services`](../experience/cli-spec.md#pave-services)
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-08-15

**Query parameters:**
- `team` — filter by team slug
- `runtime` — filter by runtime (kubernetes, docker-compose, ecs)

**Response (200):**
```json
{
  "services": [
    {
      "id": "uuid",
      "name": "checkout-api",
      "team": { "id": "uuid", "name": "Falcon", "slug": "falcon" },
      "runtime": "kubernetes",
      "pci_scoped": false,
      "current_deploys": {
        "dev": { "commit_sha": "abc123f", "deployed_at": "2025-09-15T10:00:00Z" },
        "staging": { "commit_sha": "abc123f", "deployed_at": "2025-09-15T12:00:00Z" },
        "production": { "commit_sha": "def456a", "deployed_at": "2025-09-14T16:00:00Z" }
      },
      "pave_yaml_hash": "sha256:abc..."
    }
  ],
  "total_count": 42
}
```

---

### GET /services/{name}

Get details for a specific service.

> **Matches:** [Dashboard: Service Detail](../experience/dashboard-specs.md#service-detail-view)
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-08-15

**Response (200):**
```json
{
  "id": "uuid",
  "name": "checkout-api",
  "team": { "id": "uuid", "name": "Falcon", "slug": "falcon" },
  "runtime": "kubernetes",
  "pci_scoped": false,
  "pave_yaml_hash": "sha256:abc...",
  "current_deploys": {
    "production": {
      "deploy_id": "uuid",
      "commit_sha": "def456a",
      "deploy_type": "feature",
      "deployed_at": "2025-09-14T16:00:00Z",
      "deployer": "Kai Tanaka"
    }
  },
  "recent_deploys": 15,
  "success_rate_30d": 0.93,
  "drift_status": "clean",
  "secrets_status": "current"
}
```

---

### PUT /services/{name}/config

Update service configuration (registers or updates the service's `pave.yaml`).

> **Matches:** [CLI: `pave init`](../experience/cli-spec.md#pave-init), [CLI: `pave validate`](../experience/cli-spec.md#pave-validate)
> **Proven by:** [TC-301](../quality/test-suites.md#tc-301-onboarding--k8s-service-via-pave-init), [TC-302](../quality/test-suites.md#tc-302-onboarding--pave-yaml-validation), [TC-303](../quality/test-suites.md#tc-303-onboarding--invalid-pave-yaml-rejected)
> **If this changes:** CLI init/validate commands, service registry, and runtime adapter selection become suspect.
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-08-15

**Request:**
```json
{
  "pave_yaml": "base64-encoded-pave-yaml-content",
  "pave_yaml_hash": "sha256:abc..."
}
```

**Response (200):**
```json
{
  "service_name": "checkout-api",
  "validation": {
    "valid": true,
    "warnings": [
      "canary.thresholds.latency_multiplier is set but latency-based auto-rollback is not yet implemented"
    ]
  },
  "pave_yaml_hash": "sha256:abc...",
  "updated_at": "2025-09-15T14:00:00Z"
}
```

**Response (422 — validation failure):**
```json
{
  "error": "validation_failed",
  "message": "pave.yaml validation failed.",
  "errors": [
    {
      "path": "deploy.health_check",
      "message": "health_check is required. See https://pave.internal/docs/health-checks"
    }
  ]
}
```

---

## 3. Canary Management

### POST /deploys/{id}/canary/start

Start a canary rollout for a queued deploy. Can also be initiated via `POST /deploys` with `canary: true`.

> **Matches:** [CLI: `pave deploy --canary`](../experience/cli-spec.md#pave-deploy---canary), [Dashboard: Canary Status](../experience/dashboard-specs.md#canary-rollout-status)
> **Proven by:** [TC-201](../quality/test-suites.md#tc-201-canary-deploy--5-percent-traffic-split)
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-08-01

**Request:**
```json
{
  "traffic_percent": 5,
  "observation_window_minutes": 15,
  "auto_promote": true
}
```

**Response (200):**
```json
{
  "canary_session_id": "uuid",
  "deploy_id": "uuid",
  "baseline_deploy_id": "uuid",
  "traffic_split": { "canary": 5, "baseline": 95 },
  "status": "active",
  "started_at": "2025-09-15T14:35:00Z",
  "observation_ends_at": "2025-09-15T14:50:00Z",
  "auto_promote": true
}
```

---

### GET /deploys/{id}/canary/metrics

Get real-time canary vs. baseline metrics.

> **Matches:** [Dashboard: Canary Metrics](../experience/dashboard-specs.md#canary-rollout-status), [CLI: `pave canary status`](../experience/cli-spec.md#pave-canary-status)
> **Proven by:** [TC-202](../quality/test-suites.md#tc-202-canary-metrics-comparison--error-rate)
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-08-01

**Response (200):**
```json
{
  "canary_session_id": "uuid",
  "status": "active",
  "traffic_split": { "canary": 5, "baseline": 95 },
  "metrics": {
    "canary": {
      "error_rate": 0.012,
      "p99_latency_ms": 145,
      "request_count": 523,
      "health_check_pass": true
    },
    "baseline": {
      "error_rate": 0.008,
      "p99_latency_ms": 120,
      "request_count": 9937,
      "health_check_pass": true
    },
    "comparison": {
      "error_rate_ratio": 1.5,
      "latency_ratio": 1.21,
      "verdict": "healthy"
    }
  },
  "checks_passed": 8,
  "checks_failed": 0,
  "next_check_at": "2025-09-15T14:43:00Z"
}
```

---

### POST /deploys/{id}/canary/promote

Promote canary to full traffic (100%).

> **Matches:** [CLI: `pave canary promote`](../experience/cli-spec.md#pave-canary-promote)
> **Proven by:** [TC-203](../quality/test-suites.md#tc-203-canary-promote--full-traffic)
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-08-01

**Response (200):**
```json
{
  "canary_session_id": "uuid",
  "status": "promoted",
  "promoted_at": "2025-09-15T14:50:00Z",
  "final_metrics": {
    "error_rate_ratio": 1.2,
    "observation_window_minutes": 15,
    "checks_passed": 15,
    "checks_failed": 0
  }
}
```

---

### POST /deploys/{id}/canary/abort

Abort canary and revert all traffic to baseline.

> **Matches:** [CLI: `pave canary abort`](../experience/cli-spec.md#pave-canary-abort)
> **Proven by:** [TC-204](../quality/test-suites.md#tc-204-canary-abort--traffic-reverted), [TC-205](../quality/test-suites.md#tc-205-canary-auto-rollback--error-threshold-breach)
> **If this changes:** CLI abort command, auto-rollback logic, and canary cleanup become suspect.
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-08-01

**Request:**
```json
{
  "reason": "Manual abort — suspicious latency pattern",
  "auto_triggered": false
}
```

**Response (200):**
```json
{
  "canary_session_id": "uuid",
  "status": "aborted",
  "aborted_at": "2025-09-15T14:42:00Z",
  "reason": "Manual abort — suspicious latency pattern",
  "auto_triggered": false,
  "traffic_reverted": true
}
```

---

## 4. Drift Detection

### GET /drift/status

Get current drift status for all services (or filtered).

> **Matches:** [Dashboard: Drift Status](../experience/dashboard-specs.md#drift-status-view), [CLI: `pave drift`](../experience/cli-spec.md#pave-drift)
> **Proven by:** [TC-105](../quality/test-suites.md#tc-105-drift-detection--image-mismatch), [TC-106](../quality/test-suites.md#tc-106-drift-detection--ssh-mutation)
> **Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-07-15

**Query parameters:**
- `service` — filter by service name
- `status` — `drifted`, `clean`, `paused`
- `team` — filter by team slug

**Response (200):**
```json
{
  "services": [
    {
      "service_name": "checkout-api",
      "environment": "production",
      "status": "clean",
      "last_checked": "2025-09-15T14:30:00Z"
    },
    {
      "service_name": "payments-api",
      "environment": "production",
      "status": "drifted",
      "drift_event_id": "uuid",
      "detected_at": "2025-09-15T13:45:00Z",
      "drift_details": {
        "image_expected": "registry.internal/payments-api:def456a",
        "image_actual": "registry.internal/payments-api:manual-hotfix-789",
        "config_diff": null,
        "replica_diff": null
      },
      "deploy_paused": true
    }
  ]
}
```

---

### GET /drift/{id}

Get details of a specific drift event.

> **Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-07-15

**Response (200):**
```json
{
  "id": "uuid",
  "service_name": "payments-api",
  "environment": "production",
  "expected_state": {
    "image_digest": "sha256:abc...",
    "env_hash": "sha256:def...",
    "replicas": 3,
    "resource_limits": { "cpu": "500m", "memory": "512Mi" }
  },
  "actual_state": {
    "image_digest": "sha256:xyz...",
    "env_hash": "sha256:def...",
    "replicas": 3,
    "resource_limits": { "cpu": "500m", "memory": "512Mi" }
  },
  "diff_summary": "Image digest mismatch. Expected abc..., found xyz...",
  "detected_at": "2025-09-15T13:45:00Z",
  "resolved_at": null,
  "resolved_by": null,
  "resolution_action": null
}
```

---

### POST /drift/{id}/resolve

Resolve a drift event. Accept the drift (update Pave's expected state) or revert it (redeploy).

> **Matches:** [CLI: `pave drift resolve`](../experience/cli-spec.md#pave-drift-resolve), [Dashboard: Drift Resolution](../experience/dashboard-specs.md#drift-status-view)
> **If this changes:** CLI drift resolve, deploy pause/resume logic, and drift audit trail become suspect.
> **Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-07-15

**Request:**
```json
{
  "action": "accept",
  "reason": "Manual TLS cert update during Saturday night incident. Cert is correct."
}
```

`action` is `accept` or `revert`. If `revert`, a new deploy is created automatically.

**Response (200):**
```json
{
  "drift_event_id": "uuid",
  "resolved_at": "2025-09-15T14:00:00Z",
  "resolved_by": "Sasha Petrov",
  "action": "accept",
  "deploy_resumed": true,
  "new_deploy_id": null
}
```

---

### GET /drift/history

Historical drift events.

> **Matches:** [Dashboard: Drift History](../experience/dashboard-specs.md#drift-status-view)
> **Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-07-15

**Query parameters:**
- `service` — filter by service name
- `since` — ISO 8601 timestamp
- `limit` — max results (default 50)

**Response (200):**
```json
{
  "events": [
    {
      "id": "uuid",
      "service_name": "payments-api",
      "diff_summary": "Image digest mismatch",
      "detected_at": "2025-09-15T13:45:00Z",
      "resolved_at": "2025-09-15T14:00:00Z",
      "resolution_action": "accept"
    }
  ],
  "total_count": 7
}
```

---

## 5. RBAC & Access Control

### GET /access/{team}

Get roles for a team.

> **Matches:** [Dashboard: Team Access](../experience/dashboard-specs.md#team-access-management)
> **Proven by:** [TC-401](../quality/test-suites.md#tc-401-rbac--team-member-deploys-to-allowed-env)
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-09-01

**Response (200):**
```json
{
  "team": { "id": "uuid", "name": "Falcon", "slug": "falcon" },
  "roles": [
    {
      "user_id": "uuid",
      "user_name": "Kai Tanaka",
      "environment": "production",
      "role": "deployer",
      "granted_by": "Marcus Chen",
      "granted_at": "2025-08-20T10:00:00Z"
    },
    {
      "user_id": "uuid",
      "user_name": "New Intern",
      "environment": "dev",
      "role": "deployer",
      "granted_by": "Marcus Chen",
      "granted_at": "2025-09-01T10:00:00Z"
    }
  ]
}
```

---

### POST /access/{team}/grant

Grant a role to a user for a team and environment.

> **Matches:** [Dashboard: Grant Access](../experience/dashboard-specs.md#team-access-management)
> **Proven by:** [TC-405](../quality/test-suites.md#tc-405-rbac--role-change-audited)
> **If this changes:** RBAC enforcement across all deploy endpoints, dashboard access management, and audit log become suspect.
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-09-01

**Request:**
```json
{
  "user_id": "uuid",
  "environment": "staging",
  "role": "deployer"
}
```

**Response (200):**
```json
{
  "role_id": "uuid",
  "user_id": "uuid",
  "team": "falcon",
  "environment": "staging",
  "role": "deployer",
  "granted_by": "Marcus Chen",
  "granted_at": "2025-09-15T10:00:00Z"
}
```

**Response (403):**
```json
{
  "error": "permission_denied",
  "message": "Only team admins or platform admins can grant roles."
}
```

---

### DELETE /access/{team}/revoke

Revoke a role.

> **Proven by:** [TC-405](../quality/test-suites.md#tc-405-rbac--role-change-audited)
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-09-01

**Request:**
```json
{
  "user_id": "uuid",
  "environment": "production",
  "role": "deployer"
}
```

**Response (200):**
```json
{
  "revoked": true,
  "user_id": "uuid",
  "team": "falcon",
  "environment": "production",
  "role": "deployer",
  "revoked_by": "Marcus Chen",
  "revoked_at": "2025-09-15T10:05:00Z"
}
```

---

## 6. Audit Log

### GET /audit/log

Query the immutable audit log.

> **Matches:** [Dashboard: Audit Log](../experience/dashboard-specs.md#audit-log-view)
> **Proven by:** [TC-406](../quality/test-suites.md#tc-406-audit-log--deploy-event-recorded), [TC-407](../quality/test-suites.md#tc-407-audit-log--immutability)
> **Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-09-01

**Query parameters:**
- `actor` — filter by actor name or ID
- `action` — filter by action type (e.g., `deploy.completed`, `rbac.granted`)
- `resource_type` — filter by resource type (deploy, service, role, drift, secret, approval)
- `resource_id` — filter by specific resource
- `since` / `until` — time range
- `limit` — max results (default 100, max 1000)
- `offset` — pagination offset

**Response (200):**
```json
{
  "entries": [
    {
      "id": "uuid",
      "actor_id": "uuid",
      "actor_name": "Kai Tanaka",
      "action": "deploy.completed",
      "resource_type": "deploy",
      "resource_id": "uuid",
      "metadata": {
        "service": "checkout-api",
        "environment": "production",
        "commit_sha": "abc123f",
        "deploy_type": "feature",
        "duration_seconds": 125
      },
      "created_at": "2025-09-15T14:32:10Z"
    }
  ],
  "total_count": 4521,
  "limit": 100,
  "offset": 0
}
```

---

## 7. Secrets Management

### GET /secrets/{service}

Get secrets metadata for a service (paths, versions, rotation status — NOT secret values).

> **Matches:** [Dashboard: Secrets Status](../experience/dashboard-specs.md#secrets-rotation-status), [CLI: `pave secrets list`](../experience/cli-spec.md#pave-secrets-list)
> **Proven by:** [TC-702](../quality/test-suites.md#tc-702-secrets-injection--sidecar-mounts-vault-secret)
> **Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-10-20

**Response (200):**
```json
{
  "service_name": "checkout-api",
  "secrets": [
    {
      "vault_path": "secret/data/pave/checkout-api/production",
      "keys": ["redis-password", "db-url", "stripe-key"],
      "current_version": 5,
      "last_rotated": "2025-09-01T10:00:00Z",
      "rotated_by": "Sasha Petrov",
      "pickup_status": "confirmed",
      "pickup_confirmed_at": "2025-09-01T10:02:30Z"
    }
  ]
}
```

---

### POST /secrets/{service}/{key}/rotate

Rotate a specific secret for a service.

> **Matches:** [CLI: `pave secrets rotate`](../experience/cli-spec.md#pave-secrets-rotate)
> **Proven by:** [TC-701](../quality/test-suites.md#tc-701-secrets-rotation--zero-downtime), [TC-703](../quality/test-suites.md#tc-703-secrets-rotation--rolling-restart)
> **If this changes:** Vault integration, sidecar restart logic, rotation audit trail, and expired secret alerting all become suspect.
> **Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-10-20

**Request:**
```json
{
  "new_value": "base64-encoded-new-secret-value",
  "affected_services": ["checkout-api", "cart-api"]
}
```

**Response (200):**
```json
{
  "rotation_id": "uuid",
  "secret_path": "secret/data/pave/checkout-api/production",
  "key": "redis-password",
  "old_version": 5,
  "new_version": 6,
  "affected_services": [
    {
      "service": "checkout-api",
      "pickup_status": "pending",
      "sidecar_restart_initiated": true
    },
    {
      "service": "cart-api",
      "pickup_status": "pending",
      "sidecar_restart_initiated": true
    }
  ],
  "rotated_at": "2025-09-15T10:00:00Z"
}
```

---

### GET /secrets/rotations

Get rotation history.

> **Proven by:** [TC-704](../quality/test-suites.md#tc-704-secrets-audit--rotation-event-recorded)
> **Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-10-20

**Query parameters:**
- `service` — filter by service name
- `since` — ISO 8601 timestamp
- `limit` — max results (default 50)

**Response (200):**
```json
{
  "rotations": [
    {
      "id": "uuid",
      "secret_path": "secret/data/pave/checkout-api/production",
      "key": "redis-password",
      "old_version": 5,
      "new_version": 6,
      "rotated_at": "2025-09-15T10:00:00Z",
      "rotated_by": "Sasha Petrov",
      "affected_services": ["checkout-api", "cart-api"],
      "all_pickups_confirmed": true
    }
  ],
  "total_count": 12
}
```

---

## 8. Approval Workflows

### POST /approvals

Create an approval request (usually called by the deploy pipeline, not directly by users).

> **Matches:** [Dashboard: Pending Approvals](../experience/dashboard-specs.md#pending-approval-queue)
> **Proven by:** [TC-801](../quality/test-suites.md#tc-801-pci-deploy--approval-required-before-prod)
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-11-15

**Request:**
```json
{
  "deploy_id": "uuid",
  "gate_type": "pci",
  "approvers": ["uuid-security-lead", "uuid-security-engineer"],
  "sla_minutes": 30
}
```

**Response (201):**
```json
{
  "id": "uuid",
  "deploy_id": "uuid",
  "gate_type": "pci",
  "status": "pending",
  "requested_at": "2025-09-15T14:00:00Z",
  "sla_deadline": "2025-09-15T14:30:00Z",
  "approvers": [
    { "id": "uuid", "name": "Security Lead", "notified": true }
  ]
}
```

---

### GET /approvals/{id}

Get approval details.

> **Matches:** [Dashboard: Approval Detail](../experience/dashboard-specs.md#pending-approval-queue)
> **Proven by:** [TC-802](../quality/test-suites.md#tc-802-pci-approval--approve-flow), [TC-804](../quality/test-suites.md#tc-804-pci-approval--sla-tracking)
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-11-15

**Response (200):**
```json
{
  "id": "uuid",
  "deploy_id": "uuid",
  "deploy_summary": {
    "service": "payments-api",
    "commit_sha": "abc123f",
    "environment": "production",
    "deployer": "Kai Tanaka",
    "deploy_type": "feature"
  },
  "gate_type": "pci",
  "status": "pending",
  "requested_at": "2025-09-15T14:00:00Z",
  "sla_deadline": "2025-09-15T14:30:00Z",
  "sla_remaining_seconds": 1200,
  "approvers": [
    { "id": "uuid", "name": "Security Lead", "notified": true, "responded": false }
  ],
  "comment": null
}
```

---

### POST /approvals/{id}/approve

Approve a deploy.

> **Proven by:** [TC-802](../quality/test-suites.md#tc-802-pci-approval--approve-flow)
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-11-15

**Request:**
```json
{
  "comment": "Reviewed diff — no PCI-impacting changes. Approved."
}
```

**Response (200):**
```json
{
  "id": "uuid",
  "status": "approved",
  "approved_by": { "id": "uuid", "name": "Security Lead" },
  "comment": "Reviewed diff — no PCI-impacting changes. Approved.",
  "resolved_at": "2025-09-15T14:15:00Z",
  "deploy_resumed": true
}
```

---

### POST /approvals/{id}/reject

Reject a deploy.

> **Proven by:** [TC-803](../quality/test-suites.md#tc-803-pci-approval--reject-flow)
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-11-15

**Request:**
```json
{
  "comment": "This changes the card tokenization flow. Needs security review meeting first."
}
```

**Response (200):**
```json
{
  "id": "uuid",
  "status": "rejected",
  "rejected_by": { "id": "uuid", "name": "Security Lead" },
  "comment": "This changes the card tokenization flow. Needs security review meeting first.",
  "resolved_at": "2025-09-15T14:20:00Z",
  "deploy_cancelled": true
}
```

---

### GET /approvals

List pending and recent approvals.

> **Matches:** [Dashboard: Pending Approvals](../experience/dashboard-specs.md#pending-approval-queue)
> **Proven by:** [TC-805](../quality/test-suites.md#tc-805-pci-approval--escalation-after-30-min)
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-11-15

**Query parameters:**
- `status` — `pending`, `approved`, `rejected`, `escalated`, `expired`
- `gate_type` — `pci` (future: `hipaa`, `sox`)
- `since` — ISO 8601 timestamp
- `limit` — max results (default 20)

**Response (200):**
```json
{
  "approvals": [
    {
      "id": "uuid",
      "deploy_id": "uuid",
      "service": "payments-api",
      "gate_type": "pci",
      "status": "pending",
      "requested_at": "2025-09-15T14:00:00Z",
      "sla_deadline": "2025-09-15T14:30:00Z"
    }
  ],
  "total_count": 3
}
```

---

## 9. Deploy Metrics

### GET /metrics/deploys

Aggregate deploy metrics (DORA-style).

> **Matches:** [Dashboard: Deploy Health](../experience/dashboard-specs.md#deploy-health-dashboard)
> **Proven by:** [TC-601](../quality/test-suites.md#tc-601-dashboard--success-rate-calculation)
> **If this changes:** Deploy health dashboard, team metrics view, and classification engine become suspect.
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-10-01

**Query parameters:**
- `team` — filter by team slug (omit for org-wide)
- `period` — `7d`, `30d`, `90d` (default 30d)
- `deploy_type` — filter by classification

**Response (200):**
```json
{
  "period": "30d",
  "team": null,
  "metrics": {
    "total_deploys": 342,
    "by_type": {
      "feature": 198,
      "config": 67,
      "infra": 42,
      "trivial": 35
    },
    "success_rate": 0.94,
    "substantive_frequency_per_week": 22.3,
    "mean_lead_time_hours": 4.2,
    "mean_time_to_recovery_minutes": 8.5,
    "change_failure_rate": 0.06,
    "rollback_count": 18
  }
}
```

---

### GET /metrics/health/{team}

Get deploy health for a specific team.

> **Matches:** [Dashboard: Team Deploy Metrics](../experience/dashboard-specs.md#team-deploy-metrics)
> **Proven by:** [TC-601](../quality/test-suites.md#tc-601-dashboard--success-rate-calculation)
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-10-01

**Response (200):**
```json
{
  "team": { "id": "uuid", "name": "Falcon", "slug": "falcon" },
  "period": "30d",
  "services": [
    {
      "service_name": "checkout-api",
      "deploys": 28,
      "success_rate": 0.96,
      "mean_deploy_duration_seconds": 130,
      "rollbacks": 1,
      "last_incident": null
    },
    {
      "service_name": "inventory-api",
      "deploys": 15,
      "success_rate": 0.87,
      "mean_deploy_duration_seconds": 95,
      "rollbacks": 2,
      "last_incident": "2025-09-10T16:00:00Z"
    }
  ],
  "team_health_score": "good"
}
```

---

## 10. Queue Management

### GET /queue

Get current deploy queue state (derived from events — ADR-008).

> **Matches:** [Dashboard: Deploy Queue](../experience/dashboard-specs.md#deploy-queue-view)
> **Proven by:** [TC-503](../quality/test-suites.md#tc-503-queue-state--derived-not-stored)
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-09-15

**Response (200):**
```json
{
  "queue": [
    {
      "position": 1,
      "deploy_id": "uuid",
      "service_name": "checkout-api",
      "environment": "production",
      "status": "building",
      "queued_at": "2025-09-15T14:30:00Z",
      "deployer": "Kai Tanaka"
    },
    {
      "position": 2,
      "deploy_id": "uuid",
      "service_name": "cart-api",
      "environment": "staging",
      "status": "queued",
      "queued_at": "2025-09-15T14:31:00Z",
      "deployer": "New Intern"
    }
  ],
  "depth": 2,
  "oldest_queued_seconds": 120
}
```

---

### POST /queue/pause

Pause the deploy queue (global or per service).

> **Matches:** [CLI: `pave queue pause`](../experience/cli-spec.md#pave-queue-pause)
> **Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-09-15

**Request:**
```json
{
  "service": "checkout-api",
  "environment": "production",
  "reason": "Investigating drift event"
}
```

**Response (200):**
```json
{
  "paused": true,
  "scope": "checkout-api/production",
  "reason": "Investigating drift event",
  "paused_by": "Sasha Petrov",
  "paused_at": "2025-09-15T14:00:00Z"
}
```

---

### POST /queue/resume

Resume the deploy queue.

> **Matches:** [CLI: `pave queue resume`](../experience/cli-spec.md#pave-queue-resume)
> **Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-09-15

**Request:**
```json
{
  "service": "checkout-api",
  "environment": "production"
}
```

**Response (200):**
```json
{
  "resumed": true,
  "scope": "checkout-api/production",
  "resumed_by": "Sasha Petrov",
  "resumed_at": "2025-09-15T14:15:00Z",
  "queued_deploys_released": 1
}
```

---

## 11. Bypass (Break-Glass)

### POST /bypass/sync

Sync bypass records after Pave recovers from an outage (ADR-009).

> **Matches:** [CLI: `pave bypass sync`](../experience/cli-spec.md#pave-bypass-sync)
> **Proven by:** [TC-501](../quality/test-suites.md#tc-501-break-glass--manual-deploy-when-pave-is-down)
> **Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-09-15

**Request:**
```json
{
  "bypass_records": [
    {
      "service_name": "payments-api",
      "commit_sha": "hotfix-789",
      "environment": "production",
      "bypassed_at": "2025-09-15T02:15:00Z",
      "reason": "P1 fix — payment processor TLS cert expired. Pave was down.",
      "commands_executed": [
        "kubectl set image deployment/payments-api payments-api=registry.internal/payments-api:hotfix-789"
      ]
    }
  ]
}
```

**Response (200):**
```json
{
  "synced": 1,
  "deploy_records_created": [
    {
      "deploy_id": "uuid",
      "service_name": "payments-api",
      "is_bypass": true,
      "drift_event_created": true
    }
  ]
}
```
