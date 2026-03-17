# Runbook: Database Failure

**Severity:** P0 -- Page Immediately
**Impact:** Total system outage. No check-ins, no dashboard, no data access. All kiosks show "unavailable."

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
# Can you connect to PostgreSQL at all?
psql $DB_PRIMARY_URL -c "SELECT 1;" 2>&1

# Can you connect to PgBouncer?
psql -h $PGBOUNCER_HOST -p 6432 -U pgbouncer pgbouncer -c "SHOW STATS;" 2>&1

# Check PgBouncer for backend errors
psql -h $PGBOUNCER_HOST -p 6432 -U pgbouncer pgbouncer -c "SHOW POOLS;"
# sv_active=0, sv_idle=0, cl_waiting=high → PgBouncer can't reach PostgreSQL

# Check managed database status (RDS/Cloud SQL/etc.)
aws rds describe-db-instances --db-instance-identifier clinic-checkin-primary \
  | jq '.DBInstances[0] | {DBInstanceStatus, Endpoint, MultiAZ, ReadReplicaDBInstanceIdentifiers}'
```

---

## Response by Failure Type

### Type A: PgBouncer Down (PostgreSQL is Fine)

```bash
# Verify PostgreSQL is reachable directly
psql -h $DB_PRIMARY_HOST -p 5432 -U app_user -d clinic_checkin -c "SELECT 1;"
# If this works, PgBouncer is the problem

# Restart PgBouncer
sudo systemctl restart pgbouncer
# Or restart the container:
kubectl rollout restart deployment/pgbouncer

# Verify
psql -h $PGBOUNCER_HOST -p 6432 -U pgbouncer pgbouncer -c "SHOW POOLS;"

# If PgBouncer won't start, check its config and logs
cat /etc/pgbouncer/pgbouncer.ini
journalctl -u pgbouncer --since "10 minutes ago"
```

**As a last resort**, application services can connect directly to PostgreSQL (bypass PgBouncer):

```bash
# Update the DB_PRIMARY_URL environment variable on all services
# to point to PostgreSQL directly (port 5432) instead of PgBouncer (port 6432)
# WARNING: This removes connection pooling. Only do this for short-term emergency.
kubectl set env deployment/checkin-service DB_PRIMARY_URL="postgresql://user:pass@$DB_PRIMARY_HOST:5432/clinic_checkin"
```

### Type B: PostgreSQL Primary Down (Managed DB Failover)

If using a managed database (RDS, Cloud SQL) with Multi-AZ:

```bash
# Check if automated failover is in progress
aws rds describe-events \
  --source-identifier clinic-checkin-primary \
  --source-type db-instance \
  --duration 30 \
  | jq '.Events[] | {Date, Message}'

# RDS Multi-AZ failover is automatic and takes 1-3 minutes
# The endpoint DNS record updates to point to the new primary
# Application connections will fail during failover, then reconnect automatically

# Monitor failover progress
watch -n 5 'aws rds describe-db-instances \
  --db-instance-identifier clinic-checkin-primary \
  | jq ".DBInstances[0].DBInstanceStatus"'
# Wait until status returns to "available"
```

After failover:
```bash
# PgBouncer may need to be restarted to pick up the new backend
sudo systemctl restart pgbouncer

# Application services may need to clear their connection pools
# Usually restarting PgBouncer is sufficient
# If not, restart application services:
kubectl rollout restart deployment/checkin-service
kubectl rollout restart deployment/notification-service
```

### Type C: PostgreSQL Primary Down (No Automatic Failover)

If there's no automatic failover (self-managed PostgreSQL):

```bash
# 1. Check if the read replica is available
psql $DB_REPLICA_URL -c "SELECT 1;"

# 2. If replica is available, promote it to primary
# WARNING: This is a one-way operation. The old primary cannot rejoin as replica.

# For RDS:
aws rds promote-read-replica --db-instance-identifier clinic-checkin-replica

# For self-managed PostgreSQL:
# On the replica server:
sudo -u postgres pg_ctl promote -D /var/lib/postgresql/16/main

# 3. Update PgBouncer to point to the new primary (the promoted replica)
# Edit /etc/pgbouncer/pgbouncer.ini:
# [databases]
# clinic_checkin = host=<NEW_PRIMARY_HOST> port=5432 dbname=clinic_checkin
sudo systemctl restart pgbouncer

# 4. Update application environment variables if needed
# (If using PgBouncer, the app config doesn't change -- only PgBouncer's backend changes)

# 5. Create a new read replica from the new primary
# This can be done later, not during the incident
```

### Type D: Database Storage Full

```bash
# Check storage usage
psql $DB_PRIMARY_URL -c "
  SELECT pg_size_pretty(pg_database_size('clinic_checkin')) AS db_size;
"

