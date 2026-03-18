# Flow Diagrams — Visual Reference

Companion to the text-based user flows and screen specs. Each diagram is interactive — click to view full size.

---

## Kiosk Check-In Flow

| Trace | Link |
|-------|------|
| Traced from | [US-001](../product/user-stories.md#us-001-pre-populated-check-in-for-returning-patients), [US-003](../product/user-stories.md#us-003-secure-patient-identification-on-scan), [BUG-001](../product/user-stories.md#bug-001-kiosk-confirmation-not-syncing-to-receptionist-screen), [BUG-002](../product/user-stories.md#bug-002-data-leak--previous-patients-data-visible-on-scan), [E1](../product/epics.md#e1-returning-patient-recognition) |
| Matched by | [POST /patients/identify](../architecture/api-spec.md#post-patientsidentify), [POST /checkins](../architecture/api-spec.md#post-checkins), [POST /checkins/{id}/complete](../architecture/api-spec.md#post-checkinsidcomplete), [ADR-001](../architecture/adrs.md#adr-001-websocket-with-polling-fallback-for-real-time-dashboard-updates), [ADR-002](../architecture/adrs.md#adr-002-session-purge-protocol-for-kiosk-state-isolation) |
| Proven by | [Suite 1](../quality/test-suites.md#suite-1-core-kiosk-check-in-round-1), [Suite 2](../quality/test-suites.md#suite-2-kiosk-to-receptionist-sync--bug-001-fix-round-2), [Suite 3](../quality/test-suites.md#suite-3-session-isolation--bug-002-fix-round-4) |
| Confirmed by | Jamie Park (Design Lead), 2024-11-05 |

All screens and state transitions for the kiosk check-in experience, including error paths and the BUG-001/BUG-002 fixes.

https://diashort.apps.quickable.co/e/46ad65e9

---

## Mobile Check-In Flow

| Trace | Link |
|-------|------|
| Traced from | [US-007](../product/user-stories.md#us-007-pre-visit-check-in-from-personal-device), [US-008](../product/user-stories.md#us-008-receptionist-visibility-of-mobile-check-ins), [E2](../product/epics.md#e2-mobile-check-in) |
| Matched by | [POST /patients/verify-identity](../architecture/api-spec.md#post-patientsverify-identity), [POST /mobile-checkin/send-link](../architecture/api-spec.md#post-mobile-checkinsend-link), [PATCH /checkins/{id}/progress](../architecture/api-spec.md#patch-checkinsidprogress) |
| Proven by | [Suite 4](../quality/test-suites.md#suite-4-mobile-check-in-round-3) |
| Confirmed by | Jamie Park (Design Lead), 2024-10-28 |

End-to-end mobile check-in journey including link states, partial completion/resume, and kiosk duplicate prevention.

https://diashort.apps.quickable.co/e/e00cefa4

---

## Kiosk-to-Receptionist Sync (BUG-001 Fix)

| Trace | Link |
|-------|------|
| Traced from | [US-002](../product/user-stories.md#us-002-receptionist-sees-confirmed-check-in-data), [BUG-001](../product/user-stories.md#bug-001-kiosk-confirmation-not-syncing-to-receptionist-screen) |
| Matched by | [POST /checkins/{id}/complete](../architecture/api-spec.md#post-checkinsidcomplete), [WebSocket /ws/dashboard/{location_id}](../architecture/api-spec.md#websocket-wsdashboardlocation_id), [ADR-001](../architecture/adrs.md#adr-001-websocket-with-polling-fallback-for-real-time-dashboard-updates) |
| Proven by | [TC-201](../quality/test-suites.md#tc-201-successful-sync--green-checkmark), [TC-202](../quality/test-suites.md#tc-202-sync-timeout--yellow-warning-on-kiosk), [TC-203](../quality/test-suites.md#tc-203-sync-failure--dashboard-retry) |
| Confirmed by | Jamie Park (Design Lead), 2024-10-15 |

Sequence diagram showing the end-to-end sync verification between kiosk confirmation and receptionist dashboard update, including the three possible outcomes (confirmed, timeout, failure).

https://diashort.apps.quickable.co/e/e90549a3

---

## Concurrent Edit Conflict Resolution (BUG-003 Fix)

| Trace | Link |
|-------|------|
| Traced from | [US-004](../product/user-stories.md#us-004-concurrent-edit-safety-for-patient-records), [BUG-003](../product/user-stories.md#bug-003-concurrent-edit-causes-silent-data-loss) |
| Matched by | [PATCH /patients/{id}](../architecture/api-spec.md#patch-patientsid), [ADR-003](../architecture/adrs.md#adr-003-optimistic-concurrency-control-via-version-field) |
| Proven by | [Suite 7](../quality/test-suites.md#suite-7-concurrent-edit-safety--bug-003-fix-round-7) |
| Confirmed by | Jamie Park (Design Lead), 2024-12-10 |

Sequence diagram showing optimistic concurrency control when two receptionists edit the same patient record simultaneously.

https://diashort.apps.quickable.co/e/7fd8a747

---

## Riverside Migration Pipeline

| Trace | Link |
|-------|------|
| Traced from | [US-012](../product/user-stories.md#us-012-patient-data-migration-from-riverside), [US-013](../product/user-stories.md#us-013-duplicate-patient-detection-and-merge), [E5](../product/epics.md#e5-riverside-practice-acquisition) |
| Matched by | [POST /migration/batches](../architecture/api-spec.md#post-migrationbatches), [GET /migration/duplicates/{id}](../architecture/api-spec.md#get-migrationduplicatesid), [POST /migration/duplicates/{id}/resolve](../architecture/api-spec.md#post-migrationduplicatesidresolve), [ADR-008](../architecture/adrs.md#adr-008-duplicate-detection-algorithm-for-riverside-migration), [ADR-010](../architecture/adrs.md#adr-010-migration-pipeline-architecture--batch-import-with-rollback) |
| Proven by | [Suite 10](../quality/test-suites.md#suite-10-riverside-data-migration-round-10) |
| Confirmed by | Sarah Chen (PM), 2024-12-22 |

Data flow from Riverside EMR export and paper records through validation, duplicate detection, staff review, and patient first-visit confirmation.

https://diashort.apps.quickable.co/e/b382c1ca
