# Flows — Complete (Rounds 1-10)

Every flow maps Design's state machine to exact API calls, data mutations, and events. Evolved from 9 flows (S-01) to 20 flows (S-01 through S-10).

---

## Flow 1: Patient Lookup (Happy Path)

*Origin: S-01 | Modified: S-05, S-09, S-10*

**Screens:** S5 -> S1 -> S2
**Boxes:** BOX-01 (patient recognized), BOX-20 (cross-location search), BOX-40 (Riverside patients searchable)

```
1. Receptionist opens S1 from S5 (Check-in Queue)
   -> Client renders search bar, focus in field

2. Receptionist types in search bar (S1)
   -> Client debounces (300ms)
   -> GET /api/patients/search?q={input}&location_id={current} [or no location filter]
   <- PatientSummary[] with last_visit_date, last_visit_location, has_active_checkin, source_system
   -> S-09: if response >500ms, show loading indicator. If >5s, timeout error.
   -> S-10: results may include imported Riverside patients with is_imported badge

3. Receptionist selects a patient from results
   -> GET /api/patients/{id}
   <- Full patient record with data_sections[], staleness flags, provenance_note
   -> Client renders S2 (Patient Summary)
   -> S-07: if has_active_checkin == true, render concurrent session state on S2
```

---

## Flow 2: Assisted Search (Recognition Failure)

*Origin: S-01 | Modified: S-10*

**Screens:** S1 -> S1b -> S2
**Boxes:** BOX-D1 (graceful failure), BOX-37 (duplicate detection at point of care)

```
1. Standard search returns no match / patient says "that's not me"
   -> Receptionist clicks "Can't Find Record"
   -> Client renders S1b (Assisted Search)

2. Receptionist enters alternative criteria
   -> GET /api/patients/search/fuzzy?name=...&phone=...&insurance_id=...
   <- Results with confidence scores, matched_on, source_system, source_id

3a. Match found:
   -> Select patient -> GET /api/patients/{id} -> S2

3b. No match:
   -> "Start as New, Merge Later"
   -> POST /api/patients {merge_flag: "possible_duplicate"}
   -> Record enters duplicate-review queue
```

S-10 note: During Riverside migration, fuzzy search cross-references `source_id` from imported records. A Riverside patient visiting for the first time may not match on name spelling but may match on phone or DOB.

---

## Flow 3: Begin Check-in (Session Creation)

*Origin: S-01 | Modified: S-03, S-05, S-06, S-07*

**Screens:** S2 -> S3R + S3P
**Boxes:** BOX-E2 (token access), BOX-E5 (concurrent prevention), BOX-22 (medications always included)

```
1. Receptionist clicks "Begin Check-in" on S2
   -> POST /api/checkins {patient_id, location_id, channel: "kiosk"}

2. Server checks:
   a. Active sessions for this patient (cross-location, S-05)
      -> If found: return 409 with active_checkin_info (who, where, when, status)
   b. Unique partial index enforces at DB level

3. Server creates session:
   -> Generate access_token (64 char)
   -> Snapshot patient_data into checkin_sections
   -> S-06: medications section ALWAYS created, even if no medication data exists
     -> If patient has medications: snapshot current list
     -> If no medication data: create section with original_value = {items: [], confirmed_empty: false}
   -> INSERT checkin_sessions (status='pending', version=1, location_id, channel='kiosk')
   -> INSERT checkin_sections (one per category including medications)
   -> Hash access_token, store hash
   -> Emit checkin.created

4. Response returns:
   <- Session ID, access_token, sections (including medications with required_every_visit=true)
   -> Client opens WebSocket
   -> Client generates patient URL: /checkin/{access_token}
   -> Receptionist hands tablet to patient
   -> Client renders S3R

5. Patient device loads URL:
   -> GET /api/checkins/token/{token}
   <- Patient view with first_name, sections split into existing/missing, medications section flagged
   -> Patient opens WebSocket
   -> S3P renders with medications section always expanded
   -> Session status -> 'in_progress', version incremented
```

---

## Flow 4: Patient Confirms a Section

*Origin: S-01 | Modified: S-02*

