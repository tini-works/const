# Boxes — Story 10 (Acquiring Riverside Family Practice)

---

## BOX-36: All Riverside patient records are importable

4,000 patient records from two sources (paper and foreign EHR) must be importable into our system. The import process must handle both structured data (foreign EHR export) and manual data entry (paper records).

**Traces to:** "We need to bring all their patients into our system."

**Verified when:**
1. Foreign EHR data is mapped, transformed, and imported via automated pipeline
2. Paper records have a manual entry workflow (data entry staff or digitization service)
3. Import progress is tracked: total records, imported, pending, errors

---

## BOX-37: Duplicate patients are detected before import

Before creating a new patient record from Riverside data, the system must check for existing matches in our database. A match must be surfaced for human review, not auto-merged.

**Traces to:** "Some of their patients are already our patients too — we can't create duplicates."

**Verified when:**
1. Import process runs duplicate detection on each record before insert
2. Detection uses probabilistic matching: name (with fuzzy matching for spelling variants), DOB, phone, address, insurance member ID
3. Potential duplicates are flagged for manual review, not auto-resolved
4. Review interface shows both records side-by-side with highlighted differences
5. Reviewer can: merge (choose which fields from which source), mark as separate patients, or defer

---

## BOX-38: Record merging preserves data from both sources

When two records are confirmed as the same patient, merging must not lose data from either source. Conflicting fields must be resolved explicitly.

**Traces to:** Preventing the S-07 problem (lost data from overwrites) at import scale.

**Verified when:**
1. Merge presents conflicting fields for human decision (e.g., different allergies listed)
2. Non-conflicting fields are combined (e.g., one record has address, other has insurance — merged record has both)
3. Merge audit trail records: source records, resolved conflicts, who decided, when
4. Both original source records are retained (archived, not deleted) for reference

---

## BOX-39: Import does not degrade live system performance

Bulk import of 4,000 records must not cause the production system to degrade. S-09 (Monday morning crush) shows the system is already at performance limits during peak.

**Traces to:** Operational reality — the clinic continues operating while migration happens.

**Verified when:**
1. Import runs during off-peak hours or at throttled rate
2. Search index rebuilding from import does not block live queries
3. Performance monitoring during import shows no SLA violations for live check-ins

---

## BOX-40: Post-import, Riverside patients are recognized as returning patients

After migration, a Riverside patient visiting any of our locations for the first time must be recognized as a returning patient (BOX-01). Their imported data must be available for confirmation, not re-entry.

**Traces to:** S-01 — the original promise. Migration must not create a new population of "unrecognized" returning patients.

**Verified when:** A migrated Riverside patient checks in at our clinic. System recognizes them by name + DOB search. Their imported data (address, insurance, allergies, medications) appears pre-filled for confirmation.

---

## BOX-41: Paper record import captures minimum viable data set

Not all paper records will be complete. The import must define a minimum data set required for a patient record to be created, and a process for records that don't meet the minimum.

**Traces to:** "Paper records for half of them" — paper records are inherently incomplete and variable.

**Verified when:**
1. Minimum data set defined: name, DOB, and at least one contact method (phone or address)
2. Records meeting minimum are imported with incomplete fields marked as "needs confirmation at next visit"
3. Records below minimum are flagged for follow-up (contact patient for missing info)

---

## Open Questions

- **Timeline:** When does the acquisition close? Hard deadline for records to be accessible?
- **Riverside's EHR system:** What system? Can we get an API export or only a database dump?
- **Riverside as a location:** Does the Riverside office become Location C in our system? Or are their patients distributed to our existing locations?
- **Paper record digitization:** Who does the data entry? Our staff, Riverside's staff, a third-party service?
- **Active vs. inactive patients:** Import all 4,000, or only patients who visited in the last N years?
- **Patient notification:** Must Riverside patients be notified their records are being transferred? HIPAA may require this.
- **Riverside staff:** Are their receptionists joining us? Do they need system access/training?
