# Screen Inventory — Complete (Rounds 1-10)

All screens in the system, evolved through 10 rounds of stories, bugs, compliance, and business changes.

Three actor classes:
- **Patient** — experiences the system (kiosk or mobile)
- **Receptionist** — operates the check-in workflow
- **Admin** — manages data migration, conflict resolution, system health

---

## S0: Kiosk Welcome / Idle (Patient-facing)

**Added in:** S-04 (Data Breach / HIPAA)
**Purpose:** Clean state between patients. Zero PHI. Hard visual boundary between sessions.

**Regions:**
- **Clinic branding** — Logo, clinic name
- **Welcome message** — "Welcome to [Clinic Name]. Please see the receptionist to begin check-in."
- **Nothing else** — No search fields, no patient data, no previous session artifacts

**Shown when:**
- Kiosk first powered on
- Session finalized (auto-transition from S4 after 10 seconds)
- Session timed out
- Session cancelled by receptionist

**Security properties:**
- Browser history replaced (not pushed) — back button shows S0, not previous patient data
- DOM is purged of all patient data elements
- Client-side cache cleared
- No autocomplete data retained from previous session

**Boxes matched:** BOX-12 (no PHI cross-exposure), BOX-13 (enforced clearing)

---

## S1: Patient Lookup (Receptionist)

**Introduced in:** S-01 | **Modified in:** S-05, S-09, S-10

**Purpose:** Find the patient in the system. The fork — first-visit or returning.

**Regions:**
- **Search bar** — Input: patient name, DOB, or insurance ID. Auto-suggests after 2+ characters. Performance target: results in <200ms.
- **Results list** — Matching patients with summary: name, DOB, last visit date and location, photo (if available). Each result is selectable. Post-S-10: results include imported Riverside patients with a subtle "imported" badge during the first 6 months after migration.
- **No-match action** — Button "New Patient" (first-visit flow) and button "Can't Find Record" (triggers S1b assisted search).
- **Result count** — "(12 results)" — useful when the search index grows post-S-10 acquisition.

**What receptionist sees:**
- On open: empty search bar, focus in search field. No results.
- On typing: results appear after 2+ characters. Results show enough to disambiguate (name + DOB + last visit + last visit location).
- On selecting a match: transitions to S2.
- On no match: two options — register new patient or assisted search (S1b).

**S-09 modification:** When search is slow (>500ms), a subtle loading indicator replaces the instant results. The search bar remains usable. No error unless search fully times out (>5s).

**S-10 impact:** Search index grows by ~4,000 records. Results may include Riverside imports. Last visit location becomes more important for disambiguation ("Maria Rodriguez — last visit: Riverside Office" vs. "Maria Rodriguez — last visit: Main Street").

**Boxes matched:** BOX-01 (recognition), BOX-D2 (receptionist view), BOX-20 (cross-location search), BOX-40 (Riverside patients searchable)

---

## S1b: Assisted Search (Receptionist)

**Introduced in:** S-01 | **Modified in:** S-10

**Purpose:** Handle recognition failure gracefully.

**Regions:**
- **Original search terms** — Preserved at top (shows what was already tried)
- **Alternative search fields** — Phone number, email, previous insurance ID, approximate visit date range. Each optional.
- **Partial match results** — Looser matching with match-confidence indicator.
- **Fallback action** — "Start as New, Merge Later" — begins intake flagged for reconciliation.

**S-10 impact:** During the migration period, recognition failures spike for Riverside patients visiting our locations for the first time. The fuzzy search is critical here. Partial matches should include cross-system identifiers when available.

**Boxes matched:** BOX-D1 (graceful failure), BOX-37 (duplicate detection at point of care)

---

## S2: Patient Summary (Receptionist)

**Introduced in:** S-01 | **Modified in:** S-05, S-07

**Purpose:** Receptionist sees the returning patient's record. Verifies identity verbally. Initiates check-in.

**Regions:**
- **Patient header** — Name, DOB, photo (if exists). Large, clear.
- **Quick facts** — Last visit date, last visit location (S-05), primary physician, active insurance on file.
- **Data status panel** — Sections (address, insurance, allergies, medications) each showing: current value, last updated date, staleness flag (amber if stale, green if current). Medications always show amber (0-day staleness per S-06 mandate).
- **Provenance note (S-10)** — For imported Riverside patients: "Patient data imported from Riverside Family Practice on [date]. Patient has not yet confirmed this data at our clinic."
- **Action bar:**
  - "Begin Check-in" — sends confirmation view to patient, transitions to S3R + S3P simultaneously
  - "Update Record" — manual edit by receptionist, no patient involvement

