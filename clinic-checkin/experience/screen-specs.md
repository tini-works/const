# Screen Specs — Clinic Check-In System

All screens are specified by region, content, and states. Organized by feature area. Engineers should be able to build each screen from this document alone.

---

## 1. Kiosk Check-In Screens

### 1.1 Kiosk Welcome Screen

**Purpose:** Entry point for all kiosk check-ins. Patient initiates identification.

**Layout:**
- Full-screen kiosk display (landscape, 1920x1080 typical)
- Centered content area, max-width 800px

**Regions:**

| Region | Content | Notes |
|--------|---------|-------|
| Header | Clinic logo + location name (e.g., "Main Street Clinic") | Location name is driven by the kiosk's assigned location |
| Primary action | "Scan your card to check in" with card reader icon | Large, accessible text (min 24px) |
| Secondary action | "No card? Tap here to search by name" | Smaller, below primary |
| Footer | "Need help? Ask the front desk" | Static |

**States:**

| State | What the user sees |
|-------|-------------------|
| Idle | Default layout above. No patient data in memory, DOM, or component state. Screen is fully clean. |
| Scanning | Card reader icon animates. Text changes to "Reading your card..." |
| Scan failed | Red inline error: "We couldn't read your card. Please try again, or tap below to search by name." Returns to idle after 10 seconds. |
| Identification failed | "We couldn't find your record. Please check with the front desk." No partial data shown. |

**Security (post-BUG-002):**
- Before rendering ANY patient data, the system must execute a full session purge: DOM clear, component state reset, cached data flush.
- Between the idle state and patient data display, a **transition screen** (Section 1.2) is always shown. There is never a direct transition from one patient's data to another patient's data.

---

### 1.2 Session Transition Screen

**Purpose:** Enforced visual and technical barrier between patient sessions. Prevents data leakage.

**Added in:** Round 4 (BUG-002 fix)

**Layout:**
- Full screen, clinic-branded background
- Centered spinner or clinic logo animation

**Content:**
- "Loading your information..." text
- Animated loading indicator

**Duration:** Minimum 800ms display time even if data loads faster. This guarantees the UI has fully re-rendered from a clean state.

**Technical requirement:** This screen must render BEFORE any patient data API call returns. The rendering of this screen IS the proof that the previous session's DOM is gone.

---

### 1.3 Patient Identification Confirmation Screen

**Purpose:** After scan/search, patient confirms their identity before seeing full record.

**Layout:**
- Header with clinic branding
- Centered card showing partial identity info

**Regions:**

| Region | Content | Notes |
|--------|---------|-------|
| Greeting | "Welcome back, [First Name]" | First name only — minimal PHI exposure for identity confirmation |
| Identity hint | "Date of birth: [MM/DD/YYYY]" | Patient confirms this is them |
| Actions | "Yes, that's me" (primary) / "That's not me" (secondary) | |

**States:**

| State | What the user sees |
|-------|-------------------|
| Confirming | Layout above |
| Rejected ("That's not me") | "Please check with the front desk for assistance." No further data shown. Session ends. Screen returns to idle after 5 seconds. |

---

### 1.4 Check-In Review Screen — Demographics

**Purpose:** Patient reviews and confirms or edits their demographic information.

**Layout:**
- Scrollable content area with section cards
- Progress indicator at top showing check-in steps
- Sticky footer with navigation

**Progress indicator steps:**
1. Demographics (current)
2. Insurance
3. Allergies
4. Medications (mandatory — added Round 6)
5. Confirmation

**Regions:**

| Region | Content | Notes |
|--------|---------|-------|
| Progress bar | Step 1 of 5 highlighted | Visual breadcrumb of the check-in flow |
| Section: Name | Full name, pre-populated | Read-only display with "Edit" link |
| Section: Date of Birth | DOB, pre-populated | Read-only display with "Edit" link |
| Section: Address | Street, city, state, zip — pre-populated | Read-only with "Edit" link |
| Section: Phone | Phone number, pre-populated | Read-only with "Edit" link |
| Section: Email | Email, pre-populated | Read-only with "Edit" link |
| Footer | "Everything correct? Continue" (primary) / "Back" (secondary) | |

