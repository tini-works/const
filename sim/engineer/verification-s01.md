# Verification Guide — Story 01

How QA proves each box is matched. Each entry specifies what to test, the exact API calls to make, what to assert, and what would break it.

---

## BOX-01: Returning patient is recognized

**What to prove:** A patient who has visited before is found by the system before any data collection begins.

**Test sequence:**
1. Seed: create a patient with at least one prior visit.
2. `GET /api/patients/search?q={patient_name}` — assert the patient appears in results with `last_visit_date` populated.
3. `GET /api/patients/search?q={partial_name}` (first 3 chars) — assert prefix matching works.
4. `GET /api/patients/search?q={dob}` — assert DOB search returns the patient.
5. `GET /api/patients/{id}` — assert full record returned with data sections, last visit info.

**Negative cases:**
- Search with <2 characters returns 400.
- Search for a name that doesn't exist returns empty results (not an error).
- A brand-new patient with no visits has `last_visit_date: null` in search results.

**What would break it:** Search index out of sync with patient store. Test by creating a patient, waiting 3 seconds, and verifying they appear in search.

---

## BOX-02: Previously collected data is not re-asked

**What to prove:** The patient-facing check-in view (S3P) shows pre-filled data, not blank fields, for data that exists in the patient record.

**Test sequence:**
1. Seed: patient with address, insurance, and allergies on file.
2. Create check-in: `POST /api/checkins {patient_id}`.
3. Load patient view: `GET /api/checkins/token/{token}`.
4. Assert: `sections.existing` contains all three categories. Each has `value` populated (not null). `sections.missing` is empty.

**Negative case (partial data):**
1. Seed: patient with address on file, no insurance, no allergies.
2. Create check-in and load patient view.
3. Assert: `sections.existing` contains address only. `sections.missing` contains insurance and allergies with `value: null`.

**What would break it:** Patient Service returning null values for categories that have data. Check that the snapshot logic in `POST /api/checkins` correctly copies `patient_data.value` into `checkin_sections.original_value`.

---

## BOX-03: Confirm or update, not re-enter

**What to prove:** The patient's action is confirm (one tap) or update (edit pre-filled field), never fill-from-blank for data that exists.

**Test sequence — confirm:**
1. Load patient view (pre-conditions: data exists).
2. `PATCH /api/checkins/token/{token}/sections/{id} {action: "confirm"}`.
3. Assert: section status = "confirmed". `confirmed_value` is null (no new data needed). Response is 200.

**Test sequence — update:**
1. Load patient view.
2. `PATCH /api/checkins/token/{token}/sections/{id} {action: "update", value: {new data}}`.
3. Assert: section status = "updated". `confirmed_value` contains the new data.

**Negative case:**
- Attempting `{action: "fill"}` on a section that has existing data should return 422. Fill is only for missing sections.

---

## BOX-04: Experience communicates recognition

**What to prove:** The patient-facing view addresses the patient by first name, and the check-in completion message is personalized.

**Test sequence:**
1. Seed: patient with first_name = "Maria".
2. Create check-in and load patient view.
3. Assert: response contains `patient_first_name: "Maria"`.
4. Complete all sections, then `POST /api/checkins/token/{token}/complete`.
5. Assert: response `message` contains "Maria".

**Privacy check:**
- Assert: patient view response does NOT contain `last_name` anywhere in the payload. (Shared-space privacy per Design spec.)

---

## BOX-D1: Recognition failure has graceful path

**What to prove:** Fuzzy search returns results with confidence scores when standard search fails, and the "start as new with merge flag" path works.

**Test sequence — fuzzy match found:**
1. Seed: patient named "Jane Doe", DOB 1985-03-14, phone 555-0123.
2. Standard search: `GET /api/patients/search?q=Jayne` — assert no exact match (spelling differs).
3. Fuzzy search: `GET /api/patients/search/fuzzy?name=Jayne&phone=555-0123`.
4. Assert: results contain "Jane Doe" with confidence > 0.5, `matched_on` includes "phone".

**Test sequence — no match, fallback:**
1. Fuzzy search with criteria that match no one.
2. Assert: empty results (not an error).
3. The receptionist creates a new patient with `merge_flag: "possible_duplicate"`.
4. `GET /api/patients/{new_id}` — assert `merge_flag` = "possible_duplicate".

---

## BOX-D2: Two actors, two views

**What to prove:** The receptionist and patient see different data shapes for the same check-in session.

**Test sequence:**
1. Create check-in session.
2. Receptionist view: `GET /api/checkins/{id}` — assert response contains `original_value` and `confirmed_value` for each section, full `patient_name` (first + last).
3. Patient view: `GET /api/checkins/token/{token}` — assert response contains `patient_first_name` only, sections split into `existing`/`missing`, no `original_value`/`confirmed_value` diff structure.
4. After patient updates a section: receptionist view shows old-vs-new diff. Patient view shows only the new status.

**Access control check:**
- Patient token cannot access `GET /api/checkins/{id}` (receptionist endpoint). Returns 401.
- Receptionist session cannot access `GET /api/checkins/token/{token}` without the token. (Actually, the receptionist HAS the token from session creation — this is acceptable. But the token-based endpoint returns the patient-scoped view regardless of who calls it.)

---

## BOX-D3: Partial data handled without confusion

**What to prove:** Sections with existing data and sections with missing data are separated in the patient view.

