# Scaling Strategy — S-09 Performance, S-10 Migration

Dedicated document for peak load handling and migration infrastructure. The scope grew beyond what fits in infrastructure.md.

---

## The Problem

**Monday morning rush:** 30 concurrent check-ins per location. With 2 locations (Main + Riverside, S-05/S-10), that's 60 aggregate. System froze at ~15 concurrent in current deployment. Patients walked out (S-09, BOX-35).

**Riverside acquisition:** 4,000 patient records imported while the clinic is operational. Import must not degrade production (S-10, BOX-39).

These compound: post-acquisition, the patient base grows by ~40%. Search index is larger. Monday rush hits harder because both locations are busy simultaneously.

---

## Scaling Architecture

### Horizontal Scaling (stateless services)

```
                         Load Balancer
                              |
              +---------------+---------------+
              |               |               |
         API Gateway     API Gateway     (HPA: 2 fixed)
              |               |
     +--------+--------+-----+-----+
     |        |        |           |
  Check-in  Check-in  Check-in  Check-in    (HPA: 2-4)
  Service   Service   Service   Service
     |        |        |           |
     +--------+--------+-----------+
              |
     +--------+--------+
     |                  |
  WebSocket          WebSocket              (HPA: 2-4)
  Server             Server
```

**Check-in Service HPA:**
- Min: 2 instances (always available)
- Max: 4 instances (peak capacity)
- Scale-up trigger: CPU > 60% sustained 30s OR custom metric `checkin.sessions.active > 25` per instance
- Scale-down trigger: CPU < 30% sustained 10 minutes
- Scale-down delay: 10 minutes (prevents flapping during the 1-2 hour Monday rush)
- Pod disruption budget: max 1 unavailable (always 1+ instance running)

**WebSocket Server HPA:**
- Min: 2 instances
- Max: 4 instances
- Scale-up trigger: custom metric `ws.connections.active > 150` per instance
- Scale-down trigger: `ws.connections.active < 50` per instance sustained 10 minutes
- Scale-down delay: 10 minutes (connection draining)
- Sticky sessions: by session ID (not IP — multiple receptionists share IP behind NAT)
- Pod disruption budget: max 1 unavailable

**OCR Service HPA:**
- Min: 1 instance
- Max: 2 instances
- Scale-up trigger: custom metric `ocr.queue.depth > 10`
- Scale-down delay: 5 minutes

### Vertical Scaling (stateful services)

PostgreSQL, Elasticsearch, and Redis are scaled vertically (bigger instances) not horizontally. Horizontal scaling of stateful services adds operational complexity (sharding, split-brain) that is not justified at this patient volume.

**When to reconsider:** If patient count exceeds 50,000 or concurrent sessions exceed 100, revisit PostgreSQL read replica count and Elasticsearch node count.

---

## Connection Pool Math

### PostgreSQL Primary (50 connections)

```
Consumers of primary pool:
  Check-in Service (2-4 instances x ~8 connections each)  = 16-32
  Patient Service (2 instances x ~5 connections each)      = 10
  Search Service (0 — uses replica)                        = 0
  Migration Service (1 instance x ~5 connections)          = 5
  Notification Service (1 instance x ~2 connections)       = 2
  OCR Service (1-2 instances x ~2 connections each)        = 2-4
  Session cleanup cron                                     = 1
  BOX-O3 invariant check cron                              = 1
                                                   Total: 37-55

Peak scenario: 4 Check-in instances + Migration active = 55 connections.
Pool of 50 is tight. Migration Service must be paused during peak hours
OR pool increased to 60.
```

**Decision:** Pool stays at 50. Import pauses during peak hours (08:00-10:00). This is already configured via `IMPORT_PAUSE_DURING_PEAK`. The 55-connection scenario cannot happen because import and peak are mutually exclusive.

### PostgreSQL Read Replica (20 connections)

```
Consumers of replica pool:
  Search Service (2 instances x ~5 connections each)       = 10
  Queue queries (read path via Check-in Service)           = 4
  Admin UI read queries                                    = 2
                                                   Total: 16
```

Headroom: 4 connections. Sufficient for current scale.

