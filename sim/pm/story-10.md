# Story 10 — Acquiring Riverside Family Practice (Major Business Change)

## Customer's Words (Clinic Administrator)

> "We're acquiring Riverside Family Practice. They have 4,000 patients, paper records for half of them, and some electronic records in a completely different system. We need to bring all their patients into our system. Some of their patients are already our patients too — we can't create duplicates."

## What the Customer Is Saying

1. **"4,000 patients"** — Significant scale increase. Current patient volume is unspecified but this is likely a 50-100% increase in total patient records.

2. **"Paper records for half of them"** — 2,000 patients with no electronic data. These require data entry/digitization. This is a migration project, not a feature.

3. **"Electronic records in a completely different system"** — 2,000 patients with structured data in an incompatible format. This requires data mapping, transformation, and import.

4. **"Some of their patients are already our patients too"** — Duplicate detection is mandatory. A patient who exists in both practices must be merged, not duplicated. Merging patient records is one of the hardest problems in healthcare IT.

5. **"We can't create duplicates"** — The administrator knows this is a risk and is stating it as a hard constraint.

## What the Customer Is NOT Saying

- They're not specifying a timeline (but acquisitions typically have legal closing dates that create deadlines)
- They're not describing Riverside's data quality. Paper records may be incomplete, illegible, or inconsistent.
- They're not addressing Riverside's staff — do their receptionists join too? Do they need training?
- They're not addressing patients who haven't visited Riverside in years. Do stale records get imported?

## Scale and Complexity

This is the largest and most complex ask in the system's history. It touches:

1. **Data migration** — Two source formats (paper, foreign EHR) into our system
2. **Duplicate detection** — Matching across systems with different identifiers. Name + DOB is insufficient (married names, typos, shared birthdays). Need probabilistic matching.
3. **Record merging** — When a duplicate is found, which record wins? What if they have conflicting data (different allergies listed at each practice)?
4. **Bulk import** — 4,000 records imported at once affects search index (BOX-E4), database size, and performance (S-09)
5. **Data quality** — Paper records may have missing fields, creating partial records (BOX-D3)
6. **Compliance** — Transferring patient data between practices has HIPAA implications (Business Associate Agreement, patient notification)
7. **Ongoing identity** — After import, patients from Riverside who visit our clinic should be recognized as returning patients (S-01), not treated as new.

## Relationship to Existing Stories

- **S-01** — After migration, Riverside patients must be recognized as returning patients at our locations
- **S-05** — Riverside may become a third location, or its patients may be distributed across our two locations
- **S-09** — 4,000 new records in the search index affects search performance at peak load
- **BOX-D1** (recognition failure graceful path) — During and immediately after migration, recognition failures will spike. The fuzzy search becomes critical.
- **BOX-E4** (eventual consistency) — Bulk import will stress the event bus and search index. The <2s lag target may break during import.

## Open Questions

1. **Timeline** — When does the acquisition close? When must patient records be accessible?
2. **Riverside's system** — What format are the electronic records in? API access or database export?
3. **Data authority** — For duplicate patients, which record is authoritative? Most recent? Most complete? Manual review?
4. **Patient notification** — Must Riverside patients be notified their data is being transferred?
5. **Scope of import** — All 4,000 patients, or only active patients (visited in last N years)?
6. **Riverside as location** — Does the Riverside office become a third clinic location in our system?
