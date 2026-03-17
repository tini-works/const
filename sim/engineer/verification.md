# Verification Guide — Complete (Rounds 1-10)

How QA proves each box is matched. Evolved from S-01 verification (12 tests) to full coverage across all rounds.

---

## S-01 Boxes (unchanged from verification-s01.md, summarized)

### BOX-01: Returning patient recognized
Test: seed patient -> GET /patients/search -> assert found with last_visit_date.

### BOX-02: Previously collected data not re-asked
Test: seed patient with data -> create check-in -> GET /checkins/token/{t} -> assert sections.existing populated.

### BOX-03: Confirm or update, not re-enter
Test: PATCH with action:"confirm" -> assert status confirmed. PATCH with action:"update" -> assert confirmed_value. Negative: action:"fill" on existing data -> 422.

### BOX-04: Recognition experience
Test: seed patient "Maria" -> create check-in -> assert patient_first_name:"Maria". Assert no last_name in response.

### BOX-D1: Graceful failure
Test: fuzzy search -> assert confidence scores, matched_on. Fallback: create with merge_flag.

### BOX-D2: Two actor views
Test: same session -> GET /checkins/{id} shows full diff structure, GET /checkins/token/{t} shows first_name only.

### BOX-D3: Partial data
Test: patient with partial data -> assert existing/missing split in token response.

### BOX-E1: No data loss on timeout
Test: confirm 2 of 3 sections -> wait for timeout -> assert sections preserved -> reinitiate -> assert progress restored.

### BOX-E2: Token-scoped access
Test: token A can't access session B's sections. Token expires after finalization (410). Token expires after TTL.

### BOX-E3: Staged updates
Test: patient updates insurance -> GET /patients/{id} still shows old value -> finalize -> GET /patients/{id} shows new value.

### BOX-E4: Eventual consistency
Test: create patient -> wait 3s -> search -> assert found. Boundary: if not found after 5s, index sync broken.

### BOX-E5: Concurrent prevention
Test: POST /checkins twice for same patient -> first 201, second 409. Race condition: two simultaneous POSTs -> exactly one 201, one 409.

---

## S-02 Boxes

### BOX-05: Patient completion visible to receptionist within 2s

**What to prove:** When the patient taps "All Confirmed", the receptionist's view reflects completion within 2 seconds (WebSocket path).

**Test sequence (WebSocket path):**
1. Create session. Receptionist connects to WebSocket.
2. Patient completes all sections and POSTs /complete.
3. Measure: time from patient's 200 response to receptionist receiving `patient.complete` WebSocket event.
4. Assert: < 2 seconds.

**Test sequence (polling fallback):**
1. Create session. Kill WebSocket connection.
2. Patient completes all sections.
3. Receptionist polls: GET /checkins/{id}/poll.
4. Assert: poll returns status "patient_complete" within 10 seconds (polling interval).
5. Note: under polling, the 2s target does not apply. The BOX-05 fallback target is 10s.

**What would break it:** Event bus lag. WebSocket server dropping events. Test by monitoring event delivery latency.

---

### BOX-06: No false success to patient

**What to prove:** Patient does not see green checkmark unless the server has persisted the confirmation.

**Test sequence:**
1. Create session. Patient confirms a section.
2. Assert: PATCH returns 200 with status:"confirmed" ONLY after DB write succeeds.
3. Negative: simulate DB write failure (e.g., connection pool exhaustion).
4. Assert: PATCH returns 500 or 503. Client should show "trouble saving" message, NOT green checkmark.

---

### BOX-07: Receptionist has fallback queue view

**What to prove:** S5 queue works without WebSocket.

**Test sequence:**
1. Create 3 sessions. One pending, one in_progress, one patient_complete.
2. GET /checkins/queue — assert all 3 sessions visible with correct statuses.
3. This endpoint is pure REST — no WebSocket dependency.
4. Kill WebSocket server entirely. Repeat step 2. Assert: still works.

---

## S-03 Boxes

### BOX-08: Patient can pre-check-in from mobile

