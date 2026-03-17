# Data Model — Clinic Check-In System

All tables use PostgreSQL. Timestamps are UTC. UUIDs for primary keys. Soft deletes where audit trail matters.

---

## Entity Relationship Overview

```
locations 1──┬──N appointments
              │
              ├──N kiosks
              │
              └──N staff_locations (M:N with staff)

patients 1──┬──N appointments
             │
             ├──N allergies
             │
             ├──N medications
             │
             ├──N insurance_records
             │
             ├──N check_ins
             │
             ├──N medication_confirmations
             │
             └──N patient_record_versions (audit)

appointments 1──N check_ins

migration_batches 1──N migration_records
                        │
                        └──N duplicate_candidates
```

---

## Core Tables

### patients

The central entity. One record per patient across all locations (centralized model per DEC-005).

```sql
CREATE TABLE patients (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    version         INTEGER NOT NULL DEFAULT 1,  -- optimistic locking (ADR-003)
    first_name      VARCHAR(100) NOT NULL,
    last_name       VARCHAR(100) NOT NULL,
    middle_name     VARCHAR(100),
    date_of_birth   DATE NOT NULL,
    phone           VARCHAR(20),
    email           VARCHAR(255),
    address_line1   VARCHAR(255),
    address_line2   VARCHAR(255),
    city            VARCHAR(100),
    state           VARCHAR(2),
    zip_code        VARCHAR(10),
    ssn_last4       VARCHAR(4),              -- stored hashed, used for dedup matching only
    card_id         VARCHAR(100) UNIQUE,     -- kiosk scan card identifier

    -- Migration tracking (Round 10)
    migration_source    VARCHAR(50),         -- e.g., 'riverside_emr', 'riverside_paper'
    migration_record_id UUID REFERENCES migration_records(id),
    patient_confirmed   BOOLEAN DEFAULT TRUE, -- FALSE for migrated records until first visit
    data_confidence     JSONB,               -- per-field confidence scores from OCR/migration

    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ              -- soft delete
);

-- Indexes for search performance (Round 9)
CREATE INDEX idx_patients_last_first ON patients (last_name, first_name);
CREATE INDEX idx_patients_dob ON patients (date_of_birth);
CREATE INDEX idx_patients_phone ON patients (phone);
CREATE INDEX idx_patients_card_id ON patients (card_id);

-- Trigram index for fuzzy name search
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX idx_patients_name_trgm ON patients
    USING gin ((last_name || ' ' || first_name) gin_trgm_ops);
```

**Version field:** Every update to a patient record increments `version`. On save, the API checks `WHERE id = $id AND version = $expected_version`. If no rows are updated, a conflict is detected. See ADR-003.

---

### locations

Added in Round 5 (multi-location).

