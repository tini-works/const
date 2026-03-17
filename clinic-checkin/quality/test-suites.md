# Test Suites — Clinic Check-In System

Test cases organized by feature area. Each case includes preconditions, steps, and expected results. Traceability to user stories and bugs is noted per case.

---

## Suite 1: Core Kiosk Check-In (Round 1)

### TC-101: Returning patient — happy path check-in
**Traces to:** US-001, US-002
**Precondition:** Patient "Sarah Johnson" exists in the system with demographics, insurance (Aetna, member ID ABC123), allergies (Penicillin — severe), and medications (Lisinopril 10mg once daily). Appointment scheduled for today at 9:15 AM at Main Street Clinic. Kiosk is idle (welcome screen).

**Steps:**
1. Scan Sarah's card at the kiosk
2. Observe the session transition screen
3. On the identity confirmation screen, verify it shows "Welcome back, Sarah" and DOB "03/15/1982"
4. Tap "Yes, that's me"
5. On the demographics review (Step 1/5), verify name, DOB, address, phone, email are pre-populated from stored record
6. Tap "Continue" without editing
7. On insurance review (Step 2/5), verify payer name "Aetna", member ID "ABC123" are pre-populated
8. Tap "Continue"
9. On allergies review (Step 3/5), verify "Penicillin — Severe" pill is displayed
10. Tap "Continue"
11. On medications review (Step 4/5), verify "Lisinopril 10mg — Once daily" card is displayed, compliance notice is visible
12. Tap "I've reviewed my medications — Continue"
13. On confirmation summary (Step 5/5), verify all sections are shown collapsed with correct data
14. Tap "Confirm and check in"
15. Observe the confirmation state

**Expected:**
- Step 2: Transition screen displays for at least 800ms with "Loading your information..." and spinner
- Step 5: All demographic fields match stored record
- Step 12: Continue button text includes "I've reviewed my medications"
- Step 15: Green success message "You're checked in! Please have a seat in the waiting area." appears. 10-second countdown begins. After 10 seconds, kiosk returns to welcome screen.

---

### TC-102: Returning patient — edit demographics during check-in
**Traces to:** US-001
**Precondition:** Same as TC-101.

**Steps:**
1. Proceed through card scan and identity confirmation
2. On demographics review, tap "Edit" next to the Address section
3. Verify the address section expands inline with editable form inputs, other sections are dimmed
4. Change the zip code from "62701" to "62702"
5. Tap "Save"
6. Verify the section collapses back to read-only with the updated zip code "62702" and a green flash
7. Continue through remaining steps and confirm check-in

**Expected:**
- Step 3: Only one section is editable at a time. Other sections at 0.6 opacity.
- Step 5: Brief inline spinner on Save button
- Step 6: Updated value displayed, green flash confirmation (300ms)
- After completing check-in, the patient record in the database has zip_code = "62702"

---

### TC-103: New patient — kiosk check-in
**Traces to:** US-001
**Precondition:** Card "NEW-001" is not associated with any patient record. Kiosk is idle.

**Steps:**
1. Scan card "NEW-001"
2. Observe session transition
3. Verify screen shows "Welcome! Let's get you set up."
4. On demographics (Step 1/5), verify all fields are empty form inputs
5. Enter: First name "James", Last name "Williams", DOB "08/22/1975", Phone "555-123-4567"
6. Leave address and email blank
7. Tap "Continue"
8. On insurance step, enter or skip insurance
9. On allergies, confirm "No known allergies"
10. On medications, confirm "No current medications"
11. Confirm and check in

**Expected:**
- Step 4: Required fields (name, DOB, phone) are marked. Optional fields (address, email) are not required.
- Step 7: Validation passes for required fields
- Step 11: New patient record created. Check-in completes successfully.

---

### TC-104: Card scan failure — fallback to name search
**Traces to:** US-001
**Precondition:** Patient "Sarah Johnson" exists. Kiosk is idle.

**Steps:**
1. Simulate an unreadable card scan
2. Verify error message: "We couldn't read your card. Please try again, or tap below to search by name."
3. Tap "Search by name"
4. On name search screen, type "John" in the search input
5. Verify results appear with "Johnson, Sarah — 03/15/1982" in the list
6. Tap Sarah's name
7. Verify identity confirmation screen appears with "Welcome back, Sarah" and her DOB

**Expected:**
- Step 2: Error message displays; auto-returns to idle after 10 seconds if no action
- Step 5: Results appear within 2 seconds. Max 10 visible results.
- Step 7: Normal check-in flow continues from identity confirmation

---

### TC-105: Card scan — no matching record
**Precondition:** Card "UNKNOWN-001" has no associated patient. Kiosk is idle.

**Steps:**
1. Scan card "UNKNOWN-001"
2. Observe transition screen
3. Verify identification failed message: "We couldn't find your record. Please check with the front desk."

