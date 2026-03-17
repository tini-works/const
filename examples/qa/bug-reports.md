# Bug Reports — Clinic Check-In System

---

## BUG-001: Kiosk Confirmation Shows Green Checkmark But Receptionist Sees Nothing

**Severity:** P1 — Core flow broken
**Reported:** Round 2
**Reporter:** Patient (via complaint)
**Status:** Fix verified
**Related:** US-002, ADR-001

### Summary
Patient completed kiosk check-in, saw green confirmation checkmark, but the receptionist had no data on her screen. Patient was asked to fill out a paper form despite having "successfully" checked in at the kiosk.

### Steps to Reproduce
1. Open receptionist dashboard on one screen
2. At the kiosk, scan a valid patient card
3. Complete check-in through all steps
4. Tap "Confirm and check in"
5. Observe green checkmark on kiosk
6. Check receptionist dashboard — patient's check-in status is still "Not Checked In"

### Expected Behavior
After patient sees green checkmark, receptionist dashboard should show the patient as "Checked In" with all confirmed data visible.

### Actual Behavior
Kiosk showed green checkmark immediately after saving to the database. Receptionist dashboard never received the update. The green checkmark was a lie — it only confirmed the kiosk-side save, not the end-to-end delivery.

### Root Cause
The kiosk showed the success state as soon as the API returned a successful save response. There was no verification that the receptionist dashboard actually received the data. The WebSocket push to the dashboard had no acknowledgment mechanism. If the WebSocket connection was dropped or the push failed, the kiosk had no way to know.

Two specific failures:
1. **No ack mechanism:** WebSocket delivery was fire-and-forget. The system assumed the push succeeded if the WebSocket connection was "open."
2. **No fallback:** If the WebSocket connection was silently dead (missed heartbeats), updates were permanently lost.

### Fix Description
- **WebSocket ack:** Dashboard now sends an acknowledgment back through the WebSocket for each check-in update it receives.
- **Kiosk waits for ack:** After saving, the kiosk waits up to 5 seconds for the ack from the dashboard.
  - Ack received: green checkmark (sync confirmed)
  - Ack not received within 5s: yellow warning ("saved, but front desk wasn't notified — please let them know")
  - Save failed entirely: red error with retry
- **Polling fallback:** If the dashboard's WebSocket drops, it automatically falls back to polling `GET /dashboard/queue` every 5 seconds.
- **Heartbeat:** Server pings WebSocket every 30 seconds. No pong within 10 seconds = connection dead, cleanup triggered.

### Fix Verification
- **TC-201:** Confirmed sync — green checkmark only after dashboard ack. PASS.
- **TC-202:** Disconnected dashboard — kiosk shows yellow warning, not green. PASS.
- **TC-203:** Reconnected dashboard picks up data via polling fallback. PASS.
- **Regression test:** 20 consecutive check-ins, all confirmed on both kiosk and dashboard. No false green checkmarks.

### Post-Mortem Notes
The fundamental mistake was showing a success state based on a partial operation. "Saved to DB" is not the same as "receptionist can see it." The fix gates the success indicator on the thing the patient actually cares about: the receptionist knows they're checked in. Honest feedback (yellow warning) is better than false confidence (green checkmark).

---

## BUG-002: Previous Patient's Data Briefly Visible on Kiosk After Card Scan

**Severity:** P0 — Security / PHI Exposure / Potential HIPAA Breach
**Reported:** Round 4
**Reporter:** Patient (via complaint)
**Status:** Fix verified
**Related:** US-003, ADR-002, DD-001

### Summary
A patient scanned their card at the kiosk and briefly saw another patient's name and allergies on screen before the display switched to their own data. The previous patient's PHI (name and allergy information) was visible for approximately 200-400 milliseconds. This is a data exposure incident and a potential HIPAA breach.

