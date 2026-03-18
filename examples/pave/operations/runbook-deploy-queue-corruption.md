# Runbook: Deploy Queue Corruption

**Severity:** P0 — Page Immediately
**SLA:** Acknowledge within 15 minutes, restore queue within 2 hours
**Last tested:** 2025-11-15 — Tabletop exercise: simulated corrupted queue state, walked through event log rebuild.
**Last triggered:** 2025-09-10 — Round 6 incident. RBAC migration locked deploy_queue for 4 hours. Three teams had P1 fixes queued. Queue state was inconsistent after the lock was force-released.

### Traceability

| Link | Reference |
|------|-----------|
| **Triggered by:** | Alert: [Deploy Queue Corruption](./monitoring-alerting.md#p0----page-immediately-any-time) (`pave_deploy_queue_depth > 50 AND rate(pave_deploys_total[10m]) == 0`) |
| **Caused by:** | [BUG-003: Deploy queue corruption during RBAC migration](../quality/bug-reports.md#bug-003-deploy-queue-corruption-during-rbac-migration) |
| **Fixed by:** | [ADR-008: Deploy queue resilience — WAL-based recovery](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery) |
| **Watches:** | [Deploy Engine](../architecture/architecture.md#deploy-engine), [PostgreSQL deploy_events table](../architecture/data-model.md) |
| **Proves:** | [US-011: Deploy queue resilience](../product/user-stories.md#us-011-deploy-queue-resilience) — no queued deploys lost after failure |
| **Detects:** | [TC-503: Queue state derived from event log](../quality/test-suites.md#tc-503-queue-state-derived-from-event-log), [TC-504: Queue recovery no lost deploys](../quality/test-suites.md#tc-504-queue-recovery--no-lost-deploys-after-crash) |
| **Confirmed by** | Sasha Petrov (DevOps/SRE), 2025-11-15 — event log rebuild procedure tested in staging with 10K events |

---

## Detection

How you'll know:

- Alert: Queue depth > 50 and no deploys completing for 10+ minutes
- Teams report: "My deploy has been queued for 30 minutes"
- Dashboard shows deploys in "queued" status but none transitioning to "executing"
- Deploy Engine logs show errors reading from or writing to the queue

---

## Diagnosis

### 1. Check Queue State

```bash
# Current queue contents
psql $DATABASE_URL -c "
  SELECT id, service, team, status, created_at, updated_at
  FROM deploy_queue
  WHERE status IN ('queued', 'executing')
  ORDER BY created_at;
"

# Check if the Deploy Engine is processing
kubectl logs deployment/pave-deploy-engine -n pave-system --tail=50 | grep -E "queue|dequeue|execute"
```

### 2. Check for Database Locks

```bash
# Look for blocking locks on deploy_queue or deploy_events
psql $DATABASE_URL -c "
  SELECT l.relation::regclass AS table,
         l.mode, l.granted,
         a.pid, a.state, a.query,
         NOW() - a.query_start AS duration
  FROM pg_locks l
  JOIN pg_stat_activity a ON a.pid = l.pid
  WHERE l.relation::regclass::text IN ('deploy_queue', 'deploy_events')
  ORDER BY duration DESC;
"
```

If you see a long-running lock on `deploy_queue`: this is the Round 6 pattern. Kill the blocking process (see [Runbook: Pave Outage — Database Lock](./runbook-pave-outage.md#if-database-lock----kill-and-recover)).

### 3. Check Event Log Integrity

The deploy queue state is derived from the `deploy_events` table ([ADR-008](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery)). If the queue is corrupted but the event log is intact, we can rebuild.

```bash
# Count events by type in the last 24 hours
psql $DATABASE_URL -c "
  SELECT event_type, COUNT(*)
  FROM deploy_events
  WHERE created_at > NOW() - INTERVAL '24 hours'
  GROUP BY event_type
  ORDER BY event_type;
"

# Look for orphaned deploys (queued event without a corresponding complete/fail event)
psql $DATABASE_URL -c "
  SELECT e.deploy_id, e.service, e.team, e.created_at
  FROM deploy_events e
  WHERE e.event_type = 'deploy_queued'
    AND e.created_at > NOW() - INTERVAL '24 hours'
    AND NOT EXISTS (
      SELECT 1 FROM deploy_events e2
      WHERE e2.deploy_id = e.deploy_id
        AND e2.event_type IN ('deploy_completed', 'deploy_failed', 'deploy_cancelled')
    );
"
```

---

## Recovery

### Option A: Restart Deploy Engine (If Queue Data Is Intact)

If the queue table data looks correct but the engine stopped processing:

```bash
# Restart the Deploy Engine
kubectl rollout restart deployment/pave-deploy-engine -n pave-system
kubectl rollout status deployment/pave-deploy-engine -n pave-system

# Watch it pick up queued deploys
kubectl logs deployment/pave-deploy-engine -n pave-system --follow | grep -E "dequeue|execute"
```

### Option B: Rebuild Queue from Event Log (If Queue Table Is Corrupted)

This is the nuclear option. It derives the queue state from the immutable event log.

```bash
# 1. Stop the Deploy Engine to prevent concurrent writes
kubectl scale deployment/pave-deploy-engine --replicas=0 -n pave-system

# 2. Truncate the corrupted queue table
psql $DATABASE_URL -c "TRUNCATE deploy_queue;"

# 3. Rebuild from event log
# The rebuild script replays all events and derives current state
kubectl exec -it deployment/pave-api-blue -n pave-system -- \
  /app/pave-admin queue rebuild --from-events

# If the admin command is not available, run the SQL directly:
psql $DATABASE_URL -c "
  INSERT INTO deploy_queue (id, service, team, environment, commit_sha, image, status, created_at)
  SELECT
    e.deploy_id,
    e.service,
    e.team,
    e.environment,
    e.commit_sha,
    e.image,
    CASE
      WHEN EXISTS (SELECT 1 FROM deploy_events e2 WHERE e2.deploy_id = e.deploy_id AND e2.event_type = 'deploy_completed') THEN 'completed'
      WHEN EXISTS (SELECT 1 FROM deploy_events e2 WHERE e2.deploy_id = e.deploy_id AND e2.event_type = 'deploy_failed') THEN 'failed'
      WHEN EXISTS (SELECT 1 FROM deploy_events e2 WHERE e2.deploy_id = e.deploy_id AND e2.event_type = 'deploy_executing') THEN 'queued'  -- re-queue executing deploys
      ELSE 'queued'
    END AS status,
    e.created_at
  FROM deploy_events e
  WHERE e.event_type = 'deploy_queued'
    AND e.created_at > NOW() - INTERVAL '7 days'
  ON CONFLICT (id) DO NOTHING;
"

# 4. Restart the Deploy Engine
kubectl scale deployment/pave-deploy-engine --replicas=2 -n pave-system

# 5. Watch the queue drain
kubectl logs deployment/pave-deploy-engine -n pave-system --follow | grep -E "dequeue|execute"
```

### Option C: Emergency Drain (If Teams Are Blocked and Queue Can't Be Rebuilt Quickly)

If the queue is stuck and teams need to deploy urgently, bypass Pave entirely:

1. Communicate in #pave-incidents: "Queue recovery in progress. Manual bypass available for urgent deploys."
2. For each urgent deploy, use the [Bootstrap Procedure](./deployment-procedure.md#bootstrap-procedure).
3. After recovery, retroactively log all manual deploys in Pave's audit log.

---

## Verification

After recovery:

```bash
# 1. Queue is draining
psql $DATABASE_URL -c "
  SELECT status, COUNT(*)
  FROM deploy_queue
  GROUP BY status;
"
# Expected: some 'queued', some 'executing', no stuck items

# 2. Test a deploy
pave deploy test-app --env staging --commit test-$(date +%s)

# 3. Verify event log integrity
psql $DATABASE_URL -c "
  SELECT event_type, COUNT(*)
  FROM deploy_events
  WHERE created_at > NOW() - INTERVAL '1 hour'
  GROUP BY event_type;
"
# Expected: deploy_queued, deploy_executing, deploy_completed events flowing

# 4. Check no deploys were lost
# Compare the list of orphaned deploys from diagnosis against the rebuilt queue.
# Every deploy that was queued before the incident should either be:
#   - In the queue (will execute)
#   - Completed/failed (already executed during the incident window)
#   - Logged as manually bypassed
```

---

## Prevention

After Round 6, these safeguards were added:

1. **Event-sourced queue** ([ADR-008](../architecture/adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery)): The queue state is always derivable from the event log. Even if the queue table is corrupted, no deploys are lost.
2. **Migration safety rules** ([deployment-procedure.md](./deployment-procedure.md#migration-safety-rules)): All migrations touching deploy_queue, deploy_events, or audit_log require Sasha's sign-off and production-volume testing.
3. **Non-blocking migrations**: All DDL on large tables uses `CREATE INDEX CONCURRENTLY`, `ADD CONSTRAINT NOT VALID`, etc.

---

## Escalation

| Time | If | Escalate to |
|------|------|-------------|
| +0 min | Alert fires | On-call engineer (platform team) |
| +15 min | No ack | Secondary on-call |
| +30 min | Queue not recovering | Marcus Chen (Platform Lead) |
| +1 hour | Teams blocked with P0/P1 fixes | Activate manual bypass for all requesting teams |
