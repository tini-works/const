# Test Suites — Pave Deploy Platform

Test cases organized by feature area. Each case includes preconditions, steps, and expected results. Traceability to user stories, CLI commands, API endpoints, dashboard screens, and production monitors is noted per case.

**Traceability key:**
- **Proves:** which [product/](../product/epics.md) acceptance criteria this test verifies
- **Tests:** which [architecture/](../architecture/api-spec.md) API endpoint, [experience/](../experience/cli-spec.md) CLI command, or [experience/](../experience/dashboard-specs.md) dashboard screen
- **Monitored by:** which [operations/](../operations/monitoring-alerting.md) alert detects when this breaks in production

---

## Suite 1: Core Deploy Safety (E1, Rounds 1–2)

> **Last run:** 2025-07-15 | **Environment:** staging | **Result:** all pass | **Run by:** automated (CI)
> **Confirmed by:** Dani Reeves (QA Lead), 2025-07-15

### TC-101: Atomic deploy — single commit
- **Proves:** [US-001](../product/epics.md#us-001-atomic-single-commit-deploys) AC: every deploy maps to exactly one commit, deploy record shows commit SHA, author, and timestamp
- **Tests:** [CLI: `pave deploy`](../experience/cli-spec.md#pave-deploy); [POST /deploys](../architecture/api-spec.md#post-deploys)
- **Monitored by:** [Deploy Failure Rate](../operations/monitoring-alerting.md#deploy-pipeline-health), [Deploy Success by Team](../operations/monitoring-alerting.md#deploy-metrics)

**Precondition:** Service "checkout-api" (Team Falcon) is onboarded. Branch `main` has one new commit `abc1234` since last deploy. User has deployer role for staging.

**Steps:**
1. Run `pave deploy checkout-api --env staging`
2. Observe CLI output
3. Run `pave status checkout-api --env staging`
4. Check Kubernetes deployment for the `checkout-api` pod

**Expected:**
- Step 2: CLI output shows:
  ```
  Deploying checkout-api to staging
    Commit: abc1234 (feat: add retry logic)
    Author: kai.tanaka@company.com
    Building... done (14s)
    Pushing image... done (8s)
    Rolling update... done (22s)
  Deploy successful. Total: 44s
  ```
- Step 3: `pave status` shows `deployed | abc1234 | staging | 2025-07-15T10:22:00Z`
- Step 4: Pod is running with image tagged `abc1234`

---

### TC-102: Rollback — under 2 minutes
- **Proves:** [US-002](../product/epics.md#us-002-instant-rollback-under-2-minutes) AC: rollback completes in under 2 minutes, restores exact previous state, no SSH required
- **Tests:** [CLI: `pave rollback`](../experience/cli-spec.md#pave-rollback); [POST /deploys/{id}/rollback](../architecture/api-spec.md#post-deploysidrollback)
- **Monitored by:** [Rollback Duration](../operations/monitoring-alerting.md#deploy-pipeline-health), [Deploy Failure Rate](../operations/monitoring-alerting.md#deploy-pipeline-health)

**Precondition:** Service "checkout-api" was deployed with commit `abc1234`. Previous deploy was commit `def5678`. Deploy `abc1234` introduced a 500 error.

**Steps:**
1. Run `pave rollback checkout-api --env staging`
2. Start a timer
3. Observe CLI output
4. When rollback completes, stop timer
5. Run `pave status checkout-api --env staging`
6. Verify the running pod image

**Expected:**
- Step 3: CLI shows:
  ```
  Rolling back checkout-api on staging
    Current: abc1234 (feat: add retry logic)
    Target:  def5678 (fix: connection timeout)
    Reverting... done (18s)
  Rollback complete. checkout-api is now at def5678
  ```
- Step 4: Timer < 120 seconds
- Step 5: Status shows `deployed | def5678 | staging`
- Step 6: Pod is running with image tagged `def5678`

---

### TC-103: Multi-commit deploy — rejected
- **Proves:** [US-001](../product/epics.md#us-001-atomic-single-commit-deploys) AC: multi-commit deploys are rejected with clear error
- **Tests:** [CLI: `pave deploy` — error state](../experience/cli-spec.md#pave-deploy); [POST /deploys](../architecture/api-spec.md#post-deploys) (422 response)
- **Monitored by:** [Deploy Failure Rate](../operations/monitoring-alerting.md#deploy-pipeline-health)
- **Regression for:** [BUG-001](bug-reports.md#bug-001-multi-commit-deploy-with-unknown-blame), [ADR-001](../architecture/adrs.md#adr-001-atomic-deploy-model--one-commit-per-deploy)

**Precondition:** Service "checkout-api" has 3 undeployed commits on `main`: `aaa1111`, `bbb2222`, `ccc3333`.

**Steps:**
1. Run `pave deploy checkout-api --env staging`
2. Observe CLI output

**Expected:**
- CLI rejects with:
  ```
  Error: 3 commits ahead of last deploy. Pave deploys one commit at a time.

  Undeployed commits:
    ccc3333  fix: null pointer in cart (2h ago)
    bbb2222  feat: add discount field (5h ago)
    aaa1111  chore: update deps (1d ago)

  Run: pave deploy checkout-api --env staging --commit aaa1111
  ```
- No deploy is created in the system

---

### TC-104: Deploy with build failure
- **Proves:** [US-001](../product/epics.md#us-001-atomic-single-commit-deploys) AC: failed deploys are recorded with failure reason
- **Tests:** [CLI: `pave deploy` — build failure](../experience/cli-spec.md#pave-deploy); [POST /deploys](../architecture/api-spec.md#post-deploys) (build_failed status)
- **Monitored by:** [Deploy Failure Rate](../operations/monitoring-alerting.md#deploy-pipeline-health), [Build Duration p95](../operations/monitoring-alerting.md#deploy-pipeline-health)

**Precondition:** Service "checkout-api" has one new commit with a syntax error that fails the build step.

**Steps:**
1. Run `pave deploy checkout-api --env staging`
2. Observe CLI output
3. Run `pave status checkout-api --env staging`

**Expected:**
- Step 2: CLI shows build failure with log excerpt:
  ```
  Deploying checkout-api to staging
    Commit: eee5555 (feat: broken import)
    Building... FAILED

  Build error (line 42): Cannot find module './nonexistent'
  Deploy aborted. No changes applied.
  ```
- Step 3: Status shows last successful deploy (previous commit), not the failed one
- Deploy record exists with `status: build_failed` and `failure_reason` populated

---

### TC-105: Drift detection — out-of-band change detected
- **Proves:** [US-003](../product/epics.md#us-003-drift-detection) AC: Pave detects when production state diverges from expected state within 5 minutes
- **Tests:** [CLI: `pave status`](../experience/cli-spec.md#pave-status) (drift indicator); [GET /services/{id}/drift](../architecture/api-spec.md#get-servicesiddrift)
- **Monitored by:** [Drift Detected](../operations/monitoring-alerting.md#deploy-pipeline-health)
- **Regression for:** [BUG-002](bug-reports.md#bug-002-bypass-overwrite--pave-reverts-manual-hotfix), [ADR-002](../architecture/adrs.md#adr-002-drift-detection-via-state-fingerprinting)

**Precondition:** Service "checkout-api" is deployed at commit `abc1234`. K8s fingerprint is recorded.

**Steps:**
1. SSH into a staging node and manually `kubectl set image` to a different image tag
2. Wait up to 5 minutes for drift detection cycle
3. Run `pave status checkout-api --env staging`
4. Check dashboard for drift alert

**Expected:**
- Step 3: CLI shows:
  ```
  checkout-api  staging  DRIFT DETECTED
    Expected: abc1234 (image: registry.internal/checkout-api:abc1234)
    Actual:   manual-override (image: registry.internal/checkout-api:hotfix-1)
    Detected: 2025-07-15T10:45:00Z

  Run: pave drift resolve checkout-api --env staging
  ```
- Step 4: [Dashboard: Deploy Queue](../experience/dashboard-specs.md#deploy-queue-health) shows drift warning for checkout-api
- Pave API returns `drift_status: detected` with `expected_fingerprint` and `actual_fingerprint`

---

### TC-106: Drift detection — SSH mutation
- **Proves:** [US-003](../product/epics.md#us-003-drift-detection) AC: Pave detects manual changes to replica count, environment variables, and image tags
- **Tests:** [GET /services/{id}/drift](../architecture/api-spec.md#get-servicesiddrift); [ADR-002](../architecture/adrs.md#adr-002-drift-detection-via-state-fingerprinting) (fingerprinting covers replicas, env vars, image)
- **Monitored by:** [Drift Detected](../operations/monitoring-alerting.md#deploy-pipeline-health)

**Precondition:** Service "payments-api" deployed with 3 replicas, `DATABASE_URL` env var set.

**Steps:**
1. `kubectl scale deployment payments-api --replicas=5` (out-of-band)
2. Wait for drift detection cycle
3. `pave status payments-api --env staging`

**Expected:**
- Drift detected with details: `replicas: expected=3, actual=5`
- Service is flagged as drifted in dashboard

---

### TC-107: Drift detection — no drift (clean state)
- **Proves:** [US-003](../product/epics.md#us-003-drift-detection) AC: clean state produces no false drift alerts
- **Tests:** [GET /services/{id}/drift](../architecture/api-spec.md#get-servicesiddrift)
- **Monitored by:** [Drift Detected](../operations/monitoring-alerting.md#deploy-pipeline-health)

**Precondition:** Service "checkout-api" deployed normally via Pave. No manual changes.

**Steps:**
1. Run `pave status checkout-api --env staging`
2. Check drift status via API: `GET /services/checkout-api/drift`

**Expected:**
- CLI shows no drift indicator
- API returns `drift_status: clean`, `last_checked` within the last 5 minutes

---

### TC-108: Drift resolution — acknowledge and update
- **Proves:** [US-003](../product/epics.md#us-003-drift-detection) AC: team can acknowledge drift and update Pave's expected state to match the manual change
- **Tests:** [CLI: `pave drift resolve`](../experience/cli-spec.md#pave-drift-resolve); [POST /services/{id}/drift/resolve](../architecture/api-spec.md#post-servicesiddriftresolve)
- **Monitored by:** [Drift Detected](../operations/monitoring-alerting.md#deploy-pipeline-health)

**Precondition:** Drift detected on "checkout-api" (from TC-105).

**Steps:**
1. Run `pave drift resolve checkout-api --env staging --action accept`
2. Confirm the prompt: "Accept current production state as new baseline? [y/N]"
3. Type `y`
4. Run `pave status checkout-api --env staging`

**Expected:**
- Step 2: CLI explains what "accept" means: Pave will update its expected fingerprint to match current production
- Step 4: Status shows `deployed | manual-override | staging | DRIFT RESOLVED (accepted)`
- Audit log records who resolved the drift and which action was taken

---

### TC-109: Drift resolution — acknowledge and revert
- **Proves:** [US-003](../product/epics.md#us-003-drift-detection) AC: team can revert production to Pave's expected state
- **Tests:** [CLI: `pave drift resolve`](../experience/cli-spec.md#pave-drift-resolve); [POST /services/{id}/drift/resolve](../architecture/api-spec.md#post-servicesiddriftresolve) (action: revert)
- **Monitored by:** [Drift Detected](../operations/monitoring-alerting.md#deploy-pipeline-health), [Rollback Duration](../operations/monitoring-alerting.md#deploy-pipeline-health)

**Precondition:** Drift detected on "checkout-api" (manual image change).

**Steps:**
1. Run `pave drift resolve checkout-api --env staging --action revert`
2. Confirm prompt
3. Observe Pave restoring the expected state
4. Run `pave status checkout-api --env staging`

**Expected:**
- Pave re-applies the expected image tag `abc1234`
- Step 4: Status shows `deployed | abc1234 | staging` with no drift indicator
- Audit log records drift revert action

---

### TC-110: Deploy blocked when drift is unresolved
- **Proves:** [US-003](../product/epics.md#us-003-drift-detection) AC: deploys are blocked while drift is unresolved
- **Tests:** [CLI: `pave deploy` — drift block](../experience/cli-spec.md#pave-deploy); [POST /deploys](../architecture/api-spec.md#post-deploys) (409 drift_unresolved)
- **Monitored by:** [Drift Detected](../operations/monitoring-alerting.md#deploy-pipeline-health)

**Precondition:** Drift detected on "checkout-api", not resolved.

**Steps:**
1. Run `pave deploy checkout-api --env staging`

**Expected:**
- CLI rejects with:
  ```
  Error: Drift detected on checkout-api (staging). Resolve before deploying.

  Run: pave drift resolve checkout-api --env staging
  ```
- No deploy is created

---

### TC-111: Bypass overwrite prevention
- **Proves:** [US-003](../product/epics.md#us-003-drift-detection) AC: Pave does not deploy over a manual hotfix without drift resolution
- **Tests:** [POST /deploys](../architecture/api-spec.md#post-deploys) (409 drift_unresolved); [ADR-002](../architecture/adrs.md#adr-002-drift-detection-via-state-fingerprinting)
- **Monitored by:** [Drift Detected](../operations/monitoring-alerting.md#deploy-pipeline-health)
- **Regression for:** [BUG-002](bug-reports.md#bug-002-bypass-overwrite--pave-reverts-manual-hotfix)

**Precondition:** On-call engineer SSH'd into prod and applied a hotfix image `hotfix-42`. Pave detects drift.

**Steps:**
1. Another engineer runs `pave deploy checkout-api --env staging` with a new commit
2. Observe CLI output

**Expected:**
- Deploy is blocked with drift error referencing the out-of-band change
- Hotfix image remains running
- No automatic overwrite of the hotfix

---

### TC-112: Deploy audit trail recorded
- **Proves:** [US-008](../product/epics.md#us-008-full-deploy-audit-trail) AC: every deploy action records who, what, when, where, and outcome
- **Tests:** [GET /audit-log](../architecture/api-spec.md#get-audit-log) (deploy events); [Dashboard: Audit Log](../experience/dashboard-specs.md#audit-log-view)
- **Monitored by:** [Audit Log Growth](../operations/monitoring-alerting.md#access-control)

**Precondition:** A deploy was just completed (TC-101).

**Steps:**
1. Query `GET /audit-log?service=checkout-api&action=deploy&limit=1`
2. Open [Dashboard: Audit Log](../experience/dashboard-specs.md#audit-log-view) and filter by "checkout-api"

**Expected:**
- API returns audit entry with: `actor`, `action: deploy`, `service`, `environment`, `commit`, `timestamp`, `outcome: success`, `duration_seconds`
- Dashboard shows the same entry with human-readable formatting

---

## Suite 2: Canary Deploys (E2, Round 3)

> **Last run:** 2025-08-01 | **Environment:** staging | **Result:** 7/8 pass, TC-208 not yet executed | **Run by:** automated (CI)
> **Note:** TC-208 (non-Istio fallback) requires ECS staging environment not yet provisioned.
> **Confirmed by:** Dani Reeves (QA Lead), 2025-08-01

### TC-201: Canary deploy — 5% traffic split
- **Proves:** [US-004](../product/epics.md#us-004-canary-deploy-with-traffic-splitting) AC: deploy to configurable percentage of traffic (1-50%), canary pods receive only designated traffic share
- **Tests:** [CLI: `pave deploy --canary`](../experience/cli-spec.md#pave-deploy---canary); [POST /deploys](../architecture/api-spec.md#post-deploys) (strategy: canary); [Dashboard: Canary Status](../experience/dashboard-specs.md#canary-rollout-status)
- **Monitored by:** [Canary Error Rate](../operations/monitoring-alerting.md#canary-deploy-health), [Canary Traffic Split](../operations/monitoring-alerting.md#canary-deploy-health)

**Precondition:** Service "payments-api" deployed at `v1.2.0`. Istio VirtualService configured. New commit `v1.3.0` ready.

**Steps:**
1. Run `pave deploy payments-api --env staging --canary 5`
2. Observe CLI output
3. Send 1000 requests to payments-api endpoint
4. Count how many hit `v1.3.0` vs `v1.2.0`
5. Check canary dashboard

**Expected:**
- Step 2: CLI shows:
  ```
  Canary deploy: payments-api to staging
    Stable:  v1.2.0 (95% traffic)
    Canary:  v1.3.0 (5% traffic)
    Monitoring window: 10 min

  Canary is live. Watching metrics...
  ```
- Step 4: ~50 of 1000 requests (5% +-2%) hit `v1.3.0`
- Step 5: Dashboard shows split visualization with live error rate comparison

---

### TC-202: Canary promote — full rollout
- **Proves:** [US-004](../product/epics.md#us-004-canary-deploy-with-traffic-splitting) AC: promote canary to 100% when metrics are healthy
- **Tests:** [CLI: `pave canary promote`](../experience/cli-spec.md#pave-canary-promote); [POST /deploys/{id}/promote](../architecture/api-spec.md#post-deploysidpromote)
- **Monitored by:** [Deploy Success by Team](../operations/monitoring-alerting.md#deploy-metrics)

**Precondition:** Canary is live from TC-201 with healthy metrics.

**Steps:**
1. Run `pave canary promote payments-api --env staging`
2. Send 100 requests
3. Verify all traffic goes to `v1.3.0`

**Expected:**
- Step 1: CLI shows `Promoting canary v1.3.0 to 100%... done`
- Step 2: All requests hit `v1.3.0`
- Old `v1.2.0` pods are terminated
- Deploy record updated to `status: promoted`

---

### TC-203: Canary abort — traffic reverted
- **Proves:** [US-004](../product/epics.md#us-004-canary-deploy-with-traffic-splitting) AC: abort canary returns 100% traffic to stable
- **Tests:** [CLI: `pave canary abort`](../experience/cli-spec.md#pave-canary-abort); [POST /deploys/{id}/abort](../architecture/api-spec.md#post-deploysidabort)
- **Monitored by:** [Canary Error Rate](../operations/monitoring-alerting.md#canary-deploy-health)

**Precondition:** Canary is live at 5%.

**Steps:**
1. Run `pave canary abort payments-api --env staging`
2. Send 100 requests
3. Verify all traffic goes to stable version

**Expected:**
- Step 1: CLI shows `Aborting canary... reverting traffic to v1.2.0... done`
- Step 2: All requests hit `v1.2.0`
- Canary pods are terminated
- Deploy record updated to `status: aborted`

---

### TC-204: Auto-rollback on error rate threshold
- **Proves:** [US-005](../product/epics.md#us-005-auto-rollback-on-error-threshold) AC: auto-rollback triggers when canary error rate exceeds 5% for 2 consecutive minutes
- **Tests:** [POST /deploys](../architecture/api-spec.md#post-deploys) (auto-rollback trigger); [Dashboard: Canary Status](../experience/dashboard-specs.md#canary-rollout-status) (rollback event)
- **Monitored by:** [Canary Auto-Rollback Triggered](../operations/monitoring-alerting.md#canary-deploy-health)
- **Regression for:** [ADR-003](../architecture/adrs.md#adr-003-canary-deploy-via-weighted-traffic-splitting)

**Precondition:** Service "payments-api" canary deployed with image that returns 500 for 10% of requests.

**Steps:**
1. Run `pave deploy payments-api --env staging --canary 10`
2. Wait for error threshold to be detected (canary error rate > 5%)
3. Observe auto-rollback

**Expected:**
- Within 3 minutes, Pave detects canary error rate > 5%
- CLI shows: `Auto-rollback triggered: canary error rate 10.2% exceeds threshold 5%`
- All traffic reverts to stable version
- Deploy record: `status: auto_rolled_back`, `rollback_reason: error_rate_threshold`
- Dashboard shows rollback event with error rate chart

---

### TC-205: Auto-rollback on latency threshold
- **Proves:** [US-005](../product/epics.md#us-005-auto-rollback-on-error-threshold) AC: auto-rollback on latency threshold (p99 > 2x stable baseline)
- **Tests:** [POST /deploys](../architecture/api-spec.md#post-deploys) (latency-based rollback); [Dashboard: Canary Status](../experience/dashboard-specs.md#canary-rollout-status)
- **Monitored by:** [Canary Latency p99](../operations/monitoring-alerting.md#canary-deploy-health)

**Precondition:** Stable p99 latency is 200ms. Canary image has a 500ms sleep injected.

**Steps:**
1. Run `pave deploy payments-api --env staging --canary 10`
2. Wait for latency threshold detection
3. Observe auto-rollback

**Expected:**
- Canary p99 ~700ms (>2x stable 200ms)
- Auto-rollback triggers with reason: `latency_threshold`
- All traffic reverts to stable

---

### TC-206: Canary with custom traffic percentage
- **Proves:** [US-004](../product/epics.md#us-004-canary-deploy-with-traffic-splitting) AC: traffic percentage is configurable from 1% to 50%
- **Tests:** [CLI: `pave deploy --canary`](../experience/cli-spec.md#pave-deploy---canary); [POST /deploys](../architecture/api-spec.md#post-deploys)
- **Monitored by:** [Canary Traffic Split](../operations/monitoring-alerting.md#canary-deploy-health)

**Precondition:** Service "search-api" deployed at stable version.

**Steps:**
1. Run `pave deploy search-api --env staging --canary 25`
2. Send 400 requests
3. Count traffic split

**Expected:**
- ~100 of 400 requests (25% +-5%) hit canary
- CLI and dashboard reflect 25% split

---

### TC-207: Canary metrics comparison accuracy
- **Proves:** [US-004](../product/epics.md#us-004-canary-deploy-with-traffic-splitting) AC: dashboard shows side-by-side metrics (error rate, latency, throughput) for stable vs canary
- **Tests:** [Dashboard: Canary Status](../experience/dashboard-specs.md#canary-rollout-status) (metrics panel)
- **Monitored by:** [Canary Error Rate](../operations/monitoring-alerting.md#canary-deploy-health)

**Precondition:** Canary is live at 10% with both stable and canary receiving traffic.

**Steps:**
1. Open canary dashboard
2. Verify metrics panels show stable vs canary side by side
3. Compare dashboard numbers against Prometheus query results

**Expected:**
- Error rate, p50 latency, p99 latency, and throughput shown for both versions
- Dashboard values match Prometheus within 1% margin
- Refresh rate: every 15 seconds

---

### TC-208: Canary on service without Istio (fallback)
- **Proves:** [US-004](../product/epics.md#us-004-canary-deploy-with-traffic-splitting) AC: canary works for services without Istio via replica-based splitting
- **Tests:** [CLI: `pave deploy --canary`](../experience/cli-spec.md#pave-deploy---canary) (replica fallback); [ADR-003](../architecture/adrs.md#adr-003-canary-deploy-via-weighted-traffic-splitting) (fallback strategy)
- **Monitored by:** [Canary Traffic Split](../operations/monitoring-alerting.md#canary-deploy-health)
- **Status:** Not yet executed — ECS staging environment pending

**Precondition:** Service "gridline-api" runs on Docker Compose (no Istio).

**Steps:**
1. Run `pave deploy gridline-api --env staging --canary 20`
2. Observe the canary strategy used
3. Send requests and verify approximate split

**Expected:**
- CLI indicates replica-based canary (not Istio traffic splitting)
- Pave scales: 4 stable replicas + 1 canary replica (~20% by replica count)
- Warning in CLI: "Replica-based canary — traffic split is approximate"

---

## Suite 3: Onboarding (E3, Round 4)

> **Last run:** 2025-08-20 | **Environment:** staging | **Result:** 5/6 pass, TC-306 suspect | **Run by:** automated (CI)
> **Note:** TC-306 suspect — onboarding status tracking not verified after schema v2 migration.
> **Confirmed by:** Dani Reeves (QA Lead), 2025-08-20

### TC-301: pave.yaml validation — valid K8s service
- **Proves:** [US-007](../product/epics.md#us-007-service-definition-schema--paveyaml) AC: pave.yaml validation succeeds for valid K8s service definition
- **Tests:** [CLI: `pave validate`](../experience/cli-spec.md#pave-validate); [POST /services/validate](../architecture/api-spec.md#post-servicesvalidate)
- **Monitored by:** [Onboarding Failures](../operations/monitoring-alerting.md#onboarding)

**Precondition:** Valid pave.yaml:
```yaml
name: checkout-api
team: falcon
runtime: kubernetes
deploy:
  image: registry.internal/checkout-api
  replicas: 3
  port: 8080
  health_check: /healthz
```

**Steps:**
1. Run `pave validate`

**Expected:**
- CLI shows:
  ```
  Validating pave.yaml... OK

  Service:  checkout-api
  Team:     falcon
  Runtime:  kubernetes
  Ready to onboard. Run: pave init
  ```

---

### TC-302: pave.yaml validation — valid Docker Compose service
- **Proves:** [US-006](../product/epics.md#us-006-compatibility-mode-for-non-k8s-stacks) AC: Docker Compose services are supported; [US-007](../product/epics.md#us-007-service-definition-schema--paveyaml) AC: pave.yaml validates non-K8s runtime
- **Tests:** [CLI: `pave validate`](../experience/cli-spec.md#pave-validate); [ADR-005](../architecture/adrs.md#adr-005-adapter-pattern-for-multi-runtime-support) (Docker Compose adapter)
- **Monitored by:** [Onboarding Failures](../operations/monitoring-alerting.md#onboarding)

**Precondition:** Valid pave.yaml with Docker Compose runtime:
```yaml
name: gridline-api
team: gridline
runtime: docker-compose
deploy:
  compose_file: docker-compose.prod.yml
  service: api
  port: 3000
  health_check: /health
```

**Steps:**
1. Run `pave validate`

**Expected:**
- CLI shows validation success with runtime `docker-compose`
- Warning: "Docker Compose runtime — canary deploys use replica-based splitting (approximate)"

---

### TC-303: pave.yaml validation — missing required fields
- **Proves:** [US-007](../product/epics.md#us-007-service-definition-schema--paveyaml) AC: validation rejects invalid pave.yaml with actionable error messages
- **Tests:** [CLI: `pave validate`](../experience/cli-spec.md#pave-validate); [POST /services/validate](../architecture/api-spec.md#post-servicesvalidate) (400 with field errors)
- **Monitored by:** [Onboarding Failures](../operations/monitoring-alerting.md#onboarding)

**Precondition:** pave.yaml missing `team` and `deploy.health_check`:
```yaml
name: broken-service
runtime: kubernetes
deploy:
  image: registry.internal/broken
```

**Steps:**
1. Run `pave validate`

**Expected:**
- CLI shows:
  ```
  Validating pave.yaml... FAILED

  2 errors:
    - team: required field missing
    - deploy.health_check: required field missing (Pave needs a health endpoint for rollout verification)

  See: https://docs.pave.internal/schema
  ```

---

### TC-304: pave init wizard generates valid pave.yaml
- **Proves:** [US-007](../product/epics.md#us-007-service-definition-schema--paveyaml) AC: `pave init` generates a valid pave.yaml interactively
- **Tests:** [CLI: `pave init`](../experience/cli-spec.md#pave-init); [Onboarding Flow](../experience/onboarding-flows.md#guided-onboarding)
- **Monitored by:** [Onboarding Failures](../operations/monitoring-alerting.md#onboarding)

**Precondition:** Empty directory with a Dockerfile present.

**Steps:**
1. Run `pave init`
2. Answer prompts: service name "my-service", team "falcon", runtime "kubernetes", port "8080", health check "/healthz"
3. Verify generated pave.yaml
4. Run `pave validate`

**Expected:**
- Step 2: Interactive prompts with sensible defaults (auto-detects Dockerfile, suggests runtime)
- Step 3: pave.yaml is generated with all fields populated
- Step 4: Validation passes

---

### TC-305: Deploy from Docker Compose runtime
- **Proves:** [US-006](../product/epics.md#us-006-compatibility-mode-for-non-k8s-stacks) AC: Docker Compose services deploy through Pave without K8s
- **Tests:** [CLI: `pave deploy`](../experience/cli-spec.md#pave-deploy) (docker-compose runtime); [ADR-005](../architecture/adrs.md#adr-005-adapter-pattern-for-multi-runtime-support)
- **Monitored by:** [Deploy Success by Team](../operations/monitoring-alerting.md#deploy-metrics)

**Precondition:** "gridline-api" onboarded with Docker Compose runtime. One new commit.

**Steps:**
1. Run `pave deploy gridline-api --env staging`
2. Observe CLI output
3. Verify the Docker Compose service was updated

**Expected:**
- CLI shows deploy progress using `docker compose` commands (not `kubectl`)
- Service restarts with new image
- Health check at `/health` passes
- Deploy record created with `runtime: docker-compose`

---

### TC-306: Onboarding status tracking
- **Proves:** [US-007](../product/epics.md#us-007-service-definition-schema--paveyaml) AC: dashboard shows onboarding progress per team
- **Tests:** [Dashboard: Onboarding Status](../experience/dashboard-specs.md#onboarding-status); [GET /teams/{id}/onboarding](../architecture/api-spec.md#get-teamsidonboarding)
- **Monitored by:** [Onboarding Failures](../operations/monitoring-alerting.md#onboarding)
- **Status:** Suspect — not re-verified after schema v2 migration

**Precondition:** Team "gridline" has 5 services. 3 onboarded, 2 pending.

**Steps:**
1. Open onboarding dashboard
2. Check Team Gridline status

**Expected:**
- Dashboard shows: "Gridline: 3/5 services onboarded (60%)"
- Each service shows status: onboarded / pending / failed
- Pending services show next steps

---

## Suite 4: RBAC & Audit (E4, Round 5)

> **Last run:** 2025-09-01 | **Environment:** staging | **Result:** all pass | **Run by:** automated (CI)
> **Confirmed by:** Dani Reeves (QA Lead), 2025-09-01

### TC-401: Deploy to prod — authorized (deployer role)
- **Proves:** [US-009](../product/epics.md#us-009-rbac-per-team-x-environment) AC: team member with deployer role can deploy to their team's environments
- **Tests:** [CLI: `pave deploy`](../experience/cli-spec.md#pave-deploy); [POST /deploys](../architecture/api-spec.md#post-deploys) (RBAC check); [ADR-006](../architecture/adrs.md#adr-006-rbac-model--team-x-environment-matrix)
- **Monitored by:** [RBAC Violations](../operations/monitoring-alerting.md#access-control)

**Precondition:** User `kai.tanaka` has `deployer` role for Team Falcon on `staging` and `prod`. Service "checkout-api" belongs to Team Falcon.

**Steps:**
1. Authenticate as `kai.tanaka`
2. Run `pave deploy checkout-api --env prod`

**Expected:**
- Deploy proceeds normally
- Audit log records `actor: kai.tanaka`, `role: deployer`, `team: falcon`, `env: prod`

---

### TC-402: Deploy to prod — unauthorized (viewer role)
- **Proves:** [US-009](../product/epics.md#us-009-rbac-per-team-x-environment) AC: viewer role cannot deploy
- **Tests:** [CLI: `pave deploy` — permission denied](../experience/cli-spec.md#pave-deploy--permission-denied); [POST /deploys](../architecture/api-spec.md#post-deploys) (403 response)
- **Monitored by:** [RBAC Violations](../operations/monitoring-alerting.md#access-control)

**Precondition:** User `intern.jones` has `viewer` role for Team Falcon.

**Steps:**
1. Authenticate as `intern.jones`
2. Run `pave deploy checkout-api --env prod`

**Expected:**
- CLI shows:
  ```
  Error: Permission denied.
  You (intern.jones) have role 'viewer' on team 'falcon'.
  Deploying to 'prod' requires role 'deployer' or higher.

  Contact your team lead to request access.
  ```
- No deploy created
- Audit log records the denied attempt

---

### TC-403: Deploy to prod — unauthorized (deployer on wrong team)
- **Proves:** [US-009](../product/epics.md#us-009-rbac-per-team-x-environment) AC: deployer role on Team A cannot deploy Team B's services
- **Tests:** [POST /deploys](../architecture/api-spec.md#post-deploys) (403 — team mismatch); [ADR-006](../architecture/adrs.md#adr-006-rbac-model--team-x-environment-matrix)
- **Monitored by:** [RBAC Violations](../operations/monitoring-alerting.md#access-control)

**Precondition:** User `atlas.dev` has `deployer` for Team Atlas. Service "checkout-api" belongs to Team Falcon.

**Steps:**
1. Authenticate as `atlas.dev`
2. Run `pave deploy checkout-api --env staging`

**Expected:**
- CLI shows:
  ```
  Error: Permission denied.
  Service 'checkout-api' belongs to team 'falcon'.
  You (atlas.dev) are not a member of team 'falcon'.
  ```
- No deploy created

---

### TC-404: Intern role restrictions
- **Proves:** [US-009](../product/epics.md#us-009-rbac-per-team-x-environment) AC: intern role can deploy to dev only, not staging or prod
- **Tests:** [POST /deploys](../architecture/api-spec.md#post-deploys) (403 for staging/prod); [ADR-006](../architecture/adrs.md#adr-006-rbac-model--team-x-environment-matrix)
- **Monitored by:** [RBAC Violations](../operations/monitoring-alerting.md#access-control)

**Precondition:** User `intern.jones` has `intern` role for Team Falcon (dev only).

**Steps:**
1. Run `pave deploy checkout-api --env dev` as `intern.jones`
2. Run `pave deploy checkout-api --env staging` as `intern.jones`
3. Run `pave deploy checkout-api --env prod` as `intern.jones`

**Expected:**
- Step 1: Deploy succeeds
- Step 2: Permission denied — intern cannot deploy to staging
- Step 3: Permission denied — intern cannot deploy to prod

---

### TC-405: Role grant and revoke
- **Proves:** [US-009](../product/epics.md#us-009-rbac-per-team-x-environment) AC: team leads can grant and revoke roles for their team
- **Tests:** [CLI: `pave roles grant/revoke`](../experience/cli-spec.md#pave-roles); [POST /teams/{id}/roles](../architecture/api-spec.md#post-teamsidroles)
- **Monitored by:** [Audit Log Growth](../operations/monitoring-alerting.md#access-control)

**Precondition:** `kai.tanaka` is team lead for Falcon. `new.dev` exists with no roles.

**Steps:**
1. Run `pave roles grant new.dev --team falcon --role deployer --env staging`
2. Verify `new.dev` can deploy to staging
3. Run `pave roles revoke new.dev --team falcon --role deployer --env staging`
4. Verify `new.dev` cannot deploy to staging

**Expected:**
- Step 1: Role granted, audit log records the grant
- Step 2: Deploy succeeds
- Step 3: Role revoked, audit log records the revocation
- Step 4: Deploy denied with permission error

---

### TC-406: Audit log records all deploy actions
- **Proves:** [US-008](../product/epics.md#us-008-full-deploy-audit-trail) AC: every deploy action (start, complete, fail, rollback) is recorded with full context
- **Tests:** [GET /audit-log](../architecture/api-spec.md#get-audit-log); [Dashboard: Audit Log](../experience/dashboard-specs.md#audit-log-view); [ADR-007](../architecture/adrs.md#adr-007-immutable-audit-log-architecture)
- **Monitored by:** [Audit Log Growth](../operations/monitoring-alerting.md#access-control)

**Precondition:** Execute a deploy, a rollback, and a failed deploy.

**Steps:**
1. Deploy checkout-api successfully
2. Rollback checkout-api
3. Deploy with a bad image (build failure)
4. Query `GET /audit-log?service=checkout-api&limit=10`

**Expected:**
- 3 audit entries, each with: `actor`, `action`, `service`, `environment`, `commit`, `timestamp`, `outcome`, `duration_seconds`
- Actions recorded: `deploy`, `rollback`, `deploy` (with `outcome: build_failed`)
- Entries are immutable — no UPDATE or DELETE operations possible on audit log table

---

### TC-407: Audit log records role changes
- **Proves:** [US-008](../product/epics.md#us-008-full-deploy-audit-trail) AC: role changes are audited
- **Tests:** [GET /audit-log](../architecture/api-spec.md#get-audit-log) (role events); [ADR-007](../architecture/adrs.md#adr-007-immutable-audit-log-architecture)
- **Monitored by:** [Audit Log Growth](../operations/monitoring-alerting.md#access-control)

**Precondition:** Role grant from TC-405.

**Steps:**
1. Query `GET /audit-log?action=role_grant&actor=kai.tanaka&limit=5`

**Expected:**
- Entry shows: `actor: kai.tanaka`, `action: role_grant`, `target_user: new.dev`, `role: deployer`, `team: falcon`, `environment: staging`
- Revocation also recorded with `action: role_revoke`

---

### TC-408: Audit log query and filtering
- **Proves:** [US-008](../product/epics.md#us-008-full-deploy-audit-trail) AC: audit log is queryable by service, actor, action, time range
- **Tests:** [GET /audit-log](../architecture/api-spec.md#get-audit-log) (query params); [Dashboard: Audit Log](../experience/dashboard-specs.md#audit-log-view) (filters)
- **Monitored by:** [Audit Log Growth](../operations/monitoring-alerting.md#access-control)

**Precondition:** Multiple audit entries from prior test cases.

**Steps:**
1. Query `GET /audit-log?service=checkout-api&from=2025-09-01&to=2025-09-01`
2. Query `GET /audit-log?actor=kai.tanaka&action=deploy`
3. Open dashboard audit log and apply same filters

**Expected:**
- API returns filtered results matching criteria
- Dashboard mirrors API results
- Pagination works (100 entries per page)
- Export to CSV available

---

## Suite 5: Platform Resilience (E5, Round 6)

> **Last run:** 2025-09-15 | **Environment:** chaos lab | **Result:** 5/6 pass, TC-505 suspect | **Run by:** manual (Sasha Petrov)
> **Note:** TC-505 suspect — recovery test passed with clean shutdown but not with mid-write crash simulation.
> **Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-09-15

### TC-501: Event-sourced queue — normal operation
- **Proves:** [US-011](../product/epics.md#us-011-deploy-queue-resilience) AC: deploy queue processes deploys in FIFO order with no lost events
- **Tests:** [POST /deploys](../architecture/api-spec.md#post-deploys) (queue behavior); [ADR-008](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery)
- **Monitored by:** [Deploy Queue Depth](../operations/monitoring-alerting.md#deploy-pipeline-health)

**Precondition:** 5 deploys queued across 3 teams.

**Steps:**
1. Queue 5 deploys in rapid succession
2. Observe processing order
3. Verify all 5 complete

**Expected:**
- Deploys process in FIFO order
- Each deploy event is recorded in the event store
- All 5 complete with correct status
- Queue depth returns to 0

---

### TC-502: Event-sourced queue — rebuild from events after corruption
- **Proves:** [US-011](../product/epics.md#us-011-deploy-queue-resilience) AC: queue state can be rebuilt from the event log after corruption
- **Tests:** [ADR-008](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery) (WAL-based recovery)
- **Monitored by:** [Deploy Queue Depth](../operations/monitoring-alerting.md#deploy-pipeline-health), [Queue Recovery Events](../operations/monitoring-alerting.md#deploy-pipeline-health)
- **Regression for:** [BUG-003](bug-reports.md#bug-003-deploy-queue-corruption-during-rbac-migration)

**Precondition:** 3 deploys in queue. Event log intact.

**Steps:**
1. Corrupt the deploy queue table (simulate `TRUNCATE deploy_queue`)
2. Trigger queue recovery: `pave admin queue rebuild`
3. Check queue state

**Expected:**
- Queue is rebuilt from event log
- 3 pending deploys are restored in correct order
- No deploys are lost, no duplicates created
- Recovery audit entry logged

---

### TC-503: Manual bypass procedure — documented steps work
- **Proves:** [US-010](../product/epics.md#us-010-manual-bypass-when-pave-is-down) AC: documented bypass procedure allows deploys when Pave API is down
- **Tests:** [CLI: `pave bypass`](../experience/cli-spec.md#pave-bypass); [ADR-009](../architecture/adrs.md#adr-009-break-glass-bypass-procedure); [Runbook: Pave Down](../operations/monitoring-alerting.md#pave-down-runbook)
- **Monitored by:** [Pave API Health](../operations/monitoring-alerting.md#deploy-pipeline-health)

**Precondition:** Pave API is deliberately stopped. A P1 fix must ship.

**Steps:**
1. Verify Pave API is unreachable
2. Follow bypass runbook: `pave bypass deploy checkout-api --env prod --commit abc1234 --reason "P1 fix, Pave down"`
3. Verify the deploy happens directly via kubectl/docker
4. Restart Pave API
5. Verify Pave detects the bypass deploy and records it

**Expected:**
- Step 2: Bypass deploys directly using kubectl, bypassing the Pave queue
- Step 3: Service is running at `abc1234`
- Step 5: Pave reconciles the bypass deploy into its state, records it as `method: bypass` in audit log

---

### TC-504: Pave API down — bypass procedure accessible
- **Proves:** [US-010](../product/epics.md#us-010-manual-bypass-when-pave-is-down) AC: bypass documentation is accessible even when Pave is down
- **Tests:** [ADR-009](../architecture/adrs.md#adr-009-break-glass-bypass-procedure); [Runbook: Pave Down](../operations/monitoring-alerting.md#pave-down-runbook)
- **Monitored by:** [Pave API Health](../operations/monitoring-alerting.md#deploy-pipeline-health)

**Precondition:** Pave API is down.

**Steps:**
1. Run `pave bypass --help`
2. Verify the bypass procedure is printed locally (not fetched from API)

**Expected:**
- `pave bypass --help` works offline
- Prints step-by-step procedure with all required flags
- Includes emergency contacts

---

### TC-505: Deploy queue recovery — no duplicate deploys after recovery
- **Proves:** [US-011](../product/epics.md#us-011-deploy-queue-resilience) AC: after queue recovery, no deploy is executed twice
- **Tests:** [ADR-008](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery); [POST /deploys](../architecture/api-spec.md#post-deploys) (idempotency)
- **Monitored by:** [Deploy Queue Depth](../operations/monitoring-alerting.md#deploy-pipeline-health)
- **Status:** Suspect — tested with clean shutdown only, mid-write crash not yet simulated

**Precondition:** Deploy is mid-execution when Pave crashes.

**Steps:**
1. Start a deploy
2. Kill Pave process mid-deploy (after build, before rollout)
3. Restart Pave
4. Check: does the deploy resume or restart?
5. Verify the service was deployed exactly once

**Expected:**
- Pave detects the interrupted deploy
- Either resumes from the interrupted step or marks it as failed (no silent double-deploy)
- Service has the new image deployed exactly once
- Event log shows the interruption and recovery

---

### TC-506: Queue corruption detection
- **Proves:** [US-011](../product/epics.md#us-011-deploy-queue-resilience) AC: Pave detects queue corruption (event log vs queue state mismatch)
- **Tests:** [ADR-008](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery) (integrity check)
- **Monitored by:** [Queue Corruption Detected](../operations/monitoring-alerting.md#deploy-pipeline-health)

**Precondition:** Event log has 10 deploy events. Queue table manually modified to have 8 entries.

**Steps:**
1. Pave runs periodic integrity check (every 5 minutes)
2. Check alert state

**Expected:**
- Integrity check detects mismatch: "Queue state diverged from event log (8 vs 10 entries)"
- Alert fires on [Queue Corruption Detected](../operations/monitoring-alerting.md#deploy-pipeline-health)
- Dashboard shows queue health warning

---

## Suite 6: Deploy Metrics (E6, Round 7)

> **Last run:** 2025-10-01 | **Environment:** staging | **Result:** 5/6 pass, TC-606 not yet executed | **Run by:** automated (CI)
> **Note:** TC-606 requires 30-day historical data not yet available in staging.
> **Confirmed by:** Dani Reeves (QA Lead), 2025-10-01

### TC-601: Classification — feature deploy
- **Proves:** [US-013](../product/epics.md#us-013-deploy-classification) AC: feature deploys are classified as "substantive"
- **Tests:** [GET /deploys/{id}](../architecture/api-spec.md#get-deploysid) (classification field); [ADR-010](../architecture/adrs.md#adr-010-deploy-classification-engine)
- **Monitored by:** [Deploy Health Dashboard](../operations/monitoring-alerting.md#deploy-metrics)

**Precondition:** Commit changes `src/checkout/handler.go` — new feature code.

**Steps:**
1. Deploy the commit
2. Query `GET /deploys/{id}` for the deploy record
3. Check dashboard classification

**Expected:**
- `classification: substantive`
- `classification_reason: source_code_change`
- Dashboard shows deploy in "Feature Deploys" category

---

### TC-602: Classification — trivial deploy (README only)
- **Proves:** [US-013](../product/epics.md#us-013-deploy-classification) AC: README-only deploys are classified as "non-substantive"
- **Tests:** [GET /deploys/{id}](../architecture/api-spec.md#get-deploysid) (classification); [ADR-010](../architecture/adrs.md#adr-010-deploy-classification-engine)
- **Monitored by:** [Deploy Health Dashboard](../operations/monitoring-alerting.md#deploy-metrics)

**Precondition:** Commit only changes `README.md`.

**Steps:**
1. Deploy the commit
2. Query deploy record

**Expected:**
- `classification: non_substantive`
- `classification_reason: documentation_only`

---

### TC-603: Classification — config change
- **Proves:** [US-013](../product/epics.md#us-013-deploy-classification) AC: config-only changes are classified separately from feature work
- **Tests:** [GET /deploys/{id}](../architecture/api-spec.md#get-deploysid) (classification); [ADR-010](../architecture/adrs.md#adr-010-deploy-classification-engine)
- **Monitored by:** [Deploy Health Dashboard](../operations/monitoring-alerting.md#deploy-metrics)

**Precondition:** Commit only changes `config/prod.yaml` — updates a timeout value.

**Steps:**
1. Deploy the commit
2. Query deploy record

**Expected:**
- `classification: config_change`
- `classification_reason: config_file_only`
- Dashboard shows in "Config Changes" category

---

### TC-604: Health dashboard metrics accuracy
- **Proves:** [US-012](../product/epics.md#us-012-deploy-health-dashboard) AC: dashboard shows accurate success rate, MTTR, change failure rate, lead time
- **Tests:** [Dashboard: Deploy Health](../experience/dashboard-specs.md#deploy-health-dashboard); [GET /metrics/deploy-health](../architecture/api-spec.md#get-metricsdeploy-health)
- **Monitored by:** [Deploy Health Dashboard](../operations/monitoring-alerting.md#deploy-metrics)

**Precondition:** 20 deploys in the last 7 days: 18 success, 1 failed (rolled back in 3 min), 1 failed (rolled back in 7 min).

**Steps:**
1. Open deploy health dashboard
2. Verify each metric

**Expected:**
- Success rate: 90% (18/20)
- MTTR: 5 min average ((3+7)/2)
- Change failure rate: 10% (2/20)
- Values match API response from `GET /metrics/deploy-health`

---

### TC-605: Trivial deploys excluded from frequency KPI
- **Proves:** [US-013](../product/epics.md#us-013-deploy-classification) AC: non-substantive deploys do not inflate deploy frequency metrics
- **Tests:** [Dashboard: Deploy Health](../experience/dashboard-specs.md#deploy-health-dashboard) (frequency calculation); [ADR-010](../architecture/adrs.md#adr-010-deploy-classification-engine)
- **Monitored by:** [Deploy Health Dashboard](../operations/monitoring-alerting.md#deploy-metrics)

**Precondition:** Team Falcon: 8 deploys this week — 5 substantive, 2 config, 1 README.

**Steps:**
1. Open deploy health dashboard for Team Falcon
2. Check "Meaningful Deploy Frequency" metric

**Expected:**
- Meaningful frequency: 5/week (excludes non-substantive)
- Total frequency shown separately: 8/week
- Tooltip explains the difference

---

### TC-606: Team-relative baseline calculation
- **Proves:** [US-012](../product/epics.md#us-012-deploy-health-dashboard) AC: metrics are relative to team's own baseline, not company-wide
- **Tests:** [Dashboard: Team View](../experience/dashboard-specs.md#team-deploy-metrics); [GET /metrics/deploy-health?team=falcon](../architecture/api-spec.md#get-metricsdeploy-health)
- **Monitored by:** [Deploy Health Dashboard](../operations/monitoring-alerting.md#deploy-metrics)
- **Status:** Not yet executed — requires 30-day historical data

**Precondition:** Team Falcon has 30 days of deploy history.

**Steps:**
1. Open Team Falcon's metrics view
2. Check trend line and baseline indicator

**Expected:**
- Baseline is calculated from team's own 30-day rolling average
- Current week shown relative to baseline (above/below with percentage)
- No comparison to other teams' frequencies

---

## Suite 7: Secrets Management (E7, Round 8)

> **Last run:** 2025-10-20 | **Environment:** staging | **Result:** 5/6 pass, TC-706 not yet executed | **Run by:** manual (Sasha Petrov)
> **Note:** TC-706 (emergency rotation) requires Vault admin access in staging — pending provisioning.
> **Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-10-20

### TC-701: Secret rotation — zero downtime
- **Proves:** [US-014](../product/epics.md#us-014-secrets-rotation-without-redeploy) AC: services pick up new secret value without redeploy, zero downtime
- **Tests:** [CLI: `pave secrets rotate`](../experience/cli-spec.md#pave-secrets-rotate); [ADR-011](../architecture/adrs.md#adr-011-runtime-secrets-injection-via-sidecar) (sidecar refreshes secret)
- **Monitored by:** [Expired Secret In Use](../operations/monitoring-alerting.md#alert-expired-secret-in-use)

**Precondition:** Service "payments-api" uses secret `vault:secret/redis-creds`. Sidecar is running. Service is healthy.

**Steps:**
1. Run `pave secrets rotate redis-creds --path secret/redis-creds`
2. Monitor service health during rotation
3. After 60 seconds, verify the service is using the new secret
4. Check that old Redis connections gracefully closed

**Expected:**
- Step 1: CLI shows:
  ```
  Rotating secret: redis-creds
    Path: vault:secret/redis-creds
    Affected services: payments-api, checkout-api
    Rotating... done
    Waiting for services to pick up new secret...
    payments-api: refreshed (12s)
    checkout-api: refreshed (18s)
  Rotation complete. 0 errors.
  ```
- Step 2: No 5xx errors during rotation
- Step 3: Service connects to Redis with new credentials
- No pods restarted

---

### TC-702: Secret rotation — service restart (rolling, not full)
- **Proves:** [US-014](../product/epics.md#us-014-secrets-rotation-without-redeploy) AC: if sidecar refresh fails, Pave triggers rolling restart (not full restart)
- **Tests:** [ADR-011](../architecture/adrs.md#adr-011-runtime-secrets-injection-via-sidecar) (fallback to rolling restart)
- **Monitored by:** [Expired Secret In Use](../operations/monitoring-alerting.md#alert-expired-secret-in-use)

**Precondition:** Service "legacy-api" does not support sidecar refresh (reads secret at startup only).

**Steps:**
1. Run `pave secrets rotate api-key --path secret/api-key`
2. Observe rotation behavior for "legacy-api"
3. Monitor service availability

**Expected:**
- Sidecar signals that "legacy-api" requires restart
- Pave triggers rolling restart (one pod at a time)
- Zero downtime — old pods serve traffic until new pods are ready
- CLI shows: `legacy-api: rolling restart required (no sidecar support)`

---

### TC-703: Secret rotation — audit trail recorded
- **Proves:** [US-015](../product/epics.md#us-015-secrets-rotation-audit-trail) AC: rotation event recorded with who rotated, when, which services consumed the new secret
- **Tests:** [GET /audit-log](../architecture/api-spec.md#get-audit-log) (secret_rotation events); [Dashboard: Secrets Status](../experience/dashboard-specs.md#secrets-rotation-status)
- **Monitored by:** [Audit Log Growth](../operations/monitoring-alerting.md#access-control)

**Precondition:** Secret rotation from TC-701.

**Steps:**
1. Query `GET /audit-log?action=secret_rotation&limit=5`
2. Check dashboard secrets status

**Expected:**
- Audit entry: `actor: sasha.petrov`, `action: secret_rotation`, `secret_path: secret/redis-creds`, `affected_services: [payments-api, checkout-api]`, `outcome: success`
- Each service has a sub-entry with `refresh_method: sidecar` or `refresh_method: rolling_restart` and `refresh_duration_seconds`

---

### TC-704: Secret reference by path, not value
- **Proves:** [US-014](../product/epics.md#us-014-secrets-rotation-without-redeploy) AC: pave.yaml references secrets by Vault path, never contains plaintext values
- **Tests:** [CLI: `pave validate`](../experience/cli-spec.md#pave-validate) (secret reference validation); [ADR-011](../architecture/adrs.md#adr-011-runtime-secrets-injection-via-sidecar)
- **Monitored by:** [Onboarding Failures](../operations/monitoring-alerting.md#onboarding)

**Precondition:** pave.yaml with inline secret value:
```yaml
env:
  REDIS_PASSWORD: "s3cr3t-value"
```

**Steps:**
1. Run `pave validate`

**Expected:**
- CLI rejects with:
  ```
  Error: Plaintext secret detected in pave.yaml

    env.REDIS_PASSWORD appears to contain a secret value.
    Use a Vault reference instead: vault:secret/redis-creds#password

  See: https://docs.pave.internal/secrets
  ```

---

### TC-705: Expired secret detection
- **Proves:** [US-014](../product/epics.md#us-014-secrets-rotation-without-redeploy) AC: Pave alerts when a service is using an expired secret
- **Tests:** [Dashboard: Secrets Status](../experience/dashboard-specs.md#secrets-rotation-status); [ADR-012](../architecture/adrs.md#adr-012-secrets-rotation-event-bus)
- **Monitored by:** [Expired Secret In Use](../operations/monitoring-alerting.md#alert-expired-secret-in-use)

**Precondition:** Secret `vault:secret/redis-creds` was rotated 2 hours ago. Service "notifications-api" is still using the old secret (sidecar refresh failed silently).

**Steps:**
1. Check dashboard secrets status
2. Check alerting

**Expected:**
- Dashboard shows: "notifications-api: using expired secret (redis-creds, rotated 2h ago)"
- Alert fires: [Expired Secret In Use](../operations/monitoring-alerting.md#alert-expired-secret-in-use) with service name and secret path
- Remediation suggestion: "Run `pave secrets refresh notifications-api` or restart the service"

---

### TC-706: Emergency secret rotation
- **Proves:** [US-014](../product/epics.md#us-014-secrets-rotation-without-redeploy) AC: emergency rotation forces immediate restart of all consuming services
- **Tests:** [CLI: `pave secrets rotate --emergency`](../experience/cli-spec.md#pave-secrets-rotate); [ADR-011](../architecture/adrs.md#adr-011-runtime-secrets-injection-via-sidecar)
- **Monitored by:** [Expired Secret In Use](../operations/monitoring-alerting.md#alert-expired-secret-in-use)
- **Status:** Not yet executed — requires Vault admin access in staging

**Precondition:** Compromised secret must be rotated immediately.

**Steps:**
1. Run `pave secrets rotate redis-creds --path secret/redis-creds --emergency`
2. Observe behavior

**Expected:**
- All consuming services are restarted immediately (parallel, not rolling)
- Brief downtime accepted for security
- CLI shows: `EMERGENCY rotation — all consuming services will be restarted immediately`
- Audit log records `rotation_type: emergency`

---

## Suite 8: PCI Approval (E8, Round 9)

> **Last run:** 2025-11-15 | **Environment:** staging | **Result:** all pass | **Run by:** manual (Dani Reeves, with PCI auditor observation)
> **Confirmed by:** Dani Reeves (QA Lead), 2025-11-15

### TC-801: PCI deploy — approval required
- **Proves:** [US-016](../product/epics.md#us-016-pci-deploy-approval-workflow) AC: deploy to PCI-scoped service is blocked until security team approves
- **Tests:** [CLI: `pave deploy` — approval prompt](../experience/cli-spec.md#pave-deploy--approval-required); [POST /deploys](../architecture/api-spec.md#post-deploys) (pending_approval status); [ADR-013](../architecture/adrs.md#adr-013-approval-gate-middleware-pattern)
- **Monitored by:** [PCI Approval SLA](../operations/monitoring-alerting.md#compliance-gates)

**Precondition:** Service "payments-api" has `pci: true` in pave.yaml. Deploy to prod.

**Steps:**
1. Run `pave deploy payments-api --env prod`
2. Observe CLI output

**Expected:**
- CLI shows:
  ```
  Deploy requires approval (PCI-scoped service).
    Service: payments-api
    Environment: prod
    Commit: abc1234

  Approval request sent to: security-team@company.com
  Waiting for approval... (SLA: 30 minutes)
  Track: pave deploy status abc1234
  ```
- Deploy record: `status: pending_approval`
- Deploy does NOT proceed until approved

---

### TC-802: PCI deploy — approved, proceeds to prod
- **Proves:** [US-016](../product/epics.md#us-016-pci-deploy-approval-workflow) AC: after approval, deploy proceeds normally
- **Tests:** [Dashboard: Pending Approvals](../experience/dashboard-specs.md#pending-approval-queue); [POST /deploys/{id}/approve](../architecture/api-spec.md#post-deploysidapprove)
- **Monitored by:** [PCI Approval SLA](../operations/monitoring-alerting.md#compliance-gates)

**Precondition:** Deploy from TC-801 is pending approval.

**Steps:**
1. Security team member clicks "Approve" in dashboard (or runs `pave approve {deploy-id}`)
2. Observe deploy progression

**Expected:**
- Deploy proceeds through build, push, rollout
- CLI (if still waiting) shows: `Approved by security.lead@company.com — deploying...`
- Deploy completes normally
- Audit log records: `approver`, `approval_timestamp`, `time_to_approve`

---

### TC-803: PCI deploy — rejected, deploy blocked
- **Proves:** [US-016](../product/epics.md#us-016-pci-deploy-approval-workflow) AC: rejected deploy does not proceed
- **Tests:** [POST /deploys/{id}/reject](../architecture/api-spec.md#post-deploysidreject); [Dashboard: Pending Approvals](../experience/dashboard-specs.md#pending-approval-queue)
- **Monitored by:** [PCI Approval SLA](../operations/monitoring-alerting.md#compliance-gates)

**Precondition:** PCI deploy pending approval.

**Steps:**
1. Security team member clicks "Reject" with reason: "Needs vulnerability scan"
2. Check deploy status

**Expected:**
- Deploy record: `status: rejected`, `rejection_reason: "Needs vulnerability scan"`
- CLI shows: `Deploy rejected by security.lead@company.com. Reason: Needs vulnerability scan`
- Service remains at previous version

---

### TC-804: Non-PCI deploy — no approval needed
- **Proves:** [US-016](../product/epics.md#us-016-pci-deploy-approval-workflow) AC: non-PCI services skip the approval gate entirely
- **Tests:** [POST /deploys](../architecture/api-spec.md#post-deploys) (no approval gate); [ADR-014](../architecture/adrs.md#adr-014-pci-scope-tagging-in-pave-yaml)
- **Monitored by:** [Deploy Success by Team](../operations/monitoring-alerting.md#deploy-metrics)

**Precondition:** Service "search-api" does not have `pci: true` in pave.yaml.

**Steps:**
1. Run `pave deploy search-api --env prod`
2. Observe deploy proceeds immediately

**Expected:**
- No approval prompt
- Deploy goes straight to build and rollout
- No `pending_approval` status in deploy record

---

### TC-805: Approval SLA — 30-minute escalation
- **Proves:** [US-017](../product/epics.md#us-017-30-minute-sla-on-approvals) AC: if no response in 30 minutes, escalation triggers (Slack + email to security lead)
- **Tests:** [ADR-013](../architecture/adrs.md#adr-013-approval-gate-middleware-pattern) (escalation path); [Dashboard: Pending Approvals](../experience/dashboard-specs.md#pending-approval-queue)
- **Monitored by:** [PCI Approval SLA](../operations/monitoring-alerting.md#compliance-gates)

**Precondition:** PCI deploy pending approval for 30 minutes (simulate with clock manipulation or shortened timeout in staging).

**Steps:**
1. Submit PCI deploy approval request
2. Wait 30 minutes (or simulate timeout)
3. Observe escalation

**Expected:**
- After 30 minutes: Slack message to `#security-escalation` and email to security lead
- CLI shows: `Approval SLA exceeded (30 min). Escalation sent to security lead.`
- Deploy remains pending — NOT auto-approved
- Dashboard shows SLA breach indicator (red) on the pending approval

---

### TC-806: Approval audit trail
- **Proves:** [US-016](../product/epics.md#us-016-pci-deploy-approval-workflow) AC: complete approval chain recorded in audit log
- **Tests:** [GET /audit-log](../architecture/api-spec.md#get-audit-log) (approval events); [ADR-013](../architecture/adrs.md#adr-013-approval-gate-middleware-pattern)
- **Monitored by:** [Audit Log Growth](../operations/monitoring-alerting.md#access-control)

**Precondition:** PCI deploy approved from TC-802.

**Steps:**
1. Query `GET /audit-log?service=payments-api&action=approval&limit=5`

**Expected:**
- Entries show the full chain: `approval_requested` -> `approved` (or `rejected`)
- Each entry includes: `requester`, `approver`, `timestamp`, `time_to_approve`, `deploy_id`
- PCI auditor can query this for compliance evidence