### Steps to Reproduce
1. Patient A scans card, completes check-in, sees success screen
2. Before the 10-second countdown finishes, Patient B scans their card
3. For a brief moment (~200-400ms), Patient A's data (name, allergies) flashes on screen before Patient B's data loads

### Expected Behavior
After Patient B scans their card, the screen should show a loading state (transition screen) with zero trace of Patient A's data. At no point should one patient's PHI be visible during another patient's session.

### Actual Behavior
The React component tree retained state from Patient A's session. When Patient B's card triggered a new data fetch, the old data remained visible in the DOM during the re-render cycle. For approximately 200-400ms, Patient A's name and allergy list were visible on screen while the app was fetching Patient B's data.

### Root Cause
React's reconciliation model updates the DOM incrementally. There is no guarantee that all remnants of the previous render are cleared before the new render begins. When the data fetch for Patient B resolved, the new data replaced the old data — but during the gap between "new scan detected" and "new data arrived," the old data remained in the DOM.

Specifically:
- React state atoms holding patient data were not reset before the new fetch
- React Query cache contained Patient A's data
- The component tree was re-rendered with new data rather than destroyed and rebuilt
- No visual barrier existed between patient sessions

### Fix Description
Three-layer defense-in-depth (Session Purge Protocol):

**Layer 1 — Application State Reset:**
- Cancel all in-flight API requests (AbortController)
- Clear all React state atoms to null
- Clear React Query / TanStack Query cache entirely
- Clear sessionStorage and any browser storage

**Layer 2 — DOM Destruction:**
- Increment a React `key` on the SessionBoundary component, forcing React to fully unmount and remount the entire patient data component subtree
- This is not a re-render — it is a full component lifecycle teardown and rebuild

**Layer 3 — Transition Screen Barrier (Design-mandated):**
- A branded loading screen ("Loading your information...") renders between every patient session
- Minimum display time: 800ms (even if data loads faster)
- This screen is the visual proof that the old DOM is gone
- Data fetch does NOT begin until after the transition screen is rendered

**Sequencing:** Card scan -> state reset -> DOM destroy -> transition screen renders -> wait 800ms -> begin data fetch -> on data arrival, transition to identity confirmation.

### Fix Verification
- **TC-301:** Sequential patients, normal timing — no data leakage. PASS.
- **TC-302:** Rapid sequential scans (Patient B scans during Patient A's countdown) — no leakage. PASS.
- **TC-303:** Sub-second timing automated test (200ms between scans) — zero frames contain Patient A's data. PASS.
- **TC-304:** DOM inspection after session purge — zero patient data in DOM, sessionStorage, or component state. PASS.
- **TC-305:** Browser back button does not reveal previous session data. PASS.
- **Manual security test:** Two testers, two cards. Frame-by-frame video analysis of screen during transition. No Patient A data visible after Patient B's scan. PASS.
- **Penetration test:** Browser dev tools, memory dump, network cache — no extractable patient data from previous session after purge. PASS.

### HIPAA Incident Response
- Legal team consulted on breach notification requirements
- Affected patients identified (Patient A whose data was exposed)
- Notification protocol followed per HIPAA breach rules
- Root cause documented for future audits

### Post-Mortem Notes
This bug exposed a fundamental architectural gap: the kiosk was built as a single-page app that re-used component trees between patients. In a healthcare context, each patient session must be treated as a completely isolated environment — not a state update within a persistent app. The three-layer fix ensures that even if one layer fails (e.g., a future developer forgets to reset a state atom), the other layers still prevent exposure. The transition screen is a designed safety net, not just an engineering convenience.

**Classification:** This fix is a security control. Any code change to the kiosk session lifecycle must be reviewed against the Session Purge Protocol. Regressions on session isolation are treated as security incidents, not bugs.

---

## BUG-003: Concurrent Edit by Two Receptionists Causes Silent Data Loss

**Severity:** P1 — Data Integrity
**Reported:** Round 7
**Reporter:** Receptionist (Sarah)
**Status:** Fix verified
**Related:** US-004, ADR-003, DEC-003

### Summary
Two receptionists simultaneously opened and edited the same patient record (Mrs. Rodriguez). Receptionist A updated the insurance payer. Receptionist B updated the phone number. Both clicked Save. Receptionist A's save succeeded, but Receptionist B's save also "succeeded" — silently overwriting Receptionist A's insurance change. The insurance update was lost without any notification to either party.

### Steps to Reproduce
1. Receptionist A opens Mrs. Rodriguez's record on her dashboard
2. Receptionist B opens the same record on her dashboard (within seconds)
3. Receptionist A edits insurance payer from "Aetna" to "Blue Cross" and clicks Save
4. A's save succeeds
5. Receptionist B edits phone number from "555-1234" to "555-5678" and clicks Save
6. B's save succeeds
7. Open Mrs. Rodriguez's record: phone is "555-5678" (B's change), insurance is "Aetna" (A's change was silently lost)

### Expected Behavior
Receptionist B's save should be blocked (or warned) because the record was modified since B loaded it. B should see what changed (A's insurance update) and be able to re-apply her phone change on top of the current data. A's insurance change must not be silently overwritten.

