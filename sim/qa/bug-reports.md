# Bug Reports — Clinic Check-In System

---

## BUG-001: Kiosk Confirmation Shows Green Checkmark But Receptionist Sees Nothing

**Severity:** P1 — Core flow broken
**Reported:** Round 2
**Reporter:** Patient (via complaint)
**Status:** Fix verified
**Related:** US-002, ADR-001

### Summary
Patient completed kiosk check-in, saw green confirmation checkmark, but the receptionist had no data on her screen. Patient was asked to fill out a paper form despite having "successfully" checked in.

### Steps to Reproduce
1. Open receptionist dashboard
2. At the kiosk, scan a valid patient card
3. Complete check-in through all steps
4. Tap "Confirm and check in"
5. Observe green checkmark on kiosk
6. Check receptionist dashboard — patient still shows "Not Checked In"

### Expected Behavior
After green checkmark on kiosk, receptionist dashboard should show the patient as "Checked In" with all confirmed data.

### Actual Behavior
Kiosk showed green checkmark immediately after the API returned a successful save response. The WebSocket push to the dashboard had no acknowledgment mechanism. The green checkmark confirmed the kiosk-side save, not end-to-end delivery.

### Root Cause
Two failures:
1. **No ack mechanism:** WebSocket delivery was fire-and-forget. The system assumed push succeeded if the connection was "open."
2. **No fallback:** If the WebSocket connection was silently dead, updates were permanently lost.

### Fix Description
- **WebSocket ack:** Dashboard sends acknowledgment for each check-in update received.
- **Kiosk waits for ack:** Up to 5 seconds.
  - Ack received: green checkmark (sync confirmed)
  - No ack within 5s: yellow warning ("saved, but front desk wasn't notified")
  - Save failed: red error with retry
- **Polling fallback:** Dashboard falls back to polling every 5 seconds if WebSocket drops.
- **Heartbeat:** Server ping every 30s, pong expected within 10s.

### Fix Verification
- **TC-201:** Successful sync — green checkmark only after dashboard ack. PASS.
- **TC-202:** Disconnected dashboard — kiosk shows yellow warning, not green. PASS.
- **TC-203:** Reconnected dashboard picks up data via polling fallback. PASS.
- **Regression:** 20 consecutive check-ins, all confirmed on both sides. No false green checkmarks.

### Post-Mortem
The mistake was showing success based on a partial operation. "Saved to DB" is not "receptionist can see it." The fix gates the success indicator on the outcome the patient cares about. Honest feedback beats false confidence.

---

## BUG-002: Previous Patient's Data Briefly Visible on Kiosk After Card Scan

**Severity:** P0 — Security / PHI Exposure / Potential HIPAA Breach
**Reported:** Round 4
**Reporter:** Patient (via complaint)
**Status:** Fix verified
**Related:** US-003, ADR-002, DD-001

### Summary
A patient scanned their card at the kiosk and briefly saw another patient's name and allergies on screen before it switched to their own data. PHI exposure for approximately 200-400 milliseconds. Potential HIPAA breach.

### Steps to Reproduce
1. Patient A scans card, completes check-in, sees success screen
2. Before the 10-second countdown finishes, Patient B scans their card
3. For ~200-400ms, Patient A's data (name, allergies) flashes before Patient B's data loads

### Expected Behavior
After Patient B scans, the screen should show a loading/transition screen with zero trace of Patient A's data.

### Actual Behavior
React component tree retained state from Patient A's session. During re-render for Patient B, old data remained visible in the DOM for a fraction of a second.

### Root Cause
React's reconciliation model updates the DOM incrementally. When the new data fetch resolved, the old data was replaced — but during the gap between "new scan detected" and "new data arrived," old data remained rendered. Specifically:
- React state atoms were not reset before the new fetch
- React Query cache contained Patient A's data
- Component tree was re-rendered (not destroyed/rebuilt)
- No visual barrier between patient sessions

### Fix Description
Three-layer defense-in-depth (Session Purge Protocol):

**Layer 1 — Application State Reset:** Cancel in-flight API requests (AbortController), clear all React state atoms, flush query cache, clear sessionStorage.

**Layer 2 — DOM Destruction:** Increment a React `key` on SessionBoundary, forcing full unmount/remount (not re-render) of the patient component subtree.