**Test sequence:**
1. Seed: patient with address on file, no insurance, no allergies.
2. Create check-in, load patient view.
3. Assert: `sections.existing` = [address]. `sections.missing` = [insurance, allergies].
4. Patient fills insurance: `PATCH ...sections/{insurance_id} {action: "fill", value: {...}}`.
5. Reload patient view.
6. Assert: insurance section moved from "missing" to "existing" conceptually — its status is now "missing_filled", but it remains in the response structure with the filled value.

**Negative case:**
- `{action: "confirm"}` on a missing section (original_value = null) should return 422. You can't confirm data that doesn't exist.

---

## BOX-E1: Session timeout produces no data loss

**What to prove:** Sections confirmed before timeout survive the timeout. Resumed session shows progress.

**Test sequence:**
1. Create check-in with 3 sections.
2. Confirm section 1: `PATCH ...sections/{s1} {action: "confirm"}`. Assert: 200, status = "confirmed".
3. Confirm section 2: `PATCH ...sections/{s2} {action: "update", value: {...}}`. Assert: 200, status = "updated".
4. Do NOT touch section 3. Wait for inactivity timeout (or simulate by checking `last_activity_at` + 5 min < now).
5. Assert: session status is still "in_progress" (not expired, not rolled back).
6. Assert: section 1 status = "confirmed", section 2 status = "updated", section 3 status = "pending". All data preserved.
7. Re-initiate: `POST /api/checkins/{id}/reinitiate`. Assert: new token returned, sections preserved.
8. Load patient view with new token. Assert: sections 1 and 2 show as confirmed/updated. Section 3 is still pending.

---

## BOX-E2: Patient access is token-scoped

**What to prove:** The patient token grants access to exactly one session and expires correctly.

**Test sequence — scope:**
1. Create two check-in sessions (for different patients).
2. Token A accesses session A: `GET /api/checkins/token/{tokenA}` — 200.
3. Token A tries to access session B's sections: `PATCH /api/checkins/token/{tokenA}/sections/{sectionFromB}` — 404 or 403 (section doesn't belong to this session).

**Test sequence — expiry:**
1. Create check-in session.
2. Access with token: 200.
3. Finalize session: `POST /api/checkins/{id}/finalize`.
4. Access with same token: 410 Gone.

**Test sequence — hard TTL:**
1. Create session. Wait 30 minutes (or set `expires_at` to past in test setup).
2. Access with token: 410 Gone.

**Security check:**
- Token is 64 characters, alphanumeric + special. Brute-forcing is infeasible.
- Token does not appear in server response headers or logs (check application log output).

---

## BOX-E3: Data updates are staged, not immediate

**What to prove:** Patient-entered updates do not modify the patient record until the receptionist finalizes.

**Test sequence:**
1. Seed: patient with insurance = "BlueCross".
2. Create check-in.
3. Patient updates insurance: `PATCH ...sections/{insurance_id} {action: "update", value: {provider: "Aetna"}}`.
4. **Before finalization:** `GET /api/patients/{id}` — assert insurance value is still "BlueCross". The patient record is unchanged.
5. Receptionist finalizes: `POST /api/checkins/{id}/finalize`.
6. **After finalization:** `GET /api/patients/{id}` — assert insurance value is now "Aetna". `last_confirmed` is updated. `source` = "checkin_update".

**Audit check:**
- After finalization, the audit trail should contain a row showing: old value = "BlueCross", new value = "Aetna", changed_by = "checkin_update", session_id = {id}.

---

## BOX-E4: Search index eventual consistency

**What to prove:** The search index reflects patient record changes within an acceptable lag.

**Test sequence:**
1. Create a new patient: `POST /api/patients {first_name: "UniqueTestName..."}`.
2. Immediately search: `GET /api/patients/search?q=UniqueTestName` — may return empty (acceptable).
3. Wait 3 seconds.
4. Search again: assert patient appears.

**Boundary:** If the patient does not appear within 5 seconds, the search index sync is broken. Alert.

---

## BOX-E5: Concurrent check-in prevention

**What to prove:** Two simultaneous check-in sessions for the same patient are prevented.

**Test sequence:**
1. Create check-in for patient X: `POST /api/checkins {patient_id: X}` — 201.
2. Attempt second check-in for patient X: `POST /api/checkins {patient_id: X}` — 409 Conflict.
3. Assert: 409 response contains `existing_session_id`, `initiated_by`, `initiated_at`.
4. Finalize the first session: `POST /api/checkins/{id}/finalize`.
5. Now create a new check-in for patient X: `POST /api/checkins {patient_id: X}` — 201 (succeeds because no active session exists).

**Race condition test:**
- Two concurrent `POST /api/checkins {patient_id: X}` requests sent simultaneously.
- Exactly one succeeds (201), exactly one fails (409).
- This is enforced by database unique partial index, not application logic.

---

## End-to-End Verification Path

The full customer story ("I visit the clinic, I don't want to re-enter my information") is verified by running these flows in sequence:

1. Patient exists with prior visit data -> **BOX-01 verified**
2. Receptionist finds patient via search -> **BOX-01 verified**
3. Check-in session created, patient view shows pre-filled data -> **BOX-02 verified**
4. Patient taps "Still correct" on each section -> **BOX-03 verified**
5. Patient view greets by first name, completion is personalized -> **BOX-04 verified**
6. Finalization applies only confirmations (no data change on patient record, just timestamp updates) -> **BOX-E3 verified**
7. Check-in complete -> **Full flow verified**

Variant paths (fuzzy search, partial data, timeout, concurrent prevention) are verified individually per the test sequences above.
