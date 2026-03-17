# State Machine — Complete (Rounds 1-10)

Every path a user can take, across all actors, mapped. No hanging states.

---

## Flow 1: Primary Check-in (Happy Path)

*Origin: S-01 | Modified: S-02, S-04, S-06*

```
[Kiosk: S0 Welcome Screen]
  [Receptionist: S5 Check-in Queue]
    → Receptionist opens S1: Patient Lookup
      → types patient name/DOB
      → results appear (<200ms)
      → selects matching patient
        → S2: Patient Summary
          → reviews data status, sees staleness flags
          → medications section shows amber (always stale per S-06)
          → clicks "Begin Check-in"
            → S3R: Check-in Monitor (receptionist)
            → S3P: Confirm Your Information (kiosk, simultaneously)
              → patient confirms/updates contact info
              → patient confirms/updates insurance
              → patient confirms/updates allergies
              → patient reviews/confirms medications (mandatory, S-06)
                → explicit "I confirm this medication list is current"
              → all sections resolved
                → patient taps "All Confirmed"
                  → spinner while server persists (S-02, BOX-06)
                  → server acknowledges
                    → green checkmark displayed
                      → S3R updates: completion notification event (S-02, BOX-D5)
                        → receptionist clicks "Complete Check-in"
                          → S4: Check-in Complete (kiosk)
                            → auto-transitions to S0 after 10s (S-04)
                          → S5: Queue updated (receptionist)
```

## Flow 2: Recognition Failure

*Origin: S-01 | Modified: S-10*

```
[S1: Patient Lookup]
  → types patient name/DOB
  → no results / patient says "that's not me"
    → clicks "Can't Find Record"
      → S1b: Assisted Search
        → tries alternative criteria (phone, email, old insurance)
        → match found
          → selects patient → S2 (rejoins Flow 1)
        → still no match
          → clicks "Start as New, Merge Later"
            → [First-visit flow, out of scope]
            → record flagged as "possible duplicate"
```

*S-10 note: During Riverside migration period, recognition failures spike. S1b fuzzy search handles imported patients whose data may differ slightly from what they provide verbally.*

## Flow 3: Receptionist Direct Edit

*Origin: S-01 | Unchanged*

```
[S2: Patient Summary]
  → receptionist clicks "Update Record" (instead of "Begin Check-in")
    → inline edit on S2
    → saves
    → remains on S2 (can now "Begin Check-in" or return to S5)
```

## Flow 4: Patient Updates Data During Check-in

*Origin: S-01 | Modified: S-08*

```
[S3P: Confirm Your Information]
  → patient taps "Update" on a section
    → [If insurance section, S-08:]
      → choice: "Take photo of card" or "Enter manually"
      → [If photo:]
        → camera overlay with card frame guide
        → captures front of card
        → optionally captures back of card
        → OCR processing (spinner)
        → [If OCR succeeds:]
          → verification screen: field-by-field review of extracted data
          → patient confirms or edits each field
          → section shows as "Updated" (blue)
        → [If OCR fails:]
          → "We couldn't read your card" → Try again / Enter manually
      → [If manual:]
        → standard edit fields (pre-filled with current values)
        → patient modifies and saves
        → section shows as "Updated" (blue)
    → [For other sections:]
      → section expands to editable fields (pre-filled)
      → patient modifies and saves
      → section shows as "Updated" (blue)
    → S3R: receptionist sees old-vs-new diff
      → [If insurance photo, S-08: receptionist also sees card image]
  → continues to next section
```

## Flow 5: Medication Confirmation (S-06)

*Added in: S-06*