**Screens:** S3P (patient), S3R (receptionist)
**Boxes:** BOX-02 (no re-asking), BOX-03 (confirm not re-enter), BOX-06 (no false success)

```
1. Patient sees section with pre-filled data

2a. Patient taps "Still Correct":
   -> PATCH /api/checkins/token/{token}/sections/{sectionId} {action: "confirm"}
   -> Server updates checkin_sections
   -> Emit checkin.section.updated -> WebSocket OR polling (S-02 fallback)
   -> S-02: response includes server acknowledgment. Client shows spinner during persist.
   -> On success: green checkmark. On failure: "We're having trouble saving. Please try again."
   -> Response: {status: "confirmed", can_complete: false/true}

2b. Patient taps "Update":
   -> Section expands to editable fields
   -> Patient modifies and submits
   -> PATCH ... {action: "update", value: {...}}
   -> Same server flow as 2a, with confirmed_value = new data
   -> WebSocket -> receptionist sees old-vs-new diff
```

---

## Flow 5: Medication Confirmation (S-06)

*Added in: S-06*

**Screens:** S3P (medications section)
**Boxes:** BOX-22 (collected every visit), BOX-23 (variable-length), BOX-24 (auditable confirmation), BOX-25 (integrated in check-in)

```
1. S3P renders medications section ALWAYS expanded, amber "Confirm every visit" badge

2. [If medications exist:]
   -> Patient reviews list
   -> [Optional: edit medication]
     -> PATCH .../sections/{medSectionId} {action: "update", value: {items: [modified list]}}
   -> [Optional: remove medication]
     -> PATCH .../sections/{medSectionId} {action: "update", value: {items: [list without removed item]}}
   -> [Optional: add medication]
     -> PATCH .../sections/{medSectionId} {action: "update", value: {items: [list with new item]}}
   -> Patient taps "I confirm this medication list is current"
     -> PATCH .../sections/{medSectionId} {action: "confirm_medications", value: {items: [full list], confirmed_empty: false}}
     -> Server validates submitted list matches current state
     -> Section status -> "confirmed"
     -> Audit: creates unambiguous "medication_confirmed" event with full list snapshot

3. [If no medications:]
   -> Patient sees "No medications currently listed"
   -> Option A: "No, I am not taking any medications"
     -> PATCH .../sections/{medSectionId} {action: "confirm_medications", value: {items: [], confirmed_empty: true}}
   -> Option B: "+ Add a medication"
     -> Opens inline form, patient adds, then confirms full list

4. WebSocket -> receptionist: medications.updated event with item-level changes
```

**Key enforcement:** `POST /api/checkins/token/{token}/complete` will REJECT with 400 if medications section is still "pending". This is server-enforced, not just client-enforced. BOX-22 cannot be bypassed by a client-side bug.

---

## Flow 6: Patient Fills Missing Data

*Origin: S-01 | Unchanged*

Same as flows-s01.md Flow 5.

---

## Flow 7: Complete and Finalize

*Origin: S-01 | Modified: S-02, S-06, S-07*

**Screens:** S3P -> S4 (patient), S3R -> S4/S8 (receptionist)
**Boxes:** BOX-04, BOX-E1, BOX-E3, BOX-06, BOX-O1 (atomic finalization), BOX-27 (conflict-safe)

```
1. All sections resolved (including medications confirmed, S-06)
   -> "All Confirmed" activates
   -> Patient taps "All Confirmed"
   -> POST /api/checkins/token/{token}/complete
   -> S-06: server validates medications section confirmed. If not: 400 error.
   -> S-02: client shows spinner during server persist. Green checkmark only on 200 response.
   -> Session status -> 'patient_complete', version incremented
   -> Emit checkin.patient.complete
   -> WebSocket/poll -> receptionist: "Complete Check-in" button activates

2. Receptionist reviews S3R:
   -> All sections visible with diffs
   -> S-08: insurance card images visible if patient used photo upload
   -> Receptionist clicks "Complete Check-in"

3. Finalization:
   -> POST /api/checkins/{id}/finalize {expected_version: N}
   -> S-07: server checks version match
     -> If version mismatch: 412 Precondition Failed
     -> If another session finalized for same patient (edge case where concurrent prevention failed): 409 Conflict
   -> Within single DB transaction (BOX-O1):
     -> For each section: apply to patient_data
     -> Create audit rows
     -> Set session finalized, finalized_at, finalized_by
     -> Invalidate access token
   -> After transaction commit:
     -> Emit patient.updated, checkin.finalized
     -> Close WebSocket channel

4. Success:
   -> Receptionist: S4/S5 updated
   -> Patient kiosk: S4 displayed -> auto-transition to S0 after 10s (S-04)

5. S-07: On 409 Conflict:
   -> Receptionist directed to S8 (Finalization Conflict)
   -> S8 shows both sessions' changes
   -> Receptionist resolves via POST /api/checkins/{id}/resolve-conflict
```

