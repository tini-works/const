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

**Traceability:**
- Traced from: [E1: Returning Patient Recognition](epics.md#e1-returning-patient-recognition) — Round 1 patient complaint
- Matched by:
  - [Screen 1.1: Kiosk Welcome](../experience/screen-specs.md#11-kiosk-welcome-screen), [Screen 1.3: Identity Confirmation](../experience/screen-specs.md#13-patient-identification-confirmation-screen), [Screen 1.4: Demographics Review](../experience/screen-specs.md#14-check-in-review-screen--demographics), [Screen 1.5: Insurance Review](../experience/screen-specs.md#15-check-in-review-screen--insurance), [Screen 1.6: Allergies Review](../experience/screen-specs.md#16-check-in-review-screen--allergies), [Screen 1.8: Confirmation](../experience/screen-specs.md#18-check-in-confirmation-screen)
  - [Flow 1: Returning Patient — Kiosk Check-In](../experience/user-flows.md#1-returning-patient--kiosk-check-in-happy-path), [Flow 2: New Patient — Kiosk Check-In](../experience/user-flows.md#2-new-patient--kiosk-check-in), [Flow 3: Card Scan Failures](../experience/user-flows.md#3-card-scan-failures)
  - API: [POST /patients/identify](../architecture/api-spec.md#post-patientsidentify), [GET /patients/{id}](../architecture/api-spec.md#get-patientsid), [PATCH /patients/{id}](../architecture/api-spec.md#patch-patientsid)
- Proven by: [TC-101](../quality/test-suites.md#tc-101-returning-patient--happy-path-check-in), [TC-102](../quality/test-suites.md#tc-102-returning-patient--edit-demographics-during-check-in), [TC-103](../quality/test-suites.md#tc-103-new-patient--kiosk-check-in), [TC-104](../quality/test-suites.md#tc-104-card-scan-failure--fallback-to-name-search)
- Verification: **proven** — TC-101 through TC-105 passing in staging, all 5 AC covered. Verified 2024-03-15.

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

**Traceability:**
- Traced from: [E1: Returning Patient Recognition](epics.md#e1-returning-patient-recognition) — Round 2 sync failure
- Matched by:
  - [Screen 2.1: Receptionist Dashboard](../experience/screen-specs.md#21-receptionist-dashboard--main-view), [Screen 2.2: Patient Detail Panel](../experience/screen-specs.md#22-receptionist--patient-detail-side-panel)
  - [Flow 5: Kiosk-to-Receptionist Sync](../experience/user-flows.md#5-kiosk-to-receptionist-sync-bug-001-fix)
  - API: [GET /dashboard/queue](../architecture/api-spec.md#get-dashboardqueue), [WebSocket /ws/dashboard/{location_id}](../architecture/api-spec.md#websocket-wsdashboardlocation_id)
  - [ADR-001: WebSocket with Polling Fallback](../architecture/adrs.md#adr-001-websocket-with-polling-fallback-for-real-time-dashboard-updates)
- Proven by: [TC-201](../quality/test-suites.md#tc-201-successful-sync--green-checkmark), [TC-202](../quality/test-suites.md#tc-202-sync-timeout--yellow-warning-on-kiosk), [TC-203](../quality/test-suites.md#tc-203-sync-failure--dashboard-retry), [TC-204](../quality/test-suites.md#tc-204-dashboard-real-time-update--websocket-push)
- Bug: [BUG-001](../quality/bug-reports.md#bug-001-kiosk-confirmation-shows-green-checkmark-but-receptionist-sees-nothing)
- Verification: **proven** — TC-201 through TC-204 passing, end-to-end sync verified in staging. ADR-001 implemented. Verified 2024-03-18.

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

**Traceability:**
- Traced from: [E1: Returning Patient Recognition](epics.md#e1-returning-patient-recognition) — Round 4 security incident
- Matched by:
  - [Screen 1.2: Session Transition](../experience/screen-specs.md#12-session-transition-screen), [Screen 1.3: Identity Confirmation](../experience/screen-specs.md#13-patient-identification-confirmation-screen)
  - [Flow 4: Data Leak Prevention](../experience/user-flows.md#4-data-leak-prevention--between-patients-bug-002-fix)
  - [ADR-002: Session Purge Protocol](../architecture/adrs.md#adr-002-session-purge-protocol-for-kiosk-state-isolation)
- Proven by: [TC-301](../quality/test-suites.md#tc-301-sequential-patients--no-data-leakage), [TC-302](../quality/test-suites.md#tc-302-rapid-sequential-scans--no-data-leakage), [TC-303](../quality/test-suites.md#tc-303-rapid-sequential-scans--sub-second-timing), [TC-304](../quality/test-suites.md#tc-304-session-purge--dom-inspection), [TC-305](../quality/test-suites.md#tc-305-browser-back-button-does-not-reveal-previous-session)
- Bug: [BUG-002](../quality/bug-reports.md#bug-002-previous-patients-data-briefly-visible-on-kiosk-after-card-scan)
- Verification: **proven** (partial gap) — TC-301 through TC-305 passing, security test signed off. Audit log AC (scan events logged with patient ID + timestamp) lacks explicit test coverage — see [coverage report](../quality/coverage-report.md). Verified 2024-03-20.

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

**Traceability:**
- Traced from: [E1: Returning Patient Recognition](epics.md#e1-returning-patient-recognition) — Round 7 data loss incident
- Matched by:
  - [Screen 2.2: Patient Detail Panel](../experience/screen-specs.md#22-receptionist--patient-detail-side-panel) (conflict banner spec)
  - [Flow 10: Concurrent Edit Conflict](../experience/user-flows.md#10-concurrent-edit-conflict-bug-003-fix)
  - API: [PATCH /patients/{id}](../architecture/api-spec.md#patch-patientsid) (409 version conflict response)
  - [ADR-003: Optimistic Concurrency Control](../architecture/adrs.md#adr-003-optimistic-concurrency-control-via-version-field)
- Proven by: [TC-701](../quality/test-suites.md#tc-701-two-receptionists--conflict-detection), [TC-702](../quality/test-suites.md#tc-702-conflict-resolution--view-current-version), [TC-703](../quality/test-suites.md#tc-703-conflict-resolution--re-apply-my-changes), [TC-704](../quality/test-suites.md#tc-704-no-conflict--normal-save), [TC-705](../quality/test-suites.md#tc-705-concurrent-edit--same-field-by-two-users)
- Bug: [BUG-003](../quality/bug-reports.md#bug-003-concurrent-edit-by-two-receptionists-causes-silent-data-loss)
- Verification: **proven** — TC-701 through TC-705 passing, ADR-003 optimistic locking implemented. Verified 2024-03-22.

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

**Traceability:**
- Traced from: [E6: Compliance — Medication List](epics.md#e6-compliance--medication-list-at-check-in) — Round 6 state mandate
- Matched by:
  - [Screen 1.7: Medications Review](../experience/screen-specs.md#17-check-in-review-screen--medications), [Screen 3.2: Mobile Review](../experience/screen-specs.md#32-mobile--review-screens-demographics-insurance-allergies-medications)
  - [Flow 1: Returning Patient — Step 4 Medications](../experience/user-flows.md#1-returning-patient--kiosk-check-in-happy-path), [Flow 6: Mobile Check-In — Step 4](../experience/user-flows.md#6-mobile-check-in--happy-path)
  - API: [POST /checkins/{id}/complete](../architecture/api-spec.md#post-checkinsidcomplete) (medication_confirmation required)
  - [ADR-004: Immutable Medication Confirmation Audit Records](../architecture/adrs.md#adr-004-immutable-medication-confirmation-audit-records)
- Proven by: [TC-601](../quality/test-suites.md#tc-601-medication-step-is-mandatory--cannot-skip), [TC-602](../quality/test-suites.md#tc-602-medication-confirmation--confirmed-unchanged), [TC-603](../quality/test-suites.md#tc-603-medication-confirmation--modified), [TC-604](../quality/test-suites.md#tc-604-medication-confirmation--confirmed-none), [TC-605](../quality/test-suites.md#tc-605-medication-confirmation--immutability), [TC-606](../quality/test-suites.md#tc-606-medication-step-on-mobile)
- Verification: **proven** — TC-601 through TC-606 passing, immutability audit confirmed, ADR-004 implemented. Verified 2024-03-25.

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

**Traceability:**
- Traced from: [E1: Returning Patient Recognition](epics.md#e1-returning-patient-recognition) — Round 9 performance complaints
- Matched by:
  - [Screen 1.9: Name Search](../experience/screen-specs.md#19-kiosk-name-search-screen), [Screens 5.1-5.4: Loading & Degraded States](../experience/screen-specs.md#5-loading--degraded-states)
  - [Flow 15: Peak Load Degraded Experience](../experience/user-flows.md#15-peak-load-degraded-experience-round-9)
  - [ADR-007: Scaling Strategy for 50 Concurrent Sessions](../architecture/adrs.md#adr-007-scaling-strategy-for-50-concurrent-sessions)
  - Decision: [DEC-007](decision-log.md#dec-007-performance-target--50-concurrent-sessions-p95-under-3-seconds)
- Proven by: [TC-901](../quality/test-suites.md#tc-901-50-concurrent-kiosk-check-ins--response-time), [TC-902](../quality/test-suites.md#tc-902-patient-search-performance-under-load), [TC-903](../quality/test-suites.md#tc-903-dashboard-stability-during-peak), [TC-904](../quality/test-suites.md#tc-904-degraded-mode--slow-backend), [TC-905](../quality/test-suites.md#tc-905-degraded-mode--backend-unreachable)
- Verification: **proven** — TC-901 through TC-905 passing, load test report shows p95 < 3s at 50 concurrent sessions. Verified 2024-04-02.

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

**Traceability:**
- Traced from: [E2: Mobile Check-In](epics.md#e2-mobile-check-in) — Round 3 patient request, [PRD: Mobile Check-In](prd-mobile-checkin.md)
- Matched by:
  - [Screen 3.1: Mobile Landing / Identity Verification](../experience/screen-specs.md#31-mobile--link-landing--identity-verification), [Screen 3.2: Mobile Review Screens](../experience/screen-specs.md#32-mobile--review-screens-demographics-insurance-allergies-medications), [Screen 3.3: Mobile Confirmation](../experience/screen-specs.md#33-mobile--confirmation-screen)
  - [Flow 6: Mobile Check-In — Happy Path](../experience/user-flows.md#6-mobile-check-in--happy-path), [Flow 7: Mobile Partial Completion](../experience/user-flows.md#7-mobile-check-in--partial-completion), [Flow 8: Mobile-to-Kiosk Duplicate Prevention](../experience/user-flows.md#8-mobile-check-in--kiosk-arrival-duplicate-prevention)
  - API: [POST /patients/verify-identity](../architecture/api-spec.md#post-patientsverify-identity), [POST /mobile-checkin/send-link](../architecture/api-spec.md#post-mobile-checkinsend-link), [POST /checkins](../architecture/api-spec.md#post-checkins)
  - Decision: [DEC-004: Mobile web, not native app](decision-log.md#dec-004-mobile-check-in-via-mobile-web-not-native-app)
- Proven by: [TC-401](../quality/test-suites.md#tc-401-mobile-check-in--happy-path), [TC-402](../quality/test-suites.md#tc-402-mobile--identity-verification-failure), [TC-403](../quality/test-suites.md#tc-403-mobile--expired-link), [TC-404](../quality/test-suites.md#tc-404-mobile--partial-completion-and-resume), [TC-405](../quality/test-suites.md#tc-405-mobile-then-kiosk--duplicate-prevention), [TC-406](../quality/test-suites.md#tc-406-mobile--session-timeout), [TC-407](../quality/test-suites.md#tc-407-mobile--already-checked-in-via-mobile)
- Verification: **suspect** — TC-401 through TC-407 passing for core flow, but SMS/email link delivery untested (Twilio sandbox dependency). Cross-browser matrix (iOS Safari, Chrome Android) not verified. Last verified 2024-04-05.

### US-008: Receptionist visibility of mobile check-ins
**As a** receptionist,
**I want** to see which patients checked in via mobile before arriving,
**so that** I can prioritize patients who still need in-person check-in.

**Acceptance criteria:**
- Receptionist dashboard shows check-in channel (mobile / kiosk / walk-in) for each patient
- Mobile check-ins appear with a timestamp of when they were completed
- Receptionist can view what the patient confirmed/changed during mobile check-in
- If mobile check-in is partial (started but not completed), it shows as "in progress"

**Traceability:**
- Traced from: [E2: Mobile Check-In](epics.md#e2-mobile-check-in) — Round 3, [PRD: Mobile Check-In](prd-mobile-checkin.md)
- Matched by:
  - [Screen 2.1: Receptionist Dashboard](../experience/screen-specs.md#21-receptionist-dashboard--main-view) (channel column, mobile status badges)
  - [Flow 6: Mobile Check-In — Happy Path](../experience/user-flows.md#6-mobile-check-in--happy-path) (receptionist dashboard update), [Flow 7: Partial Completion](../experience/user-flows.md#7-mobile-check-in--partial-completion)
  - API: [GET /dashboard/queue](../architecture/api-spec.md#get-dashboardqueue) (check_in_channel, mobile_partial status)
- Proven by: [TC-401](../quality/test-suites.md#tc-401-mobile-check-in--happy-path) (dashboard shows "Mobile — Complete"), [TC-404](../quality/test-suites.md#tc-404-mobile--partial-completion-and-resume) (dashboard shows "Mobile — Partial")
- Verification: **proven** — all 4 AC covered by TC-401 and TC-404 dashboard assertions. Verified 2024-04-05.

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

**Traceability:**
- Traced from: [E3: Multi-Location Support](epics.md#e3-multi-location-support) — Round 5, [PRD: Multi-Location Support](prd-multi-location.md)
- Matched by:
  - [Screen 2.1: Receptionist Dashboard](../experience/screen-specs.md#21-receptionist-dashboard--main-view) (location selector, cross-location search)
  - [Flow 11: Multi-Location Check-In](../experience/user-flows.md#11-multi-location-check-in)
  - [ADR-005: Centralized Database](../architecture/adrs.md#adr-005-centralized-database-for-multi-location-no-replication)
  - Decision: [DEC-005: Centralized patient record](decision-log.md#dec-005-centralized-patient-record-for-multi-location-not-syncreplicate)
- Proven by: [TC-501](../quality/test-suites.md#tc-501-cross-location-patient-record--data-consistency), [TC-503](../quality/test-suites.md#tc-503-receptionist--location-filter-and-search)
- Verification: **suspect** — TC-501 and TC-503 cover centralized record and search, but appointment history UI showing cross-location visits lacks explicit verification. Verified 2024-04-10.

### US-010: Location-aware check-in
**As a** patient,
**I want** the system to know which location I'm checking in at,
**so that** I'm directed to the right waiting area and the right staff see me.

**Acceptance criteria:**
- Kiosk is associated with a specific location
- Mobile check-in prompts the patient to confirm which location their appointment is at
- Receptionist dashboard is filtered to their location by default, with option to search across locations
- Check-in notifications route to the correct location's staff

**Traceability:**
- Traced from: [E3: Multi-Location Support](epics.md#e3-multi-location-support) — Round 5, [PRD: Multi-Location Support](prd-multi-location.md)
- Matched by:
  - [Screen 2.1: Receptionist Dashboard](../experience/screen-specs.md#21-receptionist-dashboard--main-view) (location-filtered queue), [Screen 3.1: Mobile Landing](../experience/screen-specs.md#31-mobile--link-landing--identity-verification) (location in appointment info)
  - [Flow 11: Multi-Location Check-In](../experience/user-flows.md#11-multi-location-check-in), [Flow 12: Mobile Check-In — Multi-Location](../experience/user-flows.md#12-mobile-check-in--multi-location)
  - API: [POST /checkins](../architecture/api-spec.md#post-checkins) (location_id), [WebSocket /ws/dashboard/{location_id}](../architecture/api-spec.md#websocket-wsdashboardlocation_id)
  - [ADR-005: Centralized Database](../architecture/adrs.md#adr-005-centralized-database-for-multi-location-no-replication) (location scoping model)
- Proven by: [TC-502](../quality/test-suites.md#tc-502-location-aware-kiosk), [TC-503](../quality/test-suites.md#tc-503-receptionist--location-filter-and-search), [TC-504](../quality/test-suites.md#tc-504-mobile-check-in--location-displayed)
- Verification: **proven** — TC-502 through TC-504 cover all 4 AC. Verified 2024-04-10.

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

**Traceability:**
- Traced from: [E4: Insurance Card Photo Capture](epics.md#e4-insurance-card-photo-capture) — Round 8 patient frustration
- Matched by:
  - [Screen 1.5: Insurance Review](../experience/screen-specs.md#15-check-in-review-screen--insurance), [Screen 1.5a: Photo Capture Overlay](../experience/screen-specs.md#15a-insurance-card-photo-capture-overlay), [Screen 3.2: Mobile Review](../experience/screen-specs.md#32-mobile--review-screens-demographics-insurance-allergies-medications)
  - [Flow 9: Insurance Card Photo Capture](../experience/user-flows.md#9-insurance-card-photo-capture)
  - API: [POST /patients/{id}/insurance/{type}/photo](../architecture/api-spec.md#post-patientsidinsurancetypephoto), [GET /patients/{id}/insurance/{type}/photo/status/{processing_id}](../architecture/api-spec.md#get-patientsidinsurancetypephotostatusprocessing_id)
  - [ADR-006: OCR Service](../architecture/adrs.md#adr-006-ocr-service-as-a-separate-service-behind-a-stable-api-contract), [ADR-009: Object Storage](../architecture/adrs.md#adr-009-object-storage-for-insurance-card-photos-and-scanned-records)
- Proven by: [TC-801](../quality/test-suites.md#tc-801-photo-capture--happy-path-on-kiosk), [TC-802](../quality/test-suites.md#tc-802-photo-capture--ocr-failure), [TC-803](../quality/test-suites.md#tc-803-photo-capture--camera-permission-denied), [TC-804](../quality/test-suites.md#tc-804-photo-capture-on-mobile), [TC-805](../quality/test-suites.md#tc-805-insurance-card-photos-stored-and-accessible-to-staff)
- Verification: **suspect** — TC-801 through TC-805 cover primary insurance flow, but secondary insurance card photo capture and client-side blurry image detection are untested. Verified 2024-04-15.

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

**Traceability:**
- Traced from: [E5: Riverside Practice Acquisition](epics.md#e5-riverside-practice-acquisition) — Round 10, [PRD: Riverside Acquisition](prd-riverside-acquisition.md)
- Matched by:
  - [Screen 4.1: Admin Migration Dashboard](../experience/screen-specs.md#41-admin--migration-dashboard)
  - [Flow 13: First Visit After Migration](../experience/user-flows.md#13-riverside-migration--first-visit-after-migration)
  - API: [POST /migration/batches](../architecture/api-spec.md#post-migrationbatches), [POST /migration/batches/{batch_id}/import](../architecture/api-spec.md#post-migrationbatchesbatch_idimport), [GET /migration/batches/{batch_id}](../architecture/api-spec.md#get-migrationbatchesbatch_id), [POST /migration/batches/{batch_id}/rollback](../architecture/api-spec.md#post-migrationbatchesbatch_idrollback)
  - [ADR-009: Object Storage](../architecture/adrs.md#adr-009-object-storage-for-insurance-card-photos-and-scanned-records), [ADR-010: Migration Pipeline](../architecture/adrs.md#adr-010-migration-pipeline-architecture--batch-import-with-rollback)
  - Decision: [DEC-008: Digitization pipeline](decision-log.md#dec-008-riverside-paper-records--digitization-pipeline-not-bulk-data-entry)
- Proven by: [TC-1001](../quality/test-suites.md#tc-1001-emr-import--valid-records), [TC-1002](../quality/test-suites.md#tc-1002-emr-import--validation-failures), [TC-1007](../quality/test-suites.md#tc-1007-migration-rollback), [TC-1008](../quality/test-suites.md#tc-1008-first-visit-after-migration--patient-confirmation), [TC-1009](../quality/test-suites.md#tc-1009-paper-record-ocr-pipeline)
- Verification: **suspect** — TC-1001, TC-1002, TC-1007 through TC-1009 cover core import and rollback. Gaps: medication frequency mapping (BID -> twice_daily), batch review flow, and migration dashboard live counts untested. Verified 2024-04-18.

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

**Traceability:**
- Traced from: [E5: Riverside Practice Acquisition](epics.md#e5-riverside-practice-acquisition) — Round 10, [PRD: Riverside Acquisition](prd-riverside-acquisition.md)
- Matched by:
  - [Screen 4.2: Duplicate Review](../experience/screen-specs.md#42-admin--duplicate-review-screen)
  - [Flow 14: Duplicate Detection — Staff Review](../experience/user-flows.md#14-duplicate-detection--staff-review-riverside)
  - API: [GET /migration/duplicates/{id}](../architecture/api-spec.md#get-migrationduplicatesid), [POST /migration/duplicates/{id}/resolve](../architecture/api-spec.md#post-migrationduplicatesidresolve)
  - [ADR-008: Duplicate Detection Algorithm](../architecture/adrs.md#adr-008-duplicate-detection-algorithm-for-riverside-migration)
  - Decision: [DEC-006: No auto-merge](decision-log.md#dec-006-duplicate-detection-requires-staff-confirmation--no-auto-merge)
- Proven by: [TC-1003](../quality/test-suites.md#tc-1003-duplicate-detection--exact-match), [TC-1004](../quality/test-suites.md#tc-1004-duplicate-detection--no-match), [TC-1005](../quality/test-suites.md#tc-1005-staff-merge-review--field-level-merge), [TC-1006](../quality/test-suites.md#tc-1006-staff-review--keep-separate), [TC-1010](../quality/test-suites.md#tc-1010-duplicate-detection--near-miss-below-threshold), [TC-1011](../quality/test-suites.md#tc-1011-no-auto-merge-verification)
- Verification: **proven** — TC-1003 through TC-1006, TC-1010, TC-1011 cover all 6 AC including no-auto-merge. Verified 2024-04-18.

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

**Traceability:**
- Traced from: [E1](epics.md#e1-returning-patient-recognition) — Round 2
- Related stories: [US-002](#us-002-receptionist-sees-confirmed-check-in-data)
- Matched by: [Flow 5: Kiosk-to-Receptionist Sync](../experience/user-flows.md#5-kiosk-to-receptionist-sync-bug-001-fix), [Screen 1.8 sync failure state](../experience/screen-specs.md#18-check-in-confirmation-screen), [ADR-001](../architecture/adrs.md#adr-001-websocket-with-polling-fallback-for-real-time-dashboard-updates)
- Proven by: [TC-201](../quality/test-suites.md#tc-201-successful-sync--green-checkmark), [TC-202](../quality/test-suites.md#tc-202-sync-timeout--yellow-warning-on-kiosk), [TC-203](../quality/test-suites.md#tc-203-sync-failure--dashboard-retry)
- Bug report: [BUG-001](../quality/bug-reports.md#bug-001-kiosk-confirmation-shows-green-checkmark-but-receptionist-sees-nothing)
- Verification: **proven** — TC-201 through TC-203 passing, ADR-001 WebSocket + polling fallback verified end-to-end. Verified 2024-03-18.

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

**Traceability:**
- Traced from: [E1](epics.md#e1-returning-patient-recognition) — Round 4, [DEC-001](decision-log.md#dec-001-bug-002-elevated-to-p0-blocks-all-e1-feature-work)
- Related stories: [US-003](#us-003-secure-patient-identification-on-scan)
- Matched by: [Flow 4: Data Leak Prevention](../experience/user-flows.md#4-data-leak-prevention--between-patients-bug-002-fix), [Screen 1.2: Session Transition](../experience/screen-specs.md#12-session-transition-screen), [ADR-002](../architecture/adrs.md#adr-002-session-purge-protocol-for-kiosk-state-isolation)
- Proven by: [TC-301](../quality/test-suites.md#tc-301-sequential-patients--no-data-leakage) through [TC-305](../quality/test-suites.md#tc-305-browser-back-button-does-not-reveal-previous-session)
- Bug report: [BUG-002](../quality/bug-reports.md#bug-002-previous-patients-data-briefly-visible-on-kiosk-after-card-scan)
- Verification: **proven** — TC-301 through TC-305 passing, ADR-002 session purge protocol verified including DOM inspection and penetration test. Verified 2024-03-20.

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

**Traceability:**
- Traced from: [E1](epics.md#e1-returning-patient-recognition) — Round 7, [DEC-003](decision-log.md#dec-003-optimistic-concurrency-control-for-patient-records)
- Related stories: [US-004](#us-004-concurrent-edit-safety-for-patient-records)
- Matched by: [Flow 10: Concurrent Edit Conflict](../experience/user-flows.md#10-concurrent-edit-conflict-bug-003-fix), [Screen 2.2 conflict banner](../experience/screen-specs.md#22-receptionist--patient-detail-side-panel), [ADR-003](../architecture/adrs.md#adr-003-optimistic-concurrency-control-via-version-field)
- Proven by: [TC-701](../quality/test-suites.md#tc-701-two-receptionists--conflict-detection) through [TC-705](../quality/test-suites.md#tc-705-concurrent-edit--same-field-by-two-users)
- Bug report: [BUG-003](../quality/bug-reports.md#bug-003-concurrent-edit-by-two-receptionists-causes-silent-data-loss)
- Verification: **proven** — TC-701 through TC-705 passing, ADR-003 optimistic concurrency control verified with multi-user scenarios. Verified 2024-03-22.
