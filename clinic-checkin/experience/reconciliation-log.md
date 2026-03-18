# Reconciliation Log — Design (Experience)

Tracks when upstream changes (bugs, new features, architecture shifts) required re-evaluation of Design artifacts. Each entry records what changed, what was impacted, and the outcome.

---

## Entry 1: BUG-002 Session Isolation — Screen and Flow Reevaluation

**Date:** 2024-11-05
**Change:** [BUG-002](../product/user-stories.md#bug-002-data-leak--previous-patients-data-visible-on-scan) (P0 data leak) — previous patient's data briefly visible on kiosk during sequential scans. Architecture introduced [ADR-002](../architecture/adrs.md#adr-002-session-purge-protocol-for-kiosk-state-isolation) (Session Purge Protocol with 800ms transition screen).

**Impact on Design:**
- New screen required: **Screen 1.2 (Session Transition Screen)** — added as a mandatory visual barrier between patient sessions
- Screen 1.1 (Kiosk Welcome) updated: added security note about session purge before any patient data rendering
- Screen 1.8 (Confirmation) updated: auto-return countdown added with session purge on expiry
- Screen 1.10 (Kiosk Idle Timeout) added: ensures abandoned sessions are purged
- Design Decision **DD-001** created: transition screen is a designed safety net, not just a tech fix
- Design Decision **DD-009** created: visible, interruptible countdown after check-in success

**Items reevaluated:**
- screen-specs.md: Screens 1.1, 1.3, 1.8 (security notes added); Screen 1.2 created; Screen 1.10 created
- user-flows.md: Flow 4 (Data Leak Prevention) created
- interaction-specs.md: Section 1.1 (session lifecycle) rewritten; Section 1.2 (rapid sequential scans) added; Section 1.6 (auto-return) added
- flow-diagrams.md: Kiosk Check-In Flow diagram updated to include transition screen and purge paths

**Result:** All kiosk screens now route through the session transition screen. No direct transition between patient data states. Defense-in-depth: design layer guarantees isolation even if code-layer purge has a race condition.

**Assessed by:** Jamie Park (Design Lead), 2024-11-05

---

## Entry 2: BUG-003 Concurrent Edit Handling — New Screens and Components

**Date:** 2024-12-10
**Change:** [BUG-003](../product/user-stories.md#bug-003-concurrent-edit-causes-silent-data-loss) (concurrent receptionist edits causing silent data loss). Architecture introduced [ADR-003](../architecture/adrs.md#adr-003-optimistic-concurrency-control-via-version-field) (optimistic concurrency via version field). API spec updated: `PATCH /patients/{id}` now requires `version` field, returns 409 with `conflicting_changes` on conflict.

**Impact on Design:**
- Screen 2.2 (Patient Detail Side Panel) updated: added concurrency handling section with conflict banner spec
- Component 7 (Conflict Banner) created: yellow warning with change diff and resolution actions
- Design Decision **DD-008** created: rejected "currently being edited by" indicator in favor of conflict-at-save-time
- Interaction spec Section 2.3 rewritten: full conflict detection and resolution flow

**Items reevaluated:**
- screen-specs.md: Screen 2.2 — concurrency handling section added, conflict banner spec with ASCII mockup
- component-inventory.md: Component 7 (Conflict Banner) created
- interaction-specs.md: Section 2.3 (editing patient record) rewritten with optimistic concurrency flow, conflict resolution flow, concurrent panel open edge case
- user-flows.md: Flow 10 (Concurrent Edit Conflict) created
- flow-diagrams.md: Concurrent Edit Conflict Resolution diagram added
- design-decisions.md: DD-008 added

**Result:** No silent data loss. Every version conflict is surfaced at save time with clear information about what changed and resolution options. Normal (non-conflicting) editing experience is unchanged.

**Assessed by:** Jamie Park (Design Lead), 2024-12-10

---

## Entry 3: Round 9 Performance — Degraded Mode Screens

**Date:** 2024-12-18
**Change:** [US-006](../product/user-stories.md#us-006-peak-hour-check-in-performance) performance requirements formalized. Architecture introduced [ADR-007](../architecture/adrs.md#adr-007-scaling-strategy-for-50-concurrent-sessions) (scaling strategy for 50 concurrent sessions). PM set target: p95 under 3 seconds, system must never freeze.

**Impact on Design:**
- Section 5 (Loading & Degraded States) added to screen-specs.md: loading states, slow backend behavior, unreachable backend behavior, skeleton screens
- Component 8 (Skeleton Screen / Shimmer Loader) created
- Component 9 (Connection Status Indicator) created
- Design Decision **DD-007** created: skeleton screens instead of spinners for data loading
- Interaction spec Section 5 (Performance-Related Interactions) added: search debouncing, optimistic UI updates, dashboard virtualization, connection quality indicator

**Items reevaluated:**
- screen-specs.md: Screen 1.9 (Name Search) — performance note added (2s search target, spinner after 500ms); Section 5 (5.1-5.4) created
- component-inventory.md: Components 8 and 9 created
- interaction-specs.md: Section 5 added (5.1 search debouncing, 5.2 optimistic UI, 5.3 pagination, 5.4 connection quality)
- user-flows.md: Flow 15 (Peak Load Degraded Experience) created
- design-decisions.md: DD-007 added

**Result:** Every screen has a defined behavior under slow and unreachable conditions. No screen ever freezes. Loading states are skeleton-based (perceived performance). Connection quality is surfaced to the user when degraded.

**Assessed by:** Jamie Park (Design Lead), 2024-12-18

---

## Entry 4: Round 10 Riverside Migration — Admin Screens and Migration Notice

**Date:** 2024-12-22
**Change:** [E5](../product/epics.md#e5-riverside-practice-acquisition) (Riverside Practice Acquisition) — 4,000 patient records to import. Architecture introduced [ADR-008](../architecture/adrs.md#adr-008-duplicate-detection-algorithm-for-riverside-migration) (duplicate detection algorithm), [ADR-009](../architecture/adrs.md#adr-009-object-storage-for-insurance-card-photos-and-scanned-records) (object storage for scanned records), [ADR-010](../architecture/adrs.md#adr-010-migration-pipeline-architecture--batch-import-with-rollback) (migration pipeline with rollback). New API endpoints for migration batches, records, and duplicate resolution.

**Impact on Design:**
- Screen 4.1 (Admin Migration Dashboard) created: summary stats, progress bar, filterable record list, batch actions
- Screen 4.2 (Admin Duplicate Review) created: side-by-side comparison, field-level merge controls, confidence score display
- Component 12 (Confidence Score Badge) created
- Component 14 (Migration Notice Banner) created
- Component 4 (Medication Card) updated: migrated data state variant added
- Design Decision **DD-006** created: side-by-side comparison over diff list for duplicate review
- Design Decision **DD-010** created: migration notice is informational, not alarming
- Design Decision **DD-013** created: confidence scores visible but not decisive

**Items reevaluated:**
- screen-specs.md: Screens 4.1, 4.2 created; existing kiosk review screens (1.4-1.7) evaluated for migration notice placement
- component-inventory.md: Components 4 (migrated data variant), 12, 14 created
- user-flows.md: Flows 13 (First Visit After Migration), 14 (Duplicate Detection Staff Review) created
- flow-diagrams.md: Riverside Migration Pipeline diagram added
- design-decisions.md: DD-006, DD-010, DD-013 added

**Result:** Complete admin workflow for migration management. Patient-facing experience handles migrated records gracefully with informational notice and field-level confidence highlighting. No auto-merge — every duplicate requires explicit staff confirmation.

**Assessed by:** Sarah Chen (PM), 2024-12-22