---

## Flow 8: Timeout and Recovery

*Origin: S-01 | Modified: S-04*

**Screens:** S3P -> S0 (kiosk), S3R (timeout notice), S2 -> reinitiate
**Boxes:** BOX-E1 (no data loss), BOX-12 (screen clearing)

```
1. 3-minute inactivity: WebSocket -> patient: timeout.warning {2 min remaining}
2. 4-minute inactivity: WebSocket -> patient: timeout.warning {1 min remaining}
3. 5-minute inactivity:
   -> WebSocket -> patient: session.expired
   -> WebSocket -> receptionist: session.timeout
   -> S-04: patient kiosk immediately transitions to S0 (Welcome Screen)
   -> Client-side state purge executes (DOM, memory, history, autocomplete)
   -> Confirmed/updated sections PRESERVED in DB

4. Receptionist re-initiates:
   -> POST /api/checkins/{id}/reinitiate
   <- New access_token, preserved sections
   -> Patient device loads new URL
   -> GET /api/checkins/token/{new_token}
   -> Patient sees: confirmed sections done, pending sections need action
```

---

## Flow 9: Concurrent Check-in Prevention

*Origin: S-01 | Modified: S-05, S-07*

**Screens:** S1/S2 (blocked state), S8 (conflict resolution)
**Boxes:** BOX-E5, BOX-26 (airtight prevention), BOX-27 (conflict-safe finalization)

```
[Prevention layer — S-01, enhanced S-05:]
1. Search results show has_active_checkin: true
2. S2 shows concurrent session state with who, where (S-05: location), when, status
3. POST /api/checkins returns 409 if attempted
4. S-05: concurrent prevention is cross-location. A session at Location A blocks
   creation at Location B for the same patient.
5. S-07: supervisor can "Take Over Session":
   -> Old session cancelled (status -> "expired")
   -> New session created
   -> Old session's partial data preserved for recovery

[Finalization conflict — S-07:]
6. If concurrent prevention fails (DB pool exhaustion, rare edge case):
   -> Two sessions may exist for same patient
   -> First to finalize wins
   -> Second finalization returns 409 Conflict
   -> Conflict recorded in session_conflicts table
   -> Receptionist sees S8 with both sessions' data
   -> Resolution via POST /api/checkins/{id}/resolve-conflict
```

---

## Flow 10: WebSocket Failure and Fallback (S-02)

*Added in: S-02*

**Screens:** S3R (degraded), S5 (fallback queue)
**Boxes:** BOX-05 (2s visibility), BOX-07 (fallback queue), BOX-D4 (connection health)

```
1. WebSocket connection drops:
   -> Client detects: missed 2 pings or connection error
   -> Connection health indicator: green -> amber
   -> Auto-reconnect: exponential backoff (1s, 2s, 4s, 8s, max 30s)

2. During reconnection:
   -> S3R switches to polling: GET /api/checkins/{id}/poll every 10s
   -> Patient actions still persist (patient side has its own connection)
   -> Receptionist sees "Updates may be delayed" message

3. Reconnection succeeds:
   -> Connection indicator: amber -> green
   -> Polling stops, live updates resume
   -> Any missed events are caught by the first poll response

4. Reconnection fails (10 retries exhausted):
   -> Connection indicator: amber -> red
   -> S3R continues polling every 10s
   -> S5 (queue view) always works — it's pure REST
   -> Receptionist can finalize from S5 without S3R if needed

5. Patient completes during WebSocket outage:
   -> Patient side: POST /complete succeeds (separate connection)
   -> Receptionist side: polling detects patient_complete within 10s
   -> "Complete Check-in" button activates
   -> BOX-05: worst case 10s delay (polling interval), not 2s. This is acceptable
     under degraded conditions. BOX-05 2s target applies to WebSocket path only.
```

