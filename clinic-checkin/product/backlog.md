# Backlog

Prioritized by urgency, dependency order, and business impact.

| # | Story | Epic | Priority | Status | Key Links | Confirmed by |
|---|-------|------|----------|--------|-----------|-------------|
| BUG-002 | Data leak — previous patient visible on scan | E1 | P0 | Open | [Screen 1.2](../experience/screen-specs.md#12-session-transition-screen), [Flow 4](../experience/user-flows.md#4-data-leak-prevention--between-patients-bug-002-fix), [ADR-002](../architecture/adrs.md#adr-002-session-purge-protocol-for-kiosk-state-isolation), [TC-301–305](../quality/test-suites.md#tc-301-sequential-patients--no-data-leakage), [Bug report](../quality/bug-reports.md#bug-002-previous-patients-data-briefly-visible-on-kiosk-after-card-scan) | Dr. Martinez (Medical Director), 2024-03-20 |
| BUG-001 | Kiosk confirmation not syncing to receptionist | E1 | P1 | Open | [Screen 1.8](../experience/screen-specs.md#18-check-in-confirmation-screen), [Flow 5](../experience/user-flows.md#5-kiosk-to-receptionist-sync-bug-001-fix), [ADR-001](../architecture/adrs.md#adr-001-websocket-with-polling-fallback-for-real-time-dashboard-updates), [TC-201–203](../quality/test-suites.md#tc-201-successful-sync--green-checkmark), [Bug report](../quality/bug-reports.md#bug-001-kiosk-confirmation-shows-green-checkmark-but-receptionist-sees-nothing) | Chen Wei (QA Lead), 2024-03-18 |
| BUG-003 | Concurrent edit causes silent data loss | E1 | P1 | Open | [Screen 2.2](../experience/screen-specs.md#22-receptionist--patient-detail-side-panel), [Flow 10](../experience/user-flows.md#10-concurrent-edit-conflict-bug-003-fix), [ADR-003](../architecture/adrs.md#adr-003-optimistic-concurrency-control-via-version-field), [TC-701–705](../quality/test-suites.md#tc-701-two-receptionists--conflict-detection), [Bug report](../quality/bug-reports.md#bug-003-concurrent-edit-by-two-receptionists-causes-silent-data-loss) | Chen Wei (QA Lead), 2024-03-22 |
| US-005 | Medication list confirmation at check-in | E6 | P1 | Open | [Screen 1.7](../experience/screen-specs.md#17-check-in-review-screen--medications), [ADR-004](../architecture/adrs.md#adr-004-immutable-medication-confirmation-audit-records), [TC-601–606](../quality/test-suites.md#tc-601-medication-step-is-mandatory--cannot-skip) | Dr. Martinez (Medical Director), 2024-03-25 |
| US-001 | Pre-populated check-in for returning patients | E1 | P2 | Open | [Screens 1.1–1.8](../experience/screen-specs.md#11-kiosk-welcome-screen), [Flow 1](../experience/user-flows.md#1-returning-patient--kiosk-check-in-happy-path), [TC-101–104](../quality/test-suites.md#tc-101-returning-patient--happy-path-check-in) | Sarah Chen (PM Lead), 2024-03-15 |
| US-002 | Receptionist sees confirmed check-in data | E1 | P2 | Open | [Screen 2.1](../experience/screen-specs.md#21-receptionist-dashboard--main-view), [Flow 5](../experience/user-flows.md#5-kiosk-to-receptionist-sync-bug-001-fix), [TC-201–204](../quality/test-suites.md#tc-201-successful-sync--green-checkmark) | Sarah Chen (PM Lead), 2024-03-18 |
| US-003 | Secure patient identification on scan | E1 | P2 | Open | [Screen 1.2](../experience/screen-specs.md#12-session-transition-screen), [Flow 4](../experience/user-flows.md#4-data-leak-prevention--between-patients-bug-002-fix), [TC-301–305](../quality/test-suites.md#tc-301-sequential-patients--no-data-leakage) | Dr. Martinez (Medical Director), 2024-03-20 |
| US-006 | Peak-hour check-in performance | E1 | P2 | Open | [Screens 5.1–5.4](../experience/screen-specs.md#5-loading--degraded-states), [Flow 15](../experience/user-flows.md#15-peak-load-degraded-experience-round-9), [ADR-007](../architecture/adrs.md#adr-007-scaling-strategy-for-50-concurrent-sessions), [TC-901–905](../quality/test-suites.md#tc-901-50-concurrent-kiosk-check-ins--response-time) | Alex Kim (Engineering), 2024-04-02 |
| US-004 | Concurrent edit safety | E1 | P2 | Open | [Screen 2.2](../experience/screen-specs.md#22-receptionist--patient-detail-side-panel), [Flow 10](../experience/user-flows.md#10-concurrent-edit-conflict-bug-003-fix), [ADR-003](../architecture/adrs.md#adr-003-optimistic-concurrency-control-via-version-field), [TC-701–705](../quality/test-suites.md#tc-701-two-receptionists--conflict-detection) | Sarah Chen (PM Lead), 2024-03-22 |
| US-009 | Cross-location patient record access | E3 | P2 | Open | [Screen 2.1](../experience/screen-specs.md#21-receptionist-dashboard--main-view), [Flow 11](../experience/user-flows.md#11-multi-location-check-in), [ADR-005](../architecture/adrs.md#adr-005-centralized-database-for-multi-location-no-replication), [TC-501, TC-503](../quality/test-suites.md#tc-501-cross-location-patient-record--data-consistency) | Sarah Chen (PM Lead), 2024-04-10 |
| US-010 | Location-aware check-in | E3 | P2 | Open | [Screen 2.1](../experience/screen-specs.md#21-receptionist-dashboard--main-view), [Flow 11–12](../experience/user-flows.md#11-multi-location-check-in), [TC-502–504](../quality/test-suites.md#tc-502-location-aware-kiosk) | Sarah Chen (PM Lead), 2024-04-10 |
| US-007 | Pre-visit mobile check-in | E2 | P3 | Open | [Screens 3.1–3.3](../experience/screen-specs.md#31-mobile--link-landing--identity-verification), [Flow 6–8](../experience/user-flows.md#6-mobile-check-in--happy-path), [TC-401–407](../quality/test-suites.md#tc-401-mobile-check-in--happy-path) | Sarah Chen (PM Lead), 2024-04-05 |
| US-008 | Receptionist visibility of mobile check-ins | E2 | P3 | Open | [Screen 2.1](../experience/screen-specs.md#21-receptionist-dashboard--main-view), [Flow 6](../experience/user-flows.md#6-mobile-check-in--happy-path), [TC-401, TC-404](../quality/test-suites.md#tc-401-mobile-check-in--happy-path) | Sarah Chen (PM Lead), 2024-04-05 |
| US-011 | Insurance card photo capture | E4 | P3 | Open | [Screen 1.5a](../experience/screen-specs.md#15a-insurance-card-photo-capture-overlay), [Flow 9](../experience/user-flows.md#9-insurance-card-photo-capture), [ADR-006](../architecture/adrs.md#adr-006-ocr-service-as-a-separate-service-behind-a-stable-api-contract), [TC-801–805](../quality/test-suites.md#tc-801-photo-capture--happy-path-on-kiosk) | Alex Kim (Engineering), 2024-04-15 |
| US-012 | Patient data migration from Riverside | E5 | P3 | Open | [Screen 4.1](../experience/screen-specs.md#41-admin--migration-dashboard), [Flow 13](../experience/user-flows.md#13-riverside-migration--first-visit-after-migration), [ADR-010](../architecture/adrs.md#adr-010-migration-pipeline-architecture--batch-import-with-rollback), [TC-1001–1009](../quality/test-suites.md#tc-1001-emr-import--valid-records) | Sarah Chen (PM Lead), 2024-04-18 |
| US-013 | Duplicate detection and merge | E5 | P3 | Open | [Screen 4.2](../experience/screen-specs.md#42-admin--duplicate-review-screen), [Flow 14](../experience/user-flows.md#14-duplicate-detection--staff-review-riverside), [ADR-008](../architecture/adrs.md#adr-008-duplicate-detection-algorithm-for-riverside-migration), [TC-1003–1011](../quality/test-suites.md#tc-1003-duplicate-detection--exact-match) | Chen Wei (QA Lead), 2024-04-18 |

---

## Coverage Gaps

Items identified from the [coverage report](../quality/coverage-report.md) triage. These are untested areas that need either test coverage or an explicit risk acceptance.

### Security / Session Isolation

| # | Gap | Risk | Status |
|---|-----|------|--------|
| GAP-001 | 100-session memory leak test for kiosk session purge | P1 — prolonged kiosk use could degrade session isolation | Needs TC |
| GAP-002 | Presigned URL expiry verification (15-min S3 URLs) | P2 — expired URLs could expose stale access or break staff image viewing | Needs TC |

### Mobile Check-In

| # | Gap | Risk | Status |
|---|-----|------|--------|
| GAP-003 | SMS/email link delivery verification (Twilio integration) | P2 — patients may never receive check-in links | Needs TC (depends on Twilio sandbox) |
| GAP-004 | Reminder notification delivery (2h before appointment) | P3 — missed reminders reduce mobile check-in adoption | Needs TC |
| GAP-005 | Cross-browser compatibility matrix (iOS Safari, Chrome Android) | P2 — mobile flow may break on common devices | Needs device lab test plan |
| GAP-006 | Focus management on mobile bottom sheet edit panels | P3 — accessibility issue for screen reader users on mobile | Needs TC |

### Multi-Location

| # | Gap | Risk | Status |
|---|-----|------|--------|
| GAP-007 | Admin "All Locations" dashboard view | P3 — admin lacks cross-location visibility | Needs TC |
| GAP-008 | Staff permissions scoped per location | P2 — receptionist at Location A could access Location B patient queue | Needs TC |
| GAP-009 | Cross-location appointment history UI display | P3 — US-009 AC partially unverified | Needs TC |

### Insurance OCR

| # | Gap | Risk | Status |
|---|-----|------|--------|
| GAP-010 | Secondary insurance card photo capture | P3 — patients with dual coverage can't photograph second card | Needs TC |
| GAP-011 | Client-side blurry/dark image detection before OCR submit | P3 — poor quality images waste OCR processing and frustrate patients | Needs TC |

### Data Migration (Riverside)

| # | Gap | Risk | Status |
|---|-----|------|--------|
| GAP-012 | Riverside medication frequency mapping (BID -> twice_daily) | P2 — incorrect medication data post-migration is a patient safety risk | Needs TC |
| GAP-013 | Batch sequential review flow (staff reviews 10 duplicates at a time) | P3 — staff workflow for bulk review untested | Needs TC |
| GAP-014 | Migration dashboard live count accuracy during active import | P3 — admin may see stale progress data | Needs TC |

### Accessibility

| # | Gap | Risk | Status |
|---|-----|------|--------|
| GAP-015 | Kiosk high-contrast mode toggle | P3 — visually impaired patients at kiosk | Needs TC |

### Audit

| # | Gap | Risk | Status |
|---|-----|------|--------|
| GAP-016 | US-003 audit log AC — scan events logged with patient ID + timestamp | P2 — security audit trail incomplete, compliance risk | Needs TC |

---

## Priority definitions
- **P0:** Fix now. Production incident, data exposure, compliance violation.
- **P1:** Fix this sprint. Core flow broken or deadline-driven compliance.
- **P2:** Next up. High value, needed soon, or unblocks other work.
- **P3:** Planned. Important but can wait for dependencies or capacity.

## Sequencing notes

**Immediate (this sprint):**
- BUG-002 first — security incident, possible HIPAA reporting obligation
- BUG-001 and BUG-003 in parallel — both are data integrity issues in the core flow
- US-005 design kickoff — Q3 deadline means we need lead time

**Next sprint:**
- US-001 through US-004 — finish stabilizing the core check-in experience
- US-006 — performance work can happen alongside feature work
- US-009, US-010 — second location opens next month

**Following sprints:**
- US-007, US-008 — mobile check-in (E1 must be stable first)
- US-011 — photo capture (nice acceleration for mobile launch)
- US-012, US-013 — Riverside migration (E3 must be in place, PRD needs sign-off)