**Edit mode:** When patient taps "Edit" on any section, it expands inline into an editable form. Only one section edits at a time. Changes are staged locally until the patient taps "Save" or "Cancel" on that section.

**States:**

| State | What the user sees |
|-------|-------------------|
| Review (default) | All fields read-only, pre-populated from stored record |
| Editing [section] | Selected section expanded with form inputs. Other sections remain read-only. |
| Saving edit | Brief inline spinner on the edited section |
| Edit saved | Section collapses back to read-only with updated value. Green flash to confirm change. |
| Validation error | Inline red text below the invalid field (e.g., "Please enter a valid zip code") |

**For new patients (no stored data):** All sections show empty form fields. Progress bar still visible. Patient must fill required fields (name, DOB, phone) before continuing.

---

### 1.5 Check-In Review Screen — Insurance

**Purpose:** Patient reviews and confirms or edits insurance information.

**Layout:** Same shell as Demographics (progress bar, sticky footer). Step 2 of 5 highlighted.

**Regions:**

| Region | Content | Notes |
|--------|---------|-------|
| Progress bar | Step 2 of 5 highlighted | |
| Section: Primary Insurance | Payer name, member ID, group number, plan type | Pre-populated if on file |
| Photo capture button | "Update with a photo of your card" | Opens camera capture flow (Section 1.5a) |
| Section: Secondary Insurance (if exists) | Same fields as primary | Only shown if patient has secondary on file |
| "Add secondary insurance" link | Expands to add form | Only shown if no secondary exists |
| Footer | "Continue" / "Back" | |

**Edit mode:** Same inline edit pattern as Demographics.

**States:** Same as Demographics (review, editing, saving, validation error), plus:

| State | What the user sees |
|-------|-------------------|
| No insurance on file | Empty form with all fields editable. Message: "No insurance information on file. Please enter your insurance details or take a photo of your card." |
| Photo capture in progress | Camera viewfinder overlay (see 1.5a) |
| OCR processing | "Reading your card..." with spinner |
| OCR complete | Extracted fields populated, highlighted in blue to indicate they're OCR-derived. Patient reviews and confirms. |
| OCR low confidence | Field highlighted in yellow with note: "Please verify this field — we weren't sure about it." |
| OCR failed | "We couldn't read your card. Please enter the information manually." Fields remain empty/editable. |

---

### 1.5a Insurance Card Photo Capture Overlay

**Added in:** Round 8 (E4: Insurance Card Photo Capture)

**Purpose:** Guided capture of insurance card front and back.

**Layout:** Full-screen camera overlay on top of the insurance screen.

**Flow:**

1. **Front capture prompt:** "Hold your insurance card in the frame — front side" with a card-shaped guide overlay on the camera viewfinder. Shutter button at bottom.
2. **Front preview:** Captured image shown. "Use this photo" / "Retake" buttons.
3. **Back capture prompt:** "Now flip your card — back side" with same guide overlay.
4. **Back preview:** Same pattern as front.
5. **Processing:** Both images sent for OCR. "Reading your card..." screen.
6. **Return to insurance screen** with extracted fields populated.

**States:**

| State | What the user sees |
|-------|-------------------|
| Camera permission denied | "Camera access is needed to take a photo. You can enter your information manually instead." + "Enter manually" button to dismiss overlay. |
| Camera unavailable (kiosk hardware issue) | "Camera is not available. Please enter your information manually." + dismiss button. |
| Image too blurry | "The photo is blurry. Please hold the card steady and try again." + "Retake" button. |

**Mobile note:** On mobile check-in, this same flow uses the device's native camera via web API. Layout adapts to portrait orientation.

