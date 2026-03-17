# Boxes — Story 05 (Second Clinic Location)

---

## BOX-19: Patient data is location-independent

A patient record is the same regardless of which location accesses it. Update at Location A is visible at Location B. No location-specific data silos.

**Traces to:** "Their info needs to be the same at both clinics."

**Verified when:**
1. Patient updates insurance at Location A
2. Patient visits Location B the next day
3. Location B shows the updated insurance without re-entry

---

## BOX-20: Check-in works at any location for any patient

A patient who has historically visited Location A can check in at Location B and be recognized as a returning patient with all their data.

**Traces to:** "I don't want patients re-entering everything just because they walked into the other building."

**Verified when:** Patient search at Location B returns patients originally registered at Location A. Check-in flow at Location B shows all existing data regardless of origin location.

---

## BOX-21: Location is a context, not a boundary

Appointments, check-in sessions, and staff assignments are location-specific. Patient records, data history, and audit trails are cross-location.

**Traces to:** Architectural clarity — some things are per-location, some are global.

**Verified when:** Data model separates location-specific entities (appointment, session, staff roster) from global entities (patient, patient_data, audit). Queries for patient data never filter by location.

---

## Open Questions

- **Staff access scope:** Can Location A staff see that a patient is currently checked in at Location B? Recommend: yes, for coordination.
- **Reporting:** Does the administrator want per-location reports or aggregate reports? Likely both.
- **Location-specific configurations:** Different operating hours, different kiosk counts, different appointment types?
