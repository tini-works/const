# Environments — Rounds 1-10

Test environments must match production reality. When QA says "it works on staging," that must mean it will work in production.

---

## Environment Inventory

| Environment | Purpose | Parity with Prod | Data |
|-------------|---------|-------------------|------|
| **local** | Developer workstation | Low | Fixtures, <100 patients |
| **ci** | Automated tests on every commit | Medium | Seeded per test run, ephemeral |
| **staging** | Pre-production verification. E2E tests. Manual QA | High | Anonymized production snapshot, refreshed weekly |
| **production** | Live | - | Real |
| **import-staging** | **S-10.** Isolated import testing. Validate Riverside data before production import | High | Copy of production + Riverside source data |

---

## Parity Matrix

| Dimension | Local | CI | Staging | Import-Staging | Production |
|-----------|-------|----|---------|----------------|------------|
| Service versions | Current branch | Current branch | Same as prod deploy candidate | Same as staging | Deployed |
| Service count | All 7 (single instance) | All 7 (single instance) | All 7 (production replica counts) | Patient, Search, Migration only | Production |
| PostgreSQL version | Same major | Same major | Same major.minor | Same major.minor | Baseline |
| PostgreSQL replica | No | No | Yes (S-09) | No | Yes |
| Elasticsearch version | Same major | Same major | Same major.minor | Same major.minor | Baseline |
| Redis version | Same major | Same major | Same major.minor | Same major.minor | Baseline |
| DB schema | Current migrations | Current migrations | Same as prod + pending | Same as prod + import tables | Baseline |
| Network topology | All local | All local | Matches prod (gateway -> services -> data) | Simplified | Baseline |
| TLS | No | No | Yes (self-signed OK) | Yes (self-signed OK) | Yes (CA-signed) |
| Auth | Mocked tokens OK | Mocked tokens OK | Real auth, test accounts | Real auth, admin only | Real |
| Event bus | In-process (unit) | Redis (real) | Redis (real) | Redis (real) | Baseline |
| WebSocket | Real | Real | Real | N/A (no WebSocket needed) | Baseline |
| Rate limiting | Disabled | Disabled | Enabled (same rules) | Disabled (import throttling only) | Baseline |
| Encryption at rest | No | No | Yes | Yes | Yes |
| Session TTLs | Shortened (5m/1m) | Shortened | **Same as prod** (30m/5m) | N/A | 30m / 5m |
| Data categories / freshness | Same config | Same config | Same config | Same config | Baseline |
| Search index | Real ES | Real ES | Real ES, same mapping | Real ES, same mapping | Baseline |
| **Object Storage (S-08)** | Local filesystem mock | MinIO (S3-compat) | Real S3 (test bucket) | Real S3 (test bucket) | Real S3 (PHI bucket) |
| **OCR API (S-08)** | Mock (returns canned responses) | Mock | Real OCR API (test images) | N/A | Real |
| **SMS/Email (S-03)** | Console output | Console output | Real (test phone/email) | N/A | Real |
| **HPA (S-09)** | Disabled | Disabled | Enabled (same thresholds) | Disabled | Enabled |
| **Cache layer (S-09)** | Redis DB 1 | Redis DB 1 | Redis DB 1 (same config) | N/A | Redis DB 1 |

### Critical Parity Rules

1. **Session TTLs on staging must match production.** If staging uses shorter TTLs, timeout flow testing is invalid.

2. **Event bus must be real Redis Streams on CI and staging.** In-process event bus hides delivery failures, ordering issues, and consumer lag.

3. **Concurrent check-in prevention requires the real PostgreSQL partial index.** The unique constraint must be present on CI and staging.

4. **Elasticsearch mapping and analyzer config must be identical on staging.** Fuzzy search results depend on the analyzer.

5. **Object Storage on staging must use real S3 (test bucket).** Signed URL generation, encryption, and lifecycle policies must be validated against real S3 behavior. Local filesystem mocks hide IAM, encryption, and network-related failures.

6. **HPA must be enabled on staging (S-09).** Peak load testing is meaningless without autoscaling behavior matching production.

7. **Cache layer must use same Redis config on staging (S-09).** TTLs, maxmemory, eviction policy must match.

8. **Import-staging must have production-scale patient data (S-10).** Dedup accuracy depends on having a realistic patient set to match against. Testing dedup against 100 patients proves nothing about 10,000.

---

## Staging Data Requirements

