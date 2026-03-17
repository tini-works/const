# DevOps Traceability — Rounds 1-10

Every box, where it lands in operational reality, and how I prove it runs.

---

## Box -> Operational Mapping

### Upstream Boxes (from PM, Design, Engineering)

| Box | Operational Concern | What Breaks It in Production | Detection |
|-----|--------------------|-----------------------------|-----------|
| BOX-01: Patient recognized | Search service must be up AND index must be current | ES cluster down, index drift, search consumer lag | `es.cluster.health`, `search.index.drift`, `redis.streams.consumer_lag` |
| BOX-02: No re-asking | Patient data must survive from visit to visit. DB must not lose data | PostgreSQL failure, backup failure, accidental deletion | `pg.replication.lag`, WAL backup verification, audit table integrity |
| BOX-03: Confirm not re-enter | Check-in session snapshot must correctly copy patient data | Snapshot logic bug, DB connection timeout during snapshot | `checkin.create.snapshot_failure`, `checkin.create.error_rate` |
| BOX-04: Recognition experience | Patient first_name must be in the session payload | Patient Service returning null names, API contract drift | Contract tests in CI, `checkin.section.action.error_rate` |
| BOX-05: 2s visibility (S-02) | WebSocket event delivery within 2s. Polling fallback within 10s | WebSocket down, event bus lag, server overload | `ws.event.delivery.latency_p99`, `ws.fallback.polling_activated` |
| BOX-06: No false success (S-02) | Section save must be acknowledged before UI shows checkmark | Network failure between client and server | `checkin.section.action.error_rate`, client telemetry |
| BOX-07: Fallback queue (S-02) | S5 queue works via REST even when WebSocket fails | API Gateway down (single point of failure for REST too) | `checkin.queue.error_rate`, API Gateway health |
| BOX-08: Mobile entry (S-03) | Pre-check-in link reachable from patient's phone | DNS, TLS, mobile browser compatibility | `precheckin.link.opened` rate, external uptime monitoring |
| BOX-09: Time window (S-03) | Link expires at appointment time. Opens 24h before | Clock drift between servers, timezone misconfiguration | NTP sync verification, `precheckin.verify.lockout_count` |
| BOX-11: Identity verification (S-03) | DOB verification with lockout | Brute force attempts, rate limiting bypass | `precheckin.verify.lockout_count`, WAF rate limiting |
| BOX-12: No PHI exposure (S-04) | Token invalidated at session end. Client purges state | Token invalidation failure, 410 not returned | `auth.token.post_invalidation_attempts` |
| BOX-13: Enforced clearing (S-04) | S0 loads from scratch with zero PHI | Client-side bug (DevOps can only verify server-side: token invalidation, 410 responses) | `auth.token.gone.count` |
| BOX-14: Encryption at rest (S-04) | All data stores encrypted. HIPAA compliant | Encryption disabled by config drift, key rotation failure | Weekly encryption config audit |
| BOX-15: 7-year audit retention (S-04) | Audit table not truncated. Backups cover 7 years | Backup expiry, storage cost leading to premature deletion | Backup retention verification, storage alerts |
| BOX-16: Minimum necessary (S-03) | Pre-check-in only exposes data needed for check-in | API returning excess data (DevOps: ensure API Gateway doesn't add headers leaking info) | Contract tests, API response size monitoring |
| BOX-19: Location-independent patients (S-05) | Single DB serves all locations. No location sharding | DB overload from multi-location aggregate load | Per-location monitoring, connection pool sizing |
| BOX-20: Works at any location (S-05) | Cross-location search, queue, concurrent prevention | Location routing misconfiguration | Cross-location E2E test in staging |
| BOX-21: Location is context (S-05) | Location is an attribute, not a boundary | Schema migration accidentally adds location to unique index | Schema drift detection, BOX-O3 (concurrent session check is location-independent) |
| BOX-22: Medications every visit (S-06) | Medications section always created. Server blocks completion without confirmation | Service bug (DevOps: monitor `checkin.complete.medications_blocked`) | `checkin.medications.confirmation_rate` |
| BOX-26: Airtight concurrent prevention (S-07) | DB unique partial index + optimistic locking on finalization | Index dropped by migration, connection pool exhaustion | BOX-O3 (invariant check), `db.constraint.unexpected_violation` |
| BOX-27: Conflict-safe finalization (S-07) | Version column prevents lost updates | Version not incremented, transaction isolation insufficient | `checkin.finalize.version_mismatch`, `checkin.finalize.conflict_rate` |
| BOX-29: Photo capture (S-08) | Object Storage accepts uploads. OCR processes them | S3 outage, OCR API outage | `ocr.upload.error_rate`, `ocr.external_api.error_rate` |
| BOX-30: OCR verification (S-08) | Extracted fields returned for patient review | OCR API returns garbage, timeout | `ocr.processing.success_rate`, `ocr.confidence.p50` |
| BOX-31: Card images are PHI (S-08) | Encrypted storage. Signed URL access only. 7-year retention | Encryption off, public access enabled, lifecycle policy removed | BOX-O6 verification, weekly access audit |
| BOX-32: 30 concurrent per location (S-09) | System handles 30 simultaneous check-in sessions per location | Connection pool exhaustion, HPA not scaling, DB locks | `checkin.sessions.active{location_id}`, HPA events, `pg.connections.utilization` |
| BOX-33: 60 aggregate (S-09) | System handles 60 sessions across 2 locations | Aggregate load exceeds infrastructure capacity | `checkin.sessions.active.aggregate`, scaling dashboard |
| BOX-34: Degradation visible to staff (S-09) | Queue shows load metrics when busy | Metrics endpoint fails under load (ironic) | Monitor the monitoring: queue API latency during load test |
| BOX-35: Patient loss measurable (S-09) | Abandonment tracking works | Session status tracking broken, archival too aggressive | `checkin.session.abandoned_during_peak` |
| BOX-36: Data importable (S-10) | Migration Service can ingest Riverside data | Source format parsing failure, network connectivity to source | `import.error_rate`, batch progress monitoring |
| BOX-37: Duplicates detected (S-10) | Dedup algorithm runs against full patient index | Search index incomplete at import time, ES lag | `import.dedup.processed_per_second`, reconciliation during import |
| BOX-38: Merge preserves data (S-10) | Merge creates audit trail. No data lost in merge | Merge transaction failure, audit write failure | `import.merge.audit_written`, `import.merge.success_rate` |
| BOX-39: Import non-degrading (S-10) | Production performance maintained during import | Import rate too high, event bus overwhelmed | BOX-O7 verification, `search.standard.latency_p99` during import |
| BOX-40: Post-import searchable (S-10) | Imported patients appear in search immediately | Search index rebuild lag, event bus backlog | `search.index.import_backlog`, reconciliation check post-import |
| BOX-D1: Graceful failure | Fuzzy search performs within SLA | ES analyzer misconfigured, cluster degraded | `search.fuzzy.latency_p99` |
| BOX-D2: Two actor views | Both WebSocket channels work simultaneously | WebSocket Server overloaded, connection limit hit | `ws.connections.active`, `ws.connections.per_instance` |
| BOX-D3: Partial data | Sections with null original_value correctly created | Migration removed nullable constraint, schema drift | Schema drift detection, CI contract tests |
| BOX-E1: No data loss on timeout | Per-section persist completes. Progress survives re-initiation | Section write latency exceeds window. DB pool exhausted | `checkin.section.action.latency_p99`, `pg.connections.utilization` |
| BOX-E2: Token-scoped access | Token never in logs. Token expires correctly | Log scrubbing fails. Session expiry cron broken | BOX-O4, BOX-O5 |
| BOX-E3: Staged updates | Finalization applies all changes atomically | Partial application on crash | BOX-O1 (atomic finalization), `checkin.finalize.apply_failure` |
| BOX-E4: Eventual consistency | Search reflects changes within 2s | Event bus down, consumer crashed, ES lag | `redis.streams.consumer_lag`, `search.index.lag_after_finalize`, BOX-O2 |
| BOX-E5: Concurrent prevention | DB constraint prevents duplicate active sessions | Constraint dropped by migration, pool exhaustion | BOX-O3, `db.constraint.unexpected_violation` |
| BOX-E6: Medication server-enforced | Complete check-in blocked without meds confirmation | Service bug | `checkin.complete.medications_blocked` |
| BOX-E7: OCR async with fallback | Upload returns 202, polling for result, 10s timeout | OCR API down, queue stuck | `ocr.processing.latency_p99`, `ocr.external_api.error_rate` |
| BOX-E8: Import idempotent | Re-import same source_id is no-op | Idempotency check bypassed, source_id collision | `import.error_rate`, re-import test in CI |
| BOX-E9: Atomic finalization | Single DB transaction for all finalization writes | Transaction isolation insufficient, long transaction locks | `pg.transactions.finalize.duration_p99` |

### My Boxes (operational)

| Box | Requirement | Proven When |
|-----|-------------|-------------|
| BOX-O1: Atomic finalization | Single DB transaction | Integration test: kill mid-finalization -> all-or-nothing. Production: `checkin.finalize.apply_failure` = 0 |
| BOX-O2: Index drift detection | Reconciliation every 5 min | Alert fires within 10 min of actual drift. Job uptime = 100% |
| BOX-O3: Concurrent session invariant | Background check every minute | Alert fires within 2 min of violation. Zero false negatives |
| BOX-O4: Token scrubbing | Tokens never in stored logs | Post-deploy log grep returns zero matches |
| BOX-O5: Session cleanup | Archive/purge on schedule | No non-terminal sessions older than 2 hours. Archive growth bounded |
| BOX-O6: PHI access control (S-08) | Object Storage locked down | Direct access -> 403. Expired URL -> 403. Unauthorized role -> 403 |
| BOX-O7: Import non-degradation (S-10) | Production stable during import | Search p95 < 500ms during import. DB pool < 80%. Event lag < 500 |
| BOX-O8: Multi-location parity (S-05) | Single deployment serves all locations | Adding location requires zero infrastructure changes |
| BOX-O9: Peak scaling (S-09) | System handles 60 concurrent sessions | HPA scales. No 503s. No session creation failures during load test |

---

## Flow -> Infra Dependency Chain

For each flow, what infrastructure components must be healthy for the flow to complete.

| Flow | Components Required | Single Point of Failure? |
|------|--------------------|-----------------------|
| Flow 1: Patient Lookup | API Gateway, Search Service, Elasticsearch, (Cache) | ES cluster (3 nodes, tolerates 1 failure) |
| Flow 2: Assisted Search | API Gateway, Search Service, Elasticsearch | Same as Flow 1 |
| Flow 3: Session Creation | API Gateway, Check-in Service, Patient Service, PostgreSQL, Redis, WebSocket Server | PostgreSQL primary |
| Flow 4: Section Confirm | API Gateway, Check-in Service, PostgreSQL, Redis, WebSocket Server | PostgreSQL primary |
| Flow 5: Medication Confirm | Same as Flow 4 | Same |
| Flow 6: Fill Missing | Same as Flow 4 | Same |
| Flow 7: Finalize | API Gateway, Check-in Service, Patient Service, PostgreSQL, Redis, Elasticsearch (async) | PostgreSQL primary |
| Flow 8: Timeout | Check-in Service (timer), WebSocket Server, Redis | WebSocket Server (warnings don't reach patient if WS down) |
| Flow 9: Concurrent Prevention | Check-in Service, PostgreSQL | PostgreSQL primary |
| Flow 10: WebSocket Failure | Check-in Service (polling), API Gateway | None (graceful degradation by design) |
| Flow 11: Screen Clearing | API Gateway (410 response) | None (client-side enforcement) |
| Flow 12: Mobile Pre-Check-In | API Gateway, Check-in Service, Notification Service, SMS/Email gateway, PostgreSQL | SMS gateway (external dependency) |
| Flow 13: Partial Pre-Check-In | Same as Flow 3 | PostgreSQL primary |
| Flow 14: Insurance Photo Upload | API Gateway, Check-in Service, OCR Service, Object Storage, Cloud OCR API | Cloud OCR API (external). Fallback: manual entry |
| Flow 15: Conflict Resolution | API Gateway, Check-in Service, Patient Service, PostgreSQL | PostgreSQL primary |
| Flow 16: Multi-Location Queue | API Gateway, Check-in Service, PostgreSQL | PostgreSQL primary |
| Flow 17: Import Pipeline | Migration Service, Patient Service, PostgreSQL, Redis, Elasticsearch | PostgreSQL primary. Import pauses on failure, resumes |
| Flow 18: Duplicate Review | Migration Service, Patient Service, PostgreSQL | PostgreSQL primary |
| Flow 19: Performance Under Load | All services, HPA, PostgreSQL (primary + replica), Cache | PostgreSQL primary (but replica handles reads) |
| Flow 20: Direct Edit | API Gateway, Patient Service, PostgreSQL, Redis, Elasticsearch (async) | PostgreSQL primary |

**PostgreSQL primary remains the single point of failure for all write flows.** Mitigation: replica with automated failover (< 30s). During failover, check-in section confirms will fail for ~30s. Client retry logic handles this (S-02: retry with exponential backoff).

**External dependencies (non-owned):**
- SMS/Email gateway (S-03): failure prevents pre-check-in link delivery. Kiosk check-in unaffected.
- Cloud OCR API (S-08): failure prevents insurance card OCR. Manual entry fallback exists.
- Appointment system (S-03): failure prevents automated link generation. Manual link generation by receptionist still works.

---

## Event Chain -> Monitoring Chain

Every event in Engineering's event chain maps to a monitoring signal.

```
patient.created / patient.updated
  -> [Monitor: redis.streams.consumer_lag for search-consumer]
  -> Search Service: rebuild index entry
     -> [Monitor: es.indexing.latency_p99]
  -> Cache: invalidate patient:{id}:summary
     -> [Monitor: redis.cache.invalidation_lag_ms]
  -> Audit Service: log change
     -> [Monitor: audit.write.failure]

patient.imported (S-10)
  -> [Monitor: redis.streams.consumer_lag{topic=import}]
  -> Search Service: index imported patient
     -> [Monitor: search.index.import_backlog]
  -> Audit Service: log import with provenance

patient.merged (S-10)
  -> [Monitor: import.merge.audit_written]
  -> Search Service: update merged patient
  -> Audit Service: log merge with source IDs

checkin.created
  -> [Monitor: ws.channel.open.success_rate]
  -> WebSocket Server: open channel for session

checkin.section.updated
  -> [Monitor: ws.event.delivery.latency_p99]
  -> WebSocket Server -> Receptionist UI: live section status

checkin.patient.complete
  -> [Monitor: ws.event.delivery.latency_p99]
  -> WebSocket Server -> Receptionist UI: enable "Complete Check-in"

checkin.finalized
  -> [Monitor: checkin.finalize.apply_failure]
  -> Patient Service: apply staged updates -> patient.updated (cascade)
     -> [Monitor: search.index.lag_after_finalize]
  -> WebSocket Server: close channel
  -> Access token invalidated

checkin.conflict (S-07)
  -> [Monitor: checkin.conflict.created_per_day]
  -> session_conflicts table: record conflict for review

checkin.expired (hard TTL)
  -> [Monitor: checkin.session.timeout_rate]
  -> WebSocket Server: notify both actors, close channel
  -> Staged data preserved
     -> [Monitor: checkin.reinitiate.sections_preserved]

ocr.completed / ocr.failed (S-08)
  -> [Monitor: ocr.processing.success_rate]
  -> Check-in Service: update document_uploads.ocr_status
  -> WebSocket -> Patient: OCR result ready

import.batch.progress (S-10)
  -> [Monitor: import.batch.last_processed_age_seconds]
  -> Admin UI: progress update
```

Every arrow has a monitor. If an arrow breaks, an alert fires.

---

## What "Proven" Means for DevOps (Rounds 1-10)

Per CONST.md, my inventory is proven when:

1. **Every deployment path is reproducible** — CI/CD pipeline is defined, deterministic, tested. 7 services, each with its own deploy. Pipeline runs green on staging before production. Proven by: pipeline runs on staging.

2. **Environments match what QA needs for proof** — Staging has right data volume (10K patients, 4K import records), right schema, right configuration. All 20 flows' tests run on staging. HPA enabled. Cache layer enabled. Object Storage real. Proven by: weekly parity checks, E2E suite passes.

3. **Observability covers every flow in Engineering's inventory** — All 20 flows have monitoring. Every silent failure mode is detectable. 7 dashboards cover all dimensions. Proven by: chaos testing (kill each component, verify alert fires within SLA).

4. **Operational incidents can be traced back to a broken match** — When an alert fires, the traceability table maps it to a box. "Search latency spike" traces to BOX-01. "Finalization failure" traces to BOX-E3/BOX-O1. "Import degrading production" traces to BOX-39/BOX-O7. Proven by: the mapping table above.

5. **HIPAA compliance at infrastructure level** — Encryption at rest for all data stores (BOX-14). PHI images access-controlled (BOX-O6). 7-year audit retention (BOX-15). Network segmentation. VPC flow logs. BAA with cloud OCR provider (BOX-E7). Proven by: weekly compliance audit, encryption config checks.

6. **Peak load handling is proven, not assumed** — HPA config validated under simulated peak (BOX-O9). Connection pool sizing validated. Cache effectiveness measured. Scaling arithmetic documented and tested. Proven by: load test results.

7. **Migration infrastructure is safe** — Import-staging environment validates Riverside data before production. Import throttling prevents production degradation (BOX-O7). Dedup tested at production scale. Import is idempotent (BOX-E8). Proven by: import-staging dry run with production-scale data.
