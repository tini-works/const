# Observability — Rounds 1-10

Every engineering flow must be detectable when it breaks in production. 20 flows, 7 services, 4 data stores. This document maps each to production signals.

## Principle

Observability answers one question per flow: **"Is this flow completing successfully for real users right now?"**

Not "is the service up." Services can be up while flows are silently broken.

---

## Flow-Level Monitoring

### Flow 1: Patient Lookup

**What proves it works:** Receptionist types, results appear in <200ms.

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Search latency | `search.standard.latency_p99` | API Gateway / Search Service | WARN >200ms, CRIT >500ms |
| Search error rate | `search.standard.error_rate` | API Gateway | WARN >1%, CRIT >5% |
| Search zero-result rate | `search.standard.zero_result_rate` | Search Service | WARN >50% over 15 min (indicates broken index) |
| Search request volume | `search.standard.requests_per_min` | API Gateway | CRIT if 0 for 10 min during business hours |

**Reconciliation check (cron, every 5 min):** Pick 10 random patient IDs from PostgreSQL. Search for each by name via the search API. If any are missing: `search.index.drift` CRIT.

---

### Flow 2: Assisted Search (Fuzzy)

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Fuzzy search latency | `search.fuzzy.latency_p99` | Search Service | WARN >500ms, CRIT >1000ms |
| Fuzzy search usage | `search.fuzzy.requests_per_day` | API Gateway | Info only |

---

### Flow 3: Check-in Session Creation

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Session creation latency | `checkin.create.latency_p99` | Check-in Service | WARN >300ms, CRIT >1000ms |
| Session creation errors | `checkin.create.error_rate` | Check-in Service | WARN >1%, CRIT >5% |
| Snapshot failure | `checkin.create.snapshot_failure` | Check-in Service | CRIT >0 |
| WebSocket channel open rate | `ws.channel.open.success_rate` | WebSocket Server | CRIT <95% |
| 409 Conflict rate | `checkin.create.conflict_rate` | Check-in Service | Info |

---

### Flow 4: Patient Confirms a Section

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Section action latency | `checkin.section.action.latency_p99` | Check-in Service | WARN >200ms, CRIT >500ms |
| Section action error rate | `checkin.section.action.error_rate` | Check-in Service | CRIT >1% |
| WebSocket delivery latency | `ws.event.delivery.latency_p99` | WebSocket Server | WARN >500ms, CRIT >2000ms |
| WebSocket delivery failures | `ws.event.delivery.failures` | WebSocket Server | CRIT >0 per session |

---

### Flow 5: Medication Confirmation (S-06)

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Medication section action latency | `checkin.section.medications.latency_p99` | Check-in Service | WARN >300ms, CRIT >500ms |
| Medication validation failures | `checkin.medications.validation_failure` | Check-in Service | WARN >5% (list mismatch between submitted and server state) |
| Medication completions vs. check-ins | `checkin.medications.confirmation_rate` | Check-in Service | WARN <90% (should be ~100% since server-enforced) |
| Completion blocked by medications | `checkin.complete.medications_blocked` | Check-in Service | Info — count of 400 responses when medications not confirmed |

**Silent failure mode:** Patient edits medications, server accepts, but audit row not created. Compliance risk (BOX-24). Detected by: medication section updates without matching audit entries.

---

### Flow 6: Patient Fills Missing Data

Same metrics as Flow 4. Additional:

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Fill validation failure rate | `checkin.section.fill.validation_error_rate` | Check-in Service | WARN >10% (schema mismatch suggests UI/API drift) |

---

