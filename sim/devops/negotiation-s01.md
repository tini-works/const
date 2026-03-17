# DevOps Negotiation — Rounds 1-10

## Boxes Received from Engineering

### Round 1 (S-01)

| Box | Verdict | Operational Implications |
|-----|---------|------------------------|
| BOX-E1: No data loss on timeout | **Accepted** | Per-section persist means every patient tap is a DB write. Connection pool must be sized for burst writes during peak check-in hours. |
| BOX-E2: Token-scoped access | **Accepted with constraint** | Token must never appear in access logs. Log aggregation pipeline must scrub any field matching `access_token`. BOX-O4 deployed. |
| BOX-E3: Staged updates | **Accepted** | Finalization must be transactional. Confirmed via BOX-O1 and BOX-E9. |
| BOX-E4: Eventual consistency | **Accepted with monitoring** | <2s lag target. BOX-O2 reconciliation deployed. |
| BOX-E5: Concurrent prevention | **Accepted** | Database-enforced constraint. BOX-O3 secondary check deployed. |

### Round 6 (S-06)

| Box | Verdict | Operational Implications |
|-----|---------|------------------------|
| BOX-E6: Medication completion server-enforced | **Accepted** | No new infra. Monitoring added: `checkin.complete.medications_blocked` metric tracks 400 responses. |

### Round 7 (S-07)

| Box | Verdict | Operational Implications |
|-----|---------|------------------------|
| BOX-E9: Atomic finalization (single transaction) | **Accepted** | DB transaction isolation: READ COMMITTED minimum. Monitor transaction duration — long transactions under peak load can exhaust connection pool. `pg.transactions.finalize.duration_p99` alert at >500ms. |

### Round 8 (S-08)

| Box | Verdict | Operational Implications |
|-----|---------|------------------------|
| BOX-E7: OCR is async with timeout fallback | **Accepted with constraints** | 1. Cloud OCR provider must have signed HIPAA BAA. 2. Object Storage bucket must be encrypted (AES-256, KMS-managed). 3. Signed URLs for image access must have 5-min expiry. 4. OCR API key stored in Vault, rotated 90 days. 5. OCR queue depth monitored — HPA on OCR Service if queue > 10. |

### Round 10 (S-10)

| Box | Verdict | Operational Implications |
|-----|---------|------------------------|
| BOX-E8: Import is idempotent on source_id | **Accepted** | 1. Migration Service must handle restarts gracefully. 2. Monitor batch stuck detection (last_processed_age > 60s). 3. Import-staging environment created for pre-production validation. |

---

## Boxes I Own

### BOX-O1: Finalization is atomic

When `POST /api/checkins/{id}/finalize` is called:
- For each section: patient_data is updated or inserted
- Audit rows are created
- Session status is set to "finalized"
- Access token is invalidated
- Events are emitted

**If any step fails after patient_data is partially updated, data integrity is broken.**

**Requirement:** All patient_data mutations in finalization MUST execute within a single database transaction. Event emission happens AFTER the transaction commits.

**Status:** Matched. Engineer confirmed via BOX-E9.

**Verification:** Integration test that kills the service mid-finalization. Patient record must be entirely updated or entirely unchanged.

### BOX-O2: Search index drift is detectable

**Requirement:** Reconciliation process runs every 5 minutes:
1. Select 10 random patient IDs from PostgreSQL
2. Query the search API for each
3. If any missing: `search.index.drift` CRIT
4. If stale data (name mismatch): `search.index.stale` WARN

Additionally: monitor Redis Streams consumer lag for Search Service consumer group.

**Status:** Deployed. Reconciliation cron running. Alert routing confirmed.

### BOX-O3: Concurrent session invariant is verified

**Requirement:** Background check runs every minute:
```sql
SELECT patient_id, COUNT(*)
FROM checkin_sessions
WHERE status IN ('pending', 'in_progress', 'patient_complete')
GROUP BY patient_id
HAVING COUNT(*) > 1
```
If any rows: CRIT alert.

**Status:** Deployed. Zero violations since deployment.

### BOX-O4: Access token never appears in logs

**Requirement:**
1. API Gateway access logs: token portion masked in URIs
2. Application log pipeline: JSON fields `access_token`, `token`, `access_url` redacted
3. Error reporting: strip 64-char token patterns from stack traces
4. WebSocket connection logs: query params stripped

**Status:** Deployed. Daily log scan confirms zero token appearances.

### BOX-O5: Session cleanup runs reliably

**Requirement:**
1. Archive job hourly: sessions >24h with terminal status -> archive table
2. Purge job daily: archived sessions >90 days -> deleted
3. Monitor: `checkin.sessions.stale.count` WARN >10, CRIT >50

**Status:** Deployed. Cleanup running reliably.

### BOX-O6: Object Storage PHI access control (NEW — S-08)

Insurance card images and scanned paper records are PHI (BOX-31).

**Requirement:**
1. Bucket policy: no public access. Only OCR Service IAM role and Admin UI IAM role have read/write.
2. Server-side encryption: AES-256 with KMS-managed keys. Key rotation annually.
3. Access logging: all reads/writes to Object Storage logged to separate bucket.
4. Signed URLs: 5-minute expiry. Generated server-side only (no client-side signing).
5. Lifecycle: Standard -> IA at 90 days -> Archive at 1 year -> Delete at 7 years.
6. Versioning enabled (protects against accidental deletion).
7. Cross-region replication for disaster recovery.

**Status:** Provisioned. Access logging confirmed. Lifecycle policy applied.

**Verification:** Attempt direct bucket access without signed URL -> 403. Attempt access with expired signed URL -> 403. Attempt access from unauthorized IAM role -> 403.

