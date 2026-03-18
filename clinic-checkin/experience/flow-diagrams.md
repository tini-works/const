# Flow Diagrams — Visual Reference

Companion to the text-based user flows and screen specs. Each diagram is interactive — click to view full size.

---

## Kiosk Check-In Flow

| Trace | Link |
|-------|------|
| Traced from | [US-001](../product/user-stories.md#us-001-pre-populated-check-in-for-returning-patients), [US-003](../product/user-stories.md#us-003-secure-patient-identification-on-scan), [BUG-001](../product/user-stories.md#bug-001-kiosk-confirmation-not-syncing-to-receptionist-screen), [BUG-002](../product/user-stories.md#bug-002-data-leak--previous-patients-data-visible-on-scan), [E1](../product/epics.md#e1-returning-patient-recognition) |
| Proven by | [Suite 1](../quality/test-suites.md#suite-1-core-kiosk-check-in-round-1), [Suite 2](../quality/test-suites.md#suite-2-kiosk-to-receptionist-sync--bug-001-fix-round-2), [Suite 3](../quality/test-suites.md#suite-3-session-isolation--bug-002-fix-round-4) |
| Confirmed by | Jamie Park (Design Lead), 2024-11-05 |

All screens and state transitions for the kiosk check-in experience, including error paths and the BUG-001/BUG-002 fixes.

https://diashort.apps.quickable.co/e/46ad65e9

---

## Mobile Check-In Flow

| Trace | Link |
|-------|------|
| Traced from | [US-007](../product/user-stories.md#us-007-pre-visit-check-in-from-personal-device), [US-008](../product/user-stories.md#us-008-receptionist-visibility-of-mobile-check-ins), [E2](../product/epics.md#e2-mobile-check-in) |
| Proven by | [Suite 4](../quality/test-suites.md#suite-4-mobile-check-in-round-3) |
| Confirmed by | Jamie Park (Design Lead), 2024-10-28 |

End-to-end mobile check-in journey including link states, partial completion/resume, and kiosk duplicate prevention.

https://diashort.apps.quickable.co/e/e00cefa4

---

## Kiosk-to-Receptionist Sync (BUG-001 Fix)

| Trace | Link |
|-------|------|
| Traced from | [US-002](../product/user-stories.md#us-002-receptionist-sees-confirmed-check-in-data), [BUG-001](../product/user-stories.md#bug-001-kiosk-confirmation-not-syncing-to-receptionist-screen) |
| Proven by | [TC-201](../quality/test-suites.md#tc-201-successful-sync--green-checkmark), [TC-202](../quality/test-suites.md#tc-202-sync-timeout--yellow-warning-on-kiosk), [TC-203](../quality/test-suites.md#tc-203-sync-failure--dashboard-retry) |
| Confirmed by | Jamie Park (Design Lead), 2024-10-15 |

Sequence diagram showing the end-to-end sync verification between kiosk confirmation and receptionist dashboard update, including the three possible outcomes (confirmed, timeout, failure).

https://diashort.apps.quickable.co/e/e90549a3

---

## Concurrent Edit Conflict Resolution (BUG-003 Fix)

| Trace | Link |
|-------|------|
| Traced from | [US-004](../product/user-stories.md#us-004-concurrent-edit-safety-for-patient-records), [BUG-003](../product/user-stories.md#bug-003-concurrent-edit-causes-silent-data-loss) |
| Proven by | [Suite 7](../quality/test-suites.md#suite-7-concurrent-edit-safety--bug-003-fix-round-7) |
| Confirmed by | Jamie Park (Design Lead), 2024-12-10 |

Sequence diagram showing optimistic concurrency control when two receptionists edit the same patient record simultaneously.

https://diashort.apps.quickable.co/e/7fd8a747

---

## Riverside Migration Pipeline

| Trace | Link |
|-------|------|
| Traced from | [US-012](../product/user-stories.md#us-012-patient-data-migration-from-riverside), [US-013](../product/user-stories.md#us-013-duplicate-patient-detection-and-merge), [E5](../product/epics.md#e5-riverside-practice-acquisition) |
| Proven by | [Suite 10](../quality/test-suites.md#suite-10-riverside-data-migration-round-10) |
| Confirmed by | Sarah Chen (PM), 2024-12-22 |

Data flow from Riverside EMR export and paper records through validation, duplicate detection, staff review, and patient first-visit confirmation.

https://diashort.apps.quickable.co/e/b382c1ca
