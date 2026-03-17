# Verification Runs — Complete (Rounds 1-10)

Runnable proof sequences. Each run proves one or more boxes end-to-end. These are not unit tests — they are scenario-level verification paths that walk the customer's story through the system.

---

## How to use this document

Each run is a sequence of API calls with setup, assertions, and teardown. They are ordered from the customer's perspective: the happy path first, then failure paths, then edge cases, then new capabilities.

Runs reference boxes they prove. A box is only proven when ALL runs that reference it pass.

R1 Runs (01-06) are updated where upstream changes affected them. New Runs (07-16) cover Rounds 2-10.

---

## Run 01: Happy Path — Returning Patient Recognized and Confirmed (UPDATED)

**Proves:** BOX-01, BOX-02, BOX-03, BOX-04, BOX-D2, BOX-E2, BOX-E3, BOX-E5, BOX-22, BOX-24, BOX-25, BOX-E6, BOX-E9

**R1 to R10 changes:** Added medications section (S-06). Added version-based finalization (S-07). Added location_id (S-05).

**Setup:**
```
Create location: {name: "Main Street Clinic"}

Create patient:
  first_name: "Maria", last_name: "Santos", dob: "1985-03-14"
  phone: "555-0199", email: "maria@test.com"

Create patient_data:
  address: {line1: "42 Oak Ave", city: "Portland", state: "OR", zip: "97201"}
    last_confirmed: 60 days ago
  insurance: {provider: "BlueCross", policy_number: "BC-55555", group_number: "G-10"}
    last_confirmed: 90 days ago
  allergies: {items: [{name: "Penicillin", severity: "moderate", reaction: "rash"}]}
    last_confirmed: 30 days ago
  medications: {items: [{drug_name: "Lisinopril", dosage: "10mg", frequency: "once daily", prescriber: "Dr. Smith"}], confirmed_empty: false}
    last_confirmed: 30 days ago

Create visit:
  patient_id, location_id, visit_date: 30 days ago, physician_id: any
```

**Sequence:**