---

### 1.6 Check-In Review Screen — Allergies

**Purpose:** Patient reviews and confirms or edits allergy information.

**Layout:** Same shell. Step 3 of 5.

**Regions:**

| Region | Content | Notes |
|--------|---------|-------|
| Progress bar | Step 3 of 5 highlighted | |
| Allergy list | Each allergy as a pill/tag: name + severity | Pre-populated from record |
| "Add allergy" button | Opens inline add form | |
| "No known allergies" checkbox | If checked, clears the list and records NKA | Only shown if list is empty |
| Footer | "Continue" / "Back" | |

**Edit interactions:**
- Tap an allergy pill to expand it for editing (name, reaction type, severity)
- Swipe left (or tap X) to remove an allergy — confirmation prompt: "Remove [allergy name]?"
- "Add allergy" opens an inline form with search-as-you-type for common allergens

**States:**

| State | What the user sees |
|-------|-------------------|
| Has allergies | List of allergy pills, pre-populated |
| No allergies on file | "No allergies on file. Please add any known allergies or confirm you have none." + "Add allergy" button + "No known allergies" checkbox |
| Adding | Inline form visible below the list |
| Removing | Confirmation dialog before removal |

---

### 1.7 Check-In Review Screen — Medications

**Added in:** Round 6 (E6: Compliance — Medication List)

**Purpose:** Mandatory medication list review and confirmation. Cannot be skipped. Required by state health board at every visit.

**Layout:** Same shell. Step 4 of 5.

**Regions:**

| Region | Content | Notes |
|--------|---------|-------|
| Progress bar | Step 4 of 5 highlighted | |
| Compliance notice | "Please review your current medications. This is required at every visit." | Subtle but always visible |
| Medication list | Each medication as a card: name, dosage, frequency | Pre-populated from record |
| "Add medication" button | Opens inline add form | |
| "No current medications" button | Records explicit "none" confirmation | Only shown if list is empty |
| Footer | "I've reviewed my medications — Continue" / "Back" | Button text is explicit about review |

**This screen cannot be bypassed.** The "Continue" button requires the patient to have either:
- Confirmed the existing list (scrolled through and tapped continue), OR
- Made changes (add/edit/remove) and tapped continue, OR
- Explicitly confirmed "no current medications"

**Medication card layout:**
```
┌─────────────────────────────────┐
│ Lisinopril                    ✎ │
│ 10mg · Once daily               │
└─────────────────────────────────┘
```

**Edit interactions:**
- Tap ✎ to edit medication details (name, dosage, frequency)
- Swipe left or tap X to remove — confirmation prompt: "Remove [medication name] from your list?"
- "Add medication" opens inline form: medication name (search-as-you-type), dosage (free text), frequency (dropdown: once daily, twice daily, three times daily, as needed, other)

**States:**

| State | What the user sees |
|-------|-------------------|
| Has medications | List of medication cards, pre-populated |
| No medications on file | "No medications on file. Please add any current medications, or confirm you take none." + "Add medication" button + "No current medications" button |
| Adding | Inline form below the list |
| Editing | Card expands to editable form inline |
| Removing | Confirmation dialog |

**Audit:** Every confirmation on this screen is timestamped and stored as an auditable record. The timestamp and confirmation type (confirmed unchanged / modified / confirmed none) are recorded.

---

### 1.8 Check-In Confirmation Screen

**Purpose:** Final step. Patient confirms all information is correct and completes check-in.

**Layout:** Summary view with all sections collapsed but visible.

**Regions:**

| Region | Content | Notes |
|--------|---------|-------|
| Progress bar | Step 5 of 5 highlighted | |
| Summary: Demographics | Name, DOB, address (collapsed, read-only) | Tap to expand and view details |
| Summary: Insurance | Payer name, member ID (collapsed) | Tap to expand |
| Summary: Allergies | Count or "None" (collapsed) | Tap to expand |
| Summary: Medications | Count or "None" (collapsed) | Tap to expand. Shows compliance badge ✓ |
| Actions | "Confirm and check in" (primary, large) / "Go back and edit" (secondary) | |

