# Risk Register — Clinic Check-In System

Areas with weak coverage, architectural vulnerabilities, things that could break silently, and operational risks the team hasn't fully addressed.

---

## RISK-001: Session Isolation Regression
**Severity:** Critical
**Area:** Kiosk security (BUG-002 fix)
**What could go wrong:** A future code change to the kiosk SPA introduces a new React state atom, context provider, or global variable that holds patient data but is not included in the session purge protocol. The three-layer defense works for all currently-known state locations, but new state locations would bypass it.

**Why it matters:** PHI exposure. HIPAA breach. Patient trust destruction.

**Current mitigation:** Session Purge Protocol (ADR-002) with three layers. Automated DOM inspection test (TC-304).

**Gap:** There is no automated check that ensures every new piece of patient-related state is covered by the purge. A developer could add `useState(patientAllergies)` in a new component and forget to reset it. The DOM inspection test only catches data that actually renders — state that is stored but not yet rendered would not be caught.

**Recommendation:**
1. Add a lint rule or architecture test that flags any new state atom/store containing "patient" in its name that is not registered with the purge function.
2. Add a memory heap analysis test (100 consecutive sessions, monitor for unbounded growth) to catch retained references.
3. Make the Session Purge Protocol a mandatory review checklist item for any PR touching kiosk code.

---

## RISK-002: WebSocket Silent Failure Between Heartbeats
**Severity:** High
**Area:** Kiosk-to-receptionist sync (BUG-001 fix)

**What could go wrong:** The WebSocket heartbeat interval is 30 seconds. If the connection dies between heartbeats, there is a window of up to 30 seconds where the server believes the connection is alive but the dashboard is not receiving updates. Check-ins during this window will time out (yellow warning on kiosk after 5s), but the receptionist won't see them until the polling fallback kicks in (another 5s after WebSocket is detected dead).

**Why it matters:** Worst case: patient gets yellow warning, receptionist doesn't see the check-in for up to 35 seconds. Not a data loss issue (data is saved), but a degraded experience.

**Current mitigation:** 5-second timeout on kiosk shows yellow warning. Polling fallback at 5-second interval.

**Gap:** No test for the specific scenario of WebSocket dying between heartbeats (TC-202 simulates a disconnection, but not a silent mid-heartbeat death).

**Recommendation:**
1. Add a test case that kills the WebSocket connection at a random point within the 30-second heartbeat cycle.
2. Consider reducing heartbeat interval to 10 seconds (trade-off: more network traffic).
3. Monitor WebSocket disconnection frequency in production.

---

## RISK-003: Medication Confirmation Immutability Not Enforced at Database Level
**Severity:** High
**Area:** Compliance (Round 6, US-005)

**What could go wrong:** The `medication_confirmations` table is designed to be INSERT-only (no UPDATE, no DELETE). The application layer enforces this, but there is no database-level constraint (trigger or permission restriction) preventing a direct UPDATE or DELETE. A rogue query, a migration script, or a support engineer with DB access could modify or delete audit records.

**Why it matters:** These records are required for state health board license renewal inspections. Tampered records could result in compliance violations, fines, or license revocation.

**Current mitigation:** Application-layer enforcement (ADR-004 mentions adding a trigger "if needed").

**Gap:** The trigger was mentioned but its implementation is not confirmed. TC-605 tests it at the application layer but not at the DB level.

**Recommendation:**
1. Implement a database trigger that blocks UPDATE and DELETE on `medication_confirmations`:
   ```sql
   CREATE FUNCTION prevent_medication_confirmation_changes()
   RETURNS TRIGGER AS $$
   BEGIN
     RAISE EXCEPTION 'medication_confirmations records are immutable';
   END;
   $$ LANGUAGE plpgsql;

   CREATE TRIGGER no_update_med_conf
   BEFORE UPDATE OR DELETE ON medication_confirmations
   FOR EACH ROW EXECUTE FUNCTION prevent_medication_confirmation_changes();
   ```
2. Add a test case that attempts UPDATE and DELETE at the database level (not just API) and verifies they fail.
3. Restrict DB user permissions: the application's DB user should only have INSERT on this table.

---

## RISK-004: False Merge During Riverside Migration
**Severity:** Critical (patient safety)
**Area:** Data migration (Round 10, US-013)

**What could go wrong:** Staff reviewer incorrectly merges two different patients who happen to share the same name and DOB. The merged record combines medication lists and allergy records from two different people. A clinician later relies on the combined record and makes a treatment decision based on wrong medication/allergy data.

**Why it matters:** Patient safety. Wrong medication or missed allergy = potential adverse event or death. Legal liability.

**Current mitigation:** No auto-merge (DEC-006). Side-by-side review with confidence scores. Merge confirmation dialog.

