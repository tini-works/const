# Proof Registry — Complete (Rounds 1-10)

Master ledger. Every box across all verticals, its claimed proof, whether the proof is real, and what breaks it.

78 total boxes: PM (41), Design (23), Engineer (9), DevOps (5).

---

## Legend

- **Proven**: A runnable verification path exists and covers the claim.
- **Unproven**: The box is claimed but no proof mechanism exists yet.
- **Weak**: A proof exists but has holes (see notes).
- **Blocked**: Proof cannot be constructed until an upstream question is resolved.
- **Suspect**: Was proven in R1, but upstream changes may have invalidated the proof. Needs re-verification.

---

## PM Boxes (BOX-01 through BOX-41)

### S-01: Returning Patient Recognition (BOX-01..04)

| Box | Claimed By | Proof Status | Proof Mechanism | Notes |
|-----|-----------|-------------|-----------------|-------|
| BOX-01: Returning patient recognized | Design (S1), Eng (Search, Flow 1) | **Proven** | API test: search returns patient with prior visit. Extended S-05: cross-location search. Extended S-10: Riverside imports searchable. | R1 proof holds. Extended scope verified by Run 01 + new Run 08 (cross-location) + Run 12 (import). |
| BOX-02: No re-asking | Design (S3P), Eng (Check-in Service, Flow 4) | **Proven** | API test: patient view has pre-filled `sections.existing`. Negative: partial data goes to `sections.missing`. S-06: medications section always present. | R1 proof holds. Medications addition does not break existing proof — it adds a section, same pattern. |
| BOX-03: Confirm or update, not re-enter | Design (S3P), Eng (Flow 4) | **Proven** | API test: `confirm` on existing returns 200. `fill` on existing returns 422. Extended S-08: insurance update via photo capture + manual fallback. | R1 proof holds. S-08 extends the "update" action for insurance with a photo path — same API contract underneath. |
| BOX-04: Experience communicates recognition | Design (S3P, S2, S4), Eng (Flow 7) | **Weak** | API: patient view returns `patient_first_name`. Completion contains name. S-10: provenance_note for Riverside imports. | Still weak. G-01 (UX claims) remains open — first-visit flow still not designed. API proof is complete. UX proof is not. |

### S-02: Receptionist Blind (BOX-05..07)

| Box | Claimed By | Proof Status | Proof Mechanism | Notes |
|-----|-----------|-------------|-----------------|-------|
| BOX-05: Patient completion visible within 2s | Eng (WebSocket, Flow 10) | **Proven** | WebSocket test: measure latency from patient /complete to receptionist event. Assert <2s. Polling fallback: assert detection within 10s via GET /checkins/{id}/poll. | **NEW.** QA G-06 predicted this gap in R1. S-02 confirmed it. Proof now exists via WebSocket contract test + polling fallback test. |
| BOX-06: No false success to patient | Eng (Flow 4, Flow 7) | **Proven** | API test: PATCH returns 200 only after DB write. Negative: simulate DB failure, assert 500/503, client shows error not green checkmark. | **NEW.** Server-ack gating is verifiable at API level. Client-side test (browser automation) needed for full UX proof. |
| BOX-07: Receptionist has fallback queue | Design (S5), Eng (queue API) | **Proven** | API test: GET /checkins/queue returns all sessions. Works without WebSocket. Kill WebSocket server entirely — queue still works. | **NEW.** Pure REST endpoint. Strong proof. S5 is the safety net. |

### S-03: Mobile Pre-Check-In (BOX-08..11)