**Expected:**
- No partial data shown
- Screen returns to idle after 10 seconds

---

### TC-106: Identity confirmation — rejection ("That's not me")
**Traces to:** US-003
**Precondition:** Patient exists, card scanned successfully.

**Steps:**
1. Scan a valid card
2. On identity confirmation, tap "That's not me"
3. Verify message: "Please check with the front desk for assistance."

**Expected:**
- No further patient data is shown
- Session ends, screen returns to idle after 5 seconds

---

### TC-107: Kiosk idle timeout
**Precondition:** Patient is on a check-in review screen.

**Steps:**
1. Begin check-in, arrive at demographics review
2. Do not touch the screen for 2 minutes
3. Verify timeout prompt: "Are you still there? [Yes] [Start over]"
4. Wait 30 more seconds without touching

**Expected:**
- Step 3: Prompt appears at 2 minutes of inactivity
- Step 4: After 30s countdown, session purge runs, kiosk returns to welcome screen

---

## Suite 2: Kiosk-to-Receptionist Sync — BUG-001 Fix (Round 2)

### TC-201: Successful sync — green checkmark
**Traces to:** US-002, BUG-001
**Precondition:** Receptionist dashboard is open and connected (WebSocket active). Patient has appointment today.

**Steps:**
1. Patient completes check-in at kiosk, taps "Confirm and check in"
2. Observe the kiosk confirmation state
3. Observe the receptionist dashboard

**Expected:**
- Kiosk: Button shows spinner, then within 5 seconds shows green "You're checked in!"
- Dashboard: Patient's row status changes from "Not Checked In" (gray) to "Checked In" (green) within 5 seconds of kiosk confirmation
- Dashboard row shows channel "Kiosk" and check-in timestamp
- Status bar count updates (e.g., "13 of 18 patients checked in")

---

### TC-202: Sync timeout — yellow warning on kiosk
**Traces to:** US-002, BUG-001
**Precondition:** Receptionist dashboard WebSocket is disrupted (simulate network disconnection on dashboard side).

**Steps:**
1. Disconnect the receptionist dashboard's network connection
2. Patient completes check-in at kiosk
3. Wait 5 seconds
4. Observe kiosk message

**Expected:**
- Kiosk does NOT show green checkmark
- Kiosk shows yellow warning: "Your check-in was saved, but we're having trouble notifying the front desk. Please let the receptionist know you've checked in."
- Patient data IS saved in the database (verify via API)

---

### TC-203: Sync failure — dashboard retry
**Traces to:** US-002, BUG-001
**Precondition:** Dashboard WebSocket was disconnected during a check-in.

**Steps:**
1. After TC-202, observe dashboard behavior
2. Reconnect dashboard network
3. Observe the patient's row on the dashboard

**Expected:**
- While disconnected: row shows "Syncing..." (blue pulse) then "Check-In Failed" (red) after 15 seconds
- After reconnection: dashboard falls back to polling. Row updates to "Checked In" (green) within the next poll cycle (5 seconds)
- "Retry sync" link is clickable and triggers manual re-fetch

---

### TC-204: Dashboard real-time update — WebSocket push
**Traces to:** US-002
**Precondition:** Receptionist dashboard connected via WebSocket. Multiple patients checking in.

**Steps:**
1. Three patients check in at kiosk within 30 seconds
2. Observe dashboard updates

**Expected:**
- Each patient's row updates to green with a brief pulse animation
- Channel column shows "Kiosk" for each
- Notification sound plays (unless muted)
- Status bar counts update in real-time

---

## Suite 3: Session Isolation — BUG-002 Fix (Round 4)

### TC-301: Sequential patients — no data leakage
**Traces to:** US-003, BUG-002
**Precondition:** Two test patients: Patient A (Sarah Johnson, allergy: Penicillin) and Patient B (James Williams, allergy: Latex). Kiosk idle.

**Steps:**
1. Patient A scans card, completes check-in, sees success screen
2. Wait for 10-second countdown to finish and kiosk returns to welcome
3. Patient B scans card
4. Observe the transition screen
5. On identity confirmation, verify it shows Patient B's name and DOB only

**Expected:**
- Step 2: Full session purge runs (DOM cleared, state reset, cache flushed)
- Step 4: Transition screen shows for at least 800ms. No flash of Patient A's data at any point.
- Step 5: Only Patient B's data appears. No trace of "Sarah", "Penicillin", or any Patient A data in the DOM.

---

### TC-302: Rapid sequential scans — no data leakage
**Traces to:** US-003, BUG-002
**Precondition:** Two test patients with distinct data. Kiosk is on Patient A's success screen.

**Steps:**
1. Patient A's success screen is showing (countdown active)
2. Patient B scans card immediately (while countdown is still active, not waiting for it to finish)
3. Observe the screen transition

