# Flows — Story 01

Every flow maps Design's state machine to exact API calls, data mutations, and events. Each flow traces to PM boxes and Design screens.

## Sequence Diagram

https://diashort.apps.quickable.co/d/f4a2a6ca

---

## Flow 1: Patient Lookup (Happy Path)

**Screens:** S1 -> S2
**Boxes:** BOX-01 (patient recognized)

```
1. Receptionist types in search bar (S1)
   -> Client debounces (300ms)
   -> GET /api/patients/search?q={input}
   <- PatientSummary[] with last_visit_date, has_active_checkin

2. Receptionist selects a patient from results
   -> GET /api/patients/{id}
   <- Full patient record with data_sections[], staleness flags
   -> Client renders S2 (Patient Summary)

3. S2 shows:
   - Patient header (name, DOB, photo)
   - Quick facts (last visit, physician, insurance)
   - Data status panel: each category with value, last_confirmed, stale/current flag
   - Action bar: "Begin Check-in" / "Update Record"
```

**Data flow:** Search Index -> Search Service -> API -> Client. Then: Patient Store -> Patient Service -> API -> Client.

**Staleness computation happens at step 2.** The Patient Service computes `is_stale` for each data section by comparing `last_confirmed` against `data_categories.freshness_days`. This is read-time computation, not stored state.

---

## Flow 2: Assisted Search (Recognition Failure)

**Screens:** S1 -> S1b -> S2
**Boxes:** BOX-D1 (graceful failure)

```
1. Receptionist search returns no match or patient says "that's not me"
   -> Receptionist clicks "Can't Find Record"
   -> Client renders S1b (Assisted Search)

2. Receptionist enters alternative criteria (phone, email, old insurance ID, approx visit date)
   -> GET /api/patients/search/fuzzy?name=...&phone=...&insurance_id=...
   <- Results with confidence scores and matched_on fields

3a. Match found:
   -> Receptionist selects patient -> GET /api/patients/{id} -> S2 (rejoins Flow 1, step 2)

3b. No match:
   -> Receptionist clicks "Start as New, Merge Later"
   -> POST /api/patients (first-visit flow, out of scope)
   -> Patient created with merge_flag: "possible_duplicate"
   -> Record enters duplicate-review queue (background process, out of scope for S-01)
```

**Key detail:** The fuzzy search endpoint hits a different index query. It uses Levenshtein distance on names (up to distance 2), partial DOB matching (year-only or month+year), and exact matching on phone/email/insurance_id. Confidence is weighted: more criteria matched = higher confidence.

---

## Flow 3: Begin Check-in (Session Creation)

**Screens:** S2 -> S3R + S3P
**Boxes:** BOX-E2 (token access), BOX-E5 (concurrent prevention)

```
1. Receptionist clicks "Begin Check-in" on S2
   -> POST /api/checkins {patient_id}

2. Server checks for active sessions:
   -> SELECT FROM checkin_sessions WHERE patient_id = X AND status IN ('pending','in_progress')
   -> If found: return 409 Conflict with existing session info
   -> If not found: proceed

3. Server creates session:
   -> Generate access_token (64 char, cryptographically random)
   -> Snapshot patient_data into checkin_sections (one row per data category)
   -> For categories with no patient_data: create section with original_value = null, category source = "missing"
   -> INSERT checkin_sessions (status='pending', expires_at=now+30min)
   -> INSERT checkin_sections (one per category)
   -> Hash access_token, store hash in DB
   -> Emit checkin.created event

4. Response returns:
   <- Session ID, access_token (plaintext, one-time), access_url, section summaries
   -> Client opens WebSocket to ws://host/ws/checkins/{sessionId}
   -> Client generates patient-facing URL: /checkin/{access_token}
   -> Receptionist hands tablet/kiosk to patient or navigates device to URL
   -> Client renders S3R (Check-in Monitor)

5. Patient device loads URL:
   -> GET /api/checkins/token/{token}
   -> Server hashes token, finds matching session
   -> Returns patient view: first_name, sections split into existing/missing
   -> Patient device opens WebSocket to ws://host/ws/checkins/{sessionId}?token={token}
   -> Device renders S3P (Confirm Your Information)
   -> Session status -> 'in_progress'
```

**Data flow:** Patient Store -> snapshot into Check-in Store. From this point, the check-in session operates on its own copy. The patient record is not modified until finalization.

---

## Flow 4: Patient Confirms a Section

