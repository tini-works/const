# Degradation Signals — Complete (Rounds 1-10)

How we know when a proof has broken, gone stale, or stopped holding. Each signal is observable, measurable, and has a response.

---

## What this document is

Proofs are not one-time events. A proof that passed yesterday can fail today because:
- Upstream changed something and didn't flag it
- Infrastructure drifted
- A dependency rotted
- Load changed behavior
- New features introduced side effects

This document defines the signals that indicate a proof is degrading.

---

## R1 Signals (S-01) — Updated

### S-01: Search index drift

**What breaks:** BOX-01 (patient recognized), BOX-E4 (eventual consistency), BOX-40 (Riverside patients searchable)

**Signal:** Time between `patient.updated` or `patient.imported` event emission and the patient appearing in search results exceeds 5 seconds.

**How to detect:**
- Continuous: create a synthetic patient every hour, measure time to searchability. Alert if >5s.
- Reactive: if a receptionist searches for a patient they just registered and gets no results, log the lag.
- **S-10 addition:** During Riverside import, monitor search index rebuild time for imported patients. Alert if imported patient not searchable within 10s of import completion.

**Response:** Investigate search index consumer lag. Check event bus health. Check Elasticsearch cluster state. S-10: check if bulk import is monopolizing index rebuild capacity.

---

### S-02: Check-in session leak

**What breaks:** BOX-E5 (concurrent prevention), BOX-E1 (timeout behavior), BOX-26 (cross-location prevention), BOX-O5 (session cleanup)

**Signal:** `checkin_sessions` with status `pending` or `in_progress` and `expires_at` in the past.

**How to detect:**
- Scheduled: every 15 minutes, count sessions where `status IN ('pending','in_progress') AND expires_at < now()`. If count > 0, the expiration job is not running or is failing.
- **S-07 addition:** Also check for sessions with status `patient_complete` and `expires_at` in the past — these are completed sessions that were never finalized by the receptionist.

**Response:** Run the session expiry job manually. Investigate why automatic expiry failed. Check cron/scheduler health.

**Secondary signal:** if a receptionist tries to start a check-in and gets a 409 for a session that should have expired, the leak is causing a user-visible problem. **S-07 validated this exact scenario.**

---

### S-03: WebSocket disconnect without event delivery

**What breaks:** BOX-D2 (receptionist live view), BOX-05 (2s visibility), BOX-D4 (connection health), BOX-D5 (completion notification), all real-time flows

**Signal:** Patient completes actions via REST API, but receptionist's S3R view does not update.

**How to detect:**
- Server-side: track event emission count vs. WebSocket delivery count per session. If events emitted > events delivered, something dropped.
- Client-side: receptionist UI polls `GET /api/checkins/{id}/poll` as a fallback every 10 seconds. If the REST response differs from the last WebSocket-received state, WebSocket delivery failed.
- **S-02 addition:** Connection health indicator tracks state transitions: connected -> heartbeat_missed -> disconnected. Log all state transitions. Alert if >10% of sessions experience disconnection.

**Response:** Check WebSocket server health. Check event bus consumer for the WebSocket server. Check heartbeat statistics. Reconnect client.

---

### S-04: Token appearing in logs

**What breaks:** BOX-E2 (token security), BOX-O4 (token scrubbing), BOX-16 (minimum necessary)

**Signal:** Access token strings found in application logs, access logs, or proxy logs.

**How to detect:**
- Periodic log scan: search for patterns matching 64-character alphanumeric strings in access logs, proxy logs, application logs. Cross-reference with known token hashes.
- Automated: deploy a log scanner that flags any line containing a string matching the token format.
- **S-03 addition:** Also scan for pre-check-in link tokens in logs.

**Response:** Identify the log source. Fix the logging configuration to exclude the token. Rotate any tokens that were logged (invalidate and reissue).

---

### S-05: Snapshot-record divergence

**What breaks:** BOX-E3 (staged updates), data integrity

**Signal:** At finalization, the `original_value` in `checkin_sections` does not match the current `patient_data.value` for a section that was only confirmed (not updated).

**Why this matters:** If a receptionist edits the patient record (Flow 20) while a check-in session is active for the same patient, the snapshot is stale. BOX-E5/BOX-26 prevents concurrent *check-in sessions*, but it does not prevent a receptionist from editing the record via `PATCH /patients/{id}` while a session is active.