**Expected:**
- Countdown is interrupted immediately
- Session purge runs instantly
- Transition screen appears for full 800ms
- Patient B's identity confirmation shows — no flash of Patient A's data
- Patient A's in-flight API requests (if any) are cancelled

---

### TC-303: Rapid sequential scans — sub-second timing
**Traces to:** US-003, BUG-002
**Precondition:** Automated test setup. Two different patient cards.

**Steps:**
1. Scan Patient A's card
2. Wait 200ms (transition screen is visible, data fetch may be in progress)
3. Scan Patient B's card (interrupt Patient A's session)
4. Inspect the DOM at every frame during the transition

**Expected:**
- Patient A's data is NEVER rendered in the DOM (the fetch was aborted before it could render)
- Transition screen re-triggers (800ms timer restarts)
- Patient B's data loads after the new transition screen completes
- Zero frames contain Patient A's name, allergies, or any PHI

---

### TC-304: Session purge — DOM inspection
**Traces to:** US-003, BUG-002
**Precondition:** Patient A has completed check-in.

**Steps:**
1. After Patient A's session ends and kiosk returns to welcome
2. Open browser developer tools (for test/lab environment only)
3. Search the DOM for any text matching Patient A's name, DOB, allergies, medications, insurance data
4. Inspect sessionStorage, localStorage, and any in-memory caches

**Expected:**
- Zero DOM elements contain Patient A's data
- sessionStorage is empty
- No patient data in any browser storage
- React component state is null/empty for all patient-related atoms

---

### TC-305: Browser back button does not reveal previous session
**Traces to:** US-003, BUG-002
**Precondition:** Patient A completed check-in. Kiosk returned to welcome.

**Steps:**
1. Press browser back button on the kiosk (if accessible)
2. Observe what the screen shows

**Expected:**
- Back button does not navigate to Patient A's check-in screens
- Either nothing happens, or the welcome screen remains

---

## Suite 4: Mobile Check-In (Round 3)

### TC-401: Mobile check-in — happy path
**Traces to:** US-007, US-008
**Precondition:** Patient Sarah Johnson has appointment tomorrow at 9:15 AM at Main Street Clinic. System sends SMS check-in link 24 hours before.

**Steps:**
1. Open the check-in link on a mobile browser
2. Verify landing page shows: "Check in for your appointment — [tomorrow's date] at 9:15 AM at Main Street Clinic"
3. Enter DOB "03/15/1982" and last 4 of phone "5309"
4. Tap "Verify and continue"
5. On demographics (mobile layout, single-column), verify data is pre-populated
6. Tap "Next"
7. On insurance, verify data is pre-populated
8. Tap "Next"
9. On allergies, verify Penicillin allergy shown
10. Tap "Next"
11. On medications, verify Lisinopril shown, compliance notice visible
12. Tap "I've reviewed my medications — Next"
13. On confirmation, tap "Confirm and check in"
14. Observe confirmation message

**Expected:**
- Step 2: Mobile-optimized layout, progress dots visible
- Step 4: Verification succeeds, session created
- Step 14: "You're checked in! We'll see you on [date] at [time] at Main Street Clinic." No PHI cached in browser after this screen.
- Receptionist dashboard shows "Mobile — Complete" (green + phone icon) for Sarah with timestamp

---

### TC-402: Mobile — identity verification failure
**Traces to:** US-007
**Precondition:** Valid check-in link. Patient enters wrong verification info.

**Steps:**
1. Open check-in link
2. Enter wrong DOB "01/01/1990" and correct last 4 of phone
3. Tap "Verify and continue"
4. Observe error
5. Retry with wrong info two more times

**Expected:**
- Step 4: Red inline error: "The information doesn't match our records. Please try again or call the clinic."
- Step 5: After 3 failed attempts, form is disabled with message: "Please contact the clinic for help" with clinic phone number

---

### TC-403: Mobile — expired link
**Traces to:** US-007
**Precondition:** Appointment was at 9:15 AM, current time is 9:20 AM.

**Steps:**
1. Open the check-in link after appointment time

**Expected:**
- "This check-in link has expired. Please check in at the clinic."
- No verification form shown

---

### TC-404: Mobile — partial completion and resume
**Traces to:** US-007
**Precondition:** Patient opens link, verifies identity, completes demographics and insurance steps.

**Steps:**
1. Complete Steps 1 (demographics) and 2 (insurance) on mobile
2. Close the browser
3. Check receptionist dashboard
4. Reopen the check-in link
5. Re-verify identity (DOB + phone)
6. Observe the resume screen

**Expected:**
- Step 3: Dashboard shows "Mobile — Partial" (yellow + phone icon) for the patient
- Step 6: "Welcome back! You left off at Allergies." with a "Continue" button
- Resuming from Step 3 (allergies), previously confirmed data is intact

