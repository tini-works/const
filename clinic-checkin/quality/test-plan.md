# Test Plan — Clinic Check-In System

**QA Lead:** QA Team
**Last updated:** After Round 10
**System:** Clinic Check-In (Kiosk, Mobile Web, Receptionist Dashboard, Admin Panel)

---

## 1. Scope

This plan covers all testing activities for the clinic check-in system across 10 rounds of development. It addresses:

- Core kiosk check-in flow (returning and new patients)
- Kiosk-to-receptionist sync (BUG-001 fix)
- Session isolation / data leak prevention (BUG-002 fix)
- Concurrent edit safety (BUG-003 fix)
- Mobile pre-check-in
- Multi-location support
- Medication compliance (state mandate)
- Insurance card OCR capture
- Peak-hour performance
- Riverside data migration and deduplication

---

## 2. Testing Strategy

### 2.1 Test Types

| Type | Purpose | Tools / Approach |
|------|---------|------------------|
| Functional | Verify acceptance criteria for every user story and bug fix | Manual test execution against test cases, automated regression |
| Security | Session isolation, PHI exposure, HIPAA compliance | Manual penetration testing, automated DOM inspection, session purge verification |
| Performance / Load | Verify system handles 50 concurrent sessions with p95 < 3s | Load test tool (k6 or similar), simulated concurrent kiosk + mobile + dashboard sessions |
| Integration | End-to-end flows crossing service boundaries (kiosk -> API -> WebSocket -> dashboard) | Automated E2E tests, API contract tests |
| Compliance / Audit | Medication confirmation records are immutable and auditable | Database inspection, audit log verification |
| Data Migration | Riverside import accuracy, duplicate detection precision, rollback integrity | Batch import with known test data, verify mapping, dedup scores, merge/rollback |
| Accessibility | Kiosk and mobile meet a11y requirements (ARIA, touch targets, contrast) | Screen reader testing, automated a11y scanner |
| Regression | Ensure new features don't break existing flows | Automated suite run before each release |

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

1. **Session isolation (BUG-002)** — no patient ever sees another patient's data, even transiently. This is a HIPAA gate. Any failure here blocks release.
2. **Kiosk-to-receptionist sync (BUG-001)** — no false green checkmarks. Patient confirmation state must match receptionist dashboard state.
3. **Concurrent edit safety (BUG-003)** — no silent data loss on concurrent saves.
4. **Medication confirmation audit trail** — every check-in produces an immutable medication confirmation record with correct snapshot. Compliance gate.

### High

5. **Mobile check-in identity verification** — PHI must not be accessible without successful verification. Link expiry must be enforced.
6. **Multi-location data consistency** — patient record is identical at all locations, no stale data.
7. **Performance under load** — 50 concurrent sessions, p95 < 3s, no freezes.
8. **Duplicate detection accuracy** — no false merges (safety-critical), acceptable false positive rate (< 5%).

### Medium

9. **OCR extraction accuracy** — confidence scoring is correct, low-confidence fields are flagged.
10. **Migration rollback** — batch rollback fully reverses import including merged records.
11. **Mobile partial completion and resume** — progress saved and resumed correctly.

---

## 4. Entry and Exit Criteria

### Entry Criteria (start testing)
- Feature code is deployed to staging
- Unit tests pass (developer responsibility)
- API contract matches spec
- Test data is seeded in staging environment

### Exit Criteria (release approval)
- All critical test cases pass (zero failures)
- All high-priority test cases pass
- Medium-priority: no P0/P1 open defects, known P2s documented with workarounds
- Performance test meets targets (50 concurrent, p95 < 3s)
- Security test confirms session isolation (automated + manual)
- Compliance test confirms medication audit records are correct and immutable
- Regression suite passes (no regressions from prior rounds)

---

## 5. Test Execution by Round

| Round | What Happened | Test Focus |
|-------|---------------|------------|
| 1 | Customer ask: returning patient recognition | Core check-in flow, pre-populated data, demographics/insurance/allergies |
| 2 | BUG-001: kiosk confirmation not syncing to receptionist | End-to-end sync, false checkmark prevention, receptionist dashboard updates |
| 3 | Feature: mobile pre-check-in | Mobile flow, identity verification, link lifecycle, partial completion, duplicate check-in prevention |
| 4 | BUG-002: data leak between patients (P0) | Session isolation, DOM purge, rapid scan testing, penetration testing |
| 5 | Business: multi-location | Cross-location data access, location-aware kiosk/dashboard, search across locations |
| 6 | Compliance: medication list mandatory | Medication step is unskippable, audit record creation, confirmation types, "no medications" flow |
| 7 | BUG-003: concurrent edit data loss | Optimistic locking, version conflict detection, conflict resolution UI, no silent overwrites |
| 8 | Feature: insurance card photo/OCR | Camera capture flow, OCR extraction, confidence scoring, fallback to manual entry |
| 9 | Performance: peak-hour load | Load testing, connection pooling effectiveness, search performance, dashboard under load |
| 10 | Business: Riverside acquisition migration | Schema mapping, import validation, duplicate detection, staff review, merge, rollback, first-visit confirmation |

---

## 6. Defect Management

- **P0 (Critical/Security):** Fix within 24 hours. Blocks release. Example: PHI exposure.
- **P1 (High):** Fix this sprint. Core flow broken. Example: data loss, false sync confirmation.
- **P2 (Medium):** Fix next sprint. Functional issue with workaround. Example: OCR confidence threshold slightly off.
- **P3 (Low):** Backlog. Cosmetic, edge-case, or enhancement.

All bugs are logged with: summary, steps to reproduce, expected vs actual, severity, environment, screenshots/video, root cause (when identified).

---

## 7. Assumptions and Dependencies

- Engineering provides API documentation matching the spec in `/sim/engineer/api-spec.md`
- Kiosk hardware (touchscreen, card reader, camera) is available in the lab for physical testing
- Twilio sandbox is available for SMS link testing
- Google Vision API (or equivalent) sandbox is available for OCR testing
- Riverside EMR export format is provided in CSV/JSON per the schema mapping document
- Anonymized production data is available for staging performance tests
