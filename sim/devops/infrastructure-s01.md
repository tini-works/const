# Infrastructure — Rounds 1-10

## Deployment Topology

```
                              +-----------+
                              |   CDN /   |
                              | Static    |
                              | Assets    |
                              +-----+-----+
                                    |
                         +----------v-----------+
                         |    Load Balancer      |
                         |  (TLS termination)    |
                         +----------+-----------+
                                    |
               +--------------------+--------------------+
               |                                         |
     +---------v---------+               +---------------v-----------+
     |    API Gateway     |               |   WebSocket Server (2+)   |
     |  (auth, routing,   |               |   (session-scoped          |
     |   rate limiting,   |               |    connections,            |
     |   circuit breaker) |               |    heartbeat, fallback)   |
     +--------+----------+               +---------------+-----------+
              |                                           |
     +--------v-------------------------------------------v----------+
     |                     Service Mesh                               |
     |                                                                 |
     |  +----------------+  +----------------+  +------------------+  |
     |  | Patient Service|  | Check-in       |  | Search           |  |
     |  | (2 instances)  |  | Service (2-4)  |  | Service (2)      |  |
     |  +-------+--------+  +-------+--------+  +--------+--------+  |
     |          |                    |                     |           |
     |  +-------v--------+  +-------v---------+  +-------v--------+  |
     |  | Notification   |  | OCR             |  | Migration       |  |
     |  | Service (1)    |  | Service (1-2)   |  | Service (1)     |  |
     |  +----------------+  +-----------------+  +-----------------+  |
     |                                                                 |
     +---------+---------------------+-------------------+-------------+
               |                     |                   |
     +---------v---------------------v---+       +-------v--------+
     |        PostgreSQL                 |       | Elasticsearch  |
     |  primary + read replica (S-09)    |       | (3-node)       |
     |  schemas: patient, checkin        |       +----------------+
     +-----------------------------------+
               |                   |
     +---------v---------+  +-----v-----------+
     |    Redis           |  | Object Storage  |
     |  (Streams + Cache) |  | (S3-compat,     |
     |  primary + replica |  |  PHI encrypted) |
     +--------------------+  +-----------------+
```

## Component Inventory

| Component | Instances (prod) | Stateful | Persistent Volume | Port | Health Endpoint |
|-----------|-----------------|----------|-------------------|------|-----------------|
| API Gateway | 2 (HA) | No | No | 443 (external), 8080 (internal) | `GET /health` |
| Patient Service | 2 | No | No | 8081 | `GET /health` |
| Check-in Service | 2-4 (HPA) | No | No | 8082 | `GET /health` |
| Search Service | 2 | No | No | 8083 | `GET /health` |
| WebSocket Server | 2+ (HPA) | In-memory (connections) | No | 8084 | `GET /health` + `/ws/health` |
| Notification Service | 1 | No | No | 8085 | `GET /health` |
| OCR Service | 1-2 (HPA) | No | No | 8086 | `GET /health` |
| Migration Service | 1 | No | No | 8087 | `GET /health` |
| PostgreSQL | 1 primary + 1 read replica | Yes | Yes (encrypted) | 5432 | pg_isready |
| Elasticsearch | 3-node cluster | Yes | Yes | 9200 | `GET /_cluster/health` |
| Redis (Streams + Cache) | 1 primary + 1 replica | Yes | Yes (AOF) | 6379 | `redis-cli ping` |
| Object Storage | Managed (S3-compatible) | Yes | N/A (managed) | 443 | Provider health |
| Load Balancer | Managed (cloud) | No | No | 443 | Cloud health check |

### New Services (Rounds 3, 8, 10)

**Notification Service (S-03):**
- Polls appointment schedule, generates pre-check-in links, sends SMS/email.
- Integrations: SMS gateway (Twilio or equivalent), email service (SES or equivalent).
- Low resource footprint. Single instance sufficient — work is cron-driven, not request-driven.
- Requires outbound network access to SMS/email providers (NAT gateway or egress rules).

**OCR Service (S-08):**
- Receives image processing requests from Check-in Service (internal).
- Calls external Cloud OCR API (AWS Textract / Azure Form Recognizer).
- Requires HIPAA BAA with cloud OCR provider (BOX-E7).
- Async pipeline: job queue pattern. Image in Object Storage -> OCR API -> result back to Check-in Service.
- Scales with photo upload volume. HPA based on queue depth.
- Requires outbound network access to OCR provider API.