### Redis (20 connections)

```
Consumers:
  Event publishing (all services)                          = 7
  Event consuming (Search, WebSocket, Audit, Migration)    = 4
  Cache reads/writes                                       = 4
  Stream consumer groups                                   = 3
                                                   Total: 18
```

Headroom: 2. Low contention — Redis operations are sub-millisecond.

---

## Peak Load Scenarios

### Scenario 1: Monday Morning Rush (S-09)

**Profile:** 08:00-10:00, 30 concurrent sessions per location, 60 aggregate.

```
Timeline:
  07:55  HPA at min (2 Check-in, 2 WebSocket)
  08:00  Sessions start climbing. ~5 new sessions/minute.
  08:05  Active sessions > 10. S5 queue shows "Busy" state.
  08:10  Active sessions > 25/instance. HPA triggers scale-up.
  08:12  3rd Check-in Service instance ready. Traffic rebalanced.
  08:15  Active sessions > 25/instance again. HPA triggers 4th instance.
  08:17  4th instance ready. Peak capacity reached.
  08:20  30 sessions/location. System stable at 4 Check-in + 3 WebSocket instances.
  09:00  Sessions start declining as patients complete.
  09:30  Active sessions < 25/instance. Scale-down timer starts (10 min).
  09:40  Scale-down deferred — still > 15 sessions.
  10:00  Rush ends. Sessions < 10/instance.
  10:10  HPA scales down to 2 Check-in, 2 WebSocket.
```

**Performance targets during peak:**
| Metric | Normal | Peak Target | Breach Action |
|--------|--------|------------|---------------|
| Search p95 | < 200ms | < 500ms | Read replica absorbs. If breach: investigate cache miss rate |
| Section save p95 | < 100ms | < 500ms | If breach: connection pool contention. Check `pg.connections.utilization` |
| Session creation p95 | < 300ms | < 1000ms | If breach: HPA not scaling fast enough. Increase min replicas |
| Finalization p95 | < 500ms | < 2000ms | If breach: transaction duration too long. Check dead locks |
| WebSocket delivery p95 | < 500ms | < 2000ms | Acceptable degradation. Polling fallback available |
| Abandonment rate | < 5% | < 10% | If breach: capacity issue. Patients leaving due to perceived slowness |

### Scenario 2: Monday Rush + Import Running

**This must not happen.** Import pauses during peak hours.

If someone manually overrides the pause:
- Import at 10/second adds ~20 DB writes/second (10 inserts + 10 dedup queries)
- Combined with 60 concurrent sessions: connection pool will exhaust
- Search index backlog will grow (import events + check-in events competing)
- Alert: `pg.connections.primary.utilization > 90%` CRIT
- Auto-response: Migration Service circuit breaker — if connection pool > 80%, pause import automatically

### Scenario 3: Riverside Import (S-10, nominal)

**Profile:** Off-peak hours. No concurrent check-in load. 4,000 records at 10/second.

```
Timeline:
  Duration: 4,000 records / 10 per second = 400 seconds ≈ 7 minutes

  Each record:
    1. Parse + normalize: ~5ms (CPU)
    2. Dedup query against search index: ~50ms (ES query)
    3. If importing: Patient Service write: ~20ms (DB insert)
    4. Event emission: ~1ms (Redis publish)
    5. Search index update: ~100ms (async, ES indexing)

  Total per record: ~75ms synchronous + 100ms async
  At 10/second: sustainable. Migration Service CPU ~50%. Single instance sufficient.

  DB impact:
    10 inserts/second to patients table
    10 inserts/second to patient_data (potentially 40/second with 4 categories each)
    10 inserts/second to patient_data_audit
    Peak: ~60 writes/second. Connection pool can handle.

  Search index impact:
    10 new documents/second into ES
    ES indexing is near-real-time by default (refresh_interval=1s)
    At 10/second for 7 minutes: 4,000 additional documents
    Index size grows from ~10,000 to ~14,000. Negligible impact on search performance.

  Event bus impact:
    10 patient.imported events/second
    Search consumer processes ~10/second (within capacity)
    Consumer lag should stay < 50 during import
```