---

### TC-405: Mobile then kiosk — duplicate prevention
**Traces to:** US-007
**Precondition:** Patient completed mobile check-in earlier today.

**Steps:**
1. Patient arrives at clinic and scans card at kiosk
2. Observe kiosk behavior

**Expected:**
- Kiosk shows identity confirmation (name + DOB)
- Then immediately shows: "You're already checked in! We received your information earlier. Please have a seat."
- No redundant check-in steps
- Returns to welcome after 10 seconds

---

### TC-406: Mobile — session timeout
**Traces to:** US-007
**Precondition:** Patient has verified identity and is on a review screen.

**Steps:**
1. After verification, do not interact for 4 minutes
2. Observe warning banner
3. Continue to not interact for 1 more minute

**Expected:**
- Step 2: At 4 minutes, banner: "Your session will expire in 1 minute due to inactivity"
- Step 3: At 5 minutes, session expires. Screen shows: "Your session has expired for security. [Start over]"
- Starting over returns to identity verification

---

### TC-407: Mobile — already checked in via mobile
**Traces to:** US-007
**Precondition:** Patient already completed mobile check-in for this appointment.

**Steps:**
1. Open the same check-in link again

**Expected:**
- "You've already checked in for this appointment. See you soon!"
- No verification form, no PHI displayed

---

## Suite 5: Multi-Location (Round 5)

### TC-501: Cross-location patient record — data consistency
**Traces to:** US-009
**Precondition:** Patient "Sarah Johnson" has visited Location A before. Today she has an appointment at Location B. Both locations are configured in the system.

**Steps:**
1. At Location B kiosk, scan Sarah's card
2. Verify identity confirmation shows Sarah's name and DOB
3. On demographics review, verify all data matches what was stored at Location A
4. Continue through all steps, confirm check-in

**Expected:**
- Same data at Location B as was entered/confirmed at Location A
- No re-entry required
- Visit history (if shown) includes previous visits at Location A

---

### TC-502: Location-aware kiosk
**Traces to:** US-010
**Precondition:** Kiosk at Location B is configured with Location B's ID.

