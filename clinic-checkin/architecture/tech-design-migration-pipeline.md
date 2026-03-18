# Technical Design: Riverside Patient Data Migration Pipeline

**Related:** Epic [E5](../product/epics.md#e5-riverside-practice-acquisition), [US-012](../product/user-stories.md#us-012-patient-data-migration-from-riverside), [US-013](../product/user-stories.md#us-013-duplicate-patient-detection-and-merge), PRD Riverside Acquisition, [ADR-008](adrs.md#adr-008-duplicate-detection-algorithm-for-riverside-migration), [ADR-010](adrs.md#adr-010-migration-pipeline-architecture--batch-import-with-rollback)
**Screens:** [4.1 Migration Dashboard](../experience/screen-specs.md#41-admin--migration-dashboard), [4.2 Duplicate Review](../experience/screen-specs.md#42-admin--duplicate-review-screen)
**Flows:** [13. First Visit After Migration](../experience/user-flows.md#13-riverside-migration--first-visit-after-migration), [14. Duplicate Detection Staff Review](../experience/user-flows.md#14-duplicate-detection--staff-review-riverside)
**Tested by:** [TC-1001](../quality/test-suites.md#tc-1001-emr-import--valid-records), [TC-1002](../quality/test-suites.md#tc-1002-emr-import--validation-failures), [TC-1003](../quality/test-suites.md#tc-1003-duplicate-detection--exact-match), [TC-1004](../quality/test-suites.md#tc-1004-duplicate-detection--no-match), [TC-1005](../quality/test-suites.md#tc-1005-staff-merge-review--field-level-merge), [TC-1006](../quality/test-suites.md#tc-1006-staff-review--keep-separate), [TC-1007](../quality/test-suites.md#tc-1007-migration-rollback), [TC-1008](../quality/test-suites.md#tc-1008-first-visit-after-migration--patient-confirmation), [TC-1009](../quality/test-suites.md#tc-1009-paper-record-ocr-pipeline), [TC-1010](../quality/test-suites.md#tc-1010-duplicate-detection--near-miss-below-threshold), [TC-1011](../quality/test-suites.md#tc-1011-no-auto-merge-verification)
**Monitored by:** [Migration Dashboard](../operations/monitoring-alerting.md#5-migration-dashboard-temporary----during-riverside-migration)
**Confirmed by:** Alex Kim (Tech Lead), 2024-12-22

---

## Problem

We're acquiring Riverside Family Practice. They have 4,000 patient records:
- ~2,000 in their EMR system (different schema, different system)
- ~2,000 on paper (needs scanning and OCR)

An estimated 5-15% of Riverside patients are already in our system. We need to import all records without creating duplicates, losing data, or corrupting existing records. The migration must be reversible if systemic issues are found.

---

## Pipeline Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                    Source Data                                 │
│                                                               │
│   Riverside EMR Export        Scanned Paper Records           │
│   (CSV/JSON, ~2,000 records) (PDF/images, ~2,000 records)    │
└──────────┬────────────────────────────┬──────────────────────┘
           │                            │
           ▼                            ▼
┌──────────────────┐          ┌──────────────────┐
│  Schema Mapper   │          │   OCR Pipeline   │
│                  │          │                  │
│  Riverside field │          │  Scan → S3       │
│  → Our field     │          │  S3 → OCR Service│
│                  │          │  Structured data │
└──────────┬───────┘          └──────────┬───────┘
           │                             │
           └───────────┬─────────────────┘
                       │
                       ▼
            ┌──────────────────┐
            │    Validator     │
            │                  │
            │  Required fields │
            │  Format checks   │
            │  Data type checks│
            └──────────┬───────┘
                       │
              ┌────────┴────────┐
              │                 │
         Valid records     Invalid records
              │                 │
              ▼                 ▼
   ┌──────────────────┐  Status: "import_error"
   │  Dedup Engine    │  → Staff review queue
   │                  │
   │  Match against   │
   │  existing patients│
   └──────────┬───────┘
              │
     ┌────────┴────────┐
     │                 │
  No match         Match found
     │                 │
     ▼                 ▼
  Import as        Status: "potential_duplicate"
  new patient      → Staff review queue
     │                 │
     ▼                 │
  Status: "imported"   │
  patient_confirmed=   │
    FALSE              │
                       ▼
            ┌──────────────────┐
            │  Staff Review    │
            │                  │
            │  Side-by-side    │
            │  comparison      │
            │                  │
            │  Merge / Separate│
            │  / Flag          │
            └──────────────────┘
```

---

## Schema Mapping: Riverside EMR to Our Data Model

Riverside's EMR uses a different schema. The mapper translates field names, normalizes formats, and flags unmappable data.

### Field Mapping

| Riverside Field | Our Field | Transform |
|----------------|-----------|-----------|
| `patient_first` | `first_name` | Trim, title case |
| `patient_last` | `last_name` | Trim, title case |
| `patient_middle` | `middle_name` | Trim, title case; NULL if empty |
| `dob` | `date_of_birth` | Parse MM/DD/YYYY or YYYY-MM-DD to DATE |
| `phone_home` or `phone_cell` | `phone` | Normalize to digits, format as XXX-XXX-XXXX. Prefer cell. |
| `email_address` | `email` | Lowercase, validate format |
| `addr_line1` | `address_line1` | Trim |
| `addr_line2` | `address_line2` | Trim; NULL if empty |
| `addr_city` | `city` | Trim, title case |
| `addr_state` | `state` | Uppercase, 2-letter code |
| `addr_zip` | `zip_code` | First 5 digits (strip +4 if present) |
| `ssn` | `ssn_last4` | Extract last 4 digits, hash for storage |
| `ins_carrier` | `insurance.payer_name` | Trim |
| `ins_policy_no` | `insurance.member_id` | Trim |
| `ins_group` | `insurance.group_number` | Trim |
| `ins_plan` | `insurance.plan_type` | Map to our enum (PPO/HMO/EPO/POS/Other) |
| `allergies` | `allergies[]` | Parse delimited list. Map severity if provided. |
| `medications` | `medications[]` | Parse structured list: name, dose, frequency. Map frequency to our enum. |

### Frequency Mapping (Medications)

| Riverside Format | Our Enum |
|-----------------|----------|
| `QD`, `daily`, `once daily` | `once_daily` |
| `BID`, `twice daily` | `twice_daily` |
| `TID`, `three times daily` | `three_times_daily` |
| `PRN`, `as needed` | `as_needed` |
| Anything else | `other` |

### Handling Unmappable Data

Fields that don't map to our schema are stored in the `migration_records.source_data` JSONB column. They're preserved for reference but not imported into the patient record. This includes Riverside-specific fields like provider notes, billing codes, and visit history (per PRD: "Won't have: Historical visit records from Riverside").

---

## Duplicate Detection Engine

Implements the algorithm described in ADR-008.

### Process

```
For each validated Riverside record R:

1. Query candidates:
   SELECT id, first_name, last_name, date_of_birth, phone, ssn_last4, address_line1
   FROM patients
   WHERE date_of_birth = R.date_of_birth
     AND deleted_at IS NULL

2. For each candidate C, calculate match score:

   score = 0.0

   -- Full name + DOB exact
   IF normalize(R.first_name) = normalize(C.first_name)
      AND normalize(R.last_name) = normalize(C.last_name):
       score += 0.50

   -- Last name + DOB (first name may differ)
   ELSE IF normalize(R.last_name) = normalize(C.last_name):
       score += 0.35

   -- SSN last-4 match
   IF R.ssn_last4 IS NOT NULL AND R.ssn_last4 = C.ssn_last4:
       score += 0.25

   -- Phone match
   IF normalize_phone(R.phone) = normalize_phone(C.phone):
       score += 0.20

   -- Address match
   IF fuzzy_match_address(R.address, C.address):
       score += 0.10

   -- Phonetic first name match (catches Bob/Robert, Bill/William)
   IF soundex(R.first_name) = soundex(C.first_name)
      AND score < 0.50:  -- only add if full name match didn't already fire
       score += 0.10

3. If score >= 0.40:
   Create duplicate_candidate record with score and match_reasons

4. If no candidates score >= 0.40:
   Import R as new patient (patient_confirmed = FALSE)
```

### Name Normalization

```typescript
function normalizeName(name: string): string {
  return name
    .toLowerCase()
    .trim()
    .replace(/\s+/g, ' ')           // collapse whitespace
    .replace(/\b(jr|sr|iii|iv|ii)\.?\b/gi, '')  // strip suffixes
    .replace(/[^a-z\s]/g, '')       // strip non-alpha
    .trim();
}
```

### Phone Normalization

```typescript
function normalizePhone(phone: string | null): string | null {
  if (!phone) return null;
  const digits = phone.replace(/\D/g, '');
  // Handle country code prefix
  if (digits.length === 11 && digits.startsWith('1')) {
    return digits.substring(1);
  }
  return digits.length === 10 ? digits : null;
}
```

### Address Fuzzy Match

```typescript
function fuzzyMatchAddress(a: Address, b: Address): boolean {
  // Normalize street abbreviations
  const normalizeStreet = (s: string) => s
    .toLowerCase()
    .replace(/\bst\.?\b/g, 'street')
    .replace(/\bave\.?\b/g, 'avenue')
    .replace(/\bdr\.?\b/g, 'drive')
    .replace(/\brd\.?\b/g, 'road')
    .replace(/\bln\.?\b/g, 'lane')
    .replace(/\bblvd\.?\b/g, 'boulevard')
    .replace(/\bapt\.?\b/g, 'apartment')
    .replace(/\bste\.?\b/g, 'suite');

  return normalizeStreet(a.line1) === normalizeStreet(b.line1)
    && a.zip_code === b.zip_code;
}
```

---

## Merge Operation

When staff confirms a merge, the system combines two patient records into one.

### Merge Process

```
1. Staff selects field-level merge decisions:
   For each differing field: keep_ours | keep_theirs | edit (custom value)

2. System executes merge in a transaction:

   BEGIN TRANSACTION;

   -- Snapshot both records for audit trail
   INSERT INTO patient_record_versions (patient_id, version, snapshot, ...)
     VALUES (existing_patient_id, current_version, current_snapshot, ...);

   -- Apply merge decisions to the existing patient record
   UPDATE patients
   SET
     field1 = CASE WHEN decision = 'keep_theirs' THEN riverside_value ELSE existing_value END,
     ...
     version = version + 1,
     updated_at = NOW()
   WHERE id = existing_patient_id AND version = current_version;

   -- Merge clinical lists
   -- If medications decision = 'merge_both':
   INSERT INTO medications (patient_id, name, dosage, frequency, source)
     SELECT existing_patient_id, name, dosage, frequency, 'migrated_emr'
     FROM temp_riverside_medications
     WHERE NOT EXISTS (
       SELECT 1 FROM medications
       WHERE patient_id = existing_patient_id
         AND name = temp_riverside_medications.name
         AND deleted_at IS NULL
     );
   -- (Same pattern for allergies)

   -- Link Riverside migration record to the existing patient
   UPDATE migration_records
   SET patient_id = existing_patient_id, status = 'duplicate_resolved'
   WHERE id = riverside_migration_record_id;

   -- Resolve the duplicate candidate
   UPDATE duplicate_candidates
   SET resolution = 'merged', resolved_by = staff_id, resolved_at = NOW(),
       merge_details = $merge_decisions_json
   WHERE id = duplicate_candidate_id;

   -- Audit log
   INSERT INTO audit_log (entity_type, entity_id, action, actor_type, actor_id, changes)
     VALUES ('patient', existing_patient_id, 'merge', 'staff', staff_id, $merge_details);

   COMMIT;
```

### Merge Constraints

- Both original records are preserved: the existing patient's version history captures the pre-merge state, and the `migration_records.source_data` preserves the Riverside original.
- Merged medications/allergies have `source = 'migrated_emr'` or `'migrated_paper'` to distinguish their origin.
- The merged patient record inherits `patient_confirmed = FALSE` if any field came from Riverside — the patient should verify on their next visit.

---

## Batch Processing

### Import Batches

Records are imported in batches of 100-500. Each batch:
1. Creates a `migration_batches` row
2. Processes records through the pipeline stages
3. Updates batch counters (imported, flagged, errors, duplicates)
4. Can be rolled back independently

### Rollback

```sql
-- Rollback a batch: soft-delete all records created by this batch
UPDATE patients SET deleted_at = NOW()
  WHERE migration_record_id IN (
    SELECT id FROM migration_records WHERE batch_id = $batch_id
  );

UPDATE allergies SET deleted_at = NOW()
  WHERE patient_id IN (
    SELECT patient_id FROM migration_records WHERE batch_id = $batch_id
  );
-- (Same for medications, insurance_records)

UPDATE migration_records SET status = 'rolled_back' WHERE batch_id = $batch_id;
UPDATE migration_batches SET status = 'rolled_back' WHERE id = $batch_id;

-- Rollback merges: restore from patient_record_versions
-- (This is more complex — see below)
```

**Merge rollback:** When a batch is rolled back and that batch included merged records:
1. Find all `duplicate_candidates` resolved as `'merged'` for this batch
2. For each: restore the existing patient from `patient_record_versions` (the pre-merge snapshot)
3. Delete the merged medications/allergies that came from the Riverside source
4. Update `duplicate_candidates.resolution` to NULL (back to pending)

This is the most complex part of rollback and should be tested thoroughly.

---

## Staff Review Interface

### Batch Review Flow

Staff can select multiple records from the migration dashboard and review them in sequence:

```
Staff selects 10 duplicate candidates → clicks "Review selected"
    │
    ▼
Duplicate Review Screen (first record)
    │
    ├── Staff decides: Merge / Keep separate / Flag
    │   │
    │   ▼
    │   Auto-advance to next record
    │   Progress: "3 of 10 reviewed"
    │
    └── Staff clicks "Exit batch review"
        Returns to migration dashboard
        Unreviewed records remain in the queue
```

### Review Prioritization

Records in the review queue are ordered:
1. High confidence (> 0.85) first — fastest to resolve, likely real duplicates
2. Then medium confidence (0.50 - 0.85) — need more careful review
3. Import errors last — require manual data correction

---

## Timeline Estimate

| Phase | Records | Estimated Duration |
|-------|---------|-------------------|
| EMR schema mapping + testing | — | 1 week |
| Electronic record import (2,000) | 2,000 | 1 day (pipeline) + 1 week (staff review of ~100-300 duplicates + errors) |
| Paper record scanning | 2,000 | 2 weeks (physical scanning process) |
| Paper record OCR processing | 2,000 | 1 day (batch OCR, ~3 hours processing + review queue) |
| Paper record staff review (low-confidence) | ~500-1,000 | 2-3 weeks (ongoing, parallel with normal operations) |
| Patient first-visit confirmation | Ongoing | N/A — happens when patients visit |

**Total:** ~6 weeks from start to electronic records fully resolved. Paper records trail for another 2-3 weeks. Some records will be confirmed on-demand at patient visits over the following months.