**Post-import verification checklist:**
- [ ] All 4,000 records in `import_records` with status: `imported` or `duplicate_flagged`
- [ ] `import_batches.errors` < 1% (< 40 records)
- [ ] Search reconciliation: pick 50 random imported patients, verify searchable
- [ ] Search latency unchanged from pre-import baseline
- [ ] No orphan records (imported to patients but missing from import_records)

### Scenario 4: Post-Acquisition Steady State

**Profile:** 2 locations, ~14,000 total patients, ~100 check-ins/day aggregate.

```
Infrastructure sizing:
  PostgreSQL: 14,000 patients x 4 categories = 56,000 patient_data rows
    + ~3,500 audits/year (growing) = manageable on current instance

  Elasticsearch: 14,000 documents. Search latency impact: negligible.
    Prefix search on 14K is <50ms. Fuzzy search <200ms.

  Redis: Event volume ~100 check-in events/day. Cache entries: ~14,000 patient summaries (5-min TTL).
    Memory: ~14,000 x ~1KB = ~14MB for cache. Well within 1Gi.

  Object Storage: If 20% of check-ins use photo upload = ~20 images/day
    x 2 images (front+back) x ~3MB each = ~120MB/day = ~44GB/year
    7-year lifecycle: ~300GB total. Negligible cost.
```

No infrastructure scaling needed for steady-state post-acquisition. The Monday rush remains the bottleneck, and HPA handles it.

---

## Migration Infrastructure (S-10)

### Import-Staging Environment

**Purpose:** Validate Riverside data import before touching production.

**What it runs:**
- Patient Service (for receiving imports)
- Search Service (for dedup queries)
- Migration Service (for import pipeline)
- PostgreSQL (copy of production data)
- Elasticsearch (copy of production index)
- Redis (for events)

**What it does NOT run:**
- Check-in Service (not needed for import)
- WebSocket Server (not needed)
- Notification Service (not needed)
- OCR Service (not needed)
- API Gateway (internal access only)

**Data setup:**
1. Take production PostgreSQL snapshot
2. Anonymize per standard rules
3. Restore to import-staging instance
4. Rebuild ES index from anonymized data
5. Load Riverside source data (CSV/HL7)
6. Run import pipeline
7. Validate results

**Validation criteria before production import:**
- [ ] Error rate < 1%
- [ ] Dedup precision: 0 false auto-imports (all 0% confidence are genuinely new patients)
- [ ] Dedup recall: planted duplicates detected at correct confidence tiers
- [ ] Import duration within expected window (< 10 minutes at 10/second)
- [ ] Search latency unchanged after import
- [ ] Data categories populated correctly (address, insurance, medications mapped)

### Riverside Source Data Handling

**Data sources:**
1. **EHR export (3,200 records):** CSV or HL7 format from Riverside's electronic health records system.
   - Received via secure file transfer (SFTP) to a staging area.
   - Staging area is encrypted storage, not accessible to application services.
   - Migration Service reads from staging area, processes, writes to Patient Service.
   - After successful import: source file archived (not deleted) for audit. Retained 1 year.

2. **Paper records (800 records):** Scanned documents + manual data entry via S13.
   - Scanned PDFs uploaded to Object Storage (phi-documents bucket).
   - Manual entry via Admin UI -> `POST /api/admin/import/paper-entry`.
   - Paper entry is slow (~5 minutes per record for careful data entry).
   - Paper records may span multiple sessions (admin enters 50, takes a break, continues later).
   - Batch tracking via `import_batches` with `source_system: "riverside_paper"`.

**Source data security:**
- Riverside EHR export contains PHI. Must be encrypted in transit (SFTP) and at rest (encrypted staging area).
- Access to staging area restricted to Migration Service IAM role and admin operators.
- Source data deleted from staging area 30 days after successful import and verification.
- Audit trail records: who received the data, when it was processed, disposition of every record.

### Import Operational Runbook