```
STEP 1 — Search (BOX-01)
  GET /api/patients/search?q=Maria
  ASSERT: results contains patient with first_name "Maria", last_visit_date populated
  ASSERT: results[0].has_active_checkin == false

STEP 2 — Load summary
  GET /api/patients/{id}
  ASSERT: data_sections contains address, insurance, allergies, medications
  ASSERT: medications.is_stale == true (freshness_days=0, always stale)
  ASSERT: medications.required_every_visit == true
  ASSERT: has_active_checkin == false

STEP 3 — Create check-in (BOX-E5 precondition, BOX-E2, BOX-22)
  POST /api/checkins {patient_id, location_id, channel: "kiosk"}
  ASSERT: 201 Created
  ASSERT: response has access_token (64 chars)
  ASSERT: response has sections with 4 entries (address, insurance, allergies, medications)
  ASSERT: medications section has required_every_visit: true, is_stale: true
  ASSERT: version == 1
  STORE: session_id, access_token, version

STEP 4 — Concurrent prevention (BOX-E5)
  POST /api/checkins {patient_id, location_id, channel: "kiosk"}
  ASSERT: 409 Conflict
  ASSERT: response has existing_session_id == stored session_id

STEP 5 — Patient view (BOX-02, BOX-04, BOX-D2, BOX-22)
  GET /api/checkins/token/{access_token}
  ASSERT: patient_first_name == "Maria"
  ASSERT: response does NOT contain "Santos"
  ASSERT: sections.existing has 4 entries (including medications)
  ASSERT: sections.missing is empty
  ASSERT: medications has required_every_visit: true, confirmation_label populated
  ASSERT: can_complete == false

STEP 6 — Receptionist view (BOX-D2)
  GET /api/checkins/{session_id}
  ASSERT: patient_name contains "Maria Santos"
  ASSERT: sections contain original_value for each category including medications

STEP 7 — Confirm address (BOX-03)
  PATCH /api/checkins/token/{access_token}/sections/{address_section_id} {action: "confirm"}
  ASSERT: 200, status == "confirmed"

STEP 8 — Update insurance (BOX-03, BOX-E3 setup)
  PATCH /api/checkins/token/{access_token}/sections/{insurance_section_id}
    {action: "update", value: {provider: "Aetna", policy_number: "AE-99999", group_number: "G-200"}}
  ASSERT: 200, status == "updated"

STEP 9 — Verify staging (BOX-E3)
  GET /api/patients/{id}
  ASSERT: insurance value is STILL "BlueCross" — patient record unchanged

STEP 10 — Receptionist sees diff (BOX-D2)
  GET /api/checkins/{session_id}
  ASSERT: insurance section has original_value "BlueCross" AND confirmed_value "Aetna"

STEP 11 — Confirm allergies (BOX-03)
  PATCH /api/checkins/token/{access_token}/sections/{allergies_section_id} {action: "confirm"}
  ASSERT: 200, status == "confirmed"

STEP 12 — Attempt completion without medications (BOX-E6, BOX-22)
  POST /api/checkins/token/{access_token}/complete
  ASSERT: 400
  ASSERT: error == "medications_not_confirmed"

STEP 13 — Confirm medications (BOX-22, BOX-24, BOX-25)
  PATCH /api/checkins/token/{access_token}/sections/{medications_section_id}
    {action: "confirm_medications", value: {items: [{drug_name: "Lisinopril", dosage: "10mg", frequency: "once daily", prescriber: "Dr. Smith"}], confirmed_empty: false}}
  ASSERT: 200, status == "confirmed"
  ASSERT: can_complete == true

STEP 14 — Patient completes (BOX-04)
  POST /api/checkins/token/{access_token}/complete
  ASSERT: 200, status == "patient_complete"
  ASSERT: message contains "Maria"

STEP 15 — Finalize with version (BOX-E3, BOX-E9)
  GET /api/checkins/{session_id}
  STORE: current_version
  POST /api/checkins/{session_id}/finalize {expected_version: current_version}
  ASSERT: 200, status == "finalized"
  ASSERT: updates_applied contains insurance with old/new values

STEP 16 — Verify commit (BOX-E3)
  GET /api/patients/{id}
  ASSERT: insurance value is NOW "Aetna"
  ASSERT: insurance.last_confirmed is today
  ASSERT: address.last_confirmed is today
  ASSERT: allergies.last_confirmed is today
  ASSERT: medications.last_confirmed is today

STEP 17 — Verify audit (BOX-24)
  GET /api/admin/audit?patient_id={id}&category=medications
  ASSERT: audit entry exists with source:"checkin_confirm"
  ASSERT: audit entry for insurance has old_value "BlueCross", new_value "Aetna"

STEP 18 — Token expired (BOX-E2)
  GET /api/checkins/token/{access_token}
  ASSERT: 410 Gone

STEP 19 — New session allowed (BOX-E5)
  POST /api/checkins {patient_id, location_id, channel: "kiosk"}
  ASSERT: 201 Created
```

**Teardown:** Delete session, patient data, patient, location.

---

## Run 02: Recognition Failure — Fuzzy Search (UNCHANGED)

**Proves:** BOX-D1

Same as R1. S-10 extends fuzzy search to handle Riverside imports but does not change the test structure.

**Setup:**
```
Create patient: first_name: "Jane", last_name: "Doe", dob: "1985-03-14", phone: "555-0123"
```

**Sequence:**
```
STEP 1 — Standard search misses
  GET /api/patients/search?q=Jayne
  ASSERT: results do NOT contain the patient

STEP 2 — Fuzzy search finds
  GET /api/patients/search/fuzzy?name=Jayne&phone=555-0123
  ASSERT: results contain "Jane Doe", confidence > 0.5, matched_on includes "phone"

STEP 3 — Total failure, fallback
  GET /api/patients/search/fuzzy?name=Zzzzz&dob=2000-01-01
  ASSERT: results is empty
```

---

## Run 03: Partial Data — Missing Sections (UNCHANGED)

**Proves:** BOX-D3, BOX-02

Same as R1. Medications addition does not change the missing-data pattern — if a patient has no medications data, medications appears in the missing section.

---

## Run 04: Timeout and Recovery (UNBLOCKED — G-02 resolved)

**Proves:** BOX-E1, BOX-D8

**R1 status:** Blocked by gap G-02 (reinitiate API missing).
**R10 status:** UNBLOCKED. POST /api/checkins/{id}/reinitiate is now defined.

**Setup:**
```
Create patient with full data (address, insurance, allergies, medications).
Create location.
```