### Actual Behavior
Both saves used a simple `UPDATE ... WHERE id = patient_id` without any version check. The last write won. B's PATCH request only included the phone field, but the lack of a version check meant the system had no way to detect that the record had changed between B loading it and B saving it. The update succeeded, and the server returned a success response. A's insurance change was overwritten because B's request payload was merged over the latest state without conflict detection.

### Root Cause
No concurrency control mechanism existed on the patient record. The API accepted writes from any client regardless of whether the record had been modified since the client loaded it. This is a classic "lost update" problem.

### Fix Description
**Optimistic concurrency control via version field:**

1. **Schema change:** Added `version INTEGER NOT NULL DEFAULT 1` to the `patients` table.
2. **API change:** `PATCH /patients/{id}` now requires a `version` field in the request body.
3. **Write logic:** `UPDATE patients SET ... version = version + 1 WHERE id = $id AND version = $expected_version`. If zero rows updated, the version has changed — conflict detected.
4. **Conflict response:** API returns 409 with `conflicting_changes` object containing: who changed the record, when, and what fields changed (old vs. new values).
5. **Client handling:** Receptionist dashboard shows a conflict banner with two options:
   - "View current version" — refreshes with latest data, discards pending edits
   - "Re-apply my changes" — refreshes with latest data and shows the user's edits as highlighted diffs, letting them selectively re-apply
6. **Version history:** Each version change writes a full snapshot to `patient_record_versions` for audit trail and potential rollback.

### Fix Verification
- **TC-701:** Two receptionists edit same patient, first save succeeds, second save is blocked with conflict banner. PASS.
- **TC-702:** "View current version" refreshes panel, discards unsaved edits. PASS.
- **TC-703:** "Re-apply my changes" shows edits as diffs on latest version. PASS.
- **TC-704:** Normal save (no conflict) succeeds immediately. PASS.
- **TC-705:** Same field edited by two users — conflict properly detected and surfaced. PASS.
- **Stress test:** 10 concurrent edits to the same patient record. Only one succeeds, other 9 get conflict responses. Zero data loss. PASS.

### Post-Mortem Notes
This is a textbook lost-update bug that should have been prevented from the start. Any multi-user system with shared mutable state needs a concurrency control strategy. For a clinic system where data integrity has patient safety implications (e.g., lost insurance update could delay treatment authorization), the "last write wins" model is unacceptable.

The decision to use record-level (not field-level) optimistic locking is a deliberate trade-off: it produces false-positive conflicts when two users edit different fields on the same record. But the resolution flow is fast (review, re-apply), and the alternative (field-level tracking) adds significant complexity for a rare scenario. See ADR-003 for the full rationale.