**Test sequence:**
1. Create pre-check-in link for a patient with an appointment tomorrow.
2. GET /precheckin/{token} — assert status:"active".
3. POST /precheckin/{token}/verify {dob: correct} — assert status:"verified", checkin_token returned.
4. GET /checkins/token/{checkin_token} — assert patient view works. channel:"mobile".
5. Complete all sections including medications.
6. POST .../complete — 200.
7. GET /checkins/queue — assert session visible with status "patient_complete", channel "mobile".

---

### BOX-09: Pre-check-in time window

**Test sequence:**
1. Create link with appointment 48 hours from now. GET /precheckin/{token} — assert status:"too_early".
2. Create link with appointment 20 hours from now. GET /precheckin/{token} — assert status:"active".
3. Create link with appointment in the past. GET /precheckin/{token} — assert status:"expired".
4. Complete a pre-check-in. GET /precheckin/{token} again — assert status:"completed".

---

### BOX-11: Identity verification required

**Test sequence:**
1. Create pre-check-in link.
2. POST /precheckin/{token}/verify {dob: wrong} — 401, attempts_remaining: 2.
3. POST /precheckin/{token}/verify {dob: wrong} — 401, attempts_remaining: 1.
4. POST /precheckin/{token}/verify {dob: wrong} — 403, locked.
5. POST /precheckin/{token}/verify {dob: correct} — still 403. Lockout is permanent.
6. Assert: pre_checkin_links.status = "locked". Audit trail contains 3 failed verification entries.

**Rate limit test:**
7. Send 10 verification requests in 1 second from same IP. Assert: rate limited after 5th request (429).

---

## S-04 Boxes

### BOX-12: No PHI cross-patient exposure

**What to prove:** After session termination, no patient data remains accessible on the client device.

**Test sequence:**
1. Create session. Load patient view on kiosk.
2. Finalize session.
3. Assert: access_token returns 410 (invalidated).
4. Assert: any cached API responses return 410 if replayed.
5. Client-side (manual/automated browser test): DOM contains zero patient data elements after transition to S0.
6. Browser back button shows S0 (history replaced), not previous patient screen.

**Cross-session isolation:**
7. Create session for Patient A. Finalize. Create session for Patient B.
8. Assert: Patient B's view contains zero data from Patient A. No autocomplete suggestions from Patient A's session.

---

### BOX-13: Screen clearing enforced

**What to prove:** Transition to S0 is programmatic, not advisory.

**Test sequence (browser automation):**
1. Create session, load S3P on kiosk browser.
2. Trigger session timeout (5 min inactivity).
3. Assert: browser is now showing S0. Not S3P with a timeout overlay.
4. Assert: window.history length is 1 (or back button goes to S0).
5. Open browser dev tools: no patient data in localStorage, sessionStorage, or IndexedDB.

---

### BOX-14: Encryption at rest

**Verification:** Infrastructure-level. DevOps verifies PostgreSQL encryption at rest (AES-256). Object Storage server-side encryption enabled. Engineer provides: confirmation that no patient data is stored in unencrypted temporary files, logs, or caches.

---

### BOX-15: HIPAA access logging

**Test sequence:**
1. Create session. Patient confirms sections. Receptionist finalizes.
2. GET /admin/audit?patient_id={id} — assert audit entries exist for every data mutation.
3. Create pre-check-in link. Submit 3 wrong DOBs (lockout).
4. GET /admin/audit — assert failed verification attempts are logged with timestamp and IP.

---

### BOX-16: Minimum necessary

**Test sequence:**
1. Create session. GET /checkins/token/{t} — assert response contains patient_first_name ONLY. No last_name, no full DOB, no full address, no SSN, no internal IDs.
2. PATCH .../sections/{s} — assert response contains only section status, not full patient record.
3. Pre-check-in link landing (GET /precheckin/{t}) — assert zero patient data before verification.

---

## S-05 Boxes

### BOX-19: Patient data location-independent

**Test sequence:**
1. Create patient at Location A with visit history.
2. Search at Location B: GET /patients/search?q={name} — assert patient found regardless of location.
3. GET /patients/{id} from Location B — assert full record returned.

---

### BOX-20: Check-in works at any location

