# Environment Guide -- Clinic Check-In System

Last updated: 2026-03-17
Owner: DevOps

---

## Environments

| Environment | Purpose | URL | Data |
|-------------|---------|-----|------|
| Local | Developer workstation | `http://localhost:3000` | Seed data (synthetic) |
| Staging | Pre-production testing | `https://staging-api.clinic-checkin.example.com` | Anonymized copy of production |
| Production | Live system | `https://api.clinic-checkin.example.com` | Real patient data (PHI) |

---

## Local Development Setup

### Prerequisites

| Tool | Version | Installation |
|------|---------|-------------|
| Node.js | 20 LTS | `nvm install 20` |
| Docker | 24+ | Docker Desktop or `apt install docker.io` |
| Docker Compose | 2.20+ | Included with Docker Desktop |
| PostgreSQL client | 16 | `apt install postgresql-client-16` |
| Redis CLI | 7 | `apt install redis-tools` |

### Quick Start

```bash
# 1. Clone the repo
git clone git@github.com:clinic/checkin-system.git
cd checkin-system

# 2. Start infrastructure
docker compose up -d

# 3. Wait for services to be healthy
docker compose ps

# 4. Install dependencies
npm ci

# 5. Run database migrations
npx prisma migrate deploy

# 6. Seed the database
npm run db:seed

# 7. Start services (each in a separate terminal)
npm run dev:checkin       # http://localhost:3000
npm run dev:notification  # http://localhost:3001
npm run dev:kiosk         # http://localhost:5173
npm run dev:dashboard     # http://localhost:5174
```

### docker-compose.yml (Infrastructure Only)

```yaml
services:
  postgres:
    image: postgres:16-alpine
    ports: ["5432:5432"]
    environment:
      POSTGRES_DB: clinic_checkin
      POSTGRES_USER: app_user
      POSTGRES_PASSWORD: dev_password
    volumes: [pgdata:/var/lib/postgresql/data]
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U app_user -d clinic_checkin"]
      interval: 5s
      timeout: 3s
      retries: 5

  pgbouncer:
    image: edoburu/pgbouncer:1.22.0
    ports: ["6432:6432"]
    environment:
      DATABASE_URL: "postgres://app_user:dev_password@postgres:5432/clinic_checkin"
      POOL_MODE: transaction
      DEFAULT_POOL_SIZE: 10
      MAX_CLIENT_CONN: 50
    depends_on:
      postgres: { condition: service_healthy }

  redis:
    image: redis:7-alpine
    ports: ["6379:6379"]
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 3s
      retries: 5

  minio:
    image: minio/minio:latest
    ports: ["9000:9000", "9001:9001"]
    environment:
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: minioadmin
    command: server /data --console-address ":9001"
    volumes: [miniodata:/data]

  createbucket:
    image: minio/mc:latest
    depends_on: [minio]
    entrypoint: >
      /bin/sh -c "sleep 3;
      mc alias set local http://minio:9000 minioadmin minioadmin;
      mc mb local/clinic-checkin-files --ignore-existing; exit 0;"

volumes:
  pgdata:
  miniodata:
```

### Local Environment Variables

Create `.env` in the project root (never committed to git):

```bash
# Database
DB_PRIMARY_URL=postgresql://app_user:dev_password@localhost:6432/clinic_checkin
DB_REPLICA_URL=postgresql://app_user:dev_password@localhost:5432/clinic_checkin

# Redis
REDIS_URL=redis://localhost:6379

# S3 / MinIO
S3_ENDPOINT=http://localhost:9000
S3_ACCESS_KEY=minioadmin
S3_SECRET_KEY=minioadmin
S3_BUCKET=clinic-checkin-files
S3_FORCE_PATH_STYLE=true

# OCR (use mock in local dev)
OCR_PROVIDER=mock

# Auth
JWT_SIGNING_KEY=dev-signing-key-not-for-production

# Notification (mock in local dev)
SMS_PROVIDER=mock
EMAIL_PROVIDER=mock

# Server
PORT=3000
NODE_ENV=development
LOG_LEVEL=debug
```

### Seed Data

| Entity | Count | Details |
|--------|-------|---------|
| Locations | 2 | "Main Street Clinic", "Oak Avenue Clinic" |
| Kiosks | 4 | 2 per location |
| Staff | 4 | 2 receptionists per location |
| Patients | 50 | Synthetic names, DOBs, addresses |
| Appointments | 30 | Today and tomorrow, spread across locations |
| Allergies | ~80 | 1-3 per patient |
| Medications | ~100 | 1-4 per patient |
| Insurance | 50 | One per patient (primary) |

Test patients:
- **Card scan test:** Card ID `TEST-CARD-001`, Sarah Johnson, DOB 1982-03-15
- **Mobile test:** Card ID `TEST-CARD-002`, James Williams, DOB 1975-08-22, token `test-mobile-token-001`

### Running Tests

