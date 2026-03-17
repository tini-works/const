# Runbook: Concurrent Edit / Version Conflict Issues

**Severity:** P2 (operational) / P1 (if data loss is confirmed)
**Impact:** Staff members see "This record was modified since you loaded it" errors. In the worst case (if optimistic locking fails), data is silently lost.
**Last tested:** 2026-03-17 — Walked through Scenario A (frequent conflicts) and Scenario B (stale cache) in staging.
**Last triggered:** Never in production. BUG-003 occurred pre-launch; ADR-003 has prevented recurrence.

### Traceability

| Link | Reference |
|------|-----------|
| **Triggered by:** | Alert: `patient_version_conflict_total` spike — monitored on [Check-In Flow Dashboard](./monitoring-alerting.md#4-check-in-flow-dashboard) |
| **Caused by:** | [BUG-003: Concurrent edit causes silent data loss](../quality/bug-reports.md#bug-003-concurrent-edit-by-two-receptionists-causes-silent-data-loss) — the original incident |
| **Fixed by:** | [ADR-003: Optimistic Concurrency Control via Version Field](../architecture/adrs.md#adr-003-optimistic-concurrency-control-via-version-field) |
| **Watches:** | [PATCH /patients/{id}](../architecture/api-spec.md#patch-patientsid) — version field enforcement, [Check-In Service](../architecture/architecture.md#check-in-service-core) |
| **Proves:** | [US-004: Concurrent edit safety](../product/user-stories.md#us-004-concurrent-edit-safety-for-patient-records) — no silent data loss |
| **Detects:** | [TC-701: Conflict detection](../quality/test-suites.md#tc-701-two-receptionists--conflict-detection), [TC-705: Same field conflict](../quality/test-suites.md#tc-705-concurrent-edit--same-field-by-two-users) failing in production |

---

## Detection

How you'll know:
- Alert: `patient_version_conflict_total` spikes significantly above normal (> 10 in 1 hour)
- Staff report: "I keep getting conflict errors when I try to save"
- Staff report: "My changes disappeared" (indicates optimistic locking may have failed)
- Alert: unusual pattern in `patient_record_versions` (multiple rapid version increments for same patient)

---

## Normal vs. Abnormal

Version conflicts are **expected behavior** -- the system is working correctly when it detects conflicts. The concern is:

| Scenario | Normal? | Action |
|----------|---------|--------|
| Occasional 409 conflict (1-2/day) | Yes | No action. Staff resolves via UI. |
| Frequent conflicts on same patient | Investigate | May indicate workflow issue (two staff assigned same patient) |
| Spike in conflicts during peak hours | Maybe | Check if connection pooling or caching is causing stale reads |
| Staff reports lost data (no conflict shown) | P1 | Optimistic locking may be broken. Investigate immediately. |

---

## Diagnosis

### Scenario A: Staff Reports Frequent Conflict Errors

This is the system working as designed, but it might indicate a workflow problem.

```bash
# Check which patients are experiencing conflicts
psql $DB_REPLICA_URL -c "
  SELECT p.id, p.first_name, p.last_name, p.version,
         COUNT(prv.id) AS version_changes_today
  FROM patients p
  JOIN patient_record_versions prv ON prv.patient_id = p.id
  WHERE prv.created_at > CURRENT_DATE
  GROUP BY p.id, p.first_name, p.last_name, p.version
  HAVING COUNT(prv.id) > 3
  ORDER BY COUNT(prv.id) DESC;
"

# Check who is editing these records
psql $DB_REPLICA_URL -c "
  SELECT prv.patient_id, prv.version, prv.changed_by_type, prv.changed_by_id,
         s.name AS staff_name, prv.created_at, prv.change_summary
  FROM patient_record_versions prv
  LEFT JOIN staff s ON s.id = prv.changed_by_id
  WHERE prv.patient_id = '<patient_uuid>'
  ORDER BY prv.version;
"
```

**Resolution:** If two staff members are repeatedly editing the same patient, this is a workflow issue. Recommend to clinic management: assign specific patients to specific receptionists during check-in rush.

### Scenario B: Conflicts Caused by Stale Cache

If the read replica or Redis cache serves a stale version number, the client sends the wrong version in the PATCH request, causing a false conflict.

```bash
# Check read replica lag
psql $DB_REPLICA_URL -c "
  SELECT
    EXTRACT(EPOCH FROM (NOW() - pg_last_xact_replay_timestamp())) AS lag_seconds;
"

# Check if patient records are being served from cache with wrong version
redis-cli -h $REDIS_HOST -p 6379 --tls GET "patient:<patient_uuid>:summary"
# Compare the version in cache with the version in the primary DB
psql $DB_PRIMARY_URL -c "
  SELECT id, version, updated_at FROM patients WHERE id = '<patient_uuid>';
"
```

**Resolution:** If cache is stale, invalidate it:
```bash
redis-cli -h $REDIS_HOST -p 6379 --tls DEL "patient:<patient_uuid>:summary"
```

If this is happening frequently, check cache invalidation logic:
- The write-through invalidation on `PATCH /patients/{id}` should delete the cache key
- Check application logs for errors in the cache invalidation path

### Scenario C: Staff Reports Data Loss (No Conflict Shown)

This is the original BUG-003 scenario. If optimistic locking is working correctly, this should not happen. If it does, the locking mechanism may be broken.

```bash
# Verify the version field is being checked on writes
# Check recent updates -- was the version incremented?
psql $DB_PRIMARY_URL -c "
  SELECT id, version, updated_at
  FROM patients
  WHERE updated_at > NOW() - INTERVAL '1 hour'
  ORDER BY updated_at DESC
  LIMIT 20;
"

# Check version history for the affected patient
psql $DB_PRIMARY_URL -c "
  SELECT version, changed_by_type, changed_by_id, change_summary, created_at
  FROM patient_record_versions
  WHERE patient_id = '<affected_patient_uuid>'
  ORDER BY version DESC
  LIMIT 10;
"

# Look for the lost data -- which version had it?
psql $DB_PRIMARY_URL -c "
  SELECT version, snapshot->>'phone' AS phone,
         snapshot->'insurance'->'primary'->>'payer_name' AS insurance
  FROM patient_record_versions
  WHERE patient_id = '<affected_patient_uuid>'
  ORDER BY version;
"
```

**If data was overwritten without a conflict detection:**

This means the `WHERE version = $expected_version` clause is not being enforced. Check:

1. Is the version field being sent from the client in the PATCH request?
2. Is the server actually checking it in the SQL query?
3. Is PgBouncer in transaction mode? (Session mode could cause issues with prepared statements)

```bash
# Check PgBouncer mode
psql -h $PGBOUNCER_HOST -p 6432 -U pgbouncer pgbouncer -c "SHOW POOLS;"
# Verify pool_mode is 'transaction'
```

**Data recovery:** If data was lost, restore from version history:

```bash
# Find the version that had the correct data
psql $DB_PRIMARY_URL -c "
  SELECT version, snapshot
  FROM patient_record_versions
  WHERE patient_id = '<affected_patient_uuid>'
  ORDER BY version DESC;
"

# Restore the correct field values (manual -- adapt to the specific fields)
# IMPORTANT: Use the current version number to avoid creating another conflict
psql $DB_PRIMARY_URL -c "
  UPDATE patients
  SET
    phone = '<correct_phone>',
    version = version + 1,
    updated_at = NOW()
  WHERE id = '<affected_patient_uuid>'
    AND version = <current_version>;

  INSERT INTO patient_record_versions (patient_id, version, snapshot, changed_by_type, change_summary)
  VALUES (
    '<affected_patient_uuid>',
    <current_version + 1>,
    (SELECT row_to_json(p) FROM patients p WHERE id = '<affected_patient_uuid>'),
    'system',
    '{\"reason\": \"data recovery from concurrent edit data loss\"}'
  );

  INSERT INTO audit_log (entity_type, entity_id, action, actor_type, metadata)
  VALUES (
    'patient', '<affected_patient_uuid>', 'update', 'system',
    '{\"reason\": \"data recovery\", \"incident\": \"concurrent edit data loss\"}'
  );
"
```

---

## Monitoring

After any concurrent edit incident, watch these metrics for 24 hours:

```bash
# Version conflict rate
curl -s https://api.clinic-checkin.example.com/metrics | grep patient_version_conflict_total

# Patient record version growth (should be 1 increment per edit, not spikes)
psql $DB_REPLICA_URL -c "
  SELECT DATE_TRUNC('hour', created_at) AS hour, COUNT(*) AS version_changes
  FROM patient_record_versions
  WHERE created_at > NOW() - INTERVAL '24 hours'
  GROUP BY hour
  ORDER BY hour;
"
```

---

## Prevention

- The optimistic locking implementation (ADR-003) should prevent all silent data loss
- Conflict resolution UI should make it easy for staff to recover from conflicts
- If conflict rate is high during Monday 8-9 AM peak, consider:
  - Assigning patients to specific receptionists
  - Reducing the likelihood of two people editing the same patient (workflow change, not system change)
  - Exploring field-level locking in a future iteration (ADR-003 documents why this was deferred)