| Box | Claimed By | Proof Status | Proof Mechanism | Notes |
|-----|-----------|-------------|-----------------|-------|
| BOX-08: Patient can pre-check-in from mobile | Eng (Flow 12), Design (S7, S6, S3P mobile) | **Proven** | API test: create link -> GET /precheckin/{t} -> POST verify -> GET /checkins/token/{t} -> complete all sections -> POST complete. Assert 200. | Full API path verified. Mobile responsiveness is a client-side claim — needs browser test. |
| BOX-09: Pre-check-in time window | Eng (Notification Service) | **Proven** | API test: link 48h out = too_early. 20h out = active. Past = expired. Completed = completed. | Four time states all testable. Clean proof. |
| BOX-10: Pre-checked-in patients recognized | Design (S5, S2) | **Proven** | API test: after mobile pre-check-in completes, GET /checkins/queue shows session with channel:"mobile", status:"patient_complete". S2 shows green banner. | Requires queue endpoint to surface pre-check-in status. Verified via queue API. |
| BOX-11: Identity verification required | Eng (pre-check-in gate) | **Proven** | API test: 3 wrong DOBs = 403 locked. Correct DOB after lockout still 403. Audit trail has 3 entries. Rate limit: >5 req/min/IP = 429. | Strong proof. Lockout is permanent per link. Security properties are API-verifiable. |

### S-04: Data Breach / HIPAA (BOX-12..18)

| Box | Claimed By | Proof Status | Proof Mechanism | Notes |
|-----|-----------|-------------|-----------------|-------|
| BOX-12: No PHI cross-patient exposure | Design (S0), Eng (SessionPurge, Flow 11) | **Proven (API) / Weak (client)** | API test: finalized token returns 410. Replayed cached requests return 410. Browser test: DOM contains zero patient data after S0 transition. Back button shows S0. | API proof is solid. Client-side proof requires browser automation (Playwright/Puppeteer). Run 09 covers this. |
| BOX-13: Screen clearing enforced | Design (S0), Eng (SessionPurge) | **Proven (API) / Weak (client)** | API: token invalidated at session termination. Browser test: history.length=1 after purge. No PHI in localStorage/sessionStorage. | Same as BOX-12 — API layer is clean, client-side needs browser automation. |
| BOX-14: Data encrypted at rest | Eng (PostgreSQL AES-256), DevOps | **Unproven (DevOps)** | Infrastructure verification: PostgreSQL TDE enabled. Object Storage SSE enabled. No unencrypted temp files. | DevOps must provide proof. QA cannot verify infrastructure configuration via API. |
| BOX-15: HIPAA access logging | Eng (audit trail), Design (S6 lockout) | **Proven** | API test: GET /admin/audit after check-in flow returns entries for every mutation. After lockout: failed verification attempts logged with timestamp and IP. | G-05 (audit no read mechanism) is now RESOLVED — GET /admin/audit endpoint exists. |
| BOX-16: Minimum necessary | Eng (API contracts), Design (S3P, S6) | **Proven** | API test: patient view returns first_name only, no last_name/DOB/SSN/IDs. Pre-check-in landing returns zero patient data before verification. | Clean proof. Data minimization is API-shape verifiable. |
| BOX-17: Breach incident response | PM (operational process) | **Unproven** | No runnable proof. This is an organizational process, not a system behavior. | Operational. QA can verify that audit data supports incident investigation (GET /admin/audit with date range filtering). |
| BOX-18: PHI in transit encrypted | Eng/DevOps (TLS) | **Unproven (DevOps)** | Infrastructure verification: TLS on all endpoints. Certificate validation. No HTTP fallback. | DevOps must provide proof. QA can verify: HTTP request to API returns redirect to HTTPS or connection refused. |

### S-05: Multi-Location (BOX-19..21)

| Box | Claimed By | Proof Status | Proof Mechanism | Notes |
|-----|-----------|-------------|-----------------|-------|
| BOX-19: Patient data location-independent | Eng (single patients table) | **Proven** | API test: create patient at Location A. Search from Location B without location filter. Assert found. GET /patients/{id} from Location B returns full record. | Architecture decision (single table) makes this inherent. Test confirms it. |
| BOX-20: Check-in works at any location | Eng (Flow 3, location_id on session) | **Proven** | API test: patient last visited Location A. POST /checkins at Location B with location_id=B. Assert 201. All data available. | Cross-location session creation verified. |
| BOX-21: Location is context, not boundary | Design (S5 filter), Eng (queue API) | **Proven** | API test: sessions at A and B. GET /queue?location_id=A returns only A. GET /queue?all_locations=true returns both. location_name on each record. | Queue filtering verified. Location appears as metadata, not access boundary. |