---

## Flow 11: Screen Clearing (S-04)

*Added in: S-04*

**Screens:** S3P/S4 -> S0
**Boxes:** BOX-12 (no PHI exposure), BOX-13 (enforced clearing), BOX-14 (encryption at rest)

```
[Trigger events:]
- Session finalized (receptionist clicks "Complete Check-in")
- Session timed out (5 min inactivity)
- Session cancelled (receptionist or supervisor action)

[Client-side purge sequence — synchronous, blocking:]
1. Replace current screen with S0 (Welcome) immediately — no transition animation
2. DOM purge: remove all elements with patient data
3. JavaScript: nullify all patient data variables, clear closures
4. Browser history: replaceState({}, "", "/welcome") — back button shows S0
5. Autocomplete: clear form autocomplete data
6. Session token: delete from client memory (localStorage, sessionStorage, variables)
7. Cache: clear any client-side cache entries
8. Verify: S0 is showing, no patient data in DOM

[Server-side:]
- Access token invalidated at finalization/expiry time
- If client makes any request with invalidated token: 410 Gone
```

---

## Flow 12: Mobile Pre-Check-In (S-03)

*Added in: S-03*

**Screens:** S7 -> S6 -> S3P (mobile) -> S4 (mobile)
**Boxes:** BOX-08 (mobile entry), BOX-09 (time window), BOX-11 (identity verification), BOX-16 (minimum necessary)

```
[Link generation — background process:]
1. Notification Service polls appointment schedule
2. For each appointment in next 24 hours with no existing link:
   -> Generate pre-check-in link token
   -> INSERT pre_checkin_links (status='generated', opens_at=appointment-24h, expires_at=appointment)
   -> Send SMS/email with link
   -> Status -> 'sent'

[Patient opens link:]
3. GET /api/precheckin/{token}
   -> Too early: "Opens 24 hours before appointment"
   -> Expired: "Link has expired"
   -> Already completed: "You've already pre-checked-in"
   -> Active: proceed to S6

[Identity verification — S6:]
4. Patient enters DOB
   -> POST /api/precheckin/{token}/verify {dob}
   -> Incorrect: "Doesn't match. X attempts remaining." Logged (BOX-15).
   -> Locked (3 failures): "Link locked." Permanent. Must verify at clinic.
   -> Correct: check-in session created automatically
     <- checkin_token returned
     -> Client redirects to S3P using checkin_token

[Check-in — same as kiosk:]
5. S3P (mobile variant) — same API surface as kiosk
   -> Responsive layout, same sections
   -> S-08: photo capture uses phone camera (mobile-native)
   -> S-06: medications section same behavior
   -> Patient completes all sections
   -> POST /api/checkins/token/{checkin_token}/complete
   -> S4 (mobile variant): "You're all set, [Name]. When you arrive, let the receptionist know."

[When patient arrives at clinic:]
6. Receptionist opens S5 queue
   -> Sees patient with "Pre-checked-in" status
   -> Clicks patient -> S2 with green banner: "Patient completed pre-check-in at [time]"
   -> "Review & Finalize" (skips S3R — patient already completed)
   -> POST /api/checkins/{id}/finalize
```

---

## Flow 13: Partial Pre-Check-In -> Kiosk Completion (S-03)

*Added in: S-03*

**Screens:** S2 -> S3R + S3P (kiosk)
**Boxes:** BOX-D8 (partial pre-check-in handled)