```bash
npm run test                    # Unit tests
npm run test:integration        # Integration (requires Docker)
npm run test:session-isolation  # Headless browser session tests
npm run test:e2e                # Full stack E2E
npm run test:load               # 50 concurrent sessions simulation
```

---

## Staging Environment

### Access

| Component | URL |
|-----------|-----|
| API | `https://staging-api.clinic-checkin.example.com` |
| Kiosk SPA | `https://staging-checkin.clinic.example.com` |
| Dashboard SPA | `https://staging-dashboard.clinic.example.com` |
| Grafana | `https://staging-grafana.clinic.example.com` |
| Database | Via bastion host (SSH tunnel) |

### SSH Tunnel to Staging Database

```bash
ssh -L 15432:staging-db.internal:5432 \
    -L 16379:staging-redis.internal:6379 \
    user@bastion.clinic.example.com

# Connect to staging DB
psql postgresql://app_user:$STAGING_DB_PASS@localhost:15432/clinic_checkin
```

### Data

Staging uses an anonymized copy of production data, refreshed weekly (Sunday night).

Anonymization:
- Replace patient names with synthetic names
- Replace phone numbers with 555-xxx-xxxx
- Replace email addresses with synthetic@example.com
- Replace addresses with synthetic addresses
- Replace SSN last-4 with random digits
- Keep DOBs and medical data intact (preserves data distribution)
- Insurance card photos replaced with stock images
- Audit logs cleared

### Deploying to Staging

Staging deploys automatically on merge to `main`. To deploy a specific branch:
```bash
gh workflow run deploy-staging.yml -f branch=feature/mobile-checkin
```

---

## Production Environment

### Access

| Component | URL |
|-----------|-----|
| API | `https://api.clinic-checkin.example.com` |
| Kiosk SPA | `https://checkin.clinic.example.com` |
| Dashboard SPA | `https://dashboard.clinic.example.com` |
| Grafana | `https://grafana.clinic.example.com` |
| Database | Via bastion host (SSH tunnel + MFA) |

### SSH Tunnel to Production Database

```bash
# CAUTION: This is production. Read-only queries unless you have explicit approval.
ssh -L 25432:prod-db.internal:5432 user@bastion-prod.clinic.example.com
# Requires MFA token

# Connect READ-ONLY to the replica (preferred)
psql postgresql://readonly_user:$PROD_READONLY_PASS@localhost:25432/clinic_checkin
```

### Production Data Handling Rules

- Never copy production data to local dev without anonymization
- Never run UPDATE or DELETE without a WHERE clause and a SELECT first
- Always connect to the read replica for investigation
- Write operations require team lead approval
- All production database access is logged and audited

---

## Environment Parity

### Must Match Between Staging and Production

| Component | Must Match |
|-----------|-----------|
| PostgreSQL version | Exact major + minor |
| PostgreSQL key config | shared_buffers, work_mem |
| Redis version | Major version |
| Node.js version | Exact |
| Container base image | Exact |
| Schema (migrations) | Exact |
| Indexes | Exact |
| PgBouncer pool mode | Exact |

### Allowed to Differ

| Aspect | Staging | Production |
|--------|---------|------------|
| Instance size | Smaller | Full size |
| Instance count | 1 per service | 2+ for Check-In Service |
| Data volume | ~10% of prod | Full |
| External services | Mock Twilio/SendGrid | Real |
| Monitoring alerts | Disabled | Enabled |

---

## Common Development Tasks

### Reset Local Database

```bash
docker compose down -v
docker compose up -d
npx prisma migrate deploy
npm run db:seed
```

### Add a New Database Migration

```bash
# 1. Edit prisma/schema.prisma
# 2. Generate migration
npx prisma migrate dev --name "describe_the_change"
# 3. Review generated SQL in prisma/migrations/
# 4. Test on fresh database
docker compose down -v && docker compose up -d
npx prisma migrate deploy && npm run db:seed
# 5. Commit migration file with the code change
```

### Test Against Production-Like Data

```bash
scp user@bastion.clinic.example.com:/backups/staging-anonymized-latest.sql.gz .
gunzip -c staging-anonymized-latest.sql.gz \
  | psql postgresql://app_user:dev_password@localhost:5432/clinic_checkin
```

### Simulate Peak Load

```bash
npm run test:load
# Or with k6:
k6 run scripts/load-test.js --vus 50 --duration 5m
```

---

## Troubleshooting

| Problem | Check |
|---------|-------|
| Cannot connect to database | `docker ps`, then `psql postgresql://...@localhost:5432/...` |
| Redis connection refused | `docker compose ps redis`, `redis-cli PING` |
| MinIO bucket not found | `docker compose run --rm createbucket` |
| Migration failed | `npx prisma migrate status`, resolve with `npx prisma migrate resolve` |
| Slow query | `EXPLAIN (ANALYZE, BUFFERS) <query>` -- look for Seq Scan |