**States:**

| State | What the user sees |
|-------|-------------------|
| Ready | Summary layout above. Primary button enabled. |
| Submitting | "Checking you in..." with spinner. Button disabled. |
| Success | Green confirmation: "You're checked in! Please have a seat in the waiting area." Auto-returns to welcome screen after 10 seconds. |
| Sync failure (post-BUG-001) | Yellow warning: "Your check-in was saved, but we're having trouble notifying the front desk. Please let the receptionist know you've checked in." Does NOT show a false green checkmark. |
| System error | Red error: "Something went wrong. Please try again or ask the front desk for help." + "Try again" button. |

**Post-BUG-001 behavior:** The success state is only shown after the system has confirmed that the receptionist dashboard has received the data (or after a timeout with the sync failure message). No false green checkmarks.

---

### 1.9 Kiosk Name Search Screen

**Purpose:** Fallback when card scan fails or patient has no card.

**Layout:**
- Search input at top
- Results list below

**Regions:**

| Region | Content | Notes |
|--------|---------|-------|
| Search input | "Search by last name" with keyboard | Auto-focus on load |
| Results list | Matching patients: "Last, First — DOB" | Filtered as user types. Max 10 visible results. |
| No results | "No patients found. Please check with the front desk." | Shown after 3+ characters with no match |
| Footer | "Back to scan" link | |

**After selection:** Patient taps their name → goes to Identity Confirmation Screen (1.3) to verify DOB before proceeding.

**Performance (Round 9):** Search must return results within 2 seconds under load. If the search is slow, show a spinner after 500ms. Never freeze the input.

---

## 2. Receptionist Dashboard

### 2.1 Receptionist Dashboard — Main View

**Purpose:** Staff's primary workspace. Shows today's patients, their check-in status, and actions.

**Layout:**
- Top bar with location context and controls
- Patient queue as a sortable table
- Side panel for patient detail (opens on row click)

**Regions:**

| Region | Content | Notes |
|--------|---------|-------|
| Top bar: Location | Current location name + location selector dropdown | Default: staff's assigned location (post-Round 5). Dropdown allows switching or viewing "All Locations" for admin staff. |
| Top bar: Search | Patient search input | Searches across all locations (post-Round 5). Clearly labeled "Search all locations" when in single-location view. |
| Top bar: Date | Today's date, with date picker for viewing other days | |
| Queue header | Column headers: Time, Patient, Check-In Status, Channel, Actions | Sortable by any column |
| Queue rows | One row per appointment | See row spec below |
| Status bar (bottom) | "12 of 18 patients checked in · 3 pending" | Live count |

**Queue row spec:**

| Column | Content | Notes |
|--------|---------|-------|
| Time | Appointment time (e.g., "9:15 AM") | |
| Patient | "Last, First" | Tap to open side panel |
| Check-In Status | Badge: see status badges below | |
| Channel | Icon + label: Kiosk / Mobile / Walk-in / — | Shows how the patient checked in |
| Actions | "Check in" button (for walk-ins not yet checked in) | Only shown for unchecked-in patients |

**Check-in status badges:**

| Badge | Color | Meaning |
|-------|-------|---------|
| Checked In | Green | Patient completed check-in (any channel) |
| In Progress | Yellow | Patient started but hasn't finished (e.g., partial mobile check-in) |
| Syncing... | Blue pulse | Data in transit from kiosk (post-BUG-001). Should resolve to green within 5 seconds. |
| Not Checked In | Gray | Patient hasn't started check-in |
| Check-In Failed | Red | Kiosk/mobile check-in encountered an error |
| Mobile — Complete | Green + phone icon | Checked in via mobile before arriving |
| Mobile — Partial | Yellow + phone icon | Started mobile check-in but didn't finish |