**Gap:** No mechanism to detect or undo a false merge after the fact (short of a full batch rollback, which would undo all merges in the batch, not just the incorrect one). No "un-merge" operation for individual records. The original records are preserved in version history and source_data, but there is no staff-facing workflow to reverse a single merge.

**Recommendation:**
1. Build an individual "un-merge" operation that restores both original records from the preserved snapshots.
2. Add a post-merge validation step: for high-risk merges (combined medication lists from different sources), flag the merged record for a second reviewer.
3. Track merge-override rate during migration (how often staff overrides the default field selection). A high override rate may indicate the dedup algorithm is surfacing poor matches.
4. Add a test case specifically for false merge recovery.

---

## RISK-005: OCR Confidence Thresholds Not Validated Against Real Data
**Severity:** Medium
**Area:** Insurance card OCR (Round 8), Paper record OCR (Round 10)

**What could go wrong:** The confidence thresholds (>= 0.85 = auto-populate, 0.50-0.84 = flag, < 0.50 = leave empty) were set based on engineering judgment, not empirical data. If the real-world OCR confidence distribution is different than expected, the thresholds could be too permissive (auto-populating incorrect data) or too strict (flagging too many fields as low-confidence, adding manual work).

**Why it matters:** Insurance data errors cause claim rejections. Incorrect medication data from paper records is a safety risk.

**Current mitigation:** Thresholds are configurable (per tech design doc). Patient reviews OCR-extracted data before confirming.

**Gap:** No test case measures OCR accuracy against a known-good dataset. No metric tracks how often patients correct OCR-extracted fields (which would indicate false-high-confidence extractions).

**Recommendation:**
1. Create a test set of 50 insurance cards with known correct values. Run OCR and measure: % of fields correctly extracted, confidence scores vs. actual accuracy.
2. After launch, instrument the check-in flow to track: "patient edited an OCR-populated field" events. A high edit rate on high-confidence fields means the threshold is too low.
3. Do the same for Riverside paper records: 50 test records with known values, measure OCR accuracy.

---

## RISK-006: Read Replica Lag During Peak Load
**Severity:** Medium
**Area:** Performance (Round 9)

**What could go wrong:** During peak load, the read replica lag could exceed the target (< 1 second). Dashboard queries and patient search would show stale data. A patient who just checked in might not appear as "checked in" on the dashboard for several seconds — confusing the receptionist.

