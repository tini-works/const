# Flow Diagrams — Visual Reference

Companion to the text-based user flows and screen specs. Each diagram is interactive — click to view full size.

---

## Kiosk Check-In Flow
All screens and state transitions for the kiosk check-in experience, including error paths and the BUG-001/BUG-002 fixes.

https://diashort.apps.quickable.co/d/46ad65e9

---

## Mobile Check-In Flow
End-to-end mobile check-in journey including link states, partial completion/resume, and kiosk duplicate prevention.

https://diashort.apps.quickable.co/d/e00cefa4

---

## Kiosk-to-Receptionist Sync (BUG-001 Fix)
Sequence diagram showing the end-to-end sync verification between kiosk confirmation and receptionist dashboard update, including the three possible outcomes (confirmed, timeout, failure).

https://diashort.apps.quickable.co/d/e90549a3

---

## Concurrent Edit Conflict Resolution (BUG-003 Fix)
Sequence diagram showing optimistic concurrency control when two receptionists edit the same patient record simultaneously.

https://diashort.apps.quickable.co/d/7fd8a747

---

## Riverside Migration Pipeline
Data flow from Riverside EMR export and paper records through validation, duplicate detection, staff review, and patient first-visit confirmation.

https://diashort.apps.quickable.co/d/b382c1ca
