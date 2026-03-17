# Infrastructure Document — Clinic Check-In System

Last updated: 2026-03-17
Owner: DevOps

---

## Overview

The clinic check-in system runs on cloud-hosted infrastructure serving two clinic locations, kiosk terminals, mobile web clients, and staff dashboards. This document describes every deployed component, its configuration, and how to rebuild from scratch.

---

## Network Topology

```
Internet
    │
    ▼
┌─────────────────────────────────────────────────────┐
│  CDN / Edge (Cloudflare or AWS CloudFront)          │
│  - TLS termination for static assets                │
│  - DDoS protection                                  │
│  - WAF rules for OWASP top 10                       │
└──────────────────────┬──────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────┐
│  Load Balancer (ALB / nginx)                        │
│  - TLS 1.2+ termination for API traffic             │
│  - Health checks: GET /health (5s interval, 3 fail) │
│  - Rate limiting: 100 req/s per IP                  │
│  - WebSocket upgrade support on /ws/*               │
│  - Sticky sessions: OFF (app is stateless)          │
│                                                     │
│  Listeners:                                         │
│    443 → Check-In Service (port 3000)               │
│    443/ws → Notification Service (port 3001)        │
│    443/migration → Migration Service (port 3002)    │
└──────────────────────┬──────────────────────────────┘
                       │
          ┌────────────┼────────────────┐
          │            │                │
          ▼            ▼                ▼
    ┌──────────┐ ┌──────────┐   ┌──────────────┐
    │ Check-In │ │ Notif.   │   │  Migration   │
    │ Service  │ │ Service  │   │  Service     │
    │ (2 inst) │ │ (1 inst) │   │  (1 inst)    │
    └────┬─────┘ └────┬─────┘   └──────┬───────┘
         │            │                │
         └────────────┼────────────────┘
                      │
              ┌───────┴───────┐
              │               │
              ▼               ▼
        ┌──────────┐    ┌──────────┐
        │ PgBouncer│    │  Redis   │
        │ (pooler) │    │ (cache + │
        │          │    │  pubsub) │
        └────┬─────┘    └──────────┘
             │
     ┌───────┴───────┐
     │               │
     ▼               ▼
┌──────────┐  ┌──────────────┐
│ PG       │  │ PG Read      │
│ Primary  │  │ Replica      │
│ (RW)     │──│ (RO)         │
└──────────┘  └──────────────┘
             WAL streaming
```

---

## Compute — Application Services

### Check-In Service (Core)

| Property | Value |
|----------|-------|
| Runtime | Node.js 20 LTS, TypeScript |
| Framework | Fastify |
| ORM | Prisma |
| Port | 3000 |
| Instances | 2 (min), 4 (max, auto-scale) |
| CPU | 2 vCPU per instance |
| Memory | 4 GB per instance |
| Health endpoint | `GET /health` returns `{"status":"ok","version":"x.y.z"}` |
| Deployment | Container (Docker), orchestrated via ECS/K8s |
| Environment | See [Environment Guide](./environment-guide.md) |

Handles: patient lookup, check-in flow, record CRUD, medication confirmation, insurance data, OCR job dispatch, session isolation enforcement.

Auto-scale trigger: CPU > 70% sustained for 2 minutes, or active connections > 150.

### Notification Service

| Property | Value |
|----------|-------|
| Runtime | Node.js 20 LTS, TypeScript |
| Port | 3001 |
| Instances | 1 (sufficient for current scale) |
| CPU | 1 vCPU |
| Memory | 2 GB |
| Health endpoint | `GET /health` |
| WebSocket | `/ws/dashboard/{location_id}` |

Handles: WebSocket push to receptionist dashboards, SMS/email delivery (Twilio, SendGrid), sync acknowledgment relay, polling fallback.

WebSocket config:
- Heartbeat ping: every 30s
- Pong timeout: 10s (connection dropped if no pong)
- Max connections per location: 20
- Reconnect backoff: exponential, 1s-30s

### Migration Service

| Property | Value |
|----------|-------|
| Runtime | Node.js 20 LTS, TypeScript |
| Port | 3002 |
| Instances | 1 (batch workload, not latency-sensitive) |
| CPU | 2 vCPU |
| Memory | 4 GB (handles large batch processing in memory) |
| Health endpoint | `GET /health` |

Handles: EMR schema mapping, batch import pipeline, duplicate detection, merge operations, rollback.

**Not on the critical path.** This service can be stopped during peak clinic hours without affecting check-in operations. Consider running migration batches during off-hours (after 6 PM).

### OCR Service

| Property | Value |
|----------|-------|
| Runtime | Node.js 20 LTS (thin wrapper) |
| Port | 3003 |
| Instances | 1 |
| CPU | 1 vCPU |
| Memory | 2 GB |
| External dependency | Google Cloud Vision API |
| Health endpoint | `GET /health` |

Handles: insurance card OCR, paper record OCR (Riverside migration). Wraps Google Cloud Vision; the service itself does field extraction and confidence scoring from the raw OCR text.

