# Reconciliation Log — Design (Experience)

Tracks when upstream changes (bugs, new features, architecture shifts) required re-evaluation of Design artifacts. Each entry records what changed, what was impacted, and the outcome.

---

## Entry 1: BUG-002 Session Isolation — Screen and Flow Reevaluation

**Date:** 2024-02-15
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

## Entry 2: BUG-001 Sync Failure — Confirmation Screen and Dashboard Sync

**Date:** 2024-10-15
**Change:** [BUG-001](../product/user-stories.md#bug-001-kiosk-confirmation-not-syncing-to-receptionist-screen) (kiosk confirmation not syncing to receptionist screen). Architecture introduced [ADR-001](../architecture/adrs.md#adr-001-websocket-with-polling-fallback-for-real-time-dashboard-updates) (WebSocket with ack + polling fallback).

**Impact on Design:**
- Design Decision **DD-002** created: green checkmark gated on end-to-end sync proof, not just kiosk-side save
- Screen 1.8 (Confirmation) updated: three outcome states (sync confirmed → green, sync timeout → yellow warning, save failed → red error)
- Flow 5 (Kiosk-to-Receptionist Sync) created to document the end-to-end sync verification sequence
- Interaction spec Section 1.5 rewritten: "Confirm and check in" now waits for receptionist-side confirmation

**Items reevaluated:**
- screen-specs.md: Screen 1.8 updated with sync states (green/yellow/red)
- interaction-specs.md: Section 1.5 (check-in confirmation submit) rewritten
- flow-diagrams.md: Kiosk-to-Receptionist Sync diagram added
- design-decisions.md: DD-002 added

**Result:** No false green checkmarks. Patient sees honest status — green only when the receptionist dashboard has confirmed receipt.

**Assessed by:** Jamie Park (Design Lead), 2024-10-15

---

## Entry 3: Round 3 Mobile Check-In — New Surface and Interaction Patterns

**Date:** 2024-10-28
**Change:** [E2](../product/epics.md#e2-mobile-check-in) (Mobile Check-In) — patients check in from personal devices via SMS/email link. Architecture added [POST /patients/verify-identity](../architecture/api-spec.md#post-patientsverify-identity), [POST /mobile-checkin/send-link](../architecture/api-spec.md#post-mobile-checkinsend-link), mobile check-in endpoints.

**Impact on Design:**
- Screens 3.1–3.3 created: Mobile Link Landing / Identity Verification, Mobile Review Screens, Mobile Confirmation
- Design Decision **DD-004** created: one-step-per-screen on mobile (not a single long form like kiosk)
- Design Decision **DD-005** created: bottom-sheet editing on mobile, inline editing on kiosk
- Design Decision **DD-011** created: 5-minute mobile session timeout with 1-minute warning
- Mobile interaction specs added: link open → identity verification, step navigation, mobile edit sheets, session security
- Component 2 (Progress Indicator) extended with mobile dot variant

**Items reevaluated:**
- screen-specs.md: Screens 3.1, 3.2, 3.3 created
- interaction-specs.md: Section 3 (Mobile Check-In Interactions) created with subsections 3.1–3.5
- component-inventory.md: Component 2 mobile variant added
- design-decisions.md: DD-004, DD-005, DD-011 added

**Result:** Complete mobile check-in surface with patterns adapted for small screens. Bottom sheets for editing, simplified progress dots, step-based navigation.

**Assessed by:** Jamie Park (Design Lead), 2024-10-28

---

## Entry 4: Round 5 Multi-Location — Dashboard Location Selector

**Date:** 2024-11-12
**Change:** [E3](../product/epics.md#e3-multi-location-support) (Multi-Location Support) — second clinic location opening, patients visit both. Architecture introduced [ADR-005](../architecture/adrs.md#adr-005-centralized-database-for-multi-location-no-replication) (centralized database). API spec updated: `GET /dashboard/queue` now accepts `location_id` parameter.

**Impact on Design:**
- Screen 2.1 (Receptionist Dashboard) updated: location selector dropdown added to top bar
- Component 11 (Location Selector) created: dropdown with current location, other locations, and "All Locations" option
- Design Decision **DD-012** created: search always searches all locations regardless of queue filter
- Interaction spec Section 2.4 (Location Switching) added: fade transition, location memory, cross-location search behavior

**Items reevaluated:**
- screen-specs.md: Screen 2.1 updated with location selector in top bar
- component-inventory.md: Component 11 (Location Selector) created
- interaction-specs.md: Section 2.4 added
- design-decisions.md: DD-012 added

**Result:** Dashboard supports multi-location with a simple selector. Search is always cross-location. Queue filter defaults to the staff member's assigned location.

**Assessed by:** Sarah Chen (PM), 2024-11-12

---

## Entry 5: Round 6 Medications — Mandatory Step Design

**Date:** 2024-11-20
**Change:** [US-005](../product/user-stories.md#us-005-medication-list-confirmation-at-check-in), [E6](../product/epics.md#e6-compliance--medication-list-at-check-in) (Medication List Confirmation) — state health board mandate requiring medication confirmation at every visit. Architecture introduced [ADR-004](../architecture/adrs.md#adr-004-immutable-medication-confirmation-audit-records) (immutable medication confirmation audit records).

**Impact on Design:**
- Screen 1.7 (Medications Review) created: mandatory step in kiosk check-in flow with "I've reviewed my medications — Continue" for unchanged lists
- Design Decision **DD-003** created: medications step is non-skippable but designed to be fast (one-tap for unchanged lists)
- Component 4 (Medication Card) created: default, editing, and empty states with medication name, dosage, frequency

**Items reevaluated:**
- screen-specs.md: Screen 1.7 created
- component-inventory.md: Component 4 (Medication Card) created
- design-decisions.md: DD-003 added
- interaction-specs.md: Section 1.4 (allergy and medication list interactions) updated

**Result:** Mandatory medication confirmation step that meets regulatory requirements with minimal patient friction. One-tap confirmation for unchanged lists. Immutable audit records for compliance inspection.

**Assessed by:** Sarah Chen (PM), 2024-11-20

---

## Entry 6: BUG-003 Concurrent Edit Handling — New Screens and Components

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

## Entry 7: Round 8 Photo Capture — Insurance Card Camera Flow

**Date:** 2024-12-15
**Change:** [E4](../product/epics.md#e4-insurance-card-photo-capture) (Insurance Card Photo Capture) — patients photograph insurance cards at kiosk or on mobile. Architecture introduced [ADR-006](../architecture/adrs.md#adr-006-ocr-service-as-a-separate-service-behind-a-stable-api-contract) (OCR service behind stable API contract), [ADR-009](../architecture/adrs.md#adr-009-object-storage-for-insurance-card-photos-and-scanned-records) (object storage for photos). New API endpoints: `POST /patients/{id}/insurance/{type}/photo`, `GET /patients/{id}/insurance/{type}/photo/status/{processing_id}`.

**Impact on Design:**
- Screen 1.5a (Insurance Card Photo Capture Overlay) created: camera viewfinder with card guide overlay, guided front/back capture
- Design Decision **DD-005** extended: bottom-sheet camera on mobile, full-screen overlay on kiosk
- Component 13 (Photo Capture Viewfinder) created: kiosk landscape and mobile portrait variants with card outline guide
- Component 3 (Editable Section Card) updated: OCR-derived state (blue background) and OCR low-confidence state (yellow background) variants added
- Interaction spec Section 3.4 (Insurance Photo Capture on Mobile) added

**Items reevaluated:**
- screen-specs.md: Screen 1.5a created; Screen 1.5 (Insurance Review) updated with OCR processing state
- component-inventory.md: Component 13 created; Component 3 updated with OCR states
- interaction-specs.md: Section 3.4 added (mobile photo capture flow)
- design-decisions.md: DD-005 extended

**Result:** Complete insurance card photo capture flow on both kiosk and mobile. OCR extracts structured fields with per-field confidence scores. Low-confidence fields highlighted for patient verification.

**Assessed by:** Jamie Park (Design Lead), 2024-12-15

---

## Entry 8: Round 9 Performance — Degraded Mode Screens

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

## Entry 9: Round 10 Riverside Migration — Admin Screens and Migration Notice

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