**States:**

| State | Visual | Actions Available |
|-------|--------|-------------------|
| Normal | Standard layout | Begin Check-in, Update Record |
| Concurrent session active (S-07) | Warning banner replaces action bar: "This patient is currently being checked in by [Name] at [Location] since [time]. Status: [status]." | Wait, Contact receptionist, Take Over (supervisor only) |
| Pre-checked-in (S-03) | Green banner: "Patient completed pre-check-in at [time] from mobile device." | Review & Finalize, Start Fresh Check-in |

**Boxes matched:** BOX-01, BOX-04, BOX-D2, BOX-D11 (location context), BOX-26 (concurrent blocking)

---

## S3R: Check-in Monitor (Receptionist)

**Introduced in:** S-01 | **Modified in:** S-02, S-06

**Purpose:** Receptionist tracks patient's progress through confirmation. Monitor, not operate.

**Regions:**
- **Connection health indicator (S-02)** — Green dot (live), amber dot (polling fallback), red dot (reconnecting). BOX-D4.
- **Progress tracker** — Sections: contact info, insurance, allergies, medications (S-06). Each shows: pending / confirmed / updated / skipped status. Live updates via WebSocket.
- **Flagged items** — If patient updated data, old-vs-new diff appears. For insurance updates via photo (S-08): card image thumbnail is shown alongside extracted data.
- **Completion notification (S-02)** — When patient finishes: a prominent visual event — status banner changes, optional audio cue, "Complete Check-in" button activates with a pulse animation. BOX-D5.
- **Completion action** — "Complete Check-in" button. Only active when patient finishes all sections.

**S-06 addition:** Medications progress shows as a separate tracked section. If the patient adds/removes medications, each change appears in the flagged items area.

**S-08 addition:** When patient uses photo upload for insurance, the receptionist sees the card image(s) in the flagged items alongside the extracted data. This replaces "let me see your card" — the receptionist already has it.

**Boxes matched:** BOX-D2, BOX-05 (real-time visibility), BOX-D4 (connection health), BOX-D5 (completion notification)

---

## S3P: Confirm Your Information (Patient-facing — Kiosk or Mobile)

**Introduced in:** S-01 | **Modified in:** S-02, S-04, S-06, S-08, S-09, S-10

**Purpose:** Patient reviews existing data and confirms or updates. Core interaction screen.

**Responsive:** Works on kiosk tablet and mobile phone (S-03). Same components, responsive layout.

**Regions:**
- **Greeting** — "Welcome back, [First Name]." No last name (privacy). For Riverside imports (S-10): optional note "Your information was transferred from Riverside Family Practice."
- **Section: Contact Info** — Pre-filled. Confirm/update pattern. Stale = expanded with amber flag.
- **Section: Insurance** — Pre-filled. Confirm/update pattern. Update action branches to photo capture sub-flow (S-08) or manual entry.
- **Section: Allergies** — Pre-filled. Confirm/update + "Any new allergies?" prompt. Never stale.
- **Section: Medications (S-06)** — ALWAYS expanded. NEVER skippable. Variable-length list with add/remove/edit. Requires explicit "I confirm this medication list is current" action. 0-day staleness — shown every visit with amber "Confirm every visit" badge. See medication sub-section design below.
- **Section: Missing info** — If any fields are blank, separate "We still need:" section. Visually distinct.
- **Done button** — "All Confirmed" — only active when ALL sections confirmed/updated, including medications.

**Section states (unchanged from S-01, extended for medications):**

| Section State | Visual Treatment |
|---|---|
| Current (within freshness window) | Collapsed. Green check. One-tap "Still correct." |
| Stale (beyond threshold) | Expanded. Amber indicator. Confirm or update. |
| Mandatory review (medications) | Expanded. Amber "Confirm every visit" badge. Cannot collapse. |
| Missing (no data on file) | Separate section. "We still need:" with input. |
| Updated (changed this session) | Blue highlight. Shows new value. |
| Confirmed (tapped "Still correct") | Collapsed. Green check. |

**S-02 modification:** "All Confirmed" button shows brief spinner while waiting for server acknowledgment. Green checkmark only appears after server confirms persistence. If persistence fails: error state with retry. BOX-06.