Failure mode: if Google Vision is unavailable, OCR requests fail gracefully. Patients fall back to manual entry. This is by design (OCR is an accelerator, not a gatekeeper).

---

## Database — PostgreSQL

### Primary

| Property | Value |
|----------|-------|
| Engine | PostgreSQL 16 |
| Instance type | db.r6g.large (2 vCPU, 16 GB RAM) or equivalent |
| Storage | 100 GB GP3 SSD, auto-expand enabled |
| Max connections | 200 (PgBouncer handles pooling) |
| Encryption at rest | AES-256 (KMS-managed key) |
| Backup | Automated daily snapshot, 30-day retention |
| Point-in-time recovery | Enabled, 7-day window |
| Maintenance window | Sunday 03:00-04:00 UTC |
| Availability | Multi-AZ (standby in second AZ for failover) |

Key parameters:
```
shared_buffers = 4GB
effective_cache_size = 12GB
work_mem = 64MB
maintenance_work_mem = 512MB
max_connections = 200
wal_level = replica
max_wal_senders = 5
max_replication_slots = 5
```

### Read Replica

| Property | Value |
|----------|-------|
| Engine | PostgreSQL 16 (streaming replication) |
| Instance type | db.r6g.large (same as primary) |
| Replication | Asynchronous WAL streaming |
| Lag target | < 1 second |
| Lag alert | > 2 seconds = critical |
| Purpose | Dashboard queries, patient search, reporting |

**Write routing:** All writes go to primary. Application code uses `getDbClient('read' | 'write')` to route. Read replica is never used for check-in writes, version checks, or medication confirmations.

### PgBouncer (Connection Pooler)

| Property | Value |
|----------|-------|
| Version | 1.22+ |
| Port | 6432 |
| Pool mode | Transaction |
| Default pool size | 25 |
| Max client connections | 200 |
| Reserve pool size | 5 |
| Reserve pool timeout | 3s |
| Server idle timeout | 600s |
| Query timeout | 30s |

Application services connect to PgBouncer on port 6432, not directly to PostgreSQL on 5432. PgBouncer is deployed on the same host/container as the primary database.

### Database Schema

17 tables across 4 functional groups:

**Core:** `patients`, `locations`, `kiosks`, `staff`, `staff_locations`, `appointments`
**Check-in:** `check_ins`, `medication_confirmations`
**Clinical:** `allergies`, `medications`, `insurance_records`
**Audit:** `audit_log`, `patient_record_versions`
**Migration:** `migration_batches`, `migration_records`, `duplicate_candidates`

Key indexes:
- `idx_patients_card_id` — kiosk card scan lookup
- `idx_patients_last_first` — name search (prefix)
- `idx_patients_name_trgm` — fuzzy name search (trigram GIN)
- `idx_patients_dob` — duplicate detection first filter
- `idx_appointments_location_date` — dashboard queue
- `idx_checkins_appointment` — check-in lookup
- `idx_audit_entity`, `idx_audit_time` — audit queries

Extensions: `pg_trgm` (fuzzy text search), `pgcrypto` (gen_random_uuid).

---

## Cache / Message Broker — Redis

| Property | Value |
|----------|-------|
| Engine | Redis 7 |
| Instance type | cache.r6g.large (2 vCPU, 13 GB) or equivalent |
| Port | 6379 |
| Max memory | 8 GB |
| Eviction policy | `allkeys-lru` |
| Persistence | AOF with 1s fsync (data survives restart) |
| Encryption in transit | TLS |

Serves two purposes:

**1. Pub/Sub message broker:**
- Channel: `checkin:{location_id}` — check-in status events
- Channel: `sync:{check_in_id}` — sync acknowledgment from dashboard
- Publishers: Check-In Service
- Subscribers: Notification Service

**2. Query cache:**

| Key Pattern | TTL | Size estimate |
|------------|-----|---------------|
| `queue:{location_id}:{date}` | 30s | ~50 KB per location |
| `patient:{id}:summary` | 5 min | ~1 KB per patient |
| `search:{query_hash}` | 30s | ~5 KB per query |
| `dashboard:stats:{location_id}` | 10s | ~200 bytes |

Total cache footprint: < 100 MB (well within 8 GB allocation).

---

## Object Storage — S3

| Property | Value |
|----------|-------|
| Bucket | `clinic-checkin-files` |
| Provider | AWS S3 (production) / MinIO (dev/staging) |
| Region | Same as compute (us-east-1 or equivalent) |
| Encryption | SSE-S3 (AES-256) |
| Versioning | Enabled |
| Public access | Blocked (all objects private) |
| Access method | Presigned URLs (15-minute expiry) |

Directory structure:
```
clinic-checkin-files/
├── insurance-cards/
│   └── {patient_id}/
│       ├── {timestamp}-front.jpg
│       └── {timestamp}-back.jpg
├── scanned-records/
│   └── {batch_id}/
│       └── {source_id}-page{n}.pdf
└── ocr-results/
    └── {processing_id}.json
```

