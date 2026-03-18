# Infrastructure — Pave Deploy Platform

Last updated: 2025-12-01
Owner: Sasha Petrov (DevOps/SRE)

### Traceability

| Component | Architecture Reference |
|-----------|----------------------|
| Pave API | [architecture.md — Pave API](../architecture/architecture.md#pave-api) |
| Deploy Engine | [architecture.md — Deploy Engine](../architecture/architecture.md#deploy-engine) |
| Canary Controller | [architecture.md — Canary Controller](../architecture/architecture.md#canary-controller), [ADR-003](../architecture/adrs.md#adr-003-canary-deploy-via-weighted-traffic-splitting) |
| Drift Detector | [architecture.md — Drift Detector](../architecture/architecture.md#drift-detector), [ADR-002](../architecture/adrs.md#adr-002-drift-detection-via-state-fingerprinting) |
| Secrets Engine | [architecture.md — Secrets Engine](../architecture/architecture.md#secrets-engine), [ADR-011](../architecture/adrs.md#adr-011-runtime-secrets-injection-via-sidecar) |
| Approval Service | [architecture.md — Approval Service](../architecture/architecture.md#approval-service), [ADR-013](../architecture/adrs.md#adr-013-approval-gate-middleware-pattern) |
| Metrics Collector | [architecture.md — Metrics Collector](../architecture/architecture.md#metrics-collector), [ADR-010](../architecture/adrs.md#adr-010-deploy-classification-engine) |
| Notification Service | [architecture.md — Notification Service](../architecture/architecture.md#notification-service) |
| PostgreSQL | [architecture.md — Database](../architecture/architecture.md#database), [data-model.md](../architecture/data-model.md) |
| Redis | [architecture.md — Cache](../architecture/architecture.md#redis-cache) |
| Vault | [architecture.md — Vault](../architecture/architecture.md#vault-integration), [ADR-012](../architecture/adrs.md#adr-012-secrets-rotation-event-bus) |
| S3 | [architecture.md — Object Storage](../architecture/architecture.md#object-storage) |
| **Monitored by** | [monitoring-alerting.md](./monitoring-alerting.md) |
| **Deployed via** | [deployment-procedure.md](./deployment-procedure.md) |
| **Confirmed by** | Sasha Petrov (DevOps/SRE), 2025-12-01 — verified all component references, resource allocations, and network topology against production cluster |

---

## Overview

Pave runs inside the Kubernetes cluster it manages. Namespace: `pave-system`. All Pave components are internal-only — no public endpoints. Engineers interact via CLI (which calls the Pave API over the internal network) and the web dashboard (served behind the corporate VPN).

**Last verified:** 2025-12-01 — All resource allocations, replica counts, and networking rules confirmed against production. Next verification due when any infrastructure change is deployed or at 30-day mark (2025-12-31).

---

## Network Topology

```
Corporate VPN / Internal Network
    |
    v
+----------------------------------------------------------+
|  Ingress Controller (nginx, pave-system namespace)       |
|  - TLS termination (internal CA cert)                    |
|  - No public endpoints                                   |
|  - Rate limiting: 200 req/s per source IP                |
|                                                          |
|  Routes:                                                 |
|    pave.internal/api/*    -> Pave API (port 8080)        |
|    pave.internal/ws/*     -> Notification Svc (port 8081)|
|    pave.internal/dash/*   -> Dashboard SPA (port 3000)   |
+---------------------------+------------------------------+
                            |
          +-----------------+-----------------+
          |                 |                 |
          v                 v                 v
    +-----------+    +------------+    +-----------+
    | Pave API  |    | Deploy     |    | Notif.    |
    | (2 pods)  |    | Engine     |    | Service   |
    |           |    | (2 pods)   |    | (1 pod)   |
    +-----+-----+    +-----+------+    +-----+-----+
          |                 |                 |
          +--------+--------+-----------------+
                   |
          +--------+--------+
          |                 |
          v                 v
    +-----------+    +-----------+
    | PostgreSQL|    | Redis     |
    | primary + |    | (cache +  |
    | replica   |    |  pubsub)  |
    +-----------+    +-----------+

External dependencies (outside pave-system):
    +------------------+   +------------------+   +------------------+
    | HashiCorp Vault  |   | S3 (build logs,  |   | Istio (shared    |
    | (shared, managed |   |  deploy artifacts)|   |  service mesh)   |
    | by infra team)   |   |                  |   |                  |
    +------------------+   +------------------+   +------------------+
```

---

## Compute — Application Services

### Pave API

> **Architecture:** [Pave API](../architecture/architecture.md#pave-api) · **API surface:** [api-spec.md](../architecture/api-spec.md) · **ADRs:** [ADR-001](../architecture/adrs.md#adr-001-atomic-deploy-model--one-commit-per-deploy), [ADR-006](../architecture/adrs.md#adr-006-rbac-model--team-x-environment-matrix), [ADR-009](../architecture/adrs.md#adr-009-break-glass-bypass-procedure)

| Property | Value |
|----------|-------|
| Runtime | Go 1.21 |
| Port | 8080 |
| Replicas | 2 (min), 4 (max, HPA) |
| CPU | 500m per pod |
| Memory | 512Mi per pod |
| Health endpoint | `GET /healthz` |
| Readiness endpoint | `GET /readyz` |
| Namespace | `pave-system` |

Entry point for all CLI and dashboard interactions. Handles deploy requests, RBAC enforcement, audit logging, approval workflow coordination.

HPA trigger: CPU > 60% sustained for 2 minutes.

### Deploy Engine

> **Architecture:** [Deploy Engine](../architecture/architecture.md#deploy-engine) · **ADRs:** [ADR-001](../architecture/adrs.md#adr-001-atomic-deploy-model--one-commit-per-deploy), [ADR-005](../architecture/adrs.md#adr-005-adapter-pattern-for-multi-runtime-support), [ADR-008](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery)

| Property | Value |
|----------|-------|
| Runtime | Go 1.21 |
| Port | 8082 (internal gRPC) |
| Replicas | 2 |
| CPU | 1 core per pod |
| Memory | 1Gi per pod |
| Health endpoint | gRPC health check |
| Namespace | `pave-system` |

Executes deploys: pulls images, applies K8s manifests, runs Docker Compose on non-K8s targets, manages the deploy queue. Consumes events from PostgreSQL (event-sourced queue per [ADR-008](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery)).

Two replicas for availability, but deploys are serialized per target service to prevent conflicts. Leader election via PostgreSQL advisory locks.

### Canary Controller

> **Architecture:** [Canary Controller](../architecture/architecture.md#canary-controller) · **ADRs:** [ADR-003](../architecture/adrs.md#adr-003-canary-deploy-via-weighted-traffic-splitting) · **Tech design:** [tech-design-canary.md](../architecture/tech-design-canary.md)

| Property | Value |
|----------|-------|
| Runtime | Go 1.21 |
| Port | 8083 (internal gRPC) |
| Replicas | 1 |
| CPU | 250m |
| Memory | 256Mi |
| Namespace | `pave-system` |

Manages Istio VirtualService weights for canary traffic splitting. Polls Prometheus for error rate comparison between canary and baseline. Triggers auto-rollback when threshold is breached.

Single replica is acceptable — if the controller is down, canary deploys queue but don't fail. The Deploy Engine falls back to all-at-once deploy with a warning.

### Drift Detector

> **Architecture:** [Drift Detector](../architecture/architecture.md#drift-detector) · **ADRs:** [ADR-002](../architecture/adrs.md#adr-002-drift-detection-via-state-fingerprinting) · **Tech design:** [tech-design-drift-detection.md](../architecture/tech-design-drift-detection.md)

| Property | Value |
|----------|-------|
| Runtime | Go 1.21 |
| Port | 8084 (metrics only) |
| Replicas | 1 |
| CPU | 250m |
| Memory | 256Mi |
| Namespace | `pave-system` |

Reconciliation loop that compares actual cluster state against Pave's expected state store. Runs every 60 seconds. Flags drift for human review — does not auto-remediate (per [ADR-002](../architecture/adrs.md#adr-002-drift-detection-via-state-fingerprinting) decision to detect, not prevent).

### Secrets Engine

> **Architecture:** [Secrets Engine](../architecture/architecture.md#secrets-engine) · **ADRs:** [ADR-011](../architecture/adrs.md#adr-011-runtime-secrets-injection-via-sidecar), [ADR-012](../architecture/adrs.md#adr-012-secrets-rotation-event-bus) · **Tech design:** [tech-design-secrets-engine.md](../architecture/tech-design-secrets-engine.md)

| Property | Value |
|----------|-------|
| Runtime | Go 1.21 |
| Port | 8085 (internal gRPC) |
| Replicas | 2 |
| CPU | 250m per pod |
| Memory | 256Mi per pod |
| Namespace | `pave-system` |

Mediates between Vault and consumer services. Injects secrets via sidecar. Publishes rotation events on the event bus so services pick up new secrets without redeploy. Two replicas because if this is down, secret rotation stalls and new deploys can't get secrets.

### Approval Service

> **Architecture:** [Approval Service](../architecture/architecture.md#approval-service) · **ADRs:** [ADR-013](../architecture/adrs.md#adr-013-approval-gate-middleware-pattern), [ADR-014](../architecture/adrs.md#adr-014-pci-scope-tagging-in-pave-yaml)

| Property | Value |
|----------|-------|
| Runtime | Go 1.21 |
| Port | 8086 |
| Replicas | 1 |
| CPU | 250m |
| Memory | 256Mi |
| Namespace | `pave-system` |

Handles PCI deploy approval workflows. Sends Slack notifications to security team, tracks approval state, enforces 30-minute SLA escalation. Single replica — approval state is in PostgreSQL; pod restart doesn't lose state.

### Metrics Collector

> **Architecture:** [Metrics Collector](../architecture/architecture.md#metrics-collector) · **ADRs:** [ADR-010](../architecture/adrs.md#adr-010-deploy-classification-engine)

| Property | Value |
|----------|-------|
| Runtime | Go 1.21 |
| Port | 8087 (metrics only) |
| Replicas | 1 |
| CPU | 250m |
| Memory | 256Mi |
| Namespace | `pave-system` |

Aggregates deploy metrics from the event log. Classifies deploys (substantive vs. non-substantive). Feeds the deploy health dashboard. Batch-processes — no real-time latency requirement.

### Notification Service

> **Architecture:** [Notification Service](../architecture/architecture.md#notification-service)

| Property | Value |
|----------|-------|
| Runtime | Go 1.21 |
| Port | 8081 |
| Replicas | 1 |
| CPU | 250m |
| Memory | 256Mi |
| Namespace | `pave-system` |

Sends Slack notifications for deploy events, approval requests, drift alerts. Maintains WebSocket connections to the web dashboard for real-time deploy status updates.

---

## Data Stores

### PostgreSQL

> **Architecture:** [Database](../architecture/architecture.md#database) · **Schema:** [data-model.md](../architecture/data-model.md) · **ADRs:** [ADR-007](../architecture/adrs.md#adr-007-immutable-audit-log-architecture), [ADR-008](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery)

| Property | Value |
|----------|-------|
| Version | PostgreSQL 16 |
| Primary | 1 instance, 2 vCPU, 8Gi RAM |
| Read replica | 1 instance, 1 vCPU, 4Gi RAM |
| Storage | 100Gi SSD (primary), 100Gi SSD (replica) |
| Namespace | `pave-system` (StatefulSet) |
| Backup | WAL archiving to S3, daily full backup |
| Retention | 30 days point-in-time recovery |

Key databases:
- `pave` — deploy queue (event-sourced), service registry, team/RBAC config
- Audit log — immutable append-only table ([ADR-007](../architecture/adrs.md#adr-007-immutable-audit-log-architecture))
- Deploy events — event store for queue state derivation ([ADR-008](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery))

The read replica serves the dashboard and metrics collector queries. All deploy-path writes go to primary.

Connection pooling: PgBouncer sidecar on each application pod, 20 connections per pod, transaction-level pooling.

### Redis

> **Architecture:** [Redis Cache](../architecture/architecture.md#redis-cache)

| Property | Value |
|----------|-------|
| Version | Redis 7 |
| Instance | 1 pod, 512Mi RAM |
| Namespace | `pave-system` |
| Persistence | RDB snapshots every 5 min |
| Eviction | `allkeys-lru` |

Used for:
- Deploy status cache (current state of active deploys, TTL 1 hour)
- Pub/sub for real-time deploy status updates to dashboard WebSocket
- Rate limiting counters for API

Not mission-critical. If Redis is down, Pave still works — deploy status reads fall back to PostgreSQL, and dashboard updates use polling instead of WebSocket push.

### HashiCorp Vault

> **Architecture:** [Vault Integration](../architecture/architecture.md#vault-integration) · **ADRs:** [ADR-011](../architecture/adrs.md#adr-011-runtime-secrets-injection-via-sidecar), [ADR-012](../architecture/adrs.md#adr-012-secrets-rotation-event-bus) · **Tech design:** [tech-design-secrets-engine.md](../architecture/tech-design-secrets-engine.md)

| Property | Value |
|----------|-------|
| Version | Vault 1.15 |
| Managed by | Infrastructure team (shared cluster) |
| Auth method | Kubernetes service account |
| Secret engines | KV v2 (static secrets), Transit (encryption) |
| Namespace | `vault-system` (external to pave-system) |

Pave's Secrets Engine reads from Vault and injects secrets into consumer service pods via sidecar. Pave does not own the Vault cluster — it's a tenant. Vault availability is the infrastructure team's responsibility; Pave monitors Vault health from the consumer side.

**Dependency risk:** If Vault is sealed or unreachable, new deploys that require secrets will fail. Existing running services continue with cached secrets (sidecar has a local cache with configurable TTL, default 5 minutes).

### S3 (Object Storage)

| Property | Value |
|----------|-------|
| Provider | AWS S3 (or MinIO in staging) |
| Buckets | `pave-build-artifacts`, `pave-deploy-logs` |
| Retention | Build artifacts: 90 days. Deploy logs: 1 year. |

Stores:
- Build artifacts (container images are in the registry, but build logs and intermediate artifacts go here)
- Deploy logs (full stdout/stderr of every deploy, referenced from audit log)

---

## Service Mesh — Istio

Pave configures Istio VirtualServices for canary traffic splitting on behalf of product teams. The Istio control plane is shared infrastructure — Pave is a consumer, not the operator.

| Property | Value |
|----------|-------|
| Istio version | 1.20 |
| Managed by | Infrastructure team |
| Pave's role | Creates/updates VirtualService and DestinationRule resources |
| Namespace scope | Per-team namespaces (Pave writes to them via RBAC) |

The Canary Controller manages VirtualService weights during progressive rollouts. If Istio is degraded, canary deploys are unavailable but standard deploys still work.

---

## Networking

All Pave endpoints are internal-only. No public-facing surfaces.

| Path | Access | Purpose |
|------|--------|---------|
| `pave.internal/api/*` | Corporate VPN | CLI and dashboard API calls |
| `pave.internal/ws/*` | Corporate VPN | Dashboard WebSocket |
| `pave.internal/dash/*` | Corporate VPN | Dashboard SPA |
| Pod-to-pod (gRPC) | Cluster network | Pave API <-> Deploy Engine, Canary Controller, etc. |
| Pave -> Vault | Cluster network | Secret reads via Kubernetes auth |
| Pave -> S3 | AWS PrivateLink / internal | Artifact and log storage |
| Pave -> Istio API | Cluster network | VirtualService management |
| Pave -> target namespaces | Cluster network + RBAC | Deploy execution (kubectl apply) |

NetworkPolicy:
- `pave-system` pods can talk to each other, to PostgreSQL, to Redis, to Vault, to S3, and to target namespaces.
- Ingress to `pave-system` only from the ingress controller and from within the namespace.
- Egress from `pave-system` to target namespaces is scoped by Pave's Kubernetes RBAC (ServiceAccount with per-namespace RoleBindings).

---

## Disaster Recovery

### Backup Strategy

| Data | Method | Frequency | Retention | Recovery target |
|------|--------|-----------|-----------|----------------|
| PostgreSQL | WAL archiving + daily pg_dump | Continuous WAL, daily full | 30 days PITR | RPO: ~1 min, RTO: 30 min |
| Redis | RDB snapshots | Every 5 min | 24 hours | RPO: 5 min, RTO: 5 min (acceptable — cache is reconstructible) |
| Vault | Managed by infra team | N/A | N/A | Per infra team SLA |
| S3 | Cross-region replication | Continuous | Per bucket lifecycle | RPO: ~0, RTO: ~0 (AWS managed) |

### Recovery Priorities

1. **PostgreSQL primary** — without the database, nothing works. Restore from WAL archive.
2. **Pave API + Deploy Engine** — without these, nobody can deploy. Stateless; just restart the pods.
3. **Redis** — nice to have. Pave degrades to slower queries and polling. Rebuild from snapshot or let it repopulate.
4. **Canary Controller, Drift Detector, Secrets Engine** — important but not blocking deploys. Restart and they resume.

### Full cluster loss scenario

If the Kubernetes cluster is gone entirely:
1. Provision new cluster (Terraform, ~30 min)
2. Restore PostgreSQL from S3 WAL archive (~30 min)
3. Deploy Pave via bootstrap procedure (kubectl apply, ~10 min) — see [deployment-procedure.md](./deployment-procedure.md#bootstrap-procedure)
4. Verify deploy queue state derived from event log
5. Resume normal operations

**Total estimated recovery: 60–90 minutes.** Not tested end-to-end. Tabletop exercise completed 2025-11-15; full DR drill planned for 2026-Q1.

---

## Capacity Planning

Current load: ~300 engineers, ~20 teams, averaging 80–120 deploys per business day.

| Resource | Current usage | Headroom | Action threshold |
|----------|--------------|----------|-----------------|
| Pave API CPU | ~30% average, 60% peak | 2x before HPA max | Add nodes if HPA maxes out consistently |
| Deploy Engine CPU | ~40% average | 1.5x | Monitor deploy queue depth — high depth = engine can't keep up |
| PostgreSQL connections | ~50 active (of 200 max via PgBouncer) | 4x | Review connection patterns if >150 |
| PostgreSQL storage | 22Gi of 100Gi | 4x | Audit log growth is the main driver; review retention if >70Gi |
| Redis memory | 128Mi of 512Mi | 4x | Should never be a problem at current scale |
| S3 | ~50Gi | Unlimited (pay-per-use) | Review artifact retention if cost spikes |