**S-04 modification:** On session end (any reason), this screen is immediately replaced by S0 (Welcome). No transition animation. Hard cut. Browser history replaced.

**S-08 modification (Insurance Photo Capture Sub-Flow):**

When patient taps "Update" on insurance, a choice appears:
1. "Take a photo of your card" -> camera overlay with card frame guide -> capture front + back -> OCR processing spinner -> field-by-field verification -> confirm
2. "Enter manually" -> standard edit fields

Photo capture is a modal overlay within S3P, not a separate screen. On completion, the insurance section shows as "Updated" with new values.

**S-09 modification:** Under system load, section save shows a visible spinner (normally sub-100ms). If save times out: "We're having trouble saving. Please try again." No system load messages visible to patient. BOX-D19.

**Medications Sub-Section (S-06) Detailed Design:**

```
Your Medications                    [Confirm every visit]
────────────────────────────────────────────────────────
[If medications exist:]
  Lisinopril 10mg — Once daily           [Edit] [Remove]
  Metformin 500mg — Twice daily          [Edit] [Remove]

                                  [+ Add a medication]

  [ I confirm this medication list is current ]

[If no medications:]
  No medications currently listed.
  Are you taking any medications?
  [No, I am not taking any medications]   [+ Add a medication]
```

Adding a medication opens inline form: drug name, dosage, frequency, prescriber (optional).
Removing shows confirmation dialog. Removed items shown as struck-through until final confirmation.
"I confirm" button activates only after patient has reviewed the full list (scroll-gate or 3s visibility delay).

**Boxes matched:** BOX-02, BOX-03, BOX-04, BOX-D3, BOX-06 (server-confirmed success), BOX-12 (no cross-patient PHI), BOX-22-25 (medications), BOX-D13 (explicit med confirmation), BOX-D14 (empty med list), BOX-D19 (no load state to patient), BOX-29-30 (photo capture)

---

## S4: Check-in Complete (Both)

**Introduced in:** S-01 | **Modified in:** S-03, S-04

**Purpose:** Confirmation that check-in is done.

**Two variants:**

**Kiosk variant (original):**
- Patient sees: "You're all checked in, [First Name]. Please take a seat — we'll call you shortly."
- Auto-transitions to S0 (Welcome/Idle) after 10 seconds. BOX-13.
- Receptionist sees: check-in record updated, patient returns to queue (S5), flagged items for verification if needed.

**Mobile variant (S-03):**
- Patient sees: "You're all set for your visit, [First Name]. When you arrive at [Clinic Name], let the receptionist know you've already checked in." BOX-D7.
- Shows appointment date/time as reminder.
- No auto-transition (it's the patient's phone — they close the browser tab).

**S-04 modification:** Kiosk variant auto-transitions to S0. No patient data remains on screen after transition. Browser history cleared.

**Boxes matched:** BOX-04 (closure), BOX-D7 (mobile closure), BOX-12 (screen clearing), BOX-13 (enforced clearing)

---

## S5: Check-in Queue (Receptionist)

**Added in:** S-02 | **Modified in:** S-03, S-05, S-09

**Purpose:** Receptionist's home base. Global view of all check-in sessions. Replaces the per-patient workflow with queue management.

**Regions:**
- **Location header (S-05)** — Current location name. Toggle: "This location" / "All locations." BOX-D12.
- **Queue stats (S-09)** — In busy/peak states: patient count, average check-in time, queue depth. BOX-D20.
- **Session list** — All active, completed, and recent sessions:

| Column | Content |
|--------|---------|
| Patient | Name (first + last initial) |
| Status | See status values below |
| Started | Time |
| Duration | How long in current state |
| Assigned to | Receptionist name |
| Actions | View, Finalize, Cancel |

**Session statuses:**

| Status | Badge Color | Meaning |
|--------|------------|---------|
| Waiting | Gray | Session created, patient hasn't started |
| In Progress | Blue | Patient actively confirming sections |
| Patient Complete | Green (pulsing) | Patient finished, awaiting receptionist finalization |
| Pre-checked-in (S-03) | Green (solid) | Completed from mobile before arrival |
| Finalized | Dim | Check-in complete, archived |
| Timed Out | Amber | Session expired, partial progress saved |
| Abandoned (S-09) | Red | Created but never started or completed |