Lifecycle rules:
- `insurance-cards/`: no expiration (retained indefinitely)
- `scanned-records/`: transition to IA storage after 90 days, retain for migration + 1 year regulatory hold
- `ocr-results/`: expire after 90 days (debugging/reprocessing cache)

Estimated storage: ~50 GB initial (4,000 migration documents + ongoing insurance card photos at ~2 MB each).

---

## External Services

| Service | Purpose | Credentials |
|---------|---------|-------------|
| Twilio | SMS delivery for mobile check-in links | API key in Secrets Manager |
| SendGrid | Email delivery for mobile check-in links | API key in Secrets Manager |
| Google Cloud Vision | OCR extraction for insurance cards and paper records | Service account key in Secrets Manager |

Failure of any external service does not block check-in. SMS/email failure = patient doesn't get mobile link (can still use kiosk). OCR failure = patient enters insurance info manually.

---

## Networking

### DNS

| Record | Target |
|--------|--------|
| `api.clinic-checkin.example.com` | Load Balancer |
| `checkin.clinic.example.com` | CDN (mobile web SPA) |
| `dashboard.clinic.example.com` | CDN (receptionist SPA) |

### Ports (Internal)

| Service | Port |
|---------|------|
| Check-In Service | 3000 |
| Notification Service | 3001 |
| Migration Service | 3002 |
| OCR Service | 3003 |
| PgBouncer | 6432 |
| PostgreSQL Primary | 5432 |
| PostgreSQL Replica | 5432 |
| Redis | 6379 |

### Security Groups / Firewall

| Source | Destination | Port | Protocol |
|--------|-------------|------|----------|
| Internet | Load Balancer | 443 | HTTPS |
| Load Balancer | App services | 3000-3003 | HTTP |
| App services | PgBouncer | 6432 | TCP |
| PgBouncer | PostgreSQL Primary | 5432 | TCP |
| PostgreSQL Primary | PostgreSQL Replica | 5432 | TCP (replication) |
| App services | Redis | 6379 | TCP/TLS |
| App services | S3 | 443 | HTTPS |
| OCR Service | Google Vision API | 443 | HTTPS |
| Notification Service | Twilio/SendGrid | 443 | HTTPS |

All inter-service traffic stays within the VPC. No service is directly reachable from the internet except the load balancer.

---

## Clinic Site Infrastructure

### Kiosks (per location)

Each clinic location has 2-4 kiosk terminals.

| Component | Spec |
|-----------|------|
| Hardware | Tablet (iPad or Android) or all-in-one touchscreen PC |
| Browser | Chrome (kiosk mode, auto-launch on boot) |
| Network | Wired ethernet (preferred) or clinic WiFi |
| Card reader | USB HID-mode card reader (barcode or magnetic stripe) |
| Connectivity | HTTPS to api.clinic-checkin.example.com |

Kiosk configuration is pushed via MDM (Mobile Device Management). Chrome is locked to the check-in URL with no address bar, no navigation, auto-restart on crash.

**Network dependency:** If internet connectivity is lost, the kiosk shows "System temporarily unavailable, please see the receptionist." There is no offline mode.

### Receptionist Workstations

Standard clinic PCs running Chrome. Dashboard accessed via `https://dashboard.clinic.example.com`. WebSocket connection maintained for real-time updates, automatic fallback to 5s polling if WebSocket drops.

---

## Capacity Planning

### Current State (2 locations)

| Resource | Current Usage | Capacity | Headroom |
|----------|--------------|----------|----------|
| Check-In Service instances | 2 | 4 (auto-scale) | 2x |
| DB connections (via PgBouncer) | ~15 peak | 25 pool | 40% |
| PostgreSQL storage | ~5 GB | 100 GB | 95% |
| Redis memory | ~50 MB | 8 GB | 99% |
| S3 storage | ~2 GB | unlimited | N/A |
| Peak concurrent sessions | ~30 | 50 target | 40% |

### Growth Triggers

| Trigger | Action |
|---------|--------|
| 3rd location opens | Add Check-In Service instance, evaluate Notification Service scaling |
| 5+ locations | Re-evaluate single-database architecture, consider regional replicas |
| 100+ concurrent sessions | Horizontal scale Check-In Service, increase PgBouncer pool, add Redis cluster |
| S3 > 500 GB | Review lifecycle policies, consider Glacier for old scanned records |
| Riverside migration complete | Shut down Migration Service, retain database tables for audit |

---

## Disaster Recovery

| Component | RPO | RTO | Mechanism |
|-----------|-----|-----|-----------|
| PostgreSQL | 1 second | < 15 min | Multi-AZ failover (automated) |
| PostgreSQL data | 24 hours | < 1 hour | Daily snapshots + PITR |
| Redis | Acceptable loss | < 5 min | Cache rebuild from DB on restart |
| S3 | 0 | 0 | 99.999999999% durability (AWS managed) |
| Application services | N/A | < 5 min | Container restart / new instance launch |

Redis is a cache, not a source of truth. Losing Redis causes a temporary performance degradation (cache cold start) but no data loss. All persistent state is in PostgreSQL and S3.
