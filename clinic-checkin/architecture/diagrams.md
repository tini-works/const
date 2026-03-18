# Engineering Diagrams — Clinic Check-In System

Visual references for architecture, data model, and key system flows.

---

## System Architecture
Full system decomposition: clients, services, data stores, infrastructure.

> **See also:** [Architecture Overview](architecture.md), Epics [E1](../product/epics.md#e1-returning-patient-recognition)–[E6](../product/epics.md#e6-compliance--medication-list-at-check-in)
> **Confirmed by:** Alex Kim (Tech Lead), 2024-12-22

https://diashort.apps.quickable.co/e/17eba3ea

---

## Data Model (ER Diagram)
Core entities, relationships, and key fields across all rounds.

> **See also:** [Data Model](data-model.md)
> **Confirmed by:** Alex Kim (Tech Lead), 2024-12-22

https://diashort.apps.quickable.co/e/280207f2

---

## Kiosk-to-Receptionist Sync (BUG-001 Fix)
Sequence diagram: end-to-end sync confirmation via WebSocket ack, including timeout and fallback paths.

> **ADR:** [ADR-001](adrs.md#adr-001-websocket-with-polling-fallback-for-real-time-dashboard-updates) | **Story:** [BUG-001](../product/user-stories.md#bug-001-kiosk-confirmation-not-syncing-to-receptionist-screen) | **Flow:** [5. Kiosk-to-Receptionist Sync](../experience/user-flows.md#5-kiosk-to-receptionist-sync-bug-001-fix) | **Tests:** [TC-201](../quality/test-suites.md#tc-201-successful-sync--green-checkmark)–[TC-204](../quality/test-suites.md#tc-204-dashboard-real-time-update--websocket-push)
> **Confirmed by:** Priya Patel (Senior Engineer), 2024-10-18

https://diashort.apps.quickable.co/e/64120fa4

---

## Optimistic Concurrency Control (BUG-003 Fix)
Sequence diagram: two receptionists editing the same patient record simultaneously, version conflict detection and resolution.

> **ADR:** [ADR-003](adrs.md#adr-003-optimistic-concurrency-control-via-version-field) | **Story:** [BUG-003](../product/user-stories.md#bug-003-concurrent-edit-causes-silent-data-loss) | **Flow:** [10. Concurrent Edit Conflict](../experience/user-flows.md#10-concurrent-edit-conflict-bug-003-fix) | **Tests:** [TC-701](../quality/test-suites.md#tc-701-two-receptionists--conflict-detection)–[TC-705](../quality/test-suites.md#tc-705-concurrent-edit--same-field-by-two-users)
> **Confirmed by:** Alex Kim (Tech Lead), 2024-11-25

https://diashort.apps.quickable.co/e/d1e238bc

---

## Riverside Migration Pipeline
Data flow from EMR export and paper records through validation, dedup, staff review, and import.

> **Tech design:** [Migration Pipeline](tech-design-migration-pipeline.md) | **ADRs:** [ADR-008](adrs.md#adr-008-duplicate-detection-algorithm-for-riverside-migration), [ADR-010](adrs.md#adr-010-migration-pipeline-architecture--batch-import-with-rollback) | **Stories:** [US-012](../product/user-stories.md#us-012-patient-data-migration-from-riverside), [US-013](../product/user-stories.md#us-013-duplicate-patient-detection-and-merge) | **Tests:** [TC-1001](../quality/test-suites.md#tc-1001-emr-import--valid-records)–[TC-1011](../quality/test-suites.md#tc-1011-no-auto-merge-verification)
> **Confirmed by:** Alex Kim (Tech Lead), 2024-12-22

https://diashort.apps.quickable.co/e/342376ce