```
1. Patient started pre-check-in on phone but didn't finish
   -> Confirmed sections saved in DB (same as Flow 8 partial save)

2. Patient arrives at clinic:
   -> Receptionist looks up patient on S2
   -> S2 shows: "Patient started pre-check-in. 3 of 5 sections confirmed."
   -> Receptionist clicks "Begin Check-in" (or "Continue Check-in" if session still active)
     -> If session still active: receptionist uses existing session, generates new kiosk token
       -> POST /api/checkins/{id}/reinitiate
     -> If session expired: new session created, but server checks for recent expired sessions
       -> POST /api/checkins {patient_id, location_id, channel: "kiosk"}
       -> Server detects recent expired mobile session with partial data
       -> New session pre-populates confirmed sections from expired session (BOX-E1 extended)

3. S3P on kiosk shows:
   -> Previously confirmed sections: green checks (done)
   -> Remaining sections: pending (need action)
   -> Patient finishes remaining sections on kiosk
   -> Normal completion flow (Flow 7)
```

---

## Flow 14: Insurance Photo Upload (S-08)

*Added in: S-08*

**Screens:** S3P (photo capture overlay), S3R (card image visible)
**Boxes:** BOX-29 (photo capture), BOX-30 (OCR verification), BOX-31 (card images are PHI)

```
1. Patient taps "Update" on insurance section
   -> Choice: "Take a photo of your card" / "Enter manually"

2. [Photo path:]
   -> Camera overlay with card frame guide
   -> Patient captures front of card
     -> POST /api/checkins/token/{token}/sections/{sectionId}/upload
       {image: file, document_type: "insurance_card_front"}
     <- {upload_id, ocr_status: "processing", poll_url}
   -> Client shows OCR processing spinner

3. [Optional: capture back of card]
   -> Same upload flow with document_type: "insurance_card_back"

4. [OCR result polling:]
   -> GET /api/checkins/token/{token}/sections/{sectionId}/ocr/{upload_id}
   -> Every 2 seconds, max 5 attempts (10 seconds)
   -> If completed: show extracted fields for verification
   -> If failed: "We couldn't read your card. Try again or enter manually."
   -> If still processing after 10s: offer "Enter manually" fallback

5. [Patient verification:]
   -> Patient reviews extracted fields (provider, policy number, group number)
   -> Corrects any errors
   -> Confirms
   -> PATCH .../sections/{sectionId} {action: "update", value: {extracted + corrected fields, card_image_front: upload_id, card_image_back: upload_id}}
   -> Section status -> "updated"

6. [Receptionist view — S3R:]
   -> WebSocket: photo.uploaded event
   -> S3R shows: card image thumbnail + extracted data in flagged items
   -> Receptionist can view card image via signed URL (5-min expiry)
   -> No "let me see your card" conversation needed — they already have it

7. [PHI handling:]
   -> Card images stored in Object Storage (encrypted, AES-256)
   -> Access via signed URLs only — no direct access
   -> 7-year retention per HIPAA, then deleted
   -> Images are PHI (BOX-31) — same access controls as patient_data
```

---

## Flow 15: Concurrent Finalization Conflict Resolution (S-07)

*Added in: S-07*

**Screens:** S8 (Finalization Conflict), S9 (Session Recovery)
**Boxes:** BOX-27 (conflict-safe), BOX-28 (lost data recoverable)

```
[S8 — Receptionist conflict resolution:]
1. POST /api/checkins/{id}/finalize returns 409
2. Client renders S8 with conflict details:
   -> Winning session: who finalized, when, what changed
   -> Losing session (yours): what was NOT applied
3. Receptionist chooses:
   a. "Apply my changes too"
     -> POST /api/checkins/{id}/resolve-conflict {resolution: "apply", sections_to_apply: [...]}
     -> Patient data updated with losing session's changes
     -> Audit trail records both finalizations
   b. "Discard my changes"
     -> POST /api/checkins/{id}/resolve-conflict {resolution: "discard"}
     -> Losing session data archived, not applied
   c. "Contact admin"
     -> Receptionist escalates. Conflict stays in "pending" state.

[S9 — Admin recovery:]
4. Admin opens S9 (Session Recovery)
   -> GET /api/admin/sessions/conflicts — list unresolved conflicts
5. Admin selects a conflict
   -> GET /api/admin/sessions/{id}/history — full session history
6. Admin reviews side-by-side data
7. Admin applies specific changes
   -> POST /api/admin/sessions/{id}/recover {sections: [...], reason: "..."}
   -> Patient data updated, audit trail records recovery
```

---