**Sequence:**
```
STEP 1 — Create check-in
  POST /api/checkins {patient_id, location_id, channel: "kiosk"}
  ASSERT: 201
  STORE: session_id, token_1

STEP 2 — Confirm one section
  PATCH /api/checkins/token/{token_1}/sections/{address_id} {action: "confirm"}
  ASSERT: 200, status == "confirmed"

STEP 3 — Update another section
  PATCH /api/checkins/token/{token_1}/sections/{insurance_id}
    {action: "update", value: {provider: "NewInsurer", ...}}
  ASSERT: 200, status == "updated"

STEP 4 — Simulate timeout
  (Set checkin_sessions.last_activity_at to now() - 6 minutes in test DB, or wait 5 minutes)

STEP 5 — Verify session state preserved
  GET /api/checkins/{session_id}  (receptionist endpoint)
  ASSERT: address section status == "confirmed"
  ASSERT: insurance section status == "updated"
  ASSERT: allergies section status == "pending"
  ASSERT: medications section status == "pending"

STEP 6 — Reinitiate
  POST /api/checkins/{session_id}/reinitiate
  ASSERT: 200
  ASSERT: response has new access_token (different from token_1)
  ASSERT: preserved_progress == true
  STORE: token_2

STEP 7 — Patient resumes with new token
  GET /api/checkins/token/{token_2}
  ASSERT: address section confirmed
  ASSERT: insurance section updated
  ASSERT: allergies section pending
  ASSERT: medications section pending

STEP 8 — Old token is dead
  GET /api/checkins/token/{token_1}
  ASSERT: 401 or 410
```

---

## Run 05: Staleness Flagging (UPDATED for medications)

**Proves:** BOX-02 (staleness), BOX-22 (medications always stale)

**Setup:**
```
Create patient with:
  address: last_confirmed = 400 days ago (stale, threshold 365)
  insurance: last_confirmed = 200 days ago (stale, threshold 180)
  allergies: last_confirmed = 1000 days ago (NOT stale, threshold null/never)
  medications: last_confirmed = 1 day ago (STALE, threshold 0 — always stale)
```

**Sequence:**
```
STEP 1 — Patient summary shows staleness
  GET /api/patients/{id}
  ASSERT: address.is_stale == true
  ASSERT: insurance.is_stale == true
  ASSERT: allergies.is_stale == false
  ASSERT: medications.is_stale == true (confirmed yesterday, still stale because threshold=0)

STEP 2 — Create check-in, patient view shows staleness
  POST /api/checkins {patient_id, location_id}
  GET /api/checkins/token/{token}
  ASSERT: address section has is_stale == true
  ASSERT: insurance section has is_stale == true
  ASSERT: allergies section has is_stale == false
  ASSERT: medications section has is_stale == true, required_every_visit == true

STEP 3 — Confirming stale data resets staleness (including medications)
  Confirm all sections. Finalize.
  GET /api/patients/{id}
  ASSERT: address.is_stale == false (last_confirmed is now today)
  ASSERT: medications.is_stale == true (STILL stale — 0 threshold means always stale for next visit)
```

---

## Run 06: Token Security (UNCHANGED)

**Proves:** BOX-E2

Same as R1. Extended scope covered by Run 09 (mobile token) and Run 10 (signed URLs for PHI).

---

## NEW RUNS (Rounds 2-10)

---

## Run 07: WebSocket and Polling Fallback

**Proves:** BOX-05, BOX-06, BOX-07, BOX-D4, BOX-D5

**Source:** S-02

**Setup:**
```
Create patient with full data. Create location. Create check-in session.
```

**Sequence:**
```
STEP 1 — WebSocket path: completion visibility (BOX-05)
  Connect receptionist to WebSocket: ws://host/ws/checkins/{sessionId}
  Patient completes all sections + POST .../complete
  MEASURE: time from patient's 200 response to receptionist's patient.complete event
  ASSERT: < 2 seconds

STEP 2 — Completion notification event (BOX-D5)
  ASSERT: WebSocket event payload includes completed_at

STEP 3 — Polling fallback (BOX-07)
  Disconnect WebSocket
  GET /api/checkins/{id}/poll
  ASSERT: 200 with session state, poll_interval_ms, connection_health:"polling"

STEP 4 — Queue works without WebSocket (BOX-07)
  GET /api/checkins/queue
  ASSERT: session visible with correct status
  Kill WebSocket server entirely
  GET /api/checkins/queue
  ASSERT: still works (pure REST)

STEP 5 — Server-ack gating (BOX-06)
  Patient confirms section
  ASSERT: PATCH returns 200 only after DB persist
  Simulate DB failure
  ASSERT: PATCH returns 500/503, NOT 200
```

