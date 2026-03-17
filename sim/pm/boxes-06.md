# Boxes — Story 06 (Medication List Mandate)

---

## BOX-22: Medication list is collected at every check-in

The patient's current medication list must be presented for confirmation or update at every visit, regardless of how recently it was last confirmed.

**Traces to:** "The patient must confirm or update their medications at every visit."

**Verified when:** The check-in flow always includes a medications section. This section cannot be skipped. The section is always expanded (never collapsed as "no changes needed").

---

## BOX-23: Medication list supports variable-length structured data

Unlike address (single value) or insurance (fixed fields), medications are a list of 0-N items, each with: drug name, dosage, frequency, prescribing doctor (optional).

**Traces to:** Nature of medication data — patients may be on zero or many medications.

**Verified when:**
1. Patient can confirm existing medication list as-is
2. Patient can add a new medication
3. Patient can remove a medication (mark as discontinued)
4. Patient can update dosage/frequency of existing medication
5. "No medications" is a valid, confirmable state

---

## BOX-24: Medication confirmation is auditable for compliance

The clinic must be able to prove that medication confirmation happened at every visit. This is a license renewal requirement.

**Traces to:** "Mandatory for license renewal."

**Verified when:** Audit trail records: patient ID, visit date, medication list at time of confirmation, confirmation timestamp, and whether any changes were made. This audit trail can be exported for regulatory review.

---

## BOX-25: Medication data integrates with existing check-in flow

Medications are a new data category added to the existing check-in flow, not a separate workflow. The patient confirms medications alongside allergies, insurance, and address.

**Traces to:** "During check-in" — the mandate places this in the check-in flow.

**Verified when:** Medications appear as a section in the check-in confirmation screen (S3P), with the same confirm/update UX as other sections. Section order: existing sections + medications. Medications section is always present, always requires active confirmation.

---

## Timeline

**Deadline: Q3.** This is non-negotiable. The clinic's license depends on it. All verticals must have medications integrated into check-in by Q3 launch.
