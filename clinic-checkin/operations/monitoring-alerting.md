# Monitoring & Alerting — Clinic Check-In System

Last updated: 2026-03-17
Owner: DevOps

### Traceability — Operations as Last Line of Proof

Every monitor exists to watch an architecture component, prove a product requirement is met in production, or detect a quality failure at runtime. This section maps the full chain.

| Alert / Monitor | Watches (architecture) | Proves (product) | Detects (quality) |
|-----------------|----------------------|-------------------|-------------------|
| **Service Down** | [Check-In Service](../architecture/architecture.md#check-in-service-core) | [US-006 peak-hour performance](../product/user-stories.md#us-006-peak-hour-check-in-performance) — system uptime | [TC-905 backend unreachable](../quality/test-suites.md#tc-905-degraded-mode--backend-unreachable) in production |
| **Database Unreachable** | [PostgreSQL Primary](../architecture/architecture.md#database) | [US-006](../product/user-stories.md#us-006-peak-hour-check-in-performance) — system availability | [TC-905](../quality/test-suites.md#tc-905-degraded-mode--backend-unreachable) |
| **Error Rate Critical** | All [API endpoints](../architecture/api-spec.md) | [US-006](../product/user-stories.md#us-006-peak-hour-check-in-performance) — p95 under 3s, no freezes | [TC-901 50 concurrent check-ins](../quality/test-suites.md#tc-901-50-concurrent-kiosk-check-ins--response-time) failing in prod |
| **Data Leak Detected** | [Session Purge Protocol](../architecture/adrs.md#adr-002-session-purge-protocol-for-kiosk-state-isolation) | [US-003 secure identification](../product/user-stories.md#us-003-secure-patient-identification-on-scan) — no PHI leakage | [TC-301](../quality/test-suites.md#tc-301-sequential-patients--no-data-leakage)–[TC-305](../quality/test-suites.md#tc-305-browser-back-button-does-not-reveal-previous-session) session isolation failure in prod |
| **Read Replica Lag** | [Read Replica](../architecture/architecture.md#database), [ADR-007](../architecture/adrs.md#adr-007-scaling-strategy-for-50-concurrent-sessions) | [US-002](../product/user-stories.md#us-002-receptionist-sees-confirmed-check-in-data) — dashboard data freshness | [TC-903 dashboard stability](../quality/test-suites.md#tc-903-dashboard-stability-during-peak) |
| **p95 Response Time** | All [API endpoints](../architecture/api-spec.md), [ADR-007](../architecture/adrs.md#adr-007-scaling-strategy-for-50-concurrent-sessions) | [US-006](../product/user-stories.md#us-006-peak-hour-check-in-performance) — p95 < 3s | [TC-901](../quality/test-suites.md#tc-901-50-concurrent-kiosk-check-ins--response-time), [TC-902 search perf](../quality/test-suites.md#tc-902-patient-search-performance-under-load) |
| **Concurrent Sessions Warning** | [Check-In Service scaling](../architecture/adrs.md#adr-007-scaling-strategy-for-50-concurrent-sessions) | [US-006](../product/user-stories.md#us-006-peak-hour-check-in-performance) — 50 concurrent target | [TC-901](../quality/test-suites.md#tc-901-50-concurrent-kiosk-check-ins--response-time) |
| **DB Pool Near Capacity** | [PgBouncer](../architecture/architecture.md#connection-pooling-round-9), [ADR-007](../architecture/adrs.md#adr-007-scaling-strategy-for-50-concurrent-sessions) | [US-006](../product/user-stories.md#us-006-peak-hour-check-in-performance) — no timeouts | [TC-904 degraded mode](../quality/test-suites.md#tc-904-degraded-mode--slow-backend) |
| **Sync Failure Rate High** | [Notification Service](../architecture/architecture.md#notification-service), [WebSocket /ws/dashboard](../architecture/api-spec.md#websocket-wsdashboardlocation_id) | [US-002](../product/user-stories.md#us-002-receptionist-sees-confirmed-check-in-data) — data within 5s | [TC-202 sync timeout](../quality/test-suites.md#tc-202-sync-timeout--yellow-warning-on-kiosk), [TC-203 sync failure](../quality/test-suites.md#tc-203-sync-failure--dashboard-retry) |
| **WebSocket Connections High** | [Notification Service](../architecture/architecture.md#notification-service), [ADR-001](../architecture/adrs.md#adr-001-websocket-with-polling-fallback-for-real-time-dashboard-updates) | [US-002](../product/user-stories.md#us-002-receptionist-sees-confirmed-check-in-data) — real-time updates | [TC-204 WebSocket push](../quality/test-suites.md#tc-204-dashboard-real-time-update--websocket-push) |
| **Cache Hit Rate Low** | [Redis cache](../architecture/architecture.md#caching-round-9), [ADR-007](../architecture/adrs.md#adr-007-scaling-strategy-for-50-concurrent-sessions) | [US-006](../product/user-stories.md#us-006-peak-hour-check-in-performance) — search < 2s | [TC-902](../quality/test-suites.md#tc-902-patient-search-performance-under-load) |
| **OCR Service Slow** | [OCR Service](../architecture/architecture.md#ocr-service-round-8), [ADR-006](../architecture/adrs.md#adr-006-ocr-service-as-a-separate-service-behind-a-stable-api-contract) | [US-011](../product/user-stories.md#us-011-photo-capture-of-insurance-card) — OCR extraction | [TC-801 OCR happy path](../quality/test-suites.md#tc-801-photo-capture--happy-path-on-kiosk), [TC-802 OCR failure](../quality/test-suites.md#tc-802-photo-capture--ocr-failure) |
| **Migration Import Errors** | [Migration Service](../architecture/architecture.md#migration-service-round-10), [ADR-010](../architecture/adrs.md#adr-010-migration-pipeline-architecture--batch-import-with-rollback) | [US-012](../product/user-stories.md#us-012-patient-data-migration-from-riverside) — import quality | [TC-1001](../quality/test-suites.md#tc-1001-emr-import--valid-records), [TC-1002](../quality/test-suites.md#tc-1002-emr-import--validation-failures) |
| **SMS Delivery Failure Rate** | [Notification Service](../architecture/architecture.md#notification-service), Twilio integration | [US-007](../product/user-stories.md#us-007-mobile-check-in-link-delivery) — SMS link delivery, [US-008](../product/user-stories.md#us-008-mobile-check-in-flow) — mobile check-in flow | SMS delivery path failure in production |
| **Token Expiry Rate High** | [Check-In Service](../architecture/architecture.md#check-in-service-core), [Mobile Check-In Links API](../architecture/api-spec.md#6-mobile-check-in-links) | [US-008](../product/user-stories.md#us-008-mobile-check-in-flow) — mobile token redemption | Mobile token lifecycle failure in production |
| **Token Redemption Failure Rate** | [Check-In Service](../architecture/architecture.md#check-in-service-core), [Mobile Check-In Links API](../architecture/api-spec.md#6-mobile-check-in-links) | [US-007](../product/user-stories.md#us-007-mobile-check-in-link-delivery), [US-008](../product/user-stories.md#us-008-mobile-check-in-flow) — mobile check-in completion | Mobile token redemption failure in production |
| **Cross-Location Query Failures** | [PostgreSQL](../architecture/architecture.md#database), [ADR-005](../architecture/adrs.md#adr-005-centralized-database-for-multi-location-no-replication) | [US-009](../product/user-stories.md#us-009-multi-location-patient-access) — cross-location data access | Cross-location data query failure in production |
| **Location Data Inconsistency** | [Check-In Service](../architecture/architecture.md#check-in-service-core), [ADR-005](../architecture/adrs.md#adr-005-centralized-database-for-multi-location-no-replication) | [US-009](../product/user-stories.md#us-009-multi-location-patient-access), [US-010](../product/user-stories.md#us-010-location-aware-receptionist-dashboard) — location-scoped data integrity | `location_id` mismatch or orphaned records in production |
| **Medication Confirmation Flow Failure** | [Check-In Service](../architecture/architecture.md#check-in-service-core), [ADR-004](../architecture/adrs.md#adr-004-immutable-medication-confirmation-audit-records) | [US-005](../product/user-stories.md#us-005-medication-list-confirmation-at-check-in) — medication list confirmation | Medication confirmation step failure in production |
| **Medication Confirmation Skip Rate** | [Check-In Service](../architecture/architecture.md#check-in-service-core), [ADR-004](../architecture/adrs.md#adr-004-immutable-medication-confirmation-audit-records) | [US-005](../product/user-stories.md#us-005-medication-list-confirmation-at-check-in) — confirmation compliance | Patients bypassing medication confirmation in production |

| **Confirmed by** | Jordan Lee (DevOps Lead), 2026-03-17 — verified all alert conditions fire correctly in staging, confirmed Watches/Proves/Detects references match current architecture and product docs |

**Runbook links:** Each P0/P1 alert fires a runbook — see [Alert Rules](#alert-rules) below for runbook references, and the [runbooks index](#runbooks) for triggered-by / caused-by / fixed-by links.

---

## Monitoring Stack

| Component | Tool | Purpose |
|-----------|------|---------|
| Metrics | Prometheus + Grafana | Time-series metrics, dashboards |
| Logs | Loki (or ELK) | Centralized log aggregation |
| Tracing | OpenTelemetry + Jaeger | Distributed request tracing |
| Uptime | External ping (e.g., Uptime Robot, Pingdom) | External availability monitoring |
| Alerting | Grafana Alerting / PagerDuty | Alert routing and escalation |

---

## Dashboards

### 1. Operations Overview (Primary Dashboard)

The first dashboard anyone looks at. Shows system health at a glance.

**Panels:**

| Panel | Type | Data Source | Query/Metric |
|-------|------|-------------|--------------|
| System Status | Stat (green/red per service) | Prometheus | `up{job=~"checkin\|notification\|migration\|ocr"}` |
| Request Rate | Time series | Prometheus | `rate(http_requests_total[5m])` by service |
| p95 Response Time | Time series | Prometheus | `histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))` by endpoint |
| Error Rate | Time series | Prometheus | `rate(http_requests_total{status=~"5.."}[5m]) / rate(http_requests_total[5m])` |
| Active Check-In Sessions | Gauge | Prometheus | `checkin_active_sessions` |
| WebSocket Connections | Bar chart by location | Prometheus | `ws_connections_active{service="notification"}` by location |

### 2. Database Dashboard

| Panel | Type | Metric |
|-------|------|--------|
| PgBouncer Pool Utilization | Gauge | `pgbouncer_pools_server_active / pgbouncer_pools_server_pool_size` |
| PgBouncer Wait Time | Time series | `pgbouncer_pools_client_wait_time` |
| PgBouncer Active Connections | Gauge | `pgbouncer_pools_server_active` |
| Query Duration (p95) | Time series | `pg_stat_statements_mean_exec_time` top 10 slowest |
| Read Replica Lag | Time series | `pg_replication_lag_seconds` |
| Database Size | Stat | `pg_database_size_bytes{datname="clinic_checkin"}` |
| Active Queries | Stat | `pg_stat_activity_count{state="active"}` |
| Dead Tuples | Time series | `pg_stat_user_tables_n_dead_tup` top 5 tables |
| Transaction Rate | Time series | `rate(pg_stat_database_xact_commit[5m])` |

### 3. Cache Dashboard (Redis)

| Panel | Type | Metric |
|-------|------|--------|
| Cache Hit Rate | Gauge (%) | `redis_keyspace_hits / (redis_keyspace_hits + redis_keyspace_misses)` |
| Memory Usage | Gauge | `redis_memory_used_bytes / redis_memory_max_bytes` |
| Connected Clients | Stat | `redis_connected_clients` |
| Ops/sec | Time series | `rate(redis_commands_processed_total[5m])` |
| Pub/Sub Channels | Stat | `redis_pubsub_channels` |
| Key Count | Stat | `redis_db_keys` |

### 4. Check-In Flow Dashboard

Business-level metrics for clinic operations.

| Panel | Type | Metric |
|-------|------|--------|
| Check-ins Today (by location) | Stat | `checkin_completed_total{date="today"}` by location |
| Check-in Duration (median) | Stat | `histogram_quantile(0.5, checkin_duration_seconds_bucket)` |
| Sync Success Rate | Gauge (%) | `checkin_sync_confirmed / checkin_completed_total` |
| Sync Timeout Rate | Gauge (%) | `checkin_sync_timeout / checkin_completed_total` |
| Mobile vs Kiosk | Pie chart | `checkin_completed_total` by channel |
| Concurrent Sessions (now) | Gauge | `checkin_active_sessions` |
| Patient Search Latency (p95) | Stat | `histogram_quantile(0.95, patient_search_duration_seconds_bucket)` |
| Version Conflicts Today | Stat | `patient_version_conflict_total{date="today"}` |

### 5. Migration Dashboard (Temporary -- during Riverside migration)

| Panel | Type | Metric |
|-------|------|--------|
| Batch Status | Table | `migration_batch_status` |
| Records Processed | Counter | `migration_records_processed_total` by status |
| Duplicates Found | Stat | `migration_duplicates_found_total` |
| Duplicates Resolved | Stat | `migration_duplicates_resolved_total` |
| OCR Processing Time (avg) | Stat | `histogram_quantile(0.5, ocr_processing_duration_seconds_bucket)` |
| Import Error Rate | Gauge | `migration_import_errors / migration_records_processed` |
| Queue Depth (staff review) | Stat | `migration_review_queue_depth` |

---

## Alert Rules

### P0 -- Page Immediately (Any Time)

These alerts page the on-call engineer. Response expected within 15 minutes.

| Alert | Condition | Duration | Action |
|-------|-----------|----------|--------|
| **Service Down** | `up{job="checkin"} == 0` | 1 min | Page on-call. See [Runbook: Service Outage](./runbook-service-outage.md). **Watches:** [Check-In Service](../architecture/architecture.md#check-in-service-core). **Proves:** [US-006 uptime](../product/user-stories.md#us-006-peak-hour-check-in-performance). |
| **Database Unreachable** | `pg_up == 0` | 30 sec | Page on-call. See [Runbook: Database Failure](./runbook-database-failure.md). **Watches:** [PostgreSQL](../architecture/architecture.md#database). **Proves:** [US-006](../product/user-stories.md#us-006-peak-hour-check-in-performance). |
| **Error Rate Critical** | HTTP 5xx rate > 5% | 2 min | Page on-call. Likely deploy issue or downstream failure. **Watches:** all [API endpoints](../architecture/api-spec.md). **Detects:** [TC-901](../quality/test-suites.md#tc-901-50-concurrent-kiosk-check-ins--response-time) threshold breach. |
| **Data Leak Detected** | `security_session_isolation_failure > 0` | Immediate | Page on-call + security lead. See [Runbook: Data Leak](./runbook-data-leak.md). **Watches:** [ADR-002 Session Purge](../architecture/adrs.md#adr-002-session-purge-protocol-for-kiosk-state-isolation). **Proves:** [US-003](../product/user-stories.md#us-003-secure-patient-identification-on-scan). **Detects:** [TC-301–TC-305](../quality/test-suites.md#suite-3-session-isolation--bug-002-fix-round-4) failure in prod. **Caused by:** [BUG-002](../quality/bug-reports.md#bug-002-previous-patients-data-briefly-visible-on-kiosk-after-card-scan). |
| **Read Replica Lag Critical** | `pg_replication_lag_seconds > 10` | 1 min | Page on-call. Dashboard showing stale data. **Watches:** [Read Replica](../architecture/architecture.md#database), [ADR-007](../architecture/adrs.md#adr-007-scaling-strategy-for-50-concurrent-sessions). **Proves:** [US-002 data freshness](../product/user-stories.md#us-002-receptionist-sees-confirmed-check-in-data). |

### P1 -- Notify During Business Hours

Alert via Slack #ops-alerts. Response expected within 1 hour during business hours.

| Alert | Condition | Duration |
|-------|-----------|----------|
| **p95 Response Time Warning** | > 2 seconds (any endpoint) | 5 min | **Watches:** [API endpoints](../architecture/api-spec.md), [ADR-007](../architecture/adrs.md#adr-007-scaling-strategy-for-50-concurrent-sessions). **Proves:** [US-006](../product/user-stories.md#us-006-peak-hour-check-in-performance) p95 < 3s. **Detects:** [TC-901](../quality/test-suites.md#tc-901-50-concurrent-kiosk-check-ins--response-time), [TC-902](../quality/test-suites.md#tc-902-patient-search-performance-under-load). **Runbook:** [Peak Load](./runbook-peak-load.md). |
| **p95 Response Time Critical** | > 3 seconds (any endpoint) | 2 min | Same traceability as above. |
| **Concurrent Sessions Warning** | > 40 active sessions | 5 min | **Watches:** [Check-In Service](../architecture/architecture.md#check-in-service-core). **Proves:** [US-006](../product/user-stories.md#us-006-peak-hour-check-in-performance) 50-session target. **Detects:** [TC-901](../quality/test-suites.md#tc-901-50-concurrent-kiosk-check-ins--response-time). **Runbook:** [Peak Load](./runbook-peak-load.md). |
| **DB Pool Near Capacity** | PgBouncer utilization > 80% | 5 min | **Watches:** [PgBouncer](../architecture/architecture.md#connection-pooling-round-9), [ADR-007](../architecture/adrs.md#adr-007-scaling-strategy-for-50-concurrent-sessions). **Proves:** [US-006](../product/user-stories.md#us-006-peak-hour-check-in-performance). **Runbook:** [Peak Load](./runbook-peak-load.md). |
| **Read Replica Lag Warning** | > 2 seconds | 2 min | **Watches:** [Read Replica, ADR-007](../architecture/adrs.md#adr-007-scaling-strategy-for-50-concurrent-sessions). **Proves:** [US-002](../product/user-stories.md#us-002-receptionist-sees-confirmed-check-in-data) dashboard freshness. |
| **WebSocket Connections High** | > 15 per location | 5 min | **Watches:** [Notification Service](../architecture/architecture.md#notification-service), [ADR-001](../architecture/adrs.md#adr-001-websocket-with-polling-fallback-for-real-time-dashboard-updates). **Proves:** [US-002](../product/user-stories.md#us-002-receptionist-sees-confirmed-check-in-data). **Detects:** [TC-204](../quality/test-suites.md#tc-204-dashboard-real-time-update--websocket-push). |
| **Sync Failure Rate High** | Sync timeout rate > 10% of check-ins | 10 min | **Watches:** [Notification Service](../architecture/architecture.md#notification-service), [POST /checkins/{id}/complete](../architecture/api-spec.md#post-checkinsidcomplete). **Proves:** [US-002](../product/user-stories.md#us-002-receptionist-sees-confirmed-check-in-data) within 5s. **Detects:** [TC-202](../quality/test-suites.md#tc-202-sync-timeout--yellow-warning-on-kiosk). **Caused by:** [BUG-001](../quality/bug-reports.md#bug-001-kiosk-confirmation-shows-green-checkmark-but-receptionist-sees-nothing). **Runbook:** [Sync Failure](./runbook-sync-failure.md). |
| **SMS Delivery Failure Rate** | `notification_sent_total{type="sms",status="failure"}` rate > 10% of SMS attempts | 10 min | **Watches:** [Notification Service](../architecture/architecture.md#notification-service), Twilio integration. **Proves:** [US-007](../product/user-stories.md#us-007-mobile-check-in-link-delivery) SMS delivery, [US-008](../product/user-stories.md#us-008-mobile-check-in-flow) mobile flow. **Runbook:** [Mobile Delivery](./runbook-mobile-delivery.md). |
| **Token Redemption Failure Rate** | `mobile_token_redemption_failure_total` rate > 5% of redemption attempts | 10 min | **Watches:** [Check-In Service](../architecture/architecture.md#check-in-service-core), [Mobile Check-In Links API](../architecture/api-spec.md#6-mobile-check-in-links). **Proves:** [US-007](../product/user-stories.md#us-007-mobile-check-in-link-delivery), [US-008](../product/user-stories.md#us-008-mobile-check-in-flow). **Runbook:** [Mobile Delivery](./runbook-mobile-delivery.md). |
| **Cross-Location Query Failures** | `http_requests_total{path="/patients/*",status="5xx",cross_location="true"}` rate > 2% | 5 min | **Watches:** [PostgreSQL](../architecture/architecture.md#database), [ADR-005](../architecture/adrs.md#adr-005-centralized-database-for-multi-location-no-replication). **Proves:** [US-009](../product/user-stories.md#us-009-multi-location-patient-access) cross-location data access. |
| **Medication Confirmation Flow Failure** | `medication_confirmation_failure_total` rate > 5% of confirmation attempts | 10 min | **Watches:** [Check-In Service](../architecture/architecture.md#check-in-service-core), [ADR-004](../architecture/adrs.md#adr-004-immutable-medication-confirmation-audit-records). **Proves:** [US-005](../product/user-stories.md#us-005-medication-list-confirmation-at-check-in) medication confirmation. |
| **Error Rate Warning** | HTTP 5xx rate > 1% | 5 min | **Watches:** all [API endpoints](../architecture/api-spec.md). **Proves:** [US-006](../product/user-stories.md#us-006-peak-hour-check-in-performance). |

### P2 -- Investigate During Next Business Day

Alert via Slack #ops-alerts. No pager.

| Alert | Condition | Duration |
|-------|-----------|----------|
| **Cache Hit Rate Low** | Redis hit rate < 50% | 30 min | **Watches:** [Redis cache](../architecture/architecture.md#caching-round-9), [ADR-007](../architecture/adrs.md#adr-007-scaling-strategy-for-50-concurrent-sessions). **Proves:** [US-006](../product/user-stories.md#us-006-peak-hour-check-in-performance) search < 2s. **Detects:** [TC-902](../quality/test-suites.md#tc-902-patient-search-performance-under-load) degradation. |
| **Redis Memory High** | > 80% of max memory | 30 min | **Watches:** [Redis](../architecture/architecture.md#caching-round-9). |
| **DB Storage High** | > 70% of allocated storage | N/A (daily check) | **Watches:** [PostgreSQL](../architecture/architecture.md#database). |
| **Certificate Expiry** | TLS cert expires within 14 days | N/A (daily check) | **Watches:** [TLS termination](../architecture/architecture.md#security). |
| **Dead Tuples High** | > 100,000 dead tuples on patients table | N/A (daily check) | **Watches:** [PostgreSQL](../architecture/architecture.md#database). **Proves:** [US-006](../product/user-stories.md#us-006-peak-hour-check-in-performance) query performance. |
| **Audit Log Growth** | > 1 GB/day growth | N/A (daily check) | **Watches:** audit_log table per [ADR-004](../architecture/adrs.md#adr-004-immutable-medication-confirmation-audit-records). **Proves:** [US-005](../product/user-stories.md#us-005-medication-list-confirmation-at-check-in) compliance audit trail. |
| **OCR Service Slow** | OCR processing time p95 > 10 seconds | 15 min | **Watches:** [OCR Service](../architecture/architecture.md#ocr-service-round-8), [ADR-006](../architecture/adrs.md#adr-006-ocr-service-as-a-separate-service-behind-a-stable-api-contract). **Proves:** [US-011](../product/user-stories.md#us-011-photo-capture-of-insurance-card). **Detects:** [TC-801](../quality/test-suites.md#tc-801-photo-capture--happy-path-on-kiosk) degradation. **Runbook:** [Import Failure — OCR section](./runbook-import-failure.md#type-2-ocr-extraction-failures-paper-records). |
| **Migration Import Errors** | > 5% error rate in active batch | 10 min | **Watches:** [Migration Service](../architecture/architecture.md#migration-service-round-10), [ADR-010](../architecture/adrs.md#adr-010-migration-pipeline-architecture--batch-import-with-rollback). **Proves:** [US-012](../product/user-stories.md#us-012-patient-data-migration-from-riverside). **Detects:** [TC-1002](../quality/test-suites.md#tc-1002-emr-import--validation-failures). **Runbook:** [Import Failure](./runbook-import-failure.md). |
| **Token Expiry Rate High** | `mobile_token_expired_total / mobile_token_issued_total` > 20% over 24h | N/A (daily check) | **Watches:** [Check-In Service](../architecture/architecture.md#check-in-service-core), [Mobile Check-In Links API](../architecture/api-spec.md#6-mobile-check-in-links). **Proves:** [US-008](../product/user-stories.md#us-008-mobile-check-in-flow) mobile completion rate. **Runbook:** [Mobile Delivery](./runbook-mobile-delivery.md). |
| **Location Data Inconsistency** | `location_data_inconsistency_total > 0` | Immediate | **Watches:** [Check-In Service](../architecture/architecture.md#check-in-service-core), [ADR-005](../architecture/adrs.md#adr-005-centralized-database-for-multi-location-no-replication). **Proves:** [US-009](../product/user-stories.md#us-009-multi-location-patient-access), [US-010](../product/user-stories.md#us-010-location-aware-receptionist-dashboard) location-scoped data integrity. |
| **Medication Confirmation Skip Rate** | `medication_confirmation_skipped_total / checkin_completed_total{has_medications="true"}` > 15% | N/A (daily check) | **Watches:** [Check-In Service](../architecture/architecture.md#check-in-service-core), [ADR-004](../architecture/adrs.md#adr-004-immutable-medication-confirmation-audit-records). **Proves:** [US-005](../product/user-stories.md#us-005-medication-list-confirmation-at-check-in) confirmation compliance. |

---

## Custom Application Metrics

These metrics must be instrumented in the application code and exposed on `/metrics` (Prometheus format).

### Check-In Service

```
# Counter: total check-ins by channel and status
checkin_completed_total{channel="kiosk|mobile|walk_in", status="completed|failed", location_id="uuid"}

# Gauge: currently active sessions
checkin_active_sessions{location_id="uuid"}

# Histogram: check-in flow duration (start to complete)
checkin_duration_seconds_bucket{channel="kiosk|mobile"}

# Counter: sync outcomes
checkin_sync_confirmed_total{location_id="uuid"}
checkin_sync_timeout_total{location_id="uuid"}
checkin_sync_failed_total{location_id="uuid"}

# Histogram: patient search latency
patient_search_duration_seconds_bucket{method="card_scan|name_search"}

# Counter: version conflicts
patient_version_conflict_total{location_id="uuid"}

# Counter: session isolation events (should always be 0)
security_session_isolation_failure_total

# Histogram: API response time
http_request_duration_seconds_bucket{method="GET|POST|PATCH|PUT|DELETE", path="/patients/*|/checkins/*|...", status="2xx|4xx|5xx"}

# Counter: total HTTP requests
http_requests_total{method, path, status}
```

### Notification Service

```
# Gauge: active WebSocket connections by location
ws_connections_active{location_id="uuid"}

# Counter: WebSocket events pushed
ws_events_pushed_total{event_type="checkin_update|batch_update", location_id="uuid"}

# Counter: WebSocket acks received
ws_acks_received_total{location_id="uuid"}

# Counter: SMS/email sent
notification_sent_total{type="sms|email", status="success|failure"}

# Histogram: notification delivery time
notification_delivery_seconds_bucket{type="sms|email"}
```

### OCR Service

```
# Histogram: OCR processing time
ocr_processing_duration_seconds_bucket{type="insurance_card|patient_record"}

# Counter: OCR results by quality
ocr_result_total{type="insurance_card|patient_record", result="success|partial|failure"}

# Gauge: average confidence score
ocr_confidence_average{field="payer_name|member_id|group_number|..."}
```

### Migration Service

```
# Counter: records processed by status
migration_records_processed_total{batch_id="uuid", status="imported|needs_review|potential_duplicate|import_error"}

# Counter: duplicates found
migration_duplicates_found_total{batch_id="uuid"}

# Counter: duplicates resolved
migration_duplicates_resolved_total{batch_id="uuid", resolution="merged|kept_separate|flagged"}

# Gauge: staff review queue depth
migration_review_queue_depth

# Histogram: batch processing time
migration_batch_duration_seconds_bucket
```

---

## Log Aggregation

### Log Format

All services log in structured JSON:

```json
{
  "timestamp": "2026-03-17T09:17:00.123Z",
  "level": "info",
  "service": "checkin-service",
  "trace_id": "abc123",
  "message": "Check-in completed",
  "patient_id": "uuid",
  "check_in_id": "uuid",
  "channel": "kiosk",
  "location_id": "uuid",
  "duration_ms": 1234
}
```

**PHI in logs:** Patient IDs (UUIDs) are logged. Patient names, DOB, SSN, phone, address, and medical data are NEVER logged. If a log entry accidentally contains PHI, treat it as a security incident.

### Log Retention

| Log Source | Retention |
|------------|-----------|
| Application logs | 90 days (hot), 1 year (cold/archive) |
| Access logs (load balancer) | 90 days |
| Audit log (database) | Indefinite (compliance requirement) |
| PostgreSQL logs | 30 days |
| PgBouncer logs | 30 days |
| Redis logs | 14 days |

### Key Log Queries

**Find all events for a check-in session:**
```
{service="checkin-service"} | json | check_in_id="<uuid>"
```

**Find all 5xx errors in the last hour:**
```
{service=~"checkin.*|notification.*"} | json | level="error" | status >= 500
```

**Find sync failures:**
```
{service="checkin-service"} | json | message=~"sync.*timeout|sync.*failed"
```

**Find session isolation events (CRITICAL -- should return zero):**
```
{service="checkin-service"} | json | message=~"session.*isolation|purge.*fail"
```

---

## Distributed Tracing

OpenTelemetry instrumentation across all services. A single check-in flow generates a trace spanning:

```
[Check-In Service] POST /patients/identify
    └─[PgBouncer] → [PostgreSQL] SELECT patients WHERE card_id = ...
[Check-In Service] GET /patients/{id}
    └─[PgBouncer] → [PostgreSQL] SELECT patients JOIN allergies JOIN medications ...
    └─[Redis] GET patient:{id}:summary
[Check-In Service] POST /checkins/{id}/complete
    └─[PgBouncer] → [PostgreSQL] INSERT check_ins, INSERT medication_confirmations
    └─[Redis] PUBLISH checkin:{location_id}
    └─[Notification Service] WebSocket push
        └─[Dashboard] WebSocket ack
    └─[Redis] DEL queue:{location_id}:{date}
```

Trace IDs are passed in the `X-Trace-Id` HTTP header and propagated through Redis pub/sub messages. This allows tracing a check-in from kiosk tap to dashboard update.

**Sampling:** 10% of traces in production (adjustable). 100% for requests with errors. 100% in staging.

---

## Uptime Monitoring (External)

External pings from outside our infrastructure, verifying the system is reachable from the internet.

| Check | URL | Interval | Timeout | Alert after |
|-------|-----|----------|---------|-------------|
| API Health | `https://api.clinic-checkin.example.com/health` | 30s | 10s | 2 failures |
| Mobile Web | `https://checkin.clinic.example.com` | 60s | 10s | 3 failures |
| Dashboard | `https://dashboard.clinic.example.com` | 60s | 10s | 3 failures |

---

## Alert Routing

| Severity | Channel | Who | When |
|----------|---------|-----|------|
| P0 | PagerDuty | On-call engineer | 24/7 |
| P0 (data leak) | PagerDuty + phone call | On-call engineer + security lead + CTO | 24/7 |
| P1 | Slack #ops-alerts | DevOps team | Business hours (8 AM - 6 PM ET) |
| P2 | Slack #ops-alerts | DevOps team | Next business day |

### On-Call Rotation

- Primary on-call: weekly rotation among DevOps team
- Secondary on-call: the previous week's primary (backup escalation)
- Escalation: if primary doesn't ack within 15 minutes, page secondary
- If secondary doesn't ack within 15 minutes, page CTO

### Acknowledgment Protocol

When an alert fires, acknowledgment is not just "I see it." It means:

1. **Identify affected items.** What does this alert prove? (See traceability table above.) Those items are now **suspect** — their proven status no longer holds.
2. **Assess impact.** Which upstream requirements and downstream dependencies trace to the suspect items? Flag them.
3. **Plan re-verification.** What evidence is needed to restore proven status? A passing test run, a metric returning to baseline, a manual walkthrough — not just "it stopped firing."
4. **Record the acknowledgment.** Who acknowledged, when, what was flagged suspect, and what re-verification is planned. This goes in the incident channel, not just PagerDuty.

An alert that is acknowledged but not impact-assessed is an alert that is ignored with extra steps.

### Alert Fatigue Prevention

- Alerts that fire > 3 times/week without action needed: review and tune thresholds
- Group related alerts (e.g., "high p95" and "high DB pool" during peak hours are one incident, not two)
- Suppress known maintenance alerts during scheduled maintenance windows
- Review all alert definitions monthly

---

## Health Check Endpoints

Every service exposes `GET /health`:

```json
{
  "status": "ok",
  "version": "1.4.2",
  "uptime_seconds": 86400,
  "checks": {
    "database": "ok",
    "redis": "ok",
    "s3": "ok"
  }
}
```

If any dependency check fails:
```json
{
  "status": "degraded",
  "version": "1.4.2",
  "checks": {
    "database": "ok",
    "redis": "error: connection refused",
    "s3": "ok"
  }
}
```

The load balancer uses `status` field: `"ok"` = healthy, anything else = unhealthy.

`"degraded"` means the service is running but a dependency is down. The service may still handle requests that don't depend on the failed component (e.g., if Redis is down, check-ins still work but cache misses go to DB).
