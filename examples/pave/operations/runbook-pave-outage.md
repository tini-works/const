# Runbook: Pave Outage — The Deploy Platform Is Down

**Severity:** P0 — Page Immediately
**SLA:** Acknowledge within 15 minutes, restore deploy capability within 1 hour
**Last tested:** 2025-11-15 — Tabletop exercise: simulated API crash + database lock, walked through bootstrap procedure and manual deploy.
**Last triggered:** 2025-09-10 — Round 6 incident (BUG-003, deploy queue corruption). Full outage, 4 hours to restore. Bootstrap procedure was not yet documented — that's why this runbook exists.

When Pave is down, nobody can deploy. Including us. This is the meta problem.

### Traceability

| Link | Reference |
|------|-----------|
| **Triggered by:** | Alert: [Pave API Down](./monitoring-alerting.md#p0----page-immediately-any-time), [Deploy Engine Down](./monitoring-alerting.md#p0----page-immediately-any-time) |
| **Caused by:** | [BUG-003: Deploy queue corruption during RBAC migration](../quality/bug-reports.md#bug-003-deploy-queue-corruption-during-rbac-migration) — the original incident that exposed the need for this runbook |
| **Fixed by:** | [ADR-008: Deploy queue resilience](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery), [ADR-009: Break-glass bypass procedure](../architecture/adrs.md#adr-009-break-glass-bypass-procedure) |
| **Watches:** | [Pave API](../architecture/architecture.md#pave-api), [Deploy Engine](../architecture/architecture.md#deploy-engine) |
| **Proves:** | [US-010: Manual bypass when Pave is down](../product/user-stories.md#us-010-manual-bypass-when-pave-is-down), [US-011: Deploy queue resilience](../product/user-stories.md#us-011-deploy-queue-resilience) |
| **Detects:** | [TC-501: Break-glass manual deploy](../quality/test-suites.md#tc-501-break-glass--manual-deploy-when-pave-is-down), [TC-504: Queue recovery no lost deploys](../quality/test-suites.md#tc-504-queue-recovery--no-lost-deploys-after-crash) |
| **Confirmed by** | Sasha Petrov (DevOps/SRE), 2025-11-15 — tabletop exercise with full bootstrap walkthrough, recovery steps verified in staging |

---

## Detection

How you'll know:

- Alert: `up{job="pave-api"} == 0` or `up{job="pave-deploy-engine"} == 0`
- Synthetic health check fails (CronJob in `pave-monitoring` namespace)
- Teams report in Slack: "I'm getting `Error: Pave API unreachable` from the CLI"
- Deploy queue depth climbing with no deploys completing

Pave being slow is not the same as Pave being down. If the API is responding but deploys aren't executing, that's a Deploy Engine issue — skip to [Diagnosis: Deploy Engine](#deploy-engine).

---

## Immediate Response (First 15 Minutes)

### 1. Confirm the Outage

```bash
# Check from outside pave-system (use the synthetic check endpoint)
curl -sf http://pave.internal/api/healthz && echo "API is up" || echo "API is DOWN"

# Check pod status
kubectl get pods -n pave-system -o wide

# Check recent events
kubectl get events -n pave-system --sort-by='.lastTimestamp' | tail -20
```

### 2. Communicate

Post in #pave-incidents immediately:

> **Pave is currently unavailable. Deploys are blocked. We are investigating. If you have a P0/P1 fix that cannot wait, contact @sasha-petrov or @kai-tanaka for manual bypass.**

### 3. Activate Manual Bypass

If any team has an urgent deploy while Pave is down, they can use the bypass procedure documented in [deployment-procedure.md — Bootstrap Procedure](./deployment-procedure.md#bootstrap-procedure).

The bypass is manual `kubectl apply` with mandatory audit logging. Only Sasha, Kai, or Marcus can execute it.

---

## Diagnosis

### Pave API

```bash
# Check API pod logs
kubectl logs deployment/pave-api-blue -n pave-system --tail=100
kubectl logs deployment/pave-api-green -n pave-system --tail=100

# Check if it's a crash loop
kubectl get pods -n pave-system | grep pave-api
# STATUS: CrashLoopBackOff = application error (check logs)
# STATUS: Pending = resource pressure or scheduling issue
# STATUS: Running but not Ready = readiness probe failing

# Check resource pressure
kubectl top pods -n pave-system
kubectl describe pod <pave-api-pod> -n pave-system | grep -A5 "Conditions"
```

Common causes:
- **Bad deploy:** The last Pave API deploy introduced a bug. Rollback via bootstrap.
- **Database unreachable:** API can't connect to PostgreSQL. See [PostgreSQL](#postgresql).
- **OOM kill:** Pod memory exceeded limit. Check `kubectl describe pod` for OOMKilled.
- **Certificate expired:** Internal TLS cert for `pave.internal` expired. Renew via cert-manager.

### Deploy Engine

```bash
# Check Deploy Engine logs
kubectl logs deployment/pave-deploy-engine -n pave-system --tail=100

# Check if leader election is working (two replicas, one leader)
kubectl logs deployment/pave-deploy-engine -n pave-system | grep "leader"

# Check deploy queue state
psql $DATABASE_URL -c "
  SELECT status, COUNT(*)
  FROM deploy_events
  WHERE created_at > NOW() - INTERVAL '1 hour'
  GROUP BY status;
"
```

Common causes:
- **Queue corruption:** See [Runbook: Deploy Queue Corruption](./runbook-deploy-queue-corruption.md).
- **Leader election stuck:** Both replicas think the other is leader. Restart one.
- **Target namespace RBAC revoked:** Deploy Engine can't apply to target namespaces. Check ServiceAccount RoleBindings.

### PostgreSQL

```bash
# Check PostgreSQL pod
kubectl get pods -n pave-system | grep pg
kubectl logs statefulset/pave-pg-postgresql -n pave-system --tail=50

# Check from a Pave pod
kubectl exec -it deployment/pave-api-blue -n pave-system -- \
  pg_isready -h pave-pg-postgresql -p 5432

# Check for blocking locks (the Round 6 cause)
psql $DATABASE_URL -c "
  SELECT pid, state, query, wait_event_type, wait_event,
         NOW() - query_start AS duration
  FROM pg_stat_activity
  WHERE state != 'idle'
  ORDER BY duration DESC
  LIMIT 10;
"

# Check for locked tables
psql $DATABASE_URL -c "
  SELECT l.relation::regclass, l.mode, l.granted,
         a.pid, a.state, a.query
  FROM pg_locks l
  JOIN pg_stat_activity a ON a.pid = l.pid
  WHERE NOT l.granted;
"
```

Common causes:
- **Migration lock:** A migration is holding an exclusive lock. This is what caused Round 6. Kill the migration process, then assess whether it can be re-run safely.
- **Storage full:** PostgreSQL stops accepting writes. Expand PV or clean up old deploy_events.
- **Connection exhaustion:** Too many connections. Check PgBouncer stats.

### Redis

```bash
# Check Redis pod
kubectl get pods -n pave-system | grep redis
kubectl exec -it pave-redis-master-0 -n pave-system -- redis-cli ping
```

Redis being down degrades Pave but doesn't take it fully offline. The API falls back to PostgreSQL for status queries, and the dashboard uses polling instead of WebSocket push.

---

## Recovery

### If Bad Deploy — Rollback via Bootstrap

```bash
# Find the last known good image tag
kubectl get deployment pave-api-blue -n pave-system -o jsonpath='{.spec.template.spec.containers[0].image}'
# If the current image is bad, check deploy history:
kubectl rollout history deployment/pave-api-blue -n pave-system

# Rollback
kubectl rollout undo deployment/pave-api-blue -n pave-system
kubectl rollout status deployment/pave-api-blue -n pave-system

# Verify
curl -sf http://pave.internal/api/healthz
```

### If Database Lock — Kill and Recover

```bash
# Identify the blocking PID
psql $DATABASE_URL -c "
  SELECT pid, query FROM pg_stat_activity
  WHERE state = 'active' AND wait_event_type = 'Lock'
  ORDER BY query_start LIMIT 5;
"

# Kill the blocking process
psql $DATABASE_URL -c "SELECT pg_terminate_backend(<pid>);"

# Verify the lock is released
psql $DATABASE_URL -c "
  SELECT COUNT(*) FROM pg_locks WHERE NOT granted;
"

# Check deploy queue health
psql $DATABASE_URL -c "
  SELECT status, COUNT(*) FROM deploy_events
  WHERE created_at > NOW() - INTERVAL '1 hour'
  GROUP BY status;
"
```

If the deploy queue state is corrupted, see [Runbook: Deploy Queue Corruption](./runbook-deploy-queue-corruption.md).

### If Infrastructure Issue — Node/PV Problems

```bash
# Check node health
kubectl get nodes
kubectl describe node <node> | grep -A10 "Conditions"

# Check PersistentVolumes
kubectl get pv,pvc -n pave-system

# If node is NotReady, pods will be rescheduled automatically.
# If PV is lost, restore PostgreSQL from backup:
# See infrastructure.md — Disaster Recovery
```

---

## Verification

After recovery, confirm everything is working:

```bash
# 1. API health
curl -sf http://pave.internal/api/healthz | jq

# 2. Deploy a test service to staging
pave deploy test-app --env staging --commit test-$(date +%s)

# 3. Verify deploy queue is draining
pave queue status

# 4. Check monitoring dashboards
# D1: Pave Operations Overview — all green
# D2: Deploy Pipeline Dashboard — deploys flowing

# 5. Run drift check to confirm expected state matches reality
pave drift-check --all --env production
```

---

## Audit — After Recovery

Every action taken during the outage must be retroactively logged:

1. **Log all manual deploys** performed via bootstrap procedure in Pave's audit log (see [deployment-procedure.md — After Bootstrap Recovery](./deployment-procedure.md#after-bootstrap-recovery)).
2. **Log all manual database operations** (killed PIDs, direct SQL).
3. **Update drift detection** — if manual changes were made to the cluster, Pave's expected state must be updated to match.

---

## Post-Mortem Template

Use within 48 hours of any Pave outage.

```markdown
## Incident: [Title]
**Date:** YYYY-MM-DD
**Duration:** X hours Y minutes
**Severity:** P0/P1
**Author:** [name]
**Responders:** [names]

### Timeline
- HH:MM — Alert fired / issue reported
- HH:MM — Acknowledged by [name]
- HH:MM — Root cause identified: [what]
- HH:MM — Fix applied: [what]
- HH:MM — Service restored
- HH:MM — Verification complete

### Root Cause
[What broke and why. Not "the deploy failed" but "the migration acquired an ACCESS EXCLUSIVE lock on deploy_queue while 50K rows were being reindexed."]

### Impact
- Duration: X hours
- Teams blocked: N
- Deploys delayed: N
- Manual bypasses executed: N
- Any data loss: yes/no

### What Went Well
- [e.g., "Bootstrap procedure worked as documented"]

### What Went Wrong
- [e.g., "Migration wasn't tested against production-volume data"]

### Action Items
| Action | Owner | Due |
|--------|-------|-----|
| [action] | [name] | [date] |

### Constitution Impact
Which proven items became suspect? How were they re-verified?
```

---

## Escalation

| Time | If | Escalate to |
|------|------|-------------|
| +0 min | Alert fires | On-call engineer (platform team) |
| +15 min | No ack | Secondary on-call |
| +30 min | Not resolved | Marcus Chen (Platform Lead) |
| +1 hour | Still down, teams blocked | CTO James Liu |
| +1 hour | Teams need to deploy P0 fixes | Activate bootstrap bypass for requesting teams |
