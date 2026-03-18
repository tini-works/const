# Architecture Decision Records

---

## ADR-001: Atomic Deploy Model — One Commit Per Deploy

**Date:** Round 1 (2025-06-15)

**Status:** Accepted
**Last reviewed:** 2025-12-01 — still valid, foundational constraint for all subsequent ADRs

**Triggered by:** [BUG-001](../product/user-stories.md#bug-001-multi-commit-deploy-with-unknown-blame), [US-001](../product/user-stories.md#us-001-atomic-single-commit-deploys), [US-002](../product/user-stories.md#us-002-instant-rollback-under-2-minutes)
**Verified by:** [TC-101](../quality/test-suites.md#tc-101-atomic-deploy--single-commit), [TC-102](../quality/test-suites.md#tc-102-rollback--redeploy-previous-commit), [TC-103](../quality/test-suites.md#tc-103-deploy-record--commit-sha-present), [TC-104](../quality/test-suites.md#tc-104-multi-commit-deploy--rejected)
**Monitored by:** [Deploy Pipeline Health, Rollback Duration](../operations/monitoring-alerting.md#deploy-pipeline-health)
**Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-06-20

**Context:**
Team Falcon merged 3 PRs and deployed Friday at 5:03 PM. Checkout broke at 5:08. It took 40 minutes to identify which commit caused it — the other two were fine. Rollback was manual, required paging an SRE at dinner, and involved SSHing to production nodes.

Root cause was twofold:
1. Pave allowed batching multiple commits into a single deploy — no traceability
2. Rollback was a manual process with no defined "previous known-good state"

**Options Considered:**

1. **Allow multi-commit deploys, improve blame tooling** — Keep batching, but add per-commit health checks post-deploy to identify which commit broke things. Problem: retroactive blame is slow and unreliable. By the time you've identified the bad commit, users have been impacted for 30+ minutes.
2. **One commit per deploy with atomic rollback** — Each deploy is exactly one Git commit SHA. Deploy record includes commit SHA, service, environment, deployer, timestamp. Rollback = redeploy the last known-good commit. Simple, traceable, fast.
3. **Feature flags instead of deploy isolation** — Use runtime feature flags to isolate changes. Problem: requires every change to be flag-wrapped, which is cultural change for 20 teams and adds permanent complexity.

**Decision:** Option 2 — one commit per deploy with atomic rollback.

**Implementation:**

Deploy record schema:
```sql
INSERT INTO deploys (service_name, commit_sha, environment, deployer_id, rollback_target)
VALUES ('checkout-api', 'abc123f', 'production', 'user-uuid', 'def456a');
```

- `commit_sha` is required and unique per service+environment at any point in time
- `rollback_target` is the commit SHA of the previous successful deploy for this service+environment
- Rollback = `POST /deploys` with `commit_sha` set to `rollback_target`, `is_rollback: true`
- CLI enforces: `pave deploy` takes a single commit SHA, not a branch

**Rollback flow:**
```
pave rollback checkout-api --env production
    → Pave looks up current deploy for checkout-api/production
    → Gets rollback_target commit SHA
    → Creates new deploy with that SHA, marked as rollback
    → Deploy Engine rebuilds and redeploys
    → Target: rollback complete in < 2 minutes
```

**Consequences:**
- (+) Every production state maps to exactly one commit — blame is instant
- (+) Rollback is a first-class operation, not an ad-hoc SSH session
- (+) Deploy records form a linked list of known-good states per service
- (-) Teams can no longer batch multiple changes into one deploy — more deploys overall
- (-) "Deploy a branch" workflow is gone — teams must merge to get a commit SHA first

---

## ADR-002: Drift Detection via State Fingerprinting

**Date:** Round 2 (2025-07-01)

**Status:** Accepted
**Last reviewed:** 2025-12-01 — suspect: drift detection for non-K8s workloads untested after E3 expanded runtime support

**Triggered by:** [BUG-002](../product/user-stories.md#bug-002-bypass-overwrite--pave-reverts-manual-hotfix), [US-003](../product/user-stories.md#us-003-drift-detection)
**Verified by:** [TC-105](../quality/test-suites.md#tc-105-drift-detection--image-mismatch), [TC-106](../quality/test-suites.md#tc-106-drift-detection--ssh-mutation)
**Monitored by:** [Drift Detected alert](../operations/monitoring-alerting.md#drift-detected)
**Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-07-15

**Context:**
Team Kite's on-call engineer SSH'd to production at 2 AM to update a TLS cert that their payment processor had rotated. The fix worked. Monday morning, Pave ran its scheduled deploy and overwrite the manual fix with the old cert. Transactions failed for 20 minutes before anyone noticed.

The problem: Pave assumed its last deploy was the source of truth, but reality had diverged. Pave didn't know production had been modified outside its control.

**Options Considered:**

1. **Block all SSH access to production** — Enforce that all changes go through Pave. Problem: emergencies happen. Blocking SSH during a 2 AM payment outage would have cost real money.
2. **Detect drift, alert, and pause** — Periodically compare actual cluster state with Pave's expected state. On mismatch: alert the service team, pause the next scheduled deploy, require manual resolution. Pave becomes aware of reality without controlling it.
3. **Full GitOps reconciliation** — Auto-remediate drift by redeploying from Git. Problem: in the TLS cert scenario, auto-remediation would have reverted the fix *faster* than the scheduled deploy did. GitOps is wrong when the manual change is the correct state.

**Decision:** Option 2 — detect and alert, do not auto-remediate. This is explicitly not GitOps.

**Implementation:**

See [tech design: drift detection](tech-design-drift-detection.md) for full details.

State fingerprint = hash of:
- Container image digest (not tag — tags are mutable)
- Environment variable values (hashed, not stored in plain text)
- Resource limits (CPU, memory)
- Replica count

Drift Detector compares fingerprints every 5 minutes:
```
For each service tracked by Pave:
    actual = fingerprint(k8s_api.get_deployment(service, namespace))
    expected = fingerprint(pave_db.last_successful_deploy(service, env))
    if actual != expected:
        create drift_event(service, expected, actual)
        notify(service.team, "drift detected")
        pause_next_deploy(service, env)
```

**Resolution options:**
1. **Accept drift** — update Pave's expected state to match reality (`POST /drift/{id}/resolve?action=accept`)
2. **Revert drift** — trigger a Pave deploy to restore expected state (`POST /drift/{id}/resolve?action=revert`)

**Consequences:**
- (+) Pave knows when reality diverges — no more blind overwriting of manual fixes
- (+) Human decides whether the drift is intentional or accidental
- (+) Pause-on-drift prevents the exact scenario that caused BUG-002
- (-) 5-minute detection window means up to 5 minutes of undetected drift
- (-) Only works for K8s workloads — Docker Compose drift detection is a known gap
- (-) Adds operational overhead: someone must resolve drift events, or they pile up

---

## ADR-003: Canary Deploy via Weighted Traffic Splitting

**Date:** Round 3 (2025-07-15)

**Status:** Accepted
**Last reviewed:** 2025-12-01 — suspect: latency-based thresholds untested

**Triggered by:** [US-004](../product/user-stories.md#us-004-canary-deploy-with-traffic-splitting), [US-005](../product/user-stories.md#us-005-auto-rollback-on-error-threshold)
**Verified by:** [TC-201](../quality/test-suites.md#tc-201-canary-deploy--5-percent-traffic-split), [TC-202](../quality/test-suites.md#tc-202-canary-metrics-comparison--error-rate), [TC-203](../quality/test-suites.md#tc-203-canary-promote--full-traffic), [TC-204](../quality/test-suites.md#tc-204-canary-abort--traffic-reverted), [TC-205](../quality/test-suites.md#tc-205-canary-auto-rollback--error-threshold-breach)
**Monitored by:** [Canary Health, Traffic Split](../operations/monitoring-alerting.md#canary-health)
**Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-08-01

**Context:**
Team Atlas (payments) requested canary deploys. Every deploy to their service is all-or-nothing — they push to prod, hold their breath for 10 minutes, and watch error rates. If something's wrong, they rollback and lose an hour. They want to send 5% of traffic to the new version first, validate, then roll forward.

PM decision DEC-003 made canary available to all teams, not just payments.

**Options Considered:**

1. **Blue-green deploys** — Two identical environments, switch traffic at the load balancer. Simple but binary — no gradual rollout. Also doubles infrastructure cost during deploy.
2. **Weighted traffic splitting via Istio VirtualService** — Deploy canary alongside production. Use Istio to route a configurable percentage of traffic to canary. Compare metrics. Promote or rollback.
3. **Feature flags for gradual rollout** — Roll out features to a percentage of users via flags. Problem: requires code-level flag integration in every service. Doesn't work for infrastructure changes.

**Decision:** Option 2 — Istio VirtualService weighted routing.

**Implementation:**

See [tech design: canary deploy](tech-design-canary.md) for full details.

Canary lifecycle:
```
pave deploy checkout-api --canary --traffic 5
    → Deploy Engine builds canary image
    → Creates canary Deployment (checkout-api-canary)
    → Canary Controller creates Istio VirtualService:
        route:
          - destination: checkout-api (weight: 95)
          - destination: checkout-api-canary (weight: 5)
    → Canary Controller starts metric comparison loop
    → Every 60s: compare canary error_rate vs baseline error_rate
    → If canary error_rate > 2x baseline for 3 consecutive checks → auto-rollback
    → If 15 min pass with canary healthy → auto-promote (or wait for manual promote)
```

**Thresholds (configurable per service in `pave.yaml`):**

| Metric | Default threshold | Action |
|--------|------------------|--------|
| Error rate | > 2× baseline | Auto-rollback |
| p99 latency | > 3× baseline | Auto-rollback (SUSPECT — untested) |
| Health check failures | > 0 | Auto-rollback |

**Consequences:**
- (+) Gradual rollout reduces blast radius of bad deploys
- (+) Automatic rollback catches failures before they affect all traffic
- (+) Available to all teams, not just payments
- (-) Requires Istio service mesh — K8s only. Teams on Docker Compose cannot use canary.
- (-) Metric comparison depends on sufficient traffic volume. Low-traffic services may not generate enough data in the canary window.
- (-) Adds complexity to the deploy lifecycle: deploy is no longer a single step but a multi-phase process

---

## ADR-004: pave.yaml Service Definition Schema

**Date:** Round 4 (2025-08-01)

**Status:** Accepted
**Last reviewed:** 2025-12-01 — extended in Round 9 to include `pci_scoped` flag (ADR-014)

**Triggered by:** [US-006](../product/user-stories.md#us-006-compatibility-mode-for-non-k8s-stacks), [US-007](../product/user-stories.md#us-007-service-definition-schema--paveyaml)
**Verified by:** [TC-301](../quality/test-suites.md#tc-301-onboarding--k8s-service-via-pave-init), [TC-302](../quality/test-suites.md#tc-302-onboarding--pave-yaml-validation), [TC-303](../quality/test-suites.md#tc-303-onboarding--invalid-pave-yaml-rejected)
**Monitored by:** [Onboarding Success Rate](../operations/monitoring-alerting.md#onboarding-metrics)
**Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-08-15

**Context:**
Gridline (acquired startup, 30 people) needs to be on Pave within 90 days for SOC2 compliance. Their stack: Bash deploy scripts, Docker Compose, no Kubernetes, no CI pipeline. Every other team at the company uses K8s. We can't force Gridline to migrate to K8s in 90 days — that's a 6-month project.

We need a way for any service — regardless of its runtime — to describe what it needs from Pave. The description is the contract. Pave translates it to the right runtime.

**Options Considered:**

1. **Custom integration per team** — Write a Gridline-specific adapter with hardcoded paths. Problem: doesn't scale. Every new acquisition or team with a non-standard stack requires custom work.
2. **Service definition schema (`pave.yaml`)** — A declarative file that describes: how to build, where to deploy, what runtime to target, health checks, resource limits. Pave reads this file and adapts.
3. **Force all teams onto Kubernetes** — Standardize the runtime. Problem: Gridline's 90-day SOC2 deadline makes this impossible. Also, not all workloads need K8s.

**Decision:** Option 2 — `pave.yaml` as the universal service contract.

**Implementation:**

```yaml
# pave.yaml — example for a Kubernetes service
service: checkout-api
team: falcon
runtime: kubernetes          # kubernetes | docker-compose | ecs

build:
  dockerfile: ./Dockerfile
  context: .
  args:
    NODE_ENV: production

deploy:
  replicas: 3
  resources:
    cpu: "500m"
    memory: "512Mi"
  health_check:
    path: /healthz
    port: 8080
    interval: 10s
    timeout: 5s

canary:
  enabled: true
  default_traffic: 5
  thresholds:
    error_rate_multiplier: 2.0
    observation_window: 15m

secrets:
  - vault_path: secret/data/pave/checkout-api/production
    mount: /etc/secrets

pci_scoped: false           # added Round 9 (ADR-014)
```

```yaml
# pave.yaml — example for Gridline's Docker Compose service
service: gridline-billing
team: gridline
runtime: docker-compose

build:
  dockerfile: ./Dockerfile
  context: .

deploy:
  compose_file: ./docker-compose.prod.yml
  health_check:
    command: "curl -f http://localhost:8080/health"
    interval: 10s
    retries: 3
```

**Schema validation:** `pave validate` runs JSON Schema validation against `pave.yaml`. Errors include remediation steps (e.g., "Missing `health_check` — see https://pave.internal/docs/health-checks").

**Consequences:**
- (+) Teams describe what they need, Pave figures out how to deliver it
- (+) Gridline can onboard without migrating to K8s
- (+) Schema is extensible — new runtimes or features add fields without breaking existing configs
- (+) `pave init` can generate a starter `pave.yaml` based on detected project structure
- (-) Schema must be maintained and versioned as features evolve
- (-) Docker Compose mode has fewer features (no canary, no drift detection) — creates a two-tier experience

---

## ADR-005: Adapter Pattern for Multi-Runtime Support

**Date:** Round 4 (2025-08-05)

**Status:** Accepted
**Last reviewed:** 2025-12-01 — ECS adapter still not implemented

**Triggered by:** [US-006](../product/user-stories.md#us-006-compatibility-mode-for-non-k8s-stacks)
**Verified by:** [TC-304](../quality/test-suites.md#tc-304-deploy--k8s-service-via-adapter), [TC-305](../quality/test-suites.md#tc-305-deploy--docker-compose-service-via-adapter), [TC-306](../quality/test-suites.md#tc-306-onboarding--docker-compose-to-pave)
**Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-08-20

**Context:**
ADR-004 defines `pave.yaml` with a `runtime` field. The Deploy Engine needs to translate `pave.yaml` into runtime-specific actions. The translation logic must be pluggable — we can't have `if runtime == "kubernetes"` scattered throughout the codebase.

**Decision:** Adapter pattern. Each runtime implements a `DeployAdapter` interface:

```go
type DeployAdapter interface {
    Build(ctx context.Context, spec BuildSpec) (Artifact, error)
    Deploy(ctx context.Context, artifact Artifact, spec DeploySpec) (DeployResult, error)
    Rollback(ctx context.Context, service string, targetSHA string) (DeployResult, error)
    HealthCheck(ctx context.Context, service string) (HealthStatus, error)
    GetCurrentState(ctx context.Context, service string) (ServiceState, error)
}
```

**Adapters:**
- `k8s-adapter` — creates/updates Kubernetes Deployments, Services, Ingress
- `compose-adapter` — runs `docker-compose up -d` on target host via SSH
- `ecs-adapter` — updates ECS task definitions and services (planned, not implemented)

**Consequences:**
- (+) New runtimes are additive — implement the interface, register the adapter
- (+) Core Pave logic is runtime-agnostic
- (-) Feature parity across adapters is hard — K8s adapter supports canary, compose adapter doesn't
- (-) Testing surface grows with each adapter

---

## ADR-006: RBAC Model — Team × Environment Matrix

**Date:** Round 5 (2025-08-15)

**Status:** Accepted
**Last reviewed:** 2025-12-01 — confirmed during SOC2 re-audit

**Triggered by:** [US-008](../product/user-stories.md#us-008-full-deploy-audit-trail), [US-009](../product/user-stories.md#us-009-rbac-per-team-x-environment)
**Verified by:** [TC-401](../quality/test-suites.md#tc-401-rbac--team-member-deploys-to-allowed-env), [TC-402](../quality/test-suites.md#tc-402-rbac--team-member-blocked-from-prod), [TC-403](../quality/test-suites.md#tc-403-rbac--cross-team-deploy-blocked), [TC-404](../quality/test-suites.md#tc-404-rbac--admin-override), [TC-405](../quality/test-suites.md#tc-405-rbac--role-change-audited)
**Monitored by:** [RBAC Violation Rate, Permission Denied Events](../operations/monitoring-alerting.md#rbac-violations)
**Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-09-01

**Context:**
SOC2 audit found: every engineer in the company had deploy access to every environment. An intern on Team Bolt deployed to prod twice — once by accident. The auditor flagged it as a critical finding.

We need access control that answers: "Can this person deploy this service to this environment?"

**Options Considered:**

1. **Environment-only RBAC** — Roles scoped by environment (e.g., "can deploy to staging", "can deploy to prod"). Problem: doesn't prevent cross-team deploys. Team Bolt shouldn't deploy Team Falcon's services.
2. **Team × environment matrix** — Roles scoped by (team, environment). "Deployer for Team Falcon in staging" means you can deploy Falcon's services to staging, nothing else. Team leads manage their own roles.
3. **Service-level RBAC** — Roles scoped per individual service. Most granular, but 300 engineers × 80 services = unmanageable. Teams are the natural grouping.

**Decision:** Option 2 — team × environment matrix.

**Implementation:**

```sql
-- Roles table
CREATE TABLE roles (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL,
    team_id     UUID NOT NULL REFERENCES teams(id),
    environment VARCHAR(20) NOT NULL,  -- 'dev', 'staging', 'production'
    role        VARCHAR(20) NOT NULL,  -- 'viewer', 'deployer', 'approver', 'admin'
    granted_by  UUID NOT NULL,
    granted_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, team_id, environment)
);
```

**Role hierarchy:**
- `viewer` — read deploys, services, metrics for their team
- `deployer` — all viewer permissions + deploy to allowed environments
- `approver` — all deployer permissions + approve/reject PCI deploys (added Round 9)
- `admin` — all permissions + role management + service registration

**Enforcement point:** Every API request checks roles before execution. The check is in middleware — individual endpoints don't implement their own auth.

**Consequences:**
- (+) SOC2 compliant — every deploy is attributable and authorized
- (+) Team leads manage their own permissions — platform team doesn't bottleneck
- (+) Simple model — easy to understand, easy to audit
- (-) No service-level granularity — if you're a deployer for Team Falcon, you can deploy any of Falcon's services
- (-) Role changes must be audited — added operational overhead

---

## ADR-007: Immutable Audit Log Architecture

**Date:** Round 5 (2025-08-20)

**Status:** Accepted
**Last reviewed:** 2025-12-01 — confirmed, audit log extended for secrets rotation events (Round 8) and approval events (Round 9)

**Triggered by:** [US-008](../product/user-stories.md#us-008-full-deploy-audit-trail)
**Verified by:** [TC-406](../quality/test-suites.md#tc-406-audit-log--deploy-event-recorded), [TC-407](../quality/test-suites.md#tc-407-audit-log--immutability)
**Monitored by:** [Audit Log Write Failures](../operations/monitoring-alerting.md#audit-log-health)
**Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-09-01

**Context:**
SOC2 requires a complete, tamper-proof audit trail of all deploy actions. "Who did what, when, to which service, in which environment, and what happened?" must be answerable for any point in time.

**Decision:** Append-only audit log table. No UPDATEs, no DELETEs. Application-level enforcement via a database role with INSERT-only permissions on the `audit_log` table.

**Implementation:**

```sql
CREATE TABLE audit_log (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    actor_id      UUID NOT NULL,
    actor_name    VARCHAR(255) NOT NULL,  -- denormalized for query independence
    action        VARCHAR(50) NOT NULL,
    resource_type VARCHAR(50) NOT NULL,
    resource_id   VARCHAR(255) NOT NULL,
    metadata      JSONB,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- No UPDATE or DELETE permissions for the application role
REVOKE UPDATE, DELETE ON audit_log FROM pave_app;
```

**Action types:**
- `deploy.queued`, `deploy.started`, `deploy.completed`, `deploy.failed`, `deploy.rolled_back`
- `canary.started`, `canary.promoted`, `canary.aborted`, `canary.auto_rollback`
- `rbac.granted`, `rbac.revoked`
- `drift.detected`, `drift.resolved`
- `secret.rotated`, `secret.expired_alert`
- `approval.requested`, `approval.approved`, `approval.rejected`, `approval.escalated`

**Retention:** Audit log retained indefinitely. Periodic exports to S3 for archival and disaster recovery.

**Consequences:**
- (+) Complete, tamper-proof audit trail for SOC2 compliance
- (+) Queryable — supports dashboard filters by actor, action, service, time range
- (+) Denormalized actor name means audit queries don't join to user table
- (-) Table grows unbounded — needs partitioning strategy (not implemented yet, flagged for Round 11)
- (-) INSERT-only constraint means corrections require compensating events, not edits

---

## ADR-008: Deploy Queue Resilience — WAL-Based Recovery

**Date:** Round 6 (2025-09-01)

**Status:** Accepted
**Last reviewed:** 2025-12-01 — suspect: recovery tested with clean shutdown but not mid-write crash

**Triggered by:** [BUG-003](../product/user-stories.md#bug-003-deploy-queue-corruption-during-rbac-migration), [US-011](../product/user-stories.md#us-011-deploy-queue-resilience)
**Verified by:** [TC-501](../quality/test-suites.md#tc-501-break-glass--manual-deploy-when-pave-is-down), [TC-502](../quality/test-suites.md#tc-502-queue-recovery--replay-from-events), [TC-503](../quality/test-suites.md#tc-503-queue-state--derived-not-stored), [TC-504](../quality/test-suites.md#tc-504-queue-recovery--no-lost-deploys-after-crash)
**Monitored by:** [Queue Depth, Queue Health](../operations/monitoring-alerting.md#queue-depth)
**Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-09-15

**Context:**
Pave's own database migration to add RBAC tables had a bug — it locked the `deploy_queue` table for 4 hours. Nobody could deploy. Three teams had P1 fixes queued. The irony: our deploy platform blocked deploys because of its own migration.

Root cause: the `deploy_queue` table was mutable. The migration took a table lock. Mutable state + table locks = single point of failure.

**Options Considered:**

1. **Fix the migration, keep mutable queue** — Add `LOCK_TIMEOUT` to future migrations. Problem: doesn't fix the underlying fragility. The next bug that locks the table has the same impact.
2. **Event-sourced queue** — Replace mutable `deploy_queue` table with an append-only `deploy_events` table. Queue state is derived from events, never stored. Table locks on an append-only table don't block reads of already-written events.
3. **External message queue (RabbitMQ, Kafka)** — Move the queue to a dedicated system. Problem: adds infrastructure for a problem we can solve within PostgreSQL. We have 6 people; each additional service is operational overhead.

**Decision:** Option 2 — event-sourced deploy queue within PostgreSQL.

**Implementation:**

See [tech design: event-sourced queue](tech-design-event-sourced-queue.md) for full details.

```sql
CREATE TABLE deploy_events (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    deploy_id   UUID NOT NULL,
    event_type  VARCHAR(50) NOT NULL,
    payload     JSONB NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_deploy_events_deploy ON deploy_events (deploy_id, created_at);
CREATE INDEX idx_deploy_events_type ON deploy_events (event_type, created_at);
```

**Event types:** `deploy.queued`, `deploy.started`, `deploy.building`, `deploy.deploying`, `deploy.completed`, `deploy.failed`, `deploy.cancelled`, `deploy.rolled_back`

**Queue state derivation:**
```
current_queue = deploy_events
    .where(event_type IN ('deploy.queued', 'deploy.started', 'deploy.completed', ...))
    .group_by(deploy_id)
    .having(last_event NOT IN ('deploy.completed', 'deploy.failed', 'deploy.cancelled'))
    .order_by(first_event.created_at)
```

**Recovery:** On Pave startup, rebuild the in-memory queue state by replaying events. Redis is used as a cache for the materialized queue state during normal operation; if Redis is lost, the queue is rebuilt from events.

**Consequences:**
- (+) No mutable queue table = no table locks blocking deploys
- (+) Queue can be rebuilt from events after any failure
- (+) Event log provides a natural audit trail of deploy lifecycle
- (+) Append-only table is simpler to back up and replicate
- (-) Queue queries are more expensive (derived from events, not direct reads)
- (-) Redis cache adds a consistency concern — mitigated by event-driven invalidation
- (-) Mid-write crash recovery not fully tested (suspect)

---

## ADR-009: Break-Glass Bypass Procedure

**Date:** Round 6 (2025-09-05)

**Status:** Accepted
**Last reviewed:** 2025-12-01 — tested in incident drill 2025-10-15

**Triggered by:** [US-010](../product/user-stories.md#us-010-manual-bypass-when-pave-is-down)
**Verified by:** [TC-501](../quality/test-suites.md#tc-501-break-glass--manual-deploy-when-pave-is-down)
**Monitored by:** [Pave Down Runbook](../operations/monitoring-alerting.md#pave-down-runbook)
**Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-09-15

**Context:**
When Pave itself is down (as happened in BUG-003), teams must still be able to ship critical fixes. The 4-hour queue lockout taught us: a deploy platform that can't be bypassed during its own outages is a single point of failure for the entire company.

**Decision:** Documented bypass procedure with audit trail:

1. Engineer runs `pave bypass --service checkout-api --env production --reason "P1 fix, Pave down"`
2. CLI writes a bypass record to a local log file (can't reach Pave API)
3. CLI outputs the exact `kubectl apply` or `docker-compose up` commands for the target runtime
4. Engineer executes the commands manually
5. When Pave recovers, engineer runs `pave bypass sync` to upload bypass records
6. Pave creates retroactive deploy records and drift events for reconciliation

**Consequences:**
- (+) Teams can ship during Pave outages — no more blocked P1 fixes
- (+) Bypass is auditable, even if retroactively
- (+) Drift Detector (ADR-002) will catch the bypass on next run and require resolution
- (-) Bypass procedure is manual — higher risk of human error
- (-) Retroactive sync is honor-system — an engineer who bypasses and doesn't sync creates an untracked drift

---

## ADR-010: Deploy Classification Engine

**Date:** Round 7 (2025-09-20)

**Status:** Accepted
**Last reviewed:** 2025-12-01 — suspect: classification heuristic for config-only deploys unvalidated

**Triggered by:** [US-012](../product/user-stories.md#us-012-deploy-health-dashboard), [US-013](../product/user-stories.md#us-013-deploy-classification)
**Verified by:** [TC-601](../quality/test-suites.md#tc-601-dashboard--success-rate-calculation), [TC-602](../quality/test-suites.md#tc-602-classification--feature-deploy), [TC-603](../quality/test-suites.md#tc-603-classification--config-only-deploy), [TC-604](../quality/test-suites.md#tc-604-classification--infra-deploy), [TC-605](../quality/test-suites.md#tc-605-classification--readme-deploy-tagged-as-non-substantive)
**Monitored by:** [Deploy Health Dashboard](../operations/monitoring-alerting.md#deploy-health-dashboard)
**Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-10-01

**Context:**
VP Amy Nakamura mandated "10 deploys per team per week." Teams gamed it: split PRs, deployed README changes. Deploy frequency tripled; failure rate also tripled. Marcus counter-proposed (DEC-006) replacing raw frequency with deploy health metrics. That requires classifying deploys by type so we can measure what matters.

**Options Considered:**

1. **Manual classification** — Deployer tags each deploy as feature/config/trivial. Problem: gaming again. Teams would tag everything as "feature."
2. **Automated classification via diff analysis** — Analyze the Git diff between the deployed commit and the previous deploy's commit. Classify based on file patterns.
3. **ML-based classification** — Train a model on historical deploys. Problem: we have 6 months of data and no labeled training set. Over-engineering.

**Decision:** Option 2 — automated heuristic classification.

**Classification rules:**

| Classification | Rule |
|---------------|------|
| `trivial` | Only changes to: `*.md`, `LICENSE`, `.gitignore`, `*.txt`, comments-only diffs |
| `config` | Only changes to: `*.env*`, `*.yaml`/`*.yml` (non-pave.yaml), `*.json` (config files), `*.toml`, Dockerfile env changes |
| `infra` | Only changes to: `pave.yaml`, `Dockerfile`, `docker-compose*.yml`, Kubernetes manifests, Terraform files |
| `feature` | Everything else — any change to application source code |

**Implementation:**
```
classify(deploy):
    diff = git_diff(deploy.commit_sha, deploy.rollback_target)
    changed_files = diff.files

    if all files match trivial_patterns → return 'trivial'
    if all files match config_patterns → return 'config'
    if all files match infra_patterns → return 'infra'
    return 'feature'
```

Classification is stored on the deploy record and used by the Metrics Collector. "Trivial" deploys are excluded from the deploy frequency KPI. All types are included in failure rate and MTTR.

**Consequences:**
- (+) Automated — no gaming opportunity
- (+) Distinguishes meaningful velocity from noise
- (+) Simple heuristic — easy to understand and debug
- (-) Edge cases: a deploy that changes both `README.md` and `src/index.ts` is classified as `feature` even if the source change is trivial
- (-) Config-only classification hasn't been validated against real-world deploys (suspect)

---

## ADR-011: Runtime Secrets Injection via Sidecar

**Date:** Round 8 (2025-10-01)

**Status:** Accepted
**Last reviewed:** 2025-12-01 — non-K8s stacks still gap

**Triggered by:** [US-014](../product/user-stories.md#us-014-secrets-rotation-without-redeploy)
**Verified by:** [TC-701](../quality/test-suites.md#tc-701-secrets-rotation--zero-downtime), [TC-702](../quality/test-suites.md#tc-702-secrets-injection--sidecar-mounts-vault-secret), [TC-703](../quality/test-suites.md#tc-703-secrets-rotation--rolling-restart)
**Monitored by:** [Secret Rotation Status](../operations/monitoring-alerting.md#secret-rotation-status)
**Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-10-20

**Context:**
Team Sentry rotates Redis credentials every 90 days. This requires coordinated deploys of 6 services across 4 teams. Last time, one service missed and went down at 2 AM when the old credential expired. The problem: secrets are baked into container images as environment variables at build time. Rotation = rebuild + redeploy everything that uses the secret.

**Options Considered:**

1. **External config service** — Services fetch secrets from a config service at startup. Problem: still requires restart to pick up new secrets. Also, custom implementation.
2. **Vault sidecar injection** — Use Hashicorp Vault's `vault-agent-injector` to inject secrets into pods via a sidecar container. Secrets are mounted as files. Rotation = rotate in Vault + rolling restart of sidecars (not full redeploy).
3. **Vault CSI provider** — Mount secrets via Kubernetes CSI driver. Problem: doesn't support auto-rotation in the same way — requires pod restart.

**Decision:** Option 2 — Vault sidecar injection.

**Implementation:**

See [tech design: secrets engine](tech-design-secrets-engine.md) for full details.

```yaml
# pave.yaml secrets configuration
secrets:
  - vault_path: secret/data/pave/checkout-api/production
    mount: /etc/secrets
    # Files created at /etc/secrets/redis-password, /etc/secrets/db-url, etc.
```

**Rotation flow:**
```
pave secrets rotate redis-password --services checkout-api,cart-api,order-api
    → Pave API validates RBAC (admin or service owner)
    → Secrets Engine generates new credential value
    → Writes new version to Vault at secret/data/pave/{service}/production
    → For each affected service:
        → Rolling restart of vault-agent sidecar (picks up new secret)
        → Application reads new file from mount path
        → No full redeploy — pods stay running, only sidecar restarts
    → Records rotation event in audit log
    → Alerts if any service fails to pick up new secret within 5 minutes
```

**Consequences:**
- (+) Rotation without redeploy — eliminates coordinated deploy problem
- (+) Secrets never baked into images — images are portable across environments
- (+) Vault provides audit trail of secret access and rotation
- (-) Sidecar injection only works in Kubernetes — Docker Compose services still need manual rotation (known gap)
- (-) Application must read secrets from files, not env vars — requires code change for some services
- (-) Vault is a new dependency — outage means services can't start (mitigated: sidecar caches last-known secret)

---

## ADR-012: Secrets Rotation Event Bus

**Date:** Round 8 (2025-10-05)

**Status:** Accepted
**Last reviewed:** 2025-12-01 — cross-service consumption tracking for non-K8s stacks not verified (suspect)

**Triggered by:** [US-015](../product/user-stories.md#us-015-secrets-rotation-audit-trail)
**Verified by:** [TC-704](../quality/test-suites.md#tc-704-secrets-audit--rotation-event-recorded), [TC-705](../quality/test-suites.md#tc-705-alert--service-using-expired-secret)
**Monitored by:** [Alert: Expired Secret Still In Use](../operations/monitoring-alerting.md#alert-expired-secret-in-use)
**Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-10-20

**Context:**
When a secret is rotated, we need to know: which services consumed the new version? Which are still running on the old version? The 2 AM outage happened because one service missed the rotation. We need proactive detection, not reactive incident response.

**Decision:** Event-based rotation tracking. When a secret is rotated:

1. Rotation event published with old version + new version
2. Each service's sidecar reports which secret version it's currently using (via a health endpoint)
3. Secrets Engine polls sidecars after rotation
4. If any service is still on the old version after 5 minutes → alert

```sql
CREATE TABLE secret_rotations (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    secret_path     VARCHAR(500) NOT NULL,
    service_name    VARCHAR(100) NOT NULL,
    old_version     INTEGER NOT NULL,
    new_version     INTEGER NOT NULL,
    rotated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    rotated_by      UUID NOT NULL,
    pickup_confirmed_at TIMESTAMPTZ  -- NULL until sidecar confirms new version
);
```

**Consequences:**
- (+) Proactive detection of services running on expired secrets
- (+) Audit trail: who rotated, when, which services picked up
- (-) Polling sidecars adds latency to rotation confirmation
- (-) Non-K8s services can't report version via sidecar — tracking gap

---

## ADR-013: Approval Gate Middleware Pattern

**Date:** Round 9 (2025-11-01)

**Status:** Accepted
**Last reviewed:** 2025-12-01 — confirmed by PCI auditor

**Triggered by:** [US-016](../product/user-stories.md#us-016-pci-deploy-approval-workflow), [US-017](../product/user-stories.md#us-017-30-minute-sla-on-approvals)
**Verified by:** [TC-801](../quality/test-suites.md#tc-801-pci-deploy--approval-required-before-prod), [TC-802](../quality/test-suites.md#tc-802-pci-approval--approve-flow), [TC-803](../quality/test-suites.md#tc-803-pci-approval--reject-flow), [TC-804](../quality/test-suites.md#tc-804-pci-approval--sla-tracking), [TC-805](../quality/test-suites.md#tc-805-pci-approval--escalation-after-30-min)
**Monitored by:** [Approval SLA, Pending Approvals](../operations/monitoring-alerting.md#approval-sla)
**Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-11-15

**Context:**
PCI DSS v4.0 requires security team approval before every deploy to PCI-scoped services. Three services are in PCI scope: `payments-api`, `card-vault`, `transaction-ledger`. Without this gate, the company loses PCI certification.

**Options Considered:**

1. **Hard-coded PCI check in the deploy pipeline** — Add an `if pci_service then require_approval` check in the deploy code. Problem: next compliance requirement (HIPAA, SOX) requires another hard-coded check. Doesn't scale.
2. **Approval as pipeline middleware** — The deploy pipeline is a sequence of stages. Approval is a stage that can be inserted at any point in the pipeline based on service configuration. Middleware pattern — same pattern as RBAC enforcement.
3. **External approval system (Jira, ServiceNow)** — Integrate with an external ticketing system for approvals. Problem: adds latency (30+ min for a Jira ticket to be reviewed), couples deploy speed to an external system's UX.

**Decision:** Option 2 — approval as pipeline middleware.

**Implementation:**

Deploy pipeline stages:
```
validate → build → [approval gate] → deploy → verify
                        ↑
                 only if service.pci_scoped == true
                 AND environment == "production"
```

**Approval flow:**
```
1. Deploy reaches approval gate
2. Approval Service creates approval request (status: pending)
3. Notification Service sends Slack message to designated approvers:
   "[PCI Approval Required] payments-api → production by @engineer. Approve/Reject?"
4. Approver clicks Approve or Reject in Slack (or via dashboard)
5. On approve: deploy pipeline continues to deploy stage
6. On reject: deploy cancelled with rejection comment in audit log
7. If no response in 30 min: escalation to secondary approvers + Slack channel alert
```

```sql
CREATE TABLE approvals (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    deploy_id       UUID NOT NULL REFERENCES deploys(id),
    approver_id     UUID,
    status          VARCHAR(20) NOT NULL DEFAULT 'pending',
        -- 'pending', 'approved', 'rejected', 'escalated', 'expired'
    comment         TEXT,
    requested_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    resolved_at     TIMESTAMPTZ,
    escalated_at    TIMESTAMPTZ,
    sla_deadline    TIMESTAMPTZ NOT NULL  -- requested_at + 30 min
);
```

**Consequences:**
- (+) Reusable pattern — next compliance gate (HIPAA, SOX) just adds another middleware stage
- (+) Slack integration means approvers don't context-switch to another tool
- (+) SLA tracking with escalation prevents approval from blocking deploys indefinitely
- (+) PCI auditor confirmed the design meets PCI DSS v4.0 requirements
- (-) Adds ~5-30 minutes of latency to PCI-scoped deploys
- (-) Slack integration is a dependency — if Slack is down, approvals must go through dashboard

---

## ADR-014: PCI Scope Tagging in pave.yaml

**Date:** Round 9 (2025-11-05)

**Status:** Accepted
**Last reviewed:** 2025-12-01 — confirmed, 3 services tagged

**Triggered by:** [US-016](../product/user-stories.md#us-016-pci-deploy-approval-workflow)
**Verified by:** [TC-801](../quality/test-suites.md#tc-801-pci-deploy--approval-required-before-prod)
**Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-11-15

**Context:**
The approval gate (ADR-013) needs to know which services are PCI-scoped. Where does this metadata live?

**Options Considered:**

1. **Central registry** — Platform team maintains a list of PCI-scoped services. Problem: creates a bottleneck — every new PCI service requires a platform team update.
2. **Tag in `pave.yaml`** — Service owner declares `pci_scoped: true` in their `pave.yaml`. Pave reads it during deploy. Service owner is responsible for the declaration. Compliance team audits the list periodically.
3. **Database flag on service record** — `services.pci_scoped` column. Problem: same bottleneck as option 1, just in a different place.

**Decision:** Option 2 — `pci_scoped` flag in `pave.yaml`.

```yaml
# pave.yaml for a PCI-scoped service
service: payments-api
team: atlas
runtime: kubernetes
pci_scoped: true   # triggers approval gate for production deploys
```

**Validation:** `pave validate` warns if `pci_scoped` is not set (neither true nor false). The compliance team runs a quarterly audit: `SELECT name FROM services WHERE pci_scoped = true` and cross-references with the PCI scope document.

**Consequences:**
- (+) Decentralized — service owners declare their own PCI scope
- (+) No platform team bottleneck for adding/removing PCI services
- (+) Auditable — compliance can query the services table
- (-) Trust-based — a team could remove `pci_scoped: true` to skip approval. Mitigated: quarterly audit + audit log tracks `pave.yaml` changes.
