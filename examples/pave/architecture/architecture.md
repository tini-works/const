# Architecture Overview — Pave Deploy Platform

## System Context

An internal deploy platform serving ~300 engineers across ~20 product teams. Engineers interact via CLI (primary interface) and web dashboard (monitoring, approvals, audit). The platform manages the full deploy lifecycle: build, deploy, canary, rollback, secrets, and compliance gates.

**Traceability:** This document is the top-level technical reference. It implements all epics ([E1](../product/epics.md#e1-deploy-safety--traceability)–[E8](../product/epics.md#e8-pci-compliance-gates)). For detailed links, see individual [ADRs](adrs.md), [API spec](api-spec.md), [data model](data-model.md), and tech design documents in this directory.
**Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-12-01

---

## High-Level Architecture

```
                                 ┌─────────────────────────────────────────────────┐
                                 │                  Clients                        │
                                 │                                                 │
                                 │  ┌──────────┐  ┌────────────┐  ┌────────────┐  │
                                 │  │   CLI    │  │  Dashboard  │  │  Slack Bot  │  │
                                 │  │  (pave)  │  │   (Web)     │  │            │  │
                                 │  └────┬─────┘  └─────┬──────┘  └─────┬──────┘  │
                                 └───────┼──────────────┼───────────────┼──────────┘
                                         │              │               │
                                      mTLS           HTTPS          HTTPS
                                         │              │               │
                            ┌────────────┴──────────────┴───────────────┴──────────┐
                            │                   API Gateway / LB                    │
                            │       (TLS termination, rate limiting, auth)          │
                            └──────────────────────────┬──────────────────────────┘
                                                       │
         ┌────────────────┬────────────────┬───────────┼──────────┬─────────────────┐
         │                │                │           │          │                 │
┌────────▼────────┐ ┌─────▼──────┐ ┌───────▼──────┐ ┌─▼────────┐ │    ┌────────────▼──────┐
│   Pave API      │ │  Deploy    │ │   Canary     │ │  Drift   │ │    │  Notification     │
│                 │ │  Engine    │ │  Controller  │ │ Detector │ │    │  Service          │
│ - Deploy reqs  │ │            │ │  (Round 3)   │ │ (Round 2)│ │    │                   │
│ - Queue mgmt   │ │ - Builds   │ │              │ │          │ │    │ - Slack bot       │
│ - State track  │ │ - K8s/ECS  │ │ - Istio VS   │ │ - 5-min  │ │    │ - Email           │
│ - RBAC enforce │ │ - Compose  │ │ - Metrics    │ │   loop   │ │    │ - Approval notify │
│ - Audit log    │ │ - Rollback │ │ - Auto-rollbk│ │ - Alert  │ │    └───────────────────┘
└───────┬────────┘ └─────┬──────┘ └──────┬───────┘ └────┬─────┘ │
        │                │               │              │       │
        │                │               │              │  ┌────▼────────────────┐
        │                │               │              │  │  Approval Service   │
        │                │               │              │  │  (Round 9)          │
        │                │               │              │  │                     │
        │                │               │              │  │ - PCI gates         │
        │                │               │              │  │ - Approval workflow  │
        │                │               │              │  │ - SLA tracking      │
        │                │               │              │  └────┬────────────────┘
        │                │               │              │       │
┌───────▼────────────────▼───────────────▼──────────────▼───────▼────────────────┐
│                            PostgreSQL                                          │
│                                                                                │
│  deploys │ deploy_events │ services │ teams │ roles │ audit_log │ drift_events │
│  canary_sessions │ approvals │ secret_rotations                                │
│                                                                                │
└───────────────────────────────────────┬────────────────────────────────────────┘
                                        │
    ┌───────────────┐  ┌────────────────┤  ┌─────────────────────┐
    │    Redis      │  │                │  │   Metrics Collector  │
    │               │  │                │  │   (Round 7)          │
    │ - Queue cache │  │                │  │                      │
    │ - Deploy      │  │                │  │ - Classification     │
    │   status      │  │                │  │ - Health metrics     │
    └───────────────┘  │                │  │ - Dashboard data     │
                       │                │  └──────────────────────┘
    ┌──────────────────▼──┐  ┌──────────▼─────────────┐
    │   HashiCorp Vault   │  │   S3 / Object Storage   │
    │   (Round 8)         │  │                          │
    │                     │  │ - Build artifacts        │
    │ - Secrets store     │  │ - Deploy logs            │
    │ - Rotation engine   │  │ - Audit exports          │
    │ - Sidecar injection │  └──────────────────────────┘
    └─────────────────────┘
```

---

## Services

### Pave API (Core)

The central service. Accepts all deploy requests, enforces RBAC, manages the deploy queue, and tracks state.

> **Implements:** [E1](../product/epics.md#e1-deploy-safety--traceability), [E4](../product/epics.md#e4-access-control--audit), [E5](../product/epics.md#e5-platform-resilience)
> **API:** Sections [1–6 of the API spec](api-spec.md)
> **ADRs:** [ADR-001](adrs.md#adr-001-atomic-deploy-model--one-commit-per-deploy), [ADR-006](adrs.md#adr-006-rbac-model--team-x-environment-matrix), [ADR-007](adrs.md#adr-007-immutable-audit-log-architecture), [ADR-008](adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery)
> **Monitored by:** [Deploy Pipeline Health](../operations/monitoring-alerting.md#deploy-pipeline-health), [Queue Depth](../operations/monitoring-alerting.md#queue-depth)
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-12-01

**Responsibilities:**
- Accept deploy requests via REST API (from CLI and dashboard)
- Validate deployer permissions (RBAC — team × environment)
- Queue management: enqueue, dequeue, priority, pause
- Deploy state tracking: queued → building → deploying → deployed / failed / rolled_back
- Audit log: every deploy action, RBAC change, and approval event
- Service registry: track what's deployed where, current commit SHA per service per env

**Tech stack:** Go, PostgreSQL, Redis

**Key design constraints:**
- Every deploy must be exactly one commit (ADR-001)
- All deploy actions require RBAC check before execution (ADR-006)
- Audit log is append-only (ADR-007)
- Deploy queue uses event sourcing for resilience (ADR-008)

### Deploy Engine

Executes the actual deploy. Takes a deploy request from the queue and makes it happen.

> **Implements:** [E1](../product/epics.md#e1-deploy-safety--traceability), [E3](../product/epics.md#e3-multi-stack-onboarding)
> **ADRs:** [ADR-001](adrs.md#adr-001-atomic-deploy-model--one-commit-per-deploy), [ADR-004](adrs.md#adr-004-pave-yaml-service-definition-schema), [ADR-005](adrs.md#adr-005-adapter-pattern-for-multi-runtime-support)
> **Monitored by:** [Build Duration, Deploy Duration](../operations/monitoring-alerting.md#deploy-pipeline-health)
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-09-15

**Responsibilities:**
- Build container images from source (commit SHA)
- Push images to container registry
- Apply Kubernetes manifests (or Docker Compose files, or ECS task definitions — via adapter pattern)
- Monitor rollout health (pod readiness, health check pass)
- Execute rollback: redeploy previous known-good commit
- Parse `pave.yaml` for service-specific build and deploy configuration

**Runtime adapters (ADR-005):**

| Runtime | Adapter | Status |
|---------|---------|--------|
| Kubernetes | `k8s-adapter` | Production, default |
| Docker Compose | `compose-adapter` | Production (Gridline) |
| ECS | `ecs-adapter` | Planned, not implemented |

**Key design constraints:**
- Build artifacts are immutable — same commit always produces same image (content-addressable)
- Rollback = redeploy previous commit, not "undo" (ADR-001)
- Runtime adapter selection driven by `pave.yaml` `runtime` field (ADR-004)

### Canary Controller (Round 3)

Manages progressive rollout for teams that opt in.

> **Implements:** [E2](../product/epics.md#e2-progressive-rollout)
> **Tech design:** [Canary Deploy](tech-design-canary.md)
> **ADR:** [ADR-003](adrs.md#adr-003-canary-deploy-via-weighted-traffic-splitting)
> **API:** [Section 3 Canary](api-spec.md#3-canary-management)
> **Monitored by:** [Canary Health, Traffic Split](../operations/monitoring-alerting.md#canary-health)
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-08-01

**Responsibilities:**
- Create shadow deployment alongside existing production deployment
- Configure Istio VirtualService for traffic splitting (configurable, default 5%/95%)
- Continuously compare canary metrics against baseline (error rate, p99 latency)
- Auto-promote if canary passes health window (configurable, default 15 min)
- Auto-rollback if canary error rate exceeds 2× baseline or absolute threshold
- Report canary status to CLI and dashboard in real-time

**Key design constraints:**
- Requires Istio service mesh — only available for Kubernetes runtime
- Canary metrics are sampled from the service mesh, not application-reported
- Auto-rollback is the default; teams can opt into manual-promote mode
- Suspect: latency-based thresholds untested (only error-rate triggers verified)

### Drift Detector (Round 2)

Continuously reconciles expected cluster state with actual cluster state.

> **Implements:** [E1](../product/epics.md#e1-deploy-safety--traceability) (specifically [US-003](../product/user-stories.md#us-003-drift-detection))
> **Tech design:** [Drift Detection](tech-design-drift-detection.md)
> **ADR:** [ADR-002](adrs.md#adr-002-drift-detection-via-state-fingerprinting)
> **API:** [Section 4 Drift](api-spec.md#4-drift-detection)
> **Monitored by:** [Drift Detected alert](../operations/monitoring-alerting.md#drift-detected)
> **Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-07-15

**Responsibilities:**
- Run reconciliation loop every 5 minutes
- Compare running container image tags/digests with Pave's last known deploy state
- Compare running config (env vars, resource limits) with Pave's expected config
- On mismatch: create drift event, alert via Slack, pause next scheduled deploy for that service
- Require manual resolution before deploys resume

**Key design constraints:**
- We detect and alert, we do NOT auto-remediate (this is explicitly not GitOps — ADR-002)
- Drift detection covers K8s workloads only — Docker Compose drift detection is a gap
- Resolution requires a human to either accept the drift (update Pave's expected state) or revert (trigger a Pave deploy)

### Secrets Engine (Round 8)

Manages runtime secrets injection and rotation via HashiCorp Vault.

> **Implements:** [E7](../product/epics.md#e7-secrets-management)
> **Tech design:** [Secrets Engine](tech-design-secrets-engine.md)
> **ADRs:** [ADR-011](adrs.md#adr-011-runtime-secrets-injection-via-sidecar), [ADR-012](adrs.md#adr-012-secrets-rotation-event-bus)
> **API:** [Section 7 Secrets](api-spec.md#7-secrets-management)
> **Monitored by:** [Secret Rotation Status, Expired Secret alert](../operations/monitoring-alerting.md#alert-expired-secret-in-use)
> **Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-10-20

**Responsibilities:**
- Manage Vault policies and secret paths per service
- Configure vault-agent-injector sidecar for K8s workloads
- Execute rotation: rotate in Vault → rolling restart of sidecars (no full redeploy)
- Track rotation audit trail: who rotated, when, which services consumed
- Alert when a service is still using an expired secret version

**Key design constraints:**
- Secrets are injected at runtime via sidecar, never baked into images (ADR-011)
- Services reference secrets by Vault path, not by value
- Rotation for non-K8s stacks (Docker Compose) is a gap — requires manual env var update and restart

### Approval Service (Round 9)

Manages deploy approval workflows for PCI-scoped services.

> **Implements:** [E8](../product/epics.md#e8-pci-compliance-gates)
> **ADRs:** [ADR-013](adrs.md#adr-013-approval-gate-middleware-pattern), [ADR-014](adrs.md#adr-014-pci-scope-tagging-in-pave-yaml)
> **API:** [Section 8 Approvals](api-spec.md#8-approval-workflows)
> **Monitored by:** [Approval SLA, Pending Approvals](../operations/monitoring-alerting.md#approval-sla)
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-11-15

**Responsibilities:**
- Intercept deploy pipeline for PCI-scoped services (identified by `pci_scoped: true` in `pave.yaml`)
- Create approval request, notify designated approvers via Slack
- Track approval SLA (30 min during business hours)
- Escalate if no response within SLA window
- Record approval/rejection with comment in audit log
- Gate is middleware — can be reused for HIPAA, SOX gates in the future

**Key design constraints:**
- Approval is a pipeline stage, not a separate workflow (ADR-013)
- PCI scope is declared in `pave.yaml`, not centrally managed (ADR-014)
- Auto-expire does NOT mean auto-approve — expiry triggers escalation
- Approval applies to prod deploys only; staging is unblocked

### Metrics Collector (Round 7)

Gathers deploy metrics, classifies deploys, and powers the health dashboard.

> **Implements:** [E6](../product/epics.md#e6-meaningful-deploy-metrics)
> **ADR:** [ADR-010](adrs.md#adr-010-deploy-classification-engine)
> **API:** [Section 9 Metrics](api-spec.md#9-deploy-metrics)
> **Monitored by:** [Deploy Health Dashboard](../operations/monitoring-alerting.md#deploy-health-dashboard)
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-10-01

**Responsibilities:**
- Classify every deploy: feature, config, infra, trivial (based on diff analysis — ADR-010)
- Calculate DORA metrics: lead time, deploy frequency (substantive only), change failure rate, MTTR
- Aggregate per team and org-wide
- Feed the deploy health dashboard with real-time data

**Key design constraints:**
- Classification is automated based on file diff heuristics — not perfect
- "Trivial" deploys (README, formatting) are excluded from frequency KPI
- Suspect: classification heuristic catches README deploys but hasn't been validated against config-only or migration-only deploys

### Notification Service

Handles all outbound notifications — Slack, email, CLI push.

> **Implements:** Cross-cutting — serves [E2](../product/epics.md#e2-progressive-rollout) (canary alerts), [E5](../product/epics.md#e5-platform-resilience) (incident alerts), [E8](../product/epics.md#e8-pci-compliance-gates) (approval notifications)
> **Monitored by:** [Notification Delivery Rate](../operations/monitoring-alerting.md#notification-delivery)
> **Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-07-01

**Responsibilities:**
- Slack bot: deploy started/completed/failed, canary status, drift alerts, approval requests
- Email: approval escalation, weekly deploy health digest
- CLI: real-time deploy progress streaming via SSE

---

## Data Stores

### PostgreSQL

Primary datastore for all persistent state. Chosen for:
- Strong transactional guarantees (event-sourced queue needs append-only integrity)
- JSONB support for flexible fields (deploy metadata, canary metrics snapshots)
- Mature tooling for connection pooling and replication

See [data model](data-model.md) for full schema.

### Redis

Dual purpose:
1. **Deploy status cache** — current deploy state per service, queried by CLI `pave status`
2. **Real-time queue state** — materialized view of the deploy queue, rebuilt from events on startup

Cache invalidation: deploy state changes write through to Redis immediately. TTL: 5 minutes for status cache, no TTL for queue state (event-driven updates).

### HashiCorp Vault (Round 8)

Secrets storage and rotation engine:
- Each service has a Vault path: `secret/data/pave/{service_name}/{environment}`
- Dynamic secrets for databases where supported
- Rotation managed by Pave Secrets Engine, not directly by service teams
- Access controlled by Vault policies mapped to Pave's RBAC roles

### S3 / Object Storage

- **Build artifacts** — container image build logs, intermediate artifacts
- **Deploy logs** — stdout/stderr from every deploy execution, retained 90 days
- **Audit exports** — periodic exports of audit log for compliance archival

---

## Security Model

### Authentication

| Client | Auth Method | Details |
|--------|------------|---------|
| CLI | mTLS + API token | CLI authenticates via client certificate (issued by `pave auth login`) + short-lived API token |
| Dashboard | OAuth 2.0 / SSO | Corporate SSO integration, session-based |
| Slack Bot | Slack OAuth | Bot token, verified via Slack signing secret |
| Service-to-service | mTLS | Internal services authenticate via mutual TLS |

### Authorization (RBAC)

RBAC enforcement point is the Pave API. Every request is checked against the `roles` table before execution.

| Role | Permissions |
|------|------------|
| viewer | Read deploys, services, metrics for their team |
| deployer | Deploy to allowed environments for their team |
| approver | Approve/reject deploys for PCI-scoped services |
| admin | All permissions + role management + service registration |

Scope: role × team × environment. Example: "deployer for Team Falcon in staging" means you can deploy Team Falcon's services to staging but not prod and not other teams' services.

See [ADR-006](adrs.md#adr-006-rbac-model--team-x-environment-matrix) for the full model.

### Network Security

- All external traffic terminates TLS at the API gateway
- Internal service-to-service communication uses mTLS
- Vault access restricted to Pave API and Secrets Engine via Vault policies
- PostgreSQL connections via PgBouncer, TLS required
- Redis access restricted to internal network, AUTH required

---

## Component Evolution

How the architecture grew round by round:

| Round | What changed | Components affected |
|-------|-------------|-------------------|
| 1 (Incident) | Atomic deploy model | Pave API, Deploy Engine — ADR-001 |
| 2 (Bypass) | Drift detection | +Drift Detector — ADR-002 |
| 3 (Canary) | Progressive rollout | +Canary Controller — ADR-003 |
| 4 (Onboarding) | Multi-runtime support | Deploy Engine (adapter pattern) — ADR-004, ADR-005 |
| 5 (SOC2) | RBAC + audit | Pave API (RBAC enforcement) — ADR-006, ADR-007 |
| 6 (Self-outage) | Event-sourced queue | Pave API (queue rewrite) — ADR-008, ADR-009 |
| 7 (KPI gaming) | Deploy classification | +Metrics Collector — ADR-010 |
| 8 (Secrets) | Vault integration | +Secrets Engine — ADR-011, ADR-012 |
| 9 (PCI) | Approval gates | +Approval Service — ADR-013, ADR-014 |
| 10 (Existential) | No arch change — justification exercise | Evidence gathered across all components |

---

## Known Gaps and Suspect Items

| Item | Status | Why |
|------|--------|-----|
| Drift detection for Docker Compose workloads | Gap | ADR-002 only covers K8s. Gridline's compose services have no drift detection. |
| Canary latency-based thresholds | Suspect | ADR-003 verified for error-rate triggers but latency thresholds untested. |
| ECS runtime adapter | Planned | ADR-005 defines the adapter interface but ECS adapter not implemented. |
| Secrets rotation for non-K8s stacks | Gap | ADR-011 sidecar injection only works in K8s. Compose services need manual rotation. |
| Deploy classification for config-only deploys | Suspect | ADR-010 heuristic catches README deploys but config-only classification unvalidated. |
| Queue recovery during mid-write crash | Suspect | ADR-008 tested with clean shutdown, not with mid-write crash scenario. |
