# Epics

## E1: Returning Patient Recognition

**Goal:** Patients who have visited before should never re-enter information the clinic already has.

**Origin:** Round 1 — patient complaint about repeated data entry across visits.

**Scope:**
- Store patient demographic, insurance, and allergy data persistently
- Retrieve and pre-populate on subsequent visits
- Allow patients to confirm or update (not re-enter) existing info
- Kiosk and receptionist views must reflect the same stored data

**Known issues:**
- Kiosk confirmation does not sync to receptionist screen (Round 2) — resolved as BUG-001
- Patient data briefly showing another patient's record on scan (Round 4) — resolved as BUG-002 (P0 security)
- Concurrent edits by two staff members cause data loss (Round 7) — resolved as BUG-003

**Compliance impact:** Medication list must be collected and confirmed at every visit per state mandate (Round 6). Added to check-in confirmation flow.

**Performance requirement:** System must handle 30+ concurrent check-ins during peak hours without degradation (Round 9).

**Traceability:**

| Link type | References |
|-----------|------------|
| User Stories | [US-001](user-stories.md#us-001-pre-populated-check-in-for-returning-patients), [US-002](user-stories.md#us-002-receptionist-sees-confirmed-check-in-data), [US-003](user-stories.md#us-003-secure-patient-identification-on-scan), [US-004](user-stories.md#us-004-concurrent-edit-safety-for-patient-records), [US-005](user-stories.md#us-005-medication-list-confirmation-at-check-in), [US-006](user-stories.md#us-006-peak-hour-check-in-performance) |
| Bug Stories | [BUG-001](user-stories.md#bug-001-kiosk-confirmation-not-syncing-to-receptionist-screen), [BUG-002](user-stories.md#bug-002-data-leak--previous-patients-data-visible-on-scan), [BUG-003](user-stories.md#bug-003-concurrent-edit-causes-silent-data-loss) |
| Decisions | [DEC-001](decision-log.md#dec-001-bug-002-elevated-to-p0-blocks-all-e1-feature-work), [DEC-002](decision-log.md#dec-002-medication-confirmation-is-mandatory-in-the-check-in-flow-not-optional), [DEC-003](decision-log.md#dec-003-optimistic-concurrency-control-for-patient-records), [DEC-007](decision-log.md#dec-007-performance-target--50-concurrent-sessions-p95-under-3-seconds) |
| Architecture | [ADR-001](../architecture/adrs.md#adr-001-websocket-with-polling-fallback-for-real-time-dashboard-updates), [ADR-002](../architecture/adrs.md#adr-002-session-purge-protocol-for-kiosk-state-isolation), [ADR-003](../architecture/adrs.md#adr-003-optimistic-concurrency-control-via-version-field), [ADR-004](../architecture/adrs.md#adr-004-immutable-medication-confirmation-audit-records), [ADR-007](../architecture/adrs.md#adr-007-scaling-strategy-for-50-concurrent-sessions) |
| Confirmed by | Sarah Chen (PM Lead), 2024-04-02 |

**Verification:** 6/6 stories proven, 3/3 bugs proven. US-003 has a partial gap on audit log AC (no explicit test for scan event logging). Last verified 2024-04-02.

---

## E2: Mobile Check-In

**Goal:** Patients can complete check-in from their personal device before arriving at the clinic.

**Origin:** Round 3 — patient wants to confirm info from home instead of at the kiosk.

**Scope:**
- Pre-visit check-in via mobile browser or app
- Same confirmation/update flow as kiosk (demographics, insurance, allergies, medications)
- Time-bounded: check-in valid within a window before the appointment
- Receptionist sees mobile check-in status — no need to re-process at arrival

**Dependencies:** E1 (returning patient data must exist), E4 (medication confirmation mandate applies to mobile too).

**See:** [PRD — Mobile Check-In](prd-mobile-checkin.md)

**Traceability:**

| Link type | References |
|-----------|------------|
| User Stories | [US-007](user-stories.md#us-007-pre-visit-check-in-from-personal-device), [US-008](user-stories.md#us-008-receptionist-visibility-of-mobile-check-ins) |
| PRD | [PRD: Mobile Check-In](prd-mobile-checkin.md) |
| Decisions | [DEC-004](decision-log.md#dec-004-mobile-check-in-via-mobile-web-not-native-app) |
| Screens | [3.1 Mobile Landing](../experience/screen-specs.md#31-mobile--link-landing--identity-verification), [3.2 Mobile Review](../experience/screen-specs.md#32-mobile--review-screens-demographics-insurance-allergies-medications), [3.3 Mobile Confirmation](../experience/screen-specs.md#33-mobile--confirmation-screen) |
| Flows | [Flow 6: Mobile Happy Path](../experience/user-flows.md#6-mobile-check-in--happy-path), [Flow 7: Partial Completion](../experience/user-flows.md#7-mobile-check-in--partial-completion), [Flow 8: Duplicate Prevention](../experience/user-flows.md#8-mobile-check-in--kiosk-arrival-duplicate-prevention) |
| Confirmed by | Sarah Chen (PM Lead), 2024-04-05 |

**Verification:** 1/2 stories proven, 1 suspect (US-007 — SMS/email delivery and cross-browser untested). Last verified 2024-04-05.

---

## E3: Multi-Location Support

**Goal:** Patients visiting any clinic location see their same information without re-entry.

**Origin:** Round 5 — clinic opening a second location, patients may visit both.

**Scope:**
- Centralized patient record accessible across all locations
- Location-aware check-in (patient selects or is detected at a location)
- Staff permissions scoped per location
- Data consistency across locations (no sync lag that would cause re-entry)

**Dependencies:** E1 (patient record structure), E5 (acquisition will add locations with foreign data).

**See:** [PRD — Multi-Location Support](prd-multi-location.md)

**Traceability:**

| Link type | References |
|-----------|------------|
| User Stories | [US-009](user-stories.md#us-009-cross-location-patient-record-access), [US-010](user-stories.md#us-010-location-aware-check-in) |
| PRD | [PRD: Multi-Location Support](prd-multi-location.md) |
| Decisions | [DEC-005](decision-log.md#dec-005-centralized-patient-record-for-multi-location-not-syncreplicate) |
| Architecture | [ADR-005](../architecture/adrs.md#adr-005-centralized-database-for-multi-location-no-replication) |
| Flows | [Flow 11: Multi-Location Check-In](../experience/user-flows.md#11-multi-location-check-in), [Flow 12: Mobile Multi-Location](../experience/user-flows.md#12-mobile-check-in--multi-location) |
| Confirmed by | Sarah Chen (PM Lead), 2024-04-10 |

**Verification:** 1/2 stories proven, 1 suspect (US-009 — cross-location appointment history UI unverified). Admin cross-location view and staff permissions per location untested. Last verified 2024-04-10.

---

## E4: Insurance Card Photo Capture

**Goal:** Patients can photograph their insurance card instead of manually entering card numbers.

**Origin:** Round 8 — patient frustrated reading tiny numbers off a new insurance card at the kiosk.

**Scope:**
- Camera capture on kiosk and mobile
- OCR extraction of key fields (member ID, group number, payer name, plan type)
- Patient reviews and confirms extracted data before submission
- Stored image available for staff reference

**Dependencies:** E2 (mobile flow needs this too), E1 (insurance data storage).

**Traceability:**

| Link type | References |
|-----------|------------|
| User Stories | [US-011](user-stories.md#us-011-photo-capture-of-insurance-card) |
| Architecture | [ADR-006](../architecture/adrs.md#adr-006-ocr-service-as-a-separate-service-behind-a-stable-api-contract), [ADR-009](../architecture/adrs.md#adr-009-object-storage-for-insurance-card-photos-and-scanned-records) |
| Screens | [1.5a Photo Capture Overlay](../experience/screen-specs.md#15a-insurance-card-photo-capture-overlay) |
| Flows | [Flow 9: Insurance Card Photo Capture](../experience/user-flows.md#9-insurance-card-photo-capture) |
| Confirmed by | Alex Kim (Engineering), 2024-04-15 |

**Verification:** 0/1 stories proven, 1 suspect (US-011 — secondary insurance photo and blurry image detection untested). Last verified 2024-04-15.

---

## E5: Riverside Practice Acquisition

**Goal:** Absorb 4,000 patients from Riverside Family Practice into our system without duplicates or data loss.

**Origin:** Round 10 — clinic acquiring another practice with mixed paper/electronic records on a different system.

**Scope:**
- Data migration from Riverside's EMR system
- Paper record digitization pipeline
- Duplicate detection and merge for patients existing in both systems
- Patient identity verification post-migration
- Riverside locations added to multi-location infrastructure

**Dependencies:** E3 (multi-location must be in place), E1 (patient data model must handle merge conflicts).

**See:** [PRD — Riverside Acquisition Migration](prd-riverside-acquisition.md)

**Traceability:**

| Link type | References |
|-----------|------------|
| User Stories | [US-012](user-stories.md#us-012-patient-data-migration-from-riverside), [US-013](user-stories.md#us-013-duplicate-patient-detection-and-merge) |
| PRD | [PRD: Riverside Acquisition](prd-riverside-acquisition.md) |
| Decisions | [DEC-006](decision-log.md#dec-006-duplicate-detection-requires-staff-confirmation--no-auto-merge), [DEC-008](decision-log.md#dec-008-riverside-paper-records--digitization-pipeline-not-bulk-data-entry) |
| Architecture | [ADR-008](../architecture/adrs.md#adr-008-duplicate-detection-algorithm-for-riverside-migration), [ADR-009](../architecture/adrs.md#adr-009-object-storage-for-insurance-card-photos-and-scanned-records), [ADR-010](../architecture/adrs.md#adr-010-migration-pipeline-architecture--batch-import-with-rollback) |
| Screens | [4.1 Migration Dashboard](../experience/screen-specs.md#41-admin--migration-dashboard), [4.2 Duplicate Review](../experience/screen-specs.md#42-admin--duplicate-review-screen) |
| Flows | [Flow 13: First Visit After Migration](../experience/user-flows.md#13-riverside-migration--first-visit-after-migration), [Flow 14: Duplicate Detection — Staff Review](../experience/user-flows.md#14-duplicate-detection--staff-review-riverside) |
| Confirmed by | Sarah Chen (PM Lead), 2024-04-18 |

**Verification:** 1/2 stories proven (US-013), 1 suspect (US-012 — medication frequency mapping, batch review flow, and dashboard live counts untested). Last verified 2024-04-18.

---

## E6: Compliance — Medication List at Check-In

**Goal:** Meet state health board mandate requiring medication list collection and confirmation at every visit.

**Origin:** Round 6 — state regulatory notice, mandatory for license renewal effective Q3.

**Scope:**
- Add current medication list to the check-in confirmation flow
- Patient must explicitly confirm or update medications each visit
- Confirmation is timestamped and auditable
- Applies to all check-in channels: kiosk, receptionist, mobile

**Dependencies:** E1 (check-in flow), E2 (mobile check-in must include this).

**Deadline:** Hard — must be live before Q3 license renewal period.

**Traceability:**

| Link type | References |
|-----------|------------|
| User Stories | [US-005](user-stories.md#us-005-medication-list-confirmation-at-check-in) |
| Decisions | [DEC-002](decision-log.md#dec-002-medication-confirmation-is-mandatory-in-the-check-in-flow-not-optional) |
| Architecture | [ADR-004](../architecture/adrs.md#adr-004-immutable-medication-confirmation-audit-records) |
| Screens | [1.7 Medications Review](../experience/screen-specs.md#17-check-in-review-screen--medications) |
| Flows | [Flow 1 Step 4](../experience/user-flows.md#1-returning-patient--kiosk-check-in-happy-path), [Flow 6 Step 4](../experience/user-flows.md#6-mobile-check-in--happy-path) |
| Tests | [TC-601](../quality/test-suites.md#tc-601-medication-step-is-mandatory--cannot-skip) through [TC-606](../quality/test-suites.md#tc-606-medication-step-on-mobile) |
| Confirmed by | Dr. Martinez (Medical Director), 2024-03-25 |

**Verification:** 1/1 stories proven. All 6 AC covered, immutability audit confirmed. Last verified 2024-03-25.
