# Design — Check-In Screens

Three screens. Each exists because a specific commitment requires it.

---

## SCR-01: Welcome Back

**Who sees this:** Returning patients at the check-in kiosk.

**What it shows:**
- Patient name, date of birth (read-only, for identification)
- Address, phone, emergency contact — pre-filled, with edit toggles
- Insurance provider and policy number — pre-filled, with edit toggle
- Allergies — pre-filled, with edit toggle (unless stale — then redirected to SCR-03)
- "Confirm" button at the bottom

**Behavior:**
- All editable fields start in read mode (displayed, not input fields)
- Tapping "Edit" on any field switches it to input mode
- Changed fields are highlighted and flagged for staff review
- "Confirm" submits: if edits were made → staff review queue; if no edits → patient is ready

**Exists because:** Commitment 1 (data pre-filled) and Commitment 3 (confirm, don't re-enter).

**Verify:** In staging, check in with MRN TEST001 (returning patient). Welcome Back screen appears with pre-filled fields. Edit insurance. Confirm. Check staff review queue — entry should appear with the insurance change flagged.

---

## SCR-02: Staff Review Queue

**Who sees this:** Receptionist at the front desk.

**What it shows:**
- List of patients who made edits during check-in confirmation
- For each patient: name, which fields changed, old value → new value
- "Approve" or "Flag for follow-up" actions per patient

**Behavior:**
- New entries appear in real-time as patients confirm with edits
- Approved patients move to "Ready" status
- Flagged patients are held for follow-up conversation

**Exists because:** Commitment 1 (changes flagged for staff review).

**Verify:** After a patient edits a field on SCR-01 and confirms, the change appears in the staff review queue within 5 seconds. Approve it. Patient status changes to Ready.

---

## SCR-03: Allergy Re-confirmation

**Who sees this:** Returning patients whose allergy data hasn't been updated in >6 months.

**What it shows:**
- "It's been a while since we confirmed your allergies"
- Current allergies listed with dates last updated
- "These are still correct" button (confirms as-is, resets staleness clock)
- "Update my allergies" button (opens allergy edit form)

**Behavior:**
- This screen appears BEFORE the Welcome Back screen when allergy data is stale
- Patient must either confirm or update before proceeding to SCR-01
- After confirmation or update, the staleness clock resets

**Exists because:** Commitment 4 (allergy staleness guard — clinical safety).

**Verify:** In staging, check in with MRN TEST003 (patient with allergy data last updated 8 months ago). Allergy Re-confirmation screen appears before Welcome Back. Confirm allergies. Staleness clock resets. Next check-in (if within 6 months) skips this screen.