```
[S3P: Confirm Your Information — Medications Section]
  → section is ALWAYS expanded, ALWAYS requires active confirmation
  → [If medications exist:]
    → patient reviews list
    → [Optional: edit existing medication]
      → inline edit: dosage, frequency, prescriber
      → save
    → [Optional: remove medication]
      → confirmation dialog: "Remove [drug] from your list?"
      → removed item shown as struck-through (recoverable in session)
    → [Optional: add new medication]
      → inline form: drug name, dosage, frequency, prescriber (optional)
      → save → added to list
    → taps "I confirm this medication list is current"
      → (button text changes if modifications were made:
         "I confirm these changes to my medication list")
      → section marked as confirmed
  → [If no medications:]
    → patient sees "No medications currently listed"
    → choice: "No, I am not taking any medications" (confirms empty)
             OR "+ Add a medication" (opens add form)
    → either choice confirms the section
```

## Flow 6: Patient Has Partial Data

*Origin: S-01 | Unchanged*

```
[S3P: Confirm Your Information]
  → sections with existing data: standard confirm/update pattern
  → "We still need" section appears at bottom with blank fields
    → patient fills in missing data
    → section shows as "Completed" (green)
  → "All Confirmed" only active when:
    → all existing sections: confirmed or updated
    → all missing sections: completed
    → medications section: explicitly confirmed (S-06)
```

## Flow 7: Stale Data Handling

*Origin: S-01 | Modified: S-06*

```
[S3P: Confirm Your Information]
  → section is stale (beyond freshness threshold)
    → [Insurance: >6 months]
    → [Address: >12 months]
    → [Allergies: never stale]
    → [Medications: always stale — 0 days, S-06]
  → section auto-expanded with amber indicator
  → patient has two choices:
    → "Still Correct" → section collapses, confirmed, staleness resets
    → "Update" → standard edit flow, saves new value, freshness resets
  → [Medications exception: no "Still Correct" shortcut. Must use
     explicit "I confirm" button per Flow 5]
```

## Flow 8: Abort / Interruption (Kiosk)

*Origin: S-01 | Modified: S-04*

```
[S3P: Confirm Your Information]
  → patient walks away / time out (5 min inactivity)
    → S3P transitions to S0: Welcome Screen (S-04, immediate)
    → S3R: receptionist sees "Session timed out"
    → confirmed sections are SAVED (partial progress preserved)
    → unconfirmed sections remain in prior state
    → receptionist can re-initiate from S5 queue
      → returns to S2, then re-sends S3P
      → patient sees partial progress restored when S3P reloads
```

## Flow 9: WebSocket Failure (S-02)

*Added in: S-02*

```
[S3R: Check-in Monitor]
  → WebSocket connection drops
    → connection indicator changes: green → amber
    → "Updates may be delayed" message
    → S3R automatically switches to REST polling (every 10 seconds)
    → patient's actions still persist (patient side unaffected)
    → when patient completes:
      → polling detects completion within 10 seconds
      → S3R updates, "Complete Check-in" activates
  → WebSocket reconnects
    → connection indicator: amber → green
    → polling stops, live updates resume

[Alternative — receptionist uses S5 queue as fallback:]
  → S5 always works via REST (no WebSocket dependency)
  → receptionist sees session statuses via polling/refresh
  → can finalize from S5 directly without S3R
```

## Flow 10: Concurrent Check-in Prevention (S-07)

*Added in: S-07*

```
[S2: Patient Summary]
  → receptionist clicks "Begin Check-in"
  → system detects active session for this patient
    → S2 shows concurrent session state:
      "This patient is being checked in by [Name] at [Location]
       since [time]. Status: [status]."
    → actions: Wait / Contact receptionist
    → [If supervisor:] Take Over Session
      → confirmation: "This will cancel [Name]'s session. Continue?"
        → yes: old session cancelled, new session created
        → no: return to S2 concurrent state

[S8: Finalization Conflict — if prevention fails:]
  → receptionist clicks "Complete Check-in" on S3R
  → server rejects: another session was finalized first
    → S8 shows:
      → both sessions' changes
      → what was applied (other session)
      → what was NOT applied (this session)
    → actions: Apply my changes too / Discard / Contact admin
```

## Flow 11: Mobile Pre-Check-In (S-03)

*Added in: S-03*

