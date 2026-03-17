# User Stories

## E1: Returning Patient Recognition

### US-001: Pre-populated check-in for returning patients
**As a** returning patient,
**I want** my previously provided information (allergies, insurance, address) to appear pre-filled when I check in,
**so that** I only need to confirm or update — not re-enter everything.

**Acceptance criteria:**
- On scan/identification, system retrieves the patient's most recent record
- Demographics, allergies, insurance, and medications are displayed pre-populated
- Patient can confirm all unchanged fields in a single action
- Patient can edit any individual field before confirming
- Confirmation timestamp is recorded

### US-002: Receptionist sees confirmed check-in data
**As a** receptionist,
**I want** to see the patient's confirmed check-in data on my screen immediately after they complete the kiosk,
**so that** I don't need to ask them to fill out a paper form.

**Acceptance criteria:**
- Receptionist dashboard shows real-time check-in status per patient
- Confirmed data appears within 5 seconds of patient tapping Confirm
- All fields the patient confirmed or edited are visible to the receptionist
- If check-in is incomplete or failed, receptionist sees a clear status (not just absence of data)

**Bug context (Round 2):** Original implementation showed green checkmark to patient but data did not propagate to receptionist screen. Root cause: [Engineering to determine — sync failure between kiosk and staff system]. This story's acceptance criteria must be verified end-to-end, not just on the patient-facing side.

### US-003: Secure patient identification on scan
**As a** patient,
**I want** only my own information to appear when I scan my card,
**so that** my data is private and I don't see anyone else's.

**Acceptance criteria:**
- On card scan, the system retrieves only the matched patient's record
- No other patient's data is rendered, even transiently, in any UI layer (no flash of previous session)
- Session state is fully cleared before loading a new patient's data
- If identification fails, a generic error is shown — no partial data from another patient
- Audit log records each identification event with patient ID and timestamp

**Security requirement (Round 4, P0):** A patient saw another patient's name and allergies briefly on screen after scanning. This is a data exposure incident. The fix must guarantee that the screen buffer, component state, and any cached data from the previous session are fully purged before rendering the next patient's data. This must be verified through security testing, not just functional testing.

### US-004: Concurrent edit safety for patient records
**As a** receptionist,
**I want** the system to prevent data loss when two staff members edit the same patient record simultaneously,
**so that** updates from one person aren't silently overwritten.

**Acceptance criteria:**
- When two users open the same patient record, both can view it
- On save, if the record has been modified since it was loaded, the system blocks the save and shows a conflict notice
- The conflict notice displays what changed and who changed it
- The blocked user can review the current version and re-apply their edits
- No silent data loss — every save either succeeds atomically or fails with a clear explanation

**Bug context (Round 7):** Two receptionists both finalized edits on Mrs. Rodriguez. One receptionist's insurance update was silently lost. The system must implement optimistic concurrency control (version check on write).

### US-005: Medication list confirmation at check-in
**As a** patient,
**I want** to review and confirm my current medication list during check-in,
**so that** my care team has accurate medication information for my visit.

**Acceptance criteria:**
- Medication list is displayed as a mandatory step in the check-in flow (cannot be skipped)
- Patient can confirm the existing list, add medications, remove medications, or edit dosages
- Each medication entry includes: name, dosage, frequency
- Confirmation is timestamped and stored as an auditable record
- If the patient has no medications on file, they are prompted to add any current medications or explicitly confirm "no current medications"
- Applies to every visit, even if the patient confirmed yesterday

**Compliance (Round 6):** State health board mandate, effective Q3. Confirmation must be auditable for license renewal inspection. This is not optional — clinics that don't comply risk losing their license.

### US-006: Peak-hour check-in performance
**As a** receptionist,
**I want** the check-in system to remain responsive during Monday morning rush (30+ simultaneous check-ins),
**so that** patients aren't waiting and walking out.

**Acceptance criteria:**
- Patient search returns results within 2 seconds under load of 50 concurrent sessions
- Kiosk check-in flow (scan to confirmation) completes without freezes or timeouts
- Receptionist dashboard updates within 5 seconds of patient action, even during peak
- System handles 50 concurrent check-in sessions without degradation (target: p95 response time under 3 seconds)
- If a downstream service is slow, the UI shows a loading state — not a frozen screen

**Performance context (Round 9):** Monday mornings between 8-9 AM, 30 patients checking in simultaneously causes kiosk freezes and slow search. Two patients left the clinic this month because of it. Current experience is unacceptable.

---

## E2: Mobile Check-In

### US-007: Pre-visit check-in from personal device
**As a** patient with an upcoming appointment,
**I want** to complete check-in from my phone before I arrive at the clinic,
**so that** I can walk in and go straight to the waiting area.

**Acceptance criteria:**
- Patient receives a check-in link (via SMS, email, or patient portal) before their appointment
- Link opens a mobile-optimized web flow (no app download required)
- Flow includes: identity verification, demographics confirmation, insurance confirmation, allergy confirmation, medication confirmation
- Check-in is valid starting 24 hours before appointment time
- Once completed, kiosk and receptionist see the patient as "checked in — mobile"
- If the patient also checks in at the kiosk, the system recognizes them as already checked in and skips redundant steps