### Flow 7: Completion and Finalization

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Patient completion rate | `checkin.patient_complete.rate` | Check-in Service | Info |
| Finalization latency | `checkin.finalize.latency_p99` | Check-in Service | WARN >500ms, CRIT >2000ms |
| Finalization error rate | `checkin.finalize.error_rate` | Check-in Service | CRIT >0% |
| Staged data application failures | `checkin.finalize.apply_failure` | Patient Service | CRIT >0 (BOX-E1 violated) |
| Audit write failure | `audit.write.failure` | Patient Service | CRIT >0 (compliance) |
| Search index update lag post-finalize | `search.index.lag_after_finalize` | Search Service | WARN >2s, CRIT >5s |
| **Version mismatch rate (S-07)** | `checkin.finalize.version_mismatch` | Check-in Service | Info — count of 412 responses |
| **Finalization conflict rate (S-07)** | `checkin.finalize.conflict_rate` | Check-in Service | WARN >0 per day (should be extremely rare) |

---

### Flow 8: Timeout and Recovery

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Timeout warning delivery | `ws.timeout_warning.delivered` | WebSocket Server | CRIT if 0 for a day with active sessions |
| Session timeout rate | `checkin.session.timeout_rate` | Check-in Service | Info |
| Re-initiation success rate | `checkin.reinitiate.success_rate` | Check-in Service | CRIT <95% |
| Progress preservation on reinitiate | `checkin.reinitiate.sections_preserved` | Check-in Service | CRIT — if any confirmed section becomes pending |

---

### Flow 9: Concurrent Check-in Prevention

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Concurrent prevention effectiveness | `checkin.concurrent.prevented` | Check-in Service | Info |
| DB constraint violations (unexpected) | `db.constraint.unexpected_violation` | Check-in Service | CRIT >0 |
| **Cross-location prevention (S-05)** | `checkin.concurrent.cross_location` | Check-in Service | Info — count blocked at different location |

---

### Flow 10: WebSocket Failure and Fallback (S-02)

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Heartbeat miss rate | `ws.heartbeat.miss_rate` | WebSocket Server | WARN >5%, CRIT >15% |
| Auto-reconnect attempts | `ws.reconnect.attempts_per_min` | Client telemetry | WARN >10 per min aggregate |
| Fallback to polling activations | `ws.fallback.polling_activated` | Client telemetry | WARN >0 (every activation means WebSocket fully failed) |
| Polling response latency | `checkin.poll.latency_p99` | Check-in Service | WARN >500ms, CRIT >2000ms |

---

