# Runbook: Canary Failure (Auto-Rollback or Manual Abort)

**Severity:** P1 — Notify During Business Hours
**SLA:** Acknowledge within 1 hour (the auto-rollback already protected users — this is about investigating why)
**Last tested:** 2025-10-01 — Deliberate bad deploy with canary: pushed a version that returned 500s on 30% of requests. Canary Controller detected error rate delta at 3 minutes, triggered auto-rollback at 5 minutes. Service fully restored.
**Last triggered:** 2025-10-28 — Team Atlas canary deploy. Canary showed 3x baseline latency due to a missing database index. Auto-rollback at 5 minutes. Team added the index and redeployed successfully.

### Traceability

| Link | Reference |
|------|-----------|
| **Triggered by:** | Alert: [Canary Error Rate Threshold](./monitoring-alerting.md#p1----notify-during-business-hours), [Canary Auto-Rollback Triggered](./monitoring-alerting.md#p1----notify-during-business-hours) |
| **Watches:** | [Canary Controller](../architecture/architecture.md#canary-controller), [ADR-003: Canary deploy via weighted traffic splitting](../architecture/adrs.md#adr-003-canary-deploy-via-weighted-traffic-splitting) |
| **Proves:** | [US-004: Canary deploy with traffic splitting](../product/user-stories.md#us-004-canary-deploy-with-traffic-splitting), [US-005: Auto-rollback on error threshold](../product/user-stories.md#us-005-auto-rollback-on-error-threshold) |
| **Detects:** | [TC-201: Canary deploy 5% traffic split](../quality/test-suites.md#tc-201-canary-deploy--5-percent-traffic-split), [TC-205: Canary auto-rollback error threshold breach](../quality/test-suites.md#tc-205-canary-auto-rollback--error-threshold-breach) |
| **Confirmed by** | Sasha Petrov (DevOps/SRE), 2025-10-01 — deliberate bad deploy test in staging |

---

## Context

When a canary deploy detects a problem, the Canary Controller either:
- **Auto-rollback:** Error rate exceeds threshold (canary error rate > 2x baseline). Traffic is shifted back to baseline. The deploying team is notified.
- **Manual abort:** The deploying team or Pave SRE manually aborts the canary via CLI or dashboard.

In both cases, the service is safe — traffic is back on the baseline version. This runbook is about understanding what went wrong and deciding next steps.

---

## Assessment

### 1. What Happened?

```bash
# Get canary event details
pave canary status <deploy-id>

# Check the Canary Controller logs
kubectl logs deployment/pave-canary-controller -n pave-system --tail=100 | \
  grep <deploy-id>

# Check error rate comparison
# D4: Canary Monitoring Dashboard — canary vs baseline overlay
```

Key questions:
- **What was the error rate delta?** (e.g., canary 5% errors vs baseline 0.1%)
- **What was the latency delta?** (e.g., canary p95 2s vs baseline 200ms)
- **How much traffic hit the canary?** (e.g., 5% for 5 minutes = low blast radius)
- **Did any real users experience errors?** Check downstream error logs.

### 2. Was the Rollback Correct?

Usually yes. But check:

- **False positive:** Was the error rate spike caused by something unrelated? (e.g., an upstream dependency flapped during the canary window)
- **Threshold too aggressive:** Is the 2x baseline threshold too tight for this service? Some services have naturally noisy error rates.
- **Insufficient canary duration:** Did the canary not run long enough for the error rate to stabilize?

```bash
# Compare canary window with baseline noise
# Look at baseline error rate over the past 24 hours
# If baseline regularly spikes to 1%, a canary at 2% is within noise

# Check Prometheus directly
curl -s "http://prometheus.internal/api/v1/query_range?query=pave_canary_error_rate{service='<service>'}&start=<canary_start>&end=<canary_end>&step=15s" | jq
```

### 3. Root Cause of the Bad Deploy

Common causes:
- **Code bug:** The new version has a regression. Check the diff between canary and baseline commits.
- **Missing migration:** Schema change was deployed before migration ran. Database errors.
- **Config mismatch:** New version expects a config value or secret that doesn't exist in production.
- **Resource pressure:** New version uses more memory/CPU than allocated. OOM kills or throttling.
- **Dependency incompatibility:** New version calls an API endpoint that doesn't exist yet (deploy ordering issue).

```bash
# Check canary pod logs for errors
kubectl logs <canary-pod> -n <namespace> --tail=200

# Check for OOM kills
kubectl describe pod <canary-pod> -n <namespace> | grep -A5 "Last State"

# Check for crash loops during canary
kubectl get events -n <namespace> --sort-by='.lastTimestamp' | grep <canary-pod>
```

---

## Re-Attempt Strategy

### Fix and Redeploy

Most canary failures are real bugs. The path is:

1. Identify the root cause (see above)
2. Fix the issue in a new commit
3. Run through CI/CD (tests, staging)
4. Redeploy with canary again

Don't skip canary on the retry just because "the fix is small." The canary is the proof.

### Adjust Canary Parameters

If the rollback was a false positive or the threshold is too aggressive:

```bash
# Retry with relaxed threshold
pave deploy <service> --env production --canary 10 \
  --canary-error-threshold 5.0 \
  --canary-duration 15m

# Or with a smaller traffic split for more cautious validation
pave deploy <service> --env production --canary 2 \
  --canary-duration 20m
```

Any threshold adjustment should be discussed with the deploying team and documented in the deploy's audit trail.

### Skip Canary (Emergency Only)

If a P0 fix needs to go out and canary is blocking:

```bash
pave deploy <service> --env production --skip-canary \
  --reason "P0 fix for INC-XXX, canary blocking on unrelated noise"
```

This skips canary but still goes through Pave's deploy pipeline (RBAC, audit, rollback). It is NOT the same as the bootstrap bypass. The `--reason` flag is mandatory and logged.

---

## Verification After Re-Attempt

```bash
# 1. Monitor canary dashboard
# D4: Canary Monitoring Dashboard — error rate should be within 1x baseline

# 2. Wait for full canary duration
pave canary status <new-deploy-id>

# 3. After promotion, monitor for 15 minutes
# D1: Pave Operations Overview — no error rate spikes

# 4. Confirm with deploying team
# Ask: "Is the feature working as expected in production?"
```

---

## When to Escalate to Pave Team

Most canary failures are the deploying team's responsibility — their code broke, they fix it. Escalate to Pave team if:

- **Canary Controller itself is broken** (not triggering rollback when it should, or triggering on healthy deploys)
- **Istio traffic splitting is incorrect** (canary is getting 50% traffic when configured for 5%)
- **False positives are frequent** (> 3 false positives across different teams in a week — threshold tuning needed)
- **Canary metrics are wrong** (error rate calculation is off, comparing wrong endpoints)

---

## Escalation

| Time | If | Escalate to |
|------|------|-------------|
| +0 min | Auto-rollback fires | Deploying team (Slack #deploys) + Pave on-call (informational) |
| +1 hour | Deploying team can't identify root cause | Pave on-call assists with debugging |
| +4 hours | Same team's canary fails repeatedly | Pave team reviews canary config for that service |
