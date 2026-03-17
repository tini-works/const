# Runbook: Database Failure

**Severity:** P0 -- Page Immediately
**Impact:** Total system outage. No check-ins, no dashboard, no data access.

---

## Detection

- Alert: `pg_up == 0` for > 30 seconds
- Alert: all service health checks return `"database": "error"`
- All HTTP requests returning 500
- PgBouncer logs showing connection refused to backend

---

## Immediate Response

### 1. Determine the Failure Type

```bash
# Can you connect to PostgreSQL?
psql $DB_PRIMARY_URL -c "SELECT 1;" 2>&1

# Can you connect to PgBouncer?
psql -h $PGBOUNCER_HOST -p 6432 -U pgbouncer pgbouncer -c "SHOW STATS;" 2>&1

# Check managed database status (RDS)
aws rds describe-db-instances --db-instance-identifier clinic-checkin-primary \
  | jq '.DBInstances[0] | {DBInstanceStatus, Endpoint, MultiAZ}'
```

---

## Response by Failure Type

### Type A: PgBouncer Down (PostgreSQL is Fine)

```bash
# Verify PG is reachable directly (bypass PgBouncer)
psql -h $DB_PRIMARY_HOST -p 5432 -U app_user -d clinic_checkin -c "SELECT 1;"
# If this works, PgBouncer is the problem

# Restart PgBouncer
sudo systemctl restart pgbouncer
# Or: kubectl rollout restart deployment/pgbouncer

# Verify
psql -h $PGBOUNCER_HOST -p 6432 -U pgbouncer pgbouncer -c "SHOW POOLS;"

# If PgBouncer won't start:
cat /etc/pgbouncer/pgbouncer.ini
journalctl -u pgbouncer --since "10 minutes ago"

# Emergency bypass (removes pooling -- short-term only):
kubectl set env deployment/checkin-service \
  DB_PRIMARY_URL="postgresql://user:pass@$DB_PRIMARY_HOST:5432/clinic_checkin"
```

### Type B: PostgreSQL Primary Down (Managed DB -- Automatic Failover)

```bash
# Check if automated failover is in progress (RDS Multi-AZ)
aws rds describe-events \
  --source-identifier clinic-checkin-primary \
  --source-type db-instance --duration 30 \
  | jq '.Events[] | {Date, Message}'

# RDS Multi-AZ failover is automatic, takes 1-3 minutes
# The endpoint DNS updates to point to the new primary

# Monitor progress:
watch -n 5 'aws rds describe-db-instances \
  --db-instance-identifier clinic-checkin-primary \
  | jq ".DBInstances[0].DBInstanceStatus"'
# Wait until status returns to "available"

# After failover, restart PgBouncer to pick up new backend
sudo systemctl restart pgbouncer

# If app connections still fail:
kubectl rollout restart deployment/checkin-service
kubectl rollout restart deployment/notification-service
```

### Type C: PostgreSQL Primary Down (Manual Failover Required)

```bash
# 1. Check if read replica is available
psql $DB_REPLICA_URL -c "SELECT 1;"

# 2. Promote replica to primary (one-way operation)
# For RDS:
aws rds promote-read-replica --db-instance-identifier clinic-checkin-replica

# For self-managed PostgreSQL:
sudo -u postgres pg_ctl promote -D /var/lib/postgresql/16/main

# 3. Update PgBouncer to point to new primary
# Edit /etc/pgbouncer/pgbouncer.ini with new host
sudo systemctl restart pgbouncer

# 4. Create new read replica later (not during incident)
```

### Type D: Database Storage Full

```bash
# Check storage
psql $DB_PRIMARY_URL -c "SELECT pg_size_pretty(pg_database_size('clinic_checkin'));"

# Find largest tables
psql $DB_PRIMARY_URL -c "
  SELECT relname, pg_size_pretty(pg_total_relation_size(c.oid)) AS total_size
  FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
  WHERE n.nspname = 'public'
  ORDER BY pg_total_relation_size(c.oid) DESC LIMIT 10;
"

# Increase storage (RDS)
aws rds modify-db-instance \
  --db-instance-identifier clinic-checkin-primary \
  --allocated-storage 200 --apply-immediately

# Reclaim space (non-locking, safe during clinic hours)
psql $DB_PRIMARY_URL -c "VACUUM VERBOSE patients;"
```

### Type E: Connection Limit Reached

```bash
# Check current connections
psql $DB_PRIMARY_URL -c "
  SELECT COUNT(*) AS total,
         COUNT(*) FILTER (WHERE state = 'active') AS active,
         COUNT(*) FILTER (WHERE state = 'idle') AS idle,
         COUNT(*) FILTER (WHERE state = 'idle in transaction') AS idle_in_tx
  FROM pg_stat_activity;
"

# Terminate leaked idle-in-transaction connections
psql $DB_PRIMARY_URL -c "
  SELECT pg_terminate_backend(pid) FROM pg_stat_activity
  WHERE state = 'idle in transaction'
    AND state_change < NOW() - INTERVAL '5 minutes';
"
```

---

## Read Replica Issues

Read replica being down is P1, not P0 (check-ins still work via primary).

```bash
# Check replica status
psql $DB_REPLICA_URL -c "
  SELECT pg_is_in_recovery() AS is_replica,
         pg_last_xact_replay_timestamp() AS last_replay,
         EXTRACT(EPOCH FROM (NOW() - pg_last_xact_replay_timestamp())) AS lag_seconds;
"

# If replica is down, app falls back to primary for reads
# This increases primary load. Monitor PgBouncer pool utilization.
# Rebuild replica when stable.
```

---

## Data Recovery (Last Resort)

If the database is corrupted and cannot be repaired:

```bash
# 1. Stop all application services
kubectl scale deployment checkin-service --replicas=0
kubectl scale deployment notification-service --replicas=0
kubectl scale deployment migration-service --replicas=0

# 2. Restore from backup (RDS point-in-time recovery)
aws rds restore-db-instance-to-point-in-time \
  --source-db-instance-identifier clinic-checkin-primary \
  --target-db-instance-identifier clinic-checkin-primary-restored \
  --restore-time "2026-03-17T08:00:00Z"

# 3. Update PgBouncer to point to restored instance
# 4. Restart application services
# 5. Assess data loss (anything after restore point is gone)
# 6. Incident postmortem required -- data loss is a major incident
```

---

## Communication During Database Outage

> "The check-in system is currently down due to a database issue. Please check in patients manually using paper forms. We expect restoration within [X] minutes. All patient data prior to the outage is safe."

---

## Post-Recovery Checklist

```bash
# 1. Verify all tables accessible
psql $DB_PRIMARY_URL -c "
  SELECT COUNT(*) FROM patients;
  SELECT COUNT(*) FROM appointments WHERE appointment_time > CURRENT_DATE;
  SELECT COUNT(*) FROM check_ins WHERE started_at > CURRENT_DATE;
"

# 2. Verify replication
psql $DB_REPLICA_URL -c "
  SELECT EXTRACT(EPOCH FROM (NOW() - pg_last_xact_replay_timestamp())) AS lag_seconds;
"

# 3. Application services healthy
curl -s https://api.clinic-checkin.example.com/health | jq .

# 4. VACUUM ANALYZE on key tables
psql $DB_PRIMARY_URL -c "
  VACUUM ANALYZE patients;
  VACUUM ANALYZE check_ins;
  VACUUM ANALYZE appointments;
"

# 5. Monitor for 1 hour post-recovery
```