### Flow 11: Screen Clearing (S-04)

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Token invalidation latency | `auth.token.invalidation.latency_p99` | API Gateway | WARN >100ms |
| 410 Gone responses to invalidated tokens | `auth.token.gone.count` | API Gateway | Info — expected behavior |
| Requests after token invalidation | `auth.token.post_invalidation_attempts` | API Gateway | WARN >0 (means client didn't purge or attacker probing) |

---

### Flow 12: Mobile Pre-Check-In (S-03)

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Pre-check-in link generation rate | `precheckin.link.generated_per_day` | Notification Service | Info |
| SMS/email delivery rate | `precheckin.delivery.success_rate` | Notification Service | WARN <95% |
| SMS/email delivery latency | `precheckin.delivery.latency_p99` | Notification Service | WARN >30s |
| Link open rate | `precheckin.link.opened` / `precheckin.link.sent` | Notification Service | Info — adoption metric |
| Identity verification success rate | `precheckin.verify.success_rate` | Check-in Service | Info |
| Identity verification lockouts | `precheckin.verify.lockout_count` | Check-in Service | WARN >5/day (potential brute force or UX issue) |
| Pre-check-in completion rate | `precheckin.completion_rate` | Check-in Service | Info — sessions that reach patient_complete |

**Silent failure mode:** Notification Service generates links but SMS gateway is down. Links never reach patients. Detected by: delivery success rate drop.

---

### Flow 13: Partial Pre-Check-In -> Kiosk Completion (S-03)

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Partial pre-check-in carry-over rate | `precheckin.partial.carried_over` | Check-in Service | Info |
| Section preservation on kiosk handoff | `precheckin.partial.sections_preserved` | Check-in Service | CRIT if any confirmed section lost |

---

### Flow 14: Insurance Photo Upload (S-08)

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Photo upload latency | `ocr.upload.latency_p99` | API Gateway | WARN >2s, CRIT >5s |
| Photo upload error rate | `ocr.upload.error_rate` | API Gateway | WARN >5%, CRIT >10% |
| OCR processing latency | `ocr.processing.latency_p99` | OCR Service | WARN >5s, CRIT >10s |
| OCR success rate | `ocr.processing.success_rate` | OCR Service | WARN <80% |
| OCR confidence score distribution | `ocr.confidence.p50` | OCR Service | Info — track over time |
| Cloud OCR API error rate | `ocr.external_api.error_rate` | OCR Service | CRIT >5% (provider issue) |
| Cloud OCR API latency | `ocr.external_api.latency_p99` | OCR Service | WARN >3s, CRIT >8s |
| Object Storage upload latency | `storage.upload.latency_p99` | OCR Service | WARN >1s, CRIT >3s |
| Manual fallback rate | `ocr.fallback.manual_entry_rate` | Check-in Service | Info — high rate may indicate OCR quality issue |

**Silent failure mode:** Image uploads succeed to Object Storage but OCR never processes them. Upload receipt returned but polling shows "processing" indefinitely. Detected by: OCR jobs stuck in "processing" > 30 seconds.

---

### Flow 15: Concurrent Finalization Conflict Resolution (S-07)

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Conflict creation rate | `checkin.conflict.created_per_day` | Check-in Service | WARN >0 (should be extremely rare) |
| Conflict resolution latency | `checkin.conflict.resolution_latency_hours` | Check-in Service | WARN >4 hours |
| Unresolved conflicts age | `checkin.conflict.unresolved.oldest_hours` | Check-in Service | CRIT >24 hours |

---

### Flow 16: Multi-Location Queue Management (S-05)

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Queue load per location | `checkin.queue.active_count{location_id}` | Check-in Service | WARN >20, CRIT >30 per location |
| Cross-location query latency | `checkin.queue.cross_location.latency_p99` | Check-in Service | WARN >500ms |

---

### Flow 17: Import Pipeline (S-10)

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Import throughput | `import.records_per_second` | Migration Service | Info — target: 10/s |
| Import error rate | `import.error_rate` | Migration Service | WARN >1%, CRIT >5% |
| Import progress | `import.batch.progress_pct` | Migration Service | Info |
| Dedup processing rate | `import.dedup.processed_per_second` | Migration Service | Info |
| Duplicates flagged rate | `import.dedup.flagged_rate` | Migration Service | Info — expect ~2-5% of records |
| Batch stuck detection | `import.batch.last_processed_age_seconds` | Migration Service | WARN >60s, CRIT >300s (batch stalled) |
| Search index backlog during import | `search.index.import_backlog` | Search Service | WARN >100, CRIT >500 |
| Production query latency during import | `search.standard.latency_p99` (during import window) | Search Service | CRIT >500ms (BOX-39: import must not degrade production) |

**Silent failure mode:** Migration Service crashes mid-batch. Batch stays in "in_progress" forever. Detected by: batch stuck detection. Mitigation: import is idempotent (BOX-E8), restart resumes from last processed.

---

### Flow 18: Duplicate Review and Merge (S-10)

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Pending duplicates queue depth | `import.duplicates.pending_count` | Migration Service | Info — track for staffing |
| Merge success rate | `import.merge.success_rate` | Patient Service | CRIT <95% |
| Merge audit trail completeness | `import.merge.audit_written` | Patient Service | CRIT if merge happens without audit |

---

### Flow 19: Performance Under Load (S-09)

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Concurrent active sessions (aggregate) | `checkin.sessions.active.aggregate` | Check-in Service | WARN >40, CRIT >55 (approaching 60 limit) |
| Concurrent active sessions (per location) | `checkin.sessions.active{location_id}` | Check-in Service | WARN >25, CRIT >30 per location |
| Session creation p99 during peak | `checkin.create.latency_p99` during peak window | Check-in Service | CRIT >2000ms (S-09) |
| Abandonment rate during peak | `checkin.session.abandoned_during_peak` | Check-in Service | WARN >10% (BOX-35) |
| Cache hit rate | `cache.hit_rate` | Redis | WARN <70% during peak (cache not helping) |
| HPA scaling events | `hpa.scale_up.count{service}` | Kubernetes | Info — track for capacity planning |
| DB connection pool utilization during peak | `pg.connections.utilization` during peak window | Connection pool | CRIT >90% |

---

### Flow 20: Receptionist Direct Edit

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Direct edit latency | `patient.edit.latency_p99` | Patient Service | WARN >300ms, CRIT >1000ms |
| Direct edit error rate | `patient.edit.error_rate` | Patient Service | CRIT >1% |
| Search index lag post-edit | `search.index.lag_after_edit` | Search Service | WARN >2s, CRIT >5s |

---

## System-Level Health

### Event Bus (Redis Streams)

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Consumer lag | `redis.streams.consumer_lag` | Redis / consumer groups | WARN >100 messages, CRIT >500 messages |
| Event processing rate | `redis.streams.processed_per_sec` | Consumers | CRIT if 0 for 2 min |
| Dead letter queue depth | `redis.streams.dlq.depth` | DLQ consumer | CRIT >0 |
| **Import event backlog (S-10)** | `redis.streams.consumer_lag{group=search,topic=import}` | Redis | WARN >200 during import |

### WebSocket Server

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Active connections | `ws.connections.active` | WebSocket Server | Info |
| Connection error rate | `ws.connections.error_rate` | WebSocket Server | WARN >5%, CRIT >10% |
| Message throughput | `ws.messages.per_sec` | WebSocket Server | Info |
| Orphan connections | `ws.connections.orphan` | WebSocket Server | WARN >0 |
| **Connections per instance (S-09)** | `ws.connections.per_instance` | WebSocket Server | WARN >150, triggers HPA |
| **Connection distribution across instances** | `ws.connections.distribution.stddev` | WebSocket Server | WARN if stddev > 30% of mean (uneven LB) |

### PostgreSQL

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Connection pool utilization (primary) | `pg.connections.primary.utilization` | Connection pool | WARN >80%, CRIT >95% |
| **Connection pool utilization (replica)** | `pg.connections.replica.utilization` | Connection pool | WARN >80%, CRIT >95% |
| Replication lag | `pg.replication.lag_bytes` | Replica | WARN >1MB, CRIT >10MB |
| Long-running queries | `pg.queries.duration_p99` | pg_stat_statements | WARN >1s, CRIT >5s |
| Dead tuples (patient_data) | `pg.tables.patient_data.dead_tuples` | pg_stat_user_tables | WARN >10000 |
| WAL disk usage | `pg.wal.disk_usage_pct` | Filesystem | WARN >70%, CRIT >85% |
| Audit table size | `pg.tables.patient_data_audit.size_bytes` | pg_stat_user_tables | Info — 7-year retention capacity planning |
| **Import batch table growth (S-10)** | `pg.tables.import_records.row_count` | pg_stat_user_tables | Info |
| **Transaction duration during finalization** | `pg.transactions.finalize.duration_p99` | pg_stat_activity | WARN >500ms, CRIT >2s |

### Elasticsearch

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Cluster health | `es.cluster.health` | ES API | CRIT if not "green" |
| Index size | `es.index.patients.size` | ES API | Info |
| Search latency (ES-level) | `es.search.latency_p99` | ES API | WARN >100ms, CRIT >300ms |
| Indexing latency | `es.indexing.latency_p99` | ES API | WARN >500ms, CRIT >2000ms |
| **Indexing rate during import (S-10)** | `es.indexing.rate_during_import` | ES API | Info — correlate with import throughput |

### Object Storage (S-08)

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Upload latency | `s3.put.latency_p99` | S3 SDK metrics | WARN >1s, CRIT >3s |
| Upload error rate | `s3.put.error_rate` | S3 SDK metrics | CRIT >1% |
| Signed URL generation latency | `s3.presign.latency_p99` | API Gateway | WARN >200ms |
| Bucket size | `s3.bucket.phi_documents.size_bytes` | CloudWatch/equivalent | Info — capacity planning |
| Access denied events | `s3.access_denied.count` | S3 access logs | WARN >0 (misconfigured policy or unauthorized access attempt) |

### Cache Layer (S-09)

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| Cache hit rate | `redis.cache.hit_rate` | Redis (DB 1) | WARN <70% during peak |
| Cache eviction rate | `redis.cache.evictions_per_sec` | Redis | WARN >0 (maxmemory hit — need more memory or shorter TTL) |
| Cache invalidation lag | `redis.cache.invalidation_lag_ms` | Application | WARN >500ms |

### Notification Service (S-03)

| Signal | Metric | Source | Threshold |
|--------|--------|--------|-----------|
| SMS delivery success rate | `notification.sms.success_rate` | Notification Service | WARN <95%, CRIT <80% |
| Email delivery success rate | `notification.email.success_rate` | Notification Service | WARN <95%, CRIT <80% |
| Link generation rate | `notification.links.generated_per_hour` | Notification Service | Info |
| Appointment poll failures | `notification.appointment_poll.failures` | Notification Service | CRIT >3 consecutive |

---

## Alert Routing

| Severity | Response Time | Channel | Escalation |
|----------|--------------|---------|------------|
| CRIT | < 15 min acknowledge, < 1 hour resolve | PagerDuty + Slack #ops-critical | Escalate to eng lead after 30 min |
| WARN | < 1 hour acknowledge | Slack #ops-alerts | Auto-escalate to CRIT if sustained 30 min |
| Info | Next business day | Dashboard only | None |

**S-10 addition:** During active import, alert thresholds for search latency and consumer lag are temporarily widened. Import-specific alerts route to #ops-migration channel.

---

## Dashboards

### Dashboard 1: Check-in Flow Health
- Active sessions count (per location, aggregate)
- Session creation rate (per 5 min, per location)
- Patient completion rate
- Finalization rate
- Session timeout rate
- Abandoned session rate
- Section action latency p50/p95/p99
- Finalization latency p50/p95/p99
- **Medication confirmation rate (S-06)**
- **Conflict count (S-07)**

### Dashboard 2: Search Health
- Search request rate
- Search latency p50/p95/p99 (standard vs. fuzzy)
- Zero-result rate
- Index drift check results
- Event bus consumer lag (search consumer)
- **Cache hit rate (S-09)**
- **Imported patient search volume (S-10)**

### Dashboard 3: Data Integrity
- Audit write rate
- Audit write failures
- Concurrent session violations
- Staged data application failures
- Orphan sessions
- **Finalization conflicts (S-07)**
- **Merge audit completeness (S-10)**

### Dashboard 4: Infrastructure
- PostgreSQL connection pool (primary + replica), replication lag, query latency
- Elasticsearch cluster health, indexing lag
- Redis consumer lag, memory usage, cache hit rate
- WebSocket active connections, error rate, per-instance distribution
- Service instance health, restart count, HPA events
- **Object Storage: upload latency, bucket size (S-08)**
- **Network: VPC flow anomalies, WAF blocks**

### Dashboard 5: Performance (S-09 — NEW)
- Concurrent sessions: per-location and aggregate over time
- Peak detection: hourly heatmap of session counts
- HPA scaling events timeline
- DB connection pool utilization overlay
- Section save latency overlay with session count
- Abandonment rate correlated with concurrent session count
- Cache effectiveness: hit rate vs. session count

### Dashboard 6: Mobile & Notifications (S-03 — NEW)
- Pre-check-in link generation and delivery rates
- SMS/email delivery success rates
- Link open rate, verification success rate
- Mobile completion rate vs. kiosk completion rate
- Pre-check-in to arrival conversion rate

### Dashboard 7: Import Pipeline (S-10 — NEW)
- Batch progress: total, imported, errors, duplicates
- Import throughput over time
- Dedup confidence distribution
- Pending duplicate review queue depth
- Production impact: search latency overlay during import windows
- Search index backlog during import