**Migration Service (S-10):**
- Batch import pipeline. NOT exposed via API Gateway — admin-only internal service.
- Reads source data (file upload or direct DB extract from Riverside EHR).
- Writes to Patient Service via internal API (throttled at 10 records/second).
- Single instance. Long-running batch jobs. Must handle restarts gracefully (idempotent on source_id).
- Temporary service — decommission after Riverside migration complete.

## Compute Requirements

| Component | CPU (request/limit) | Memory (request/limit) | HPA Trigger | Notes |
|-----------|--------------------|-----------------------|-------------|-------|
| API Gateway | 250m / 500m | 256Mi / 512Mi | CPU > 70% | Mostly I/O bound |
| Patient Service | 250m / 500m | 256Mi / 512Mi | — | Staleness computed at read time — CPU spikes on bulk reads |
| Check-in Service | 500m / 1000m | 512Mi / 1024Mi | CPU > 60%, active sessions > 25 | Write-heavy. **S-09: HPA scales 2->4 instances during peak** |
| Search Service | 250m / 500m | 256Mi / 512Mi | — | Reads from ES/cache. Low compute |
| WebSocket Server | 250m / 500m | 256Mi / 1024Mi | Active connections > 150 | Memory scales with connections. Budget 50KB/connection. **S-09: HPA scales based on connection count** |
| Notification Service | 100m / 250m | 128Mi / 256Mi | — | Cron-driven. Low resource |
| OCR Service | 250m / 500m | 256Mi / 512Mi | Queue depth > 10 | Burst during peak check-in. Most compute is offloaded to cloud OCR API |
| Migration Service | 500m / 1000m | 512Mi / 1024Mi | — | CPU during dedup (Levenshtein computation). Memory during batch processing |
| PostgreSQL | 1000m / 2000m | 2Gi / 4Gi | — | **S-09: primary. See read replica below** |
| PostgreSQL (replica) | 1000m / 2000m | 2Gi / 4Gi | — | **S-09: read replica for search-related queries** |
| Elasticsearch | 1000m / 2000m | 2Gi / 4Gi | — | Per node. Heap = 50% of memory |
| Redis | 500m / 1000m | 1Gi / 2Gi | — | AOF persistence. **S-09: also serves as cache layer (separate DB)** |
| Object Storage | Managed | Managed | — | S3-compatible. No compute sizing needed |

### Horizontal Pod Autoscaler (HPA) Config — S-09

| Service | Min Replicas | Max Replicas | Scale-Up Trigger | Scale-Down Delay |
|---------|-------------|-------------|-----------------|-----------------|
| Check-in Service | 2 | 4 | CPU > 60% OR custom metric: active sessions > 25 per instance | 10 minutes (avoid flapping during Monday morning rush) |
| WebSocket Server | 2 | 4 | Custom metric: active connections > 150 per instance | 10 minutes (connection draining needed) |
| OCR Service | 1 | 2 | Custom metric: OCR queue depth > 10 | 5 minutes |

## Storage

| Store | Encryption | Backup Frequency | Retention | Recovery Point Objective |
|-------|-----------|------------------|-----------|------------------------|
| PostgreSQL (patient schema) | AES-256 at rest | Continuous WAL + daily full | 30 days full, 7 days WAL | < 5 minutes (point-in-time) |
| PostgreSQL (checkin schema) | AES-256 at rest | Same DB, same backup | Same | Same |
| Elasticsearch | At rest (node-level) | Daily snapshot | 7 days | < 24 hours (rebuildable from events) |
| Redis | AOF on disk | Hourly RDB snapshot | 24 hours | < 1 hour. Event replay from WAL if lost |
| **Object Storage (S-08)** | **AES-256 server-side (SSE-S3/SSE-KMS)** | **Cross-region replication** | **7 years (HIPAA, BOX-15)** | **< 1 hour (replicated)** |

### Object Storage Details (S-08, S-10)

**Bucket: `phi-documents`**
- Purpose: insurance card images (S-08), scanned paper records (S-10)
- Encryption: AES-256 server-side encryption. KMS-managed keys. Key rotation every 365 days.
- Access control: bucket policy restricts to OCR Service IAM role and Admin UI IAM role. No public access. No cross-account access.
- Signed URLs: 5-minute expiry. Generated by API Gateway for receptionist thumbnail viewing.
- Lifecycle policy:
  - 0-90 days: Standard storage
  - 90 days - 1 year: Infrequent Access
  - 1 year - 7 years: Glacier/Archive
  - 7 years: Delete (HIPAA retention satisfied)
