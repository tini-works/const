# Screen Inventory — Story 01: Returning Patient Check-in

Two actors: Receptionist (operates the system) and Patient (experiences the system). Both have screens. The receptionist drives; the patient confirms.

---

## S1: Patient Lookup (Receptionist)

**Purpose:** Find the patient in the system. This is the fork — first-visit or returning.

**Regions:**
- **Search bar** — Input: patient name, DOB, or insurance ID. Auto-suggests as receptionist types.
- **Results list** — Matching patients with summary: name, DOB, last visit date, photo (if available). Each result is selectable.
- **No-match action** — If no results or patient not in list: button "New Patient" (first-visit flow, out of scope for S-01) and button "Can't Find Record" (triggers BOX-D1 assisted search).

**What receptionist sees:**
- On open: empty search bar, focus is in the search field. No results yet.
- On typing: results appear after 2+ characters. Results show enough to disambiguate (name + DOB + last visit).
- On selecting a match: transitions to S2.
- On no match: two options — register new patient (different flow) or assisted search (S1b).

**Boxes matched:** BOX-01 (recognition happens here), BOX-D2 (receptionist-appropriate view).

---

## S1b: Assisted Search (Receptionist)

**Purpose:** Handle recognition failure gracefully. The patient says "I've been here before" but standard lookup didn't find them.

**Regions:**
- **Alternative search fields** — Phone number, email, previous insurance ID, approximate visit date range. Each field is optional — any combination can be tried.
- **Partial match results** — Looser matching: shows candidates even with partial matches, with a match-confidence indicator.
- **Fallback action** — "Start as New, Merge Later" — begins intake but flags the record for manual reconciliation.

**What receptionist sees:**
- The original search terms are preserved at top (they can see what they already tried).
- Additional search fields appear below.
- Results use a softer match (fuzzy name, partial DOB) and show what matched.
- If still no match: receptionist creates a new record, flagged as "possible duplicate — verify."

**Boxes matched:** BOX-D1 (graceful failure path).

---

## S2: Patient Summary (Receptionist)

**Purpose:** Receptionist sees the returning patient's record. Verifies identity verbally. Initiates check-in.

**Regions:**
- **Patient header** — Name, DOB, photo (if exists). Large, clear. This is identity confirmation.
- **Quick facts** — Last visit date, primary physician, active insurance on file.
- **Data status panel** — Three sections (address, insurance, allergies) each showing:
  - Current value on file
  - Last updated date
  - Staleness flag (amber if beyond freshness threshold, green if current)
- **Action bar** — "Begin Check-in" (sends confirmation view to patient, transitions to S3R + S3P simultaneously). "Update Record" (manual edit by receptionist, no patient involvement).

**What receptionist sees:**
- The patient's existing record at a glance. Enough to say: "Hi [Name], I see you were last here on [date]. Let me pull up your check-in."
- Stale fields are visually flagged — receptionist knows which items the patient should verify.

**Boxes matched:** BOX-01 (patient identified), BOX-04 (recognition communicated — receptionist uses name and prior visit), BOX-D2 (receptionist view).

---

## S3R: Check-in Monitor (Receptionist)

**Purpose:** Receptionist tracks the patient's progress through confirmation. They see what the patient is confirming and can intervene if needed.

**Regions:**
- **Progress tracker** — Shows which sections the patient has confirmed/updated/skipped. Live status.
- **Flagged items** — If the patient updated any data, it appears here with old-vs-new. Receptionist can accept or ask clarifying questions.
- **Completion action** — When patient finishes all sections: "Complete Check-in" becomes active.

**What receptionist sees:**
- A dashboard of the patient's confirmation progress. They don't need to re-do the patient's work — they monitor.
- If patient updates insurance, the receptionist sees old value vs. new and may need to scan a new card.

**Boxes matched:** BOX-D2 (receptionist view during check-in).

---

## S3P: Confirm Your Information (Patient-facing)

**Purpose:** The patient reviews their existing data and confirms or updates. This is where BOX-02 and BOX-03 live.

**Could be:** A tablet handed to the patient, a kiosk, or the receptionist's screen turned around. The design is independent of device.

**Regions:**
- **Greeting** — "Welcome back, [First Name]." No last name displayed (privacy in shared spaces).
- **Section: Contact Info** — Pre-filled address, phone, email. Each has a "Still correct" button and an "Update" button. If data is stale (amber), section is expanded by default with a note: "We last confirmed this on [date]. Is it still current?"
- **Section: Insurance** — Pre-filled insurance provider and policy number. Same confirm/update pattern. If stale, expanded with note.
- **Section: Allergies** — Pre-filled allergy list. Confirm/update pattern. Additionally: "Any new allergies to add?" prompt.
- **Section: Missing info** — If any fields are blank (partial data), they appear here as "We still need:" with clear input fields. This section is visually distinct — not mixed with the pre-filled sections.
- **Done button** — "All Confirmed" — only active when all sections are either confirmed or updated.

**What the patient sees:**
- Their name in a greeting. Their data already there. A fast confirm-tap flow if nothing changed.
- Stale sections draw attention but don't block — the patient can confirm stale data as "still correct."
- Missing data is separated from existing data. They're not re-entering — they're filling gaps.

**States within this screen:**
| Section State | Visual Treatment |
|---|---|
| Current (confirmed within freshness window) | Collapsed. Green check. One-tap "Still correct." |
| Stale (beyond freshness threshold) | Expanded. Amber indicator. "We last confirmed this on [date]." Confirm or update. |
| Missing (no data on file) | Separate section. "We still need:" with empty input. |
| Updated (patient changed something this session) | Blue highlight. Shows new value. |
| Confirmed (patient tapped "Still correct") | Collapsed. Green check. Done. |

**Boxes matched:** BOX-02 (no re-asking), BOX-03 (confirm not re-enter), BOX-04 (greeting communicates recognition), BOX-D3 (partial data handled distinctly).

---

## S4: Check-in Complete (Both)

**Purpose:** Confirmation that check-in is done. Next steps.

**Patient sees:** "You're all checked in, [First Name]. Please take a seat — we'll call you shortly."

**Receptionist sees:** Check-in record updated. Patient returns to the queue. Any updated data is flagged for verification if needed (e.g., new insurance card to scan).

**Boxes matched:** BOX-04 (experience closure — the patient feels handled, not processed).
