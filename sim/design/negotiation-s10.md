# Design Negotiation — Story 10 (Acquiring Riverside Family Practice)

## Context

Major business change. Acquiring a practice with 4,000 patients, half paper records, half in a foreign EHR. Need to import, deduplicate, merge. Largest scope change in the system's history.

## Boxes Received from PM

| Box | Verdict | Notes |
|-----|---------|-------|
| BOX-36: All Riverside patient records are importable | **Accepted — requires admin tooling** | This is an admin/data migration flow, not a patient-facing feature. I'm designing the import monitoring dashboard as an admin tool. |
| BOX-37: Duplicate patients detected before import | **Accepted — requires a review interface** | This is the most complex screen in the system. Side-by-side patient comparison with field-level diff and merge controls. This is admin-only, not part of check-in. |
| BOX-38: Record merging preserves data from both sources | **Accepted — extends the review interface** | The merge control must show every field from both records, highlight conflicts, and let the reviewer choose which value wins, field by field. |
| BOX-39: Import does not degrade live system | **Accepted — no direct design impact** | This is an engineer/DevOps box. Throttling is invisible to the admin reviewing records — they just see import progress. |
| BOX-40: Post-import, Riverside patients recognized as returning | **Accepted — no new screens** | This is a data quality box. If the import is done correctly, S1 search finds these patients, S3P shows their data. The existing screens handle it. |
| BOX-41: Paper records have minimum viable data set | **Accepted with design specificity** | The paper record data entry interface needs to enforce the minimum (name + DOB + at least one contact method) and flag incomplete records. |

## Boxes I'm Adding

### BOX-D21: Duplicate review interface supports confidence tiers

Not all potential duplicates are equal. Some are near-certain matches (same name, same DOB, same address). Some are weak possibilities (similar name, different DOB). The review interface must present these in priority order and show the match confidence so the reviewer can triage efficiently.

**Why this matters:** With 4,000 records, even a 5% duplicate rate = 200 potential duplicates to review. If they're all presented equally, the reviewer wastes time on weak matches. Confidence tiers let them handle high-confidence matches quickly and focus effort on ambiguous cases.

**Tiers:**
- **High confidence (>90%):** Same name (fuzzy) + same DOB + at least one matching ID (phone, insurance). Likely the same person. Quick merge.
- **Medium confidence (60-90%):** Partial matches. Same name but different DOB, or same DOB but different name spelling. Needs human judgment.
- **Low confidence (<60%):** Weak signals. Algorithm flagged it, but probably different people. Quick dismiss.

### BOX-D22: Import dashboard shows real-time progress and error categories

The admin needs a dashboard showing import status, not just a progress bar. They need to know: how many records imported, how many pending, how many failed, how many flagged as duplicates, how many below minimum data set.

**Why this matters:** An import of 4,000 records takes hours or days. The admin checks periodically. They need a glanceable dashboard that tells them if the import is healthy or stuck.

### BOX-D23: Merged record shows provenance

After a merge, the resulting patient record should show where data came from. "Address: from our records. Insurance: from Riverside records. Allergies: merged (our records listed Penicillin; Riverside records listed Penicillin + Sulfa)."

**Why this matters:** After migration, if a data issue appears, the clinic needs to trace back to the source. Without provenance, debugging data quality issues is blind.

## New Screens (Admin Tooling)

These screens are NOT part of the check-in flow. They're accessed from an admin panel.

### S10: Import Dashboard

```
[Import Dashboard - S10]

Riverside Family Practice Migration
Started: 2025-03-15 | Last updated: 5 min ago

Progress:
  Total records:     4,000
  Imported:          2,847  (71%)  ████████████████████░░░░░░░░
  Pending:           953
  Errors:            42     [View errors]
  Duplicate review:  158    [Review duplicates]

By source:
  Electronic (EHR):  1,823 / 2,000  (91%)
  Paper entry:       1,024 / 2,000  (51%)

Import rate: ~120 records/hour
Estimated completion: 2025-03-16 14:00

[Pause import]  [View audit log]
```

### S11: Duplicate Review

