# Deployment Procedure — Clinic Check-In System

Last updated: 2026-03-17
Owner: DevOps

### Traceability

| Deployed Service | Architecture Reference | Infrastructure |
|-----------------|----------------------|----------------|
| Check-In Service | [architecture.md — Check-In Service](../architecture/architecture.md#check-in-service-core) | [infrastructure.md — Check-In Service](./infrastructure.md#check-in-service-core) |
| Notification Service | [architecture.md — Notification Service](../architecture/architecture.md#notification-service) | [infrastructure.md — Notification Service](./infrastructure.md#notification-service) |
| Migration Service | [architecture.md — Migration Service](../architecture/architecture.md#migration-service-round-10) | [infrastructure.md — Migration Service](./infrastructure.md#migration-service) |
| OCR Service | [architecture.md — OCR Service](../architecture/architecture.md#ocr-service-round-8) | [infrastructure.md — OCR Service](./infrastructure.md#ocr-service) |
| Database migrations | [Data Model](../architecture/data-model.md) | [infrastructure.md — PostgreSQL](./infrastructure.md#database--postgresql) |
| Frontend SPAs | [Architecture — Clients](../architecture/architecture.md#system-context) | [infrastructure.md — Kiosks](./infrastructure.md#kiosks-per-location) |
| **Post-deploy monitoring:** | [monitoring-alerting.md](./monitoring-alerting.md) — error rate auto-rollback ties to [US-006](../product/user-stories.md#us-006-peak-hour-check-in-performance) |
| **Hotfix process references:** | [BUG-002 class](../quality/bug-reports.md#bug-002-previous-patients-data-briefly-visible-on-kiosk-after-card-scan) for P0 deploy procedure |
| **Confirmed by** | Sam Rivera (SRE), 2026-03-17 — walked full pipeline, verified rollback matrix, staging deploy tested end-to-end |

---

## CI/CD Pipeline

All code is deployed through the CI/CD pipeline. No manual deployments to production. No SSH-and-deploy. No exceptions.

### Pipeline Overview

```
Developer pushes to feature branch
    │
    ▼
┌───────────────────────────────────┐
│  1. Build & Lint                  │
│     - npm ci                      │
│     - TypeScript compile          │
│     - ESLint                      │
│     - Duration: ~2 min            │
└───────────────┬───────────────────┘
                │
                ▼
┌───────────────────────────────────┐
│  2. Unit Tests                    │
│     - Jest / Vitest               │
│     - Coverage threshold: 80%     │
│     - Duration: ~3 min            │
└───────────────┬───────────────────┘
                │
                ▼
┌───────────────────────────────────┐
│  3. Integration Tests             │
│     - Testcontainers (PG, Redis)  │
│     - API contract tests          │
│     - Session isolation tests     │
│     - Duration: ~5 min            │
└───────────────┬───────────────────┘
                │
                ▼
┌───────────────────────────────────┐
│  4. Security Scan                 │
│     - npm audit (fail on high)    │
│     - Container image scan        │
│     - SAST (static analysis)      │
│     - Duration: ~2 min            │
└───────────────┬───────────────────┘
                │
                ▼
┌───────────────────────────────────┐
│  5. Build Container Image         │
│     - Docker build (multi-stage)  │
│     - Tag: git SHA + branch       │
│     - Push to container registry  │
│     - Duration: ~3 min            │
└───────────────┬───────────────────┘
                │
         PR merge to main
                │
                ▼
┌───────────────────────────────────┐
│  6. Deploy to Staging             │
│     - Auto-deploy on main merge   │
│     - Run smoke tests             │
│     - Duration: ~5 min            │
└───────────────┬───────────────────┘
                │
       Manual approval gate
                │
                ▼
┌───────────────────────────────────┐
│  7. Deploy to Production          │
│     - Rolling deployment          │
│     - Health check gating         │
│     - Duration: ~5 min            │
└───────────────┬───────────────────┘
                │
                ▼
┌───────────────────────────────────┐
│  8. Post-Deploy Verification      │
│     - Smoke tests against prod    │
│     - Monitor error rate 15 min   │
│     - Auto-rollback if errors > 1%│
└───────────────────────────────────┘
```

### Total pipeline time: ~25 minutes (push to production)

---

## Deployment Strategy

### Rolling Deployment (Default)

For the Check-In Service (2+ instances), deployments use a rolling strategy:

1. New container image is pulled to Instance B
2. Instance B starts up with the new code
3. Instance B passes health check (`GET /health` returns 200)
4. Load balancer routes traffic to Instance B
5. Instance A is drained (existing connections finish, no new connections)
6. Instance A is updated with new image
7. Instance A passes health check
8. Load balancer routes traffic to both instances

**Zero downtime.** At no point are zero healthy instances serving traffic.

Health check parameters:
- Path: `GET /health`
- Interval: 5 seconds
- Healthy threshold: 2 consecutive passes
- Unhealthy threshold: 3 consecutive failures
- Timeout: 3 seconds
- Grace period: 30 seconds (allow app startup)

### Single-Instance Services

Notification Service, Migration Service, and OCR Service run as single instances. Deployments cause a brief (~10-30 second) interruption.

**Notification Service:** During the restart window, WebSocket connections drop. Dashboards automatically reconnect (exponential backoff) and fall back to polling. No data loss -- events are persisted in the database. The polling fallback catches any events missed during the gap.

**Migration Service:** Schedule migration batch runs outside deployment windows. If a deployment interrupts a running batch, the batch status remains `in_progress`. On restart, resume from the last processed record (each record is individually committed).

**OCR Service:** During restart, insurance card photo processing jobs queue up. They'll be processed when the service is back. The client polls for results and sees "processing" status until complete.

---

## Database Migrations

Schema changes are managed via Prisma Migrate.

### Migration Process

```bash
# 1. Generate migration from schema changes
npx prisma migrate dev --name "add_migration_tables"

# 2. Review generated SQL in prisma/migrations/
# 3. Commit migration file with the code change
# 4. CI runs: npx prisma migrate deploy (staging)
# 5. On production deploy: npx prisma migrate deploy (production)
```

### Migration Rules

1. **Additive only in production.** Never drop columns or tables in the same release that stops using them. Follow the expand-contract pattern:
   - Release 1: Add new column/table, code writes to both old and new
   - Release 2: Code reads from new only, old column unused
   - Release 3: Drop old column (after confirming no reads)

2. **Indexes created concurrently.** All `CREATE INDEX` in production must use `CONCURRENTLY` to avoid table locks:
   ```sql
   CREATE INDEX CONCURRENTLY idx_patients_name_trgm ON patients ...
   ```

3. **Test migrations on a staging copy of production data.** Never run an untested migration against production.

4. **Backfill separately.** If a new column needs data backfilled from existing rows, do it as a separate post-migration script, not in the migration transaction itself.

### Migration Rollback

If a migration causes issues:
```bash
# Check current migration status
npx prisma migrate status

# Rollback requires a new migration (reverse the changes)
# Prisma does not support automatic rollback
# Write a manual migration: npx prisma migrate dev --name "rollback_bad_change"
```

For emergency rollback of a schema change, have a pre-written reverse migration in the PR.

---

## Container Image

### Dockerfile (Multi-Stage)

```dockerfile
# Build stage
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --production=false
COPY . .
RUN npx prisma generate
RUN npm run build

# Production stage
FROM node:20-alpine
WORKDIR /app
RUN apk add --no-cache dumb-init
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/package.json ./

USER node
EXPOSE 3000
CMD ["dumb-init", "node", "dist/server.js"]
```

### Image Tagging

| Tag | When | Example |
|-----|------|---------|
| `{git-sha}` | Every build | `checkin-service:a1b2c3d` |
| `staging` | On deploy to staging | `checkin-service:staging` |
| `production` | On deploy to production | `checkin-service:production` |
| `latest` | Never used in deployments | N/A |

---

## Deploy Procedures

### Standard Deploy (Staging then Production)

```bash
# 1. Verify CI is green on main
# 2. Staging deploys automatically on merge to main
# 3. Run smoke tests on staging
curl -s https://staging-api.clinic-checkin.example.com/health | jq .

# 4. Approve production deploy in CI/CD UI
# 5. Monitor deploy in CI/CD UI
# 6. Verify production health
curl -s https://api.clinic-checkin.example.com/health | jq .

# 7. Watch error rates in monitoring for 15 minutes
# 8. If error rate > 1%, trigger rollback (see below)
```

### Hotfix Deploy (P0 Bug Fix)

For critical bugs (BUG-002 class -- data leak, HIPAA violation):

```bash
# 1. Branch from main: hotfix/bug-002-session-isolation
# 2. Fix, test locally, push
# 3. CI runs full pipeline (no shortcuts)
# 4. PR review (minimum 1 reviewer, security team for PHI issues)
# 5. Merge to main
# 6. Deploy to staging, run targeted smoke test
# 7. Skip normal soak time -- deploy to production immediately after staging passes
# 8. Post-deploy: monitor for 30 minutes, then write incident postmortem
```

**Never bypass CI.** Even for P0 fixes, the full test suite runs. If tests are slow, fix the tests -- don't skip them.

### Deploy Window

| Day | Window | Notes |
|-----|--------|-------|
| Monday-Friday | 09:00-16:00 ET | Avoid Monday 8-9 AM (peak check-in) |
| Saturday-Sunday | Anytime | Low traffic |
| Holidays | Avoid | Unless P0 hotfix |

Database migrations: preferably Tuesday-Thursday, 10:00-14:00 ET (lowest traffic window).

---

## Rollback Procedure

### Application Rollback

```bash
# 1. Identify the last known good image tag (git SHA)
#    Check deployment history in CI/CD or container registry

# 2. Deploy the previous image
#    In CI/CD: re-run the production deploy job with the previous SHA
#    Or manually:
kubectl set image deployment/checkin-service \
  checkin-service=registry.example.com/checkin-service:{previous-sha}

# Equivalent for ECS:
aws ecs update-service \
  --cluster clinic-prod \
  --service checkin-service \
  --task-definition checkin-service:{previous-revision}

# 3. Verify rollback
curl -s https://api.clinic-checkin.example.com/health | jq .version
# Should show the previous version

# 4. Monitor for 15 minutes
```

Rollback time target: < 5 minutes from decision to traffic on the old version.

### Database Rollback

Database rollbacks are harder. Prevention is the strategy:

1. All migrations are tested on staging with production-like data first
2. Additive-only changes mean the old code still works with the new schema
3. If a migration must be reversed, deploy a new reverse migration

If a migration breaks production and reverse migration isn't ready:
```bash
# Point-in-time recovery (nuclear option, last resort)
# This restores the ENTIRE database to a point in time
# All data written after that point is lost
# Only use if data corruption is confirmed

# 1. Stop all application services
# 2. Restore DB from PITR to time just before the bad migration
# 3. Deploy the previous application version
# 4. Restart services
# 5. Incident postmortem required
```

### Rollback Decision Matrix

| Signal | Action |
|--------|--------|
| Error rate > 1% for 5 minutes post-deploy | Auto-rollback (configured in CI/CD) |
| Error rate > 5% at any point | Immediate manual rollback |
| Patient data exposed ([BUG-002](../quality/bug-reports.md#bug-002-previous-patients-data-briefly-visible-on-kiosk-after-card-scan) class) | Immediate rollback + incident response. See [Runbook: Data Leak](./runbook-data-leak.md). |
| Dashboard not updating | Investigate first (may be Notification Service, not a deploy issue) |
| Slow response times (> 5s p95) | Investigate first (may be DB or cache issue) |

---

## Service-Specific Deploy Notes

### Check-In Service

> **Architecture:** [Check-In Service](../architecture/architecture.md#check-in-service-core) · **Infra:** [infrastructure.md](./infrastructure.md#check-in-service-core) · **Smoke test endpoint:** [POST /patients/identify](../architecture/api-spec.md#post-patientsidentify) · **Post-deploy monitors:** [Service Down](./monitoring-alerting.md#p0----page-immediately-any-time), [Error Rate](./monitoring-alerting.md#p0----page-immediately-any-time)

- Runs 2+ instances: rolling deploy, zero downtime
- After deploy: verify a test check-in flow end-to-end on staging
- Key smoke test: `POST /patients/identify` with a known test card ID

### Notification Service

> **Architecture:** [Notification Service](../architecture/architecture.md#notification-service) · **Infra:** [infrastructure.md](./infrastructure.md#notification-service) · **Smoke test endpoint:** [WebSocket /ws/dashboard](../architecture/api-spec.md#websocket-wsdashboardlocation_id) · **Post-deploy monitors:** [Sync Failure Rate](./monitoring-alerting.md#p1----notify-during-business-hours), [WebSocket Connections](./monitoring-alerting.md#p1----notify-during-business-hours) · **Related runbook:** [Sync Failure](./runbook-sync-failure.md)

- Single instance: brief WebSocket interruption during deploy
- Deploy during low-traffic hours when possible
- After deploy: verify WebSocket connection from a test dashboard client
- Key smoke test: trigger a test check-in, verify dashboard receives the event

### Migration Service

> **Architecture:** [Migration Service](../architecture/architecture.md#migration-service-round-10) · **Infra:** [infrastructure.md](./infrastructure.md#migration-service) · **Smoke test endpoint:** [GET /migration/batches](../architecture/api-spec.md#get-migrationbatchesbatch_id) · **Related runbook:** [Import Failure](./runbook-import-failure.md)

- Single instance, not on critical path
- **Never deploy during an active migration batch.** Check `GET /migration/batches` for `in_progress` status first
- After deploy: verify `GET /health` returns OK

### OCR Service

> **Architecture:** [OCR Service](../architecture/architecture.md#ocr-service-round-8) · **Infra:** [infrastructure.md](./infrastructure.md#ocr-service) · **ADR:** [ADR-006 OCR API Contract](../architecture/adrs.md#adr-006-ocr-service-as-a-separate-service-behind-a-stable-api-contract) · **Post-deploy monitors:** [OCR Service Slow](./monitoring-alerting.md#p2----investigate-during-next-business-day)

- Single instance, not on critical path
- After deploy: upload a test insurance card image, verify OCR extraction returns results
- If Google Vision API credentials rotated, update in Secrets Manager before deploying

### Frontend SPAs (Kiosk, Mobile, Dashboard)

> **Infra:** [infrastructure.md — Kiosks](./infrastructure.md#kiosks-per-location), [CDN](./infrastructure.md#network-topology) · **Session isolation critical:** changes to kiosk SPA must be reviewed against [ADR-002 Session Purge Protocol](../architecture/adrs.md#adr-002-session-purge-protocol-for-kiosk-state-isolation) per [BUG-002](../quality/bug-reports.md#bug-002-previous-patients-data-briefly-visible-on-kiosk-after-card-scan) post-mortem

#### Build and Deploy

Static assets are built in CI and deployed to CDN (CloudFront or equivalent). Each SPA has its own build and deploy step.

```bash
# 1. Build all SPAs (CI step)
npm run build:kiosk       # → dist/kiosk/
npm run build:mobile      # → dist/mobile/
npm run build:dashboard   # → dist/dashboard/

# 2. Upload to S3 (CDN origin)
aws s3 sync dist/kiosk/ s3://clinic-checkin-spa/kiosk/ --delete
aws s3 sync dist/mobile/ s3://clinic-checkin-spa/mobile/ --delete
aws s3 sync dist/dashboard/ s3://clinic-checkin-spa/dashboard/ --delete
```

#### CDN Cache Invalidation

Every SPA deploy **must** invalidate the CDN cache. Stale assets cause version mismatches between client and API.

```bash
# Invalidate all SPA paths on CloudFront
aws cloudfront create-invalidation \
  --distribution-id $CDN_DISTRIBUTION_ID \
  --paths "/kiosk/*" "/mobile/*" "/dashboard/*"

# Verify invalidation completed (takes 30-90 seconds)
aws cloudfront get-invalidation \
  --distribution-id $CDN_DISTRIBUTION_ID \
  --id $INVALIDATION_ID \
  | jq '.Invalidation.Status'
# Should return "Completed"

# Alternative: if only one SPA changed, invalidate selectively
aws cloudfront create-invalidation \
  --distribution-id $CDN_DISTRIBUTION_ID \
  --paths "/kiosk/*"
```

**Cache headers on assets:**
- `index.html`: `Cache-Control: no-cache` (always revalidated)
- Hashed assets (`*.{hash}.js`, `*.{hash}.css`): `Cache-Control: public, max-age=31536000, immutable`
- `version.json`: `Cache-Control: no-cache`

#### Version Heartbeat Verification

Each SPA includes a `/version.json` file and a version heartbeat mechanism:

```bash
# After deploy, verify each SPA is serving the new version
curl -s https://checkin.clinic.example.com/version.json | jq .
# → {"version": "1.4.2", "build": "a1b2c3d", "deployed_at": "2026-03-17T10:00:00Z"}

curl -s https://dashboard.clinic.example.com/version.json | jq .
# → same format

# Compare against the expected version (from CI build output)
# If versions don't match, CDN invalidation may not have completed
```

The SPAs poll `/version.json` every 60 seconds. If the server version differs from the loaded version, the app shows a "New version available" banner and triggers a hard reload after the current user action completes. On kiosks, the reload is immediate (no user action in progress between patients).

#### Rollback Procedure for Static Assets

```bash
# 1. Identify the previous good build artifacts
#    Check CI/CD for the previous successful deploy's S3 snapshot
#    Or use S3 versioning to restore:

# List versions of index.html to find the previous one
aws s3api list-object-versions \
  --bucket clinic-checkin-spa \
  --prefix kiosk/index.html \
  --max-items 5 | jq '.Versions[] | {VersionId, LastModified}'

# 2. Restore previous version (copy old version over current)
aws s3api copy-object \
  --bucket clinic-checkin-spa \
  --copy-source clinic-checkin-spa/kiosk/index.html?versionId=$PREVIOUS_VERSION_ID \
  --key kiosk/index.html

# 3. Invalidate CDN cache for the rolled-back SPA
aws cloudfront create-invalidation \
  --distribution-id $CDN_DISTRIBUTION_ID \
  --paths "/kiosk/*"

# 4. Verify rollback
curl -s https://checkin.clinic.example.com/version.json | jq .version
# Should show the previous version

# 5. For full rollback (all assets, not just index.html):
#    Re-deploy from the previous CI build artifacts:
#    In CI/CD, re-run the SPA deploy job with the previous git SHA
```

Rollback time target: < 3 minutes from decision to CDN serving old assets.

#### Post-Deploy Smoke Tests

**Kiosk SPA:**

```bash
# 1. Verify SPA loads
curl -s -o /dev/null -w "%{http_code}" https://checkin.clinic.example.com
# Should return 200

# 2. Verify version.json is current
curl -s https://checkin.clinic.example.com/version.json | jq .version

# 3. On a kiosk device (or staging kiosk):
#    - Hard-refresh the browser (Ctrl+Shift+R or MDM-triggered restart)
#    - Scan TEST-CARD-001 → verify patient lookup works
#    - Complete a test check-in flow end-to-end
#    - Verify session purge: scan TEST-CARD-002 immediately after → no data from TEST-CARD-001 visible
```

**Mobile SPA:**

```bash
# 1. Verify SPA loads on mobile viewport
curl -s -o /dev/null -w "%{http_code}" https://checkin.clinic.example.com/mobile/

# 2. Test token redemption flow:
#    - Generate a test mobile token
#    - Open the mobile link in a phone browser
#    - Verify the check-in flow loads with correct patient context
#    - Complete the check-in and verify dashboard receives the event
```

**Dashboard SPA:**

```bash
# 1. Verify SPA loads
curl -s -o /dev/null -w "%{http_code}" https://dashboard.clinic.example.com

# 2. Open in a browser:
#    - Verify WebSocket connection establishes (check browser dev tools → Network → WS)
#    - Verify patient queue loads for the selected location
#    - Trigger a test check-in → verify dashboard updates in real time
```

#### Notification Service Rollback Considerations

The Notification Service has stateful connections (WebSocket to dashboards, Redis pub/sub subscriptions) that require special handling during rollback:

**WebSocket state:** Rolling back the Notification Service drops all active WebSocket connections. Dashboards automatically reconnect (exponential backoff 1s-30s) and fall back to polling. After rollback:

```bash
# Verify WebSocket connections re-establish
curl -s https://api.clinic-checkin.example.com/metrics | grep ws_connections_active
# Should show connections returning for each location with open dashboards (within 30-60 seconds)
```

**Redis pub/sub:** The Notification Service subscribes to Redis channels on startup. After a rollback restart, subscriptions are re-established automatically. Check that events flow:

```bash
# Verify pub/sub channels are active
redis-cli -h $REDIS_HOST -p 6379 --tls PUBSUB CHANNELS 'checkin:*'
# Should show channels for active locations

# Verify event delivery: trigger a test check-in and confirm dashboard receives it
```

**In-flight notifications:** SMS/email delivery requests that were in-flight during the rollback may be lost. The Notification Service does not persist outbound message queue (Twilio/SendGrid are fire-and-forget). If a mobile check-in link SMS was being sent during the restart, the patient won't receive it. Staff can re-trigger from the dashboard.

---

## Secrets Management

All secrets stored in AWS Secrets Manager (or Vault). Never in environment files, never in code.

| Secret | Used by |
|--------|---------|
| `DB_PRIMARY_URL` | All services |
| `DB_REPLICA_URL` | Check-In Service |
| `REDIS_URL` | Check-In Service, Notification Service |
| `TWILIO_API_KEY` | Notification Service |
| `SENDGRID_API_KEY` | Notification Service |
| `GOOGLE_VISION_KEY` | OCR Service |
| `S3_ACCESS_KEY` / `S3_SECRET_KEY` | Check-In Service, OCR Service, Migration Service |
| `JWT_SIGNING_KEY` | Check-In Service |
| `PGBOUNCER_AUTH` | PgBouncer |

Secret rotation: quarterly, or immediately on suspected compromise.