**Screens:** S3P (patient), S3R (receptionist sees live update)
**Boxes:** BOX-02 (no re-asking), BOX-03 (confirm not re-enter)

```
1. Patient sees section (e.g., Address) with pre-filled data
   -> Section state: "pending", value shown, staleness indicator if applicable

2a. Patient taps "Still Correct":
   -> PATCH /api/checkins/token/{token}/sections/{sectionId} {action: "confirm"}
   -> Server: checkin_sections.status = 'confirmed', confirmed_value = null, acted_at = now
   -> Server: checkin_sessions.last_activity_at = now (resets inactivity timer)
   -> Emit checkin.section.updated {sectionId, category, status: "confirmed"}
   -> WebSocket -> Receptionist client: section shows green check
   -> Response: {status: "confirmed", can_complete: false/true}
   -> Patient client: section collapses with green check

2b. Patient taps "Update":
   -> Section expands to editable fields, pre-filled with current value
   -> Patient modifies and submits:
   -> PATCH /api/checkins/token/{token}/sections/{sectionId} {action: "update", value: {...}}
   -> Server validates value against category schema
   -> Server: checkin_sections.status = 'updated', confirmed_value = {new data}, acted_at = now
   -> Server: checkin_sessions.last_activity_at = now
   -> Emit checkin.section.updated {sectionId, category, status: "updated", confirmed_value: {...}}
   -> WebSocket -> Receptionist client: section shows old-vs-new diff (blue highlight)
   -> Response: {status: "updated", can_complete: false/true}
   -> Patient client: section collapses with blue "Updated" indicator
```

**Key detail on BOX-E3 (staged updates):** The `confirmed_value` in step 2b is stored only in `checkin_sections`. The `patient_data` table is NOT modified. The receptionist sees the diff on S3R and can review before finalization. Data reaches the patient record only in Flow 6 (finalize).

---

## Flow 5: Patient Fills Missing Data

**Screens:** S3P ("We still need" section)
**Boxes:** BOX-D3 (partial data handled distinctly)

```
1. "We still need" section appears at bottom of S3P
   -> These are checkin_sections where original_value is null
   -> Patient sees empty input fields (not pre-filled — there's nothing to pre-fill)

2. Patient fills in data and submits:
   -> PATCH /api/checkins/token/{token}/sections/{sectionId} {action: "fill", value: {...}}
   -> Server validates value against category schema
   -> Server: checkin_sections.status = 'missing_filled', confirmed_value = {new data}, acted_at = now
   -> Server: checkin_sessions.last_activity_at = now
   -> Emit checkin.section.updated
   -> WebSocket -> Receptionist: sees new data for this category (no diff — there was no old value)
   -> Response: {status: "missing_filled", can_complete: false/true}
```

**Distinction from Flow 4:** `action: "fill"` vs `action: "update"`. Fill has no original_value to diff against. The receptionist sees "NEW" instead of "old -> new".

---

## Flow 6: Complete and Finalize

**Screens:** S3P -> S4 (patient), S3R -> S4 (receptionist)
**Boxes:** BOX-04 (experience closure), BOX-E1 (no data loss), BOX-E3 (staged updates applied)

```
1. All sections resolved (no "pending" sections remain)
   -> Patient client: "All Confirmed" button activates
   -> Patient taps "All Confirmed"
   -> POST /api/checkins/token/{token}/complete
   -> Server validates all sections are non-pending
   -> Server: checkin_sessions.status = 'patient_complete', patient_completed_at = now
   -> Emit checkin.patient.complete
   -> WebSocket -> Receptionist: "Complete Check-in" button activates on S3R
   -> Patient client renders S4: "You're all checked in, Jane."

2. Receptionist reviews:
   -> S3R shows all sections with their final state
   -> Updated sections show old-vs-new diff
   -> Receptionist can see if any updates need follow-up (e.g., new insurance card to scan)

3. Receptionist clicks "Complete Check-in":
   -> POST /api/checkins/{id}/finalize
   -> Server applies staged changes to patient record:

   For each section:
   a. status = "confirmed": UPDATE patient_data SET last_confirmed = now WHERE patient_id AND category
   b. status = "updated": UPDATE patient_data SET value = confirmed_value, last_confirmed = now, source = 'checkin_update'
   c. status = "missing_filled": INSERT patient_data (patient_id, category, value = confirmed_value, last_confirmed = now, source = 'checkin_update')

   -> Audit rows created for every mutation
   -> checkin_sessions.status = 'finalized', finalized_at = now
   -> Access token invalidated (session is terminal)
   -> Emit patient.updated (search index rebuilds)
   -> Emit checkin.finalized
   -> Response: summary of applied updates
   -> Receptionist client renders S4: check-in record updated, patient returns to queue
```