```
[Duplicate Review - S11]

158 potential duplicates | Reviewed: 43 | Remaining: 115

Confidence filter: [All ▼]  [High (>90%): 28]  [Medium: 87]  [Low: 43]

─── Match #44: HIGH CONFIDENCE (94%) ───────────────────

OUR RECORD                         RIVERSIDE RECORD
Name: Maria Rodriguez              Name: Maria E. Rodriguez
DOB:  1965-03-14                   DOB:  1965-03-14
Phone: (555) 234-5678              Phone: (555) 234-5678
Address: 123 Main St, Springfield  Address: 45 River Rd, Riverside
Insurance: Aetna #12345            Insurance: Aetna #12345
Allergies: Penicillin              Allergies: Penicillin, Sulfa
Medications: Lisinopril 10mg       Medications: Lisinopril 10mg,
                                               Metformin 500mg

Match signals: Name (fuzzy 96%), DOB (exact), Phone (exact),
               Insurance ID (exact)

[Merge — same patient]  [Not the same patient]  [Defer]
```

### S12: Merge Resolution (when "Merge" is selected)

```
[Merge Resolution - S12]

Merging: Maria Rodriguez / Maria E. Rodriguez

For each field, choose which value to keep:

Name:        ○ Maria Rodriguez (ours)
             ● Maria E. Rodriguez (Riverside)    ← newer record

DOB:         ● 1965-03-14 (same in both)

Address:     ● Keep both — our address as primary, Riverside as previous
             ○ Our address only (123 Main St)
             ○ Riverside address only (45 River Rd)

Insurance:   ● Aetna #12345 (same in both)

Allergies:   ○ Penicillin only (ours)
             ● Penicillin + Sulfa (Riverside — superset)    ← safer

Medications: ○ Lisinopril only (ours)
             ● Lisinopril + Metformin (Riverside — superset)  ← safer
             ○ Flag for review at next visit

[Complete merge]  [Back to comparison]
```

### S13: Paper Record Entry

```
[Paper Record Entry - S13]

Record 1,025 of 2,000 | Batch: Riverside Paper Records

Source: [scanned paper form image, if digitized]

Required fields:
  Name: [________________] *
  DOB:  [__/__/____] *
  Contact (at least one):
    Phone:   [________________]
    Address: [________________]

Optional fields:
  Insurance provider: [________________]
  Insurance ID:       [________________]
  Allergies:          [________________]
  Medications:        [________________]

[Save and Next]  [Flag as incomplete]  [Skip — illegible]
```

Records flagged as incomplete go into a follow-up queue. Records marked illegible get a separate workflow.

## Impact on Existing Screens

1. **S1 (Patient Lookup)** — After import, search results include Riverside patients. No design change needed if the data layer includes them.
2. **S1b (Assisted Search)** — During the migration period, recognition failures will spike for Riverside patients visiting our locations for the first time post-import. The fuzzy search (BOX-D1) becomes critical. No design change, but the scenario frequency increases.
3. **S3P (Confirm Your Info)** — Riverside patients with imported data see pre-filled fields from their Riverside records. This is BOX-40. The provenance note (BOX-D23) could appear here: "Insurance imported from your Riverside records on [date]." This helps the patient understand why data they didn't give US is already there.

## Push-back to PM

1. **This is a project, not a feature.** The import dashboard, duplicate review, merge resolution, and paper entry screens constitute a separate admin application. This should be scoped, resourced, and scheduled as its own workstream. It shares data with the check-in system but has a different user (admin, not receptionist/patient), different workflow, and different quality criteria.

2. **Duplicate detection quality is not a design problem.** I can design the best review interface in the world, but if the matching algorithm produces too many false positives, the reviewer drowns in noise. If it produces false negatives, duplicates slip through. PM must work with Engineer to define acceptable false positive/negative rates. The confidence tiers I designed (BOX-D21) help, but they depend on a good algorithm underneath.

3. **Paper record entry needs dedicated staff, not receptionist time.** If the clinic expects receptionists to enter 2,000 paper records between patient check-ins, that's unrealistic. PM should plan for dedicated data entry time or a third-party digitization service. My S13 design supports either workflow, but the staffing model is a PM decision.

4. **Patient notification about data transfer (HIPAA) may require a new communication.** If Riverside patients must be notified that their records were transferred, is that a letter? An email? A notice at first visit? If it's a notice at first visit, I need to design a "Welcome from Riverside" interstitial on S3P for migrated patients. PM should decide before the import begins.

5. **"Riverside as location" answer affects my location indicator (BOX-D11).** If Riverside becomes Location C, it appears in the location selector. If Riverside patients are distributed to our existing locations and the Riverside office closes, no location change needed. PM must answer this.