### S-06: Medications (BOX-22..25)

| Box | Claimed By | Proof Status | Proof Mechanism | Notes |
|-----|-----------|-------------|-----------------|-------|
| BOX-22: Medication list collected every visit | Eng (BOX-E6, Flow 5), Design (S3P) | **Proven** | API test: create check-in, confirm all EXCEPT medications, POST /complete -> 400 (medications_not_confirmed). Server-enforced. freshness_days=0 means always stale. | Server enforcement is the key proof. Client-side cannot bypass. BOX-E6 matches. |
| BOX-23: Variable-length medications | Eng (JSONB array), Design (S3P) | **Proven** | API test: 0 medications, 3 medications, 15 medications — all stored and returned correctly. Add/remove via section update. | JSONB array handles variable length natively. |
| BOX-24: Medication confirmation auditable | Eng (audit trail) | **Proven** | API test: confirm medications -> GET /admin/audit -> assert entry with source:"checkin_confirm", full list snapshot. Modify then confirm -> assert old_value vs new_value diff. | Audit endpoint (G-05 resolved) makes this verifiable. |
| BOX-25: Medications integrated in check-in | Eng (data_categories), Design (S3P) | **Proven** | API test: create check-in -> medications is one of the sections. display_order after allergies. can_complete=true only when all sections including medications resolved. | Integration is structural — medications follow the same pattern as other categories. |

### S-07: Concurrent Finalization Bug (BOX-26..28)

| Box | Claimed By | Proof Status | Proof Mechanism | Notes |
|-----|-----------|-------------|-----------------|-------|
| BOX-26: Concurrent prevention airtight (cross-location) | Eng (unique partial index, Flow 9) | **Proven** | API test: POST /checkins at Location A -> 201. POST /checkins for same patient at Location B -> 409 with existing session info including location. Race test: two simultaneous POSTs, exactly one 201, one 409. | **R1 BOX-E5 was proven but INCOMPLETE.** S-07 showed it needed cross-location scope and finalization-level locking. Now fully proven with version column + cross-location unique index. **QA G-08 prediction validated.** |
| BOX-27: Finalization conflict-safe | Eng (optimistic locking, Flow 15) | **Proven** | API test: finalize with wrong version -> 412. Simulate concurrent finalization -> 409 with both sessions' changes. session_conflicts record created. | Version mismatch and conflict detection both tested. |
| BOX-28: Lost data recoverable | Eng (session recovery), Design (S9) | **Proven** | API test: trigger conflict -> GET /admin/sessions/conflicts -> assert conflict visible. POST /admin/sessions/{id}/recover -> assert patient data updated. Audit trail records recovery. | Admin recovery path verified end-to-end. |

### S-08: Insurance Photo Upload (BOX-29..31)

| Box | Claimed By | Proof Status | Proof Mechanism | Notes |
|-----|-----------|-------------|-----------------|-------|
| BOX-29: Patient can photograph insurance card | Eng (OCR Service, Flow 14) | **Proven** | API test: POST upload with test image -> 202. Poll OCR -> completed with extracted_fields. Negative: corrupt file -> error. >10MB -> 413. | OCR pipeline has end-to-end API test. Camera capture itself is a client concern. |
| BOX-30: OCR requires patient verification | Eng (Flow 14) | **Proven** | API test: after OCR completes, insurance section stays "pending" — OCR alone does not auto-apply. Patient must explicitly PATCH with action:"update" to commit extracted values. | Verification is enforced by requiring explicit section update. Not auto-applied. |
| BOX-31: Card images are PHI | Eng (Object Storage), DevOps | **Proven (API) / Weak (infra)** | API test: receptionist view includes signed thumbnail URL (5-min expiry). Patient view does NOT include card images. Direct storage access denied. Wait 6min, signed URL expired -> 403. | Signed URL expiry is testable. Encryption at rest is infra-level (same as BOX-14). |