---

## Run 08: Multi-Location Check-In

**Proves:** BOX-19, BOX-20, BOX-21, BOX-26, BOX-D11, BOX-D12

**Source:** S-05, S-07

**Setup:**
```
Create locations: Location A ("Main Street"), Location B ("Downtown")
Create patient with visit history at Location A.
```

**Sequence:**
```
STEP 1 — Cross-location search (BOX-19, BOX-20)
  From Location B: GET /api/patients/search?q={name}
  ASSERT: patient found (no location filter needed)
  GET /api/patients/{id}
  ASSERT: last_visit.location == "Main Street"

STEP 2 — Check-in at different location (BOX-20)
  POST /api/checkins {patient_id, location_id: B, channel: "kiosk"}
  ASSERT: 201. Session at Location B. All data available.

STEP 3 — Cross-location concurrent prevention (BOX-26)
  POST /api/checkins {patient_id, location_id: A, channel: "kiosk"}
  ASSERT: 409. Existing session info includes location: "Downtown"

STEP 4 — Queue location filtering (BOX-21, BOX-D12)
  Create another session (different patient) at Location A.
  GET /api/checkins/queue?location_id=A
  ASSERT: only Location A sessions
  GET /api/checkins/queue?all_locations=true
  ASSERT: sessions from both locations visible with location_name

STEP 5 — Race condition cross-location (BOX-26)
  Finalize existing session. Two simultaneous POSTs for same patient at A and B.
  ASSERT: exactly one 201, one 409
```

---

## Run 09: Mobile Pre-Check-In End-to-End

**Proves:** BOX-08, BOX-09, BOX-10, BOX-11, BOX-16, BOX-D6, BOX-D7, BOX-D8

**Source:** S-03

**Setup:**
```
Create patient with full data. Create location. Create appointment 20 hours from now.
Create pre-check-in link for patient/appointment.
```

**Sequence:**
```
STEP 1 — Link time window (BOX-09)
  GET /api/precheckin/{token}
  ASSERT: status:"active" (within 24h window)

STEP 2 — Zero data before verification (BOX-16)
  ASSERT: response contains clinic_name, appointment_date/time. NO patient data.

STEP 3 — Identity verification failure (BOX-11)
  POST /api/precheckin/{token}/verify {dob: "1990-01-01"} (wrong)
  ASSERT: 401, attempts_remaining: 2
  POST /api/precheckin/{token}/verify {dob: "1990-01-01"} (wrong)
  ASSERT: 401, attempts_remaining: 1
  POST /api/precheckin/{token}/verify {dob: "1990-01-01"} (wrong)
  ASSERT: 403, locked

STEP 4 — Lockout is permanent (BOX-11)
  POST /api/precheckin/{token}/verify {dob: correct}
  ASSERT: still 403

STEP 5 — New link, correct verification
  Create new pre-check-in link.
  POST /api/precheckin/{new_token}/verify {dob: correct}
  ASSERT: 200, checkin_token returned, checkin_url returned
  STORE: checkin_token

STEP 6 — Mobile check-in flow (BOX-08, BOX-D6)
  GET /api/checkins/token/{checkin_token}
  ASSERT: patient_first_name populated. channel:"mobile". Same section structure as kiosk.

STEP 7 — Complete all sections including medications
  Confirm address, insurance, allergies.
  Confirm medications: PATCH {action:"confirm_medications", value:{...}}
  POST .../complete
  ASSERT: 200

STEP 8 — Queue visibility (BOX-10)
  GET /api/checkins/queue
  ASSERT: session visible with channel:"mobile", status:"patient_complete"

STEP 9 — Partial pre-check-in (BOX-D8)
  Create another link, verify, confirm 2 of 4 sections, stop.
  Let session expire.
  Create new kiosk session for same patient.
  GET /api/checkins/token/{kiosk_token}
  ASSERT: previously confirmed sections show as confirmed. Pending sections remain.

STEP 10 — Rate limiting (BOX-11)
  Send 10 verification requests in 1 second from same IP.
  ASSERT: rate limited after 5th request (429)
```

