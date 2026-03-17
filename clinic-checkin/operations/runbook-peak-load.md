# Runbook: Peak Load / Performance Degradation

**Severity:** P1 during clinic hours, P2 otherwise
**Impact:** Slow kiosk response, search hangs, dashboard updates delayed. Patients may leave the clinic.

### Traceability

| Link | Reference |
|------|-----------|
| **Triggered by:** | Alert: [p95 Response Time Warning/Critical](./monitoring-alerting.md#p1----notify-during-business-hours), Alert: [Concurrent Sessions > 40](./monitoring-alerting.md#p1----notify-during-business-hours), Alert: [DB Pool Near Capacity](./monitoring-alerting.md#p1----notify-during-business-hours), Alert: [Cache Hit Rate Low](./monitoring-alerting.md#p2----investigate-during-next-business-day) |
| **Caused by:** | Performance bottlenecks documented in [ADR-007](../architecture/adrs.md#adr-007-scaling-strategy-for-50-concurrent-sessions) root cause analysis: DB connection exhaustion, unoptimized search, dashboard broadcast storms |
| **Fixed by:** | [ADR-007: Scaling Strategy](../architecture/adrs.md#adr-007-scaling-strategy-for-50-concurrent-sessions) — PgBouncer, read replicas, Redis cache, search optimization |
| **Watches:** | [Check-In Service](../architecture/architecture.md#check-in-service-core), [PgBouncer](../architecture/architecture.md#connection-pooling-round-9), [Redis](../architecture/architecture.md#caching-round-9), [POST /patients/identify](../architecture/api-spec.md#post-patientsidentify), [GET /dashboard/queue](../architecture/api-spec.md#get-dashboardqueue) |
| **Proves:** | [US-006: Peak-hour performance](../product/user-stories.md#us-006-peak-hour-check-in-performance) — 50 concurrent sessions, p95 < 3s, search < 2s |
| **Detects:** | [TC-901: 50 concurrent check-ins](../quality/test-suites.md#tc-901-50-concurrent-kiosk-check-ins--response-time), [TC-902: Search under load](../quality/test-suites.md#tc-902-patient-search-performance-under-load), [TC-903: Dashboard stability](../quality/test-suites.md#tc-903-dashboard-stability-during-peak), [TC-904: Degraded mode](../quality/test-suites.md#tc-904-degraded-mode--slow-backend) failing in production |

---

## Detection

How you'll know:
- Alert: p95 response time > 2s (warning) or > 3s (critical)
- Alert: concurrent sessions > 40
- Alert: PgBouncer pool utilization > 80%
- Staff report: "The system is slow" / "Kiosk is frozen"
- Patient report: "I've been standing at this kiosk for 5 minutes"

---

## Quick Assessment (First 2 Minutes)

Run these checks in parallel to identify the bottleneck:

```bash
# 1. Overall response times -- which endpoints are slow?
curl -s https://api.clinic-checkin.example.com/metrics \
  | grep http_request_duration_seconds \
  | grep 'quantile="0.95"' \
  | sort -t' ' -k2 -rn | head -10

# 2. How many concurrent sessions right now?
curl -s https://api.clinic-checkin.example.com/metrics \
  | grep checkin_active_sessions

# 3. Database connection pool status
psql -h $PGBOUNCER_HOST -p 6432 -U pgbouncer pgbouncer -c "SHOW POOLS;"
# Look at: sv_active, sv_idle, cl_active, cl_waiting
# cl_waiting > 0 means clients are waiting for connections

# 4. Read replica lag
psql $DB_REPLICA_URL -c "
  SELECT EXTRACT(EPOCH FROM (NOW() - pg_last_xact_replay_timestamp())) AS lag_seconds;
"

# 5. Redis status
redis-cli -h $REDIS_HOST -p 6379 --tls INFO stats | grep -E "keyspace_hits|keyspace_misses"
# Calculate hit rate: hits / (hits + misses). Should be > 70%.

# 6. Check if auto-scaling has triggered
kubectl get pods -l app=checkin-service
# Or for ECS:
aws ecs describe-services --cluster clinic-prod --services checkin-service \
  | jq '.services[0].runningCount, .services[0].desiredCount'
```

---

## Response by Root Cause

### Root Cause: Database Connection Exhaustion

**Symptoms:** `cl_waiting > 0` in PgBouncer stats. Requests queuing.

```bash
# Check PgBouncer pool status
psql -h $PGBOUNCER_HOST -p 6432 -U pgbouncer pgbouncer -c "SHOW POOLS;"

# Check what queries are running on PostgreSQL
psql $DB_PRIMARY_URL -c "
  SELECT pid, state, query, wait_event_type,
         EXTRACT(EPOCH FROM (NOW() - query_start)) AS duration_seconds
  FROM pg_stat_activity
  WHERE state != 'idle'
    AND query NOT LIKE '%pg_stat%'
  ORDER BY duration_seconds DESC;
"

# Kill any long-running queries (> 30 seconds)
# CAREFUL: only kill queries you understand
psql $DB_PRIMARY_URL -c "
  SELECT pg_terminate_backend(pid)
  FROM pg_stat_activity
  WHERE state = 'active'
    AND query_start < NOW() - INTERVAL '30 seconds'
    AND query NOT LIKE '%pg_stat%';
"
```

**Temporary relief -- increase PgBouncer pool size:**

```bash
# Edit PgBouncer config (or environment variable)
# Increase default_pool_size from 25 to 35 temporarily
# Restart PgBouncer
sudo systemctl restart pgbouncer
# Or restart the PgBouncer container
```

**Caution:** Don't increase beyond PostgreSQL's `max_connections` (200). Each PgBouncer pool connection = 1 PostgreSQL connection.

### Root Cause: Slow Patient Search

**Symptoms:** `/patients/identify` endpoint p95 > 3 seconds. Search queries doing full table scans.

```bash
# Check if trigram index exists
psql $DB_REPLICA_URL -c "
  SELECT indexname, indexdef
  FROM pg_indexes
  WHERE tablename = 'patients'
  ORDER BY indexname;
"

# Check for missing indexes (should see idx_patients_name_trgm)
# If missing, create it (this is safe to run during peak -- CONCURRENTLY)
psql $DB_PRIMARY_URL -c "
  CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_patients_name_trgm
  ON patients USING gin ((last_name || ' ' || first_name) gin_trgm_ops);
"

# Check query execution plans for slow queries
psql $DB_REPLICA_URL -c "
  EXPLAIN ANALYZE
  SELECT id, first_name, last_name, date_of_birth
  FROM patients
  WHERE last_name ILIKE 'john%'
    AND deleted_at IS NULL
  LIMIT 10;
"
# Should show Index Scan or Bitmap Index Scan, NOT Seq Scan
```

**Immediate relief -- warm the cache:**

```bash
# Force cache refresh for common search prefixes
# The application will cache results for 30 seconds
# Just trigger a few searches to warm the cache
curl -s -X POST https://api.clinic-checkin.example.com/v1/patients/identify \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{"method":"name_search","search_query":"a","location_id":"<location_id>"}'
```

### Root Cause: Dashboard Broadcast Storm

**Symptoms:** Dashboard sluggish, high CPU on receptionist workstations, many WebSocket events in rapid succession.

```bash
# Check WebSocket event rate
curl -s https://api.clinic-checkin.example.com/metrics \
  | grep ws_events_pushed_total

# If events are not being batched (> 10 events/second to a single location),
# the event batching may not be working
# Check Notification Service logs:
{service="notification-service"} | json | message=~"batch|flush"
```

**Fix:** If event batching is disabled or broken, the dashboard still works but causes browser lag. Tell receptionist to refresh the page (clears accumulated state).

### Root Cause: Not Enough Application Instances

**Symptoms:** CPU > 80% on Check-In Service instances. Auto-scaling hasn't triggered or is too slow.

```bash
# Check current instance count and CPU
kubectl top pods -l app=checkin-service
# Or for ECS:
aws cloudwatch get-metric-statistics \
  --namespace AWS/ECS --metric-name CPUUtilization \
  --dimensions Name=ClusterName,Value=clinic-prod Name=ServiceName,Value=checkin-service \
  --start-time $(date -u -d '30 minutes ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 60 --statistics Average

# Manually scale up immediately
kubectl scale deployment checkin-service --replicas=4
# Or for ECS:
aws ecs update-service --cluster clinic-prod --service checkin-service --desired-count 4
```

### Root Cause: Redis Down or Slow

**Symptoms:** Cache miss rate 100%, all queries hitting database directly, compounding the load.

```bash
# Check Redis
redis-cli -h $REDIS_HOST -p 6379 --tls PING

# If Redis is up but slow, check memory
redis-cli -h $REDIS_HOST -p 6379 --tls INFO memory

# If Redis is down, the system still works (degrades to DB-only)
# But the DB will be under higher load
# Priority: get Redis back up, or scale DB connections
```

---

## Immediate Relief Actions (If Root Cause Is Unknown)

If the system is slow and you can't immediately identify why:

```bash
# 1. Scale up Check-In Service instances
kubectl scale deployment checkin-service --replicas=4

# 2. Kill any long-running DB queries
psql $DB_PRIMARY_URL -c "
  SELECT pg_terminate_backend(pid)
  FROM pg_stat_activity
  WHERE state = 'active'
    AND query_start < NOW() - INTERVAL '30 seconds'
    AND query NOT LIKE '%pg_stat%';
"

# 3. Clear Redis cache (forces fresh data, eliminates stale cache issues)
redis-cli -h $REDIS_HOST -p 6379 --tls FLUSHDB

# 4. Check if Migration Service is running a batch (stealing DB resources)
curl -s https://api.clinic-checkin.example.com/migration/health | jq .
# If it's running a batch, pause it:
# (The migration service should have a pause mechanism)
# Or just stop the service temporarily:
kubectl scale deployment migration-service --replicas=0
```

---

## Communication

If degradation lasts > 5 minutes during clinic hours:

**To clinic staff:**
> **"The check-in system is experiencing slowness. Kiosk operations may take longer than usual. This does not affect data accuracy -- all check-ins are being saved. We are actively working on it. If a patient's kiosk freezes, have them try the other kiosk or assist them at the front desk."**

---

## Post-Peak Recovery

After the rush ends (typically after 9:30 AM):

```bash
# 1. Scale back down (if manually scaled up)
kubectl scale deployment checkin-service --replicas=2

# 2. Check that all pending check-ins were processed
psql $DB_REPLICA_URL -c "
  SELECT status, sync_status, COUNT(*)
  FROM check_ins
  WHERE started_at > CURRENT_DATE
  GROUP BY status, sync_status;
"

# 3. Run VACUUM ANALYZE on hot tables if needed
psql $DB_PRIMARY_URL -c "
  VACUUM ANALYZE patients;
  VACUUM ANALYZE check_ins;
  VACUUM ANALYZE appointments;
"

# 4. Re-enable Migration Service if it was paused
kubectl scale deployment migration-service --replicas=1
```

---

## Prevention

- Review auto-scaling thresholds: if scaling triggered too late during the peak, lower the CPU threshold
- Pre-scale before known peaks: Monday mornings, first day after a holiday, flu season
- Consider running 3 Check-In Service instances permanently (rather than 2 with auto-scale to 4)
- Monitor trends: if peak concurrency is growing month-over-month, proactively increase capacity
- Schedule migration batches for evenings/weekends only
