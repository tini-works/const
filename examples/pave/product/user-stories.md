# User Stories

## E1: Deploy Safety & Traceability

### US-001: Atomic single-commit deploys
**As a** developer deploying to production,
**I want** each deploy to contain exactly one commit,
**so that** if something breaks, I know exactly which change caused it.

**Acceptance criteria:**
- `pave deploy` accepts only a single commit SHA or HEAD
- If the commit has not been through CI, deploy is rejected with a clear message
- Deploy record stores: commit SHA, author, timestamp, target environment, deploy result
- Multi-commit deploys are blocked at the API level — not just the CLI

**Incident context (Round 1):** Team Falcon batched 3 PRs into one deploy on Friday at 5 PM. Checkout broke. 40 minutes to figure out which of the 3 commits was the cause. If each deploy was one commit, blame would have been instant.

**Traceability:**
- Traced from: [E1: Deploy Safety & Traceability](epics.md#e1-deploy-safety--traceability) — Round 1 Friday deploy incident
- Matched by:
  - [CLI: `pave deploy`](../experience/cli-spec.md#pave-deploy)
  - API: [POST /deploys](../architecture/api-spec.md#post-deploys)
  - [ADR-001: Atomic Deploy Model](../architecture/adrs.md#adr-001-atomic-deploy-model--one-commit-per-deploy)
- Proven by: [TC-101](../quality/test-suites.md#tc-101-atomic-deploy--single-commit), [TC-102](../quality/test-suites.md#tc-102-atomic-deploy--multi-commit-rejected), [TC-103](../quality/test-suites.md#tc-103-atomic-deploy--no-ci-rejected)
- Verification: **proven** — TC-101 through TC-103 passing. API rejects multi-commit payloads. Verified 2025-06-20.
- Confirmed by: Kai Tanaka (Senior Platform Engineer), 2025-06-20

### US-002: Instant rollback under 2 minutes
**As a** developer who just deployed a bad change,
**I want** to roll back to the previous known-good state in under 2 minutes,
**so that** the blast radius is minimized and I don't need SSH access.

**Acceptance criteria:**
- `pave rollback` reverts to the previous deploy's commit SHA
- Rollback completes (traffic fully shifted) in under 2 minutes
- Rollback is itself a recorded deploy event — same audit trail
- No SSH, no manual intervention, no kubectl — just the CLI command
- If rollback fails, Pave alerts the on-call channel with failure details

**Traceability:**
- Traced from: [E1: Deploy Safety & Traceability](epics.md#e1-deploy-safety--traceability) — Round 1 manual rollback took 40 minutes
- Matched by:
  - [CLI: `pave rollback`](../experience/cli-spec.md#pave-rollback)
  - API: [POST /deploys/{id}/rollback](../architecture/api-spec.md#post-deploysidrollback)
  - [ADR-001: Atomic Deploy Model](../architecture/adrs.md#adr-001-atomic-deploy-model--one-commit-per-deploy)
- Proven by: [TC-104](../quality/test-suites.md#tc-104-rollback--under-2-minutes), [TC-105](../quality/test-suites.md#tc-105-rollback--recorded-as-deploy-event)
- Verification: **proven** — TC-104 shows rollback at 47 seconds in staging. TC-105 confirms audit trail. Verified 2025-06-25.
- Confirmed by: Sasha Petrov (DevOps/SRE), 2025-06-25

### US-003: Drift detection
**As a** platform engineer,
**I want** Pave to detect when production state diverges from the last known deploy,
**so that** we catch unauthorized changes before the next deploy overwrites them.

**Acceptance criteria:**
- Pave periodically fingerprints production state (running image, config, environment variables)
- If fingerprint doesn't match the expected state from the last deploy, drift is flagged
- Drift alert includes: what drifted, expected value, actual value, when drift was detected
- On next deploy, Pave warns if drift exists — deployer must acknowledge or resolve
- Drift events are recorded in the audit log

**Incident context (Round 2):** Team Kite's on-call SSH'd to prod Saturday to fix a TLS cert. Monday, Pave deployed old code and reverted the fix. 20 minutes of lost payment transactions. Drift detection would have caught the manual change and warned the Monday deployer.

**Traceability:**
- Traced from: [E1: Deploy Safety & Traceability](epics.md#e1-deploy-safety--traceability) — Round 2 bypass overwrite incident
- Matched by:
  - [CLI: `pave status`](../experience/cli-spec.md#pave-status) (drift indicator)
  - [Dashboard: Drift Alerts](../experience/dashboard-specs.md#drift-alert-panel)
  - API: [GET /services/{id}/drift](../architecture/api-spec.md#get-servicesiddrift)
  - [ADR-002: Drift Detection via State Fingerprinting](../architecture/adrs.md#adr-002-drift-detection-via-state-fingerprinting)
- Proven by: [TC-106](../quality/test-suites.md#tc-106-drift-detection--ssh-mutation), [TC-107](../quality/test-suites.md#tc-107-drift-detection--config-change), [TC-108](../quality/test-suites.md#tc-108-drift-warning-on-next-deploy)
- Verification: **suspect** — TC-106 through TC-108 passing for K8s workloads. Drift detection for Docker Compose (Gridline) and ECS stacks not verified after E3 expanded scope. Last verified 2025-07-15.
- Confirmed by: Kai Tanaka (Senior Platform Engineer), 2025-07-15

---

## E2: Progressive Rollout

### US-004: Canary deploy with traffic splitting
**As a** developer deploying a risky change,
**I want** to route a configurable percentage of traffic to the new version first,
**so that** I can validate in production before full rollout.

**Acceptance criteria:**
- `pave deploy --canary <percentage>` creates a canary deployment (1%–50% supported)
- Traffic splitting is verified — actual traffic ratio matches configured percentage within 5% tolerance
- Canary version runs alongside stable version, serving real traffic
- Developer can promote canary to 100% with `pave deploy --promote`
- Canary metrics (error rate, latency, status codes) are visible in real time
- Canary can be manually cancelled at any time, reverting all traffic to stable

**Traceability:**
- Traced from: [E2: Progressive Rollout](epics.md#e2-progressive-rollout) — Round 3 Team Atlas request, [PRD: Canary Deploys](prd-canary-deploys.md)
- Matched by:
  - [CLI: `pave deploy --canary`](../experience/cli-spec.md#pave-deploy---canary), [CLI: `pave deploy --promote`](../experience/cli-spec.md#pave-deploy---promote)
  - [Dashboard: Canary Status](../experience/dashboard-specs.md#canary-rollout-status)
  - API: [POST /deploys](../architecture/api-spec.md#post-deploys) (canary mode), [POST /deploys/{id}/promote](../architecture/api-spec.md#post-deploysidpromote)
  - [ADR-003: Canary Deploy via Weighted Traffic Splitting](../architecture/adrs.md#adr-003-canary-deploy-via-weighted-traffic-splitting)
  - Decision: [DEC-003: Canary available to all teams](decision-log.md#dec-003-canary-available-to-all-teams-not-just-payments)
- Proven by: [TC-201](../quality/test-suites.md#tc-201-canary-deploy--5-percent-traffic-split), [TC-202](../quality/test-suites.md#tc-202-canary-deploy--manual-promote), [TC-203](../quality/test-suites.md#tc-203-canary-deploy--manual-cancel)
- Verification: **proven** — TC-201 through TC-203 passing. Traffic ratio validated with production-like load test. Verified 2025-08-01.
- Confirmed by: Kai Tanaka (Senior Platform Engineer), 2025-08-01

### US-005: Auto-rollback on error threshold
**As a** developer using canary deploys,
**I want** Pave to automatically roll back the canary if the error rate exceeds a threshold,
**so that** a bad deploy doesn't sit in canary silently degrading a percentage of users.

**Acceptance criteria:**
- Default error rate threshold: 5% (configurable per service in `pave.yaml`)
- Pave monitors canary error rate continuously during the canary window
- If threshold is breached for 60 consecutive seconds, canary is automatically rolled back
- Auto-rollback triggers a notification to the deployer and the team's alert channel
- Auto-rollback event is recorded in the audit log with the metric that triggered it
- Latency threshold also configurable (e.g., p99 > 2s)

**Traceability:**
- Traced from: [E2: Progressive Rollout](epics.md#e2-progressive-rollout) — Round 3, [PRD: Canary Deploys](prd-canary-deploys.md)
- Matched by:
  - [Dashboard: Canary Status](../experience/dashboard-specs.md#canary-rollout-status) (auto-rollback indicator)
  - API: [GET /deploys/{id}/canary/health](../architecture/api-spec.md#get-deploysidcanaryhealth)
  - [ADR-003: Canary Deploy via Weighted Traffic Splitting](../architecture/adrs.md#adr-003-canary-deploy-via-weighted-traffic-splitting) (health check integration)
  - [Alert: Canary Auto-Rollback](../operations/monitoring-alerting.md#alert-canary-auto-rollback)
- Proven by: [TC-204](../quality/test-suites.md#tc-204-canary-auto-rollback--error-rate-breach), [TC-205](../quality/test-suites.md#tc-205-canary-auto-rollback--error-threshold-breach)
- Verification: **suspect** — TC-204 passing for error rate threshold. TC-205 for latency-based threshold defined but not yet executed. Auto-rollback notification delivery untested. Last verified 2025-08-01.
- Confirmed by: Marcus Chen (Platform Engineering Lead), 2025-08-01

---

## E3: Multi-Stack Onboarding

### US-006: Compatibility mode for non-K8s stacks
**As a** team running Docker Compose (or ECS, or bare metal),
**I want** to use Pave for deploys without migrating to Kubernetes,
**so that** I get deploy safety and audit trails regardless of my runtime.

**Acceptance criteria:**
- Pave supports at least K8s, Docker Compose, and ECS as deploy targets
- Deploy workflow (commit -> build -> deploy -> verify) is the same regardless of target runtime
- Rollback works on all supported runtimes
- Drift detection works on all supported runtimes
- Runtime-specific details are abstracted behind the adapter — teams interact with the same CLI

**Gridline context (Round 4):** 30-person acquired startup running Bash + Docker Compose. 90 days to SOC2. They can't migrate to K8s first and then onboard to Pave. Pave has to meet them where they are.

**Traceability:**
- Traced from: [E3: Multi-Stack Onboarding](epics.md#e3-multi-stack-onboarding) — Round 4 Gridline acquisition, [PRD: Multi-Stack Onboarding](prd-multi-stack-onboarding.md)
- Matched by:
  - [CLI: `pave init`](../experience/cli-spec.md#pave-init) (runtime selection)
  - [Onboarding Flow: Docker Compose](../experience/onboarding-flows.md#onboarding-docker-compose)
  - [ADR-005: Adapter Pattern for Multi-Runtime Support](../architecture/adrs.md#adr-005-adapter-pattern-for-multi-runtime-support)
  - Decision: [DEC-004: Schema, not custom integrations](decision-log.md#dec-004-onboarding-via-service-definition-schema-not-custom-integrations)
- Proven by: [TC-301](../quality/test-suites.md#tc-301-onboarding--k8s-service-via-pave-init), [TC-302](../quality/test-suites.md#tc-302-onboarding--docker-compose-via-pave-init), [TC-306](../quality/test-suites.md#tc-306-onboarding--docker-compose-to-pave)
- Verification: **suspect** — TC-301 and TC-302 passing for K8s and Docker Compose. ECS adapter not yet implemented. Bare metal support deferred. Gridline onboarding completed successfully. Last verified 2025-08-20.
- Confirmed by: Kai Tanaka (Senior Platform Engineer), 2025-08-20

### US-007: Service definition schema — pave.yaml
**As a** team onboarding to Pave,
**I want** a single configuration file that describes my service to Pave,
**so that** onboarding is predictable and I don't need to negotiate a custom integration.

**Acceptance criteria:**
- `pave.yaml` schema covers: service name, team owner, runtime (k8s / docker-compose / ecs), build config, deploy config, health check, environments, secrets references
- `pave validate` checks the file against the schema and reports errors with line numbers
- `pave init` scaffolds a valid `pave.yaml` interactively based on the team's answers
- Schema is versioned — old versions remain supported with deprecation warnings
- Invalid or missing `pave.yaml` blocks `pave deploy` with a clear error

**Traceability:**
- Traced from: [E3: Multi-Stack Onboarding](epics.md#e3-multi-stack-onboarding) — Round 4, [PRD: Multi-Stack Onboarding](prd-multi-stack-onboarding.md)
- Matched by:
  - [CLI: `pave init`](../experience/cli-spec.md#pave-init), [CLI: `pave validate`](../experience/cli-spec.md#pave-validate)
  - [ADR-004: pave.yaml Service Definition Schema](../architecture/adrs.md#adr-004-pave-yaml-service-definition-schema)
  - [Onboarding Flow: Guided Init](../experience/onboarding-flows.md#guided-onboarding)
- Proven by: [TC-303](../quality/test-suites.md#tc-303-pave-validate--valid-config), [TC-304](../quality/test-suites.md#tc-304-pave-validate--invalid-config-errors), [TC-305](../quality/test-suites.md#tc-305-pave-init--interactive-scaffold)
- Verification: **proven** — TC-303 through TC-305 passing. Schema v1 published. 12 teams onboarded successfully. Verified 2025-08-15.
- Confirmed by: Rina Okafor (Developer Experience Designer), 2025-08-15

---

## E4: Access Control & Audit

### US-008: Full deploy audit trail
**As a** compliance officer reviewing our SOC2 controls,
**I want** a complete audit trail of every deploy action in Pave,
**so that** I can prove who did what, when, and what the outcome was.

**Acceptance criteria:**
- Every deploy, rollback, promotion, and cancellation is recorded with: actor, timestamp, service, environment, commit SHA, result, duration
- Audit log is immutable — records cannot be deleted or modified
- Audit log is queryable by time range, actor, service, and environment
- Log retention: minimum 1 year (SOC2 requirement)
- Audit log accessible via API and dashboard

**SOC2 context (Round 5):** Auditor asked for a list of every production deploy in the last 6 months with actor and outcome. We had nothing. This is a non-negotiable control.

**Traceability:**
- Traced from: [E4: Access Control & Audit](epics.md#e4-access-control--audit) — Round 5 SOC2 audit finding
- Matched by:
  - [Dashboard: Audit Log](../experience/dashboard-specs.md#audit-log-view)
  - API: [GET /audit](../architecture/api-spec.md#get-audit)
  - [ADR-007: Immutable Audit Log Architecture](../architecture/adrs.md#adr-007-immutable-audit-log-architecture)
- Proven by: [TC-404](../quality/test-suites.md#tc-404-audit-log--deploy-event-complete), [TC-405](../quality/test-suites.md#tc-405-audit-log--immutability), [TC-406](../quality/test-suites.md#tc-406-audit-log--deploy-event-recorded)
- Verification: **proven** — TC-404 through TC-406 passing. SOC2 auditor reviewed sample output and confirmed format is acceptable. Verified 2025-09-01.
- Confirmed by: Marcus Chen (Platform Engineering Lead), 2025-09-01

### US-009: RBAC per team x environment
**As a** platform administrator,
**I want** to control who can deploy to which environment at a team level,
**so that** interns don't deploy to prod and teams can't accidentally deploy to another team's service.

**Acceptance criteria:**
- Permissions matrix: team x environment x action (deploy, rollback, promote, approve)
- Default: team members can deploy to staging, only leads can deploy to prod
- Permission check happens at the API level — CLI cannot bypass
- Denied deploy shows: what was attempted, what permission is missing, who can grant it
- Roles: viewer (read-only), deployer (staging), lead (prod), admin (manage roles)
- Team ownership is sourced from an existing directory (GitHub teams, LDAP, or config)

**Incident context (Round 5):** An intern on Team Bolt deployed to production twice. No one noticed until a customer reported the issue. The intern had no malicious intent — there was simply no guardrail.

**Traceability:**
- Traced from: [E4: Access Control & Audit](epics.md#e4-access-control--audit) — Round 5 SOC2 audit + intern deploy incident
- Matched by:
  - [CLI: `pave deploy` permission errors](../experience/cli-spec.md#pave-deploy--permission-denied)
  - [Dashboard: Team Permissions](../experience/dashboard-specs.md#team-permissions-management)
  - API: [POST /deploys](../architecture/api-spec.md#post-deploys) (permission check), [GET /teams/{id}/permissions](../architecture/api-spec.md#get-teamsidpermissions)
  - [ADR-006: RBAC Model — Team x Environment Matrix](../architecture/adrs.md#adr-006-rbac-model--team-x-environment-matrix)
  - Decision: [DEC-005: RBAC at team x environment granularity](decision-log.md#dec-005-rbac-at-team-x-environment-granularity)
- Proven by: [TC-401](../quality/test-suites.md#tc-401-rbac--team-member-deploys-to-allowed-env), [TC-402](../quality/test-suites.md#tc-402-rbac--intern-blocked-from-prod), [TC-403](../quality/test-suites.md#tc-403-rbac--cross-team-deploy-blocked)
- Verification: **proven** — TC-401 through TC-403 passing. GitHub Teams integration tested. SOC2 auditor confirmed control design. Verified 2025-09-01.
- Confirmed by: Marcus Chen (Platform Engineering Lead), 2025-09-01

---

## E5: Platform Resilience

### US-010: Manual bypass when Pave is down
**As a** developer with a P1 fix during a Pave outage,
**I want** a documented break-glass procedure to deploy without Pave,
**so that** Pave being down doesn't mean production stays broken.

**Acceptance criteria:**
- Break-glass procedure is documented, tested, and accessible (not locked behind Pave itself)
- Procedure works for all supported runtimes (K8s, Docker Compose)
- Every bypass deploy is retroactively logged in Pave's audit trail once Pave recovers
- Bypass requires two-person authorization (no solo bypass)
- `pave bypass` CLI command initiates the procedure with appropriate warnings

**Incident context (Round 6):** RBAC migration locked the deploy queue for 4 hours. Three teams had P1 fixes queued. They had no way to ship. One team considered SSH'ing to prod — exactly the pattern we were trying to eliminate.

**Traceability:**
- Traced from: [E5: Platform Resilience](epics.md#e5-platform-resilience) — Round 6 deploy queue lockout
- Matched by:
  - [CLI: `pave bypass`](../experience/cli-spec.md#pave-bypass)
  - [ADR-009: Break-Glass Bypass Procedure](../architecture/adrs.md#adr-009-break-glass-bypass-procedure)
  - [Runbook: Pave Down](../operations/monitoring-alerting.md#pave-down-runbook)
- Proven by: [TC-501](../quality/test-suites.md#tc-501-break-glass--manual-deploy-when-pave-is-down), [TC-502](../quality/test-suites.md#tc-502-break-glass--retroactive-audit-log), [TC-503](../quality/test-suites.md#tc-503-break-glass--two-person-auth-required)
- Verification: **proven** — TC-501 through TC-503 passing. Incident drill conducted with two teams. Bypass successfully logged retroactively. Verified 2025-09-10.
- Confirmed by: Sasha Petrov (DevOps/SRE), 2025-09-10

### US-011: Deploy queue resilience
**As a** platform engineer,
**I want** the deploy queue to survive internal failures without losing queued deploys,
**so that** a Pave bug doesn't cascade into a "nobody can ship" crisis.

**Acceptance criteria:**
- Deploy queue persists state to durable storage (not just in-memory)
- If Pave process crashes, queued deploys are recovered on restart
- Database migrations run in a non-blocking manner — long-running migrations don't lock the queue
- Queue corruption is detectable and recoverable — `pave queue repair` can reconstruct from the WAL
- Monitoring alert when queue is unhealthy or stalled for > 5 minutes

**Bug context (Round 6):** Adding RBAC tables, the migration took a lock on deploy_queue. 4-hour outage. Nobody could deploy. The migration should have been non-blocking.

**Traceability:**
- Traced from: [E5: Platform Resilience](epics.md#e5-platform-resilience) — Round 6 queue corruption
- Matched by:
  - [Dashboard: Queue Health](../experience/dashboard-specs.md#deploy-queue-health)
  - [ADR-008: Deploy Queue Resilience — WAL-Based Recovery](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery)
  - [Alert: Queue Stalled](../operations/monitoring-alerting.md#alert-deploy-queue-stalled)
- Proven by: [TC-504](../quality/test-suites.md#tc-504-queue-recovery--no-lost-deploys-after-crash), [TC-505](../quality/test-suites.md#tc-505-queue-health--stalled-alert)
- Bug: [BUG-003](../quality/bug-reports.md#bug-003-deploy-queue-locked-during-rbac-migration)
- Verification: **suspect** — TC-504 passing for clean shutdown + restart. Mid-write crash recovery not tested (requires chaos engineering setup). TC-505 alert fires correctly. Last verified 2025-09-15.
- Confirmed by: Kai Tanaka (Senior Platform Engineer), 2025-09-15

---

## E6: Meaningful Deploy Metrics

### US-012: Deploy health dashboard
**As a** VP of Engineering,
**I want** a dashboard showing meaningful deploy health metrics across all teams,
**so that** I can assess engineering velocity and stability without relying on gameable vanity metrics.

**Acceptance criteria:**
- Dashboard shows four DORA-aligned metrics per team: deploy success rate, MTTR, change failure rate, lead time (commit to production)
- Metrics are calculated from actual deploy data, not self-reported
- Team-level and org-level rollup views
- Time range selector: last 7 days, 30 days, 90 days
- Dashboard does not show raw deploy frequency as a primary metric

**Political context (Round 7):** VP mandated "10 deploys per team per week." Teams gamed it — split PRs, deployed README changes. Marcus counter-proposed these metrics instead. VP agreed to trial.

**Traceability:**
- Traced from: [E6: Meaningful Deploy Metrics](epics.md#e6-meaningful-deploy-metrics) — Round 7 VP mandate pushback
- Matched by:
  - [Dashboard: Deploy Health](../experience/dashboard-specs.md#deploy-health-dashboard), [Dashboard: Team View](../experience/dashboard-specs.md#team-deploy-metrics)
  - API: [GET /metrics/health](../architecture/api-spec.md#get-metricshealth)
  - [ADR-010: Deploy Classification Engine](../architecture/adrs.md#adr-010-deploy-classification-engine)
  - Decision: [DEC-006: Counter-propose health metrics to VP](decision-log.md#dec-006-counter-propose-deploy-health-metrics-to-vp)
- Proven by: [TC-601](../quality/test-suites.md#tc-601-dashboard--success-rate-calculation), [TC-602](../quality/test-suites.md#tc-602-dashboard--mttr-calculation), [TC-603](../quality/test-suites.md#tc-603-dashboard--lead-time-calculation)
- Verification: **proven** — TC-601 through TC-603 passing. VP reviewed dashboard in trial and approved it as the replacement for raw frequency. Verified 2025-10-01.
- Confirmed by: Marcus Chen (Platform Engineering Lead), 2025-10-01

### US-013: Deploy classification
**As a** platform engineer,
**I want** Pave to classify deploys by type (feature, bugfix, config, docs/non-substantive),
**so that** metrics reflect real engineering work and aren't polluted by noise deploys.

**Acceptance criteria:**
- Classification is automatic based on commit metadata and file changes
- Categories: feature, bugfix, config-change, docs/non-substantive, migration, rollback
- Classification is visible on the deploy record and in the dashboard
- Teams can override classification if the automatic heuristic is wrong
- Non-substantive deploys are excluded from DORA metrics by default (configurable)

**Traceability:**
- Traced from: [E6: Meaningful Deploy Metrics](epics.md#e6-meaningful-deploy-metrics) — Round 7 gaming behavior
- Matched by:
  - [Dashboard: Deploy Health](../experience/dashboard-specs.md#deploy-health-dashboard) (classification filter)
  - [ADR-010: Deploy Classification Engine](../architecture/adrs.md#adr-010-deploy-classification-engine)
- Proven by: [TC-604](../quality/test-suites.md#tc-604-classification--feature-deploy-tagged), [TC-605](../quality/test-suites.md#tc-605-classification--readme-deploy-tagged-as-non-substantive)
- Verification: **suspect** — TC-604 and TC-605 passing for feature and README deploys. Classification not tested against config-only deploys, migration-only deploys, or rollbacks. Heuristic override path untested. Last verified 2025-10-01.
- Confirmed by: Rina Okafor (Developer Experience Designer), 2025-10-01

---

## E7: Secrets Management

### US-014: Secrets rotation without redeploy
**As a** team that rotates database or cache credentials on a schedule,
**I want** services to pick up new secrets without needing a coordinated deploy,
**so that** rotation doesn't require 6 teams to deploy simultaneously at 2 AM.

**Acceptance criteria:**
- Secrets are injected at runtime via sidecar/agent, not baked into container images or deploy artifacts
- When a secret is rotated, running services pick up the new value within 60 seconds without restart
- `pave secrets rotate <secret-name>` triggers rotation for all services that reference the secret
- Rotation is atomic — either all consumers get the new secret or the rotation is rolled back
- Services still running on the old secret after 5 minutes trigger an alert

**Incident context (Round 8):** Team Sentry rotates Redis creds every 90 days. Requires coordinated deploys of 6 services. Last time one service missed, went down at 2 AM. 45 minutes to figure out which service hadn't redeployed.

**Traceability:**
- Traced from: [E7: Secrets Management](epics.md#e7-secrets-management) — Round 8 secrets rotation incident
- Matched by:
  - [CLI: `pave secrets rotate`](../experience/cli-spec.md#pave-secrets-rotate)
  - API: [POST /secrets/{name}/rotate](../architecture/api-spec.md#post-secretsnamerotate)
  - [ADR-011: Runtime Secrets Injection via Sidecar](../architecture/adrs.md#adr-011-runtime-secrets-injection-via-sidecar)
  - [ADR-012: Secrets Rotation Event Bus](../architecture/adrs.md#adr-012-secrets-rotation-event-bus)
  - Decision: [DEC-007: Secrets rotation is platform responsibility](decision-log.md#dec-007-secrets-rotation-is-platform-responsibility)
- Proven by: [TC-701](../quality/test-suites.md#tc-701-secrets-rotation--zero-downtime), [TC-702](../quality/test-suites.md#tc-702-secrets-rotation--all-consumers-updated-within-60s), [TC-703](../quality/test-suites.md#tc-703-secrets-rotation--partial-failure-rollback)
- Verification: **proven** — TC-701 through TC-703 passing for K8s services. Zero-downtime rotation verified with 6-service test. Verified 2025-10-15.
- Confirmed by: Sasha Petrov (DevOps/SRE), 2025-10-15

### US-015: Secrets rotation audit trail
**As a** compliance officer,
**I want** a complete record of every secrets rotation — who initiated it, when, which services consumed the new secret,
**so that** I can prove secrets are being rotated on schedule and all consumers are updated.

**Acceptance criteria:**
- Every rotation event records: initiator, secret name (not value), timestamp, target services, result per service
- Audit log shows which services successfully picked up the new secret and which didn't
- Services still on old secret are flagged as non-compliant
- Retention: same as deploy audit log (1 year minimum)
- Dashboard view: secrets rotation history with per-service consumption status

**Traceability:**
- Traced from: [E7: Secrets Management](epics.md#e7-secrets-management) — Round 8, compliance implication
- Matched by:
  - [Dashboard: Secrets Status](../experience/dashboard-specs.md#secrets-rotation-status)
  - API: [GET /secrets/{name}/rotations](../architecture/api-spec.md#get-secretsnamerotations)
  - [ADR-012: Secrets Rotation Event Bus](../architecture/adrs.md#adr-012-secrets-rotation-event-bus)
- Proven by: [TC-704](../quality/test-suites.md#tc-704-secrets-audit--rotation-event-recorded), [TC-705](../quality/test-suites.md#tc-705-alert--service-using-expired-secret)
- Verification: **suspect** — TC-704 passing for K8s services. Cross-service consumption tracking not verified for Docker Compose stacks (Gridline). TC-705 alert fires but only tested with K8s workloads. Last verified 2025-10-20.
- Confirmed by: Marcus Chen (Platform Engineering Lead), 2025-10-20

---

## E8: PCI Compliance Gates

### US-016: PCI deploy approval workflow
**As a** developer deploying a PCI-scoped service,
**I want** Pave to require security team approval before the deploy proceeds to production,
**so that** we meet PCI DSS v4.0 requirements and don't lose our certification.

**Acceptance criteria:**
- Services tagged as `pci: true` in `pave.yaml` require approval before prod deploy
- `pave deploy` for PCI services enters a "pending approval" state and notifies the security team
- Security team can approve or reject via dashboard or CLI (`pave approve <deploy-id>`)
- Approved deploys proceed automatically; rejected deploys require a new deploy request
- Approval record is immutable: approver, timestamp, deploy details, decision
- Non-PCI services are unaffected — no approval gate

**PCI context (Round 9):** PCI DSS v4.0 requires security team sign-off before every deploy to PCI-scoped services. Without this gate, the company fails PCI certification. Affects Team Atlas (payments) and any team touching cardholder data.

**Traceability:**
- Traced from: [E8: PCI Compliance Gates](epics.md#e8-pci-compliance-gates) — Round 9 PCI DSS v4.0 requirement
- Matched by:
  - [CLI: `pave deploy` approval prompt](../experience/cli-spec.md#pave-deploy--approval-required), [CLI: `pave approve`](../experience/cli-spec.md#pave-approve)
  - [Dashboard: Pending Approvals](../experience/dashboard-specs.md#pending-approval-queue)
  - API: [POST /deploys/{id}/approve](../architecture/api-spec.md#post-deploysidapprove), [POST /deploys/{id}/reject](../architecture/api-spec.md#post-deploysidreject)
  - [ADR-013: Approval Gate Middleware Pattern](../architecture/adrs.md#adr-013-approval-gate-middleware-pattern)
  - [ADR-014: PCI Scope Tagging in pave.yaml](../architecture/adrs.md#adr-014-pci-scope-tagging-in-pave-yaml)
  - Decision: [DEC-008: PCI gates as reusable middleware](decision-log.md#dec-008-pci-gates-as-reusable-middleware-not-hard-coded)
- Proven by: [TC-801](../quality/test-suites.md#tc-801-pci-deploy--approval-required-before-prod), [TC-802](../quality/test-suites.md#tc-802-pci-deploy--rejected-deploy), [TC-803](../quality/test-suites.md#tc-803-non-pci-deploy--no-gate)
- Verification: **proven** — TC-801 through TC-803 passing. PCI auditor reviewed gate design and approved. Verified 2025-11-10.
- Confirmed by: Marcus Chen (Platform Engineering Lead), 2025-11-10

### US-017: 30-minute SLA on approvals
**As a** developer waiting for PCI approval,
**I want** the security team to respond within 30 minutes during business hours,
**so that** compliance gates don't become a bottleneck that slows down every PCI deploy.

**Acceptance criteria:**
- Approval request triggers immediate notification to the security team channel
- If no response after 30 minutes, escalation notification is sent to security team lead
- If no response after 60 minutes, escalation to VP of Engineering
- SLA is tracked — dashboard shows approval response times and SLA compliance rate
- SLA applies during business hours only (9 AM – 6 PM local, M–F); after-hours deploys follow on-call escalation
- Auto-approve is explicitly not supported — escalation is the only path for timeouts

**Traceability:**
- Traced from: [E8: PCI Compliance Gates](epics.md#e8-pci-compliance-gates) — Round 9 concern about gates becoming bottlenecks
- Matched by:
  - [Dashboard: Pending Approvals](../experience/dashboard-specs.md#pending-approval-queue) (SLA timer)
  - [Alert: Approval SLA Breach](../operations/monitoring-alerting.md#alert-approval-sla-breach)
  - [ADR-013: Approval Gate Middleware Pattern](../architecture/adrs.md#adr-013-approval-gate-middleware-pattern) (escalation logic)
- Proven by: [TC-804](../quality/test-suites.md#tc-804-pci-approval--sla-tracking), [TC-805](../quality/test-suites.md#tc-805-pci-approval--escalation-after-30-min)
- Verification: **proven** — TC-804 and TC-805 passing. Escalation path tested with mock timeout. SLA dashboard shows 92% compliance in first month. Verified 2025-11-15.
- Confirmed by: Marcus Chen (Platform Engineering Lead), 2025-11-15

---

## Bug Stories

### BUG-001: Multi-commit deploy with unknown blame
**Priority:** P1
**Reported:** Round 1
**Impact:** Team Falcon deployed 3 commits at once. Checkout broke. 40 minutes to determine which commit caused it. Rollback was manual.

**Acceptance criteria for fix:**
- `pave deploy` rejects multi-commit payloads at the API level
- Clear error message explains why and how to deploy one commit at a time
- Existing multi-commit deploys in history are annotated as "legacy — pre-atomic"
- Deploy record always maps to exactly one commit SHA

**Traceability:**
- Traced from: [E1](epics.md#e1-deploy-safety--traceability) — Round 1
- Related stories: [US-001](#us-001-atomic-single-commit-deploys)
- Matched by: [CLI: `pave deploy`](../experience/cli-spec.md#pave-deploy), [ADR-001](../architecture/adrs.md#adr-001-atomic-deploy-model--one-commit-per-deploy)
- Proven by: [TC-102](../quality/test-suites.md#tc-102-atomic-deploy--multi-commit-rejected)
- Bug report: [BUG-001](../quality/bug-reports.md#bug-001-multi-commit-deploy-caused-40-minute-outage)
- Verification: **proven** — TC-102 passing. API rejects multi-commit payloads with clear error message. Verified 2025-06-20.
- Confirmed by: Kai Tanaka (Senior Platform Engineer), 2025-06-20

### BUG-002: Bypass overwrite — Pave reverts manual hotfix
**Priority:** P1
**Reported:** Round 2
**Impact:** On-call SSH'd to prod Saturday to fix TLS cert. Monday, Pave deployed old code and reverted the fix. 20 minutes of lost payment transactions.

**Acceptance criteria for fix:**
- Pave detects when production state doesn't match last known deploy
- Drift warning is surfaced before next deploy — deployer must acknowledge
- Manual changes are not silently overwritten
- Drift detection runs on a schedule (every 5 minutes) and on deploy initiation
- Drift events are logged with before/after state

**Traceability:**
- Traced from: [E1](epics.md#e1-deploy-safety--traceability) — Round 2
- Related stories: [US-003](#us-003-drift-detection)
- Matched by: [CLI: `pave status`](../experience/cli-spec.md#pave-status), [Dashboard: Drift Alerts](../experience/dashboard-specs.md#drift-alert-panel), [ADR-002](../architecture/adrs.md#adr-002-drift-detection-via-state-fingerprinting)
- Proven by: [TC-106](../quality/test-suites.md#tc-106-drift-detection--ssh-mutation), [TC-108](../quality/test-suites.md#tc-108-drift-warning-on-next-deploy)
- Bug report: [BUG-002](../quality/bug-reports.md#bug-002-pave-overwrote-manual-hotfix-causing-transaction-loss)
- Verification: **proven** — TC-106 and TC-108 passing for K8s. Drift detected within 5 minutes of SSH mutation. Deploy blocked until acknowledged. Verified 2025-07-10.
- Confirmed by: Sasha Petrov (DevOps/SRE), 2025-07-10

### BUG-003: Deploy queue corruption during RBAC migration
**Priority:** P0
**Reported:** Round 6
**Impact:** RBAC table migration took a lock on deploy_queue for 4 hours. No team could deploy. Three teams had P1 fixes queued.

**Acceptance criteria for fix:**
- Database migrations run without locking the deploy queue
- If a migration fails, the queue remains operational
- Queue state is persisted to durable storage with WAL for recovery
- `pave queue repair` can reconstruct queue state from the WAL
- Alert triggers when queue is stalled for > 5 minutes

**Traceability:**
- Traced from: [E5](epics.md#e5-platform-resilience) — Round 6
- Related stories: [US-011](#us-011-deploy-queue-resilience)
- Matched by: [ADR-008](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery), [Alert: Queue Stalled](../operations/monitoring-alerting.md#alert-deploy-queue-stalled)
- Proven by: [TC-504](../quality/test-suites.md#tc-504-queue-recovery--no-lost-deploys-after-crash), [TC-505](../quality/test-suites.md#tc-505-queue-health--stalled-alert)
- Bug report: [BUG-003](../quality/bug-reports.md#bug-003-deploy-queue-locked-during-rbac-migration)
- Verification: **proven** — TC-504 and TC-505 passing. Non-blocking migration strategy verified. Queue stall alert fires within 5 minutes. Verified 2025-09-10.
- Confirmed by: Kai Tanaka (Senior Platform Engineer), 2025-09-10