---

## Run 10: Insurance Photo Upload and OCR

**Proves:** BOX-29, BOX-30, BOX-31, BOX-D17, BOX-D18, BOX-E7

**Source:** S-08

**Setup:**
```
Create patient. Create check-in session. Prepare test JPEG image of insurance card.
```

**Sequence:**
```
STEP 1 — Upload card image (BOX-29)
  POST /api/checkins/token/{t}/sections/{insuranceId}/upload
    {image: test.jpg, document_type: "insurance_card_front"}
  ASSERT: 202 Accepted
  ASSERT: upload_id returned, ocr_status:"processing"

STEP 2 — Poll for OCR result (BOX-E7)
  GET /api/checkins/token/{t}/sections/{insuranceId}/ocr/{upload_id}
  Poll every 2s, max 5 attempts.
  ASSERT: eventually ocr_status:"completed"
  ASSERT: extracted_fields contains provider, policy_number with confidence scores

STEP 3 — OCR does NOT auto-apply (BOX-30)
  GET /api/checkins/token/{t}
  ASSERT: insurance section status is still "pending" (not auto-updated)

STEP 4 — Patient verifies and commits
  PATCH .../sections/{insuranceId} {action: "update", value: {extracted + corrected fields}}
  ASSERT: 200, status:"updated"

STEP 5 — Receptionist sees card image (BOX-31)
  GET /api/checkins/{session_id}
  ASSERT: insurance section has card_images with thumbnail_url (signed URL)
  ASSERT: thumbnail_url works (GET returns image)

STEP 6 — Patient view does NOT have card image (BOX-31)
  GET /api/checkins/token/{t}
  ASSERT: insurance section does NOT contain card_images

STEP 7 — Signed URL expires (BOX-31)
  Wait 6 minutes.
  GET {thumbnail_url}
  ASSERT: 403 (expired)

STEP 8 — Manual fallback (BOX-D18)
  Create new session for another patient.
  PATCH .../sections/{insuranceId} {action: "update", value: {provider: "Manual", ...}}
  ASSERT: 200 (update works without any photo upload)

STEP 9 — Negative: corrupt file
  POST upload with empty/corrupt file
  ASSERT: error response (not 202)

STEP 10 — Negative: oversized file
  POST upload with >10MB file
  ASSERT: 413
```

---

## Run 11: Concurrent Finalization and Recovery

**Proves:** BOX-26, BOX-27, BOX-28, BOX-E9, BOX-O1, BOX-D15, BOX-D16

**Source:** S-07

**Setup:**
```
Create patient with full data. Create location.
```

**Sequence:**
```
STEP 1 — Concurrent blocking (BOX-26, BOX-D15)
  POST /api/checkins {patient_id, location_id}
  ASSERT: 201
  POST /api/checkins {patient_id, location_id}
  ASSERT: 409 with informative message (who, when, status, location)

STEP 2 — Version mismatch (BOX-27)
  Complete check-in flow (all sections confirmed, patient completes).
  GET /api/checkins/{id} -> store version
  POST /api/checkins/{id}/finalize {expected_version: 1} (stale version)
  ASSERT: 412 Precondition Failed

STEP 3 — Correct finalization (BOX-27, BOX-E9)
  POST /api/checkins/{id}/finalize {expected_version: current_version}
  ASSERT: 200

STEP 4 — Simulate concurrent finalization conflict (BOX-27, BOX-D16)
  (Via test fixture: insert second active session for same patient, bypassing unique index.)
  Complete both sessions.
  Finalize session A -> 200.
  Finalize session B -> 409 Conflict.
  ASSERT: 409 response includes winning_session and your_session with changes.
  ASSERT: session_conflicts record created.

STEP 5 — Conflict resolution (BOX-27)
  POST /api/checkins/{B}/resolve-conflict {resolution: "apply", sections_to_apply: ["address"]}
  ASSERT: 200. Patient address updated from losing session.

STEP 6 — Admin recovery (BOX-28)
  GET /api/admin/sessions/conflicts
  ASSERT: conflict visible.
  POST /api/admin/sessions/{B}/recover {sections: [{category: "allergies", value: {...}}]}
  ASSERT: 200. Patient allergies updated.
  GET /api/admin/audit
  ASSERT: recovery logged with reason.
```