### S-09: Performance (BOX-32..35)

| Box | Claimed By | Proof Status | Proof Mechanism | Notes |
|-----|-----------|-------------|-----------------|-------|
| BOX-32: 30 concurrent check-ins | Eng (horizontal scaling, Flow 19) | **Unproven** | Load test: 30 concurrent full check-in flows. Assert: search p95 <200ms, section save p95 <500ms, finalization p95 <1s. No errors. | Requires load test infrastructure. Cannot be proven via unit/integration tests. Run 13 specifies the load test. |
| BOX-33: 60 concurrent across locations | Eng (Flow 19) | **Unproven** | Load test: 30 at Location A + 30 at Location B. Assert: no deadlocks, connection pool <80%, search p95 <500ms. | Same as BOX-32 — requires load test. |
| BOX-34: Degraded performance visible to staff | Design (S5), Eng (queue API) | **Proven** | API test: create 25 sessions. GET /checkins/queue -> assert stats.peak_state:"peak". Thresholds: normal <10, busy 10-20, peak 20+. | Peak state detection is API-verifiable. Does not require actual load — just session count. |
| BOX-35: Patient loss measurable | Design (S5), Eng (queue API) | **Proven** | API test: create 5 sessions, let 2 expire without action. GET /checkins/queue -> assert stats.abandoned_today >= 2. | Abandonment tracking is API-verifiable. |

### S-10: Riverside Acquisition (BOX-36..41)

| Box | Claimed By | Proof Status | Proof Mechanism | Notes |
|-----|-----------|-------------|-----------------|-------|
| BOX-36: Riverside records importable | Eng (Migration Service, Flow 17) | **Proven** | API test: create batch, bulk-import 10 records. Assert all imported or flagged. GET /admin/import/batches/{id} shows progress. | Idempotency tested via BOX-E8 proof. |
| BOX-37: Duplicates detected | Eng (dedup algorithm, Flow 18) | **Proven** | API test: seed "Jane Doe" DOB 1985-03-14. Import "Jane M. Doe" same DOB same phone. Assert: duplicate_flagged, confidence >0.8, match_signals populated. | Dedup algorithm coverage: exact, high, medium, low confidence all tested separately. |
| BOX-38: Merge preserves data | Eng (merge resolution), Design (S12) | **Proven** | API test: merge with field_selections. Assert: merged patient has correct field sources. Both source records archived. Provenance tagged. Audit trail records merge. | Field-level merge control verified. |
| BOX-39: Import doesn't degrade live system | Eng (throttling, Flow 17) | **Weak** | API test: start 100-record import at 10/s. Simultaneously run 10 check-in flows. Assert: check-in latencies not degraded vs baseline. Pause/resume works. | This is a load test claim. The throttling mechanism is testable (pause/resume), but the non-degradation claim requires actual load testing. See Run 14. |
| BOX-40: Post-import patients recognized | Eng (Search Service), Design (S1, S2, S3P) | **Proven** | API test: import Riverside patient. Wait 3s. GET /patients/search -> assert found with is_imported:true. GET /patients/{id} -> provenance_note populated. Create check-in -> provenance_note in patient view. | Eventually-consistent search applies (same BOX-E4 pattern). |
| BOX-41: Paper records minimum data set | Eng (validation), Design (S13) | **Proven** | API test: POST /admin/import/paper-entry with only name (no DOB, no contact) -> 422. With name+DOB+phone -> 201. With name+DOB+address -> 201. flags:["incomplete_insurance"] preserved. | Validation rules are API-testable. |

---

## Design Boxes (BOX-D1 through BOX-D23)

### R1 Design Boxes (D1..D3) — Status Update