**Real-time updates (post-BUG-001):**
- When a patient confirms on kiosk, the row updates within 5 seconds
- If sync is delayed, the row shows "Syncing..." badge (blue pulse) instead of nothing
- If sync fails after 15 seconds, the row shows "Check-In Failed" with a "Retry sync" action

**Multi-location behavior (post-Round 5):**
- Dashboard defaults to the staff member's assigned location
- Location selector in the top bar allows switching to another location or "All Locations"
- When viewing "All Locations," each row includes a Location column
- Search always searches across all locations regardless of the current filter

---

### 2.2 Receptionist — Patient Detail Side Panel

**Purpose:** Full view of a patient's record, opened from the queue row.

**Layout:** Slide-in panel from the right, ~40% screen width.

**Regions:**

| Region | Content | Notes |
|--------|---------|-------|
| Header | Patient name, DOB, patient ID | Close button (X) top-right |
| Check-in status | Status badge + channel + timestamp | "Checked in via kiosk at 9:17 AM" |
| Section: Demographics | All demographic fields | Editable by staff |
| Section: Insurance | Insurance details + card photo thumbnail (if captured) | Editable. Tap photo to view full size. |
| Section: Allergies | Allergy list | Editable |
| Section: Medications | Medication list + last confirmation timestamp | Editable. Shows "Confirmed by patient at [time]" |
| Section: Visit History | Past visit dates and locations | Read-only. Shows all locations (post-Round 5). |
| Footer | "Save Changes" / "Cancel" | Only visible when edits are pending |

**Concurrency handling (post-BUG-003 / Round 7):**

When a staff member opens this panel, the system records the record version. On save:

| Scenario | What happens |
|----------|-------------|
| No conflict | Save succeeds. Green flash "Saved." |
| Conflict detected (version mismatch) | Save is blocked. A conflict banner appears at the top of the panel. |

**Conflict banner spec:**
```
┌─────────────────────────────────────────────────────┐
│ ⚠ This record was updated by [Name] at [time].     │
│                                                     │
│ Changed: Insurance → Payer changed from "Aetna"     │
│          to "Blue Cross"                            │
│                                                     │
│ [View current version]  [Re-apply my changes]       │
└─────────────────────────────────────────────────────┘
```

- "View current version" refreshes the panel with the latest data, discarding the staff member's unsaved edits
- "Re-apply my changes" refreshes the data and shows the staff member's edits as a diff on top of the new version, letting them choose which changes to keep
- No silent overwrites. Ever.

---

### 2.3 Receptionist — Walk-In Check-In Flow

**Purpose:** When a patient walks in without a card and without an appointment, the receptionist manually checks them in.

**Flow:**
1. Receptionist clicks "Check in walk-in" button (top bar)
2. Search for existing patient (same search as kiosk name search)
3. If found: open their record in side panel, pre-populated. Staff confirms/updates and marks checked in.
4. If not found: "New patient" form. Staff enters demographics, insurance, allergies, medications. Creates record and marks checked in.

**This flow follows the same data structure and validation as the kiosk flow.**

---

## 3. Mobile Check-In Screens

**Added in:** Round 3 (E2: Mobile Check-In)

All mobile screens are responsive web views, optimized for phones (360-428px width). No app download.

### 3.1 Mobile — Link Landing / Identity Verification

**Purpose:** Patient opens the check-in link from SMS/email. Must verify identity before seeing any PHI.

**Layout:** Single-column mobile layout. Clinic branding at top.

**Regions:**

| Region | Content | Notes |
|--------|---------|-------|
| Header | Clinic logo + "Check in for your appointment" | |
| Appointment info | "Your appointment: [Date] at [Time] at [Location Name]" | Location name shown for multi-location (post-Round 5) |
| Identity form | "Please verify your identity" — DOB input + last 4 digits of phone | Low-friction verification |
| Action | "Verify and continue" button | |
| Footer | "Not your appointment? Contact the clinic." | |

