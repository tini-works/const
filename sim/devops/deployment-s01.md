# Deployment — Rounds 1-10

How code reaches production. Every path from commit to running system, with rollback procedures.

---

## Pipeline

```
commit -> CI -> build -> test -> staging deploy -> staging verify -> prod deploy -> prod verify
```

### Stages

#### 1. CI (on every commit)

| Step | Timeout | Failure Action |
|------|---------|----------------|
| Lint | 2 min | Block merge |
| Unit tests | 5 min | Block merge |
| Integration tests (services against test DB) | 10 min | Block merge |
| Contract tests (API shape matches api.md) | 5 min | Block merge |
| Security scan (dependency CVEs) | 5 min | WARN on medium, block on high/critical |
| Container image build (all 7 services) | 8 min | Block merge |
| **HIPAA compliance scan (S-04)** | 3 min | Block merge. Checks: no PHI in logs, encryption config present, audit writes in finalization path |
| **OCR integration test (S-08)** | 5 min | Block merge. Uses mock OCR API. Tests upload -> process -> result pipeline |
| **Import pipeline test (S-10)** | 5 min | Block merge. Tests: parse, normalize, dedup, idempotency |

#### 2. Staging Deploy (on merge to main)

| Step | Timeout | Failure Action |
|------|---------|----------------|
| Deploy to staging namespace (all 7 services) | 8 min | Abort, notify |
| Run DB migrations (staging) | 5 min | Abort, notify. Migrations must be backward-compatible |
| Health check all services (7 services) | 3 min | Abort, roll back staging |
| E2E test suite (all 20 flows) | 25 min | Abort, roll back staging, notify |
| Search index reconciliation check | 2 min | WARN only |
| **Object Storage connectivity check (S-08)** | 1 min | Abort if PHI bucket inaccessible |
| **OCR API connectivity check (S-08)** | 1 min | WARN only (OCR fallback exists) |
| **SMS/email gateway connectivity (S-03)** | 1 min | WARN only |
| **Cache layer smoke test (S-09)** | 1 min | WARN only |

#### 3. Production Deploy (manual approval gate)

| Step | Timeout | Failure Action |
|------|---------|----------------|
| Approval from eng lead or on-call | - | Block until approved |
| **Check active import batch status (S-10)** | - | WARN if import in progress. Deploy allowed but Migration Service excluded from rolling update |
| Rolling update: API Gateway | 5 min | Auto-rollback on health check failure |
| Rolling update: Patient Service | 5 min | Auto-rollback |
| Rolling update: Check-in Service | 5 min | Auto-rollback |
| Rolling update: Search Service | 5 min | Auto-rollback |
| Rolling update: WebSocket Server | 5 min | Auto-rollback. Drain existing connections first |
| Rolling update: Notification Service | 3 min | Auto-rollback |
| Rolling update: OCR Service | 3 min | Auto-rollback |
| Rolling update: Migration Service | 3 min | Auto-rollback. **Only if no active batch** |
| Post-deploy health check (all 7 services) | 3 min | Auto-rollback all |
| Post-deploy E2E smoke test (Flows 1, 3, 4, 7, 12, 14) | 8 min | Auto-rollback all, notify |

---

## Service Deploy Order

Services can deploy independently unless a change spans multiple services. For cross-service changes:

```
1. Database migrations (always first, always backward-compatible)
2. Object Storage changes (bucket policies, lifecycle rules)
3. Patient Service (data provider)
4. Check-in Service (depends on Patient Service)
5. Search Service (depends on events from Patient Service)
6. OCR Service (depends on Check-in Service for callbacks)
7. Notification Service (depends on Check-in Service for session creation)
8. Migration Service (depends on Patient Service for imports)
9. WebSocket Server (depends on events from Check-in Service)
10. API Gateway (routes to all services)
```

Backward compatibility rule: the new version of any service must work with the previous version of every other service.

---

## Database Migrations

| Rule | Rationale |
|------|-----------|
| Always additive | New columns, new tables, new indexes. Never drop or rename in the same release |
| Column drops are a separate release | Release N: stop reading. Release N+1: drop column. Minimum 1 deploy cycle between |
| Migrations run before service deploy | Services must work with both old and new schema during rolling update |
| Rollback = forward migration | Never `DOWN` migrate in production |
| Test on staging with production-scale data | Lock-taking migrations must be benchmarked |

