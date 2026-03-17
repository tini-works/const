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