**States:**

| State | What the user sees |
|-------|-------------------|
| Default | Form layout above |
| Verifying | Button shows spinner |
| Verification failed | Red inline: "The information doesn't match our records. Please try again or call the clinic." Allows retry. |
| Link expired | "This check-in link has expired. Please check in at the clinic." No form shown. |
| Already checked in | "You've already checked in for this appointment. See you soon!" No form shown. |

**Timing:** Link is active starting 24 hours before appointment time. Expires at appointment time.

---

### 3.2 Mobile — Review Screens (Demographics, Insurance, Allergies, Medications)

**Purpose:** Same review and confirm/edit flow as kiosk, adapted for mobile.

**Layout:** Single-column. One section per screen (not all-on-one-page like kiosk). Swipe or button navigation between steps.

**Step flow:**
1. Demographics
2. Insurance (with photo capture option)
3. Allergies
4. Medications (mandatory, same as kiosk — Round 6 compliance)
5. Confirm

Each step follows the same content and interaction model as the corresponding kiosk screen (Sections 1.4 through 1.7) with these mobile adaptations:

| Kiosk behavior | Mobile adaptation |
|----------------|-------------------|
| Inline edit expand | Full-screen edit sheet slides up from bottom |
| Allergy pill tap-to-edit | Tap opens full-screen edit |
| Insurance photo capture | Uses device camera via web API. Same guided flow (1.5a) but in portrait orientation |
| Medication card edit | Tap opens full-screen edit sheet |

**Progress indicator:** Horizontal dots at top (not a full breadcrumb bar). Current step filled, others outlined.

**Navigation:** "Next" button at bottom of each step. "Back" link above it. Swipe-right to go back.

**Partial completion:** If the patient closes the browser or loses connection mid-flow, their progress is saved. Reopening the link resumes from where they left off. Receptionist sees "Mobile — Partial" status.

---

### 3.3 Mobile — Confirmation Screen

**Purpose:** Final confirmation, adapted for mobile.

**Regions:**

| Region | Content | Notes |
|--------|---------|-------|
| Summary | Collapsed sections (same as kiosk 1.8) | Tap to expand |
| Action | "Confirm and check in" (full-width primary button) | |
| Note | "You're all set! When you arrive, let the front desk know you've checked in online." | |

**Post-confirmation:**
- "You're checked in! We'll see you on [date] at [time] at [Location Name]."
- No data remains in the browser after this screen. Session is terminated, no PHI cached on the device.

---

## 4. Admin Screens

### 4.1 Admin — Migration Dashboard

**Added in:** Round 10 (E5: Riverside Acquisition)

**Purpose:** Administrator monitors the Riverside patient data migration.

**Layout:** Full-width dashboard with summary stats and a filterable record list.

**Regions:**

| Region | Content | Notes |
|--------|---------|-------|
| Summary cards | Total records: 4,000 · Imported: [n] · Flagged for review: [n] · Duplicates found: [n] · Duplicates resolved: [n] | Live counts |
| Progress bar | Visual progress of migration (% complete) | Segmented by: electronic imported, electronic flagged, paper OCR'd, paper pending |
| Filter tabs | All / Needs Review / Duplicates / Import Errors / Completed | |
| Record list | Table: Patient name, source (electronic/paper), status, confidence score, actions | Sortable, filterable |
| Batch actions | "Review selected" button for processing multiple records at once | Staff can select up to 20 records for batch review |

**Record statuses:**

| Status | Meaning |
|--------|---------|
| Imported | Record successfully imported, no issues |
| Needs Review | Missing required fields or low OCR confidence |
| Potential Duplicate | Matched against existing patient — awaiting staff review |
| Duplicate Resolved | Staff confirmed merge or reject |
| Import Error | Failed validation — cannot import without correction |
| Paper — Pending | Paper record not yet scanned/OCR'd |
| Paper — OCR Complete | OCR done, awaiting review |