```
[Patient receives SMS/email with pre-check-in link]
  → taps link
    → S7: Link Landing
      → [Too early:] "Opens 24 hours before appointment. Check back [date]."
      → [Expired:] "Link expired. Check in at the clinic."
      → [Already completed:] "You've already pre-checked-in."
      → [Active:]
        → S6: Identity Verification Gate
          → enters DOB
          → [Correct:] → S3P (mobile variant)
            → same confirmation flow as kiosk (contact, insurance, allergies, medications)
            → [S-08 photo capture works on phone camera]
            → all sections confirmed
              → S4: Mobile Completion
                → "You're all set for your visit, [Name]."
                → "When you arrive, let the receptionist know."
          → [Incorrect (1-2 attempts):] "Doesn't match. Try again." [X attempts left]
          → [Locked (3 failed):] "Link locked. Verify at clinic." Link permanently dead.

[When patient arrives at clinic:]
  → receptionist opens S5: Queue
    → sees patient with "Pre-checked-in" status (green solid)
    → clicks "Review & Finalize" on S2
      → reviews pre-confirmed data
      → "Finalize Check-in"
        → S4 / S5 updated
        → patient does NOT go through kiosk (the whole point)
```

## Flow 12: Partial Pre-Check-In → Kiosk Completion (S-03)

*Added in: S-03 (BOX-D8)*

```
[Patient starts pre-check-in on phone but doesn't finish]
  → confirmed sections are saved (same as Flow 8 partial save)
  → patient arrives at clinic
    → receptionist looks up patient on S2
    → S2 shows: "Patient started pre-check-in. 3 of 5 sections confirmed."
    → clicks "Begin Check-in"
      → S3P on kiosk shows partial progress restored
      → patient finishes remaining sections on kiosk
      → normal completion flow
```

## Flow 13: Screen Clearing (S-04)

*Added in: S-04*

```
[Any session termination event:]
  → session finalized (receptionist clicks Complete)
  → session timed out (5 min inactivity)
  → session cancelled (receptionist action)

  → Kiosk immediately transitions to S0 (Welcome Screen)
  → Client-side state purge:
    → DOM cleared of all PHI elements
    → JavaScript memory (variables, closures) nullified
    → Browser history replaced (back button → S0)
    → No autocomplete data from session retained
    → Session token invalidated
  → No frame of previous patient data visible during transition
  → S0 loads with zero patient data
```

## Flow 14: Import and Migration (S-10)

*Added in: S-10*

```
[Admin opens S10: Import Dashboard]
  → views progress: total, imported, pending, errors, duplicates
  → [Errors:] clicks "View errors" → error list with reasons
  → [Duplicates:] clicks "Review duplicates" → S11

[S11: Duplicate Review]
  → reviews potential duplicates by confidence tier
  → selects a pair
    → sees side-by-side comparison
    → [Same patient:] clicks "Merge" → S12
    → [Different patients:] clicks "Not the same" → next pair
    → [Unsure:] clicks "Defer" → flagged for later

[S12: Merge Resolution]
  → field-by-field merge selection
  → resolves conflicts (choose which value for each field)
  → non-conflicting fields auto-suggested
  → clicks "Complete merge"
    → merged record created
    → both source records archived (not deleted)
    → audit trail records merge decisions
  → returns to S11 for next pair

[S13: Paper Record Entry — parallel workflow]
  → data entry staff enters paper records one by one
  → enforces minimum data set (name + DOB + contact)
  → flags incomplete records for follow-up
  → skips illegible records for separate handling
```

## Flow 15: Session Recovery (S-07)

*Added in: S-07*

```
[Admin opens S9: Session Recovery]
  → searches for patient or session ID
  → views session history: all sessions including conflicting/expired
  → selects a conflicting session pair
    → side-by-side view of both sessions' data
    → identifies data that was lost (from rejected session)
    → applies specific changes from dead session to patient record
    → or marks as reviewed (no action needed)
```

---

## Transition Summary (Complete)