**Why it matters:** Stale dashboard data during peak hours (the exact scenario we're trying to fix with Round 9 performance improvements) would undermine confidence in the system.

**Current mitigation:** WebSocket pushes handle real-time dashboard updates independently of replica lag. Search staleness of 2-3 seconds is deemed acceptable.

**Gap:** No performance test specifically measures replica lag under load. TC-901 tests response times but does not monitor replica lag independently. The interaction between replica lag and WebSocket updates is not tested — what happens if the WebSocket update arrives but the replica data is stale when the receptionist opens the patient detail panel?

**Recommendation:**
1. Add replica lag monitoring to the performance test suite. Alert at > 2 seconds.
2. Test the specific scenario: patient checks in -> dashboard row updates via WebSocket -> receptionist clicks row to open side panel -> side panel loads from replica -> does the side panel show "checked in" or stale "not checked in"?
3. Ensure the side panel reads check-in status from the WebSocket-updated local state, not from the replica query.

---

## RISK-007: Mobile Check-In PHI Cached on Shared/Public Devices
**Severity:** High
**Area:** Mobile security (Round 3)

**What could go wrong:** A patient completes mobile check-in on a shared device (public computer at a library, family iPad). Despite clearing sessionStorage and cookies on completion, the browser might cache page content (browser back/forward cache, disk cache, autofill, screenshot in app switcher).

**Why it matters:** PHI exposure to the next person using the device.

**Current mitigation:** Session terminated on completion. sessionStorage/localStorage/cookies cleared. Back button shows "already checked in" message.

**Gap:** No test case covers shared/public device scenarios:
- Browser back/forward cache (bfcache) on iOS Safari can restore the full page state
- Browser screenshot in iOS app switcher shows the last-viewed page
- Android Chrome "tabs" view shows a preview of each tab
- Some browsers cache form data even when sessionStorage is cleared

**Recommendation:**
1. Add `Cache-Control: no-store, no-cache, must-revalidate` and `Pragma: no-cache` headers on all mobile check-in pages.
2. Add `<meta name="viewport" content="...">` with no-cache directive.
3. Test bfcache behavior on iOS Safari and Chrome specifically. Use `window.addEventListener('pageshow', (event) => { if (event.persisted) { ... force-clear and redirect } })`.
4. Add a test case for app-switcher screenshot on iOS — verify that the pagehide event triggers a content blur or overlay.
5. Add `autocomplete="off"` on all PHI-containing form fields.

---

## RISK-008: Riverside Migration Timeline Pressure
**Severity:** Medium
**Area:** Project risk (Round 10)

**What could go wrong:** The acquisition has external deadlines. Testing the migration pipeline thoroughly requires a complete dry-run with realistic data volumes (4,000 records, including duplicates). If time pressure forces a truncated test cycle, edge cases in schema mapping, OCR parsing, or dedup scoring could slip through to production.

**Why it matters:** A bad migration is extremely hard to undo. Even with batch rollback, merged records that are then accessed by patients (first-visit confirmation) create downstream data integrity issues.

**Current mitigation:** Batch rollback capability. Phased approach (electronic first, paper later). Patient confirmation on first visit.

**Gap:** No dry-run test plan for the full 4,000-record migration. The test suites cover individual operations (import, detect, merge, rollback) but not an end-to-end simulation at full scale.

**Recommendation:**
1. Create a full-scale dry-run test: generate 4,000 synthetic Riverside records matching the expected data profile (50% electronic, 50% paper, 10% overlap with existing patients).
2. Run the complete pipeline: import, dedup, staff review (sampled), merge, rollback of one batch, first-visit confirmation.
3. Measure: processing time, duplicate detection accuracy (precision and recall against known overlaps), validation error rate, staff review throughput.
4. Do the dry-run at least 2 weeks before the real migration to leave time for threshold tuning and bug fixes.

---

## RISK-009: Kiosk Hardware Failures Not Tested
**Severity:** Medium
**Area:** Physical hardware

**What could go wrong:** The kiosk has physical components (touchscreen, card reader, camera for insurance photos). Hardware failures during a check-in session could leave the system in an inconsistent state — e.g., card reader fails mid-scan, camera freezes during insurance capture, touchscreen becomes unresponsive.

**Why it matters:** Patients are physically standing at the kiosk. A crashed kiosk with no clear error message creates frustration and a bad impression.

**Current mitigation:** Software-level timeouts and error messages exist for scan failures and camera unavailability.

**Gap:** No test cases simulate hardware failures:
- Card reader returns garbage data mid-scan
- Camera feed freezes during insurance capture
- Touchscreen stops responding during check-in
- Network cable disconnected from kiosk during check-in

**Recommendation:**
1. Hardware failure test suite in the kiosk lab: simulate each failure mode and verify the kiosk recovers gracefully (error message + return to welcome screen).
2. Add a "kiosk health check" background process that monitors card reader, camera, and network connectivity — display a "kiosk temporarily out of service" message if critical hardware is unavailable.

---

## RISK-010: Audit Log Completeness
**Severity:** Medium
**Area:** HIPAA compliance

**What could go wrong:** The audit_log table is designed to capture all PHI access and modifications. But audit logging is implemented at the application layer, not the database layer. If a code path accesses patient data without going through the audited service layer (e.g., a batch job, a debugging session, a migration script), the access is not logged.

**Why it matters:** HIPAA requires a record of who accessed PHI, when, and why. Incomplete audit logs are a compliance gap.

**Current mitigation:** All API endpoints log to audit_log.

**Gap:** No test verifies audit log completeness across all access paths. The migration service writes directly to the database — are those writes audited? Staff accessing the admin migration dashboard — is each record view logged?

**Recommendation:**
1. Audit the audit logging: for each API endpoint that returns or modifies patient data, verify that an audit_log entry is created.
2. Ensure the migration service logs all reads and writes to audit_log, especially merge operations.
3. Add database-level audit logging as a backup (PostgreSQL audit extension, pgaudit) to catch direct DB access.
4. Periodic audit log reconciliation: compare patient record version count against audit_log entry count — they should match.

---

## Risk Summary

| # | Risk | Severity | Has Test Coverage | Mitigation Exists | Action Needed |
|---|------|----------|:-:|:-:|---|
| 001 | Session isolation regression | Critical | Partial | Yes | Lint rule, memory heap test |
| 002 | WebSocket silent failure | High | No | Partial | Mid-heartbeat death test |
| 003 | Medication audit immutability at DB level | High | No | Partial (app-layer only) | DB trigger, permission restriction |
| 004 | False merge (patient safety) | Critical | No | Partial (manual review) | Un-merge operation, second reviewer |
| 005 | OCR thresholds not validated | Medium | No | Partial (configurable) | Ground-truth test set |
| 006 | Read replica lag during peak | Medium | No | Partial (WebSocket) | Lag monitoring in load test |
| 007 | Mobile PHI on shared devices | High | No | Partial (session clear) | bfcache test, no-store headers |
| 008 | Migration timeline pressure | Medium | No | Partial (rollback) | Full-scale dry-run |
| 009 | Kiosk hardware failures | Medium | No | Partial (software timeouts) | Hardware failure test suite |
| 010 | Audit log completeness | Medium | No | Partial (API-layer logging) | Audit the audit, pgaudit |