---

### 4.2 Admin — Duplicate Review Screen

**Added in:** Round 10 (E5: Riverside Acquisition)

**Purpose:** Staff reviews potential duplicate patients and decides whether to merge.

**Layout:** Side-by-side comparison of two patient records.

**Regions:**

| Region | Content | Notes |
|--------|---------|-------|
| Header | "Potential Duplicate — Confidence: [85%]" | Confidence score prominently displayed |
| Left panel | "Our Record" — existing patient data | All fields shown |
| Right panel | "Riverside Record" — imported patient data | All fields shown |
| Diff highlights | Fields that differ are highlighted in yellow | Fields that match are shown in green |
| Field-level merge controls | For each differing field: radio buttons to choose "Keep ours" / "Keep theirs" / "Edit" | Default: most recent data selected |
| Actions | "Merge records" (primary) / "Keep separate" (secondary) / "Flag for further review" (tertiary) | |

**Merge confirmation dialog:**
```
"You are about to merge these two patient records. This action
creates a single record with the fields you selected. Both original
records will be preserved as reference.

This cannot be undone automatically.

[Confirm merge]  [Cancel]"
```

**No auto-merge.** Every potential duplicate requires staff confirmation (DEC-006).

---

## 5. Loading & Degraded States

**Added in:** Round 9 (Performance)

These states apply across ALL screens (kiosk, mobile, receptionist).

### 5.1 Loading States

| Scenario | Behavior |
|----------|----------|
| Patient search (kiosk or receptionist) | Spinner appears after 500ms of waiting. Search input remains interactive. Results stream in as available. |
| Patient data loading (after identification) | Session transition screen (1.2) shown. Minimum 800ms for security. If data takes longer than 3 seconds, add text: "Still loading... please wait." |
| Receptionist dashboard refresh | Rows that are updating show a subtle shimmer/skeleton state. Other rows remain interactive. Dashboard never freezes. |
| Mobile page transition | Skeleton screen of the next step shown immediately. Content fills in when loaded. |
| Insurance photo OCR processing | "Reading your card..." with a progress animation. Expected: 3-5 seconds. If over 10 seconds: "This is taking longer than usual. Please wait..." |
| Check-in confirmation submit | Button shows inline spinner. Disabled to prevent double-tap. |

### 5.2 Degraded Mode — Slow Backend

When backend response times exceed p95 targets (3 seconds):

| Screen | Degraded behavior |
|--------|-------------------|
| Kiosk welcome | Functions normally (no backend call until scan) |
| Kiosk data screens | Data loads with loading states. If > 10 seconds, show: "The system is running slowly. Your information is loading — please wait." Never a frozen screen. |
| Receptionist dashboard | Dashboard loads with available data. Rows still loading show shimmer. Search results may be slow — spinner + "Searching..." shown. Never a frozen screen. |
| Mobile check-in | Same as kiosk data screens. On extremely slow connections (> 15 seconds), show: "Check-in is temporarily slow. You can complete check-in at the clinic kiosk." |

### 5.3 Degraded Mode — Backend Unreachable

| Screen | Behavior |
|--------|----------|
| Kiosk | After 30-second timeout: "Check-in is temporarily unavailable. Please see the front desk." |
| Receptionist dashboard | Banner: "System connectivity issue. Data may not be current. Last updated: [timestamp]." Dashboard shows last-loaded data. |
| Mobile | "Check-in is temporarily unavailable. Please try again later, or check in at the clinic when you arrive." |

### 5.4 Skeleton Screens

For every data-loading transition, a skeleton version of the target screen is shown immediately:
- Gray placeholder bars where text will appear
- Gray rectangles where cards will appear
- Layout structure is correct — only content is missing
- Skeleton appears instantly (no delay), content fills in when loaded

This prevents the perception of freezing or broken UI during high-load periods.
