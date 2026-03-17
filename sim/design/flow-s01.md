# State Machine — Story 01: Returning Patient Check-in

Every path a user can take, mapped. No hanging states.

---

## Primary Flow (happy path)

```
[Receptionist opens system]
  → S1: Patient Lookup
    → types patient name/DOB
    → results appear
    → selects matching patient
      → S2: Patient Summary
        → reviews data status, sees staleness flags
        → clicks "Begin Check-in"
          → S3R: Check-in Monitor (receptionist)
          → S3P: Confirm Your Information (patient, simultaneously)
            → patient confirms/updates each section
            → all sections resolved
              → patient taps "All Confirmed"
                → S3R updates: all sections complete
                  → receptionist clicks "Complete Check-in"
                    → S4: Check-in Complete (both)
```

## Recognition Failure Flow

```
[S1: Patient Lookup]
  → types patient name/DOB
  → no results / patient says "that's not me" for all results
    → clicks "Can't Find Record"
      → S1b: Assisted Search
        → tries alternative criteria (phone, email, old insurance)
        → match found
          → selects patient → S2 (rejoins primary flow)
        → still no match
          → clicks "Start as New, Merge Later"
            → [First-visit flow, out of scope]
            → record flagged as "possible duplicate"
```

## Receptionist Direct Edit Flow

```
[S2: Patient Summary]
  → receptionist clicks "Update Record" (instead of "Begin Check-in")
    → inline edit on S2, receptionist modifies fields directly
    → saves
    → remains on S2 (can now "Begin Check-in" or handle next patient)
```

This flow exists because not every update needs the patient's involvement. Receptionist scans a new insurance card, updates the record, then proceeds with check-in.

## Patient Updates Data During Check-in

```
[S3P: Confirm Your Information]
  → patient taps "Update" on a section
    → section expands to editable fields (pre-filled with current value)
    → patient modifies and saves
    → section shows as "Updated" (blue)
    → S3R: receptionist sees old-vs-new diff for that section
  → continues to next section
```

## Patient Has Partial Data

```
[S3P: Confirm Your Information]
  → sections with existing data: standard confirm/update pattern
  → "We still need" section appears at bottom with blank fields
    → patient fills in missing data
    → section shows as "Completed" (green)
  → "All Confirmed" only active when:
    → all existing sections: confirmed or updated
    → all missing sections: completed
```

## Stale Data Handling

```
[S3P: Confirm Your Information]
  → section is stale (beyond freshness threshold)
    → section auto-expanded with amber indicator
    → patient has two choices:
      → "Still Correct" → section collapses, marked confirmed, staleness timer resets
      → "Update" → standard edit flow, saves new value, freshness resets
```

## Abort / Interruption

```
[S3P: Confirm Your Information]
  → patient walks away / time out (5 min inactivity)
    → S3R: receptionist sees "Session timed out"
    → any confirmed sections are SAVED (partial progress preserved)
    → unconfirmed sections remain in their prior state
    → receptionist can re-initiate check-in (returns to S2, then re-sends S3P)
    → patient sees their partial progress restored when S3P reloads
```

No data loss on interruption. The patient doesn't start over.

---

## Transition Summary

| From | Event | To |
|------|-------|----|
| S1 | Patient selected | S2 |
| S1 | No match + "Can't Find" | S1b |
| S1 | "New Patient" | [First-visit flow, out of scope] |
| S1b | Match found + selected | S2 |
| S1b | No match + "Start as New" | [First-visit flow, out of scope] |
| S2 | "Begin Check-in" | S3R + S3P (parallel) |
| S2 | "Update Record" | S2 (inline edit) |
| S3P | All sections resolved + "All Confirmed" | S3R signals ready |
| S3R | "Complete Check-in" | S4 |
| S3P | Timeout (5 min) | S3R shows timeout, partial progress saved |
| S3R | Re-initiate after timeout | S2 → S3R + S3P (progress restored) |

## Dead-end Audit

Every state has an exit:
- S1 → forward to S2, S1b, or first-visit flow
- S1b → forward to S2 or first-visit flow (no dead end even on total failure)
- S2 → forward to S3R+S3P or back to S1 (receptionist can search again)
- S3P → forward to completion or timeout with saved progress
- S3R → forward to S4 or re-initiate
- S4 → terminal (check-in complete, flow ends)

No hanging states.