---

## Run 12: Riverside Import, Dedup, and Merge

**Proves:** BOX-36, BOX-37, BOX-38, BOX-39, BOX-40, BOX-41, BOX-E8, BOX-D21, BOX-D22, BOX-D23

**Source:** S-10

**Setup:**
```
Create existing patient: "Jane Doe", DOB 1985-03-14, phone 555-0123.
Create location.
```

**Sequence:**
```
STEP 1 — Create import batch (BOX-36, BOX-D22)
  POST /api/admin/import/batches {source_system: "riverside_ehr", total_records: 3}
  ASSERT: 201, batch_id returned.

STEP 2 — Import records: one clean, one duplicate, one with minimal data
  POST /api/patients/bulk-import {batch_id, records: [
    {source_id: "RV-001", first_name: "Maria", last_name: "Rodriguez", dob: "1972-08-20", phone: "555-0456", data_sections: [...]},
    {source_id: "RV-002", first_name: "Jane M.", last_name: "Doe", dob: "1985-03-14", phone: "555-0123", data_sections: [...]},
    {source_id: "RV-003", first_name: "Tom", last_name: "Wilson", dob: "1960-01-01"}
  ]}
  ASSERT: RV-001 -> imported (no match)
  ASSERT: RV-002 -> duplicate_flagged, confidence > 0.8, candidate_id = existing Jane Doe
  ASSERT: RV-003 -> imported (minimal data OK per BOX-41: name + DOB, phone missing but dob counts)

STEP 3 — Idempotency (BOX-E8)
  POST /api/patients/bulk-import with same RV-001 source_id
  ASSERT: status:"already_imported". No duplicate created.

STEP 4 — Progress check (BOX-D22)
  GET /api/admin/import/batches/{batch_id}
  ASSERT: imported >= 2, duplicates_flagged >= 1

STEP 5 — Duplicate review (BOX-37, BOX-D21)
  GET /api/admin/import/duplicates?batch_id={id}&confidence_min=0.6
  ASSERT: RV-002 visible. match_signals include "exact_dob", "same_phone".

STEP 6 — Merge (BOX-38, BOX-D23)
  POST /api/admin/import/duplicates/{rv002}/resolve {
    resolution: "merge",
    target_patient_id: existing_jane_id,
    field_selections: {address: "source", insurance: "target", medications: "merge_both"}
  }
  ASSERT: 200. Merged.
  GET /api/patients/{jane_id}
  ASSERT: address = Riverside's. insurance = ours. medications = combined.
  ASSERT: provenance tagged on modified fields.

STEP 7 — Post-import recognition (BOX-40)
  Wait 3s (eventual consistency).
  GET /api/patients/search?q=Maria
  ASSERT: Maria Rodriguez found with is_imported: true
  GET /api/patients/{maria_id}
  ASSERT: provenance_note populated ("imported from Riverside")

STEP 8 — Paper record entry (BOX-41)
  POST /api/admin/import/paper-entry {first_name: "Only", last_name: "Name"}
  ASSERT: 422 (missing DOB and contact method)
  POST /api/admin/import/paper-entry {first_name: "John", last_name: "Smith", dob: "1960-05-12", phone: "555-0789"}
  ASSERT: 201

STEP 9 — Import doesn't block check-in (BOX-39)
  Start import batch of 10 records.
  Simultaneously: POST /api/checkins for existing patient -> ASSERT: 201, <500ms
  Simultaneously: GET /api/patients/search?q=Maria -> ASSERT: <200ms
```

---

## Run 13: Performance — 30 Concurrent Check-Ins

**Proves:** BOX-32, BOX-34, BOX-35

**Source:** S-09

**Requires:** Load test infrastructure.

**Setup:**
```
Create 30 unique patients with full data. Create location.
```