**S-03 addition:** Pre-checked-in patients appear in the queue with distinct status. When they arrive, receptionist can finalize directly from the queue without opening S3R.

**S-05 addition:** Location filter. Default: this location. Toggle shows cross-location sessions. Useful for spotting concurrent check-in attempts (BOX-26).

**S-09 additions:**
- Queue header shows aggregate metrics during peak:
  - Normal (<10 sessions): just the list
  - Busy (10-20): "15 patients checking in | Avg: 4 min"
  - Peak (20+): Warning banner: "High volume — 25 patients | Avg: 7 min" + suggestion to direct patients to mobile pre-check-in (if S-03 is live)
- Abandonment tracking: timed-out and never-started sessions marked as abandoned for reporting. BOX-35.

**S-02 fallback:** This queue view works WITHOUT WebSocket. It's a REST-based list that can be refreshed by polling or manual page refresh. If WebSocket is down, the receptionist still has operational visibility through S5. BOX-07.

**Boxes matched:** BOX-07 (fallback queue), BOX-10 (pre-check-in visibility), BOX-D4 (works without WebSocket), BOX-D11 (location context), BOX-D12 (location filter), BOX-D20 (queue depth/metrics), BOX-35 (abandonment tracking)

---

## S6: Identity Verification Gate (Patient-facing — Mobile only)

**Added in:** S-03

**Purpose:** Verify patient identity before showing any data on an unsupervised mobile device.

**Regions:**
- **Clinic branding** — Logo, clinic name
- **Instruction** — "Before we show your information, please verify your identity."
- **Verification field** — "Please enter your date of birth:" [MM/DD/YYYY]
- **Submit button** — "Verify"

**States:**

| State | What patient sees |
|-------|-------------------|
| Initial | Clean form, DOB entry |
| Incorrect (attempt 1-2) | "That doesn't match our records. Please try again." Attempts remaining shown. |
| Locked (3 failed attempts) | "For your security, this link has been locked. Please verify your identity at the clinic." Link becomes permanently inactive. |
| Verified | Transitions to S3P (mobile variant) |

**Security properties:**
- No patient data is shown before verification succeeds
- Failed attempts are logged (BOX-15 — HIPAA access logging)
- Lockout is permanent for this link — a new link must be generated
- Rate limiting on the endpoint to prevent brute force

**Boxes matched:** BOX-11 (identity verification for mobile), BOX-16 (minimum necessary — no data shown until verified)

---

## S7: Pre-Check-In Link Landing (Patient-facing — Mobile)

**Added in:** S-03

**Purpose:** Handle the time window for pre-check-in links. The first thing the patient sees when they tap the link.

**States:**

| State | What patient sees |
|-------|-------------------|
| Too early | "Your appointment is on [date] at [time]. Pre-check-in opens 24 hours before your appointment. Please check back on [date]." |
| Active | Brief welcome message, then transitions to S6 (Identity Verification Gate) |
| Already completed | "You've already completed your pre-check-in for this appointment. See you at the clinic!" |
| Expired (appointment passed) | "This check-in link has expired. Please check in at the clinic reception." |
| Invalid / revoked | "This link is no longer valid. Please contact the clinic." |

**Boxes matched:** BOX-09 (time window), BOX-08 (mobile check-in entry point)

---

## S8: Finalization Conflict (Receptionist)

**Added in:** S-07

**Purpose:** When finalization is rejected due to concurrent session conflict. Shows both sessions' changes for manual resolution.

**Regions:**
- **Conflict explanation** — "Unable to complete check-in — another session was finalized first."
- **Session comparison** — Your session vs. conflicting session: who, when, what changed
- **Changes not applied** — Data from your session that was NOT written to the patient record
- **Changes that were applied** — Data from the other session that WAS written
- **Resolution actions** — "Apply my changes too" / "Discard my changes" / "Contact admin"

**Boxes matched:** BOX-27 (conflict-safe finalization), BOX-D16 (conflict shows both sessions)

---

## S9: Session Recovery (Admin)

**Added in:** S-07

**Purpose:** Admin tool to recover data from conflicting or dead sessions.

**Regions:**
- **Search** — Patient name or session ID
- **Session history** — All sessions for matched patient, including conflicting and expired sessions
- **Side-by-side comparison** — Both sessions' data with field-level diff
- **Recovery actions** — Apply specific changes from a dead session to the patient record

