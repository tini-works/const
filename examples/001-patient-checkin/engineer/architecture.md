# Engineer — HIS Integration Architecture

## The constraint

HIS (Hospital Information System) stores patient data in **two separate modules:**

| Module | Contains | Endpoint |
|--------|----------|----------|
| Module A | Demographics (name, address, phone, insurance, emergency contact) | `GET /his/patients/{mrn}/demographics` |
| Module B | Allergies (allergens, reactions, severity, last updated date) | `GET /his/patients/{mrn}/allergies` |

These are different databases, different update cycles, different teams. Demographics update when the patient visits. Allergies update when a clinician records a change — which might not happen every visit.

## The discovery: allergy staleness

During implementation, we found that allergy data in Module B can be arbitrarily stale. A patient who visits regularly might have demographics updated every time, but allergies from 2 years ago.

A "confirm" flow that shows stale allergy data as current is a clinical safety risk. The patient taps "Confirm" thinking their allergies are correct, but they've developed a new allergy since the last update.

**Surfaced to PM and Design as a new commitment:** if allergy data is >6 months since last update, force re-confirmation before the normal check-in flow.

This is the system revealing a risk the patient and PM can't see. The two-module architecture created the staleness gap. Engineer's job is to surface it, not to silently accept it.

## System design

```
Patient scans card
    → Check-In Service receives MRN
    → Parallel fetch:
        ├── GET /his/patients/{mrn}/demographics → demographics data
        └── GET /his/patients/{mrn}/allergies    → allergies data + last_updated timestamp
    → Compare allergy last_updated to current date
        ├── Stale (>6 months) → flag for re-confirmation
        └── Fresh (≤6 months) → proceed normally
    → Diff current data against last-visit snapshot
        → Changed fields flagged for staff review
    → Send pre-filled form to kiosk
```

## What goes suspect if this changes

- If HIS changes their API contract (response shape, field names) → all flows break
- If HIS merges Module A and B → architecture simplifies, but flows need re-verification
- If clinical policy changes the staleness threshold (6 months → 3 months) → FLW-04 and VP-03 need updating
