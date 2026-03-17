# Monitoring & Alerting — Clinic Check-In System

Last updated: 2026-03-17
Owner: DevOps

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
| **Service Down** | `up{job="checkin"} == 0` | 1 min | Page on-call. See [Runbook: Service Outage](./runbook-service-outage.md) |
| **Database Unreachable** | `pg_up == 0` | 30 sec | Page on-call. See [Runbook: Database Failure](./runbook-database-failure.md) |
| **Error Rate Critical** | HTTP 5xx rate > 5% | 2 min | Page on-call. Likely deploy issue or downstream failure |
| **Data Leak Detected** | `security_session_isolation_failure > 0` | Immediate | Page on-call + security lead. See [Runbook: Data Leak](./runbook-data-leak.md) |
| **Read Replica Lag Critical** | `pg_replication_lag_seconds > 10` | 1 min | Page on-call. Dashboard showing stale data |

### P1 -- Notify During Business Hours

Alert via Slack #ops-alerts. Response expected within 1 hour during business hours.

| Alert | Condition | Duration |
|-------|-----------|----------|
| **p95 Response Time Warning** | > 2 seconds (any endpoint) | 5 min |
| **p95 Response Time Critical** | > 3 seconds (any endpoint) | 2 min |
| **Concurrent Sessions Warning** | > 40 active sessions | 5 min |
| **DB Pool Near Capacity** | PgBouncer utilization > 80% | 5 min |
| **Read Replica Lag Warning** | > 2 seconds | 2 min |
| **WebSocket Connections High** | > 15 per location | 5 min |
| **Sync Failure Rate High** | Sync timeout rate > 10% of check-ins | 10 min |
| **Error Rate Warning** | HTTP 5xx rate > 1% | 5 min |

### P2 -- Investigate During Next Business Day

Alert via Slack #ops-alerts. No pager.

| Alert | Condition | Duration |
|-------|-----------|----------|
| **Cache Hit Rate Low** | Redis hit rate < 50% | 30 min |
| **Redis Memory High** | > 80% of max memory | 30 min |
| **DB Storage High** | > 70% of allocated storage | N/A (daily check) |
| **Certificate Expiry** | TLS cert expires within 14 days | N/A (daily check) |
| **Dead Tuples High** | > 100,000 dead tuples on patients table | N/A (daily check) |
| **Audit Log Growth** | > 1 GB/day growth | N/A (daily check) |
| **OCR Service Slow** | OCR processing time p95 > 10 seconds | 15 min |
| **Migration Import Errors** | > 5% error rate in active batch | 10 min |

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
