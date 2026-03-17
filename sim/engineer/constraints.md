# Engineering Constraints & Safety Issues

System constraints, performance concerns, and safety issues discovered during architectural evolution.

---

## Critical Safety Issues

### 1. Race Condition at Finalization (S-07 — QA G-08 validated)

**Problem:** BOX-E5 prevents concurrent *sessions*, but two receptionists could theoretically finalize the *same* session simultaneously. The unique partial index on checkin_sessions prevents duplicate sessions — it does NOT prevent duplicate finalization attempts on one session.

**Root cause:** S-01 design assumed one receptionist per session. S-07 proved this wrong — a supervisor can "Take Over" a session, and network retries could duplicate a finalize request.

**Fix:** Optimistic locking via `version` column. Finalization requires `expected_version` in request body. Server checks `WHERE id = ? AND version = ?`. If version doesn't match (another finalization raced ahead), returns 412. If version matches but the session was already finalized by another path (e.g., a parallel session somehow existed), returns 409 with conflict details.

**Status:** Fixed. BOX-E9 (atomic finalization) + version column.

### 2. Screen State Isolation (S-04 — HIPAA breach)

**Problem:** Patient A's data remained in browser DOM/memory/history after session ended. Patient B saw Patient A's PHI.

**Root cause:** Session termination was advisory ("show S4 screen"), not enforced ("purge all client state"). The client transitioned visually but did not purge data.

**Fix:** SessionPurge module — synchronous, blocking, runs before any screen transition away from S3P. DOM purge, JS memory nullification, history replacement, autocomplete clearing, token deletion, cache clearing. S0 (Welcome Screen) introduced as a hard gate — zero PHI, loaded from scratch.

**Status:** Fixed. BOX-12, BOX-13.

### 3. WebSocket Event Delivery (S-02 — QA G-06 validated)

**Problem:** Receptionist was blind to patient completion because WebSocket events were silently dropped.

**Root cause:** No heartbeat, no reconnection strategy, no fallback. WebSocket was assumed to be reliable.

**Fix:**
- Heartbeat: 15s ping/pong cycle. Server detects dead connections within 20s.
- Auto-reconnect: exponential backoff, max 10 retries.
- Fallback: after 10 failed retries, client switches to REST polling (GET /checkins/{id}/poll every 10s).
- S5 queue is always REST — works even if all WebSocket infrastructure fails.
- Connection health indicator on S3R: green/amber/red.

**Status:** Fixed. BOX-05, BOX-07, BOX-D4.

---

## Architecture Constraints

### Multi-Tenancy Model (S-05)

Location is implemented as **context, not boundary**. This means:
- Single patients table, no sharding by location
- location_id is an attribute on sessions, visits, queue views
- Search is cross-location by default (no location filter needed for patient lookup)
- Concurrent prevention is cross-location (a session at Location A blocks Location B)
- Queue can be filtered by location or shown cross-location

**Consequence:** Adding a new location is a configuration change (INSERT into locations table), not a schema migration or infrastructure change. This directly enables S-05 (second clinic) and S-10 (acquisition).

**Risk:** Single database serves all locations. If Location A's heavy load degrades queries for Location B, there's no isolation. Mitigation: read replica for search, connection pool sizing, horizontal scaling of stateless services.

### Medication Data Model (S-06)

Medications are modeled as a regular `data_category` with `freshness_days = 0`, not as a special entity.

**Why not a separate medications table?**
- All existing patterns (staleness computation, section confirm/update, audit) work unchanged.
- Adding medications required zero code changes to the staleness engine — just a new row in `data_categories`.
- The JSONB value schema supports variable-length arrays natively.
- confirmed_empty:true handles the "no medications" case without a separate entity.

**Limitation:** No medication-level audit trail. The audit captures the entire medications list as old_value/new_value. Individual medication additions/removals are not first-class audit events — they're embedded in the list diff. If per-medication audit is needed (e.g., "when was Lisinopril removed?"), a dedicated medications table with row-level tracking would be required. This is a known tradeoff for simplicity.