## Flow 16: Multi-Location Queue Management (S-05)

*Added in: S-05*

**Screens:** S5 (queue with location filter)
**Boxes:** BOX-19 (location-independent), BOX-20 (works at any location), BOX-21 (location is context), BOX-D12 (location filter)

```
1. Receptionist opens S5
   -> GET /api/checkins/queue?location_id={current_location}
   <- Queue for current location

2. Receptionist toggles "All locations"
   -> GET /api/checkins/queue?all_locations=true
   <- Queue across all locations
   -> Location column shows which location each session belongs to
   -> Concurrent sessions visible across locations (helps spot BOX-26 violations)

3. Location header shows current location name
   -> Set at login / device configuration
   -> All new sessions inherit this location
```

---

## Flow 17: Import Pipeline (S-10)

*Added in: S-10*

**Screens:** S10 (Import Dashboard)
**Boxes:** BOX-36 (importable), BOX-39 (non-degrading), BOX-40 (post-import searchable)

```
[EHR import — automated:]
1. Admin creates import batch
   -> POST /api/admin/import/batches {source_system: "riverside_ehr", total_records: 3200}

2. Migration Service processes records:
   -> For each record in source data:
     a. Parse and normalize (name standardization, date format, address normalization)
     b. Dedup check against existing patient index:
        - Exact match (name+DOB): 100% confidence -> auto-merge with review
        - High (>90%): flag for human review
        - Medium (60-90%): flag for human review
        - Low (<60%): flag for human review
        - No match (0%): import directly
     c. If importing: POST /api/patients/bulk-import
     d. If flagging: create import_record with duplicate_candidate_id
   -> Rate limited: 10/second. Pauses during peak hours.

3. Progress visible on S10:
   -> GET /api/admin/import/batches/{id}
   -> Real-time: total, imported, errors, duplicates, rate, ETA

4. Post-import:
   -> Each imported patient indexed in Search Service
   -> patient.imported event -> Search Service rebuilds entry
   -> Imported patients immediately searchable with is_imported badge

[Paper record entry — manual, via S13:]
5. Admin enters paper records one by one
   -> POST /api/admin/import/paper-entry
   -> Same dedup pipeline
   -> Minimum data required: name + DOB + contact method (BOX-41)
```

---

## Flow 18: Duplicate Review and Merge (S-10)

*Added in: S-10*

**Screens:** S11 (Duplicate Review), S12 (Merge Resolution)
**Boxes:** BOX-37 (duplicates detected), BOX-38 (merge preserves data), BOX-D21 (confidence tiers), BOX-D23 (provenance)

```
1. Admin opens S11
   -> GET /api/admin/import/duplicates?status=pending
   <- List of flagged duplicates with confidence tiers

2. Admin filters by confidence:
   -> High (>90%): likely same person. Review quickly.
   -> Medium (60-90%): need careful comparison.
   -> Low (<60%): probably different people. Quick dismissal expected.

3. Admin selects a duplicate pair:
   -> Side-by-side comparison: our record vs. Riverside record
   -> Match signals highlighted (exact_dob, similar_name, same_phone)

4a. Same patient -> Merge:
   -> Admin clicks "Merge" -> S12
   -> Field-by-field selection: for each field, choose "ours", "theirs", or "merge both"
   -> "merge both" available for list fields (medications, allergies): combines both lists
   -> POST /api/admin/import/duplicates/{id}/resolve {resolution: "merge", field_selections: {...}}
   -> Patient record updated. Source records archived. Provenance tagged. Audit trail.

4b. Different patients:
   -> POST /api/admin/import/duplicates/{id}/resolve {resolution: "not_duplicate"}
   -> Riverside record imported as new patient

4c. Unsure:
   -> POST /api/admin/import/duplicates/{id}/resolve {resolution: "deferred"}
   -> Flagged for later review
```

---

## Flow 19: Performance Under Load (S-09)

*Added in: S-09*

**Screens:** S5 (queue metrics), S3P (degraded save), S1 (slow search)
**Boxes:** BOX-32 (30 concurrent), BOX-33 (60 aggregate), BOX-34 (degradation visible to staff), BOX-35 (patient loss measurable)

