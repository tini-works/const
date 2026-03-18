# Bug Reports — Pave Deploy Platform

---

## BUG-001: Multi-Commit Deploy With Unknown Blame

**Severity:** P1 — Deploy safety broken
**Reported:** Round 1
**Reporter:** Kai Tanaka (on-call during Team Falcon incident)
**Status:** Fix verified
**Verified by:** automated (CI)
**Verified on:** 2025-07-15
**Environment:** staging
**Evidence:** TC-101, TC-103 all pass (Suite 1, staging, 2025-07-15). 50-deploy regression passed — zero multi-commit deploys accepted.

### Traceability

| Link | Target |
|------|--------|
| **Affected story** | [US-001: Atomic single-commit deploys](../product/epics.md#us-001-atomic-single-commit-deploys) — AC violated: "every deploy maps to exactly one commit" |
| **Fix documented in** | [ADR-001: Atomic Deploy Model](../architecture/adrs.md#adr-001-atomic-deploy-model--one-commit-per-deploy) |
| **CLI changes** | [CLI: `pave deploy` — multi-commit error](../experience/cli-spec.md#pave-deploy) (error message lists undeployed commits, suggests `--commit` flag) |
| **API changes** | [POST /deploys](../architecture/api-spec.md#post-deploys) (422 response when multiple undeployed commits detected) |
| **Regression tests** | [TC-101](test-suites.md#tc-101-atomic-deploy--single-commit), [TC-103](test-suites.md#tc-103-multi-commit-deploy--rejected) |
| **Production monitors** | [Deploy Failure Rate](../operations/monitoring-alerting.md#deploy-pipeline-health) |
| **Confirmed by** | Dani Reeves (QA Lead), 2025-07-15 |

### Summary

Team Falcon merged 3 PRs and ran `pave deploy` at 5 PM Friday. All three commits were bundled into a single deploy. The third commit introduced a bug that broke checkout. It took 40 minutes to identify which commit caused the failure because the deploy record showed all three commits as one unit. Rollback was manual and painful — nobody knew what state to rollback to.

### Steps to Reproduce

1. Merge 3 commits to `main` without deploying between each
2. Run `pave deploy checkout-api --env prod`
3. All 3 commits deploy as one unit
4. Checkout breaks
5. Try to determine which commit caused the failure — deploy record shows all 3

### Expected Behavior

Pave should reject the deploy when multiple undeployed commits exist, forcing the engineer to deploy one at a time with `--commit`. Each deploy maps to exactly one commit for unambiguous blame.

### Actual Behavior

Pave accepted the multi-commit deploy without warning. The deploy record listed all 3 SHAs with no indication of which was responsible for the failure. The team spent 40 minutes bisecting commits manually.

### Root Cause

The deploy pipeline had no commit count check. It simply deployed whatever was on the `main` branch HEAD relative to the last deployed commit. If multiple commits had accumulated, they were all included. The deploy record stored a "from" and "to" SHA range but no individual commit attribution. Rollback targeted the "from" SHA, which was correct, but the investigation to reach that conclusion was unnecessarily slow.

### Fix Description

- **Pre-deploy commit check:** Pave counts undeployed commits before starting. If > 1, deploy is rejected with a clear error listing all commits and suggesting `--commit <sha>`.
- **Single-commit enforcement:** API returns 422 if the deploy would include more than one commit.
- **Rollback target:** Always the immediately previous deployed commit — unambiguous.
- **Deploy record:** Stores exactly one commit SHA, not a range.

### Fix Verification

- **[TC-101](test-suites.md#tc-101-atomic-deploy--single-commit):** Single-commit deploy succeeds normally. PASS.
- **[TC-103](test-suites.md#tc-103-multi-commit-deploy--rejected):** Three undeployed commits — deploy rejected with commit list and remediation. PASS.
- **Regression test:** 50 deploys across 10 services — zero multi-commit deploys accepted.

### Post-Mortem Notes

The multi-commit deploy model was inherited from the legacy CI/CD pipeline where "deploy main" meant "deploy everything since last deploy." In a platform serving 20 teams, this creates unacceptable ambiguity. The one-commit-per-deploy constraint is a deliberate trade-off: it requires more deploys, but each deploy is fully traceable. The team accepted this because the old approach cost them 40 minutes of investigation during an incident — far more expensive than deploying incrementally.

### Preventive Action

- Added: pre-deploy commit count check — multi-commit deploys rejected at API layer (TC-103)
- Added: `--commit` flag for explicit commit selection when multiple are available
- Added: deploy record stores exactly one SHA, not a range
- Rule: deploy pipeline changes must be reviewed against the atomic deploy constraint in [ADR-001](../architecture/adrs.md#adr-001-atomic-deploy-model--one-commit-per-deploy)
- Rule: rollback target is always the previous deployed commit, no manual SHA input needed
- Traced to: [ADR-001](../architecture/adrs.md#adr-001-atomic-deploy-model--one-commit-per-deploy), TC-101, TC-103, [monitoring-alerting.md Deploy Failure Rate](../operations/monitoring-alerting.md#deploy-pipeline-health)

---

## BUG-002: Bypass Overwrite — Pave Reverts Manual Hotfix

**Severity:** P0 — Production safety / Operational trust
**Reported:** Round 2
**Reporter:** Sasha Petrov (on-call SRE)
**Status:** Fix verified
**Verified by:** Dani Reeves (manual review) + automated (CI)
**Verified on:** 2025-07-20
**Environment:** staging
**Evidence:** TC-105, TC-106, TC-110, TC-111 all pass (Suite 1, staging, 2025-07-20). Drift detection tested with SSH mutation, env var change, and replica change. 3 incident drill scenarios passed.

### Traceability

| Link | Target |
|------|--------|
| **Affected story** | [US-003: Drift detection](../product/epics.md#us-003-drift-detection) — AC violated: "Pave must not overwrite manual changes without detection" |
| **Fix documented in** | [ADR-002: Drift Detection via State Fingerprinting](../architecture/adrs.md#adr-002-drift-detection-via-state-fingerprinting) |
| **CLI changes** | [CLI: `pave status` — drift indicator](../experience/cli-spec.md#pave-status), [CLI: `pave drift resolve`](../experience/cli-spec.md#pave-drift-resolve) |
| **API changes** | [GET /services/{id}/drift](../architecture/api-spec.md#get-servicesiddrift), [POST /services/{id}/drift/resolve](../architecture/api-spec.md#post-servicesiddriftresolve), [POST /deploys](../architecture/api-spec.md#post-deploys) (409 drift_unresolved) |
| **Dashboard changes** | [Dashboard: Deploy Queue](../experience/dashboard-specs.md#deploy-queue-health) (drift warning indicator) |
| **Regression tests** | [TC-105](test-suites.md#tc-105-drift-detection--out-of-band-change-detected), [TC-106](test-suites.md#tc-106-drift-detection--ssh-mutation), [TC-110](test-suites.md#tc-110-deploy-blocked-when-drift-is-unresolved), [TC-111](test-suites.md#tc-111-bypass-overwrite-prevention) |
| **Production monitors** | [Drift Detected](../operations/monitoring-alerting.md#deploy-pipeline-health) |
| **Confirmed by** | Dani Reeves (QA Lead), 2025-07-20 |

### Summary

Saturday 2 AM. Payments-api was down — a Redis connection string was wrong in the latest deploy. Sasha (on-call SRE) SSH'd into the production node and manually patched the environment variable. Service came back. Monday morning, an engineer ran `pave deploy payments-api` with a new feature commit. Pave deployed the new image, which was built from the pre-hotfix codebase. The Redis connection string reverted to the broken value. Payments went down again. Sasha's hotfix was silently overwritten.

### Steps to Reproduce

1. Deploy payments-api with broken Redis connection string
2. Hotfix via SSH: `kubectl set env deployment/payments-api REDIS_URL=redis://correct:6379`
3. Service recovers
4. Another engineer runs `pave deploy payments-api --env prod` with a new commit that does NOT include the hotfix
5. Pave deploys the new image, overwriting the environment variable
6. Payments-api goes down again

### Expected Behavior

After the SSH hotfix, Pave should detect that production state differs from its expected state (drift). The next deploy should be blocked until the team explicitly resolves the drift — either by accepting the manual change as the new baseline, or reverting it.

### Actual Behavior

Pave had no concept of drift. It tracked "last deployed commit" but not "current production state." The deploy pipeline compared the Git commit being deployed to the last deployed commit — it never checked what was actually running in the cluster. The manual hotfix was invisible to Pave.

### Root Cause

Pave stored deploy state as a commit SHA, not as a cluster state fingerprint. It assumed that production always matched the last deployed commit. Any out-of-band change (SSH, manual kubectl, Helm override) was invisible.

Two specific failures:
1. **No state fingerprinting:** Pave never queried the K8s API to compare expected vs actual deployment spec.
2. **No pre-deploy drift check:** The deploy pipeline did not verify that the cluster matched the expected state before applying a new deploy.

### Fix Description

- **State fingerprinting:** After each deploy, Pave records a fingerprint of the K8s deployment spec (image, replicas, env vars, resource limits). Fingerprint is a SHA-256 hash of the normalized deployment spec.
- **Periodic drift check:** Every 5 minutes, Pave compares the recorded fingerprint against the live cluster state.
- **Pre-deploy drift check:** Before any deploy starts, Pave checks for drift. If drift is detected, deploy is blocked with `409 drift_unresolved`.
- **Drift resolution:** Two options via `pave drift resolve`:
  - `--action accept`: Update Pave's expected fingerprint to match the current production state
  - `--action revert`: Re-apply Pave's expected state to production (undo the manual change)
- **Drift visibility:** `pave status` shows drift indicator. Dashboard shows drift warnings.

### Fix Verification

- **[TC-105](test-suites.md#tc-105-drift-detection--out-of-band-change-detected):** SSH into staging, change image tag. Pave detects drift within 5 minutes. PASS.
- **[TC-106](test-suites.md#tc-106-drift-detection--ssh-mutation):** Change replica count out-of-band. Pave detects replica drift. PASS.
- **[TC-110](test-suites.md#tc-110-deploy-blocked-when-drift-is-unresolved):** Attempt deploy with unresolved drift — blocked with clear error. PASS.
- **[TC-111](test-suites.md#tc-111-bypass-overwrite-prevention):** Simulate exact incident scenario — hotfix SSH + new deploy. Deploy blocked. Hotfix preserved. PASS.
- **Incident drill:** 3 drill scenarios (image change, env var change, replica scaling) — all detected and blocked correctly.

### Post-Mortem Notes

This bug destroyed operational trust. Sasha spent an hour fixing a production outage, only to have the fix silently reverted on Monday. The root problem was that Pave operated on a "source of truth is Git" model without acknowledging that production is its own source of truth. The fix introduces a "dual source of truth" model: Pave knows what it deployed (Git commit), and it knows what is actually running (cluster fingerprint). When they diverge, Pave stops and asks.

The decision to block deploys on drift (rather than just warn) was deliberate. A warning would be ignored during a busy Monday morning. Blocking forces the conversation: "Something changed in production — was it intentional?"

### Preventive Action

- Added: state fingerprinting after every deploy — Pave records the expected cluster state ([ADR-002](../architecture/adrs.md#adr-002-drift-detection-via-state-fingerprinting))
- Added: 5-minute drift detection cycle comparing fingerprint to live cluster
- Added: pre-deploy drift check — deploy blocked if drift is unresolved (TC-110, TC-111)
- Added: `pave drift resolve` with accept/revert options (TC-108, TC-109)
- Rule: any change to the fingerprinting algorithm requires QA verification of TC-105 through TC-111
- Rule: new deployment spec fields (e.g., annotations, labels) must be included in the fingerprint hash — reviewed during API spec sign-off
- Traced to: [ADR-002](../architecture/adrs.md#adr-002-drift-detection-via-state-fingerprinting), TC-105, TC-106, TC-110, TC-111, [monitoring-alerting.md Drift Detected](../operations/monitoring-alerting.md#deploy-pipeline-health)

---

## BUG-003: Deploy Queue Corruption During RBAC Migration

**Severity:** P0 — Platform outage (4-hour deploy blackout)
**Reported:** Round 6
**Reporter:** Multiple teams (escalation via #platform-eng Slack)
**Status:** Fix verified
**Verified by:** Sasha Petrov (manual chaos test) + automated (CI)
**Verified on:** 2025-09-15
**Environment:** chaos lab
**Evidence:** TC-501, TC-502, TC-506 all pass (Suite 5, chaos lab, 2025-09-15). TC-505 suspect — clean shutdown recovery verified, mid-write crash not yet tested.

### Traceability

| Link | Target |
|------|--------|
| **Affected story** | [US-011: Deploy queue resilience](../product/epics.md#us-011-deploy-queue-resilience) — AC violated: "no single migration or internal failure should block all deploys" |
| **Fix documented in** | [ADR-008: Deploy Queue Resilience](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery), [ADR-009: Break-Glass Bypass Procedure](../architecture/adrs.md#adr-009-break-glass-bypass-procedure) |
| **CLI changes** | [CLI: `pave bypass`](../experience/cli-spec.md#pave-bypass) (break-glass deploy), [CLI: `pave admin queue rebuild`](../experience/cli-spec.md#pave-admin) |
| **Dashboard changes** | [Dashboard: Queue Health](../experience/dashboard-specs.md#deploy-queue-health) (corruption indicator, recovery status) |
| **Regression tests** | [TC-501](test-suites.md#tc-501-event-sourced-queue--normal-operation), [TC-502](test-suites.md#tc-502-event-sourced-queue--rebuild-from-events), [TC-505](test-suites.md#tc-505-deploy-queue-recovery--no-duplicate-deploys-after-recovery), [TC-506](test-suites.md#tc-506-queue-corruption-detection) |
| **Production monitors** | [Deploy Queue Depth](../operations/monitoring-alerting.md#deploy-pipeline-health), [Queue Corruption Detected](../operations/monitoring-alerting.md#deploy-pipeline-health) |
| **Operations runbook** | [Runbook: Pave Down](../operations/monitoring-alerting.md#pave-down-runbook) |
| **Confirmed by** | Sasha Petrov (DevOps/SRE), 2025-09-15 |

### Summary

The RBAC feature (E4) required a database migration that added columns to the `deploy_queue` table. The migration ran an `ALTER TABLE` that acquired an exclusive lock on the table. This is normally fast (<1 second), but the table had 847 rows of pending/historical deploy events. The lock acquisition took 15 seconds, during which the migration script timed out and was retried by the deployment automation. The retry attempted the same `ALTER TABLE`, creating a deadlock. The deploy queue was locked for 4 hours. Nobody could deploy. Three teams had P1 fixes queued.

### Steps to Reproduce

1. Have a `deploy_queue` table with 500+ rows
2. Run `ALTER TABLE deploy_queue ADD COLUMN rbac_team VARCHAR(255)` with a 10-second timeout
3. The lock contention with active deploy workers causes timeout
4. Retry the migration — deadlock
5. All deploys are blocked

### Expected Behavior

A database migration should never block the deploy queue for more than a few seconds. If the migration takes longer than expected, it should fail safely without locking the table. Teams should have a bypass path for critical deploys.

### Actual Behavior

The migration deadlocked the `deploy_queue` table. All `INSERT` and `SELECT` queries on the table hung. The deploy API returned 503 for all deploy requests. No bypass mechanism existed — if Pave was broken, nobody could deploy anything.

### Root Cause

Three compounding failures:
1. **No migration safety:** The `ALTER TABLE` was run directly on the active queue table without consideration for concurrent access. PostgreSQL's `ALTER TABLE ADD COLUMN` takes an `ACCESS EXCLUSIVE` lock.
2. **Retry-on-timeout:** The deployment automation retried the timed-out migration, creating a deadlock (two sessions both waiting for an exclusive lock).
3. **No bypass:** Pave was the only deploy path. When it was down, the entire company's ability to ship was gone.

### Fix Description

**Queue resilience ([ADR-008](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery)):**
- **Event-sourced queue:** Deploy state is now an event log (append-only). The queue materialized view can be rebuilt from events at any time. Corruption of the materialized view does not lose data.
- **Non-blocking migrations:** All future migrations on the deploy tables use `ALTER TABLE ... ADD COLUMN ... DEFAULT ... NOT NULL` (PostgreSQL 11+ does this without full table rewrite) and are tested against a loaded table in staging.
- **Integrity check:** Every 5 minutes, Pave compares the event log count to the materialized queue. Mismatch triggers an alert.
- **Queue rebuild:** `pave admin queue rebuild` reconstructs the queue from the event log.

**Break-glass bypass ([ADR-009](../architecture/adrs.md#adr-009-break-glass-bypass-procedure)):**
- `pave bypass deploy` deploys directly via kubectl/docker, bypassing the Pave API entirely.
- Bypass procedure is embedded in the CLI binary (works offline).
- After Pave recovers, it reconciles bypass deploys into its state via drift detection.

### Fix Verification

- **[TC-501](test-suites.md#tc-501-event-sourced-queue--normal-operation):** 5 queued deploys, all process in FIFO order. PASS.
- **[TC-502](test-suites.md#tc-502-event-sourced-queue--rebuild-from-events):** Truncate queue table, rebuild from event log — 3 pending deploys restored. PASS.
- **[TC-506](test-suites.md#tc-506-queue-corruption-detection):** Manually modify queue (delete 2 entries) — integrity check fires alert within 5 minutes. PASS.
- **[TC-503](test-suites.md#tc-503-manual-bypass-procedure--documented-steps-work):** Kill Pave API, deploy via bypass, restart Pave, verify reconciliation. PASS.
- **[TC-505](test-suites.md#tc-505-deploy-queue-recovery--no-duplicate-deploys-after-recovery):** Clean shutdown recovery verified — no duplicates. SUSPECT — mid-write crash not yet tested.

### Post-Mortem Notes

This was a 4-hour outage of the deploy platform. Three teams could not ship P1 fixes. The incident exposed a single point of failure: the entire company's deploy capability depended on one database table in one service. The event-sourced queue design eliminates the single table as a SPOF — the event log is the source of truth, and the materialized view is disposable. The bypass procedure ensures that even if Pave is completely down, teams can still ship.

The most important lesson: **the platform itself needs an SLA, and that SLA needs a degradation mode.** "Pave is down" should never mean "nobody can deploy."

### Preventive Action

- Added: event-sourced queue — deploy state stored as append-only events, materialized view is rebuildable ([ADR-008](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery))
- Added: 5-minute integrity check comparing event log to materialized queue (TC-506)
- Added: `pave bypass deploy` for break-glass deploys when Pave is down ([ADR-009](../architecture/adrs.md#adr-009-break-glass-bypass-procedure))
- Added: bypass procedure embedded in CLI binary — works offline (TC-504)
- Rule: all migrations on deploy-critical tables must be tested against a loaded staging instance (500+ rows, concurrent workers) before production
- Rule: no exclusive table locks on deploy-critical tables — use online DDL techniques
- Rule: any new database migration is reviewed by SRE (Sasha Petrov) for lock analysis before merge
- Traced to: [ADR-008](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery), [ADR-009](../architecture/adrs.md#adr-009-break-glass-bypass-procedure), TC-501, TC-502, TC-505, TC-506, [monitoring-alerting.md Deploy Queue Depth](../operations/monitoring-alerting.md#deploy-pipeline-health)