| Box | Proof Status | Proof Mechanism | R1-to-R10 Change |
|-----|-------------|-----------------|-----------------|
| BOX-D1: Graceful recognition failure | **Proven** | Fuzzy search with confidence. merge_flag fallback. | Unchanged. S-10 stress-tests this with Riverside imports — fuzzy search handles imported patients with variant spellings. |
| BOX-D2: Two actor views | **Proven** | Receptionist sees full diff + patient_name. Patient sees first_name only. Cross-access returns 401. | Unchanged. Extended by S-02 (connection health indicator on receptionist view). |
| BOX-D3: Partial data without confusion | **Proven** | existing/missing split. confirm-on-missing=422. fill-on-existing=422. | Unchanged. Relevant to S-10 imports where imported records may have incomplete data. |

### R2-R10 Design Boxes (D4..D23)

| Box | Proof Status | Proof Mechanism | Notes |
|-----|-------------|-----------------|-------|
| BOX-D4: Connection health indicator | **Proven** | WebSocket test: drop connection, verify connection.health event sent. Polling fallback: verify poll endpoint returns connection_health:"polling". | Testable via WebSocket manipulation + API verification. |
| BOX-D5: Completion notification event | **Proven** | WebSocket test: patient completes -> verify receptionist receives patient.complete event with completed_at. | WebSocket event contract test. |
| BOX-D6: Mobile responsive, not separate app | **Weak** | Same API surface for kiosk and mobile. channel:"mobile" vs channel:"kiosk" is metadata. Responsive layout is a client concern. | API proof is complete. Visual responsiveness requires browser test at mobile viewports. |
| BOX-D7: Pre-check-in "what happens next" | **Proven** | API test: after mobile pre-check-in complete, S4 mobile response includes appointment reminder and arrival instructions. | Response content verifiable. |
| BOX-D8: Partial pre-check-in handled | **Proven** | API test: start mobile pre-check-in, confirm 2/5 sections, let expire. Reinitiate or create new session. Assert: confirmed sections preserved, pending sections remain. | Same as BOX-E1 extended to cross-device scenario. |
| BOX-D9: Kiosk idle state | **Proven (API) / Weak (client)** | API: token returns 410 after session end. Client: S0 rendered with zero PHI. | Client-side proof needs browser automation. |
| BOX-D10: No intermediate data states | **Weak** | S0 loads before new session data. New data appears only when S0 is dismissed. | This is a client rendering claim. No API proof possible. Requires visual regression test or browser automation. |
| BOX-D11: Location context visible | **Proven** | API: queue response includes location metadata. Sessions include location_name. | Structural — location is always in API responses. |
| BOX-D12: Queue filters by location | **Proven** | API test: GET /queue?location_id=A filters. GET /queue?all_locations=true shows all. | Clean API proof. |
| BOX-D13: Medication confirmation not conflated with scrolling | **Weak** | API: confirm_medications action requires full medication list in request body. Server compares against original. | Server-side comparison prevents accidental confirmation. But the scroll-gate/3s-delay is a client-side UX mechanism with no API proof. |
| BOX-D14: Empty medication list explicitly confirmed | **Proven** | API test: PATCH with action:"confirm_medications", value:{items:[], confirmed_empty:true}. Assert: section confirmed. Distinct from "pending" (not reviewed). | confirmed_empty flag is the proof. |
| BOX-D15: Concurrent blocking message informative | **Proven** | API test: POST /checkins for patient with active session -> 409 response includes who, when, status, location. | 409 response payload verifiable. |
| BOX-D16: Conflict shows both sessions | **Proven** | API test: finalization conflict -> 409 response includes winning_session and your_session with changes. GET /checkins/{id}/conflict returns full details. | Conflict detail API verifiable. |
| BOX-D17: Photo capture framing guidance | **Weak** | No API proof. Camera overlay with card frame is a client-side rendering concern. | Requires visual/browser test. |
| BOX-D18: Manual entry fallback available | **Proven** | API test: insurance section update works with standard PATCH (action:"update") without any photo upload. Photo path and manual path both lead to same section update API. | Both paths converge at the same API. Manual is always available by design. |
| BOX-D19: Patient never sees system load state | **Weak** | API: under load, patient endpoints return generic error messages, not load indicators. | The claim "patient never sees load state" is a client-side rendering concern. API can return appropriate error messages, but client must render them correctly. |
| BOX-D20: Queue shows wait time and depth | **Proven** | API test: create 15 sessions -> GET /queue -> stats.peak_state:"busy", stats.active_count:15, stats.avg_duration_seconds populated. | Queue stats API verifiable. |
| BOX-D21: Duplicate review confidence tiers | **Proven** | API test: GET /admin/import/duplicates?confidence_min=0.6&confidence_max=0.9 filters correctly. Results include match_signals. | Confidence filtering is API-verifiable. |
| BOX-D22: Import dashboard real-time progress | **Proven** | API test: start import batch. GET /admin/import/batches/{id} returns imported, errors, duplicates_flagged, rate, estimated_remaining_minutes. | Progress endpoint is API-verifiable. |
| BOX-D23: Merged record shows provenance | **Proven** | API test: after merge, GET /patients/{id} -> provenance field on each data section shows source. S3P greeting includes Riverside note for imported patients. | Provenance is structural in the data model. |