**Sequence:**
```
STEP 1 — Concurrent session creation
  In parallel: POST /api/checkins for each of 30 patients
  ASSERT: all 201, no errors

STEP 2 — Concurrent full flow
  For each of 30 sessions in parallel:
    GET /api/checkins/token/{t}
    PATCH confirm address
    PATCH confirm insurance
    PATCH confirm allergies
    PATCH confirm_medications
    POST complete
    POST finalize {expected_version}
  ASSERT: all complete without error

STEP 3 — Latency assertions (BOX-32)
  ASSERT: search p95 < 200ms
  ASSERT: section save p95 < 500ms
  ASSERT: finalization p95 < 1s

STEP 4 — Queue metrics (BOX-34)
  GET /api/checkins/queue
  ASSERT: stats.peak_state == "peak" (30 > 20 threshold)
  ASSERT: stats.active_count == 30

STEP 5 — Abandonment tracking (BOX-35)
  Create 5 additional sessions. Do NOT complete them. Wait for timeout.
  GET /api/checkins/queue
  ASSERT: stats.abandoned_today >= 5
```

---

## Run 14: Performance — Import Under Load

**Proves:** BOX-33, BOX-39

**Source:** S-09, S-10

**Requires:** Load test infrastructure.

**Setup:**
```
Create 30 patients at Location A, 30 at Location B. Full data. Two locations.
Prepare 100-record import batch.
```

**Sequence:**
```
STEP 1 — Baseline (no import)
  Run 30+30 concurrent check-in flows.
  Record: search p95, section save p95, finalization p95.

STEP 2 — With concurrent import (BOX-39)
  Start import batch of 100 records at 10/s.
  Simultaneously run 10 check-in flows.
  ASSERT: check-in latencies within 20% of baseline.
  ASSERT: no check-in errors.

STEP 3 — Pause import
  POST /batches/{id}/pause
  ASSERT: import stops. Check-in flows unaffected.

STEP 4 — Multi-location aggregate (BOX-33)
  30 at A + 30 at B simultaneously.
  ASSERT: no deadlocks. Connection pool <80%. Search p95 < 500ms.
```

---

## Run 15: HIPAA Compliance

**Proves:** BOX-12, BOX-13, BOX-15, BOX-16, BOX-18

**Source:** S-04

**Requires:** Browser automation (Playwright/Puppeteer) for client-side assertions.

**Setup:**
```
Create two patients (A and B). Create location. Create kiosk browser context.
```

**Sequence:**
```
STEP 1 — Session lifecycle with client purge (BOX-12, BOX-13)
  Create check-in for Patient A.
  Load S3P on kiosk browser: /checkin/{tokenA}
  BROWSER ASSERT: DOM contains patient_first_name
  Finalize session.
  BROWSER ASSERT: current URL is /welcome (S0)
  BROWSER ASSERT: DOM contains ZERO patient data elements
  BROWSER ASSERT: window.history.length == 1 (or back -> S0)
  BROWSER ASSERT: localStorage empty. sessionStorage empty.

STEP 2 — Cross-session isolation (BOX-12)
  Create check-in for Patient B.
  Load S3P on same kiosk browser: /checkin/{tokenB}
  BROWSER ASSERT: DOM contains Patient B's name. ZERO data from Patient A.
  BROWSER ASSERT: no autocomplete suggestions from Patient A's session.

STEP 3 — Token invalidation (BOX-12)
  GET /api/checkins/token/{tokenA}
  ASSERT: 410 Gone

STEP 4 — Access logging (BOX-15)
  GET /api/admin/audit?patient_id={A}
  ASSERT: audit entries for every mutation during Patient A's check-in.

STEP 5 — Minimum necessary (BOX-16)
  GET /api/checkins/token/{tokenB}
  ASSERT: first_name only. No last_name, no DOB, no full address.
  GET /api/precheckin/{link_token} (before verification)
  ASSERT: zero patient data in response.
```

---

## Run 16: Medication Lifecycle

**Proves:** BOX-22, BOX-23, BOX-24, BOX-25, BOX-E6, BOX-D13, BOX-D14

**Source:** S-06

**Setup:**
```
Create Patient X with 3 medications.
Create Patient Y with 0 medications.
Create location.
```