**How to detect:**
- At finalization: compare `checkin_sections.original_value` with current `patient_data.value` for each section. If they differ and the section was only "confirmed" (not "updated"), the patient confirmed stale data.

**Response:** Flag the confirmation as potentially invalid. The patient confirmed data they thought was current, but it was already changed. Engineer's architecture doc mentions conflict flagging at finalization time.

---

### S-06: Staleness computation drift

**What breaks:** BOX-02 (no re-asking, stale data flagged), BOX-22 (medications always stale)

**Signal:** `data_categories.freshness_days` values change without QA being notified.

**How to detect:**
- Track `data_categories` table as a configuration artifact. Any change should emit an event or be auditable.
- The proof suite for staleness-dependent behavior should read `freshness_days` from the API and adjust assertions dynamically. Hardcoded threshold values in tests will break when policy changes.
- **S-06 addition:** Medications must ALWAYS have freshness_days=0. Any change to this is a compliance violation. Alert if medications freshness_days != 0.

**Response:** Re-run staleness-related proofs with new threshold values. For medications: if freshness_days changed from 0, escalate to PM immediately — this breaks the S-06 mandate.

---

### S-07: Audit trail gap

**What breaks:** BOX-E3 (staged updates audit), BOX-15 (HIPAA access logging), BOX-24 (medication audit)

**Signal:** A `patient_data` row has a `last_confirmed` or value change with no corresponding row in `patient_data_audit`.

**How to detect:**
- Scheduled: compare `patient_data` rows modified in the last 24 hours against `patient_data_audit` entries. Every mutation should have a corresponding audit row.
- On finalization: count `checkin_sections` with status `updated` or `missing_filled`. Count audit rows created during finalization. They should match.
- **S-10 addition:** After import/merge, verify audit rows with source="import" or source="merge" exist for every affected patient_data row.

**Response:** Investigate the code path that mutated `patient_data` without creating an audit entry. Fix immediately — audit gaps in healthcare systems are HIPAA violations.

---

### S-08: Upstream document change without re-verification

**What breaks:** Any proof that depends on a specific upstream claim

**Signal:** A file in `sim/pm/` or `sim/design/` or `sim/engineer/` or `sim/devops/` is modified, but no corresponding update appears in the proof registry.

**How to detect:**
- Git-level: track modification timestamps of all files in `sim/`. When a file changes, flag all proofs that reference boxes from that vertical as **suspect** until re-verified.
- Manual: at each sanity check, compare file modification dates across verticals. If upstream changed after proof registry was last updated, the registry may be stale.

**Response:** Re-audit the modified document. Update the proof registry. Re-run affected proofs.

---

## NEW Signals (Rounds 2-10)

### S-09: WebSocket fallback polling latency

**What breaks:** BOX-05 (completion visibility), BOX-07 (fallback queue)

**Source:** S-02

**Signal:** Polling fallback (GET /checkins/{id}/poll) response time exceeds 2 seconds, or poll interval increases beyond 15 seconds under load.

**How to detect:**
- Monitor poll endpoint p95 latency. Alert if >2s.
- Monitor poll_interval_ms returned by server. Alert if >15000ms.
- Track how many sessions are in polling mode (amber connection indicator). If >20% of active sessions are polling instead of WebSocket, the WebSocket infrastructure is degraded.

**Response:** Investigate WebSocket server capacity. Scale WebSocket server instances. Check if connection limit (200/instance) is being hit.

---

### S-10: Pre-check-in link abuse

**What breaks:** BOX-11 (identity verification), BOX-16 (minimum necessary)

**Source:** S-03

**Signal:** Multiple pre-check-in links locked (3 failed DOB attempts) within a short time window, especially from similar IP ranges.

**How to detect:**
- Scheduled: every hour, count pre_checkin_links where status="locked" and locked within the last hour. Alert if >5 (unusual — legitimate patients rarely fail 3 times).
- Real-time: rate limit endpoint already returns 429. Log 429 responses. Cluster by IP range.

**Response:** If coordinated attack suspected: temporarily increase verification requirements (add a CAPTCHA before DOB entry, or require phone verification). Notify PM.

---

### S-11: Session conflict rate

**What breaks:** BOX-26 (concurrent prevention), BOX-27 (conflict-safe finalization)

**Source:** S-07

