# Runbook: Drift Detected

**Severity:** P1 — Notify During Business Hours (P0 if drift affects PCI-scoped services)
**SLA:** Acknowledge within 1 hour, resolve within 4 hours
**Last tested:** 2025-10-20 — Deliberate drift injection in staging: manually changed replica count via kubectl, verified Drift Detector flagged it within 90 seconds.
**Last triggered:** 2025-08-14 — Team Kite on-call engineer SSH'd to production to patch a TLS cert (the original Round 2 incident pattern). Drift Detector caught it 60 seconds later. Resolved by importing the manual change into Pave's expected state.

### Traceability

| Link | Reference |
|------|-----------|
| **Triggered by:** | Alert: [Drift Detected](./monitoring-alerting.md#p0----page-immediately-any-time) (`pave_drift_detected_total` increase) |
| **Caused by:** | [BUG-002: Bypass overwrite — Pave reverts manual hotfix](../quality/bug-reports.md#bug-002-bypass-overwrite--pave-reverts-manual-hotfix) — the original incident that motivated drift detection |
| **Fixed by:** | [ADR-002: Drift detection via state fingerprinting](../architecture/adrs.md#adr-002-drift-detection-via-state-fingerprinting) |
| **Watches:** | [Drift Detector](../architecture/architecture.md#drift-detector) |
| **Proves:** | [US-003: Drift detection](../product/user-stories.md#us-003-drift-detection) — Pave knows when production diverges from expected state |
| **Detects:** | [TC-105: Drift detection — manual kubectl change](../quality/test-suites.md#tc-105-drift-detection--manual-kubectl-change), [TC-106: Drift detection — SSH mutation](../quality/test-suites.md#tc-106-drift-detection--ssh-mutation) |
| **Confirmed by** | Sasha Petrov (DevOps/SRE), 2025-10-20 — drift injection test in staging, full workflow verified |

---

## Detection

The Drift Detector reconciliation loop runs every 60 seconds. When it detects a difference between actual cluster state and Pave's expected state, it:

1. Records a `pave_drift_detected_total` metric with labels: `service`, `drift_type`
2. Writes a drift event to the database with details
3. Sends a Slack notification to #pave-ops and DMs the service owner
4. Shows the drift on [D3: Drift Detection Dashboard](./monitoring-alerting.md#d3-drift-detection-dashboard)

Drift types:
- **image** — Running image doesn't match expected image (someone deployed outside Pave)
- **config** — ConfigMap or Secret contents changed
- **replica** — Replica count doesn't match expected
- **resource** — Resource limits/requests changed
- **unknown** — Other manifest differences

---

## Assessment

Not all drift is bad. Before resolving, determine the cause.

### Was It a Legitimate Hotfix?

Check with the service owner:

```bash
# Who owns this service?
pave service info <service-name>

# Check recent activity outside Pave
kubectl get events -n <namespace> --sort-by='.lastTimestamp' | tail -20

# Check the audit log for manual actions
psql $DATABASE_URL -c "
  SELECT action, actor, details, created_at
  FROM audit_log
  WHERE target_service = '<service-name>'
    AND created_at > NOW() - INTERVAL '2 hours'
  ORDER BY created_at DESC;
"
```

**If yes (legitimate hotfix):** The drift is expected. The operator made a manual change because they needed to (e.g., cert rotation, emergency config change). Proceed to [Resolve: Accept the Drift](#option-a-accept-the-drift).

**If no (unauthorized change):** Someone changed production outside of Pave. This is a process violation. Proceed to [Resolve: Revert the Drift](#option-b-revert-the-drift).

**If unclear:** Page the service owner. Don't revert until you understand what happened. The Round 2 incident was caused by reverting a legitimate manual fix.

### Is This PCI-Scoped?

If the drifted service is PCI-scoped (tagged `pci: true` in `pave.yaml`), this is a compliance event:
- Escalate to P0
- Notify security team
- Any manual change to a PCI service without approval gate is an audit finding

---

## Resolution

### Option A: Accept the Drift

The manual change was correct. Update Pave's expected state to match reality.

```bash
# Import the current cluster state as the new expected state
pave drift accept <drift-event-id> \
  --reason "Legitimate hotfix: <description>" \
  --actor <your-name>

# This updates Pave's expected state store to match the actual cluster state.
# The drift alert will clear on the next reconciliation cycle (< 60 seconds).
```

After accepting:
1. File a follow-up ticket to deploy the change properly through Pave (so the change is in the code repo, not just in the cluster).
2. Record in the audit log why the manual change was necessary and why it wasn't done through Pave.

### Option B: Revert the Drift

The manual change was unauthorized or incorrect. Restore the expected state.

```bash
# Revert to Pave's expected state
pave drift revert <drift-event-id> \
  --reason "Unauthorized change: <description>" \
  --actor <your-name>

# This applies Pave's expected manifests to the cluster, overwriting the drift.
# Equivalent to redeploying the last known good state.
```

**Caution:** Reverting drift on a live service may cause a brief disruption if the drifted state was keeping the service healthy (e.g., someone scaled up replicas to handle load). Assess impact before reverting.

### Option C: Investigate Further

If the drift is unexplained and potentially suspicious:

```bash
# Check Kubernetes audit log for who made the change
kubectl logs -n kube-system deployment/kube-apiserver --tail=200 | \
  grep "<namespace>/<resource-name>"

# Check RBAC — who has direct kubectl access to this namespace?
kubectl get rolebindings -n <namespace> -o wide
kubectl get clusterrolebindings -o wide | grep <namespace>
```

If a non-authorized user made the change, this is a security concern. Escalate to Marcus and the security team.

---

## Verification

After resolving drift (accept or revert):

```bash
# 1. Confirm drift is cleared
pave drift status --service <service-name>
# Expected: "No drift detected"

# 2. Verify on the dashboard
# D3: Drift Detection Dashboard — drift event should show as "resolved"

# 3. Wait for next reconciliation cycle (< 60 seconds)
# The metric pave_drift_detected_total should stop incrementing for this service

# 4. Verify the service is healthy after resolution
kubectl get pods -n <namespace> | grep <service>
curl -sf <service-health-endpoint>
```

---

## Prevention

Drift is a symptom. The root cause is that someone needed to change production outside of Pave. After every drift event, ask:

1. **Why couldn't this change go through Pave?** If Pave was down, see [Runbook: Pave Outage](./runbook-pave-outage.md) — the bootstrap procedure should be the path, not ad-hoc kubectl.
2. **Why was the change urgent?** If it was a config change or cert rotation, should Pave support this as a first-class operation?
3. **Who had access to make this change?** Should they? Review RBAC if not.

Track drift frequency per team. Teams with frequent drift need either better tooling or better process. Drift is natural — persistent drift is a signal.

---

## Escalation

| Time | If | Escalate to |
|------|------|-------------|
| +0 min | Drift detected | On-call engineer + service owner (Slack) |
| +0 min | Drift on PCI-scoped service | Security team + Marcus Chen |
| +1 hour | Service owner unresponsive | Marcus Chen |
| +4 hours | Drift unresolved | Marcus Chen — decide accept vs revert |