```
PRE-IMPORT:
1. Verify import-staging validation passed all criteria
2. Schedule import for off-peak window (early morning or weekend)
3. Notify team: #ops-migration channel
4. Take production PostgreSQL backup (safety net)
5. Verify no active import batches

IMPORT EXECUTION:
1. Upload Riverside source data to staging area
2. Create import batch: POST /api/admin/import/batches
3. Monitor S10 dashboard for progress
4. Watch: import throughput, error rate, search latency, DB pool utilization
5. If search latency > 500ms: pause import, investigate
6. If error rate > 5%: pause import, review errors, fix source data

POST-IMPORT:
1. Run reconciliation: 50 random imported patients searchable
2. Verify import_batches.status = "completed"
3. Count patients: should be ~14,000 total
4. Run search performance benchmark
5. Notify team: import complete
6. Begin duplicate review (S11 queue)

DUPLICATE REVIEW (ongoing, 1-2 weeks):
1. Admin works through S11 queue daily
2. High confidence (>90%): quick review, merge or dismiss
3. Medium confidence (60-90%): careful comparison
4. Low confidence (<60%): likely different people, quick dismiss
5. Track: pending count should decrease daily
6. Alert if pending count stops decreasing (admin stopped working queue)

POST-MIGRATION CLEANUP (after all duplicates resolved):
1. Archive import source data (keep 1 year for audit)
2. Migration Service can be scaled down to 0 (but keep deployment for potential future acquisitions)
3. Import-staging environment can be torn down
4. Remove import-specific alert thresholds (restore normal alert sensitivity)
```

---

## HIPAA Compliance at Infrastructure Level

### Encryption

| Layer | Mechanism | Key Management |
|-------|-----------|---------------|
| Data in transit (client -> LB) | TLS 1.3 | Cloud-managed certificates (auto-renewal) |
| Data in transit (internal) | mTLS (service mesh) | Service mesh CA |
| Data in transit (services -> DB) | TLS | DB-managed certificates |
| Data at rest (PostgreSQL) | AES-256 | KMS-managed. Auto-rotation 365 days |
| Data at rest (Elasticsearch) | AES-256 | Node-level encryption |
| Data at rest (Redis AOF) | Volume encryption | KMS-managed |
| Data at rest (Object Storage) | AES-256 (SSE-KMS) | KMS-managed. Auto-rotation 365 days |
| Backups | Encrypted (same key as source) | KMS-managed |

### Access Control

| Resource | Who Can Access | How Enforced |
|----------|---------------|-------------|
| PostgreSQL primary | Patient Service, Check-in Service, Migration Service, Notification Service | DB user per service. Per-schema grants. Audit table: INSERT only |
| PostgreSQL replica | Search Service, Check-in Service (reads) | Read-only DB user |
| Elasticsearch | Search Service | API key. Read/write for indexing, read for searching |
| Redis | All services (events), Search/Check-in/Patient (cache) | Password auth. Network ACL |
| Object Storage | OCR Service (read/write), Admin UI (read via signed URL) | IAM role. Bucket policy. No public access |
| Cloud OCR API | OCR Service | API key in Vault |
| SMS/Email | Notification Service | API key in Vault |

### Audit & Logging

| What | Where | Retention |
|------|-------|-----------|
| API access logs (tokens masked) | Log aggregation (CloudWatch/ELK) | 90 days |
| Application logs | Log aggregation | 90 days |
| DB audit trail (patient_data_audit) | PostgreSQL + backups | 7 years |
| Object Storage access logs | Separate log bucket | 90 days |
| VPC flow logs | CloudWatch | 90 days |
| Secret access logs (Vault audit) | Vault audit backend | 1 year |
| Infrastructure change logs (IaC) | Git history + cloud trail | Indefinite |

### Compliance Verification

| Check | Frequency | Automated |
|-------|-----------|-----------|
| Encryption at rest enabled on all stores | Weekly | Yes (CI step, S-04) |
| No public access on Object Storage | Weekly | Yes |
| DB users have least-privilege grants | Monthly | Partially (script compares grants against expected) |
| Log scrubbing effective (BOX-O4) | Daily | Yes (log scan for token patterns) |
| Backup restoration test | Quarterly | Manual |
| BAA with cloud OCR provider current | Annually | Manual check |
| KMS key rotation occurred | Annually | Yes (KMS reports) |