| From | Event | To | Added/Modified |
|------|-------|----|----------------|
| S0 | Receptionist initiates check-in | S3P | S-04 |
| S1 | Patient selected | S2 | S-01 |
| S1 | No match + "Can't Find" | S1b | S-01 |
| S1 | "New Patient" | [First-visit flow] | S-01 |
| S1b | Match found + selected | S2 | S-01 |
| S1b | No match + "Start as New" | [First-visit flow] | S-01 |
| S2 | "Begin Check-in" (no conflict) | S3R + S3P | S-01 |
| S2 | "Begin Check-in" (active session exists) | S2 concurrent state | S-07 |
| S2 | "Update Record" | S2 inline edit | S-01 |
| S2 | "Review & Finalize" (pre-check-in) | S2 review → S4/S5 | S-03 |
| S2 | Supervisor "Take Over Session" | Cancel old → S3R + S3P | S-07 |
| S3P | Section confirmed/updated | S3R live update (WebSocket/poll) | S-01, S-02 |
| S3P | Insurance "Update" → "Take photo" | Photo capture overlay | S-08 |
| S3P | All sections + meds confirmed + "All Confirmed" | Server ack → green checkmark | S-01, S-02, S-06 |
| S3P | Server ack fails | Error + retry state | S-02 |
| S3P | Timeout (5 min) | S0 + S3R timeout notice | S-01, S-04 |
| S3R | "Complete Check-in" (no conflict) | S4 + S5 | S-01 |
| S3R | "Complete Check-in" (conflict) | S8 | S-07 |
| S3R | WebSocket drops | Polling fallback, amber indicator | S-02 |
| S4 (kiosk) | 10 second timer | S0 | S-04 |
| S4 (mobile) | — | Patient closes tab | S-03 |
| S5 | Select session | S3R or S2 | S-02 |
| S5 | Finalize pre-check-in | S4/S5 | S-03 |
| S7 (link landing) | Link active | S6 | S-03 |
| S7 | Link inactive (early/expired/done) | Dead end with message | S-03 |
| S6 | DOB verified | S3P (mobile) | S-03 |
| S6 | 3 failed attempts | Locked state (dead end with message) | S-03 |
| S8 | Apply/Discard/Contact | S5 or admin | S-07 |
| S9 | Apply recovery changes | Patient record updated | S-07 |
| S10 | View duplicates | S11 | S-10 |
| S11 | Merge selected | S12 | S-10 |
| S11 | Not same / Defer | Next pair in S11 | S-10 |
| S12 | Complete merge | S11 | S-10 |

## Dead-end Audit (Complete)

Every state has an exit:

| Screen | Exit paths | Dead end? |
|--------|-----------|-----------|
| S0 | → S3P (receptionist initiates) | No — waiting state, not dead end |
| S1 | → S2, S1b, first-visit | No |
| S1b | → S2, first-visit | No |
| S2 | → S3R+S3P, S2 edit, S1 (search again), S5 (back to queue) | No |
| S3R | → S4 (finalize), S8 (conflict), S5 (back to queue) | No |
| S3P | → completion → S4/S0, timeout → S0 | No |
| S4 kiosk | → S0 (auto) | No |
| S4 mobile | Patient closes tab | Terminal — intentional |
| S5 | → S1 (new lookup), S2 (select patient), S3R (view session) | No |
| S6 | → S3P (verified), locked (terminal with message) | Locked is intentional terminal |
| S7 | → S6 (active), messages (inactive states) | Inactive states are intentional terminals |
| S8 | → S5 (apply/discard), admin contact | No |
| S9 | → patient record (apply), review list | No |
| S10 | → S11 (duplicates), error views | No |
| S11 | → S12 (merge), next pair | No |
| S12 | → S11 (next pair) | No |
| S13 | → next record, incomplete queue | No |

No hanging states. Intentional terminals are: mobile completion (patient closes tab), locked verification gate (security measure), inactive pre-check-in links (time window enforcement).
