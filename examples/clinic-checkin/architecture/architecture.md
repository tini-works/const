# Architecture Overview — Clinic Check-In System

## System Context

A clinic check-in system serving patients (via kiosk and mobile web), receptionists (via dashboard), and administrators (via admin panel). Integrates with existing HIS (Hospital Information System) for medication data and, in later phases, with external EMR systems for data migration.

**Traceability:** This document is the top-level technical reference. It implements all epics ([E1](../product/epics.md#e1-returning-patient-recognition)–[E6](../product/epics.md#e6-compliance--medication-list-at-check-in)). For detailed links, see individual [ADRs](adrs.md), [API spec](api-spec.md), [data model](data-model.md), and tech design documents in this directory.
**Confirmed by:** Alex Kim (Tech Lead), 2024-12-22

---

## High-Level Architecture

```
                         ┌─────────────────────────────────────────────────┐
                         │                  Clients                        │
                         │                                                 │
                         │  ┌──────────┐  ┌──────────┐  ┌──────────────┐  │
                         │  │  Kiosk   │  │  Mobile   │  │ Receptionist │  │
                         │  │  (SPA)   │  │  (Web)    │  │  Dashboard   │  │
                         │  └────┬─────┘  └────┬─────┘  └──────┬───────┘  │
                         └───────┼──────────────┼───────────────┼──────────┘
                                 │              │               │
                              HTTPS          HTTPS           HTTPS
                                 │              │               │
                    ┌────────────┴──────────────┴───────────────┴──────────┐
                    │                   API Gateway / LB                    │
                    │              (TLS termination, rate limiting)         │
                    └────────────────────────┬─────────────────────────────┘
                                             │
              ┌──────────────────────────────┬┴────────────────────────────────┐
              │                              │                                 │
   ┌──────────▼──────────┐     ┌─────────────▼─────────────┐    ┌─────────────▼──────────┐
   │   Check-In Service  │     │   Notification Service    │    │    Migration Service   │
   │                     │     │                           │    │     (Round 10)         │
   │  - Patient lookup   │     │  - WebSocket push to      │    │  - EMR import pipeline │
   │  - Check-in flow    │     │    receptionist dashboard  │    │  - OCR pipeline        │
   │  - Record CRUD      │     │  - SMS/email for mobile   │    │  - Dedup algorithm     │
   │  - Concurrency ctrl │     │    check-in links          │    │  - Merge operations    │
   │  - Medication conf. │     │  - Polling fallback        │    └────────────┬───────────┘
   │  - Insurance data   │     └─────────────┬─────────────┘                 │
   └──────────┬──────────┘                   │                               │
              │                              │                               │
              │         ┌────────────────────┴───────┐                       │
              │         │    Message Broker           │                       │
              │         │    (Redis Pub/Sub)          │                       │
              │         └────────────────────────────┘                       │
              │                                                              │
   ┌──────────▼──────────────────────────────────────────────────────────────▼──┐
   │                         PostgreSQL (Primary)                               │
   │                                                                            │
   │   patients │ appointments │ check_ins │ medications │ insurance │ allergies │
   │   locations │ staff │ audit_log │ migration_records │ ...                   │
   │                                                                            │
   │   + Read Replica(s) for dashboard queries (Round 9)                        │
   └────────────────────────────────────────────────────────────────────────────┘
              │
   ┌──────────▼──────────┐       ┌─────────────────────────┐
   │   Object Storage    │       │   OCR Service            │
   │   (S3 / MinIO)      │       │   (Round 8)              │
   │                     │       │                          │
   │   - Insurance card  │       │   - Extracts fields from │
   │     photos          │       │     card images          │
   │   - Scanned paper   │       │   - Returns structured   │
   │     records         │       │     data + confidence    │
   └─────────────────────┘       └─────────────────────────┘
```

---

## Services

### Check-In Service (Core)

The primary backend service. Handles all patient-facing and staff-facing operations.

> **Implements:** [E1](../product/epics.md#e1-returning-patient-recognition), [E2](../product/epics.md#e2-mobile-check-in), [E3](../product/epics.md#e3-multi-location-support), [E4](../product/epics.md#e4-insurance-card-photo-capture), [E6](../product/epics.md#e6-compliance--medication-list-at-check-in)
> **API:** Sections [1–8 of the API spec](api-spec.md)
> **Monitored by:** [Operations Overview Dashboard](../operations/monitoring-alerting.md#1-operations-overview-primary-dashboard), [Check-In Flow Dashboard](../operations/monitoring-alerting.md#4-check-in-flow-dashboard)
> **Confirmed by:** Alex Kim (Tech Lead), 2024-12-22

**Responsibilities:**
- Patient identification (card scan lookup, name search)
- Patient record CRUD with optimistic locking (version field)
- Check-in flow management (track progress through steps)
- Medication confirmation recording (audit trail for compliance)
- Insurance data management including OCR-extracted fields
- Multi-location awareness (kiosks bound to locations, appointments location-scoped)
- Session management for kiosk (ensuring clean state between patients)

**Tech stack:** Node.js / TypeScript, Express (or Fastify), Prisma ORM

**Key design constraints:**
- All patient record writes must increment the version field (ADR-003)
- Medication confirmations must produce an immutable audit record (ADR-004)
- Patient search must respond within 2 seconds under 50 concurrent sessions (ADR-007)

### Notification Service

Decoupled from the check-in service to avoid blocking the check-in flow on notification delivery.

> **Implements:** [BUG-001 fix](../product/user-stories.md#bug-001-kiosk-confirmation-not-syncing-to-receptionist-screen), [US-007 mobile link delivery](../product/user-stories.md#us-007-pre-visit-check-in-from-personal-device)
> **ADR:** [ADR-001](adrs.md#adr-001-websocket-with-polling-fallback-for-real-time-dashboard-updates)
> **API:** [Section 8 Real-Time Updates](api-spec.md#8-real-time-updates), [Section 6 Mobile Check-In Links](api-spec.md#6-mobile-check-in-links)
> **Monitored by:** [Notification Service metrics](../operations/monitoring-alerting.md#notification-service)
> **Confirmed by:** Priya Patel (Senior Engineer), 2024-10-18

**Responsibilities:**
- Real-time push to receptionist dashboard (WebSocket with polling fallback — ADR-001)
- SMS delivery of mobile check-in links (via Twilio or similar)
- Email delivery of mobile check-in links
- Sync confirmation back to kiosk (the "end-to-end sync proof" for BUG-001 fix)

**How sync confirmation works (BUG-001):**
1. Kiosk submits check-in to Check-In Service
2. Check-In Service saves to DB, publishes event to message broker
3. Notification Service picks up event, pushes to receptionist dashboard via WebSocket
4. Receptionist dashboard acknowledges receipt back through WebSocket
5. Notification Service publishes ack event
6. Check-In Service returns sync status to kiosk: confirmed / timeout / failed

If WebSocket delivery fails, the notification service retries via polling endpoint. The kiosk shows green only after acknowledgment, yellow warning after 5s timeout.

### Migration Service (Round 10)

A separate service for the Riverside acquisition data migration. Not part of the runtime check-in path.

> **Implements:** [E5](../product/epics.md#e5-riverside-practice-acquisition), [US-012](../product/user-stories.md#us-012-patient-data-migration-from-riverside), [US-013](../product/user-stories.md#us-013-duplicate-patient-detection-and-merge)
> **Tech design:** [Migration Pipeline](tech-design-migration-pipeline.md)
> **ADRs:** [ADR-008](adrs.md#adr-008-duplicate-detection-algorithm-for-riverside-migration), [ADR-010](adrs.md#adr-010-migration-pipeline-architecture--batch-import-with-rollback)
> **API:** [Section 9 Migration](api-spec.md#9-migration-round-10)
> **Monitored by:** [Migration Dashboard](../operations/monitoring-alerting.md#5-migration-dashboard-temporary----during-riverside-migration)
> **Confirmed by:** Alex Kim (Tech Lead), 2024-12-22

**Responsibilities:**
- EMR schema mapping and import (Riverside EMR -> our data model)
- Paper record OCR pipeline (scan -> extract -> validate)
- Duplicate detection algorithm (name+DOB, SSN, phone, address matching)
- Confidence scoring for duplicates and OCR fields
- Merge operations with full audit trail
- Migration progress tracking and reporting

**Design rationale:** This is a separate service because migration is a batch operation with different scaling characteristics, failure modes, and lifecycle. It writes to the same database but runs independently of the check-in flow.

### OCR Service (Round 8)

Handles insurance card image processing.

> **Implements:** [E4](../product/epics.md#e4-insurance-card-photo-capture), [US-011](../product/user-stories.md#us-011-photo-capture-of-insurance-card)
> **Tech design:** [OCR Pipeline](tech-design-ocr-pipeline.md)
> **ADR:** [ADR-006](adrs.md#adr-006-ocr-service-as-a-separate-service-behind-a-stable-api-contract)
> **Monitored by:** [OCR Service metrics](../operations/monitoring-alerting.md#ocr-service)
> **Confirmed by:** Priya Patel (Senior Engineer), 2024-12-05

**Responsibilities:**
- Receive card images (front and back)
- Extract structured fields: member ID, group number, payer name, plan type, effective date
- Return extraction results with per-field confidence scores
- Flag low-confidence fields for manual review

**Implementation:** Can be a thin wrapper around a third-party OCR API (Google Vision, AWS Textract) or a self-hosted model. The API contract is the same either way (ADR-006).

---

## Data Flow

### Check-In (Kiosk)

```
Patient scans card
    → Kiosk sends card ID to Check-In Service
    → Service looks up patient by card ID
    → Returns patient record (demographics, insurance, allergies, medications)
    → Patient reviews/edits each section
    → Patient confirms
    → Kiosk POSTs check-in confirmation to Check-In Service
    → Service saves check-in, creates medication audit record, publishes event
    → Notification Service pushes to receptionist dashboard
    → Dashboard acks
    → Service returns sync-confirmed to kiosk
    → Kiosk shows green checkmark
```

### Check-In (Mobile)

```
24h before appointment:
    → Notification Service sends SMS/email with tokenized check-in link
    → Link encodes: appointment ID, patient ID, expiration timestamp

Patient opens link:
    → Mobile web app loads
    → Patient enters DOB + last 4 of phone
    → Check-In Service verifies identity against patient record
    → Returns patient record
    → Patient reviews/edits (same data flow as kiosk)
    → Patient confirms
    → Service saves check-in, publishes event
    → Receptionist dashboard updates (Mobile - Complete)

Patient arrives at kiosk:
    → Scans card
    → Service detects existing mobile check-in for today's appointment
    → Returns "already checked in" status
    → Kiosk shows acknowledgment message
```

### Multi-Location Data Flow

```
Patient record is centralized (single source of truth).
Location is a property of:
    - Appointments (each appointment is at one location)
    - Kiosks (each kiosk is at one location)
    - Staff assignments (each staff member has a default location)

It is NOT a property of:
    - Patient records (patient data is location-agnostic)
    - Allergies, medications, insurance (shared across locations)
```

---

## Infrastructure

### Database

PostgreSQL as the primary datastore. Chosen for:
- Strong transactional guarantees (critical for concurrent edit safety)
- JSON/JSONB support for flexible fields (OCR metadata, migration source data)
- Mature tooling for read replicas

**Read replicas** (added Round 9) serve dashboard queries and patient search to reduce load on the primary during peak hours. Write operations always go to primary.

### Caching (Round 9)

Redis serves dual purpose:
1. **Pub/Sub message broker** — for real-time events between Check-In Service and Notification Service
2. **Query cache** — for patient search results and dashboard data during peak load

Cache invalidation: patient record changes invalidate the relevant cache entries immediately (write-through pattern).

### Object Storage

S3-compatible storage (AWS S3 or MinIO for on-prem) for:
- Insurance card photos (front and back)
- Scanned paper records (Riverside migration)
- Stored as references — the patient record contains a URL/key, not the image data

### Connection Pooling (Round 9)

PgBouncer in front of PostgreSQL to handle 50+ concurrent connections efficiently. The application server connects to PgBouncer, not directly to PostgreSQL.

---

## Security

### PHI Protection
- All data in transit: TLS 1.2+
- All data at rest: AES-256 encryption on database and object storage
- Kiosk session isolation: full DOM/state/cache purge between patients (ADR-002)
- Mobile session: 5-minute inactivity timeout, no PHI cached in browser storage post-completion
- Audit log: all access and modifications to patient records are logged

### Authentication
- Kiosk: card scan + identity confirmation (DOB match). No persistent auth session.
- Mobile: tokenized link + identity verification (DOB + last 4 phone). Token is single-use per appointment, expires at appointment time.
- Staff: standard auth (SSO or credentials), session-based. Permissions scoped per location.

### HIPAA Compliance
- Minimum necessary access principle enforced at API level
- All PHI access logged in audit_log table
- Medication confirmations are immutable audit records
- Breach incident flow defined for data exposure events (BUG-002 class issues)

---

## Scaling Strategy (Round 9)

**Target:** 50 concurrent check-in sessions, p95 response time under 3 seconds.

**Approach:**
1. **Connection pooling** — PgBouncer to multiplex DB connections
2. **Read replicas** — dashboard queries and search go to replica
3. **Query caching** — Redis cache for frequently-accessed patient data and search results
4. **Search optimization** — composite indexes on patient name, DOB, phone; trigram index for fuzzy name search
5. **WebSocket connection management** — per-location channels to limit broadcast scope
6. **API response optimization** — paginated results, field selection, no over-fetching

**Monitoring:** Track p95 response times by endpoint, concurrent session count, DB connection pool utilization, cache hit rate. Alert when approaching 80% of target capacity.
