# Test Plan — Clinic Check-In System

**QA Lead:** QA Team
**Last updated:** After Round 10
**System:** Clinic Check-In (Kiosk, Mobile Web, Receptionist Dashboard, Admin Panel)

**Traceability:** This plan references [user stories](../product/user-stories.md), [screen specs](../experience/screen-specs.md), [API spec](../architecture/api-spec.md), [ADRs](../architecture/adrs.md), and [monitoring/alerting](../operations/monitoring-alerting.md). Test cases are in [test-suites.md](test-suites.md). Coverage analysis is in [coverage-report.md](coverage-report.md). Bug history is in [bug-reports.md](bug-reports.md).

---

## 1. Scope

This plan covers all testing activities for the clinic check-in system across 10 rounds of development. It addresses:

- Core kiosk check-in flow (returning and new patients) — [US-001](../product/user-stories.md#us-001-pre-populated-check-in-for-returning-patients)
- Kiosk-to-receptionist sync ([BUG-001](bug-reports.md#bug-001-kiosk-confirmation-shows-green-checkmark-but-receptionist-sees-nothing) fix) — [US-002](../product/user-stories.md#us-002-receptionist-sees-confirmed-check-in-data), [ADR-001](../architecture/adrs.md#adr-001-websocket-with-polling-fallback-for-real-time-dashboard-updates)
- Session isolation / data leak prevention ([BUG-002](bug-reports.md#bug-002-previous-patients-data-briefly-visible-on-kiosk-after-card-scan) fix) — [US-003](../product/user-stories.md#us-003-secure-patient-identification-on-scan), [ADR-002](../architecture/adrs.md#adr-002-session-purge-protocol-for-kiosk-state-isolation)
- Concurrent edit safety ([BUG-003](bug-reports.md#bug-003-concurrent-edit-by-two-receptionists-causes-silent-data-loss) fix) — [US-004](../product/user-stories.md#us-004-concurrent-edit-safety-for-patient-records), [ADR-003](../architecture/adrs.md#adr-003-optimistic-concurrency-control-via-version-field)
- Mobile pre-check-in — [US-007](../product/user-stories.md#us-007-pre-visit-check-in-from-personal-device), [US-008](../product/user-stories.md#us-008-receptionist-visibility-of-mobile-check-ins)
- Multi-location support — [US-009](../product/user-stories.md#us-009-cross-location-patient-record-access), [US-010](../product/user-stories.md#us-010-location-aware-check-in), [ADR-005](../architecture/adrs.md#adr-005-centralized-database-for-multi-location-no-replication)
- Medication compliance (state mandate) — [US-005](../product/user-stories.md#us-005-medication-list-confirmation-at-check-in), [ADR-004](../architecture/adrs.md#adr-004-immutable-medication-confirmation-audit-records)
- Insurance card OCR capture — [US-011](../product/user-stories.md#us-011-photo-capture-of-insurance-card), [ADR-006](../architecture/adrs.md#adr-006-ocr-service-as-a-separate-service-behind-a-stable-api-contract)
- Peak-hour performance — [US-006](../product/user-stories.md#us-006-peak-hour-check-in-performance), [ADR-007](../architecture/adrs.md#adr-007-scaling-strategy-for-50-concurrent-sessions)
- Riverside data migration and deduplication — [US-012](../product/user-stories.md#us-012-patient-data-migration-from-riverside), [US-013](../product/user-stories.md#us-013-duplicate-patient-detection-and-merge), [ADR-008](../architecture/adrs.md#adr-008-duplicate-detection-algorithm-for-riverside-migration), [ADR-010](../architecture/adrs.md#adr-010-migration-pipeline-architecture--batch-import-with-rollback)

---

## 2. Testing Strategy

### 2.1 Test Types

| Type | Purpose | Tools / Approach | Key Stories |
|------|---------|------------------|-------------|
| Functional | Verify acceptance criteria for every user story and bug fix | Manual test execution against [test cases](test-suites.md), automated regression | [US-001](../product/user-stories.md#us-001-pre-populated-check-in-for-returning-patients) through [US-013](../product/user-stories.md#us-013-duplicate-patient-detection-and-merge) |
| Security | Session isolation, PHI exposure, HIPAA compliance | Manual penetration testing, automated DOM inspection, session purge verification | [US-003](../product/user-stories.md#us-003-secure-patient-identification-on-scan), [BUG-002](bug-reports.md#bug-002-previous-patients-data-briefly-visible-on-kiosk-after-card-scan) |
| Performance / Load | Verify system handles 50 concurrent sessions with p95 < 3s | Load test tool (k6 or similar), simulated concurrent kiosk + mobile + dashboard sessions | [US-006](../product/user-stories.md#us-006-peak-hour-check-in-performance) |
| Integration | End-to-end flows crossing service boundaries (kiosk -> API -> WebSocket -> dashboard) | Automated E2E tests, [API contract](../architecture/api-spec.md) tests | [US-002](../product/user-stories.md#us-002-receptionist-sees-confirmed-check-in-data), [BUG-001](bug-reports.md#bug-001-kiosk-confirmation-shows-green-checkmark-but-receptionist-sees-nothing) |
| Compliance / Audit | Medication confirmation records are immutable and auditable | Database inspection, audit log verification | [US-005](../product/user-stories.md#us-005-medication-list-confirmation-at-check-in), [ADR-004](../architecture/adrs.md#adr-004-immutable-medication-confirmation-audit-records) |
| Data Migration | Riverside import accuracy, duplicate detection precision, rollback integrity | Batch import with known test data, verify mapping, dedup scores, merge/rollback | [US-012](../product/user-stories.md#us-012-patient-data-migration-from-riverside), [US-013](../product/user-stories.md#us-013-duplicate-patient-detection-and-merge) |
| Accessibility | Kiosk and mobile meet a11y requirements (ARIA, touch targets, contrast) | Screen reader testing, automated a11y scanner | [Screen specs](../experience/screen-specs.md) |
| Regression | Ensure new features don't break existing flows | Automated suite run before each release | All |

### 2.2 Test Environments

| Environment | Purpose | Data |
|-------------|---------|------|
| Dev | Unit and integration testing during development | Synthetic data, small set |
| Staging | Full regression, E2E, performance testing | Anonymized production-like data, 10,000+ patient records for load testing |
| Pre-Prod (Multi-Location) | Multi-location scenarios, migration dry-run | Two configured locations, synthetic Riverside data set |
| Kiosk Lab | Physical kiosk hardware testing (touchscreen, card reader, camera) | Dedicated test cards and patient identities |
| Mobile Device Lab | Cross-browser mobile testing (iOS Safari, Chrome Android, various screen sizes) | Test appointment links |

### 2.3 Test Data Requirements

- **Returning patient pool:** 50+ patient records with demographics, insurance, allergies, medications pre-populated
- **New patient scenario:** Cards/identities with no existing records
- **Concurrency test set:** 50 distinct patient identities with appointments at the same time window
- **Duplicate test set:** Riverside-format records with known overlaps against existing patients (exact matches, near-matches, no matches)
- **OCR test images:** Insurance cards in good, medium, and poor quality (blurry, dark, glare)
- **Paper record scans:** Sample Riverside paper records with varying legibility

---

## 3. Priority and Risk Areas

### Critical (must-pass before any release)

1. **Session isolation ([BUG-002](bug-reports.md#bug-002-previous-patients-data-briefly-visible-on-kiosk-after-card-scan))** — no patient ever sees another patient's data, even transiently. This is a HIPAA gate. Any failure here blocks release.
   - Tests: [TC-301](test-suites.md#tc-301-sequential-patients--no-data-leakage) through [TC-305](test-suites.md#tc-305-browser-back-button-does-not-reveal-previous-session)
   - Monitor: [Data Leak Detected](../operations/monitoring-alerting.md#p0----page-immediately-any-time)
2. **Kiosk-to-receptionist sync ([BUG-001](bug-reports.md#bug-001-kiosk-confirmation-shows-green-checkmark-but-receptionist-sees-nothing))** — no false green checkmarks. Patient confirmation state must match receptionist dashboard state.
   - Tests: [TC-201](test-suites.md#tc-201-successful-sync--green-checkmark) through [TC-204](test-suites.md#tc-204-dashboard-real-time-update--websocket-push)
   - Monitor: [Sync Failure Rate High](../operations/monitoring-alerting.md#p1----notify-during-business-hours)
3. **Concurrent edit safety ([BUG-003](bug-reports.md#bug-003-concurrent-edit-by-two-receptionists-causes-silent-data-loss))** — no silent data loss on concurrent saves.
   - Tests: [TC-701](test-suites.md#tc-701-two-receptionists--conflict-detection) through [TC-705](test-suites.md#tc-705-concurrent-edit--same-field-by-two-users)
   - Monitor: [Version Conflicts Today](../operations/monitoring-alerting.md#4-check-in-flow-dashboard)
4. **Medication confirmation audit trail** — every check-in produces an immutable medication confirmation record with correct snapshot. Compliance gate.
   - Tests: [TC-601](test-suites.md#tc-601-medication-step-is-mandatory--cannot-skip) through [TC-606](test-suites.md#tc-606-medication-step-on-mobile)
   - Architecture: [ADR-004](../architecture/adrs.md#adr-004-immutable-medication-confirmation-audit-records)

### High

5. **Mobile check-in identity verification** — PHI must not be accessible without successful verification. Link expiry must be enforced.
   - Tests: [TC-401](test-suites.md#tc-401-mobile-check-in--happy-path) through [TC-407](test-suites.md#tc-407-mobile--already-checked-in-via-mobile)
   - Monitor: [Mobile Web uptime](../operations/monitoring-alerting.md#uptime-monitoring-external)
6. **Multi-location data consistency** — patient record is identical at all locations, no stale data.
   - Tests: [TC-501](test-suites.md#tc-501-cross-location-patient-record--data-consistency) through [TC-504](test-suites.md#tc-504-mobile-check-in--location-displayed)
   - Monitor: [Read Replica Lag](../operations/monitoring-alerting.md#p0----page-immediately-any-time)
7. **Performance under load** — 50 concurrent sessions, p95 < 3s, no freezes.
   - Tests: [TC-901](test-suites.md#tc-901-50-concurrent-kiosk-check-ins--response-time) through [TC-905](test-suites.md#tc-905-degraded-mode--backend-unreachable)
   - Monitor: [p95 Response Time](../operations/monitoring-alerting.md#p1----notify-during-business-hours), [Concurrent Sessions](../operations/monitoring-alerting.md#p1----notify-during-business-hours)
8. **Duplicate detection accuracy** — no false merges (safety-critical), acceptable false positive rate (< 5%).
   - Tests: [TC-1003](test-suites.md#tc-1003-duplicate-detection--exact-match) through [TC-1011](test-suites.md#tc-1011-no-auto-merge-verification)
   - Architecture: [ADR-008](../architecture/adrs.md#adr-008-duplicate-detection-algorithm-for-riverside-migration)

### Medium

9. **OCR extraction accuracy** — confidence scoring is correct, low-confidence fields are flagged.
   - Tests: [TC-801](test-suites.md#tc-801-photo-capture--happy-path-on-kiosk) through [TC-805](test-suites.md#tc-805-insurance-card-photos-stored-and-accessible-to-staff)
   - Monitor: [OCR Service Slow](../operations/monitoring-alerting.md#p2----investigate-during-next-business-day)
10. **Migration rollback** — batch rollback fully reverses import including merged records.
    - Test: [TC-1007](test-suites.md#tc-1007-migration-rollback)
    - Architecture: [ADR-010](../architecture/adrs.md#adr-010-migration-pipeline-architecture--batch-import-with-rollback)
11. **Mobile partial completion and resume** — progress saved and resumed correctly.
    - Test: [TC-404](test-suites.md#tc-404-mobile--partial-completion-and-resume)

---

## 4. Entry and Exit Criteria

### Entry Criteria (start testing)
- Feature code is deployed to staging
- Unit tests pass (developer responsibility)
- API contract matches [spec](../architecture/api-spec.md)
- Test data is seeded in staging environment

### Exit Criteria (release approval)
- All critical test cases pass (zero failures)
- All high-priority test cases pass
- Medium-priority: no P0/P1 open defects, known P2s documented with workarounds
- Performance test meets targets (50 concurrent, p95 < 3s) — verified by [TC-901](test-suites.md#tc-901-50-concurrent-kiosk-check-ins--response-time)
- Security test confirms session isolation (automated + manual) — verified by [TC-301](test-suites.md#tc-301-sequential-patients--no-data-leakage)-[TC-305](test-suites.md#tc-305-browser-back-button-does-not-reveal-previous-session)
- Compliance test confirms medication audit records are correct and immutable — verified by [TC-602](test-suites.md#tc-602-medication-confirmation--confirmed-unchanged), [TC-605](test-suites.md#tc-605-medication-confirmation--immutability)
- Regression suite passes (no regressions from prior rounds)
- All [production monitors](../operations/monitoring-alerting.md) are active and thresholds configured

---

## 5. Test Execution by Round

| Round | What Happened | Test Focus | Stories | Architecture |
|-------|---------------|------------|---------|--------------|
| 1 | Customer ask: returning patient recognition | Core check-in flow, pre-populated data, demographics/insurance/allergies | [US-001](../product/user-stories.md#us-001-pre-populated-check-in-for-returning-patients) | N/A |
| 2 | BUG-001: kiosk confirmation not syncing to receptionist | End-to-end sync, false checkmark prevention, receptionist dashboard updates | [US-002](../product/user-stories.md#us-002-receptionist-sees-confirmed-check-in-data), [BUG-001](bug-reports.md#bug-001-kiosk-confirmation-shows-green-checkmark-but-receptionist-sees-nothing) | [ADR-001](../architecture/adrs.md#adr-001-websocket-with-polling-fallback-for-real-time-dashboard-updates) |
| 3 | Feature: mobile pre-check-in | Mobile flow, identity verification, link lifecycle, partial completion, duplicate check-in prevention | [US-007](../product/user-stories.md#us-007-pre-visit-check-in-from-personal-device), [US-008](../product/user-stories.md#us-008-receptionist-visibility-of-mobile-check-ins) | N/A |
| 4 | BUG-002: data leak between patients (P0) | Session isolation, DOM purge, rapid scan testing, penetration testing | [US-003](../product/user-stories.md#us-003-secure-patient-identification-on-scan), [BUG-002](bug-reports.md#bug-002-previous-patients-data-briefly-visible-on-kiosk-after-card-scan) | [ADR-002](../architecture/adrs.md#adr-002-session-purge-protocol-for-kiosk-state-isolation) |
| 5 | Business: multi-location | Cross-location data access, location-aware kiosk/dashboard, search across locations | [US-009](../product/user-stories.md#us-009-cross-location-patient-record-access), [US-010](../product/user-stories.md#us-010-location-aware-check-in) | [ADR-005](../architecture/adrs.md#adr-005-centralized-database-for-multi-location-no-replication) |
| 6 | Compliance: medication list mandatory | Medication step is unskippable, audit record creation, confirmation types, "no medications" flow | [US-005](../product/user-stories.md#us-005-medication-list-confirmation-at-check-in) | [ADR-004](../architecture/adrs.md#adr-004-immutable-medication-confirmation-audit-records) |
| 7 | BUG-003: concurrent edit data loss | Optimistic locking, version conflict detection, conflict resolution UI, no silent overwrites | [US-004](../product/user-stories.md#us-004-concurrent-edit-safety-for-patient-records), [BUG-003](bug-reports.md#bug-003-concurrent-edit-by-two-receptionists-causes-silent-data-loss) | [ADR-003](../architecture/adrs.md#adr-003-optimistic-concurrency-control-via-version-field) |
| 8 | Feature: insurance card photo/OCR | Camera capture flow, OCR extraction, confidence scoring, fallback to manual entry | [US-011](../product/user-stories.md#us-011-photo-capture-of-insurance-card) | [ADR-006](../architecture/adrs.md#adr-006-ocr-service-as-a-separate-service-behind-a-stable-api-contract), [ADR-009](../architecture/adrs.md#adr-009-object-storage-for-insurance-card-photos-and-scanned-records) |
| 9 | Performance: peak-hour load | Load testing, connection pooling effectiveness, search performance, dashboard under load | [US-006](../product/user-stories.md#us-006-peak-hour-check-in-performance) | [ADR-007](../architecture/adrs.md#adr-007-scaling-strategy-for-50-concurrent-sessions) |
| 10 | Business: Riverside acquisition migration | Schema mapping, import validation, duplicate detection, staff review, merge, rollback, first-visit confirmation | [US-012](../product/user-stories.md#us-012-patient-data-migration-from-riverside), [US-013](../product/user-stories.md#us-013-duplicate-patient-detection-and-merge) | [ADR-008](../architecture/adrs.md#adr-008-duplicate-detection-algorithm-for-riverside-migration), [ADR-010](../architecture/adrs.md#adr-010-migration-pipeline-architecture--batch-import-with-rollback) |

---

## 6. Defect Management

- **P0 (Critical/Security):** Fix within 24 hours. Blocks release. Example: PHI exposure. Monitor: [Data Leak Detected](../operations/monitoring-alerting.md#p0----page-immediately-any-time).
- **P1 (High):** Fix this sprint. Core flow broken. Example: data loss, false sync confirmation. Monitor: [Sync Failure Rate](../operations/monitoring-alerting.md#p1----notify-during-business-hours).
- **P2 (Medium):** Fix next sprint. Functional issue with workaround. Example: OCR confidence threshold slightly off. Monitor: [OCR Service Slow](../operations/monitoring-alerting.md#p2----investigate-during-next-business-day).
- **P3 (Low):** Backlog. Cosmetic, edge-case, or enhancement.

All bugs are logged in [bug-reports.md](bug-reports.md) with: summary, steps to reproduce, expected vs actual, severity, environment, screenshots/video, root cause (when identified), traceability to affected story and ADR.

---

## 7. Assumptions and Dependencies

- Engineering provides API documentation matching the [spec](../architecture/api-spec.md)
- Kiosk hardware (touchscreen, card reader, camera) is available in the lab for physical testing
- Twilio sandbox is available for SMS link testing
- Google Vision API (or equivalent) sandbox is available for OCR testing — see [ADR-006](../architecture/adrs.md#adr-006-ocr-service-as-a-separate-service-behind-a-stable-api-contract)
- Riverside EMR export format is provided in CSV/JSON per the schema mapping document — see [ADR-010](../architecture/adrs.md#adr-010-migration-pipeline-architecture--batch-import-with-rollback)
- Anonymized production data is available for staging performance tests
- All [production monitors](../operations/monitoring-alerting.md) are deployed and operational before go-live
