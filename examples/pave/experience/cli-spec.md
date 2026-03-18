# CLI Spec — Pave Deploy Platform

The CLI is the primary interface. Engineers interact with Pave through `pave` more than any dashboard. Every command must be fast, predictable, and self-documenting.

**Global flags** (all commands):
- `--json` — machine-readable JSON output (default: human-readable)
- `--verbose` / `-v` — include debug-level detail
- `--quiet` / `-q` — suppress non-error output
- `--no-color` — disable ANSI color codes (auto-detected for non-TTY)
- `--config <path>` — override pave.yaml location (default: `./pave.yaml`)

**Exit codes:**
- `0` — success
- `1` — general error (bad input, missing config)
- `2` — deploy/operation failed
- `3` — permission denied
- `4` — timeout
- `5` — Pave service unreachable

---

## 1. Core Commands

### 1.1 `pave deploy`

**Purpose:** Deploy the current service to the target environment.

| Trace | Link |
|-------|------|
| Traced from | [US-001](../product/user-stories.md#us-001-standard-deploy-with-commit-visibility), [US-002](../product/user-stories.md#us-002-deploy-rollback), [E1](../product/epics.md#e1-core-deploy-pipeline) |
| Matched by | [POST /deploys](../architecture/api-spec.md#post-deploys), [Deploy Service](../architecture/architecture.md#deploy-service) |
| Proven by | [TC-101](../quality/test-suites.md#tc-101-standard-deploy-happy-path), [TC-102](../quality/test-suites.md#tc-102-deploy-with-commit-list-output) |
| Confirmed by | Rina Okafor (DX Designer), 2025-06-15 |

**Synopsis:**
```
pave deploy [--env <environment>] [--service <name>] [--wait] [--skip-checks]
```

**Arguments:**
- `--env` — target environment. Default: `staging`. Values: `staging`, `production`.
- `--service` — service name. Default: inferred from `pave.yaml` in current directory.
- `--wait` — block until deploy completes (default: returns immediately with deploy ID).
- `--skip-checks` — skip pre-deploy validation. Requires `deployer` role or higher.

**Example output:**
```
$ pave deploy --env production --wait
Deploying checkout-service v2.14.3 to production...

Commits included:
  abc1234  Fix null pointer in cart total  (Kai Tanaka, 2h ago)
  def5678  Add retry logic to payment call (Dani Reeves, 4h ago)
  gh9012   Update error message for expired cards (Rina Okafor, 1d ago)

Deploy ID: dep-20250615-0847
Status: queued → building → deploying → healthy
Duration: 3m 42s

✓ Deploy successful. 3 pods healthy, 0 errors in first 60s.
```

**Error cases:**

| Error | Message | Remediation |
|-------|---------|-------------|
| No pave.yaml | `Error: No pave.yaml found in current directory. Run 'pave init' to create one, or use --config to specify a path.` | Run `pave init` |
| Image build failed | `Error: Image build failed (exit code 1). Check build logs: pave log dep-20250615-0847 --phase build` | Check build output |
| Pending approval | `Error: Deploy to payments-service requires security approval (PCI scope). Request approval: pave approve request dep-20250615-0847` | Request approval via CLI or Slack |
| Permission denied | `Error: You don't have permission to deploy to production. Required role: deployer. Your role: viewer. Request access: pave access request deployer` | Request role upgrade |
| Drift detected | `Error: Drift detected on checkout-service. Live state differs from last known deploy. Run 'pave drift show checkout-service' to see differences. To deploy anyway: pave deploy --force` | Investigate drift first |

---

### 1.2 `pave rollback`

**Purpose:** Roll back a service to a previous known-good deploy.

| Trace | Link |
|-------|------|
| Traced from | [US-002](../product/user-stories.md#us-002-deploy-rollback), [E1](../product/epics.md#e1-core-deploy-pipeline) |
| Matched by | [POST /deploys/{id}/rollback](../architecture/api-spec.md#post-deploysidrollback), [Deploy Service](../architecture/architecture.md#deploy-service) |
| Proven by | [TC-103](../quality/test-suites.md#tc-103-rollback-to-previous-deploy), [TC-104](../quality/test-suites.md#tc-104-rollback-during-active-deploy) |
| Confirmed by | Rina Okafor (DX Designer), 2025-06-15 |

**Synopsis:**
```
pave rollback [--env <environment>] [--service <name>] [--to <deploy-id>] [--reason <text>]
```

**Arguments:**
- `--to` — specific deploy ID to roll back to. Default: previous successful deploy.
- `--reason` — freeform text logged in audit trail. Required for production rollbacks.

**Example output:**
```
$ pave rollback --env production --reason "Error rate spike after dep-20250615-0847"
Rolling back checkout-service to dep-20250614-1623 (v2.14.2)...

Current:  dep-20250615-0847  v2.14.3  (deployed 22 min ago)
Target:   dep-20250614-1623  v2.14.2  (deployed 1d ago, ran 23h without issues)

Status: rolling back → deploying → healthy
Duration: 1m 15s

✓ Rollback complete. checkout-service is now running v2.14.2.
  Rolled-back deploy flagged for review: dep-20250615-0847
```

**Error cases:**

| Error | Message | Remediation |
|-------|---------|-------------|
| No previous deploy | `Error: No previous successful deploy found for checkout-service in production. Cannot rollback.` | Manual intervention needed |
| Target deploy too old | `Warning: Target deploy dep-20250601-0900 is 14 days old. Schema migrations may have occurred since. Proceed? [y/N]` | Confirm or choose a newer target |
| Reason required | `Error: Production rollbacks require a reason. Use --reason "description of why".` | Add --reason flag |

---

### 1.3 `pave status`

**Purpose:** Show current deploy status for a service or all services.

| Trace | Link |
|-------|------|
| Traced from | [US-001](../product/user-stories.md#us-001-standard-deploy-with-commit-visibility), [E1](../product/epics.md#e1-core-deploy-pipeline) |
| Matched by | [GET /services/{name}/status](../architecture/api-spec.md#get-servicesnamestatus), [GET /deploys](../architecture/api-spec.md#get-deploys) |
| Proven by | [TC-105](../quality/test-suites.md#tc-105-status-shows-current-deploy-info) |
| Confirmed by | Rina Okafor (DX Designer), 2025-06-15 |

**Synopsis:**
```
pave status [<service>] [--env <environment>] [--all]
```

**Example output:**
```
$ pave status checkout-service --env production
checkout-service  production

  Current deploy:  dep-20250615-0847  v2.14.3
  Deployed:        22 min ago by kai.tanaka
  Pods:            3/3 healthy
  Error rate:      0.02% (baseline: 0.03%)
  Last rollback:   dep-20250610-1100 (5 days ago)

$ pave status --all --env production
SERVICE              VERSION   DEPLOYED      PODS    ERROR RATE   STATUS
checkout-service     v2.14.3   22m ago       3/3     0.02%        healthy
payments-service     v4.1.0    2h ago        5/5     0.00%        healthy
user-service         v1.8.1    3d ago        2/2     0.01%        healthy
notifications        v0.9.2    1d ago        1/1     0.15%        degraded
```

---

### 1.4 `pave log`

**Purpose:** View logs for a deploy, build, or running service.

| Trace | Link |
|-------|------|
| Traced from | [US-001](../product/user-stories.md#us-001-standard-deploy-with-commit-visibility), [E1](../product/epics.md#e1-core-deploy-pipeline) |
| Matched by | [GET /deploys/{id}/logs](../architecture/api-spec.md#get-deploysidlogs) |
| Proven by | [TC-106](../quality/test-suites.md#tc-106-log-output-for-deploy-phases) |
| Confirmed by | Rina Okafor (DX Designer), 2025-06-15 |

**Synopsis:**
```
pave log <deploy-id> [--phase <build|deploy|runtime>] [--follow] [--since <duration>]
```

**Arguments:**
- `--phase` — filter to specific deploy phase. Default: all phases.
- `--follow` / `-f` — stream logs in real-time.
- `--since` — show logs from the last N minutes/hours (e.g., `--since 30m`).

**Example output:**
```
$ pave log dep-20250615-0847 --phase build
[build] 2025-06-15T08:47:12Z  Pulling base image node:20-slim...
[build] 2025-06-15T08:47:15Z  Running npm ci...
[build] 2025-06-15T08:47:28Z  Running npm test...
[build] 2025-06-15T08:47:45Z  Tests passed (142 passed, 0 failed)
[build] 2025-06-15T08:47:46Z  Building image checkout-service:v2.14.3...
[build] 2025-06-15T08:47:58Z  Image pushed to registry.
```

---

## 2. Canary Commands

### 2.1 `pave canary start`

**Purpose:** Start a canary deploy — route a percentage of traffic to the new version.

| Trace | Link |
|-------|------|
| Traced from | [US-005](../product/user-stories.md#us-005-canary-deploy-with-traffic-splitting), [E2](../product/epics.md#e2-canary-deploys) |
| Matched by | [POST /deploys/{id}/canary](../architecture/api-spec.md#post-deploysidcanary), [Canary Controller](../architecture/architecture.md#canary-controller) |
| Proven by | [TC-201](../quality/test-suites.md#tc-201-canary-start-with-traffic-split), [TC-202](../quality/test-suites.md#tc-202-canary-metrics-comparison) |
| Confirmed by | Rina Okafor (DX Designer), 2025-07-20 |

**Synopsis:**
```
pave canary start [--env <environment>] [--service <name>] [--traffic <percent>] [--duration <time>]
```

**Arguments:**
- `--traffic` — initial traffic percentage to canary. Default: `5`. Range: 1-50.
- `--duration` — how long to observe before requiring promote/abort. Default: `30m`.

**Example output:**
```
$ pave canary start --env production --traffic 10 --duration 1h
Starting canary deploy for payments-service v4.2.0...

Baseline: v4.1.0 (90% traffic)
Canary:   v4.2.0 (10% traffic)

Observe period: 1 hour (until 10:47 AM)
Dashboard: https://pave.internal/canary/can-20250720-0947

Monitoring:
  Error rate (canary):   0.00%  vs baseline 0.00%   ✓
  p99 latency (canary):  45ms   vs baseline 42ms    ✓

After observation: pave canary promote | pave canary abort
```

---

### 2.2 `pave canary promote`

**Purpose:** Promote canary to full traffic — the canary becomes the new production.

| Trace | Link |
|-------|------|
| Traced from | [US-005](../product/user-stories.md#us-005-canary-deploy-with-traffic-splitting), [E2](../product/epics.md#e2-canary-deploys) |
| Matched by | [POST /canary/{id}/promote](../architecture/api-spec.md#post-canaryidpromote) |
| Proven by | [TC-203](../quality/test-suites.md#tc-203-canary-promote-to-full-traffic) |
| Confirmed by | Rina Okafor (DX Designer), 2025-07-20 |

**Synopsis:**
```
pave canary promote [--service <name>] [--env <environment>]
```

**Example output:**
```
$ pave canary promote --env production
Promoting payments-service canary v4.2.0 to full traffic...

Canary observation summary:
  Duration:      47 min
  Error rate:    0.01% (baseline: 0.02%)  ✓ better
  p99 latency:   43ms  (baseline: 42ms)   ✓ within threshold
  Requests:      12,847

Status: promoting → scaling up → draining baseline → complete

✓ Canary promoted. payments-service is now running v4.2.0 at 100% traffic.
```

---

### 2.3 `pave canary abort`

**Purpose:** Abort canary — route all traffic back to baseline, tear down canary pods.

| Trace | Link |
|-------|------|
| Traced from | [US-005](../product/user-stories.md#us-005-canary-deploy-with-traffic-splitting), [E2](../product/epics.md#e2-canary-deploys) |
| Matched by | [POST /canary/{id}/abort](../architecture/api-spec.md#post-canaryidabort) |
| Proven by | [TC-204](../quality/test-suites.md#tc-204-canary-abort-restores-baseline) |
| Confirmed by | Rina Okafor (DX Designer), 2025-07-20 |

**Synopsis:**
```
pave canary abort [--service <name>] [--env <environment>] [--reason <text>]
```

**Example output:**
```
$ pave canary abort --env production --reason "Error rate 5x baseline after 15 min"
Aborting canary for payments-service...

Routing 100% traffic back to baseline v4.1.0...
Tearing down canary pods...

✓ Canary aborted. payments-service is running v4.1.0 at 100% traffic.
  Canary deploy flagged for review: dep-20250720-0947
```

**Error cases:**

| Error | Message | Remediation |
|-------|---------|-------------|
| No active canary | `Error: No active canary for payments-service in production. Nothing to abort.` | Check `pave status` |
| Already promoting | `Error: Canary is currently being promoted (78% complete). Cannot abort during promotion. Wait for completion, then rollback if needed.` | Wait or rollback after |

---

## 3. Secrets Commands

### 3.1 `pave secrets list`

**Purpose:** List secrets available to a service, with rotation status.

| Trace | Link |
|-------|------|
| Traced from | [US-008](../product/user-stories.md#us-008-secrets-rotation-without-redeploy), [E4](../product/epics.md#e4-secrets-management) |
| Matched by | [GET /services/{name}/secrets](../architecture/api-spec.md#get-servicesname-secrets), [Secrets Manager](../architecture/architecture.md#secrets-manager) |
| Proven by | [TC-301](../quality/test-suites.md#tc-301-secrets-list-shows-rotation-status) |
| Confirmed by | Rina Okafor (DX Designer), 2025-09-10 |

**Synopsis:**
```
pave secrets list [--service <name>] [--env <environment>]
```

**Example output:**
```
$ pave secrets list --service checkout-service --env production
SECRET                  LAST ROTATED     EXPIRES IN    STATUS
REDIS_PASSWORD          12d ago          78d           ✓ current
DATABASE_URL            45d ago          45d           ⚠ expiring soon
STRIPE_API_KEY          89d ago          1d            ✗ rotation overdue
SENTRY_DSN              never rotated    —             ✓ static (no rotation policy)
```

---

### 3.2 `pave secrets rotate`

**Purpose:** Rotate a specific secret. The new value propagates to running pods without redeployment.

| Trace | Link |
|-------|------|
| Traced from | [US-008](../product/user-stories.md#us-008-secrets-rotation-without-redeploy), [E4](../product/epics.md#e4-secrets-management) |
| Matched by | [POST /services/{name}/secrets/{key}/rotate](../architecture/api-spec.md#post-servicesname-secretskeyrotate), [Secrets Manager](../architecture/architecture.md#secrets-manager), [ADR-005](../architecture/adrs.md#adr-005-secrets-rotation-via-sidecar-injection) |
| Proven by | [TC-302](../quality/test-suites.md#tc-302-secret-rotation-propagates-without-redeploy), [TC-303](../quality/test-suites.md#tc-303-secret-rotation-audit-trail) |
| Confirmed by | Rina Okafor (DX Designer), 2025-09-10 |

**Synopsis:**
```
pave secrets rotate <key> [--service <name>] [--env <environment>] [--value <new-value>]
```

**Arguments:**
- `<key>` — secret name to rotate.
- `--value` — new secret value. If omitted, auto-generates a new value (for supported secret types).

**Example output:**
```
$ pave secrets rotate REDIS_PASSWORD --service checkout-service --env production
Rotating REDIS_PASSWORD for checkout-service (production)...

Old value hash:  sha256:a1b2c3...
New value hash:  sha256:d4e5f6...
Propagation:     3/3 pods updated (no restart required)
Audit entry:     aud-20250910-1423

✓ Secret rotated. All pods are using the new value.
  Next rotation due: 2025-12-09 (90 days)
```

**Error cases:**

| Error | Message | Remediation |
|-------|---------|-------------|
| Secret not found | `Error: Secret REDIS_PASWORD not found for checkout-service. Did you mean REDIS_PASSWORD? Run 'pave secrets list' to see available secrets.` | Check spelling |
| Permission denied | `Error: Rotating secrets in production requires 'secrets-admin' role. Your role: deployer. Request access: pave access request secrets-admin` | Request role |
| Propagation failed | `Error: Secret rotated but 1/3 pods failed to pick up new value. Pod checkout-abc123 is still using the old value. Check pod logs: pave log --pod checkout-abc123` | Check pod health |

---

### 3.3 `pave secrets set`

**Purpose:** Set a new secret for a service.

| Trace | Link |
|-------|------|
| Traced from | [US-008](../product/user-stories.md#us-008-secrets-rotation-without-redeploy), [E4](../product/epics.md#e4-secrets-management) |
| Matched by | [PUT /services/{name}/secrets/{key}](../architecture/api-spec.md#put-servicesname-secretskey), [Secrets Manager](../architecture/architecture.md#secrets-manager) |
| Proven by | [TC-304](../quality/test-suites.md#tc-304-set-new-secret-available-on-next-deploy) |
| Confirmed by | Rina Okafor (DX Designer), 2025-09-10 |

**Synopsis:**
```
pave secrets set <key> [--service <name>] [--env <environment>] [--value <value>] [--rotation-policy <days>]
```

**Example output:**
```
$ pave secrets set NEW_API_KEY --service checkout-service --env staging --rotation-policy 90
Enter secret value: ********

✓ Secret NEW_API_KEY set for checkout-service (staging).
  Rotation policy: every 90 days
  Available on next deploy, or immediately if --propagate is used.
```

---

## 4. Onboarding Commands

### 4.1 `pave init`

**Purpose:** Interactive wizard that generates a `pave.yaml` for a new service. Detects stack, suggests defaults, explains each option.

| Trace | Link |
|-------|------|
| Traced from | [US-006](../product/user-stories.md#us-006-new-team-onboarding), [US-007](../product/user-stories.md#us-007-non-kubernetes-stack-onboarding), [E3](../product/epics.md#e3-onboarding-and-compatibility) |
| Matched by | [POST /services](../architecture/api-spec.md#post-services), [Onboarding Service](../architecture/architecture.md#onboarding-service) |
| Proven by | [TC-401](../quality/test-suites.md#tc-401-init-generates-valid-pave-yaml), [TC-402](../quality/test-suites.md#tc-402-init-detects-docker-compose-stack) |
| Confirmed by | Rina Okafor (DX Designer), 2025-08-05 |

**Synopsis:**
```
pave init [--template <name>] [--non-interactive]
```

**Arguments:**
- `--template` — skip detection, use a specific template: `kubernetes`, `docker-compose`, `static`, `lambda`.
- `--non-interactive` — use detected defaults without prompting. Good for CI.

**Example output (interactive):**
```
$ pave init
Pave Setup Wizard

Detected:
  Language:      Node.js (package.json found)
  Container:     Dockerfile found
  Orchestration: docker-compose.yml found (no Kubernetes manifests)
  CI:            .github/workflows/deploy.yml found

? Service name: gridline-api
? Environment strategy: [staging, production] (recommended) / custom
  → staging, production
? Build command: docker build -t gridline-api .
  (detected from Dockerfile)
? Health check endpoint: /healthz
  (default — change if your service uses a different path)
? Deploy strategy: [rolling] / canary / blue-green
  → rolling
? Resource limits: auto-detected from docker-compose.yml
  CPU: 0.5 cores, Memory: 512Mi
  Looks right? [Y/n] → Y

Generated: pave.yaml

Next steps:
  1. Review pave.yaml and commit it to your repo
  2. Run 'pave deploy --env staging' to test your first deploy
  3. Read the onboarding guide: https://pave.internal/docs/onboarding
```

**Error cases:**

| Error | Message | Remediation |
|-------|---------|-------------|
| pave.yaml exists | `Error: pave.yaml already exists in this directory. To overwrite: pave init --force. To edit: open pave.yaml directly.` | Edit existing file or use --force |
| No container found | `Warning: No Dockerfile or container configuration found. Pave needs a container to deploy. See https://pave.internal/docs/containerizing for help.` | Add a Dockerfile |
| Unsupported stack | `Warning: Detected stack (bare metal / systemd) is not directly supported. Using compatibility mode. Some features (canary, auto-scaling) will be limited. See https://pave.internal/docs/compatibility` | Review compatibility docs |

---

## 5. Admin Commands

### 5.1 `pave audit`

**Purpose:** View the audit log — who did what, when.

| Trace | Link |
|-------|------|
| Traced from | [US-009](../product/user-stories.md#us-009-rbac-and-audit-trail), [E5](../product/epics.md#e5-soc2-compliance) |
| Matched by | [GET /audit](../architecture/api-spec.md#get-audit), [Audit Service](../architecture/architecture.md#audit-service) |
| Proven by | [TC-501](../quality/test-suites.md#tc-501-audit-log-records-all-deploy-actions), [TC-502](../quality/test-suites.md#tc-502-audit-log-records-access-changes) |
| Confirmed by | Rina Okafor (DX Designer), 2025-08-20 |

**Synopsis:**
```
pave audit [--service <name>] [--user <email>] [--action <type>] [--since <date>] [--limit <n>]
```

**Arguments:**
- `--action` — filter by action type: `deploy`, `rollback`, `canary`, `secret-rotate`, `access-change`, `approval`.
- `--since` — show entries after a date or relative time (e.g., `--since 7d`, `--since 2025-06-01`).
- `--limit` — max entries to show. Default: 50.

**Example output:**
```
$ pave audit --service payments-service --since 7d
TIMESTAMP              USER              ACTION          DETAIL
2025-06-15 08:47:12    kai.tanaka        deploy          dep-20250615-0847 v2.14.3 → production
2025-06-15 09:10:33    kai.tanaka        rollback        dep-20250615-0847 → dep-20250614-1623 (error rate spike)
2025-06-14 16:23:00    dani.reeves       deploy          dep-20250614-1623 v2.14.2 → production
2025-06-13 11:00:00    sasha.petrov      secret-rotate   REDIS_PASSWORD rotated
2025-06-12 09:15:00    marcus.chen       access-change   granted deployer role to intern.jones
```

---

### 5.2 `pave access grant` / `pave access revoke`

**Purpose:** Manage RBAC — grant or revoke roles for users on specific services or environments.

| Trace | Link |
|-------|------|
| Traced from | [US-009](../product/user-stories.md#us-009-rbac-and-audit-trail), [E5](../product/epics.md#e5-soc2-compliance) |
| Matched by | [POST /access/grant](../architecture/api-spec.md#post-accessgrant), [POST /access/revoke](../architecture/api-spec.md#post-accessrevoke), [RBAC Service](../architecture/architecture.md#rbac-service) |
| Proven by | [TC-503](../quality/test-suites.md#tc-503-grant-role-shows-in-audit), [TC-504](../quality/test-suites.md#tc-504-permission-denied-after-revoke) |
| Confirmed by | Rina Okafor (DX Designer), 2025-08-20 |

**Synopsis:**
```
pave access grant <user> --role <role> [--service <name>] [--env <environment>]
pave access revoke <user> --role <role> [--service <name>] [--env <environment>]
pave access list [--user <email>] [--service <name>]
```

**Roles:**
- `viewer` — can see status, logs, audit. Cannot deploy or modify.
- `deployer` — can deploy, rollback, manage canaries. Cannot modify access or secrets.
- `secrets-admin` — can rotate and set secrets. Cannot modify access.
- `admin` — full access including access management.

**Example output:**
```
$ pave access grant intern.jones@company.com --role viewer --service checkout-service
✓ Granted 'viewer' role to intern.jones@company.com on checkout-service (all environments).
  Audit entry: aud-20250820-1100

$ pave access list --user intern.jones@company.com
USER                        SERVICE              ROLE       ENVIRONMENT
intern.jones@company.com    checkout-service     viewer     all
```

**Error cases:**

| Error | Message | Remediation |
|-------|---------|-------------|
| Not an admin | `Error: Granting access requires 'admin' role on the target service. Your role on checkout-service: deployer. Ask a service admin to grant access.` | Ask an admin |
| Role doesn't exist | `Error: Unknown role 'superadmin'. Available roles: viewer, deployer, secrets-admin, admin.` | Use a valid role |
| Self-revoke last admin | `Error: Cannot revoke your own admin role — you are the last admin on checkout-service. Transfer admin to another user first.` | Transfer admin first |

---

## 6. Approval Commands

### 6.1 `pave approve request`

**Purpose:** Request approval for a PCI-scoped deploy.

| Trace | Link |
|-------|------|
| Traced from | [US-010](../product/user-stories.md#us-010-pci-deploy-approval), [E6](../product/epics.md#e6-pci-compliance) |
| Matched by | [POST /approvals](../architecture/api-spec.md#post-approvals), [Approval Service](../architecture/architecture.md#approval-service) |
| Proven by | [TC-601](../quality/test-suites.md#tc-601-approval-request-creates-slack-notification), [TC-602](../quality/test-suites.md#tc-602-deploy-blocked-without-approval) |
| Confirmed by | Rina Okafor (DX Designer), 2025-10-15 |

**Synopsis:**
```
pave approve request <deploy-id> [--message <text>]
```

**Example output:**
```
$ pave approve request dep-20250720-0947 --message "PCI cert renewal — updated TLS config"
Approval requested for dep-20250720-0947 (payments-service → production)

Notified:
  #pci-approvals (Slack)
  security-team@company.com (email)

Status: pending
Approve via: Slack reaction or 'pave approve dep-20250720-0947'
Track: pave approve status dep-20250720-0947
```

### 6.2 `pave approve` / `pave approve reject`

**Purpose:** Approve or reject a pending deploy (for authorized approvers).

| Trace | Link |
|-------|------|
| Traced from | [US-010](../product/user-stories.md#us-010-pci-deploy-approval), [E6](../product/epics.md#e6-pci-compliance) |
| Matched by | [POST /approvals/{id}/approve](../architecture/api-spec.md#post-approvalsidapprove), [POST /approvals/{id}/reject](../architecture/api-spec.md#post-approvalsidreject) |
| Proven by | [TC-603](../quality/test-suites.md#tc-603-approved-deploy-proceeds), [TC-604](../quality/test-suites.md#tc-604-rejected-deploy-blocked) |
| Confirmed by | Rina Okafor (DX Designer), 2025-10-15 |

**Synopsis:**
```
pave approve <deploy-id> [--comment <text>]
pave approve reject <deploy-id> --reason <text>
pave approve status <deploy-id>
```

**Example output:**
```
$ pave approve dep-20250720-0947 --comment "Reviewed TLS changes, LGTM"
✓ Deploy dep-20250720-0947 approved.
  Approved by: sasha.petrov
  Deploy will proceed automatically.

$ pave approve status dep-20250720-0947
Deploy:     dep-20250720-0947 (payments-service → production)
Requested:  kai.tanaka, 15 min ago
Status:     ✓ approved
Approved by: sasha.petrov, 2 min ago
Comment:    "Reviewed TLS changes, LGTM"
```

**Error cases:**

| Error | Message | Remediation |
|-------|---------|-------------|
| Self-approval | `Error: You cannot approve your own deploy (PCI requirement). Another member of the security team must approve.` | Ask another approver |
| Not an approver | `Error: You are not an authorized approver for PCI-scoped deploys. Authorized approvers: security team members. Contact security-team@company.com.` | Contact security |
| Already decided | `Error: Deploy dep-20250720-0947 was already approved by sasha.petrov 5 min ago.` | No action needed |

---

## 7. Drift Detection

### 7.1 `pave drift show`

**Purpose:** Show differences between the last known deploy state and what's actually running. Detects manual changes (SSH fixes, kubectl edits).

| Trace | Link |
|-------|------|
| Traced from | [US-003](../product/user-stories.md#us-003-drift-detection-after-manual-changes), [E1](../product/epics.md#e1-core-deploy-pipeline) |
| Matched by | [GET /services/{name}/drift](../architecture/api-spec.md#get-servicesnamedrift), [Drift Detector](../architecture/architecture.md#drift-detector) |
| Proven by | [TC-701](../quality/test-suites.md#tc-701-drift-detected-after-manual-ssh-change), [TC-702](../quality/test-suites.md#tc-702-drift-resolved-after-deploy) |
| Confirmed by | Rina Okafor (DX Designer), 2025-07-01 |

**Synopsis:**
```
pave drift show [<service>] [--env <environment>]
```

**Example output:**
```
$ pave drift show checkout-service --env production
Drift detected on checkout-service (production)

Last known deploy: dep-20250614-1623 (v2.14.2)
Detected changes:

  Config:
    - /etc/checkout/tls.conf modified (not in deploy artifact)
      Changed: 2025-06-15 02:13 UTC
      Likely cause: manual edit (no deploy record matches)

  Environment:
    - TLS_CERT_PATH changed from /certs/old.pem to /certs/new.pem

To bring drift into source control:
  1. Apply the changes to your codebase
  2. Deploy normally: pave deploy --env production

To revert drift (restore last deploy state):
  pave deploy --env production --force
```

---

## 8. Emergency Commands

### 8.1 `pave emergency deploy`

**Purpose:** Deploy bypassing the queue, approval gates, and canary requirements. For use when Pave's normal flow is too slow or broken. **Status: suspect** — emergency procedure was redesigned after Round 6 (Pave self-outage). Needs re-verification against current queue architecture.

| Trace | Link |
|-------|------|
| Traced from | [US-004](../product/user-stories.md#us-004-emergency-deploy-bypass), [E1](../product/epics.md#e1-core-deploy-pipeline) |
| Matched by | [POST /deploys/emergency](../architecture/api-spec.md#post-deploysemergency), [Deploy Service](../architecture/architecture.md#deploy-service) |
| Proven by | [TC-801](../quality/test-suites.md#tc-801-emergency-deploy-bypasses-queue) |
| Confirmed by | **suspect** — last confirmed pre-Round 6. Emergency bypass path changed after deploy queue corruption incident. |

**Synopsis:**
```
pave emergency deploy [--env <environment>] [--service <name>] [--acknowledge-audit]
```

**The `--acknowledge-audit` flag is mandatory.** Forces the deployer to explicitly acknowledge that:
1. This deploy bypasses normal approval gates
2. A mandatory post-incident review will be required
3. The audit trail will flag this as an emergency deploy

**Example output:**
```
$ pave emergency deploy --env production --acknowledge-audit
⚠ EMERGENCY DEPLOY — bypassing queue and approval gates

You are deploying checkout-service v2.14.3 to production WITHOUT:
  - Queue position (jumping ahead of 2 pending deploys)
  - PCI approval (if applicable)
  - Canary observation

This will be flagged in the audit log and requires a post-incident review.

Proceed? [y/N] → y

Deploying...
Status: building → deploying → healthy
Duration: 2m 10s

✓ Emergency deploy complete.
  Deploy ID: dep-20250615-0213-emergency
  ⚠ Post-incident review required within 48 hours.
  Create review: pave incident create dep-20250615-0213-emergency
```