**Signal:** `session_conflicts` table grows — any conflict is a sign that concurrent prevention has a gap.

**How to detect:**
- Scheduled: count `session_conflicts` created in the last 24 hours. Alert if >0.
- Correlate with BOX-O3 (concurrent session invariant checker). If O3 catches a violation AND a conflict appears, the root cause is likely DB pool exhaustion.

**Response:** Zero conflicts is the target. Any conflict means the prevention layer leaked. Investigate: was it pool exhaustion? A race condition? A direct SQL bypass? Fix the root cause.

---

### S-12: OCR pipeline degradation

**What breaks:** BOX-29 (photo capture), BOX-30 (verification), BOX-E7 (async fallback)

**Source:** S-08

**Signal:** OCR processing time exceeds 10 seconds (patient sees spinner too long), or OCR failure rate exceeds 20%.

**How to detect:**
- Monitor `document_uploads` table: avg time from uploaded_at to ocr_status="completed". Alert if avg >10s.
- Monitor OCR failure rate: count(status="failed") / count(total) per day. Alert if >20%.
- Monitor cloud OCR API health directly (provider status page, API response times).

**Response:** If slow: check cloud OCR API latency. Consider adding a second OCR provider as failover. If high failure rate: check image quality distribution — are patients uploading blurry photos? May need better camera guidance (BOX-D17 UX concern).

---

### S-13: Peak load metrics

**What breaks:** BOX-32 (30 concurrent), BOX-33 (60 concurrent), BOX-34 (degradation visible), BOX-35 (patient loss measurable)

**Source:** S-09

**Signal:** API p95 latencies exceed targets, connection pool utilization exceeds 80%, or abandoned session count spikes.

**How to detect:**
- Continuous monitoring:
  - Search p95 >200ms (single location) or >500ms (multi-location): alert
  - Section save p95 >500ms: alert
  - Finalization p95 >1s: alert
  - DB connection pool utilization >80%: alert
  - WebSocket connections >160 per instance (80% of 200 limit): alert
- Queue metrics:
  - GET /checkins/queue stats.peak_state="peak": log but do not alert (expected during rush hours)
  - stats.abandoned_today >10: alert (patients are leaving)
  - stats.avg_duration_seconds >600 (10 min): alert (check-ins are taking too long)

**Response:**
- Immediate: scale Check-in Service horizontally. Increase read replica connections.
- Short-term: direct patients to mobile pre-check-in (S-03) to spread load temporally.
- Investigate: is the load from legitimate traffic or from import (S-10)? If import, pause import via POST /batches/{id}/pause.

---

### S-14: Post-import duplicate creation rate

**What breaks:** BOX-37 (duplicates detected), BOX-38 (merge preserves data)

**Source:** S-10

**Signal:** After Riverside import, new patients are created via S1b "Start as New" that are later discovered to be duplicates of imported Riverside patients.

**How to detect:**
- Track patients with merge_flag="possible_duplicate" created AFTER the import date. Cross-reference against imported patients.
- Scheduled: weekly, run fuzzy search for all patients created post-import with merge_flag against imported patient set. Flag new matches.

**Response:** If duplicate creation rate is high (>5% of imported patients have later duplicates), the dedup algorithm missed them (see gap G-14 — name changes). Consider proactive outreach to Riverside patients for identity confirmation.

---

### S-15: Import degrading live system