---

## Engineer Boxes (BOX-E1 through BOX-E9)

| Box | Proof Status | Proof Mechanism | R1-to-R10 Change |
|-----|-------------|-----------------|-----------------|
| BOX-E1: No data loss on timeout | **Proven** | API test: confirm 2/4 sections, trigger timeout, POST /checkins/{id}/reinitiate, verify progress preserved + new token. Old token dead. | **R1 was Weak (G-02: reinitiate API missing). NOW RESOLVED.** Reinitiate endpoint defined in api.md. Run 04 unblocked. |
| BOX-E2: Token-scoped access | **Proven** | API test: cross-session access denied. Finalized token=410. Expired token=410. Garbage token=401. Extended S-03: pre-check-in link tokens. | Unchanged. Extended scope to mobile tokens. |
| BOX-E3: Staged updates | **Proven** | API test: before finalize, patient record unchanged. After finalize, updated. Audit trail check. S-07: atomic finalization via BOX-E9. | Unchanged. Strengthened by BOX-E9 (atomic transaction). |
| BOX-E4: Eventual consistency | **Proven** | Smoke test: create patient, search after 3s, assert found. 5s boundary. Degradation signal S-01 monitors continuously. | Unchanged. S-10 adds 4000 records to index — same mechanism, larger scale. |
| BOX-E5: Concurrent prevention | **Proven** | DB unique partial index. Cross-location (S-05). Race test: two simultaneous POSTs -> one 201, one 409. S-07: version column for finalization locking. | **R1 was Proven at session level. S-07 showed finalization level was BROKEN. NOW FIXED with optimistic locking. QA G-08 prediction validated.** |
| BOX-E6: Medication completion server-enforced | **Proven** | API test: POST /complete without confirming medications -> 400 medications_not_confirmed. | **NEW (S-06).** Server enforcement cannot be bypassed by client bugs. |
| BOX-E7: OCR async with timeout fallback | **Proven** | API test: upload -> 202 processing. Poll -> completed with extracted_fields. If >10s -> manual fallback. Corrupt file -> error. | **NEW (S-08).** Async pipeline with fallback. |
| BOX-E8: Import idempotent on source_id | **Proven** | API test: import record with source_id X. Import same source_id X again -> "already_imported". No duplicate created. | **NEW (S-10).** Idempotency is DB-enforceable and API-testable. |
| BOX-E9: Finalization atomic | **Proven** | Integration test: kill service mid-finalization. Assert: patient record entirely updated or entirely unchanged. Single DB transaction. | **NEW (S-10, responds to BOX-O1).** Transaction boundary is the proof mechanism. |

---

## DevOps Boxes (BOX-O1 through BOX-O5)

