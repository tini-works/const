# Runbook: Migration Import Failure (Riverside Data Import)

**Severity:** P2 (does not affect live check-in operations)
**Impact:** Riverside patient records are not imported, staff review queue stalls, migration timeline slips.
**Last tested:** 2026-03-17 — Ran Type 1 (schema mapping) and Type 4 (transaction failure) against test batch in staging.
**Last triggered:** Never in production. Riverside migration has not started yet.

### Traceability

| Link | Reference |
|------|-----------|
| **Triggered by:** | Alert: [Migration Import Errors > 5%](./monitoring-alerting.md#p2----investigate-during-next-business-day), Alert: [OCR Service Slow](./monitoring-alerting.md#p2----investigate-during-next-business-day) |
| **Caused by:** | No single bug — operational runbook for the [Riverside migration pipeline](../architecture/adrs.md#adr-010-migration-pipeline-architecture--batch-import-with-rollback) |
| **Fixed by:** | [ADR-010: Migration Pipeline (batch import with rollback)](../architecture/adrs.md#adr-010-migration-pipeline-architecture--batch-import-with-rollback), [ADR-008: Duplicate Detection Algorithm](../architecture/adrs.md#adr-008-duplicate-detection-algorithm-for-riverside-migration), [ADR-006: OCR Service](../architecture/adrs.md#adr-006-ocr-service-as-a-separate-service-behind-a-stable-api-contract) |
| **Watches:** | [Migration Service](../architecture/architecture.md#migration-service-round-10), [OCR Service](../architecture/architecture.md#ocr-service-round-8), [Migration API endpoints](../architecture/api-spec.md#9-migration-round-10) |
| **Proves:** | [US-012: Patient data migration](../product/user-stories.md#us-012-patient-data-migration-from-riverside), [US-013: Duplicate detection and merge](../product/user-stories.md#us-013-duplicate-patient-detection-and-merge) |
| **Detects:** | [TC-1001: Valid import](../quality/test-suites.md#tc-1001-emr-import--valid-records), [TC-1002: Validation failures](../quality/test-suites.md#tc-1002-emr-import--validation-failures), [TC-1003: Duplicate detection](../quality/test-suites.md#tc-1003-duplicate-detection--exact-match), [TC-1007: Rollback](../quality/test-suites.md#tc-1007-migration-rollback), [TC-1009: OCR pipeline](../quality/test-suites.md#tc-1009-paper-record-ocr-pipeline) failing in production |

---

## Detection

How you'll know:
- Alert: `migration_import_errors / migration_records_processed > 5%` for an active batch
- Alert: `migration_batch_duration_seconds` exceeds expected time (> 2 hours for 500 records)
- Staff report: "The migration dashboard shows a lot of errors"
- Batch status stuck at `in_progress` for > 4 hours

---

## Understanding the Pipeline

```
Source Data → Schema Mapping → Validation → Dedup → Import → Staff Review
```

Failures can happen at any stage. Each stage has different symptoms and fixes.

---

## Diagnosis

### Step 1: Check Batch Status

```bash
# Get batch overview
psql $DB_REPLICA_URL -c "
  SELECT id, name, status, total_records,
         imported_count, flagged_count, error_count, duplicate_count,
         started_at, completed_at,
         EXTRACT(EPOCH FROM (COALESCE(completed_at, NOW()) - started_at)) / 60 AS duration_minutes
  FROM migration_batches
  WHERE status IN ('in_progress', 'completed_with_errors')
  ORDER BY created_at DESC
  LIMIT 5;
"
```

### Step 2: Check Error Distribution

```bash
# What's failing and why?
psql $DB_REPLICA_URL -c "
  SELECT status, COUNT(*) AS count
  FROM migration_records
  WHERE batch_id = '<batch_uuid>'
  GROUP BY status
  ORDER BY count DESC;
"

# Get specific error details
psql $DB_REPLICA_URL -c "
  SELECT source_id, status, validation_errors, created_at
  FROM migration_records
  WHERE batch_id = '<batch_uuid>'
    AND status = 'import_error'
  ORDER BY created_at
  LIMIT 20;
"
```

---

## Response by Failure Type

### Type 1: Schema Mapping Errors

**Symptoms:** `validation_errors` shows fields like `{"dob": "unparseable date format"}` or `{"phone": "missing"}`.

**Root cause:** Riverside EMR data doesn't match expected format. Common issues:
- Date format variations (MM/DD/YYYY vs. YYYY-MM-DD vs. M/D/YY)
- Phone numbers with international prefix or extensions
- Missing required fields (name, DOB)
- Character encoding issues (accented names)

```bash
# Examine the raw source data for failed records
psql $DB_REPLICA_URL -c "
  SELECT source_id, source_data, validation_errors
  FROM migration_records
  WHERE batch_id = '<batch_uuid>'
    AND status = 'import_error'
    AND validation_errors IS NOT NULL
  LIMIT 10;
"

# Check the most common validation error types
psql $DB_REPLICA_URL -c "
  SELECT
    jsonb_object_keys(validation_errors) AS error_field,
    COUNT(*) AS occurrences
  FROM migration_records,
    LATERAL jsonb_each(validation_errors) AS kv
  WHERE batch_id = '<batch_uuid>'
    AND status = 'import_error'
  GROUP BY error_field
  ORDER BY occurrences DESC;
"
```

**Fix:**

If the error is systemic (same mapping failure for many records):

1. Fix the schema mapper code to handle the new format
2. Re-run validation on failed records:

```bash
# Reset failed records to pending so they're reprocessed
psql $DB_PRIMARY_URL -c "
  UPDATE migration_records
  SET status = 'pending', validation_errors = NULL, updated_at = NOW()
  WHERE batch_id = '<batch_uuid>'
    AND status = 'import_error'
    AND validation_errors::text LIKE '%<specific_error>%';
"

# Re-trigger the pipeline for this batch
curl -X POST https://api.clinic-checkin.example.com/v1/migration/batches/<batch_uuid>/reprocess
```

If the error is per-record (bad data in source): these go to the staff review queue for manual correction.

### Type 2: OCR Extraction Failures (Paper Records)

**Symptoms:** Records from `riverside_paper` source have `status = 'paper_pending'` or `ocr_confidence` with very low scores.

```bash
# Check OCR results
psql $DB_REPLICA_URL -c "
  SELECT source_id, status, ocr_confidence, scanned_document_url
  FROM migration_records
  WHERE batch_id = '<batch_uuid>'
    AND source_data->>'source_type' = 'paper'
    AND (status = 'import_error' OR status = 'paper_pending')
  LIMIT 20;
"

# Check OCR Service health
curl -s https://api.clinic-checkin.example.com/ocr/health | jq .

# Check OCR Service logs for errors
# In Loki:
{service="ocr-service"} | json | level="error" | last 2 hours
```

**Common OCR issues:**

| Issue | Diagnosis | Fix |
|-------|-----------|-----|
| Google Vision API quota exceeded | Check GCP console for quota limits | Wait for quota reset or request increase |
| Google Vision API credentials expired | OCR health check returns auth error | Rotate credentials in Secrets Manager, redeploy OCR Service |
| Image quality too low | `ocr_confidence` all < 0.3 | These records need manual data entry by staff |
| PDF format unsupported | OCR returns empty results | Convert PDF to images first, then re-run OCR |
| S3 access error | OCR can't download images | Check S3 bucket policy and IAM permissions |

```bash
# Re-queue failed OCR jobs
psql $DB_PRIMARY_URL -c "
  UPDATE migration_records
  SET status = 'paper_pending', updated_at = NOW()
  WHERE batch_id = '<batch_uuid>'
    AND status = 'import_error'
    AND scanned_document_url IS NOT NULL;
"
```

### Type 3: Duplicate Detection Failures

**Symptoms:** The dedup stage runs but produces unexpected results (too many false positives, or known duplicates not detected).

```bash
# Check duplicate detection results
psql $DB_REPLICA_URL -c "
  SELECT dc.confidence_score, dc.match_reasons,
         mr.source_id, mr.mapped_data->>'first_name' AS riverside_name,
         p.first_name AS our_name, p.last_name AS our_last_name
  FROM duplicate_candidates dc
  JOIN migration_records mr ON mr.id = dc.migration_record_id
  JOIN patients p ON p.id = dc.existing_patient_id
  WHERE mr.batch_id = '<batch_uuid>'
  ORDER BY dc.confidence_score DESC
  LIMIT 20;
"

# Check for false negatives: records that were imported as new
# but might actually be duplicates
psql $DB_REPLICA_URL -c "
  SELECT mr.source_id,
         mr.mapped_data->>'first_name' AS first_name,
         mr.mapped_data->>'last_name' AS last_name,
         mr.mapped_data->>'date_of_birth' AS dob
  FROM migration_records mr
  WHERE mr.batch_id = '<batch_uuid>'
    AND mr.status = 'imported'
  ORDER BY mr.source_id
  LIMIT 50;
"

# Cross-reference manually: are any of these already in our system?
psql $DB_REPLICA_URL -c "
  SELECT p.id, p.first_name, p.last_name, p.date_of_birth
  FROM patients p
  WHERE p.date_of_birth = '1982-03-15'
    AND p.last_name ILIKE 'johnson%'
    AND p.deleted_at IS NULL
    AND p.migration_source IS NULL;
"
```

**Fix (false positives):** These are handled correctly by staff review -- they choose "Keep separate" and the records remain independent. If the false positive rate is very high (> 10% of flagged records), consider raising the dedup threshold from 0.40 to 0.45.

**Fix (false negatives):** More concerning. If real duplicates were imported as new patients:

```bash
# Identify potential missed duplicates post-import
# Look for patients with same last_name + DOB where one has migration_source set
psql $DB_REPLICA_URL -c "
  SELECT p1.id AS existing_id, p1.first_name, p1.last_name, p1.date_of_birth,
         p2.id AS imported_id, p2.first_name AS imported_first
  FROM patients p1
  JOIN patients p2 ON p1.date_of_birth = p2.date_of_birth
    AND LOWER(p1.last_name) = LOWER(p2.last_name)
    AND p1.id != p2.id
  WHERE p2.migration_source IS NOT NULL
    AND p1.migration_source IS NULL
    AND p2.deleted_at IS NULL
    AND p1.deleted_at IS NULL
  ORDER BY p1.last_name;
"
```

Flag these for staff review and create duplicate_candidate records manually if needed.

### Type 4: Import Transaction Failures

**Symptoms:** Records pass validation and dedup but fail during the actual import to the patients table.

```bash
# Check for database-level errors
psql $DB_REPLICA_URL -c "
  SELECT source_id, validation_errors, status
  FROM migration_records
  WHERE batch_id = '<batch_uuid>'
    AND status = 'import_error'
    AND validation_errors IS NULL
  LIMIT 20;
"

# Check Migration Service logs for SQL errors
{service="migration-service"} | json | level="error" | batch_id="<batch_uuid>"
```

**Common causes:**

| Cause | Fix |
|-------|-----|
| Unique constraint violation (card_id) | Source patient has same card_id as existing patient. Flag for manual review. |
| Foreign key violation | Location or batch reference doesn't exist. Check data integrity. |
| Connection timeout | PgBouncer pool exhausted (migration competing with live traffic). Schedule migration for off-hours. |
| Disk space | PostgreSQL storage full. Expand storage, clean up dead tuples. |

---

## Batch Rollback

If a batch import introduced bad data (systemic schema mapping bug, wrong data in wrong fields):

```bash
# 1. Check what the batch created
psql $DB_REPLICA_URL -c "
  SELECT status, COUNT(*) FROM migration_records
  WHERE batch_id = '<batch_uuid>'
  GROUP BY status;
"

# 2. Roll back the batch via API
curl -X POST https://api.clinic-checkin.example.com/v1/migration/batches/<batch_uuid>/rollback \
  -H "Authorization: Bearer $ADMIN_TOKEN" | jq .

# 3. Verify rollback
psql $DB_REPLICA_URL -c "
  SELECT status FROM migration_batches WHERE id = '<batch_uuid>';
"
# Should show 'rolled_back'

# 4. Verify patients were soft-deleted
psql $DB_REPLICA_URL -c "
  SELECT COUNT(*) FROM patients
  WHERE migration_record_id IN (
    SELECT id FROM migration_records WHERE batch_id = '<batch_uuid>'
  )
  AND deleted_at IS NOT NULL;
"
```

**WARNING:** Rollback of merged records is complex. If duplicates were resolved as "merged" before the rollback, the merge must be undone by restoring from `patient_record_versions`. The API handles this, but verify:

```bash
# Check that merged records were properly unmerged
psql $DB_REPLICA_URL -c "
  SELECT dc.id, dc.resolution, dc.existing_patient_id,
         p.version AS current_version
  FROM duplicate_candidates dc
  JOIN migration_records mr ON mr.id = dc.migration_record_id
  JOIN patients p ON p.id = dc.existing_patient_id
  WHERE mr.batch_id = '<batch_uuid>'
    AND dc.resolution = 'merged';
"
# After rollback, resolution should be NULL (back to pending)
# And the patient's version should match the pre-merge snapshot
```

---

## Preventing Import Failures

1. **Always run a dry-run first.** Import 10 records from a batch, review results, then import the rest.
2. **Schedule imports during off-hours** (after 6 PM or weekends) to avoid competing with live check-in traffic for DB connections.
3. **Monitor the batch during import.** Watch the Migration Dashboard for error rate spikes.
4. **Keep batch sizes reasonable.** 100-500 records per batch. Smaller batches = smaller rollback scope.
5. **Test schema mapping changes** against a sample of Riverside data before deploying to production.

---

## Staff Communication

If migration is delayed:

**To clinic admin:**
> **"The Riverside data import batch [X] encountered [Y] errors out of [Z] total records. [N] records imported successfully and are available in the system. The remaining [M] records need manual review. We're investigating the root cause of the errors and will re-process them once fixed. This does not affect current check-in operations."**