### Data Volume

| Table | Staging Target | Why |
|-------|---------------|-----|
| patients | 10,000 | Search performance at scale |
| patient_data | 40,000 (4 categories x 10K) | Staleness computation. **S-06: medications added as 4th category** |
| visits | 50,000 (avg 5 visits per patient) | "Last visit" display and sorting |
| checkin_sessions | 1,000 (mix of all statuses) | Active session lookup, concurrent prevention |
| **locations** | **3 (Main, Riverside office, test location)** | **S-05: multi-location parity** |
| **pre_checkin_links** | **500** | **S-03: link generation and verification testing** |
| **document_uploads** | **200** | **S-08: OCR pipeline testing** |
| **import_batches** | **3 (one per source type)** | **S-10: import dashboard testing** |
| **import_records** | **4,000 (Riverside-scale)** | **S-10: dedup algorithm testing at production scale** |

### Data Shape

| Scenario | Count | Purpose |
|----------|-------|---------|
| Patients with all 4 categories filled | 6,000 | Flow 4/5 (confirm). S-06: includes medications |
| Patients with 1-3 categories missing | 2,000 | Flow 6 (fill missing), BOX-D3 |
| Patients with stale insurance (>180 days) | 3,000 | Staleness flag testing |
| Patients with stale address (>365 days) | 1,500 | Staleness flag testing |
| **Patients with stale medications (always, S-06)** | **10,000** | **All patients have stale medications (freshness_days=0)** |
| Patients with similar names (for fuzzy) | 500 pairs | Flow 2 (assisted search, Levenshtein) |
| Patients with merge_flag set | 200 | Recognition failure path |
| Patients with active check-in sessions | 50 | BOX-E5, S2 blocked state |
| **Patients with multi-location visits (S-05)** | **3,000** | **Cross-location search, visit history** |
| **Patients with source_system="riverside_ehr" (S-10)** | **2,000** | **Import badge display, provenance** |
| **Patients with source_system="riverside_paper" (S-10)** | **500** | **Paper import testing** |
| **Patients with document_uploads (S-08)** | **200** | **Insurance card image viewing** |
| **Patients with confirmed_empty medications (S-06)** | **500** | **"No medications" confirmation path** |

### Data Anonymization Rules

Staging data is derived from production. Before loading:

| Field | Anonymization |
|-------|--------------|
| first_name, last_name | Faker-generated. Preserve name length distribution |
| dob | Shift by random offset (1-365 days). Preserve age distribution |
| phone | Randomized. Preserve format |
| email | `patient_{id}@test.example.com` |
| address | Faker-generated US addresses |
| insurance policy_number | Randomized. Preserve format |
| allergies | Keep real allergy names (not PII). Randomize severity/reaction |
| **medications (S-06)** | **Keep real drug names (not PII). Randomize dosage/prescriber** |
| photo_url | Set to null |
| access_token (hashed) | Regenerated |
| **card_image storage keys (S-08)** | **Point to test bucket. Use synthetic card images** |
| **source_id (S-10)** | **Preserve format, randomize values** |

**Refresh cycle:** Weekly. Automated script pulls production patient count distribution, generates anonymized data, loads into staging.

### Import-Staging Data (S-10)

| Data Source | Records | Purpose |
|-------------|---------|---------|
| Simulated Riverside EHR export (CSV) | 3,200 | Tests EHR import pipeline end-to-end |
| Simulated paper record entries | 800 | Tests manual entry pipeline |
| Existing patients (production-scale copy) | 10,000 | Tests dedup accuracy against real-scale data |
| Known duplicates (planted) | 200 pairs | Validates dedup algorithm precision |
| Known non-duplicates with similar names | 100 pairs | Validates dedup algorithm recall |

---

## Environment-Specific Configuration