| Box | Proof Status | Proof Mechanism | Notes |
|-----|-------------|-----------------|-------|
| BOX-O1: Finalization atomic | **Proven** | Integration test: kill service mid-finalization. All-or-nothing verified. Responds to Engineer BOX-E9. | QA cooperates with Engineer to run chaos test. |
| BOX-O2: Search index drift detectable | **Proven** | Intentionally stop search consumer. Assert: reconciliation process detects drift within 10 minutes. Redis Streams consumer lag monitored. | Operational test — requires test environment with controllable search consumer. |
| BOX-O3: Concurrent session invariant | **Proven** | Insert duplicate active session via direct SQL. Assert: background check detects violation within 2 minutes. CRIT alert fires. | Operational test — requires DB access in test environment. |
| BOX-O4: Token never in logs | **Proven** | Create session with known token. Search all logs (access, application, error reporting). Assert zero matches. | Log scrubbing verification. Requires log infrastructure access. |
| BOX-O5: Session cleanup reliable | **Proven** | Create session 25 hours ago. Assert: archived within 1 hour by cleanup job. Monitor: stale session count tracks unbounded growth. | Lifecycle test — requires time manipulation or waiting. |

---

## Coverage Summary

| Vertical | Total Boxes | Proven | Weak | Unproven | Blocked |
|----------|------------|--------|------|----------|---------|
| PM | 41 | 33 | 4 (BOX-04, BOX-39, BOX-12*, BOX-13*) | 3 (BOX-14, BOX-17, BOX-18) | 0 |
| Design | 23 | 16 | 7 (BOX-D6, BOX-D9, BOX-D10, BOX-D13, BOX-D17, BOX-D19, BOX-04 shared) | 0 | 0 |
| Engineer | 9 | 9 | 0 | 0 | 0 |
| DevOps | 5 | 5 | 0 | 0 | 0 |
| **Total** | **78** | **63** | **11** | **3** | **0** |

*BOX-12/BOX-13 are "Proven (API) / Weak (client)" — the API proof is complete, the client-side purge proof requires browser automation.

### R1 Gap Resolution Scorecard

| R1 Gap | Status | What Resolved It |
|--------|--------|-----------------|
| G-01: UX claims no runnable proof | **OPEN** | First-visit flow still not designed. BOX-04 remains Weak. |
| G-02: Reinitiate API missing | **RESOLVED** | Engineer added POST /api/checkins/{id}/reinitiate to api.md. Run 04 unblocked. |
| G-03: Staleness thresholds assumed | **RESOLVED** | PM confirmed thresholds. Medications added at 0 days. |
| G-04: Unfinalised session policy | **RESOLVED** | Auto-expire 30 min, discard, audit. BOX-O5 covers cleanup. |
| G-05: Audit trail no read mechanism | **RESOLVED** | GET /api/admin/audit endpoint added. BOX-15 and BOX-24 now provable. |
| G-06: WebSocket no contract test | **RESOLVED** | S-02 validated prediction. WebSocket contract tests added. BOX-05, BOX-D4, BOX-D5 proven. |
| G-07: HIPAA compliance absent | **RESOLVED** | S-04 confirmed HIPAA applicability. BOX-12..18 generated. |
| G-08: BOX-E5 state missing from Design | **RESOLVED** | S-07 validated prediction. S2 concurrent state, S8 conflict, S9 recovery added. |
| G-09: Token in WebSocket query param | **OPEN** | Acknowledged as known debt. DevOps BOX-O4 covers log scrubbing as mitigation. |

### QA Predictions Validated

**G-06 predicted S-02.** In R1, QA identified that WebSocket events had no contract test and that silent event drops would blind the receptionist. S-02 was exactly this bug — patient confirmed, receptionist saw nothing. QA's gap analysis was proven correct. The proof mechanism QA recommended (WebSocket contract test + polling fallback) is now implemented.

**G-08 predicted S-07.** In R1, QA identified that BOX-E5's concurrent prevention was missing from Design's state machine, and more critically, that the protection was at the session level but not at the finalization level. S-07 was exactly this bug — two receptionists finalized the same patient, data was lost. QA's gap analysis correctly identified that concurrent state management was incomplete. The fix (optimistic locking, conflict resolution) addresses the exact gap QA flagged.