**Test sequence:**
1. Patient last visited Location A.
2. Receptionist at Location B: POST /checkins {patient_id, location_id: B} — assert 201.
3. Session created at Location B. All data available.

---

### BOX-21: Location is context

**Test sequence:**
1. Create sessions at Location A and Location B (different patients).
2. GET /checkins/queue?location_id=A — assert only Location A sessions.
3. GET /checkins/queue?all_locations=true — assert both locations' sessions visible.
4. Assert location_name appears on each session record.

---

## S-06 Boxes

### BOX-22: Medication list collected every visit

**Test sequence:**
1. Create patient with medications. Create check-in.
2. GET /checkins/token/{t} — assert medications section present with is_stale:true, required_every_visit:true.
3. Confirm address, insurance, allergies. Do NOT confirm medications.
4. POST .../complete — assert 400 error: medications_not_confirmed.
5. Confirm medications: PATCH {action:"confirm_medications", value:{items:[...]}}.
6. POST .../complete — 200.

**Always-stale verification:**
7. Create patient. Finalize check-in with medications confirmed (last_confirmed = now).
8. Immediately create new check-in.
9. GET /checkins/token/{t} — assert medications section is_stale: true (freshness_days = 0).

---

### BOX-23: Variable-length medications

**Test sequence:**
1. Patient with 0 medications. Create check-in. Assert medications section exists with empty items array.
2. Patient adds 3 medications via section update. Assert all 3 stored.
3. Patient removes 1. Assert 2 remain.
4. Patient with 15 medications. Assert all 15 displayed and manageable.

---

### BOX-24: Medication confirmation auditable

**Test sequence:**
1. Patient confirms medications (no changes).
2. GET /admin/audit?patient_id={id}&category=medications — assert audit entry with source:"checkin_confirm", old_value = new_value.
3. Patient modifies medications (add one, remove one).
4. Assert audit entry with old_value (original list) and new_value (modified list).
5. Assert audit entry includes session_id for traceability.

---

### BOX-25: Medications integrated in check-in

**Test sequence:**
1. Create check-in. Assert medications section is one of the sections alongside address, insurance, allergies.
2. Medications appears in the section list with display_order after allergies, before completion.
3. can_complete=true only when all sections INCLUDING medications are resolved.

---

## S-07 Boxes

### BOX-26: Concurrent prevention airtight (cross-location)

**Test sequence:**
1. Receptionist at Location A: POST /checkins {patient_id: X, location_id: A} — 201.
2. Receptionist at Location B: POST /checkins {patient_id: X, location_id: B} — 409.
3. Assert: 409 includes existing session info with location:"Location A".
4. Finalize session at A. Now: POST /checkins {patient_id: X, location_id: B} — 201.

**Race condition (same as S-01 but cross-location):**
5. Two simultaneous POSTs for same patient at different locations.
6. Assert: exactly one 201, one 409. Database unique partial index enforces this.

---

### BOX-27: Finalization conflict-safe

**Test sequence — version mismatch:**
1. Create session. Read version = 1.
2. Patient completes. Version increments to N.
3. POST /checkins/{id}/finalize {expected_version: 1} — assert 412 (version mismatch).
4. POST /checkins/{id}/finalize {expected_version: N} — 200.

**Test sequence — concurrent finalization (simulated):**
1. Deliberately insert a second active session (bypass unique index via test fixture).
2. Finalize session A — 200. Patient data updated.
3. Finalize session B — 409 Conflict.
4. Assert: 409 response contains winning session's changes and losing session's changes.
5. Assert: session_conflicts record created.

---

### BOX-28: Lost data recoverable

**Test sequence:**
1. Trigger a finalization conflict (as in BOX-27 test).
2. GET /admin/sessions/conflicts — assert conflict appears.
3. POST /admin/sessions/{id}/recover {sections: ["address"]} — assert patient address updated.
4. GET /admin/audit — assert recovery logged with reason.

---

## S-08 Boxes

### BOX-29: Patient can photograph insurance card