| Config Key | Local | CI | Staging | Import-Staging | Production |
|------------|-------|----|---------|----------------|------------|
| `SESSION_HARD_TTL_MIN` | 5 | 5 | 30 | N/A | 30 |
| `SESSION_INACTIVITY_TTL_MIN` | 1 | 1 | 5 | N/A | 5 |
| `SEARCH_DEBOUNCE_MS` | 300 | 0 | 300 | 300 | 300 |
| `SEARCH_INDEX_MAX_LAG_SEC` | 10 | 5 | 2 | 5 | 2 |
| `RATE_LIMIT_SEARCH_PER_SEC` | 0 | 0 | 10 | 0 | 10 |
| `CHECKIN_ARCHIVE_AFTER_HOURS` | 1 | 1 | 24 | N/A | 24 |
| `CHECKIN_PURGE_AFTER_DAYS` | 1 | 1 | 90 | N/A | 90 |
| `AUDIT_LOG_RETENTION_DAYS` | 7 | 1 | 365 | 365 | 2555 (7 years, BOX-15) |
| `DB_POOL_SIZE_PRIMARY` | 5 | 10 | 50 | 20 | 50 |
| `DB_POOL_SIZE_REPLICA` | 0 | 0 | 20 | 0 | 20 |
| `WS_MAX_CONNECTIONS` | 100 | 100 | 200 | N/A | 200 |
| `TOKEN_LENGTH` | 64 | 64 | 64 | 64 | 64 |
| `FRESHNESS_ADDRESS_DAYS` | 365 | 365 | 365 | 365 | 365 |
| `FRESHNESS_INSURANCE_DAYS` | 180 | 180 | 180 | 180 | 180 |
| `FRESHNESS_ALLERGIES_DAYS` | null | null | null | null | null |
| **`FRESHNESS_MEDICATIONS_DAYS`** | **0** | **0** | **0** | **0** | **0** |
| **`CACHE_PATIENT_SUMMARY_TTL_SEC`** | **300** | **300** | **300** | **N/A** | **300** |
| **`CACHE_DATA_CATEGORIES_TTL_SEC`** | **3600** | **3600** | **3600** | **N/A** | **3600** |
| **`IMPORT_RATE_LIMIT_PER_SEC`** | **100** | **100** | **10** | **10** | **10** |
| **`IMPORT_PAUSE_DURING_PEAK`** | **false** | **false** | **true** | **false** | **true** |
| **`IMPORT_PEAK_HOURS_START`** | **N/A** | **N/A** | **08:00** | **N/A** | **08:00** |
| **`IMPORT_PEAK_HOURS_END`** | **N/A** | **N/A** | **10:00** | **N/A** | **10:00** |
| **`OCR_API_TIMEOUT_SEC`** | **1** | **1** | **10** | **N/A** | **10** |
| **`OCR_MANUAL_FALLBACK_SEC`** | **2** | **2** | **10** | **N/A** | **10** |
| **`PHOTO_UPLOAD_MAX_SIZE_MB`** | **10** | **10** | **10** | **N/A** | **10** |
| **`PRECHECKIN_LINK_WINDOW_HOURS`** | **1** | **1** | **24** | **N/A** | **24** |
| **`HPA_CHECKIN_MIN_REPLICAS`** | **1** | **1** | **2** | **N/A** | **2** |
| **`HPA_CHECKIN_MAX_REPLICAS`** | **1** | **1** | **4** | **N/A** | **4** |
| **`HPA_WS_MIN_REPLICAS`** | **1** | **1** | **2** | **N/A** | **2** |
| **`HPA_WS_MAX_REPLICAS`** | **1** | **1** | **4** | **N/A** | **4** |

---

## Environment Drift Detection

Environments drift. Config changes in production that aren't reflected in staging. Schema changes applied manually. Elasticsearch mapping divergence.

### Automated Checks (weekly)

| Check | How | Alert if |
|-------|-----|----------|
| Schema drift | Compare `pg_dump --schema-only` between staging and prod | Any difference in table definitions |
| ES mapping drift | Compare `GET /patients/_mapping` between staging and prod | Any difference |
| Config drift | Compare environment variable values (excluding secrets) | Any difference in the parity-critical set |
| Redis config drift | Compare `CONFIG GET *` output | Differences in maxmemory, maxmemory-policy |
| Service version drift | Compare running image tags staging vs. prod | Staging is not on the prod candidate version |
| **Object Storage policy drift (S-08)** | Compare bucket policies, lifecycle rules, encryption config | Any difference |
| **HPA config drift (S-09)** | Compare HPA specs between staging and prod | Any difference in min/max replicas or thresholds |
| **Location config drift (S-05)** | Compare `locations` table content staging vs. prod | Staging missing locations that exist in prod |

### Import-Staging Specific

| Check | How | Alert if |
|-------|-----|----------|
| Patient count parity | Compare patient count between import-staging and production | Import-staging has <90% of production patient count (dedup testing unreliable) |
| Schema parity | Compare schema between import-staging and production | Any difference (import runs against wrong schema) |