### BOX-O7: Import does not degrade production (NEW — S-10)

S-10 import pipeline processes ~4,000 records. Each record triggers:
- Patient Service write (DB insert)
- `patient.imported` event on Redis Streams
- Search index entry (ES indexing)

At 10 records/second, this creates sustained load for ~7 minutes (4,000/10/60).

**Requirement:**
1. Import throttled at 10 records/second. Configurable.
2. Import pauses during peak hours (08:00-10:00 configurable).
3. Search latency during import must not exceed 500ms at p95 (double the normal target but still usable).
4. DB connection pool usage during import must not exceed 80% of primary pool.
5. Event bus consumer lag during import must not exceed 500 messages (WARN), 1000 (CRIT).
6. Import-staging environment validates all of the above before production import.

**Status:** Infrastructure provisioned. Load testing pending.

**Verification:**
- Run import on import-staging while simulating 30 concurrent check-in sessions.
- Measure search latency, session creation latency, section save latency during import.
- If any exceed thresholds: lower import rate until thresholds hold.

### BOX-O8: Multi-location infrastructure parity (NEW — S-05)

Multiple clinic locations share a single infrastructure deployment.

**Requirement:**
1. No location-specific infrastructure. All locations served by the same services, same DB, same index.
2. Adding a location is a configuration change (INSERT into `locations` table), NOT an infrastructure change.
3. Per-location monitoring: queue load, session count, connection count broken down by `location_id`.
4. No location-based network segmentation (patients from any location hit the same API gateway).
5. If one location's load spikes, it must not starve another location. HPA and connection pool sizing must account for aggregate load across all locations.

**Status:** Infrastructure confirmed single-deployment. Per-location metrics configured.

### BOX-O9: Peak load scaling strategy (NEW — S-09)

Monday morning rush: 30 concurrent check-ins per location, 60 aggregate across 2 locations.

**Requirement:**
1. HPA on Check-in Service: 2-4 instances. Trigger: CPU > 60% or active sessions > 25/instance.
2. HPA on WebSocket Server: 2-4 instances. Trigger: active connections > 150/instance.
3. PostgreSQL connection pool: 50 primary, 20 replica. At 60 concurrent sessions x ~2 ops/session, peak is ~120 ops. Pool of 70 with queuing handles bursts.
4. Read replica serves search queries during peak. Offloads primary for write-heavy check-in operations.
5. Cache layer (Redis DB 1) absorbs repeated patient summary reads. Hit rate > 70% during peak.
6. Scale-down delay: 10 minutes. Prevents flapping during the 1-2 hour Monday rush window.

**Scaling arithmetic:**
- 2 locations x 30 sessions x 2 connections/session (patient + receptionist) = 120 WebSocket connections. 2 instances at 60 each. HPA headroom for bursts.
- 60 concurrent sessions x 2 DB operations/session (section save + session update) = 120 peak DB ops/second. Each op < 10ms. 50-connection pool handles this with ~24% utilization per connection.
- Search during peak: 30 receptionists searching simultaneously. Read replica handles at < 200ms p95.

**Status:** HPA configured. Load testing in progress.

---

## Open Questions

### Resolved

1. **Finalization transaction scope** (BOX-O1): Confirmed by BOX-E9. Single DB transaction.
2. **Event bus guaranteed delivery** (Round 1): Confirmed S-02. At-least-once delivery via consumer groups. Unacknowledged messages re-delivered after 60s.
3. **WebSocket reconnection** (Round 1): Confirmed S-02. Exponential backoff (1s-30s), max 10 retries, then polling fallback.
4. **Graceful shutdown timing** (Round 1): Confirmed. 30-second termination grace period on Check-in Service pods.

### Open

1. **Audit retention archival strategy:** 7-year HIPAA retention (BOX-15) on `patient_data_audit`. At current scale (~50 audits/day x 365 x 7 = ~127,000 rows) this is manageable. With Riverside import creating ~4,000 additional audit rows (one-time) and multi-location doubling daily volume (~100 audits/day), 7-year table reaches ~250,000 rows. Still small. But if scale grows 10x, need partitioning by year. **Decision deferred until 50,000+ rows reached.**

2. **Import peak-hour window:** Currently set to 08:00-10:00. Is this the right window? Need receptionist input on when Monday rush actually peaks. Configurable, so can adjust without deploy.

3. **Object Storage region:** PHI images stored in Object Storage must comply with data residency requirements. Are there restrictions on which cloud regions can store PHI? Affects cross-region replication target.

---

## Constraints I'm Pushing to QA

| What | Why QA needs to verify |
|------|----------------------|
| BOX-O1 (atomic finalization) | Integration test: kill service mid-finalization, verify all-or-nothing |
| BOX-O2 (index drift detection) | Stop search consumer, verify drift alert fires within 10 min |
| BOX-O3 (concurrent session check) | Insert duplicate session via direct SQL, verify alert fires within 2 min |
| BOX-O4 (token scrubbing) | Create session, search logs for token value, verify zero matches |
| BOX-O5 (session cleanup) | Create session 25 hours ago, verify it's archived within 1 hour |
| BOX-O6 (PHI access control, S-08) | Attempt direct bucket access -> 403. Expired URL -> 403. Unauthorized role -> 403 |
| BOX-O7 (import non-degradation, S-10) | Run import during simulated peak. Verify search latency stays < 500ms |
| BOX-O8 (multi-location parity, S-05) | Create sessions at 2 locations. Verify cross-location concurrent prevention works |
| BOX-O9 (peak scaling, S-09) | Simulate 30 concurrent sessions. Verify HPA scales up. Verify no 503s, no session creation failures |