# Find the largest tables
psql $DB_PRIMARY_URL -c "
  SELECT relname AS table,
         pg_size_pretty(pg_total_relation_size(c.oid)) AS total_size
  FROM pg_class c
  JOIN pg_namespace n ON n.oid = c.relnamespace
  WHERE n.nspname = 'public'
  ORDER BY pg_total_relation_size(c.oid) DESC
  LIMIT 10;
"

# audit_log is likely the largest table. Check its growth rate:
psql $DB_PRIMARY_URL -c "
  SELECT DATE_TRUNC('day', created_at) AS day, COUNT(*) AS rows
  FROM audit_log
  WHERE created_at > NOW() - INTERVAL '7 days'
  GROUP BY day ORDER BY day;
"

# Emergency: increase storage
# For RDS:
aws rds modify-db-instance \
  --db-instance-identifier clinic-checkin-primary \
  --allocated-storage 200 \
  --apply-immediately

# Clean up dead tuples (reclaim space from deleted rows)
psql $DB_PRIMARY_URL -c "VACUUM FULL patients;"  -- WARNING: locks the table
# Prefer VACUUM (VERBOSE) without FULL during clinic hours (no lock):
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

# If "idle in transaction" is high, those connections are leaked
# Find and terminate them
psql $DB_PRIMARY_URL -c "
  SELECT pg_terminate_backend(pid)
  FROM pg_stat_activity
  WHERE state = 'idle in transaction'
    AND state_change < NOW() - INTERVAL '5 minutes';
"

# If total connections are at max_connections (200):
# Increase temporarily:
psql $DB_PRIMARY_URL -c "ALTER SYSTEM SET max_connections = 300;"
# Requires PostgreSQL restart to take effect (managed DB handles this)
# Or: rely on PgBouncer to queue clients (the proper long-term fix)
```

---

## Read Replica Issues

The read replica being down is P1, not P0 (check-ins still work via primary).

```bash
# Check replica status
psql $DB_REPLICA_URL -c "
  SELECT pg_is_in_recovery() AS is_replica,
         pg_last_xact_replay_timestamp() AS last_replay,
         EXTRACT(EPOCH FROM (NOW() - pg_last_xact_replay_timestamp())) AS lag_seconds;
"

# If lag is growing (> 10 seconds), the replica may be falling behind
# Check for long-running queries on the replica blocking replay:
psql $DB_REPLICA_URL -c "
  SELECT pid, state, query,
         EXTRACT(EPOCH FROM (NOW() - query_start)) AS duration_seconds
  FROM pg_stat_activity
  WHERE state = 'active' AND query NOT LIKE '%pg_stat%'
  ORDER BY duration_seconds DESC;
"

# If replica is completely down, the application falls back to primary for reads
# This increases primary load. Monitor PgBouncer pool utilization.
# Rebuild the replica:
# For RDS: delete and recreate the read replica
aws rds create-db-instance-read-replica \
  --db-instance-identifier clinic-checkin-replica-new \
  --source-db-instance-identifier clinic-checkin-primary
```

---

## Data Recovery (Last Resort)

If the database is corrupted and cannot be repaired:

```bash
# 1. Stop all application services to prevent further writes
kubectl scale deployment checkin-service --replicas=0
kubectl scale deployment notification-service --replicas=0
kubectl scale deployment migration-service --replicas=0

# 2. Restore from backup
# For RDS - point-in-time recovery:
aws rds restore-db-instance-to-point-in-time \
  --source-db-instance-identifier clinic-checkin-primary \
  --target-db-instance-identifier clinic-checkin-primary-restored \
  --restore-time "2026-03-17T08:00:00Z"
  # Choose the latest time before the corruption

# 3. Update PgBouncer to point to the restored instance
# 4. Restart application services
# 5. Assess data loss (anything written between the restore point and now)
# 6. Incident postmortem required -- any data loss is a major incident
```

---

## Communication During Database Outage

**To clinic staff:**
> **"The check-in system is currently down due to a database issue. Please check in patients manually using paper forms. We expect the system to be restored within [X] minutes. All patient data prior to the outage is safe and will be available once the system is restored."**

---

## Post-Recovery

```bash
# 1. Verify all tables are accessible
psql $DB_PRIMARY_URL -c "
  SELECT COUNT(*) FROM patients;
  SELECT COUNT(*) FROM appointments WHERE appointment_time > CURRENT_DATE;
  SELECT COUNT(*) FROM check_ins WHERE started_at > CURRENT_DATE;
"

# 2. Verify replication is working
psql $DB_REPLICA_URL -c "
  SELECT EXTRACT(EPOCH FROM (NOW() - pg_last_xact_replay_timestamp())) AS lag_seconds;
"

# 3. Verify application services are healthy
curl -s https://api.clinic-checkin.example.com/health | jq .

# 4. Run VACUUM ANALYZE on key tables
psql $DB_PRIMARY_URL -c "
  VACUUM ANALYZE patients;
  VACUUM ANALYZE check_ins;
  VACUUM ANALYZE appointments;
"

# 5. Monitor for 1 hour post-recovery
```
