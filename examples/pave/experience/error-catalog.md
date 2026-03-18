# Error Catalog — Pave Deploy Platform

Every error Pave produces, with the user-facing message, remediation steps, trigger conditions, and traceability. Organized by error code prefix.

**Error code format:** `PAVE-<area>-<number>`
- `PAVE-DEP-*` — Deploy errors
- `PAVE-CAN-*` — Canary errors
- `PAVE-SEC-*` — Secrets errors
- `PAVE-AUTH-*` — Permission/RBAC errors
- `PAVE-CFG-*` — Configuration errors
- `PAVE-DFT-*` — Drift errors
- `PAVE-APR-*` — Approval errors
- `PAVE-SYS-*` — System/platform errors

Every error message follows the pattern: **What happened → Why → What to do next.** (See [DD-002](design-decisions.md#dd-002-error-messages-must-include-remediation-steps))

---

## Deploy Errors (PAVE-DEP-*)

### PAVE-DEP-001: No pave.yaml Found

| Trace | Link |
|-------|------|
| Traced from | [US-006](../product/user-stories.md#us-006-new-team-onboarding), [E3](../product/epics.md#e3-onboarding-and-compatibility) |
| Proven by | [TC-101](../quality/test-suites.md#tc-101-standard-deploy-happy-path) (negative path) |

**Message:**
```
Error: No pave.yaml found in current directory or parent directories.
Run 'pave init' to create one, or use --config <path> to specify a location.
```

**Trigger:** `pave deploy` run in a directory without `pave.yaml`.
**Remediation:** Run `pave init` or specify config path.

---

### PAVE-DEP-002: Image Build Failed

| Trace | Link |
|-------|------|
| Traced from | [US-001](../product/user-stories.md#us-001-standard-deploy-with-commit-visibility), [E1](../product/epics.md#e1-core-deploy-pipeline) |
| Proven by | [TC-107](../quality/test-suites.md#tc-107-deploy-fails-on-build-error) |

**Message:**
```
Error: Image build failed (exit code <N>).
Build output: <last 5 lines of build log>
Full logs: pave log <deploy-id> --phase build
```

**Trigger:** Docker build returns non-zero exit code during deploy.
**Remediation:** Check build output. Common causes: missing dependency, syntax error, Dockerfile issue.

---

### PAVE-DEP-003: Image Not Found in Registry

| Trace | Link |
|-------|------|
| Traced from | [US-001](../product/user-stories.md#us-001-standard-deploy-with-commit-visibility), [E1](../product/epics.md#e1-core-deploy-pipeline) |
| Proven by | [TC-108](../quality/test-suites.md#tc-108-deploy-fails-on-missing-image) |

**Message:**
```
Error: Image <service>:<version> not found in registry.
The build may have failed or the image was not pushed.
Check: pave log <deploy-id> --phase build
If building externally: ensure image is pushed to registry.internal/<service>:<version>
```

**Trigger:** Deploy phase starts but image is not available in the container registry.
**Remediation:** Re-run build or push image manually.

---

### PAVE-DEP-004: Health Check Failed After Deploy

| Trace | Link |
|-------|------|
| Traced from | [US-001](../product/user-stories.md#us-001-standard-deploy-with-commit-visibility), [E1](../product/epics.md#e1-core-deploy-pipeline) |
| Proven by | [TC-109](../quality/test-suites.md#tc-109-deploy-fails-on-health-check-timeout) |

**Message:**
```
Error: Health check failed after deploy.
Endpoint /healthz returned <status-code> (expected 200) after 3 attempts over 90 seconds.

Pod logs (last 10 lines):
<recent pod log output>

To investigate:
  pave log <deploy-id> --phase runtime

To rollback:
  pave rollback --env <environment>
```

**Trigger:** Deployed pods fail health check within the configured timeout.
**Remediation:** Check application startup logs, fix health endpoint, redeploy.

---

### PAVE-DEP-005: Deploy Queue Full

| Trace | Link |
|-------|------|
| Traced from | [US-001](../product/user-stories.md#us-001-standard-deploy-with-commit-visibility), [E1](../product/epics.md#e1-core-deploy-pipeline) |
| Proven by | [TC-111](../quality/test-suites.md#tc-111-deploy-queue-capacity-limit) |

**Message:**
```
Error: Deploy queue is full (20 deploys pending).
Your deploy has been queued at position 21.
Estimated wait: ~45 minutes.

To check queue: pave status --queue
For urgent deploys: pave emergency deploy --acknowledge-audit
```

**Trigger:** Deploy queue reaches capacity limit.
**Remediation:** Wait for queue to drain, or use emergency deploy if genuinely urgent.

---

### PAVE-DEP-006: Deploy Queue Paused

| Trace | Link |
|-------|------|
| Traced from | Round 6 (Pave self-outage), [US-004](../product/user-stories.md#us-004-emergency-deploy-bypass) |
| Proven by | [TC-112](../quality/test-suites.md#tc-112-deploy-blocked-when-queue-paused) |

**Message:**
```
Error: Deploy queue is paused.
Paused by: sasha.petrov at 14:23 UTC
Reason: "Investigating deploy-queue corruption"

No deploys will proceed until the queue is resumed.
Status page: https://pave.internal/status

For critical fixes: pave emergency deploy --acknowledge-audit
```

**Trigger:** Admin has paused the deploy queue (usually during incident investigation).
**Remediation:** Wait for queue to resume, or use emergency deploy.

---

### PAVE-DEP-007: Pending Approval Required

| Trace | Link |
|-------|------|
| Traced from | [US-010](../product/user-stories.md#us-010-pci-deploy-approval), [E6](../product/epics.md#e6-pci-compliance) |
| Proven by | [TC-602](../quality/test-suites.md#tc-602-deploy-blocked-without-approval) |

**Message:**
```
Error: Deploy to <service> requires security approval (PCI scope).
Request approval: pave approve request <deploy-id>
Track status: pave approve status <deploy-id>

Approvers have been notified via #pci-approvals (Slack).
```

**Trigger:** Deploy targets a PCI-scoped service without prior approval.
**Remediation:** Request approval, wait for security team sign-off.

---

### PAVE-DEP-008: Rollback Target Not Found

| Trace | Link |
|-------|------|
| Traced from | [US-002](../product/user-stories.md#us-002-deploy-rollback), [E1](../product/epics.md#e1-core-deploy-pipeline) |
| Proven by | [TC-113](../quality/test-suites.md#tc-113-rollback-no-previous-deploy) |

**Message:**
```
Error: No previous successful deploy found for <service> in <environment>.
Cannot rollback — this appears to be the first deploy.

If you need to remove the service:
  kubectl delete deployment/<service> --namespace <environment>
  (manual intervention required)
```

**Trigger:** Rollback requested but no prior successful deploy exists.
**Remediation:** Manual intervention — this is an edge case for first-ever deploys.

---

## Canary Errors (PAVE-CAN-*)

### PAVE-CAN-001: No Active Canary

| Trace | Link |
|-------|------|
| Traced from | [US-005](../product/user-stories.md#us-005-canary-deploy-with-traffic-splitting), [E2](../product/epics.md#e2-canary-deploys) |
| Proven by | [TC-206](../quality/test-suites.md#tc-206-promote-without-active-canary) |

**Message:**
```
Error: No active canary for <service> in <environment>.
Start one with: pave canary start --env <environment>
```

**Trigger:** `pave canary promote` or `pave canary abort` when no canary is running.
**Remediation:** Start a canary first, or check if it already completed/aborted.

---

### PAVE-CAN-002: Canary Already Active

| Trace | Link |
|-------|------|
| Traced from | [US-005](../product/user-stories.md#us-005-canary-deploy-with-traffic-splitting), [E2](../product/epics.md#e2-canary-deploys) |
| Proven by | [TC-207](../quality/test-suites.md#tc-207-canary-start-when-already-active) |

**Message:**
```
Error: A canary is already active for <service> in <environment>.
Active canary: <canary-id> (started <time> ago, <traffic>% traffic)

To promote: pave canary promote --env <environment>
To abort:   pave canary abort --env <environment>
```

**Trigger:** `pave canary start` when a canary is already running for the same service.
**Remediation:** Promote or abort the existing canary first.

---

### PAVE-CAN-003: Cannot Abort During Promotion

| Trace | Link |
|-------|------|
| Traced from | [US-005](../product/user-stories.md#us-005-canary-deploy-with-traffic-splitting), [E2](../product/epics.md#e2-canary-deploys) |
| Proven by | [TC-208](../quality/test-suites.md#tc-208-abort-during-promotion) |

**Message:**
```
Error: Canary is currently being promoted (78% complete).
Cannot abort during promotion — traffic routing is in transition.

Wait for promotion to complete (~2 min), then rollback if needed:
  pave rollback --env <environment>
```

**Trigger:** `pave canary abort` during an in-progress promotion.
**Remediation:** Wait for promotion to finish, then rollback.

---

## Secrets Errors (PAVE-SEC-*)

### PAVE-SEC-001: Secret Not Found

| Trace | Link |
|-------|------|
| Traced from | [US-008](../product/user-stories.md#us-008-secrets-rotation-without-redeploy), [E4](../product/epics.md#e4-secrets-management) |
| Proven by | [TC-306](../quality/test-suites.md#tc-306-rotate-nonexistent-secret) |

**Message:**
```
Error: Secret '<key>' not found for <service> in <environment>.
Did you mean: <closest-match>?

Available secrets: pave secrets list --service <service> --env <environment>
To create a new secret: pave secrets set <key> --service <service> --env <environment>
```

**Trigger:** `pave secrets rotate` or `pave secrets set` with a key that doesn't exist.
**Remediation:** Check spelling, list available secrets, or create a new one.

---

### PAVE-SEC-002: Propagation Failed

| Trace | Link |
|-------|------|
| Traced from | [US-008](../product/user-stories.md#us-008-secrets-rotation-without-redeploy), [E4](../product/epics.md#e4-secrets-management) |
| Proven by | [TC-307](../quality/test-suites.md#tc-307-secret-propagation-partial-failure) |

**Message:**
```
Error: Secret rotated but propagation failed.
<N>/<total> pods updated. Pods still on old value:
  <pod-name-1> (last heartbeat: 30s ago)
  <pod-name-2> (last heartbeat: 2m ago — may be unhealthy)

Check pod health: pave status <service> --env <environment>
Pod logs: pave log --pod <pod-name>
Retry propagation: pave secrets propagate <key> --service <service> --env <environment>
```

**Trigger:** Secret rotation succeeds in the secrets store but not all pods pick up the new value.
**Remediation:** Check pod health, investigate unhealthy pods, retry propagation.

---

### PAVE-SEC-003: Secrets-Admin Role Required

| Trace | Link |
|-------|------|
| Traced from | [US-009](../product/user-stories.md#us-009-rbac-and-audit-trail), [E5](../product/epics.md#e5-soc2-compliance) |
| Proven by | [TC-504](../quality/test-suites.md#tc-504-permission-denied-after-revoke) |

**Message:**
```
Error: Rotating secrets in <environment> requires 'secrets-admin' role.
Your role: <current-role>

Request access: pave access request secrets-admin --service <service>
Current secrets-admins: <list-of-admins>
```

**Trigger:** Secret rotation attempted without sufficient role.
**Remediation:** Request secrets-admin role.

---

## Permission Errors (PAVE-AUTH-*)

### PAVE-AUTH-001: Permission Denied — Deploy

| Trace | Link |
|-------|------|
| Traced from | [US-009](../product/user-stories.md#us-009-rbac-and-audit-trail), [E5](../product/epics.md#e5-soc2-compliance) |
| Proven by | [TC-504](../quality/test-suites.md#tc-504-permission-denied-after-revoke) |

**Message:**
```
Error: You don't have permission to deploy to <environment>.
Required role: deployer
Your role:     <current-role>
Service:       <service>

To request access:
  pave access request deployer --service <service>

Service admins who can grant access:
  <admin-1>, <admin-2>
```

**Trigger:** Deploy attempted without deployer role on the target service/environment.
**Remediation:** Request role or ask an admin.

---

### PAVE-AUTH-002: Permission Denied — Access Management

| Trace | Link |
|-------|------|
| Traced from | [US-009](../product/user-stories.md#us-009-rbac-and-audit-trail), [E5](../product/epics.md#e5-soc2-compliance) |
| Proven by | [TC-505](../quality/test-suites.md#tc-505-non-admin-cannot-grant-roles) |

**Message:**
```
Error: Granting access requires 'admin' role on <service>.
Your role: <current-role>

Ask a service admin to grant access:
  Current admins: <admin-list>
```

**Trigger:** `pave access grant` without admin role.
**Remediation:** Ask an existing admin.

---

### PAVE-AUTH-003: Self-Approval Blocked

| Trace | Link |
|-------|------|
| Traced from | [US-010](../product/user-stories.md#us-010-pci-deploy-approval), [E6](../product/epics.md#e6-pci-compliance) |
| Proven by | [TC-605](../quality/test-suites.md#tc-605-self-approval-blocked) |

**Message:**
```
Error: You cannot approve your own deploy (PCI DSS requirement).
Deploy <deploy-id> was requested by you (<username>).
Another member of the security team must approve.

Authorized approvers: <list>
```

**Trigger:** Engineer tries to approve a deploy they requested.
**Remediation:** Ask another authorized approver.

---

### PAVE-AUTH-004: Last Admin Self-Revoke

| Trace | Link |
|-------|------|
| Traced from | [US-009](../product/user-stories.md#us-009-rbac-and-audit-trail), [E5](../product/epics.md#e5-soc2-compliance) |
| Proven by | [TC-506](../quality/test-suites.md#tc-506-last-admin-cannot-self-revoke) |

**Message:**
```
Error: Cannot revoke your own admin role — you are the last admin on <service>.
Transfer admin to another user first:
  pave access grant <other-user> --role admin --service <service>
  pave access revoke <yourself> --role admin --service <service>
```

**Trigger:** Last remaining admin tries to revoke their own admin role.
**Remediation:** Grant admin to someone else first.

---

## Configuration Errors (PAVE-CFG-*)

### PAVE-CFG-001: Invalid pave.yaml

| Trace | Link |
|-------|------|
| Traced from | [US-006](../product/user-stories.md#us-006-new-team-onboarding), [E3](../product/epics.md#e3-onboarding-and-compatibility) |
| Proven by | [TC-404](../quality/test-suites.md#tc-404-deploy-with-invalid-pave-yaml) |

**Message:**
```
Error: pave.yaml is invalid.
Line 12: 'deploy_strategy' must be one of: rolling, canary, blue-green
Got: 'canery' (did you mean 'canary'?)

Validate your config: pave validate
Regenerate from wizard: pave init --force
```

**Trigger:** pave.yaml fails schema validation.
**Remediation:** Fix the specific field. Error pinpoints the line and suggests corrections.

---

### PAVE-CFG-002: Missing Required Field

| Trace | Link |
|-------|------|
| Traced from | [US-006](../product/user-stories.md#us-006-new-team-onboarding), [E3](../product/epics.md#e3-onboarding-and-compatibility) |
| Proven by | [TC-405](../quality/test-suites.md#tc-405-deploy-with-missing-required-field) |

**Message:**
```
Error: pave.yaml is missing required field 'health_check.endpoint'.
Pave needs a health check endpoint to verify your service is running after deploy.

Add to your pave.yaml:
  health_check:
    endpoint: /healthz
    interval: 10s
    timeout: 5s

If your service doesn't have a health endpoint yet, see:
  https://pave.internal/docs/health-checks
```

**Trigger:** Required field missing from pave.yaml.
**Remediation:** Add the field. Error includes the exact YAML to add.

---

## Drift Errors (PAVE-DFT-*)

### PAVE-DFT-001: Drift Detected — Deploy Blocked

| Trace | Link |
|-------|------|
| Traced from | [US-003](../product/user-stories.md#us-003-drift-detection-after-manual-changes), [E1](../product/epics.md#e1-core-deploy-pipeline) |
| Proven by | [TC-701](../quality/test-suites.md#tc-701-drift-detected-after-manual-ssh-change) |

**Message:**
```
Error: Drift detected on <service> in <environment>.
Live state differs from last known deploy.

See differences: pave drift show <service> --env <environment>

To deploy anyway (overwrites drift):
  pave deploy --env <environment> --force

To resolve drift first:
  1. Apply manual changes to your codebase
  2. Commit and deploy normally
```

**Trigger:** Deploy attempted on a service with detected drift.
**Remediation:** Investigate drift, then either bring into source or force-deploy.

---

## Approval Errors (PAVE-APR-*)

### PAVE-APR-001: Approval Already Decided

| Trace | Link |
|-------|------|
| Traced from | [US-010](../product/user-stories.md#us-010-pci-deploy-approval), [E6](../product/epics.md#e6-pci-compliance) |
| Proven by | [TC-606](../quality/test-suites.md#tc-606-approve-already-decided-deploy) |

**Message:**
```
Error: Deploy <deploy-id> was already approved by <approver> at <timestamp>.
No action needed — deploy is proceeding.
```

**Trigger:** Attempting to approve/reject a deploy that already has a decision.
**Remediation:** No action needed.

---

### PAVE-APR-002: Not an Authorized Approver

| Trace | Link |
|-------|------|
| Traced from | [US-010](../product/user-stories.md#us-010-pci-deploy-approval), [E6](../product/epics.md#e6-pci-compliance) |
| Proven by | [TC-607](../quality/test-suites.md#tc-607-non-approver-cannot-approve) |

**Message:**
```
Error: You are not an authorized approver for PCI-scoped deploys.
Authorized approvers: security team members.

Contact: security-team@company.com
Slack: #pci-approvals
```

**Trigger:** Non-security-team member tries to approve a PCI deploy.
**Remediation:** Contact security team.

---

## System Errors (PAVE-SYS-*)

### PAVE-SYS-001: Pave Service Unreachable

| Trace | Link |
|-------|------|
| Traced from | Round 6 (Pave self-outage), [US-004](../product/user-stories.md#us-004-emergency-deploy-bypass) |
| Proven by | [TC-803](../quality/test-suites.md#tc-803-cli-handles-pave-unavailable) |

**Message:**
```
Error: Pave service unreachable (connection refused at pave.internal:443).

Status page: https://pave.internal/status
Emergency deploy docs: https://pave.internal/docs/emergency-manual-deploy

If you need to deploy NOW without Pave, follow the manual procedure:
  1. Build: docker build -t registry.internal/<service>:<version> .
  2. Push:  docker push registry.internal/<service>:<version>
  3. Apply: kubectl set image deployment/<service> <container>=registry.internal/<service>:<version> -n <env>
```

**Trigger:** CLI cannot connect to Pave API.
**Remediation:** Check status page. If urgent, use manual procedure.

---

### PAVE-SYS-002: Request Timeout

| Trace | Link |
|-------|------|
| Traced from | [US-001](../product/user-stories.md#us-001-standard-deploy-with-commit-visibility), [E1](../product/epics.md#e1-core-deploy-pipeline) |
| Proven by | [TC-804](../quality/test-suites.md#tc-804-cli-handles-request-timeout) |

**Message:**
```
Error: Request timed out after 30 seconds.
Pave may be experiencing high load.

Your deploy may still be queued. Check status:
  pave status <service> --env <environment>

If the problem persists:
  Status page: https://pave.internal/status
  Slack: #platform-support
```

**Trigger:** API request exceeds timeout.
**Remediation:** Check status — the operation may have succeeded server-side.

---

### PAVE-SYS-003: CLI Version Mismatch

| Trace | Link |
|-------|------|
| Traced from | General platform maintenance |
| Proven by | [TC-805](../quality/test-suites.md#tc-805-cli-version-mismatch-warning) |

**Message:**
```
Warning: Your CLI version (1.2.0) is behind the server (1.4.0).
Some features may not work as expected.

Update: brew upgrade pave  (macOS)
        curl -fsSL https://pave.internal/install | sh  (Linux)
```

**Trigger:** CLI version is more than one minor version behind the server.
**Remediation:** Update CLI. This is a warning, not a blocking error.