**Boxes matched:** BOX-28 (lost data recoverable), BOX-D16 (conflict resolution)

---

## S10: Import Dashboard (Admin)

**Added in:** S-10

**Purpose:** Monitor bulk import progress for Riverside migration.

**Regions:**
- **Overall progress** — Total records, imported, pending, errors, flagged duplicates
- **Source breakdown** — Electronic (EHR) vs. paper entry progress
- **Rate and estimate** — Records per hour, estimated completion
- **Controls** — Pause import, view audit log, view errors

**Boxes matched:** BOX-36 (importable), BOX-39 (non-degrading import — progress visibility), BOX-D22 (real-time progress)

---

## S11: Duplicate Review (Admin)

**Added in:** S-10

**Purpose:** Side-by-side comparison of potential duplicate patient records for human review.

**Regions:**
- **Queue summary** — Total duplicates, reviewed, remaining
- **Confidence filter** — High (>90%) / Medium (60-90%) / Low (<60%). BOX-D21.
- **Comparison panel** — Our record vs. Riverside record, field by field, with match signals highlighted
- **Actions** — Merge (same patient) / Not the same / Defer

**Boxes matched:** BOX-37 (duplicates detected), BOX-D21 (confidence tiers)

---

## S12: Merge Resolution (Admin)

**Added in:** S-10

**Purpose:** Field-by-field merge control when two records are confirmed as the same patient.

**Regions:**
- **Field list** — Every data field from both records, with radio buttons to choose which value keeps
- **Conflict highlights** — Fields where records disagree are highlighted
- **Non-conflicting fields** — Auto-suggested merge (combine both sources)
- **Provenance tracking** — Each resolved field tagged with source record. BOX-D23.
- **Actions** — Complete merge / Back to comparison

**Boxes matched:** BOX-38 (merge preserves data), BOX-D23 (provenance)

---

## S13: Paper Record Entry (Admin)

**Added in:** S-10

**Purpose:** Manual data entry for Riverside paper records.

**Regions:**
- **Record counter** — Current position in the batch
- **Source image** — Scanned paper form (if digitized)
- **Required fields** — Name, DOB, at least one contact method (phone or address). Minimum viable data set per BOX-41.
- **Optional fields** — Insurance, allergies, medications
- **Actions** — Save and Next / Flag as incomplete / Skip (illegible)

**Boxes matched:** BOX-36 (importable), BOX-41 (minimum data set)

---

## Screen Inventory Summary

| ID | Screen Name | Actor | Introduced | Last Modified | Purpose |
|----|------------|-------|------------|---------------|---------|
| S0 | Kiosk Welcome/Idle | Patient (kiosk) | S-04 | — | PHI boundary between sessions |
| S1 | Patient Lookup | Receptionist | S-01 | S-10 | Find patient in system |
| S1b | Assisted Search | Receptionist | S-01 | S-10 | Fuzzy search fallback |
| S2 | Patient Summary | Receptionist | S-01 | S-07 | Review patient record, initiate check-in |
| S3R | Check-in Monitor | Receptionist | S-01 | S-08 | Track patient's check-in progress |
| S3P | Confirm Your Info | Patient | S-01 | S-10 | Data confirmation (core interaction) |
| S4 | Check-in Complete | Both | S-01 | S-04 | Completion confirmation |
| S5 | Check-in Queue | Receptionist | S-02 | S-09 | Queue management home base |
| S6 | Identity Verification Gate | Patient (mobile) | S-03 | — | DOB verification for mobile pre-check-in |
| S7 | Pre-Check-In Link Landing | Patient (mobile) | S-03 | — | Time window management for pre-check-in links |
| S8 | Finalization Conflict | Receptionist | S-07 | — | Concurrent session conflict resolution |
| S9 | Session Recovery | Admin | S-07 | — | Recover data from dead/conflicting sessions |
| S10 | Import Dashboard | Admin | S-10 | — | Monitor bulk import progress |
| S11 | Duplicate Review | Admin | S-10 | — | Side-by-side duplicate comparison |
| S12 | Merge Resolution | Admin | S-10 | — | Field-by-field merge control |
| S13 | Paper Record Entry | Admin | S-10 | — | Manual data entry for paper records |

**Totals:** 16 screens (6 original from S-01, 10 added through S-02 to S-10)
**Actor breakdown:** 5 patient-facing, 6 receptionist-facing, 5 admin-facing