- Versioning: Enabled (protects against accidental deletion)
- Logging: S3 access logging enabled. Write to separate `phi-documents-access-log` bucket.

Elasticsearch is a derived store. Full data loss is recoverable: replay `patient.*` events from PostgreSQL audit trail to rebuild the index.

## Network

| Path | Protocol | TLS | Auth Mechanism |
|------|----------|-----|----------------|
| Client -> Load Balancer | HTTPS | Yes (TLS 1.3) | - |
| Load Balancer -> API Gateway | HTTP | Internal (mTLS optional) | - |
| API Gateway -> Services | HTTP | Internal mTLS | Service mesh identity |
| Client -> WebSocket Server | WSS | Yes | Session cookie or token query param |
| Services -> PostgreSQL | TCP | TLS | Password (rotated) |
| Services -> PostgreSQL replica | TCP | TLS | Read-only password (rotated) |
| Services -> Redis | TCP | TLS | Password |
| Services -> Elasticsearch | HTTP | TLS | API key |
| OCR Service -> Cloud OCR API | HTTPS | Yes (TLS 1.3) | API key (provider-specific) |
| Notification Service -> SMS Gateway | HTTPS | Yes | API key |
| Notification Service -> Email Service | HTTPS | Yes | IAM role / API key |
| Services -> Object Storage | HTTPS | Yes | IAM role (no hardcoded keys) |
| Migration Service -> Patient Service | HTTP | Internal mTLS | Service mesh identity |

### HIPAA Network Controls (S-04, BOX-14)

1. **Network segmentation:** Data layer (PostgreSQL, Redis, ES, Object Storage) runs in a private subnet. No direct internet access. Services access data layer via private endpoints.
2. **Egress control:** Only OCR Service and Notification Service have outbound internet access (via NAT gateway). All other services are internal-only.
3. **VPC flow logs:** Enabled on all subnets. Retained 90 days. Anomaly detection for unexpected traffic patterns.
4. **WAF on Load Balancer:** OWASP rule set. Rate limiting at the edge. Geo-blocking if needed.

## Secrets

| Secret | Rotation | Storage |
|--------|----------|---------|
| DB credentials (patient, checkin schemas) | 90 days | Vault / cloud secrets manager |
| DB credentials (read replica) | 90 days | Vault |
| Redis password | 90 days | Vault |
| Elasticsearch API key | 90 days | Vault |
| TLS certificates | Auto-renewal (Let's Encrypt or cloud CA) | Cert manager |
| Session signing key (receptionist auth) | 30 days | Vault |
| **Cloud OCR API key (S-08)** | **90 days** | **Vault** |
| **SMS Gateway API key (S-03)** | **90 days** | **Vault** |
| **Email Service credentials (S-03)** | **90 days** | **Vault** |
| **Object Storage KMS key (S-08)** | **365 days (auto-rotate)** | **KMS** |
| **Admin session signing key** | **30 days** | **Vault** |

## Key Constraints

1. **Access token never in logs.** WebSocket Server and API Gateway must strip tokens from access logs. Log aggregation must filter `access_token` fields. (S-01, BOX-O4)
2. **Audit table is append-only.** No DELETE or UPDATE permissions on `patient_data_audit` for application credentials. DB user for services has INSERT only on this table. (S-01)
3. **Checkin session data lifecycle.** Sessions >24 hours: archived. Sessions >90 days: purged. Cron job or pg_cron. (S-01, BOX-O5)
4. **Search index lag < 2 seconds.** Redis -> Search Service consumer must process events within this window. If lag exceeds 5s, alert. (S-01)
5. **PHI images access-controlled.** Object Storage bucket has no public access. Images served only via signed URLs with 5-minute expiry. (S-08, BOX-31)
6. **OCR provider must have HIPAA BAA.** Cloud OCR API processes insurance card images containing PHI. BAA must be signed before go-live. (S-08, BOX-E7)
7. **Import throttling.** Migration Service capped at 10 records/second. Pauses during business hours peak (configurable). (S-10, BOX-39)
8. **Client-side state purge.** Infrastructure cannot enforce this, but API Gateway must return `410 Gone` for invalidated tokens. (S-04, BOX-12)
9. **7-year audit retention.** `patient_data_audit` table must not be truncated. Backup retention must cover 7 years. Archival strategy needed for cost management. (S-04, BOX-15)
10. **Cross-location concurrent prevention.** The unique partial index on `checkin_sessions(patient_id)` is NOT location-scoped. A session at Location A blocks Location B. DB schema must never add `location_id` to this index. (S-05, BOX-26)