```sql
CREATE TABLE locations (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        VARCHAR(255) NOT NULL,       -- "Main Street Clinic"
    address     VARCHAR(500),
    phone       VARCHAR(20),
    is_active   BOOLEAN NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

---

### kiosks

Each kiosk is bound to a location.

```sql
CREATE TABLE kiosks (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    location_id UUID NOT NULL REFERENCES locations(id),
    name        VARCHAR(100),                -- "Kiosk 1", "Kiosk 2"
    is_active   BOOLEAN NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

---

### staff

```sql
CREATE TABLE staff (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(255) NOT NULL,
    email           VARCHAR(255) UNIQUE NOT NULL,
    role            VARCHAR(50) NOT NULL,    -- 'receptionist', 'admin'
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE staff_locations (
    staff_id        UUID NOT NULL REFERENCES staff(id),
    location_id     UUID NOT NULL REFERENCES locations(id),
    is_default      BOOLEAN NOT NULL DEFAULT FALSE,  -- staff's home location
    PRIMARY KEY (staff_id, location_id)
);
```

---

### appointments

Appointments are location-specific.

```sql
CREATE TABLE appointments (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id      UUID NOT NULL REFERENCES patients(id),
    location_id     UUID NOT NULL REFERENCES locations(id),
    appointment_time TIMESTAMPTZ NOT NULL,
    status          VARCHAR(20) NOT NULL DEFAULT 'scheduled',
        -- 'scheduled', 'checked_in', 'in_progress', 'completed', 'cancelled'
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_appointments_patient ON appointments (patient_id);
CREATE INDEX idx_appointments_location_date ON appointments (location_id, appointment_time);
```

---

### check_ins

Tracks each check-in event. One per appointment per channel.

```sql
CREATE TABLE check_ins (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    appointment_id  UUID NOT NULL REFERENCES appointments(id),
    patient_id      UUID NOT NULL REFERENCES patients(id),
    location_id     UUID NOT NULL REFERENCES locations(id),
    kiosk_id        UUID REFERENCES kiosks(id),          -- NULL for mobile/walk-in

    channel         VARCHAR(20) NOT NULL,
        -- 'kiosk', 'mobile', 'walk_in'
    status          VARCHAR(20) NOT NULL DEFAULT 'in_progress',
        -- 'in_progress', 'completed', 'failed', 'syncing'
    current_step    INTEGER DEFAULT 1,                    -- 1-5 for progress tracking
    sync_status     VARCHAR(20) DEFAULT 'pending',
        -- 'pending', 'confirmed', 'failed'

    -- Mobile check-in specific
    mobile_token        VARCHAR(255) UNIQUE,              -- tokenized link identifier
    mobile_token_expires TIMESTAMPTZ,
    identity_verified   BOOLEAN DEFAULT FALSE,

    started_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at    TIMESTAMPTZ,
    synced_at       TIMESTAMPTZ                           -- when receptionist dashboard acked
);

CREATE INDEX idx_checkins_appointment ON check_ins (appointment_id);
CREATE INDEX idx_checkins_patient_date ON check_ins (patient_id, started_at);
```

---

## Clinical Data Tables

### allergies

```sql
CREATE TABLE allergies (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id      UUID NOT NULL REFERENCES patients(id),
    name            VARCHAR(255) NOT NULL,
    reaction_type   VARCHAR(100),            -- 'rash', 'anaphylaxis', 'hives', etc.
    severity        VARCHAR(20),             -- 'mild', 'moderate', 'severe'
    source          VARCHAR(50) DEFAULT 'patient_reported',
        -- 'patient_reported', 'migrated_emr', 'migrated_paper'
    data_confidence REAL,                    -- 0.0-1.0, from OCR/migration
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ              -- soft delete (preserves audit trail)
);

CREATE INDEX idx_allergies_patient ON allergies (patient_id);
```

---

### medications

Added medication tracking in Round 6 for compliance.

```sql
CREATE TABLE medications (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id      UUID NOT NULL REFERENCES patients(id),
    name            VARCHAR(255) NOT NULL,
    dosage          VARCHAR(100),
    frequency       VARCHAR(50),
        -- 'once_daily', 'twice_daily', 'three_times_daily', 'as_needed', 'other'
    source          VARCHAR(50) DEFAULT 'patient_reported',
        -- 'patient_reported', 'his_import', 'migrated_emr', 'migrated_paper'
    his_medication_id VARCHAR(100),          -- reference to HIS medication module (Round 6)
    data_confidence REAL,                    -- 0.0-1.0, from OCR/migration
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ              -- soft delete
);

CREATE INDEX idx_medications_patient ON medications (patient_id);
```

---

### medication_confirmations

Immutable audit records. Required for state health board compliance (Round 6). Never updated or deleted.

```sql
CREATE TABLE medication_confirmations (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id      UUID NOT NULL REFERENCES patients(id),
    check_in_id     UUID NOT NULL REFERENCES check_ins(id),
    confirmation_type VARCHAR(30) NOT NULL,
        -- 'confirmed_unchanged', 'modified', 'confirmed_none'
    medication_snapshot JSONB NOT NULL,       -- frozen copy of the medication list at confirmation time
    confirmed_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    channel         VARCHAR(20) NOT NULL      -- 'kiosk', 'mobile', 'walk_in'
);

CREATE INDEX idx_med_confirmations_patient ON medication_confirmations (patient_id, confirmed_at);
```

**Why a snapshot?** The `medications` table can change between visits. The audit record needs to capture exactly what the patient confirmed at that moment, not a reference to a mutable table. The `medication_snapshot` field stores a JSON array of `{name, dosage, frequency}` objects as they appeared at confirmation time.

---

### insurance_records

```sql
CREATE TABLE insurance_records (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id      UUID NOT NULL REFERENCES patients(id),
    type            VARCHAR(20) NOT NULL DEFAULT 'primary',
        -- 'primary', 'secondary'
    payer_name      VARCHAR(255),
    member_id       VARCHAR(100),
    group_number    VARCHAR(100),
    plan_type       VARCHAR(100),
    effective_date  DATE,

    -- Photo capture (Round 8)
    card_front_url  VARCHAR(500),            -- S3 key for front image
    card_back_url   VARCHAR(500),            -- S3 key for back image
    ocr_extracted   BOOLEAN DEFAULT FALSE,   -- whether fields came from OCR
    ocr_confidence  JSONB,                   -- per-field confidence: {"member_id": 0.95, "group_number": 0.72}

    -- Migration tracking
    source          VARCHAR(50) DEFAULT 'patient_entered',
        -- 'patient_entered', 'ocr', 'migrated_emr', 'migrated_paper'
    data_confidence REAL,

    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMPTZ
);

CREATE INDEX idx_insurance_patient ON insurance_records (patient_id);
```

---

## Audit & Tracking Tables

### audit_log

All PHI access and modifications.

```sql
CREATE TABLE audit_log (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_type     VARCHAR(50) NOT NULL,    -- 'patient', 'medication', 'insurance', etc.
    entity_id       UUID NOT NULL,
    action          VARCHAR(20) NOT NULL,    -- 'read', 'create', 'update', 'delete', 'merge'
    actor_type      VARCHAR(20) NOT NULL,    -- 'patient', 'staff', 'system'
    actor_id        UUID,                    -- staff.id or NULL for patient/system actions
    changes         JSONB,                   -- {field: {old: x, new: y}} for updates
    metadata        JSONB,                   -- additional context (IP, kiosk_id, session info)
    location_id     UUID REFERENCES locations(id),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_audit_entity ON audit_log (entity_type, entity_id);
CREATE INDEX idx_audit_actor ON audit_log (actor_type, actor_id);
CREATE INDEX idx_audit_time ON audit_log (created_at);
```

---

### patient_record_versions

Stores full snapshots on each version change. Supports conflict resolution display ("what changed") and rollback.

```sql
CREATE TABLE patient_record_versions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id      UUID NOT NULL REFERENCES patients(id),
    version         INTEGER NOT NULL,
    snapshot         JSONB NOT NULL,          -- full patient record at this version
    changed_by_type VARCHAR(20) NOT NULL,    -- 'patient', 'staff', 'system', 'migration'
    changed_by_id   UUID,
    change_summary  JSONB,                   -- {field: {old: x, new: y}}
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_patient_versions ON patient_record_versions (patient_id, version);
```

---

## Migration Tables (Round 10)

### migration_batches

Top-level container for a migration run.

```sql
CREATE TABLE migration_batches (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(255) NOT NULL,   -- "Riverside EMR Import - Batch 1"
    source_system   VARCHAR(100) NOT NULL,   -- "riverside_emr", "riverside_paper"
    status          VARCHAR(30) NOT NULL DEFAULT 'pending',
        -- 'pending', 'in_progress', 'completed', 'completed_with_errors', 'rolled_back'
    total_records   INTEGER DEFAULT 0,
    imported_count  INTEGER DEFAULT 0,
    flagged_count   INTEGER DEFAULT 0,
    error_count     INTEGER DEFAULT 0,
    duplicate_count INTEGER DEFAULT 0,
    started_at      TIMESTAMPTZ,
    completed_at    TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### migration_records

One row per imported record.

```sql
CREATE TABLE migration_records (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    batch_id        UUID NOT NULL REFERENCES migration_batches(id),
    source_id       VARCHAR(255),            -- ID in the source system
    source_data     JSONB NOT NULL,          -- raw data from source
    mapped_data     JSONB,                   -- data after schema mapping
    status          VARCHAR(30) NOT NULL DEFAULT 'pending',
        -- 'pending', 'imported', 'needs_review', 'potential_duplicate',
        -- 'duplicate_resolved', 'import_error', 'paper_pending',
        -- 'paper_ocr_complete', 'rolled_back'
    patient_id      UUID REFERENCES patients(id),  -- set after successful import/merge
    validation_errors JSONB,                 -- [{field: "phone", error: "missing"}]
    ocr_confidence  JSONB,                   -- per-field confidence for paper records
    scanned_document_url VARCHAR(500),       -- S3 key for scanned paper record
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_migration_records_batch ON migration_records (batch_id);
CREATE INDEX idx_migration_records_status ON migration_records (status);
```

### duplicate_candidates

Potential matches found during migration.

```sql
CREATE TABLE duplicate_candidates (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    migration_record_id UUID NOT NULL REFERENCES migration_records(id),
    existing_patient_id UUID NOT NULL REFERENCES patients(id),
    confidence_score    REAL NOT NULL,        -- 0.0 to 1.0
    match_reasons       JSONB NOT NULL,       -- ["name_dob_match", "phone_match", "ssn_match"]
    resolution          VARCHAR(20),
        -- NULL (pending), 'merged', 'kept_separate', 'flagged'
    resolved_by         UUID REFERENCES staff(id),
    resolved_at         TIMESTAMPTZ,
    merge_details       JSONB,               -- {field: "kept_ours"|"kept_theirs"|"edited", ...}
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_dupes_migration ON duplicate_candidates (migration_record_id);
CREATE INDEX idx_dupes_resolution ON duplicate_candidates (resolution);
```

---

## Schema Evolution by Round

| Round | Changes |
|-------|---------|
| 1 | `patients`, `appointments`, `check_ins`, `allergies`, `insurance_records`, `audit_log` |
| 2 | Added `sync_status`, `synced_at` to `check_ins`. Added WebSocket infrastructure. |
| 3 | Added `mobile_token`, `mobile_token_expires`, `identity_verified`, `current_step` to `check_ins`. Added `channel` field. |
| 4 | No schema changes. Security fix is in application layer (session purge). |
| 5 | Added `locations`, `kiosks`, `staff_locations`. Added `location_id` to `appointments`, `check_ins`. |
| 6 | Added `medications`, `medication_confirmations`. Added `his_medication_id` and `source` to medications. |
| 7 | Added `version` to `patients`. Added `patient_record_versions` table. |
| 8 | Added `card_front_url`, `card_back_url`, `ocr_extracted`, `ocr_confidence` to `insurance_records`. Object storage setup. |
| 9 | Added indexes (trigram, composite). Connection pooling. Read replica. Caching layer. No schema changes. |
| 10 | Added `migration_batches`, `migration_records`, `duplicate_candidates`. Added migration fields to `patients`. Added `source`, `data_confidence` to clinical tables. |
