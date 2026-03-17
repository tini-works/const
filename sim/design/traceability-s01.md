# Box Traceability — Story 01

Every box must land on a screen. Every screen must serve a box. This is the cross-reference.

## State machine diagram

https://diashort.apps.quickable.co/d/1b409822

## Box → Screen Mapping

| Box | Screen(s) | How It's Matched |
|-----|-----------|-----------------|
| BOX-01: Returning patient is recognized | S1 (Patient Lookup) | Lookup returns matching patients before any form is shown. Recognition is the first thing that happens. |
| BOX-02: Previously collected data is not re-asked | S3P (Confirm Your Info) | All existing data is pre-filled. No blank fields for data on file. |
| BOX-03: Confirm or update, not re-enter | S3P (Confirm Your Info) | Each section has "Still correct" / "Update" actions. No blank-form re-entry. |
| BOX-04: Experience communicates recognition | S3P (greeting), S2 (receptionist uses name), S4 (personalized closure) | Greeting by first name. Receptionist has context to address patient personally. Completion message uses name. |
| BOX-D1: Recognition failure has graceful path | S1b (Assisted Search) | Alternative lookup, fuzzy matching, and fallback to "start as new with merge-later flag." No dead end. |
| BOX-D2: Two actors, two views | S2/S3R (receptionist), S3P (patient) | Receptionist has operational views (lookup, status, diff). Patient has confirmation view (greeting, confirm/update). Different information density, same underlying data. |
| BOX-D3: Partial data handled without confusion | S3P ("We still need" section) | Missing fields are visually separated from pre-filled fields. Patient is filling gaps, not re-entering. |

## Screen → Box Mapping (reverse — proves no orphan screens)

| Screen | Boxes Served |
|--------|-------------|
| S1: Patient Lookup | BOX-01 |
| S1b: Assisted Search | BOX-D1 |
| S2: Patient Summary | BOX-01, BOX-04, BOX-D2 |
| S3R: Check-in Monitor | BOX-D2 |
| S3P: Confirm Your Info | BOX-02, BOX-03, BOX-04, BOX-D3 |
| S4: Check-in Complete | BOX-04 |

Every screen serves at least one box. No orphans.

## Unmatched / Pending

- PM's open question on **identity verification method** affects S1 search fields. Current design assumes Name + DOB primary, insurance card secondary. If PM confirms a different method, S1 region layout changes.
- PM's open question on **freshness thresholds** affects S3P staleness indicators. Current design uses assumed thresholds (6mo insurance, 12mo address, never allergies). Values are parameterizable — screen behavior won't change, only the trigger.
- PM's open question on **multi-location** affects S1b search scope. Currently designed as if data persists across locations. If not, S1b needs a location filter.