### US-008: Receptionist visibility of mobile check-ins
**As a** receptionist,
**I want** to see which patients checked in via mobile before arriving,
**so that** I can prioritize patients who still need in-person check-in.

**Acceptance criteria:**
- Receptionist dashboard shows check-in channel (mobile / kiosk / walk-in) for each patient
- Mobile check-ins appear with a timestamp of when they were completed
- Receptionist can view what the patient confirmed/changed during mobile check-in
- If mobile check-in is partial (started but not completed), it shows as "in progress"

---

## E3: Multi-Location Support

### US-009: Cross-location patient record access
**As a** patient who visits two clinic locations,
**I want** my information to be the same at both clinics,
**so that** I don't re-enter my details when I visit the other building.

**Acceptance criteria:**
- Patient record is centralized — changes at Location A are immediately visible at Location B
- Check-in at any location retrieves the same pre-populated data
- Appointment history shows visits across all locations
- No "location-specific" copy of patient data — single source of truth

### US-010: Location-aware check-in
**As a** patient,
**I want** the system to know which location I'm checking in at,
**so that** I'm directed to the right waiting area and the right staff see me.

**Acceptance criteria:**
- Kiosk is associated with a specific location
- Mobile check-in prompts the patient to confirm which location their appointment is at
- Receptionist dashboard is filtered to their location by default, with option to search across locations
- Check-in notifications route to the correct location's staff

---

## E4: Insurance Card Photo Capture

### US-011: Photo capture of insurance card
**As a** patient with a new insurance card,
**I want** to take a photo of my card instead of typing the numbers,
**so that** I can update my insurance quickly and accurately.

**Acceptance criteria:**
- Camera capture is available at kiosk and on mobile check-in flow
- Patient is guided to capture front and back of the card
- OCR extracts: member ID, group number, payer name, plan type, effective date
- Extracted fields are shown to the patient for review and correction before saving
- Original images are stored and accessible to staff for reference
- If OCR confidence is low on a field, that field is highlighted for manual review
- Fallback: patient can still manually enter fields if camera is unavailable or OCR fails

---

## E5: Riverside Acquisition

### US-012: Patient data migration from Riverside
**As a** clinic administrator,
**I want** Riverside's 4,000 patient records migrated into our system,
**so that** acquired patients can check in seamlessly at any location.

**Acceptance criteria:**
- Electronic records from Riverside's EMR are mapped and imported
- Paper records are digitized and entered (with a defined pipeline and timeline)
- Each migrated record is validated against our data model — missing required fields are flagged for manual review
- Migration report shows: total records processed, successful imports, records needing review, duplicates found

### US-013: Duplicate patient detection and merge
**As a** clinic administrator,
**I want** the system to detect when a Riverside patient already exists in our system,
**so that** we don't create duplicate records.

**Acceptance criteria:**
- Matching algorithm checks: full name + DOB, SSN (if available), phone number, address
- Potential duplicates are surfaced for staff review with a confidence score
- Staff can confirm merge, reject (keep separate), or flag for further review
- On merge: most recent data wins by default, but staff can choose field-by-field for conflicts
- Merge history is auditable — original records from both systems are preserved as a reference
- No automatic merges without staff confirmation

---

## Bug Stories

### BUG-001: Kiosk confirmation not syncing to receptionist screen
**Priority:** P1
**Reported:** Round 2
**Impact:** Patients complete kiosk check-in but receptionist can't see it, forcing paper fallback.

**Acceptance criteria for fix:**
- After patient confirms on kiosk, data appears on receptionist screen within 5 seconds
- If sync fails, kiosk shows an error state (not a false green checkmark)
- Receptionist screen shows "syncing..." state if data is in transit
- End-to-end verification: kiosk confirm -> receptionist sees data (not just "kiosk sent it")

### BUG-002: Data leak — previous patient's data visible on scan
**Priority:** P0 (Security)
**Reported:** Round 4
**Impact:** Patient saw another patient's name and allergies briefly after scanning their card. PHI exposure.

**Acceptance criteria for fix:**
- Screen is fully cleared (DOM, component state, cached data) before loading a new patient
- No transient render of stale data during the loading transition
- Loading state (spinner or blank) shown between sessions
- Security test: rapid sequential scans of different patient cards must never cross-contaminate displayed data
- Penetration test for session isolation
- Incident response: affected patients notified per HIPAA breach protocol

### BUG-003: Concurrent edit causes silent data loss
**Priority:** P1
**Reported:** Round 7
**Impact:** Two receptionists editing the same patient record — one update silently lost (insurance change gone).

**Acceptance criteria for fix:**
- Optimistic locking: record version checked on save
- If version mismatch, save is blocked with a clear conflict message
- Conflict message shows: who changed it, when, what changed
- User can refresh to see current version and re-apply their changes
- No silent overwrites under any concurrency scenario