**What breaks:** BOX-39 (import doesn't degrade)

**Source:** S-10

**Signal:** During active import, live check-in flow latencies increase compared to pre-import baseline.

**How to detect:**
- A/B comparison: record API latency baselines before import starts. During import, compare live check-in latencies against baseline. Alert if >20% degradation.
- Monitor import rate: if actual rate exceeds configured rate limit (default 10/s), throttling is broken.
- Monitor peak_state during import: if peak_state goes from "normal" to "busy" purely from import load (no actual patients checking in), import is too aggressive.

**Response:** Pause import immediately. Reduce import_rate_limit. Resume only during off-peak hours.

---

### S-16: Client-side PHI remnants

**What breaks:** BOX-12 (no PHI exposure), BOX-13 (screen clearing enforced)

**Source:** S-04

**Signal:** After session termination, any of the following persist: patient data in DOM, patient data in localStorage/sessionStorage, patient data accessible via browser back button, autocomplete data from previous patient.

**How to detect:**
- Automated browser test (Playwright/Puppeteer): after session finalization, inspect DOM, storage, history. Assert all clean.
- Run this test in CI for every client deployment.
- Manual spot check: periodically test on actual kiosk hardware to catch device-specific caching behavior.

**Response:** If PHI remnants detected: hotfix SessionPurge module. This is a HIPAA incident if it happens in production with patient data. Treat as P0.

---

## Signal Summary

| ID | What it detects | Check frequency | Severity if triggered | Since |
|----|----------------|----------------|----------------------|-------|
| S-01 | Search index lag | Hourly (automated) | Medium | R1 |
| S-02 | Session expiry failure | Every 15 min (automated) | High | R1 |
| S-03 | WebSocket event loss | Continuous (client fallback) | Medium | R1 |
| S-04 | Token in logs | Daily (log scan) | High | R1 |
| S-05 | Snapshot divergence at finalize | Per finalization (inline) | High | R1 |
| S-06 | Staleness policy change | On config change | Low (High if medications) | R1 |
| S-07 | Missing audit rows | Daily (automated) | High | R1 |
| S-08 | Upstream doc change | Per commit / daily sanity | Medium | R1 |
| S-09 | Polling fallback latency | Continuous | Medium | R2 |
| S-10 | Pre-check-in link abuse | Hourly | Medium | R3 |
| S-11 | Session conflict rate | Daily | Critical | R7 |
| S-12 | OCR pipeline degradation | Continuous | Medium | R8 |
| S-13 | Peak load metrics | Continuous | High | R9 |
| S-14 | Post-import duplicate rate | Weekly | Medium | R10 |
| S-15 | Import degrading live system | During import (continuous) | High | R10 |
| S-16 | Client-side PHI remnants | Per client deploy (CI) | Critical | R4 |

## Signal-to-Box Coverage

Every box must have at least one degradation signal. This matrix confirms coverage.

| Signal | Boxes Covered |
|--------|--------------|
| S-01 | BOX-01, BOX-E4, BOX-40 |
| S-02 | BOX-E1, BOX-E5, BOX-26, BOX-O5 |
| S-03 | BOX-D2, BOX-05, BOX-D4, BOX-D5 |
| S-04 | BOX-E2, BOX-O4, BOX-16 |
| S-05 | BOX-E3, BOX-02 |
| S-06 | BOX-02, BOX-22 |
| S-07 | BOX-E3, BOX-15, BOX-24 |
| S-08 | All proofs (meta-signal) |
| S-09 | BOX-05, BOX-07 |
| S-10 | BOX-11, BOX-16 |
| S-11 | BOX-26, BOX-27 |
| S-12 | BOX-29, BOX-30, BOX-E7 |
| S-13 | BOX-32, BOX-33, BOX-34, BOX-35 |
| S-14 | BOX-37, BOX-38 |
| S-15 | BOX-39 |
| S-16 | BOX-12, BOX-13 |

**Boxes without dedicated degradation signals (covered by adjacent signals or by nature):**
- BOX-03, BOX-04: covered by S-05 (snapshot divergence) and S-08 (upstream change)
- BOX-06: covered by S-09 (polling fallback — same server-ack mechanism)
- BOX-08, BOX-09, BOX-10: covered by S-10 (link abuse) and S-02 (session leak)
- BOX-14, BOX-17, BOX-18: infrastructure boxes, not monitorable via application signals
- BOX-D1..D23: Design boxes are upstream claims, covered by S-08 (upstream change detection) and their corresponding PM/Eng box signals
- BOX-E6: covered by S-06 (staleness policy — medications config)
- BOX-E8: covered by S-14 (import duplicates)
- BOX-E9, BOX-O1: covered by S-07 (audit trail — finalization atomicity failures create audit gaps)
- BOX-O2: self-monitoring signal (search index drift = S-01)
- BOX-O3: self-monitoring signal (concurrent invariant = S-11)
- BOX-19, BOX-20, BOX-21: location boxes, covered by S-01 (search) and S-02 (session lifecycle)
- BOX-23, BOX-25: structural (JSONB array, data_categories), no runtime degradation mode
- BOX-28: covered by S-11 (conflict rate)
- BOX-31: covered by S-04 (token/PHI in logs) and S-12 (OCR pipeline)
- BOX-36, BOX-41: import boxes, covered by S-15 (import degradation)