System-specific constraints:
- The `checkin_sessions` unique partial index (`patient_id WHERE status IN (...)`) is critical for BOX-E5 and BOX-26. Migrations must not alter this index.
- The `patient_data_audit` table is append-only. No migration should add UPDATE or DELETE grants.
- **S-07:** The `version` column on `checkin_sessions` must have a NOT NULL constraint and DEFAULT 1.
- **S-05:** The `locations` table is INSERT-only in normal operation. No migration should add DELETE capability to application credentials.
- **S-10:** The `import_batches` and `import_records` tables are temporary. Plan for their removal post-migration. But do NOT drop during migration — keep for audit trail.

---

## Rollback Procedures

### Application Rollback (per-service)

```
1. Identify the service and current failing version
2. kubectl rollout undo deployment/{service-name}
   OR: deploy the previous known-good image tag
3. Verify health endpoint returns 200
4. Run post-deploy smoke test for affected flows
5. Notify team with: what failed, what was rolled back, what flows are affected
```

Rollback time target: < 5 minutes from decision to rolled-back and verified.

### New Services Rollback

**OCR Service:** Rollback is safe. Photo uploads will fail but manual insurance entry fallback exists (BOX-D18). No data loss.

**Notification Service:** Rollback is safe. Pre-check-in links stop generating but kiosk check-in continues. No data loss.

**Migration Service:** Rollback pauses import. Resume after fix. Import is idempotent (BOX-E8) — restart from where it stopped.

### Database Rollback

Database changes are NOT rolled back by reverting the migration. Instead:

```
1. Deploy a NEW forward migration that reverses the schema change
2. Test on staging
3. Deploy to production
```

If data was corrupted:
```
1. Stop writes to affected table (circuit breaker at service level)
2. Point-in-time recovery from WAL backup to a recovery instance
3. Identify corrupted rows by comparing production vs. recovery
4. Apply surgical fixes via SQL script (reviewed by 2 engineers)
5. Re-enable writes
6. Run reconciliation check
```

### Search Index Rollback

The search index is derived. Full rebuild is the rollback:

```
1. Delete current index
2. Create new index with correct mapping
3. Replay all patient.* events (or full reindex from PostgreSQL)
4. Verify with reconciliation check (10 random patients)
```

Time estimate: ~1 minute per 10,000 patients. With Riverside import (~14,000 total patients), full reindex takes ~90 seconds.

### WebSocket Rollback

```
1. Roll back WebSocket Server deployment
2. All active connections drop (expected)
3. Clients auto-reconnect (exponential backoff, S-02)
4. If auto-reconnect fails: clients fall back to polling (S-02)
5. Active check-in sessions NOT affected (data in Check-in Service)
```

### Object Storage Rollback (S-08)

Object Storage changes (bucket policies, lifecycle rules) are applied via infrastructure-as-code (Terraform/Pulumi). Rollback = apply previous version of IaC.

Images already uploaded are not affected by rollback. In-flight OCR jobs may fail — they'll be retried on next OCR Service restart.

---

## Deploy Checklist (pre-production)

- [ ] All CI steps pass
- [ ] Staging E2E passes all 20 flows
- [ ] Database migration tested on staging with production-scale data
- [ ] No open CRIT alerts on production dashboards
- [ ] No active check-in sessions in "patient_complete" state awaiting finalization
- [ ] **No active import batch in progress (S-10) — or Migration Service excluded from deploy**
- [ ] On-call engineer identified and available
- [ ] Rollback plan confirmed (which version to roll back to, per service)
- [ ] **HIPAA compliance scan passed (S-04)**
- [ ] **OCR provider API key valid and BAA current (S-08)**

---

## Zero-Downtime Constraints

| Component | Zero-Downtime Strategy |
|-----------|----------------------|
| API Gateway | Rolling update. Health check gates. New pod ready before old pod terminates |
| Patient Service | Rolling update. Stateless. No drain needed |
| Check-in Service | Rolling update. In-flight requests complete before pod terminates (graceful shutdown, 30s). **S-09: HPA handles scaling during peak — deploy during off-peak preferred** |
| Search Service | Rolling update. Stateless |
| WebSocket Server | **Drain required.** Stop accepting new connections, wait for existing to close naturally or drain after 60s. Clients auto-reconnect (S-02) |
| Notification Service | Rolling update. In-flight SMS/email deliveries complete before shutdown (graceful, 30s) |
| OCR Service | Rolling update. In-flight OCR jobs are idempotent — will retry on new instance |
| Migration Service | **Not rolling.** Pause import batch before deploy. Resume after. Never deploy while batch is actively processing |
| PostgreSQL | Not deployed via CI/CD. Manual failover procedure. Replica promotion for planned maintenance |
| Elasticsearch | Rolling restart. One node at a time. Cluster stays green |
| Redis | Not deployed via CI/CD. Sentinel-managed failover |
| Object Storage | Managed. No deploy needed. Policy changes via IaC |
