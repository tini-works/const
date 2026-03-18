# Monitoring & Alerting — Pave Deploy Platform

Last updated: 2025-12-01
Owner: Sasha Petrov (DevOps/SRE)

### Traceability — Operations as Last Line of Proof

Every monitor exists to watch an architecture component, prove a product requirement is met in production, or detect a quality failure at runtime. This section maps the full chain.

| Alert / Monitor | Watches (architecture) | Proves (product) | Detects (quality) |
|-----------------|----------------------|-------------------|-------------------|
| **Pave API Down** | [Pave API](../architecture/architecture.md#pave-api) | [US-001 atomic deploys](../product/user-stories.md#us-001-atomic-single-commit-deploys) — platform must be available for teams to deploy | [TC-101 atomic deploy](../quality/test-suites.md#tc-101-atomic-deploy--single-commit) — impossible to verify if API is down |
| **Deploy Engine Down** | [Deploy Engine](../architecture/architecture.md#deploy-engine) | [US-001](../product/user-stories.md#us-001-atomic-single-commit-deploys), [US-002 instant rollback](../product/user-stories.md#us-002-instant-rollback-under-2-minutes) — deploys and rollbacks stall | [TC-103 rollback under 2 min](../quality/test-suites.md#tc-103-rollback--completes-under-2-minutes) failing in prod |
| **Deploy Queue Depth High** | [Deploy Engine](../architecture/architecture.md#deploy-engine), [ADR-008 event-sourced queue](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery) | [US-001](../product/user-stories.md#us-001-atomic-single-commit-deploys) — deploys are backing up | [BUG-003 queue corruption](../quality/bug-reports.md#bug-003-deploy-queue-corruption-during-rbac-migration) recurrence |
| **Deploy Duration High (p95)** | [Deploy Engine](../architecture/architecture.md#deploy-engine) | [US-001](../product/user-stories.md#us-001-atomic-single-commit-deploys) — deploy pipeline is slow | Deploy performance degradation in production |
| **Deploy Failure Rate High** | [Deploy Engine](../architecture/architecture.md#deploy-engine), [Pave API](../architecture/architecture.md#pave-api) | [US-001](../product/user-stories.md#us-001-atomic-single-commit-deploys) — deploys are failing | [TC-101](../quality/test-suites.md#tc-101-atomic-deploy--single-commit) through [TC-106](../quality/test-suites.md#tc-106-drift-detection--ssh-mutation) regression in prod |
| **Drift Detected** | [Drift Detector](../architecture/architecture.md#drift-detector), [ADR-002 state fingerprinting](../architecture/adrs.md#adr-002-drift-detection-via-state-fingerprinting) | [US-003 drift detection](../product/user-stories.md#us-003-drift-detection) — production diverged from expected state | [TC-105 drift detection after manual change](../quality/test-suites.md#tc-105-drift-detection--manual-kubectl-change), [TC-106 SSH mutation](../quality/test-suites.md#tc-106-drift-detection--ssh-mutation) |
| **Canary Error Rate Threshold** | [Canary Controller](../architecture/architecture.md#canary-controller), [ADR-003](../architecture/adrs.md#adr-003-canary-deploy-via-weighted-traffic-splitting) | [US-004 canary deploy](../product/user-stories.md#us-004-canary-deploy-with-traffic-splitting) — canary is seeing elevated errors | [TC-201 canary traffic split](../quality/test-suites.md#tc-201-canary-deploy--5-percent-traffic-split), [TC-205 auto-rollback](../quality/test-suites.md#tc-205-canary-auto-rollback--error-threshold-breach) |
| **Canary Auto-Rollback Triggered** | [Canary Controller](../architecture/architecture.md#canary-controller), [ADR-003](../architecture/adrs.md#adr-003-canary-deploy-via-weighted-traffic-splitting) | [US-005 auto-rollback on error threshold](../product/user-stories.md#us-005-auto-rollback-on-error-threshold) — safety net worked | [TC-205](../quality/test-suites.md#tc-205-canary-auto-rollback--error-threshold-breach) firing in production |
| **DB Connection Pool Utilization** | [PostgreSQL](../architecture/architecture.md#database) | [US-001](../product/user-stories.md#us-001-atomic-single-commit-deploys) — database saturation slows all deploys | Database performance degradation |
| **Redis Connection Failures** | [Redis Cache](../architecture/architecture.md#redis-cache) | [US-012 deploy health dashboard](../product/user-stories.md#us-012-deploy-health-dashboard) — dashboard data stale | Cache failure in production |
| **Vault Health / Seal Status** | [Vault Integration](../architecture/architecture.md#vault-integration), [ADR-011](../architecture/adrs.md#adr-011-runtime-secrets-injection-via-sidecar) | [US-014 secrets rotation without redeploy](../product/user-stories.md#us-014-secrets-rotation-without-redeploy) — new deploys can't get secrets | [TC-701 secrets rotation zero downtime](../quality/test-suites.md#tc-701-secrets-rotation--zero-downtime) impossible if Vault is sealed |
| **Secret Rotation Failure** | [Secrets Engine](../architecture/architecture.md#secrets-engine), [ADR-012 rotation event bus](../architecture/adrs.md#adr-012-secrets-rotation-event-bus) | [US-014](../product/user-stories.md#us-014-secrets-rotation-without-redeploy), [US-015 rotation audit trail](../product/user-stories.md#us-015-secrets-rotation-audit-trail) | [TC-703 rotation event published](../quality/test-suites.md#tc-703-rotation-event-published-to-consumers), [TC-705 alert on expired secret](../quality/test-suites.md#tc-705-alert--service-using-expired-secret) |
| **Approval SLA Breach** | [Approval Service](../architecture/architecture.md#approval-service), [ADR-013](../architecture/adrs.md#adr-013-approval-gate-middleware-pattern) | [US-017 30-minute SLA on approvals](../product/user-stories.md#us-017-30-minute-sla-on-approvals) — approval taking too long | [TC-805 escalation after 30 min](../quality/test-suites.md#tc-805-pci-approval--escalation-after-30-min) |
| **Audit Log Write Failure** | [PostgreSQL audit_log](../architecture/architecture.md#database), [ADR-007 immutable audit log](../architecture/adrs.md#adr-007-immutable-audit-log-architecture) | [US-008 full deploy audit trail](../product/user-stories.md#us-008-full-deploy-audit-trail) — SOC2 compliance broken if audit fails | [TC-406 deploy event recorded](../quality/test-suites.md#tc-406-audit-log--deploy-event-recorded) |
| **Pave Self-Deploy Status** | [Pave API](../architecture/architecture.md#pave-api), [Deploy Engine](../architecture/architecture.md#deploy-engine) | All — if Pave can't deploy itself, confidence in the platform is zero | All TC-* — if we can't self-deploy, we can't ship fixes |
| **Confirmed by** | Sasha Petrov (DevOps/SRE), 2025-12-01 — verified all alert conditions fire correctly in staging, confirmed Watches/Proves/Detects references match current architecture and product docs |

**Runbook links:** Each P0/P1 alert fires a runbook — see [Alert Rules](#alert-rules) below for runbook references.

---

## Monitoring Stack

| Component | Tool | Purpose |
|-----------|------|---------|
| Metrics | Prometheus + Grafana | Time-series metrics, dashboards |
| Logs | Loki | Centralized log aggregation |
| Tracing | OpenTelemetry + Jaeger | Distributed request tracing |
| Alerting | Grafana Alerting / PagerDuty | Alert routing and escalation |

No external uptime monitor — Pave is internal-only. Synthetic health checks run from a CronJob outside `pave-system` namespace.

---

## Dashboards

### D1: Pave Operations Overview

The first dashboard anyone looks at. Shows platform health at a glance.

**Panels:**

| Panel | Type | Data Source | Query/Metric |
|-------|------|-------------|--------------|
| System Status | Stat (green/red per component) | Prometheus | `up{namespace="pave-system"}` by deployment |
| API Request Rate | Time series | Prometheus | `rate(pave_api_requests_total[5m])` |
| API Error Rate | Time series | Prometheus | `rate(pave_api_requests_total{status=~"5.."}[5m]) / rate(pave_api_requests_total[5m])` |
| API Latency (p95) | Time series | Prometheus | `histogram_quantile(0.95, rate(pave_api_request_duration_seconds_bucket[5m]))` |
| Active Deploys | Gauge | Prometheus | `pave_deploys_active` |
| Deploy Queue Depth | Gauge | Prometheus | `pave_deploy_queue_depth` |

### D2: Deploy Pipeline Dashboard

| Panel | Type | Metric |
|-------|------|--------|
| Deploys Today | Counter | `pave_deploys_total{date="today"}` by status |
| Deploy Duration (p95) | Time series | `histogram_quantile(0.95, rate(pave_deploy_duration_seconds_bucket[1h]))` |
| Deploy Failure Rate | Gauge (%) | `rate(pave_deploys_total{status="failed"}[1h]) / rate(pave_deploys_total[1h])` |
| Deploy Success Rate (7-day) | Stat | `pave_deploys_total{status="success"} / pave_deploys_total` over 7d |
| Queue Wait Time (p95) | Time series | `histogram_quantile(0.95, rate(pave_deploy_queue_wait_seconds_bucket[1h]))` |
| Rollbacks Today | Counter | `pave_rollbacks_total{date="today"}` |
| Deploy by Team | Bar chart | `pave_deploys_total` by team |
| Deploy Classification | Pie chart | `pave_deploys_total` by classification (substantive/non-substantive) |

### D3: Drift Detection Dashboard

| Panel | Type | Metric |
|-------|------|--------|
| Drift Events (24h) | Counter | `pave_drift_detected_total` over 24h |
| Drift by Type | Bar chart | `pave_drift_detected_total` by drift_type (image, config, replica, resource) |
| Drift Resolution Status | Table | `pave_drift_events` by status (open, acknowledged, resolved) |
| Time to Resolution (median) | Stat | `histogram_quantile(0.5, pave_drift_resolution_seconds_bucket)` |
| Reconciliation Loop Latency | Time series | `pave_drift_reconcile_duration_seconds` |

### D4: Canary Monitoring Dashboard

| Panel | Type | Metric |
|-------|------|--------|
| Active Canaries | Table | `pave_canary_active` by service, team, traffic_pct |
| Canary vs Baseline Error Rate | Time series (overlay) | `pave_canary_error_rate` vs `pave_canary_baseline_error_rate` |
| Canary vs Baseline Latency | Time series (overlay) | `pave_canary_latency_p95` vs `pave_canary_baseline_latency_p95` |
| Auto-Rollbacks (7d) | Counter | `pave_canary_rollback_total` over 7d |
| Canary Promotions (7d) | Counter | `pave_canary_promoted_total` over 7d |
| Traffic Split Actual vs Configured | Gauge | Istio telemetry vs Pave configured weight |

### D5: Secrets & Vault Dashboard

| Panel | Type | Metric |
|-------|------|--------|
| Vault Status | Stat (green/red) | `vault_health_status` |
| Vault Response Time | Time series | `pave_vault_request_duration_seconds` |
| Secret Rotation Events (30d) | Counter | `pave_secret_rotation_total` over 30d by status |
| Services Using Expired Secrets | Table | `pave_secret_expired_in_use` by service |
| Sidecar Injection Failures | Counter | `pave_sidecar_injection_failure_total` |
| Secret Lease Expiry Countdown | Table | `pave_secret_lease_remaining_seconds` by secret path, sorted ascending |

### D6: Approval Pipeline Dashboard

| Panel | Type | Metric |
|-------|------|--------|
| Pending Approvals | Table | `pave_approval_pending` by service, requester, age |
| Approval Wait Time (p95) | Time series | `histogram_quantile(0.95, rate(pave_approval_wait_seconds_bucket[1h]))` |
| SLA Breaches (7d) | Counter | `pave_approval_sla_breach_total` over 7d |
| Escalations (7d) | Counter | `pave_approval_escalation_total` over 7d |
| Approvals by Approver | Bar chart | `pave_approval_completed_total` by approver |
| Approval Rejection Rate | Gauge (%) | `pave_approval_rejected_total / pave_approval_completed_total` |

---

## Alert Rules

### P0 — Page Immediately (Any Time)

These alerts page the on-call engineer. Response expected within 15 minutes.

| Alert | Condition | Duration | Action |
|-------|-----------|----------|--------|
| **Pave API Down** | `up{job="pave-api"} == 0` | 1 min | Page on-call. See [Runbook: Pave Outage](./runbook-pave-outage.md). **Watches:** [Pave API](../architecture/architecture.md#pave-api). **Proves:** [US-001](../product/user-stories.md#us-001-atomic-single-commit-deploys). Nobody can deploy. |
| **Deploy Engine Down** | `up{job="pave-deploy-engine"} == 0` | 1 min | Page on-call. See [Runbook: Pave Outage](./runbook-pave-outage.md). **Watches:** [Deploy Engine](../architecture/architecture.md#deploy-engine). **Proves:** [US-001](../product/user-stories.md#us-001-atomic-single-commit-deploys), [US-002](../product/user-stories.md#us-002-instant-rollback-under-2-minutes). Deploys are accepted but not executing. |
| **Deploy Queue Corruption** | `pave_deploy_queue_depth > 50 AND rate(pave_deploys_total[10m]) == 0` | 5 min | Page on-call. See [Runbook: Deploy Queue Corruption](./runbook-deploy-queue-corruption.md). **Watches:** [ADR-008](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery). **Caused by:** [BUG-003](../quality/bug-reports.md#bug-003-deploy-queue-corruption-during-rbac-migration). |
| **Audit Log Write Failure** | `pave_audit_log_write_failure_total > 0` | Immediate | Page on-call. SOC2 compliance at risk. **Watches:** [ADR-007](../architecture/adrs.md#adr-007-immutable-audit-log-architecture). **Proves:** [US-008](../product/user-stories.md#us-008-full-deploy-audit-trail). **Detects:** [TC-406](../quality/test-suites.md#tc-406-audit-log--deploy-event-recorded). |
| **Drift Detected** | `pave_drift_detected_total` increase > 0 | Immediate | Page on-call during business hours, Slack outside hours. See [Runbook: Drift Detected](./runbook-drift-detected.md). **Watches:** [ADR-002](../architecture/adrs.md#adr-002-drift-detection-via-state-fingerprinting). **Proves:** [US-003](../product/user-stories.md#us-003-drift-detection). **Detects:** [TC-105](../quality/test-suites.md#tc-105-drift-detection--manual-kubectl-change), [TC-106](../quality/test-suites.md#tc-106-drift-detection--ssh-mutation). |

### P1 — Notify During Business Hours

Alert via Slack #pave-ops. Response expected within 1 hour during business hours.

| Alert | Condition | Duration | Action |
|-------|-----------|----------|--------|
| **Deploy Failure Rate High** | Deploy failure rate > 10% over 30 min | 30 min | **Watches:** [Deploy Engine](../architecture/architecture.md#deploy-engine). **Proves:** [US-001](../product/user-stories.md#us-001-atomic-single-commit-deploys). Check recent deploy logs for common failure pattern. |
| **Deploy Duration High (p95)** | p95 deploy duration > 15 min | 10 min | **Watches:** [Deploy Engine](../architecture/architecture.md#deploy-engine). Check for image pull issues, resource pressure, or slow migrations. |
| **Deploy Queue Depth High** | `pave_deploy_queue_depth > 20` | 10 min | **Watches:** [Deploy Engine](../architecture/architecture.md#deploy-engine), [ADR-008](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery). **Proves:** [US-001](../product/user-stories.md#us-001-atomic-single-commit-deploys). Deploys are backing up — check engine health. |
| **Canary Error Rate Threshold** | Canary error rate > 2x baseline | 2 min | **Watches:** [Canary Controller](../architecture/architecture.md#canary-controller), [ADR-003](../architecture/adrs.md#adr-003-canary-deploy-via-weighted-traffic-splitting). **Proves:** [US-004](../product/user-stories.md#us-004-canary-deploy-with-traffic-splitting). See [Runbook: Canary Failure](./runbook-canary-failure.md). |
| **Canary Auto-Rollback Triggered** | `pave_canary_rollback_total` increase > 0 | Immediate | **Watches:** [ADR-003](../architecture/adrs.md#adr-003-canary-deploy-via-weighted-traffic-splitting). **Proves:** [US-005](../product/user-stories.md#us-005-auto-rollback-on-error-threshold). Informational — the safety net worked. Investigate root cause. See [Runbook: Canary Failure](./runbook-canary-failure.md). |
| **DB Connection Pool Utilization** | PgBouncer utilization > 80% | 5 min | **Watches:** [PostgreSQL](../architecture/architecture.md#database). Check for long-running queries or connection leaks. |
| **Vault Unsealed But Slow** | `pave_vault_request_duration_seconds` p95 > 2s | 5 min | **Watches:** [Vault Integration](../architecture/architecture.md#vault-integration), [ADR-011](../architecture/adrs.md#adr-011-runtime-secrets-injection-via-sidecar). **Proves:** [US-014](../product/user-stories.md#us-014-secrets-rotation-without-redeploy). Escalate to infra team. |
| **Secret Rotation Failure** | `pave_secret_rotation_failure_total` increase > 0 | Immediate | **Watches:** [Secrets Engine](../architecture/architecture.md#secrets-engine), [ADR-012](../architecture/adrs.md#adr-012-secrets-rotation-event-bus). **Proves:** [US-014](../product/user-stories.md#us-014-secrets-rotation-without-redeploy). See [Runbook: Secret Rotation Failure](./runbook-secret-rotation-failure.md). |
| **Approval SLA Breach** | Approval pending > 30 min | Immediate | **Watches:** [Approval Service](../architecture/architecture.md#approval-service), [ADR-013](../architecture/adrs.md#adr-013-approval-gate-middleware-pattern). **Proves:** [US-017](../product/user-stories.md#us-017-30-minute-sla-on-approvals). **Detects:** [TC-805](../quality/test-suites.md#tc-805-pci-approval--escalation-after-30-min). Escalation auto-triggers. |
| **Redis Connection Failures** | `redis_connection_errors_total` rate > 0 | 5 min | **Watches:** [Redis Cache](../architecture/architecture.md#redis-cache). Dashboard degrades to polling. Check Redis pod status. |
| **Pave API Error Rate Warning** | HTTP 5xx rate > 1% | 5 min | **Watches:** [Pave API](../architecture/architecture.md#pave-api). Check recent changes. If post-deploy: consider rollback. |

### P2 — Investigate During Next Business Day

Alert via Slack #pave-ops. No pager.

| Alert | Condition | Duration | Action |
|-------|-----------|----------|--------|
| **Vault Sealed** | `vault_health_status == 0` | 1 min | **Watches:** [Vault Integration](../architecture/architecture.md#vault-integration). **Proves:** [US-014](../product/user-stories.md#us-014-secrets-rotation-without-redeploy). Escalate to infra team immediately (even though P2 for Pave, it's likely P0 for infra). Existing services continue with cached secrets. |
| **Service Using Expired Secret** | `pave_secret_expired_in_use > 0` | N/A (continuous) | **Watches:** [Secrets Engine](../architecture/architecture.md#secrets-engine), [ADR-012](../architecture/adrs.md#adr-012-secrets-rotation-event-bus). **Detects:** [TC-705](../quality/test-suites.md#tc-705-alert--service-using-expired-secret). See [Runbook: Secret Rotation Failure](./runbook-secret-rotation-failure.md). |
| **DB Storage High** | PostgreSQL storage > 70% of allocated | N/A (daily check) | **Watches:** [PostgreSQL](../architecture/architecture.md#database). Audit log and deploy_events are the main growth drivers. Review retention. |
| **Deploy Classification Drift** | > 30% of deploys classified as non-substantive over 7 days | N/A (weekly) | **Watches:** [Metrics Collector](../architecture/architecture.md#metrics-collector), [ADR-010](../architecture/adrs.md#adr-010-deploy-classification-engine). **Proves:** [US-013](../product/user-stories.md#us-013-deploy-classification). Teams may be gaming metrics again (Round 7 pattern). |
| **Redis Memory High** | > 80% of max memory | 30 min | **Watches:** [Redis Cache](../architecture/architecture.md#redis-cache). Should self-manage via LRU eviction, but investigate if persistent. |
| **Certificate Expiry** | Internal TLS cert expires within 14 days | N/A (daily check) | Renew via cert-manager. |
| **Sidecar Injection Failure** | `pave_sidecar_injection_failure_total` increase > 0 | N/A (daily check) | **Watches:** [Secrets Engine](../architecture/architecture.md#secrets-engine), [ADR-011](../architecture/adrs.md#adr-011-runtime-secrets-injection-via-sidecar). Service deployed without secrets sidecar — may fail at runtime when secrets rotate. |

### Planned But Not Yet Implemented

| Alert | Reason not yet implemented | Target date |
|-------|---------------------------|-------------|
| **Non-K8s runtime health** | Docker Compose adapter (Round 4) doesn't yet expose Prometheus metrics. Gridline onboarding used manual checks. | 2026-Q1 |
| **Approval pipeline throughput** | Only 3 PCI-scoped services so far; not enough volume to set meaningful thresholds. | When > 5 PCI services are onboarded |
| **Cross-team deploy conflict detection** | Architecture for deploy lock contention tracking not built yet. | 2026-Q2 |

---

## Custom Application Metrics

These metrics are instrumented in Pave services and exposed on `/metrics` (Prometheus format).

### Pave API

```
# Counter: API requests by method, path, status
pave_api_requests_total{method="GET|POST|PUT|DELETE", path="/deploys/*|/services/*|/teams/*|...", status="2xx|4xx|5xx"}

# Histogram: API request duration
pave_api_request_duration_seconds_bucket{method, path}

# Gauge: active API connections
pave_api_connections_active
```

### Deploy Engine

```
# Counter: deploys by status, team, environment
pave_deploys_total{status="success|failed|rolled_back|cancelled", team, environment="staging|production"}

# Gauge: currently active deploys
pave_deploys_active

# Gauge: deploy queue depth
pave_deploy_queue_depth

# Histogram: deploy duration (queue entry to completion)
pave_deploy_duration_seconds_bucket{team, environment}

# Histogram: queue wait time (queue entry to execution start)
pave_deploy_queue_wait_seconds_bucket

# Counter: rollbacks
pave_rollbacks_total{team, environment, trigger="manual|auto"}
```

### Canary Controller

```
# Gauge: active canary deployments
pave_canary_active{service, team, traffic_pct}

# Gauge: canary error rate vs baseline
pave_canary_error_rate{service}
pave_canary_baseline_error_rate{service}

# Gauge: canary latency p95 vs baseline
pave_canary_latency_p95{service}
pave_canary_baseline_latency_p95{service}

# Counter: canary outcomes
pave_canary_promoted_total{service, team}
pave_canary_rollback_total{service, team, reason="error_rate|latency|manual"}
```

### Drift Detector

```
# Counter: drift events detected
pave_drift_detected_total{service, drift_type="image|config|replica|resource|unknown"}

# Histogram: reconciliation loop duration
pave_drift_reconcile_duration_seconds_bucket

# Histogram: time from detection to resolution
pave_drift_resolution_seconds_bucket
```

### Secrets Engine

```
# Counter: secret rotation events
pave_secret_rotation_total{secret_path, status="success|failure"}
pave_secret_rotation_failure_total{secret_path, reason}

# Gauge: services using expired secrets
pave_secret_expired_in_use{service, secret_path}

# Histogram: Vault request duration
pave_vault_request_duration_seconds_bucket{operation="read|write|rotate"}

# Counter: sidecar injection outcomes
pave_sidecar_injection_total{status="success|failure"}
pave_sidecar_injection_failure_total{reason}

# Gauge: secret lease remaining time
pave_secret_lease_remaining_seconds{secret_path}
```

### Approval Service

```
# Gauge: pending approvals
pave_approval_pending{service, requester}

# Counter: approval outcomes
pave_approval_completed_total{service, approver, outcome="approved|rejected"}

# Counter: SLA breaches
pave_approval_sla_breach_total{service}

# Counter: escalations
pave_approval_escalation_total{service, level="1|2"}

# Histogram: approval wait time
pave_approval_wait_seconds_bucket{service}
```

### Metrics Collector

```
# Counter: deploy classification
pave_deploy_classification_total{team, classification="substantive|non-substantive|config-only|migration-only"}

# Gauge: DORA-style metrics (computed hourly)
pave_dora_lead_time_seconds{team}
pave_dora_deploy_frequency{team}
pave_dora_change_failure_rate{team}
pave_dora_mttr_seconds{team}
```

---

## Log Aggregation

### Log Format

All Pave services log in structured JSON:

```json
{
  "timestamp": "2025-10-15T14:30:00.123Z",
  "level": "info",
  "service": "pave-api",
  "trace_id": "abc123def456",
  "message": "Deploy initiated",
  "deploy_id": "deploy-789",
  "team": "falcon",
  "service_target": "checkout-api",
  "environment": "production",
  "actor": "alice.wong"
}
```

### Log Retention

| Log Source | Retention |
|------------|-----------|
| Application logs | 90 days (hot), 1 year (cold/S3) |
| Audit log (database) | Indefinite (SOC2 compliance requirement) |
| PostgreSQL logs | 30 days |
| Redis logs | 14 days |
| Deploy execution logs | 1 year (S3) |

### Key Log Queries

**Find all events for a specific deploy:**
```
{service=~"pave-.*"} | json | deploy_id="<uuid>"
```

**Find all 5xx errors in the last hour:**
```
{service="pave-api"} | json | level="error" | status >= 500
```

**Find drift detection events:**
```
{service="pave-drift-detector"} | json | message=~"drift.*detected"
```

**Find failed deploys for a team:**
```
{service="pave-deploy-engine"} | json | team="<team>" | message=~"deploy.*failed"
```

**Find audit log entries for a user:**
```
{service="pave-api"} | json | actor="<username>" | message=~"audit"
```

---

## Distributed Tracing

OpenTelemetry instrumentation across all Pave services. A single deploy request generates a trace spanning:

```
[Pave API] POST /deploys
    +-- [PostgreSQL] INSERT deploy_events (queue entry)
    +-- [Pave API] RBAC check
    +-- [Approval Service] (if PCI-scoped) request approval
    +-- [Deploy Engine] pick up from queue
        +-- [Deploy Engine] pull image from registry
        +-- [Deploy Engine] kubectl apply / docker-compose up
        +-- [Canary Controller] (if canary) configure VirtualService
            +-- [Prometheus] query error rates
            +-- [Canary Controller] promote or rollback
        +-- [Drift Detector] update expected state
    +-- [Notification Service] Slack notification
    +-- [Metrics Collector] classify deploy
    +-- [PostgreSQL] INSERT audit_log
```

Trace IDs are passed in the `X-Trace-Id` header and propagated through gRPC metadata and Redis pub/sub messages. This allows tracing a deploy from CLI invocation to cluster state change.

**Sampling:** 100% of deploys in production (deploy volume is low enough — ~100/day). 100% in staging.

---

## Alert Routing

| Severity | Channel | Who | When |
|----------|---------|-----|------|
| P0 | PagerDuty | On-call engineer (platform team) | 24/7 |
| P1 | Slack #pave-ops | Platform team | Business hours (9 AM - 6 PM) |
| P2 | Slack #pave-ops | Platform team | Next business day |
| Canary auto-rollback | Slack #deploys (team-specific) | Deploying team + platform team | Immediate |
| Drift detected | Slack #pave-ops + DM to service owner | Platform team + service owner | Immediate |

### On-Call Rotation

- Primary on-call: weekly rotation among platform team (6 people, so each person is on-call ~every 6 weeks)
- Secondary on-call: the previous week's primary (backup escalation)
- Escalation: if primary doesn't ack within 15 minutes, page secondary
- If secondary doesn't ack within 15 minutes, page Marcus Chen (Platform Lead)

### Acknowledgment Protocol

When an alert fires:

1. **Identify affected items.** What does this alert prove? (See traceability table above.) Those items are now **suspect**.
2. **Assess blast radius.** If Pave API is down, every team is blocked. If a canary failed, only one team's deploy is affected. The response urgency is proportional to the blast radius.
3. **Plan re-verification.** What evidence restores proven status? A health check passing, a deploy succeeding, a metric returning to baseline.
4. **Record the acknowledgment.** Who acknowledged, when, what was flagged suspect, and what re-verification is planned. This goes in #pave-ops.

### Alert Fatigue Prevention

- Alerts that fire > 3 times/week without action needed: review and tune thresholds
- The canary auto-rollback alert is informational, not actionable by Pave SRE — it notifies the deploying team. If it fires > 5 times/week across all teams, investigate whether the threshold is too aggressive.
- Suppress alerts during Pave's own maintenance windows
- Monthly alert review: are thresholds still meaningful? Any alerts nobody looks at?

---

## Health Check Endpoints

Every Pave service exposes `GET /healthz`:

```json
{
  "status": "ok",
  "version": "0.14.2",
  "uptime_seconds": 172800,
  "checks": {
    "database": "ok",
    "redis": "ok",
    "vault": "ok"
  }
}
```

If a dependency is down:
```json
{
  "status": "degraded",
  "version": "0.14.2",
  "checks": {
    "database": "ok",
    "redis": "error: connection refused",
    "vault": "ok"
  }
}
```

The Kubernetes readiness probe uses the `status` field: `"ok"` = ready, anything else = not ready (stop sending traffic).

The liveness probe is a separate `GET /livez` that only checks if the process is responsive — it doesn't check dependencies. This prevents a Redis outage from cascading into pod restarts.

### Synthetic Health Check

A CronJob in the `pave-monitoring` namespace runs every 60 seconds:

```bash
# Checks Pave API from outside pave-system
curl -sf http://pave.internal/api/healthz || \
  curl -X POST $PAGERDUTY_WEBHOOK -d '{"event": "pave_synthetic_health_failed"}'
```

This catches networking issues that internal readiness probes wouldn't detect.