**Layer 3 — Transition Screen Barrier:** Branded loading screen between every patient session. Minimum 800ms display. Data fetch begins only after this screen renders.

**Sequencing:** Card scan -> state reset -> DOM destroy -> transition screen renders -> 800ms wait -> data fetch -> identity confirmation.

### Fix Verification
- **TC-301:** Sequential patients, normal timing — no leakage. PASS.
- **TC-302:** Rapid scan during countdown — no leakage. PASS.
- **TC-303:** Sub-second timing (200ms between scans) — zero frames with stale data. PASS.
- **TC-304:** DOM inspection after purge — zero patient data in DOM/storage/state. PASS.
- **TC-305:** Browser back button — no previous session data. PASS.
- **Manual security test:** Frame-by-frame video analysis. No Patient A data after Patient B scan. PASS.
- **Penetration test:** Dev tools, memory dump, network cache — no extractable data from previous session. PASS.

### HIPAA Response
- Legal consulted on breach notification
- Affected patients identified
- Notification protocol followed
- Root cause documented for audits

### Post-Mortem
The kiosk was built as a single-page app that reused component trees between patients. In healthcare, each patient session must be treated as a completely isolated environment. The three-layer fix ensures that even if one layer fails, the others prevent exposure. The transition screen is a designed safety net, not just an engineering convenience. Any code change to the kiosk session lifecycle must be reviewed against this protocol. Regressions are treated as security incidents.

---

## BUG-003: Concurrent Edit by Two Receptionists Causes Silent Data Loss

**Severity:** P1 — Data Integrity
**Reported:** Round 7
**Reporter:** Receptionist (Sarah)
**Status:** Fix verified
**Related:** US-004, ADR-003, DEC-003

### Summary
Two receptionists simultaneously opened and edited the same patient record (Mrs. Rodriguez). Receptionist A updated the insurance payer. Receptionist B updated the phone number. Both saved. B's save silently overwrote A's insurance change. The insurance update was lost without notification.

### Steps to Reproduce
1. Receptionist A opens Mrs. Rodriguez's record
2. Receptionist B opens the same record (within seconds)
3. A edits insurance payer from "Aetna" to "Blue Cross" and saves — succeeds
4. B edits phone from "555-1234" to "555-5678" and saves — also "succeeds"
5. Open Mrs. Rodriguez's record: phone is "555-5678" (B's change), insurance is "Aetna" (A's change lost)

### Expected Behavior
B's save should be blocked because the record was modified since B loaded it. B should see what changed (A's insurance update) and re-apply her phone change on top of current data.

### Actual Behavior
Both saves used `UPDATE ... WHERE id = patient_id` without version check. Last write won. A's insurance change silently overwritten.

### Root Cause
No concurrency control on patient records. The API accepted writes regardless of whether the record changed since the client loaded it. Classic "lost update" problem.

### Fix Description
**Optimistic concurrency control via version field:**

1. Added `version INTEGER NOT NULL DEFAULT 1` to `patients` table
2. `PATCH /patients/{id}` requires `version` in request body
3. Write: `UPDATE ... WHERE id = $id AND version = $expected_version`. Zero rows updated = conflict.
4. On conflict: API returns 409 with `conflicting_changes` (who, when, what fields changed)
5. Dashboard shows conflict banner with "View current version" or "Re-apply my changes"
6. Version history: each change writes snapshot to `patient_record_versions`

### Fix Verification
- **TC-701:** Two receptionists edit same patient — first succeeds, second blocked with conflict banner. PASS.
- **TC-702:** "View current version" refreshes, discards edits. PASS.
- **TC-703:** "Re-apply my changes" shows edits as diffs on latest version. PASS.
- **TC-704:** Normal single-user save succeeds immediately. PASS.
- **TC-705:** Same field edited by two users — conflict detected. PASS.
- **Stress test:** 10 concurrent edits to same record. Only one succeeds. Zero data loss. PASS.

### Post-Mortem
A textbook lost-update bug that should have been prevented from the start. Any multi-user system with shared mutable state needs concurrency control. For a clinic system where data integrity has patient safety implications, "last write wins" is unacceptable. Record-level (not field-level) optimistic locking is a deliberate trade-off: false-positive conflicts are possible when editing different fields, but the resolution is fast and the alternative adds permanent complexity for a rare scenario.