**Steps:**
1. Scan a patient's card at Location B kiosk
2. Verify the welcome screen header shows "Elm Street Clinic" (Location B's name)
3. Complete check-in

**Expected:**
- Check-in record has location_id = Location B
- Location B receptionist sees the patient in their queue
- Location A receptionist does NOT see the patient in their default queue view

---

### TC-503: Receptionist — location filter and search
**Traces to:** US-009, US-010
**Precondition:** Receptionist at Location A is logged in. Patient has checked in at Location B.

**Steps:**
1. Verify dashboard defaults to Location A view
2. Confirm the patient who checked in at Location B is NOT visible in the queue
3. Use the search bar to search for the patient's name
4. Verify search returns the patient (search is always cross-location)
5. Switch location selector to "All Locations"
6. Verify the patient's row now appears with a Location column showing "Elm Street Clinic"

**Expected:**
- Step 2: Location A queue filtered by default
- Step 4: Search finds patient across all locations
- Step 6: "All Locations" view shows all patients with location column

---

### TC-504: Mobile check-in — location displayed
**Traces to:** US-010
**Precondition:** Patient has appointment at Location B.

**Steps:**
1. Open mobile check-in link
2. Verify landing page shows the appointment location name

**Expected:**
- "Check in for your appointment — [date] at [time] at Elm Street Clinic"
- Confirmation message after check-in includes location name

---

## Suite 6: Medication Compliance (Round 6)

### TC-601: Medication step is mandatory — cannot skip
**Traces to:** US-005
**Precondition:** Returning patient with medications on file. Kiosk check-in.

**Steps:**
1. Begin check-in, proceed through demographics, insurance, allergies
2. Arrive at medications review (Step 4/5)
3. Verify compliance notice: "Please review your current medications. This is required at every visit."
4. Verify the medication list is displayed
5. Attempt to proceed without reviewing (tap Continue immediately)

**Expected:**
- Step 3: Compliance notice is visible
- Step 5: The "I've reviewed my medications — Continue" button is accessible. The patient must actively tap it, confirming they have reviewed. The step cannot be bypassed by any navigation.

---

### TC-602: Medication confirmation — "confirmed unchanged"
**Traces to:** US-005
**Precondition:** Patient has Lisinopril 10mg once daily and Metformin 500mg twice daily on file. Kiosk check-in.

**Steps:**
1. Arrive at medications step
2. View the medication list (do not edit)
3. Tap "I've reviewed my medications — Continue"
4. Complete check-in
5. Query the `medication_confirmations` table for this check-in

**Expected:**
- Database record shows:
  - `confirmation_type` = "confirmed_unchanged"
  - `medication_snapshot` = JSON array with both medications and their dosages/frequencies
  - `confirmed_at` = timestamp of confirmation
  - `channel` = "kiosk"

---

### TC-603: Medication confirmation — "modified"
**Traces to:** US-005
**Precondition:** Patient has Lisinopril on file.

**Steps:**
1. Arrive at medications step
2. Tap "Add medication"
3. Add "Amlodipine, 5mg, Once daily"
4. Tap "I've reviewed my medications — Continue"
5. Complete check-in
6. Query `medication_confirmations` table

**Expected:**
- `confirmation_type` = "modified"
- `medication_snapshot` includes both Lisinopril AND Amlodipine
- The `medications` table now has both medications for this patient

---

### TC-604: Medication confirmation — "confirmed none"
**Traces to:** US-005
**Precondition:** Patient has no medications on file.

**Steps:**
1. Arrive at medications step
2. Verify prompt: "No medications on file. Please add any current medications, or confirm you take none."
3. Tap "No current medications"
4. Continue and complete check-in
5. Query `medication_confirmations` table

**Expected:**
- `confirmation_type` = "confirmed_none"
- `medication_snapshot` = empty array `[]`
- Audit record is present and immutable

---

### TC-605: Medication confirmation — immutability
**Traces to:** US-005
**Precondition:** A medication confirmation record exists from a previous check-in.

**Steps:**
1. Attempt to UPDATE the `medication_confirmations` record directly in the database
2. Attempt to DELETE the record

**Expected:**
- Both operations should be blocked (if database trigger is in place) or at minimum the application layer never issues UPDATE/DELETE on this table
- The record remains unchanged regardless of subsequent patient data modifications

---

### TC-606: Medication step on mobile
**Traces to:** US-005, US-007
**Precondition:** Patient doing mobile check-in.

**Steps:**
1. Complete mobile check-in through demographics, insurance, allergies
2. Arrive at medications step (Step 4/5)
3. Verify compliance notice and medication list are displayed
4. Confirm medications
5. Complete check-in

**Expected:**
- Medication step is mandatory on mobile, same as kiosk
- Medication confirmation audit record is created with `channel` = "mobile"

---

## Suite 7: Concurrent Edit Safety — BUG-003 Fix (Round 7)

### TC-701: Two receptionists — conflict detection
**Traces to:** US-004, BUG-003
**Precondition:** Patient "Mrs. Rodriguez" exists (version 5). Two receptionist sessions open (Receptionist A and B).

**Steps:**
1. Receptionist A opens Mrs. Rodriguez's record in the side panel
2. Receptionist B opens the same record in her side panel
3. Receptionist A edits insurance payer from "Aetna" to "Blue Cross" and clicks Save
4. Verify A's save succeeds (green flash, version incremented to 6)
5. Receptionist B edits phone from "555-1234" to "555-5678" and clicks Save

**Expected:**
- Step 4: Save succeeds. Record version is now 6.
- Step 5: Save is BLOCKED. Conflict banner appears at top of B's panel:
  - "This record was updated by [Receptionist A] at [time]."
  - "Changed: Insurance payer from Aetna to Blue Cross"
  - Two buttons: "View current version" and "Re-apply my changes"
- B's phone edit is NOT silently discarded
- No data loss — A's insurance change is preserved in the database

---

### TC-702: Conflict resolution — "View current version"
**Traces to:** US-004, BUG-003
**Precondition:** Continuing from TC-701 where B's save was blocked.

**Steps:**
1. Receptionist B clicks "View current version"
2. Observe panel state

**Expected:**
- Panel refreshes with version 6 data (A's insurance change is visible)
- B's unsaved phone edit is discarded
- B can now re-edit the phone number and save successfully (version will become 7)

---

### TC-703: Conflict resolution — "Re-apply my changes"
**Traces to:** US-004, BUG-003
**Precondition:** Continuing from TC-701 where B's save was blocked.

**Steps:**
1. Receptionist B clicks "Re-apply my changes"
2. Observe panel state

**Expected:**
- Panel refreshes with version 6 data
- B's phone edit is shown as a highlighted diff/pending change on top of the latest data
- B can review, confirm, and save — resulting in version 7
- Both A's insurance change and B's phone change are preserved

---

### TC-704: No conflict — normal save
**Traces to:** US-004
**Precondition:** Only one receptionist has the patient record open.

**Steps:**
1. Open patient record (version 5)
2. Edit address
3. Click Save

**Expected:**
- Save succeeds immediately
- Green flash confirmation
- Record version incremented to 6
- No conflict banner

---

### TC-705: Concurrent edit — same field by two users
**Traces to:** US-004, BUG-003
**Precondition:** Two receptionists both open the same patient (version 5).

**Steps:**
1. Both A and B edit the insurance payer
2. A changes to "Blue Cross" and saves (succeeds, version 6)
3. B changes to "United Health" and saves

**Expected:**
- B's save is blocked with conflict banner
- Banner shows A's change to "Blue Cross"
- No silent overwrite — B must explicitly choose to keep Blue Cross or override with United Health

---

## Suite 8: Insurance Card Photo Capture — OCR (Round 8)

### TC-801: Photo capture — happy path on kiosk
**Traces to:** US-011
**Precondition:** Patient is on the insurance review step. Kiosk camera is functional.

**Steps:**
1. Tap "Update with a photo of your card"
2. Camera viewfinder opens with card-shaped guide overlay
3. Hold insurance card in the frame (front side), tap "Capture"
4. Review preview, tap "Use this photo"
5. Prompted for back side: "Now flip your card — back side"
6. Capture back, tap "Use this photo"
7. Observe "Reading your card..." with spinner
8. OCR results populate the insurance fields

**Expected:**
- Step 8: Fields are populated with OCR-extracted values
- High-confidence fields (>= 0.85) have blue highlight: "Read from your insurance card"
- Low-confidence fields (0.50-0.84) have yellow highlight: "Please verify — we weren't sure"
- Very low confidence fields (< 0.50) are left empty for manual entry
- Patient can review and edit any field before continuing

---

### TC-802: Photo capture — OCR failure
**Traces to:** US-011
**Precondition:** Use a deliberately unreadable image (blank card, badly blurred).

**Steps:**
1. Capture front and back photos (poor quality)
2. Wait for OCR processing

**Expected:**
- "We couldn't read your card. Please enter the information manually."
- Insurance fields remain empty/editable for manual entry
- OCR failure does NOT block check-in progress

---

### TC-803: Photo capture — camera permission denied
**Traces to:** US-011
**Precondition:** Browser/kiosk camera permission is denied.

**Steps:**
1. Tap "Update with a photo of your card"
2. Deny camera permission

**Expected:**
- "Camera access is needed to take a photo. You can enter your information manually instead."
- "Enter manually" button dismisses the overlay
- Patient can type insurance info normally

---

### TC-804: Photo capture on mobile
**Traces to:** US-011, US-007
**Precondition:** Patient is on mobile check-in, insurance step.

**Steps:**
1. Tap "Take a photo of your insurance card"
2. Grant camera permission
3. Capture front and back (portrait orientation)
4. Wait for upload + OCR

**Expected:**
- Camera uses device's native camera via web API
- Upload progress bar is visible during upload
- OCR results populate fields same as kiosk
- If upload fails on mobile network: "Upload failed. [Retry] or [enter manually]"

---

### TC-805: Insurance card photos stored and accessible to staff
**Traces to:** US-011
**Precondition:** Patient completed photo capture during check-in.

**Steps:**
1. On receptionist dashboard, open the patient's record
2. In the Insurance section, look for card photo thumbnail
3. Tap thumbnail to view full-size image

**Expected:**
- Thumbnail is visible in the insurance section
- Full-size image loads (via presigned URL, valid for 15 minutes)
- Both front and back images are accessible

---

## Suite 9: Performance — Peak Load (Round 9)

### TC-901: 50 concurrent kiosk check-ins — response time
**Traces to:** US-006
**Precondition:** Load test environment with 50 test patient identities and appointments. Load testing tool configured.

**Steps:**
1. Simulate 50 concurrent check-in sessions (card scan through confirmation)
2. Measure response time for each API call
3. Measure end-to-end check-in time

**Expected:**
- Patient search: < 2 seconds (p95)
- All API endpoints: < 3 seconds (p95)
- No kiosk screen freezes — loading states shown instead
- No request timeouts
- All 50 check-ins complete successfully

---

### TC-902: Patient search performance under load
**Traces to:** US-006
**Precondition:** Database has 10,000+ patient records. 30 concurrent users performing name searches.

**Steps:**
1. Simulate 30 concurrent name search queries ("John", "Smith", "Will")
2. Measure time from query submission to results display

**Expected:**
- Results returned within 2 seconds
- Debounce (300ms) prevents excessive queries
- Search input remains interactive (no freeze)
- Spinner appears after 500ms of waiting

---

### TC-903: Dashboard stability during peak
**Traces to:** US-006
**Precondition:** Receptionist dashboard connected. 30 patients checking in simultaneously.

**Steps:**
1. Observe dashboard while 30 check-ins happen in rapid succession
2. Attempt to search, click patient rows, open side panels during peak

**Expected:**
- Dashboard never freezes
- Rows update in real-time (within 5 seconds of each check-in)
- Search is responsive
- Side panel opens and loads data without hanging
- If responses are slow (> 3s), yellow dot appears: "System is running slowly"

---

### TC-904: Degraded mode — slow backend
**Traces to:** US-006
**Precondition:** Artificially slow the backend to > 3 seconds per response.

**Steps:**
1. Attempt kiosk check-in
2. Observe loading states
3. Observe dashboard

**Expected:**
- Kiosk: "Still loading... please wait." after 3 seconds on transition screen
- Kiosk: "The system is running slowly. Your information is loading — please wait." after 10 seconds
- Kiosk: Error message and return to welcome after 30 seconds
- Dashboard: Yellow connection indicator, shimmer states on loading rows

---

### TC-905: Degraded mode — backend unreachable
**Traces to:** US-006
**Precondition:** Backend is completely down.

**Steps:**
1. Attempt kiosk check-in
2. Observe kiosk after 30-second timeout
3. Observe dashboard

**Expected:**
- Kiosk: After 30 seconds, "Check-in is temporarily unavailable. Please see the front desk."
- Dashboard: Red banner "Connection lost — data may not be current. Last updated: [timestamp]." Shows last-loaded data.
- Mobile: "Check-in is temporarily unavailable. Please try again later, or check in at the clinic when you arrive."

---

## Suite 10: Riverside Data Migration (Round 10)

### TC-1001: EMR import — valid records
**Traces to:** US-012
**Precondition:** Batch of 100 test Riverside EMR records in their schema format. All records have valid required fields.

**Steps:**
1. Submit batch import via `POST /migration/batches/{id}/import`
2. Monitor migration dashboard
3. Verify imported records

**Expected:**
- All 100 records processed
- Records with no duplicates: status = "imported", `patient_confirmed` = FALSE, `migration_source` = "riverside_emr"
- Migration dashboard shows correct counts
- Each patient record is created with correct field mapping (Riverside `patient_first` -> `first_name`, etc.)

---

### TC-1002: EMR import — validation failures
**Traces to:** US-012
**Precondition:** Batch includes records with missing required fields (e.g., no DOB, no last name).

**Steps:**
1. Submit batch with intentionally invalid records
2. Check migration dashboard for flagged records

**Expected:**
- Invalid records have status = "import_error"
- `validation_errors` field lists specific issues (e.g., `[{"field": "date_of_birth", "error": "missing"}]`)
- Valid records in the same batch are still imported
- Error count is accurate in batch summary

---

### TC-1003: Duplicate detection — exact match
**Traces to:** US-013
**Precondition:** Existing patient "Sarah M. Johnson, DOB 03/15/1982, phone 555-867-5309". Riverside record: "Sarah Johnson, DOB 03/15/1982, phone 555-867-5309".

**Steps:**
1. Import the Riverside record
2. Check duplicate detection results

**Expected:**
- Record flagged as "potential_duplicate"
- Confidence score >= 0.70 (name+DOB+phone match)
- Match reasons include "name_dob_match" and "phone_match"
- Record appears in the staff review queue

---

### TC-1004: Duplicate detection — no match
**Traces to:** US-013
**Precondition:** Riverside record for a patient who does NOT exist in our system.

**Steps:**
1. Import the record
2. Check duplicate detection results

**Expected:**
- No duplicate candidates found
- Record imported as new patient with `patient_confirmed` = FALSE

---

### TC-1005: Staff merge review — field-level merge
**Traces to:** US-013
**Precondition:** A duplicate candidate exists: our record vs. Riverside record with differing insurance and middle name.

**Steps:**
1. Staff opens the duplicate review screen
2. Verify side-by-side comparison: our record (left), Riverside record (right)
3. Matching fields shown in green, differing fields in yellow
4. For middle name: select "Keep ours" (we have "M", Riverside has none)
5. For insurance: select "Keep theirs" (Riverside has more recent insurance)
6. For medications: select "Merge both"
7. Click "Merge records"
8. Confirm merge dialog

**Expected:**
- Merged patient record has: middle_name = "M" (ours), insurance from Riverside, combined medication list
- Both original records preserved (our version in patient_record_versions, Riverside in migration_records.source_data)
- Duplicate candidate status = "merged"
- Audit log records the merge with staff ID and field decisions

---

### TC-1006: Staff review — keep separate
**Traces to:** US-013
**Precondition:** Two records flagged as potential duplicates but are actually different people.

**Steps:**
1. Staff opens duplicate review
2. Determines they are different people (same name/DOB, different address/phone)
3. Clicks "Keep separate"

**Expected:**
- Both records remain independent
- Duplicate candidate status = "duplicate_resolved" (kept separate)
- Riverside record is imported as a new patient

---

### TC-1007: Migration rollback
**Traces to:** US-012
**Precondition:** A batch of 100 records was imported, including 5 that were merged with existing patients.

**Steps:**
1. Execute rollback: `POST /migration/batches/{id}/rollback`
2. Verify all imported records
3. Verify merged records

**Expected:**
- All 95 newly-created patients are soft-deleted (deleted_at is set)
- The 5 merged patients are restored to their pre-merge state (from patient_record_versions)
- Medications/allergies/insurance from the Riverside source are removed
- Batch status = "rolled_back"
- All migration_records status = "rolled_back"
- Duplicate candidate resolutions are cleared

---

### TC-1008: First visit after migration — patient confirmation
**Traces to:** US-012
**Precondition:** Riverside patient "Maria Garcia" was imported (patient_confirmed = FALSE). She visits the clinic for the first time.

**Steps:**
1. Maria scans her card at the kiosk
2. After identity confirmation, observe migration notice
3. Review demographics — some fields may have yellow highlights (low OCR confidence)
4. Review all steps, make corrections as needed
5. Confirm check-in

**Expected:**
- Step 2: Blue info banner: "We recently migrated your records from Riverside Family Practice. Please carefully review all your information to make sure it's correct."
- Step 3: Low-confidence OCR fields highlighted in yellow with "Please verify this field"
- Step 5: After confirmation, `patient_confirmed` is set to TRUE
- Subsequent visits: no migration notice banner

---

### TC-1009: Paper record OCR pipeline
**Traces to:** US-012
**Precondition:** Scanned paper record PDF uploaded to object storage.

**Steps:**
1. Submit paper record for OCR processing
2. Monitor OCR results
3. Review extracted data in migration dashboard

**Expected:**
- OCR extracts fields with per-field confidence scores
- High-confidence (> 0.85): auto-populated in mapped_data
- Low-confidence (< 0.85): flagged for manual review
- Record enters validation pipeline same as EMR records
- Scanned document URL is stored for staff reference

---

### TC-1010: Duplicate detection — near miss (below threshold)
**Traces to:** US-013
**Precondition:** Riverside record with same phone as existing patient but different name and DOB.

**Steps:**
1. Import the record
2. Check duplicate detection

**Expected:**
- Phone-only match scores 0.20, which is below the 0.40 threshold
- Record is NOT flagged as duplicate
- Record is imported as a new patient
- This is correct behavior — phone numbers can be reused

---

### TC-1011: No auto-merge verification
**Traces to:** US-013
**Precondition:** Import a batch with high-confidence duplicates (score > 0.95).

**Steps:**
1. Import batch with obvious duplicates (same name, DOB, SSN, phone, address)
2. Check if any records were auto-merged

**Expected:**
- NO auto-merges occurred, regardless of confidence score
- All potential duplicates are in "potential_duplicate" status awaiting staff review
- This is a safety requirement (DEC-006) — every merge needs human confirmation

---

## Suite 11: Accessibility

### TC-1101: Kiosk screen reader compatibility
**Precondition:** Screen reader enabled on kiosk.

**Steps:**
1. Navigate through entire check-in flow using screen reader
2. Verify all interactive elements have ARIA labels
3. Verify error messages are announced via aria-live regions
4. Verify focus management (edit section -> focus to first input; collapse -> focus returns)

**Expected:**
- All buttons, links, form fields have descriptive ARIA labels
- Status changes are announced
- Focus moves predictably

---

### TC-1102: Touch target sizes
**Precondition:** Kiosk and mobile devices.

**Steps:**
1. Measure touch targets on all interactive elements

**Expected:**
- Kiosk: minimum 44x44px
- Mobile: minimum 48x48px
- Including edit links, allergy pills, medication cards, buttons

---

### TC-1103: Color-independent status indication
**Precondition:** Receptionist dashboard.

**Steps:**
1. View all status badges
2. Verify each badge has both icon AND text label, not just color

**Expected:**
- "Checked In" has checkmark icon + text (not just green color)
- "Failed" has X icon + text (not just red color)
- All badges include icon + text

---

## Suite 12: API Contract Verification

### TC-1201: PATCH /patients/{id} — version required
**Steps:**
1. Send PATCH request without version field
2. Send PATCH request with incorrect version

**Expected:**
- Without version: 400 Bad Request or 422 Validation error
- With wrong version: 409 Conflict with `conflicting_changes` details

---

### TC-1202: POST /checkins/{id}/complete — medication confirmation required
**Steps:**
1. Send complete request without `medication_confirmation` field

**Expected:**
- 400 or 422 error — medication confirmation is mandatory per compliance

---

### TC-1203: Rate limiting on patient search
**Steps:**
1. Send 100 search requests in rapid succession from one client

**Expected:**
- After threshold, 429 response with `retry_after_seconds`
- System remains responsive for other clients

---

### TC-1204: Mobile token expiry enforcement
**Steps:**
1. Use a token for an appointment that already passed
2. Use a token that was already used to complete check-in

**Expected:**
- Expired: 410 Gone
- Already used: 409 with `already_checked_in` and completion timestamp