**Sequence:**
```
STEP 1 — Medications always stale (BOX-22)
  Finalize a check-in for Patient X with medications confirmed. last_confirmed = now.
  Immediately create new check-in.
  GET /api/checkins/token/{t}
  ASSERT: medications.is_stale == true (freshness_days=0)

STEP 2 — Server blocks completion without med confirmation (BOX-E6)
  Confirm address, insurance, allergies. Do NOT confirm medications.
  POST .../complete
  ASSERT: 400 medications_not_confirmed

STEP 3 — Variable-length: add and remove (BOX-23)
  PATCH .../sections/{medId} {action: "update", value: {items: [original 3 + 1 new], confirmed_empty: false}}
  ASSERT: 200, 4 medications stored.
  PATCH .../sections/{medId} {action: "update", value: {items: [3 remaining], confirmed_empty: false}}
  ASSERT: 200, 3 medications stored.

STEP 4 — Explicit confirmation (BOX-D13)
  PATCH .../sections/{medId} {action: "confirm_medications", value: {items: [3 current], confirmed_empty: false}}
  ASSERT: 200, status:"confirmed"
  POST .../complete
  ASSERT: 200

STEP 5 — Empty medication list (BOX-D14, Patient Y)
  Create check-in for Patient Y.
  GET /api/checkins/token/{t}
  ASSERT: medications section exists with items: [], confirmed_empty: false
  PATCH .../sections/{medId} {action: "confirm_medications", value: {items: [], confirmed_empty: true}}
  ASSERT: 200, status:"confirmed"

STEP 6 — Audit trail (BOX-24)
  Finalize Patient X's check-in.
  GET /api/admin/audit?patient_id={X}&category=medications
  ASSERT: audit entries exist. source:"checkin_confirm" or "checkin_update".
  ASSERT: old_value and new_value contain full medication lists.
  ASSERT: session_id in audit entry for traceability.
```

---

## Run Coverage Matrix (Complete)

| Run | Key Boxes Covered | Source |
|-----|-------------------|--------|
| 01 | BOX-01,02,03,04, D2, E2,E3,E5, 22,24,25, E6,E9 | S-01 (updated S-06,07) |
| 02 | BOX-D1 | S-01 |
| 03 | BOX-D3, BOX-02 | S-01 |
| 04 | BOX-E1, BOX-D8 | S-01 (unblocked R2+) |
| 05 | BOX-02 (staleness), BOX-22 | S-01 (updated S-06) |
| 06 | BOX-E2 | S-01 |
| 07 | BOX-05,06,07, D4,D5 | S-02 |
| 08 | BOX-19,20,21,26, D11,D12 | S-05, S-07 |
| 09 | BOX-08,09,10,11,16, D6,D7,D8 | S-03 |
| 10 | BOX-29,30,31, D17,D18, E7 | S-08 |
| 11 | BOX-26,27,28, E9, O1, D15,D16 | S-07 |
| 12 | BOX-36,37,38,39,40,41, E8, D21,D22,D23 | S-10 |
| 13 | BOX-32,34,35 | S-09 |
| 14 | BOX-33,39 | S-09, S-10 |
| 15 | BOX-12,13,15,16,18 | S-04 |
| 16 | BOX-22,23,24,25, E6, D13,D14 | S-06 |

**Boxes NOT covered by any run (by design):**
- BOX-04 (experience): API-level proof only. UX proof requires visual verification (gap G-01).
- BOX-14 (encryption at rest): Infrastructure verification, not API test.
- BOX-17 (breach incident response): Organizational process, not system behavior.
- BOX-E4 (eventual consistency): Time-dependent, covered by degradation signal S-01.
- BOX-O2 (search drift detection): Operational monitor, tested via signal S-01.
- BOX-O3 (concurrent invariant check): Operational monitor, tested via signal S-11.
- BOX-O4 (token scrubbing): Log scan, tested via signal S-04.
- BOX-O5 (session cleanup): Lifecycle test, tested via signal S-02.
- BOX-D9 (idle state), BOX-D10 (no intermediate states): Client-side rendering, covered by Run 15 browser assertions.
- BOX-D19 (no load state to patient): Client-side rendering under load.
- BOX-D20 (queue depth): Covered by Run 13 Step 4.

**Run dependencies:**
- Runs 01-06: independent, can run in parallel
- Run 07: independent
- Run 08: requires two locations
- Run 09: requires appointment system mock
- Run 10: requires OCR service (or mock)
- Run 11: requires test fixture to bypass unique index
- Run 12: requires migration service
- Runs 13-14: require load test infrastructure
- Run 15: requires browser automation
- Run 16: independent