**Test sequence:**
1. Create session. Insurance section exists.
2. POST .../sections/{insuranceId}/upload {image: test.jpg, document_type:"insurance_card_front"} — 202.
3. Assert: upload_id returned. ocr_status:"processing".
4. GET .../ocr/{upload_id} — poll until ocr_status:"completed".
5. Assert: extracted_fields contains provider, policy_number, etc.

**Negative test:**
6. Upload corrupt/empty file — assert appropriate error response.
7. Upload file >10MB — assert 413 response.

---

### BOX-30: OCR requires patient verification

**Test sequence:**
1. Complete photo upload and OCR.
2. Assert: OCR result is returned to patient for review, NOT auto-applied.
3. Patient must explicitly PATCH section with extracted values (action:"update").
4. Without explicit PATCH, insurance section stays "pending" (OCR alone doesn't complete it).

---

### BOX-31: Card images are PHI

**Test sequence:**
1. Upload card image. Assert: stored in Object Storage with encryption.
2. Direct access to storage key (s3://...) without signed URL — assert denied.
3. GET /checkins/{id} as receptionist — assert card_images include thumbnail_url (signed, 5-min expiry).
4. Wait 6 minutes. Access thumbnail_url again — assert 403 (expired).
5. GET /checkins/token/{t} as patient — assert card images NOT included in patient view (patient already has the card).

---

## S-09 Boxes

### BOX-32: 30 concurrent check-ins without degradation

**Load test:**
1. Create 30 concurrent check-in sessions at one location.
2. For each: search (GET /patients/search) + create check-in + confirm 4 sections + complete + finalize.
3. Assert: all complete without error.
4. Assert: search latency p95 < 200ms. Section save latency p95 < 500ms. Finalization p95 < 1s.

---

### BOX-33: 60 concurrent across all locations

**Load test:**
1. Create 30 sessions at Location A and 30 at Location B simultaneously.
2. Run full check-in flow for all 60.
3. Assert: no errors, no deadlocks.
4. Assert: connection pool utilization < 80%.
5. Assert: search latency p95 < 500ms (relaxed from single-location).

---

### BOX-34: Degraded performance visible to staff

**Test sequence:**
1. Create 25 sessions at one location.
2. GET /checkins/queue — assert stats.peak_state:"peak". Assert stats include active_count, avg_duration_seconds.
3. Assert: peak_state thresholds: normal (<10), busy (10-20), peak (20+).

---

### BOX-35: Patient loss measurable

**Test sequence:**
1. Create 5 sessions. Let 2 expire without any patient action.
2. GET /checkins/queue — assert stats.abandoned_today >= 2.
3. Sessions with status "pending" that never reached "in_progress" before timeout are counted as abandoned.

---

## S-10 Boxes

### BOX-36: Riverside records importable

**Test sequence:**
1. POST /admin/import/batches {source_system:"riverside_ehr", total_records: 10}.
2. POST /admin/import/bulk-import with 10 normalized records.
3. Assert: all 10 imported (or flagged as duplicates).
4. GET /admin/import/batches/{id} — assert progress updated.

---

### BOX-37: Duplicates detected before import

**Test sequence:**
1. Seed existing patient: "Jane Doe", DOB 1985-03-14.
2. Import record: "Jane M. Doe", DOB 1985-03-14, same phone.
3. Assert: import_record.status = "duplicate_flagged". confidence > 0.8.
4. Assert: duplicate_candidate_id = existing patient's ID.
5. GET /admin/import/duplicates — assert flagged record visible with match_signals.

---

### BOX-38: Merge preserves data

**Test sequence:**
1. Existing patient has: address (ours), insurance (ours).
2. Riverside record has: address (theirs), insurance (theirs), medications (theirs).
3. POST .../duplicates/{id}/resolve {resolution:"merge", field_selections: {address:"source", insurance:"target", medications:"merge_both"}}.
4. GET /patients/{merged_id} — assert:
   - address = Riverside's (source selected)
   - insurance = ours (target selected)
   - medications = Riverside's (merged — we had none)
5. Assert: provenance on each field records source.
6. Assert: both original records archived, not deleted.
7. Audit trail records merge with source record IDs.

---

### BOX-39: Import doesn't degrade live system

**Test sequence:**
1. Start import batch of 100 records at 10/second.
2. Simultaneously run 10 concurrent check-in flows (normal operations).
3. Assert: check-in flow latencies NOT degraded (compare to baseline).
4. POST .../batches/{id}/pause — assert import stops.
5. Check-in flows continue unaffected.
6. POST .../batches/{id}/resume — import continues.

---

### BOX-40: Post-import Riverside patients recognized

**Test sequence:**
1. Import a Riverside patient: "Maria Rodriguez".
2. Wait 3 seconds (eventual consistency).
3. GET /patients/search?q=Maria — assert Riverside patient in results with is_imported:true.
4. GET /patients/{id} — assert provenance_note populated.
5. Create check-in for this patient. GET /checkins/token/{t} — assert provenance_note in response.

---

### BOX-41: Paper records minimum viable data set

**Test sequence:**
1. POST /admin/import/paper-entry with only first_name and last_name (missing DOB and contact) — assert 422 validation error.
2. POST with first_name, last_name, dob, phone — assert 201 (minimum met).
3. POST with first_name, last_name, dob, address (no phone) — assert 201 (address counts as contact).
4. Assert: record with flags:["incomplete_insurance"] is created and flagged for follow-up.

---

## DevOps Boxes (Engineer provides test cooperation)

### BOX-O1: Finalization atomic
Integration test: start finalization, kill service mid-transaction. Assert: patient record entirely updated or entirely unchanged. Engineer implements: single DB transaction wrapping all finalization writes.

### BOX-O2: Search index drift detectable
Engineer cooperates: intentionally stop search consumer. Assert: BOX-O2 reconciliation process detects drift within 10 minutes.

### BOX-O3: Concurrent session invariant
Engineer cooperates: insert duplicate session via direct SQL. Assert: BOX-O3 background check detects violation within 2 minutes.

### BOX-O4: Token never in logs
Engineer cooperates: create session with known token. Search all logs for token value. Assert: zero matches.

### BOX-O5: Session cleanup
Engineer cooperates: create session 25 hours ago. Assert: archived within 1 hour by cleanup job.

---

## End-to-End Verification Path (Full 10-Round Scope)

The complete customer journey, all rounds combined:

```
1. Patient exists with prior data including medications
   -> BOX-01 verified (recognized)

2. Receptionist at Location B searches for patient (last visited Location A)
   -> BOX-01 + BOX-19 + BOX-20 verified (cross-location search works)

3. S2 shows patient with provenance note (if imported from Riverside)
   -> BOX-40 verified (imported patient recognized)

4. S2 shows medications always stale (amber)
   -> BOX-22 verified (medications flagged every visit)

5. Receptionist clicks "Begin Check-in" — no concurrent session
   -> BOX-E5 + BOX-26 verified (concurrent prevention)

6. Patient device loads S3P with pre-filled data
   -> BOX-02 verified (no re-asking)

7. Patient confirms address, updates insurance via photo
   -> BOX-03, BOX-29, BOX-30 verified (confirm/update/photo)

8. Patient reviews and confirms medications (mandatory)
   -> BOX-22, BOX-23, BOX-24, BOX-25 verified

9. Patient taps "All Confirmed" — server acknowledges
   -> BOX-06 verified (no false success)

10. Receptionist sees completion within 2s on S3R (or 10s via polling)
    -> BOX-05 verified

11. Receptionist finalizes — atomic transaction
    -> BOX-E3, BOX-O1, BOX-E9 verified

12. Kiosk transitions to S0, DOM purged
    -> BOX-12, BOX-13 verified

13. Next patient: zero PHI from previous session
    -> BOX-12 verified (cross-session isolation)
```

**Variant paths tested independently:**
- Mobile pre-check-in (Flow 12): BOX-08, BOX-09, BOX-11
- WebSocket failure (Flow 10): BOX-05, BOX-07
- Concurrent finalization (Flow 15): BOX-27, BOX-28
- Import/merge (Flows 17-18): BOX-36 through BOX-41
- Performance (Flow 19): BOX-32 through BOX-35