```
[Normal operation (<10 concurrent):]
- All APIs respond within targets (<200ms search, <100ms section save)
- Queue shows simple list

[Busy (10-20 concurrent):]
- S5 queue header shows metrics: "15 patients checking in | Avg: 4 min"
- APIs may slow slightly. Connection pool utilization increases.
- Cache layer reduces DB load for read-heavy operations (patient summary lookups)

[Peak (20+ concurrent):]
- S5 shows warning: "High volume — 25 patients | Avg: 7 min"
- S-09: if S-03 is live, suggest directing patients to mobile pre-check-in
- Check-in Service horizontally scaled (2+ instances behind load balancer)
- Read replica handles search queries
- Polling interval may increase from 10s to 15s to reduce server load
- S3P: section saves may show visible spinner (normally sub-100ms, now 200-500ms)
- S3P: if save times out (>5s): "We're having trouble saving. Please try again."

[Abandonment tracking:]
- Sessions created but never started (status stays "pending" for >5min): marked "abandoned"
- Sessions started but timed out: marked "timed_out"
- Tracked on S5 queue. Aggregate stats available: abandoned_today count.
- BOX-35: this data enables measuring patient loss from performance issues.

[Scaling strategy:]
- Check-in Service: stateless, horizontal. Add instances behind LB.
- WebSocket Server: sticky sessions via connection ID. Add instances for more connections.
- PostgreSQL: read replica for search-related queries. Primary for writes.
- Redis: single instance sufficient at 60 concurrent. Monitor memory.
- Search index: single node sufficient at 4,000+ records. Monitor query latency.
- Connection pool sizing: 50 primary connections / 20 replica connections.
  - At 30 concurrent sessions, each needing ~2 DB connections (section save + session update),
    peak DB connection usage is ~60. Pool of 50+20=70 provides headroom.
```

---

## Flow 20: Receptionist Direct Edit

*Origin: S-01 | Unchanged*

Same as flows-s01.md Flow 8.

---

## Flow Summary

| # | Flow | Origin | Boxes |
|---|------|--------|-------|
| 1 | Patient Lookup | S-01, S-05, S-09, S-10 | BOX-01, BOX-20, BOX-40 |
| 2 | Assisted Search | S-01, S-10 | BOX-D1, BOX-37 |
| 3 | Begin Check-in | S-01, S-03, S-05, S-06, S-07 | BOX-E2, BOX-E5, BOX-22 |
| 4 | Patient Confirms Section | S-01, S-02 | BOX-02, BOX-03, BOX-06 |
| 5 | Medication Confirmation | S-06 | BOX-22, BOX-23, BOX-24, BOX-25 |
| 6 | Fill Missing Data | S-01 | BOX-D3 |
| 7 | Complete and Finalize | S-01, S-02, S-06, S-07 | BOX-04, BOX-E1, BOX-E3, BOX-O1, BOX-27 |
| 8 | Timeout and Recovery | S-01, S-04 | BOX-E1, BOX-12 |
| 9 | Concurrent Prevention | S-01, S-05, S-07 | BOX-E5, BOX-26, BOX-27 |
| 10 | WebSocket Failure | S-02 | BOX-05, BOX-07, BOX-D4 |
| 11 | Screen Clearing | S-04 | BOX-12, BOX-13 |
| 12 | Mobile Pre-Check-In | S-03 | BOX-08, BOX-09, BOX-11, BOX-16 |
| 13 | Partial Pre-Check-In | S-03 | BOX-D8 |
| 14 | Insurance Photo Upload | S-08 | BOX-29, BOX-30, BOX-31 |
| 15 | Conflict Resolution | S-07 | BOX-27, BOX-28 |
| 16 | Multi-Location Queue | S-05 | BOX-19, BOX-20, BOX-21, BOX-D12 |
| 17 | Import Pipeline | S-10 | BOX-36, BOX-39, BOX-40 |
| 18 | Duplicate Review/Merge | S-10 | BOX-37, BOX-38, BOX-D21, BOX-D23 |
| 19 | Performance Under Load | S-09 | BOX-32, BOX-33, BOX-34, BOX-35 |
| 20 | Receptionist Direct Edit | S-01 | — |
