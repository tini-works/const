# Onboarding Flows — Pave Deploy Platform

User journeys for all key interactions with Pave. "Users" here are software engineers deploying services.

---

## Flow 1: Standard Deploy (Happy Path)

| Trace | Link |
|-------|------|
| Traced from | [US-001](../product/user-stories.md#us-001-standard-deploy-with-commit-visibility), [E1](../product/epics.md#e1-core-deploy-pipeline) |
| Matched by | [POST /deploys](../architecture/api-spec.md#post-deploys), [Deploy Service](../architecture/architecture.md#deploy-service) |
| Proven by | [TC-101](../quality/test-suites.md#tc-101-standard-deploy-happy-path), [TC-102](../quality/test-suites.md#tc-102-deploy-with-commit-list-output) |
| Confirmed by | Rina Okafor (DX Designer), 2025-06-15 |

The most common flow. Engineer has merged code and wants to deploy.

```
Engineer merges PR to main
        |
        v
  cd service-directory/
  pave deploy --env staging --wait
        |
        v
  CLI shows: commit list, deploy ID, progress
  (queued -> building -> deploying -> verifying)
        |
        v
  "Deploy successful. 3 pods healthy."
        |
        | validates on staging
        v
  pave deploy --env production --wait
        |
        v
  CLI shows same flow for production
        |
        v
  "Deploy successful."
  Engineer moves on.
```

**Total time:** 3-6 minutes for staging + production (depending on build time and queue depth).

---

## Flow 2: Deploy with Rollback Needed

| Trace | Link |
|-------|------|
| Traced from | [US-002](../product/user-stories.md#us-002-deploy-rollback), [E1](../product/epics.md#e1-core-deploy-pipeline) |
| Matched by | [POST /deploys/{id}/rollback](../architecture/api-spec.md#post-deploysidrollback) |
| Proven by | [TC-103](../quality/test-suites.md#tc-103-rollback-to-previous-deploy), [TC-104](../quality/test-suites.md#tc-104-rollback-during-active-deploy) |
| Confirmed by | Rina Okafor (DX Designer), 2025-06-15 |

Deploy lands, something goes wrong, engineer rolls back.

```
pave deploy --env production --wait
        |
        v
  "Deploy successful."
        |
        | Engineer notices error rate spike (alert, dashboard, or pave status)
        v
  pave status checkout-service --env production
  → Error rate: 2.3% (baseline: 0.03%)
        |
        v
  pave rollback --env production --reason "Error rate 77x baseline post-deploy"
        |
        v
  CLI shows: current deploy, target (previous), progress
  "Rolling back to dep-20250614-1623 (v2.14.2)..."
        |
        v
  "Rollback complete. Running v2.14.2."
        |
        | Engineer investigates root cause
        v
  Bad deploy flagged in audit log for review.
```

**Key DX detail:** The rollback command shows both the current (bad) and target (good) deploy with timestamps and history. The engineer can see "this version ran for 23h without issues" — that's the confidence signal.

---

## Flow 3: Emergency Deploy (Pave Bypass)

| Trace | Link |
|-------|------|
| Traced from | [US-004](../product/user-stories.md#us-004-emergency-deploy-bypass), [E1](../product/epics.md#e1-core-deploy-pipeline) |
| Matched by | [POST /deploys/emergency](../architecture/api-spec.md#post-deploysemergency) |
| Proven by | [TC-801](../quality/test-suites.md#tc-801-emergency-deploy-bypasses-queue) |
| Confirmed by | **suspect** — emergency flow redesigned after Round 6. Last verified pre-queue-corruption incident. |

When a production issue can't wait for the normal queue, or when Pave itself is degraded.

```
Production incident detected
(e.g., TLS cert expired at 2 AM Saturday — Round 2)
        |
        v
  Engineer assesses: is Pave available?
        |
        +--- Pave is available ---+
        |                         |
        v                         |
  pave emergency deploy           |
    --env production              |
    --acknowledge-audit           |
        |                         |
        v                         |
  Confirmation prompt:            |
  "You are bypassing queue,       |
   approval gates, and canary.    |
   Proceed? [y/N]"               |
        |                         |
        | y                       |
        v                         |
  Deploy proceeds immediately     |
  (no queue wait, no approval)    |
        |                         |
        v                         |
  "Emergency deploy complete."    |
  "Post-incident review required  |
   within 48 hours."              |
        |                         |
        +--- Pave is DOWN --------+
        |   (Round 6 scenario)
        v
  Refer to: Emergency Procedures
  (see Flow 10: Pave Is Down)
```

**Design note (DD-006):** The emergency path is intentionally uncomfortable. `--acknowledge-audit` is a required flag (not a prompt you can skip). The confirmation prompt names exactly what you're bypassing. The post-incident review is mandatory. This discourages casual use without blocking genuine emergencies.

---

## Flow 4: Canary Deploy Lifecycle

| Trace | Link |
|-------|------|
| Traced from | [US-005](../product/user-stories.md#us-005-canary-deploy-with-traffic-splitting), [E2](../product/epics.md#e2-canary-deploys) |
| Matched by | [POST /deploys/{id}/canary](../architecture/api-spec.md#post-deploysidcanary), [POST /canary/{id}/promote](../architecture/api-spec.md#post-canaryidpromote), [POST /canary/{id}/abort](../architecture/api-spec.md#post-canaryidabort), [Canary Controller](../architecture/architecture.md#canary-controller) |
| Proven by | [TC-201](../quality/test-suites.md#tc-201-canary-start-with-traffic-split), [TC-203](../quality/test-suites.md#tc-203-canary-promote-to-full-traffic), [TC-204](../quality/test-suites.md#tc-204-canary-abort-restores-baseline) |
| Confirmed by | Rina Okafor (DX Designer), 2025-07-25 |

Full canary lifecycle — start, observe, decide.

```
pave canary start --env production --traffic 5 --duration 1h
        |
        v
  Canary running: 5% traffic to new version
  CLI prints dashboard URL
        |
        v
  Engineer opens canary dashboard (D3)
  Watches: error rate, latency, request volume
  Baseline vs canary, side by side
        |
        +--- Metrics look good ---+
        |                         |
        v                         |
  pave canary promote             |
  --env production                |
        |                         |
        v                         |
  Traffic shifts 5% -> 100%      |
  Old version drained             |
  "Canary promoted."              |
        |                         |
        +--- Metrics look bad ----+
        |
        v
  pave canary abort --env production
    --reason "p99 latency 3x baseline"
        |
        v
  Traffic shifts back to 100% baseline
  Canary pods torn down
  "Canary aborted."
  Deploy flagged for review.
```

**The decision is always human.** The dashboard shows a "verdict" (within thresholds / exceeding thresholds) but never auto-promotes or auto-aborts. Engineers decide.

---

## Flow 5: New Team Onboarding (Gridline)

| Trace | Link |
|-------|------|
| Traced from | [US-006](../product/user-stories.md#us-006-new-team-onboarding), [US-007](../product/user-stories.md#us-007-non-kubernetes-stack-onboarding), [E3](../product/epics.md#e3-onboarding-and-compatibility) |
| Matched by | [POST /services](../architecture/api-spec.md#post-services), [Onboarding Service](../architecture/architecture.md#onboarding-service) |
| Proven by | [TC-401](../quality/test-suites.md#tc-401-init-generates-valid-pave-yaml), [TC-402](../quality/test-suites.md#tc-402-init-detects-docker-compose-stack) |
| Confirmed by | Rina Okafor (DX Designer), 2025-08-10 |

Gridline joins the company. Non-standard stack (bash scripts, docker-compose, no K8s).

```
Gridline engineer: "We were told we need to use Pave.
We have no idea what Pave is."
        |
        v
  cd gridline-api/
  pave init
        |
        v
  Interactive wizard starts:
    - Detects docker-compose.yml (no K8s)
    - Detects Node.js (package.json)
    - Suggests compatibility mode
        |
        v
  Wizard generates pave.yaml
  (docker-compose deployment strategy,
   reduced feature set flagged)
        |
        v
  "Compatibility mode: canary deploys and
   auto-scaling are not available for
   docker-compose stacks."
        |
        v
  pave deploy --env staging --wait
        |
        v
  First deploy succeeds (or fails with
  actionable error messages)
        |
        | Platform team monitors via
        | Onboarding Status dashboard (D8)
        v
  Checklist progresses:
  [ ] pave.yaml created            -> [x]
  [ ] First staging deploy         -> [x]
  [ ] Health check passing         -> [ ] (needs /healthz endpoint)
  [ ] CI integration               -> [ ] (needs GitHub Actions)
  [ ] Secrets configured           -> [ ]
  [ ] RBAC configured              -> [ ]
  [ ] First production deploy      -> [ ]
  [ ] Monitoring verified          -> [ ]
        |
        v
  Blocked items surface with clear
  instructions: "Add a /healthz endpoint
  that returns 200 when the service is ready."
```

**Key DX detail:** The wizard is honest about limitations. It doesn't pretend docker-compose mode is the same as K8s mode. It tells you upfront what you won't get and links to migration docs if you want to move to K8s later.

---

## Flow 6: Secret Rotation

| Trace | Link |
|-------|------|
| Traced from | [US-008](../product/user-stories.md#us-008-secrets-rotation-without-redeploy), [E4](../product/epics.md#e4-secrets-management) |
| Matched by | [POST /services/{name}/secrets/{key}/rotate](../architecture/api-spec.md#post-servicesname-secretskeyrotate), [Secrets Manager](../architecture/architecture.md#secrets-manager), [ADR-005](../architecture/adrs.md#adr-005-secrets-rotation-via-sidecar-injection) |
| Proven by | [TC-302](../quality/test-suites.md#tc-302-secret-rotation-propagates-without-redeploy) |
| Confirmed by | Rina Okafor (DX Designer), 2025-09-10 |

Rotate a secret without redeploying any service. Critical for credential rotation cycles.

```
pave secrets list --env production
        |
        v
  Shows all secrets with rotation status:
  REDIS_PASSWORD    ✗ rotation overdue
  DATABASE_URL      ⚠ expiring soon
        |
        v
  pave secrets rotate REDIS_PASSWORD
    --service checkout-service
    --env production
        |
        v
  "Rotating REDIS_PASSWORD..."
  "New value propagated to 3/3 pods."
  "No restart required."
        |
        v
  Repeat for other services that use REDIS_PASSWORD
  (or use bulk rotation from Secrets Dashboard D6)
        |
        v
  pave secrets list --env production
  REDIS_PASSWORD    ✓ current (rotated just now)
  DATABASE_URL      ⚠ expiring soon
```

**What makes this different from pre-Pave:** Before, secret rotation meant scheduling deploys across all affected services, coordinating with 4 teams, and hoping nobody missed one. Now it's one command, no downtime, immediate propagation.

---

## Flow 7: PCI Deploy with Approval

| Trace | Link |
|-------|------|
| Traced from | [US-010](../product/user-stories.md#us-010-pci-deploy-approval), [E6](../product/epics.md#e6-pci-compliance) |
| Matched by | [POST /approvals](../architecture/api-spec.md#post-approvals), [POST /approvals/{id}/approve](../architecture/api-spec.md#post-approvalsidapprove), [Approval Service](../architecture/architecture.md#approval-service) |
| Proven by | [TC-601](../quality/test-suites.md#tc-601-approval-request-creates-slack-notification), [TC-602](../quality/test-suites.md#tc-602-deploy-blocked-without-approval), [TC-603](../quality/test-suites.md#tc-603-approved-deploy-proceeds) |
| Confirmed by | Rina Okafor (DX Designer), 2025-10-15 |

Deploying to a PCI-scoped service (payments, checkout). Security sign-off required.

```
pave deploy --env production --service payments-service
        |
        v
  "Deploy to payments-service requires security
   approval (PCI scope). Requesting approval..."
        |
        v
  Slack notification fires to #pci-approvals:
  "kai.tanaka requests approval for payments-service
   v4.2.0 -> production. 3 commits. Approve / Reject"
        |
        +--- Approved (via Slack or CLI) ---+
        |                                   |
        v                                   |
  "Deploy approved by sasha.petrov."        |
  Deploy proceeds normally.                 |
  "Deploy successful."                      |
        |                                   |
        +--- Rejected ---+                  |
        |                |                  |
        v                |                  |
  "Deploy rejected by    |                  |
   sasha.petrov.          |                  |
   Reason: 'Missing test  |                  |
   coverage for new       |                  |
   payment flow.'         |                  |
   Deploy cancelled."     |                  |
        |                                   |
        +--- No response (4h+) ---+        |
        |                          |        |
        v                          |        |
  Slack escalation:                |        |
  "Approval for payments-service   |        |
   has been waiting 4+ hours.      |        |
   @security-oncall"               |        |
```

**Design note (DD-005):** The Slack bot is the primary approval channel. Approvers are already in Slack — making them open a dashboard to approve would add friction to a process that should be fast. The dashboard (D7) exists for tracking and as a fallback if Slack is down.

---

## Flow 8: Drift Detection and Resolution

| Trace | Link |
|-------|------|
| Traced from | [US-003](../product/user-stories.md#us-003-drift-detection-after-manual-changes), [E1](../product/epics.md#e1-core-deploy-pipeline) |
| Matched by | [GET /services/{name}/drift](../architecture/api-spec.md#get-servicesnamedrift), [Drift Detector](../architecture/architecture.md#drift-detector) |
| Proven by | [TC-701](../quality/test-suites.md#tc-701-drift-detected-after-manual-ssh-change), [TC-702](../quality/test-suites.md#tc-702-drift-resolved-after-deploy) |
| Confirmed by | Rina Okafor (DX Designer), 2025-07-01 |

Someone made a manual change to production (SSH, kubectl edit). Pave detects the difference.

```
Pave drift detector runs (every 5 min)
        |
        v
  Drift detected on checkout-service
  (config file modified outside deploy)
        |
        v
  Slack alert to #platform-alerts:
  "Drift detected on checkout-service (production).
   /etc/checkout/tls.conf modified."
        |
        v
  Engineer runs: pave drift show checkout-service --env production
        |
        v
  CLI shows:
  - What changed (file diff)
  - When it changed
  - Likely cause: "manual edit (no deploy record matches)"
  - Remediation options:
    1. Apply change to source, deploy normally
    2. Force-deploy to revert drift
        |
        +--- Option 1: Bring into source ---+
        |                                    |
        v                                    |
  Engineer commits the change to repo       |
  pave deploy --env production              |
  Drift resolved.                           |
        |                                    |
        +--- Option 2: Revert drift ---------+
        |
        v
  pave deploy --env production --force
  Overwrites manual change with last known deploy state.
  Drift resolved.
```

**Key DX detail:** The drift message never says "unauthorized change detected" or anything that implies blame. It says "drift detected" and shows what's different. The Round 2 incident (Team Kite SSH'd to fix a cert) showed that drift can be a legitimate fix. The error message helps resolve it, not punish it.

---

## Flow 9: Permission Denied — What To Do

| Trace | Link |
|-------|------|
| Traced from | [US-009](../product/user-stories.md#us-009-rbac-and-audit-trail), [E5](../product/epics.md#e5-soc2-compliance) |
| Matched by | [POST /access/grant](../architecture/api-spec.md#post-accessgrant), [RBAC Service](../architecture/architecture.md#rbac-service) |
| Proven by | [TC-504](../quality/test-suites.md#tc-504-permission-denied-after-revoke) |
| Confirmed by | Rina Okafor (DX Designer), 2025-08-20 |

Engineer tries to do something they don't have permission for. The error message must tell them exactly what role they need and how to get it.

```
pave deploy --env production --service checkout-service
        |
        v
  "Error: You don't have permission to deploy
   to production.

   Required role: deployer
   Your role:     viewer
   Service:       checkout-service

   To request access:
     pave access request deployer --service checkout-service

   Or ask a service admin:
     Current admins: marcus.chen, kai.tanaka"
        |
        v
  Engineer runs:
  pave access request deployer --service checkout-service
        |
        v
  "Access request submitted.
   Notified: marcus.chen, kai.tanaka
   Track: pave access request status req-20250820-1100"
        |
        v
  Admin approves:
  pave access grant intern.jones --role deployer
    --service checkout-service
        |
        v
  "Access granted. intern.jones can now deploy
   checkout-service to all environments."
```

**Design note (DD-002):** Every permission-denied message includes: what role is needed, what role you have, who can grant it, and the command to request it. "Permission denied" alone is useless — it makes the engineer go ask on Slack, which wastes everyone's time.

---

## Flow 10: Pave Is Down — Manual Procedure

| Trace | Link |
|-------|------|
| Traced from | [US-004](../product/user-stories.md#us-004-emergency-deploy-bypass), [E1](../product/epics.md#e1-core-deploy-pipeline) |
| Matched by | [Operations runbook](../operations/runbooks.md#pave-outage-manual-deploy-procedure) |
| Proven by | [TC-802](../quality/test-suites.md#tc-802-manual-deploy-procedure-validated) |
| Confirmed by | **suspect** — procedure written after Round 6 but only dry-run tested. Not yet validated in a real outage. |

Pave itself is down (Round 6 scenario — queue corruption, 4-hour outage). Engineers need to deploy without Pave.

```
Engineer tries: pave deploy --env production
        |
        v
  "Error: Pave service unreachable.
   Status page: https://pave.internal/status
   Emergency deploy procedure:
   https://pave.internal/docs/emergency-manual-deploy"
        |
        v
  Status page shows:
  "Pave deploy queue is degraded.
   Deploys are paused.
   Estimated recovery: 2 hours.
   Manual deploy procedure available."
        |
        v
  Engineer follows manual procedure:
        |
        v
  1. Build image locally:
     docker build -t registry.internal/checkout-service:v2.14.3 .
        |
        v
  2. Push to registry:
     docker push registry.internal/checkout-service:v2.14.3
        |
        v
  3. Update deployment directly:
     kubectl set image deployment/checkout-service
       checkout=registry.internal/checkout-service:v2.14.3
       --namespace production
        |
        v
  4. Log the manual deploy:
     (Pave will detect drift when it recovers
      and reconcile the state)
        |
        v
  When Pave recovers:
  - Drift detector picks up the manual deploy
  - Audit log backfilled with manual deploy entry
  - State reconciled automatically
```

**Design note:** The manual procedure is documented but intentionally not slick. It requires kubectl access, registry credentials, and manual steps. This is by design — if manual deploys were as easy as Pave deploys, nobody would use Pave. The friction is a feature.

**Status: suspect.** This procedure was written after Round 6 but has only been validated in dry-run exercises, not a real outage. The kubectl commands assume current cluster configuration. If the cluster itself is the problem, this procedure won't help — that's an operations-level incident, not a DX-level one.
