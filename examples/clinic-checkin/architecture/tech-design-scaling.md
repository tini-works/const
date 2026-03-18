# Technical Design: Scaling for Peak Load

**Related:** [US-006](../product/user-stories.md#us-006-peak-hour-check-in-performance), [DEC-007](../product/decision-log.md#dec-007-performance-target--50-concurrent-sessions-p95-under-3-seconds), [ADR-007](adrs.md#adr-007-scaling-strategy-for-50-concurrent-sessions)
**Screens:** [5.1 Loading States](../experience/screen-specs.md#51-loading-states), [5.2 Degraded Mode — Slow Backend](../experience/screen-specs.md#52-degraded-mode--slow-backend), [5.3 Degraded Mode — Backend Unreachable](../experience/screen-specs.md#53-degraded-mode--backend-unreachable), [1.9 Name Search](../experience/screen-specs.md#19-kiosk-name-search-screen), [2.1 Dashboard](../experience/screen-specs.md#21-receptionist-dashboard--main-view)
**Flows:** [15. Peak Load Degraded Experience](../experience/user-flows.md#15-peak-load-degraded-experience-round-9)
**Tested by:** [TC-901](../quality/test-suites.md#tc-901-50-concurrent-kiosk-check-ins--response-time), [TC-902](../quality/test-suites.md#tc-902-patient-search-performance-under-load), [TC-903](../quality/test-suites.md#tc-903-dashboard-stability-during-peak), [TC-904](../quality/test-suites.md#tc-904-degraded-mode--slow-backend), [TC-905](../quality/test-suites.md#tc-905-degraded-mode--backend-unreachable)
**Monitored by:** [p95 Response Time, Concurrent Sessions, DB Pool Utilization, Cache Hit Rate, Read Replica Lag](../operations/monitoring-alerting.md#p1----notify-during-business-hours); [Database Dashboard](../operations/monitoring-alerting.md#2-database-dashboard); [Cache Dashboard](../operations/monitoring-alerting.md#3-cache-dashboard-redis)
**Confirmed by:** Alex Kim (Tech Lead), 2024-12-15

---

## Problem

Monday mornings between 8-9 AM, 30 patients check in simultaneously at one location. The system freezes: kiosk search hangs, dashboards stop updating, two patients walked out this month. With a second location opening and mobile check-in launching, peak concurrency will grow.

Target: 50 concurrent sessions, p95 response time under 3 seconds.

---

## Bottleneck Analysis

We profiled the system under simulated 30-user concurrent load. Three root causes:

### 1. Database Connection Exhaustion

**Symptom:** Requests queuing at the application layer, waiting for a DB connection.

**Root cause:** Each multi-step check-in session holds a database connection for the duration of the flow (not per-query — per-session). With 30 concurrent sessions, 30 connections are held simultaneously. PostgreSQL's default `max_connections = 100` is shared with the dashboard, search, and background jobs. At 30 check-ins + 5 dashboard refreshes + search queries, we're hitting the limit.

**Fix: PgBouncer in transaction mode.**

```
Application Server → PgBouncer → PostgreSQL

PgBouncer config:
  pool_mode = transaction
  default_pool_size = 25
  max_client_conn = 200
  reserve_pool_size = 5
```

Transaction mode means the connection is returned to the pool after each transaction (each SQL query or explicit transaction block), not after the client disconnects. 25 pooled connections can serve 200 client connections because each client only holds a connection for the milliseconds it takes to execute a query.

**Expected impact:** Connection wait time drops from seconds to near-zero. This alone should resolve most of the kiosk freeze symptoms.

### 2. Slow Patient Search

**Symptom:** Name search on the kiosk takes 5-8 seconds under load.

**Root cause:** `SELECT * FROM patients WHERE last_name ILIKE '%john%'` — leading wildcard prevents index use, full table scan. Combined with no client-side debounce, every keystroke fires a query.

**Fix: Composite index + trigram index + client-side debounce.**

```sql
-- Exact prefix match (fast, covers most cases)
CREATE INDEX idx_patients_last_first ON patients (last_name, first_name);

-- Fuzzy/partial match (covers typos, partial names)
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX idx_patients_name_trgm ON patients
    USING gin ((last_name || ' ' || first_name) gin_trgm_ops);
```

**Query strategy:**

```sql
-- First: try exact prefix match (fastest, uses btree index)
SELECT id, first_name, last_name, date_of_birth
FROM patients
WHERE last_name ILIKE $query || '%'
  AND deleted_at IS NULL
ORDER BY last_name, first_name
LIMIT 10;

-- If too few results: fall back to trigram similarity (uses gin index)
SELECT id, first_name, last_name, date_of_birth,
       similarity(last_name || ' ' || first_name, $query) AS sim
FROM patients
WHERE (last_name || ' ' || first_name) % $query
  AND deleted_at IS NULL
ORDER BY sim DESC
LIMIT 10;
```

**Client-side debounce:**
- 300ms delay after last keystroke before firing search
- Minimum 2 characters required
- Cancel in-flight request if new input arrives (AbortController)

**Expected impact:** Search time drops from 5-8 seconds to < 500ms for prefix match, < 1 second for fuzzy match.

### 3. Dashboard Broadcast Storm

**Symptom:** Dashboard becomes sluggish when many patients check in simultaneously.

**Root cause:** Each check-in publishes a WebSocket event. The dashboard receives each event and triggers a full state recalculation. When 10 events arrive within 1 second, the dashboard re-renders 10 times.

**Fix: Event batching + incremental updates.**

**Server-side batching:**
```typescript
// Batch rapid-fire events: if multiple check-ins occur within 500ms,
// combine them into a single WebSocket push

const pendingUpdates = new Map<string, CheckInUpdate[]>();

function queueUpdate(locationId: string, update: CheckInUpdate) {
  if (!pendingUpdates.has(locationId)) {
    pendingUpdates.set(locationId, []);
    setTimeout(() => flushUpdates(locationId), 500);
  }
  pendingUpdates.get(locationId)!.push(update);
}

function flushUpdates(locationId: string) {
  const updates = pendingUpdates.get(locationId) || [];
  pendingUpdates.delete(locationId);

  ws.broadcast(locationId, {
    type: 'batch_update',
    updates: updates
  });
}
```

**Client-side incremental updates:**
- Dashboard maintains a local state map of appointments
- On receiving an update, only the affected row(s) are re-rendered — not the entire table
- React key on each row ensures targeted DOM updates

**DOM virtualization for large queues:**
- Only visible rows are rendered in the DOM
- Scroll container uses virtual rendering (react-window or similar)
- Off-screen rows receive data updates in the state map but don't trigger DOM operations until scrolled into view

**Expected impact:** Dashboard CPU usage during peak drops by ~80%. Smooth scrolling and real-time updates even with 50+ concurrent check-ins.

---

## Read Replica Setup

For dashboard queries and search, route reads to a PostgreSQL streaming replica.

```
                     ┌──────────────────┐
                     │   Application    │
                     │     Server       │
                     └────────┬─────────┘
                              │
                    ┌─────────┴─────────┐
                    │                   │
               Writes only         Reads only
                    │                   │
                    ▼                   ▼
              ┌──────────┐      ┌──────────────┐
              │ Primary  │─────>│ Read Replica  │
              │ (RW)     │ WAL  │ (RO)          │
              └──────────┘      └──────────────┘
```

**Routing logic:**
```typescript
function getDbClient(operation: 'read' | 'write'): PrismaClient {
  if (operation === 'write') return primaryDb;
  return replicaDb;
}

// Dashboard queue: read from replica
app.get('/dashboard/queue', async (req, res) => {
  const db = getDbClient('read');
  const appointments = await db.appointment.findMany({ ... });
});

// Patient update: write to primary
app.patch('/patients/:id', async (req, res) => {
  const db = getDbClient('write');
  await db.patient.update({ ... });
});
```

**Replication lag tolerance:**
- Target: < 1 second lag
- Dashboard data can tolerate up to 2 seconds of staleness (a row showing "Not Checked In" for 1-2 seconds after the patient actually checked in is acceptable — the WebSocket push handles real-time updates separately)
- Search can tolerate 2-3 seconds of staleness (a newly created patient might not appear in search for a few seconds — acceptable)
- Check-in writes (version checks, medication confirmations) always go to primary — zero lag tolerance

---

## Caching Strategy

Redis cache for frequently-accessed, read-heavy data.

### Cache Entries

| Key Pattern | Data | TTL | Invalidation |
|------------|------|-----|-------------|
| `queue:{location_id}:{date}` | Today's appointment queue for a location | 30s | Invalidated on check-in status change, new appointment |
| `patient:{id}:summary` | Patient search result summary (name, DOB, phone) | 5 min | Invalidated on patient record update |
| `search:{query_hash}` | Search results for a query | 30s | Not explicitly invalidated (short TTL) |
| `dashboard:stats:{location_id}` | Dashboard summary counts (checked in / pending) | 10s | Invalidated on check-in status change |

### Cache-Aside Pattern

```typescript
async function getDashboardQueue(locationId: string, date: string) {
  const cacheKey = `queue:${locationId}:${date}`;
  const cached = await redis.get(cacheKey);
  if (cached) return JSON.parse(cached);

  const data = await replicaDb.appointment.findMany({
    where: { location_id: locationId, date },
    include: { check_in: true, patient: true }
  });

  await redis.set(cacheKey, JSON.stringify(data), 'EX', 30);
  return data;
}
```

### Cache Invalidation

On any check-in status change:
```typescript
async function invalidateDashboardCache(locationId: string) {
  const date = new Date().toISOString().split('T')[0];
  await redis.del(`queue:${locationId}:${date}`);
  await redis.del(`dashboard:stats:${locationId}`);
}
```

On patient record update:
```typescript
async function invalidatePatientCache(patientId: string) {
  await redis.del(`patient:${patientId}:summary`);
  // Search cache has short TTL, no explicit invalidation needed
}
```

---

## Load Testing Results (Projected)

Based on profiling each optimization independently:

| Scenario | Before | After (projected) |
|----------|--------|-------------------|
| Patient search (30 concurrent) | 5-8s | < 500ms |
| Dashboard load (30 concurrent check-ins) | 4-6s, freezes | < 1s, smooth |
| Kiosk check-in flow (30 concurrent) | Intermittent freezes | < 2s per step |
| DB connection wait time | 2-4s (queue) | < 50ms |
| p95 response time (all endpoints) | > 8s | < 2s |

**Target: 50 concurrent sessions, p95 < 3 seconds.** Projected to meet this with headroom.

---

## Monitoring

### Key Metrics to Track

| Metric | Source | Alert Threshold |
|--------|--------|----------------|
| p95 response time per endpoint | Application metrics | > 2s warning, > 3s critical |
| Active concurrent sessions | Application metrics | > 40 warning |
| PgBouncer pool utilization | PgBouncer stats | > 80% warning |
| PgBouncer wait time | PgBouncer stats | > 100ms warning |
| Read replica lag | PostgreSQL | > 2s critical |
| Redis memory usage | Redis INFO | > 80% of max warning |
| Redis cache hit rate | Redis INFO | < 50% investigate |
| WebSocket connection count per location | Application metrics | > 15 warning |
| Dashboard event latency (check-in to dashboard update) | Application metrics | > 5s warning |

### Dashboard for Ops

A Grafana dashboard (or equivalent) showing:
- Request rate and response time distribution (histogram)
- Concurrent sessions over time (line chart)
- DB connection pool (gauge)
- Cache hit rate (line chart)
- WebSocket connection count by location (bar chart)
- Read replica lag (line chart)

---

## Rollout Plan

These optimizations can be deployed incrementally:

1. **Week 1: Client-side debounce + search cancel** — Zero backend change, immediate relief on search load
2. **Week 1: PgBouncer** — Infrastructure change, biggest single impact
3. **Week 2: Search indexes** — Schema migration (CREATE INDEX CONCURRENTLY, no downtime)
4. **Week 2: Dashboard event batching** — Backend + frontend change
5. **Week 3: Read replica** — Infrastructure setup, routing logic
6. **Week 3: Redis caching** — Application-level change
7. **Week 4: DOM virtualization** — Frontend optimization for large queues
8. **Ongoing: Monitoring** — Deploy from week 1, tune thresholds based on observed data