**Data flow on finalization:** Check-in Store (staged) -> Patient Store (committed). This is the only moment check-in data reaches the patient record. Everything before this is provisional.

---

## Flow 7: Timeout and Recovery

**Screens:** S3P (timeout), S3R (timeout notification), S2 -> S3R + S3P (re-initiate)
**Boxes:** BOX-E1 (no data loss on interruption)

```
1. Patient is inactive for 3 minutes:
   -> Server: WebSocket -> Patient: timeout.warning {minutes_remaining: 2}
   -> Patient client shows warning: "Are you still there?"

2. Patient is inactive for 4 minutes:
   -> Server: WebSocket -> Patient: timeout.warning {minutes_remaining: 1}

3. Patient is inactive for 5 minutes:
   -> Server: checkin_sessions.status stays 'in_progress' (NOT expired yet)
   -> Server: WebSocket -> Patient: session.expired
   -> Server: WebSocket -> Receptionist: session.timeout {partial_progress}
   -> Patient client shows: "Session timed out. Please see the receptionist."
   -> Receptionist client shows: "Session timed out" on S3R with partial progress summary

   CRITICAL: Sections already confirmed/updated are PRESERVED in checkin_sections.
   They are not rolled back. The session still exists with its partial state.

4. Receptionist re-initiates:
   -> Receptionist navigates back to S2 (or directly re-initiates from S3R)
   -> POST /api/checkins/{id}/reinitiate
   -> Server: generates new access_token, resets expires_at = now+30min, resets last_activity_at
   -> Server: only "pending" sections remain pending. Confirmed/updated sections keep their state.
   -> Response: new access_token, access_url
   -> Receptionist hands tablet back to patient

5. Patient device loads new URL:
   -> GET /api/checkins/token/{new_token}
   -> Patient sees: confirmed sections show as done (green checks), only pending sections need action
   -> Patient resumes where they left off
```

**Key detail:** Timeout does NOT finalize or expire the session. It pauses it. The session remains in "in_progress" state with partial data. Only the 30-minute hard TTL or explicit finalization terminates it. This is critical for BOX-E1: no data loss.

---

## Flow 8: Receptionist Direct Edit

**Screens:** S2 (inline edit)
**Boxes:** (operational flow, no direct PM box — serves data freshness)

```
1. Receptionist clicks "Update Record" on S2
   -> Inline edit fields appear for the selected data section
   -> Receptionist modifies (e.g., scans new insurance card, types new info)

2. Receptionist saves:
   -> PATCH /api/patients/{id} {data_sections: [{category: "insurance", value: {...}}]}
   -> Server: UPDATE patient_data SET value, last_confirmed = now, confirmed_by = receptionist, source = 'receptionist_edit'
   -> Audit row created
   -> Emit patient.updated (search index rebuilds async — BOX-E4 eventual consistency)
   -> Response: updated patient record
   -> Client refreshes S2 with updated data

3. Receptionist can now "Begin Check-in" — the data they just updated will be snapshotted into the new check-in session.
```

---

## Flow 9: Concurrent Check-in Prevention

**Screens:** S2 (blocked state)
**Boxes:** BOX-E5 (concurrent prevention)

```
1. Receptionist A has started a check-in for Patient X (session exists, status = 'in_progress')

2. Receptionist B searches for Patient X on S1:
   -> GET /api/patients/search?q=...
   <- Results include has_active_checkin: true for Patient X
   -> Client shows indicator on the search result

3. Receptionist B selects Patient X:
   -> GET /api/patients/{id}
   <- has_active_checkin: true
   -> Client renders S2 with "Begin Check-in" disabled
   -> Message: "This patient is being checked in by [Receptionist A] since [time]"

4. If Receptionist B ignores the warning and tries anyway:
   -> POST /api/checkins {patient_id}
   <- 409 Conflict {existing_session_id, initiated_by: "Receptionist A", initiated_at}
   -> Client shows error with details
```

**Note:** This is enforced at the database level: unique partial index on `checkin_sessions(patient_id) WHERE status IN ('pending', 'in_progress', 'patient_complete')`. Race conditions are handled by the database, not application logic.