### OCR Pipeline (S-08)

**Architecture decision:** Cloud OCR API, not custom ML.

**Why:**
- Insurance card layouts are highly variable (thousands of providers, each with different card designs).
- Training a custom model requires labeled training data we don't have.
- Cloud APIs (Textract, Form Recognizer) are pre-trained on document types including insurance cards.
- Cost: ~$0.01 per image. At 100 uploads/day = $1/day.
- HIPAA: requires BAA with cloud provider. All major providers offer this.

**Risk:** Cloud API downtime degrades insurance update flow. Mitigation: manual entry fallback is always available (BOX-D18). OCR failure is not a session-blocking event.

### Import Pipeline (S-10)

**Dedup algorithm design:**

The algorithm uses a multi-signal scoring approach:

| Signal | Weight | Match Type |
|--------|--------|-----------|
| first_name + last_name + DOB exact | 100% | Exact |
| DOB exact + name Levenshtein <= 1 | 90% | High |
| Name exact + DOB within 1 year + phone exact | 85% | High |
| DOB exact + name Levenshtein <= 2 | 75% | Medium |
| Phone exact + name Levenshtein <= 2 | 70% | Medium |
| Last name exact + DOB year exact | 50% | Low |
| Phone exact only | 40% | Low |

**Known limitation:** The algorithm does not handle:
- Name changes (marriage, legal name change) — could miss duplicates
- Phone number changes — reduces signal accuracy
- Patients who appear at multiple source systems with different data

**Mitigation:** Human review for all confidence > 0%. Only 0% confidence (no match at all) auto-imports. Conservative by design — false positives (flagging non-duplicates) are preferred over false negatives (missing real duplicates).

---

## Performance Constraints (S-09)

### Connection Pool Sizing

| Pool | Size | Rationale |
|------|------|-----------|
| Primary DB | 50 connections | 30 concurrent sessions x 2 operations/session = 60. But operations are short (< 10ms). 50 connections with queuing handles bursts. |
| Read Replica | 20 connections | Search queries during peak. Offloads primary. |
| Redis | 20 connections | Event publishing, cache reads/writes. Low contention. |

**Warning:** If connection pool is exhausted:
- Section saves fail -> patient sees "trouble saving" error
- Session creation may fail -> receptionist sees 503
- Worst case: concurrent prevention check fails (query times out) -> potential for duplicate sessions (BOX-O3 catches this)

### Scaling Targets

| Metric | Target | Strategy |
|--------|--------|----------|
| Search p95 latency | < 200ms (single location), < 500ms (60 concurrent) | Read replica, search index optimization |
| Section save p95 | < 500ms | Connection pool, stateless Check-in Service |
| Finalization p95 | < 1s | Single transaction, event emission async |
| WebSocket connections | 200 per server instance | Horizontal scaling of WebSocket server |
| Import throughput | 10 records/second sustained | Throttling, pause during peak |

### Cache Strategy

| Key Pattern | TTL | Invalidation |
|-------------|-----|-------------|
| patient:{id}:summary | 5 min | Event-driven on patient.updated |
| data_categories | 1 hour | Manual invalidation (rare changes) |
| checkin:{id}:state | 30 seconds | Updated on every section action |

Cache is a performance optimization, not a correctness requirement. All reads fall back to DB on cache miss. TTL is a safety net for invalidation failures.

---

## Known Debt

| Item | Severity | Added | Resolution path |
|------|----------|-------|----------------|
| Per-medication audit trail | Low | S-06 | Separate medications table if regulatory requirement emerges |
| First-visit flow | Medium | S-01 (QA G-01) | Design must produce. Blocks full E2E verification. |
| WebSocket token in query param | Low | S-01 (QA G-09) | Switch to message-based auth. Deferred to DevOps. |
| Audit query endpoint pagination | Low | S-04 | Basic pagination implemented. Full-text search and date range filtering may need optimization for 7-year retention volume. |
| Import error recovery | Medium | S-10 | If a record fails to import, it's flagged but no automatic retry. Manual re-import via paper entry. |
