# Environment Guide — Pave Deploy Platform

Last updated: 2025-10-15
Owner: Sasha Petrov (DevOps/SRE)

### Traceability

| Link | Reference |
|------|-----------|
| **Traced from** | [infrastructure.md](./infrastructure.md) — compute, database, cache, and storage configuration referenced throughout |
| **Matched by** | [deployment-procedure.md](./deployment-procedure.md) — deploy targets and bootstrap procedure align with environments defined here |
| **Confirmed by** | Sasha Petrov (DevOps/SRE), 2025-10-15 — verified local, staging, and production setup instructions against running environments |

---

## Environments

| Environment | Purpose | Access | Data |
|-------------|---------|--------|------|
| Local | Developer workstation (minikube) | localhost | Seed data (synthetic teams, services) |
| Staging | Pre-production, full Pave instance | `pave-staging.internal` (VPN) | Copy of production config, synthetic deploy targets |
| Production | The real thing — deploys to prod K8s cluster | `pave.internal` (VPN) | Real team configs, real deploy history |

---

## Local Development Setup

### Prerequisites

| Tool | Version | Installation |
|------|---------|-------------|
| Go | 1.21+ | `brew install go` or `asdf install golang 1.21` |
| Docker | 24+ | Docker Desktop |
| minikube | 1.31+ | `brew install minikube` |
| kubectl | 1.28+ | `brew install kubectl` |
| Helm | 3.12+ | `brew install helm` |
| Vault CLI | 1.15+ | `brew install vault` |

### Quick Start

```bash
# 1. Start minikube with enough resources for Pave + test workloads
minikube start --cpus=4 --memory=8192 --driver=docker

# 2. Create namespaces
kubectl create namespace pave-system
kubectl create namespace pave-staging-targets  # fake "target" namespaces for deploy testing

# 3. Start infrastructure (PostgreSQL, Redis)
# Uses Helm charts pinned to production versions
helm install pave-pg bitnami/postgresql \
  --namespace pave-system \
  --set auth.database=pave \
  --set auth.username=pave_user \
  --set auth.password=dev_password \
  --set primary.persistence.size=1Gi

helm install pave-redis bitnami/redis \
  --namespace pave-system \
  --set auth.enabled=false \
  --set master.persistence.size=256Mi

# 4. Start Vault in dev mode (no persistence, auto-unsealed)
vault server -dev -dev-root-token-id=dev-token &
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=dev-token

# Seed Vault with test secrets
vault kv put secret/pave/test-service/db DSN=postgres://test:test@localhost:5432/test
vault kv put secret/pave/test-service/redis URL=redis://localhost:6379

# 5. Run database migrations
export DATABASE_URL=postgres://pave_user:dev_password@$(minikube ip):30432/pave
go run ./cmd/migrate up

# 6. Seed with test data
go run ./cmd/seed

# 7. Start Pave services (each in a separate terminal)
go run ./cmd/pave-api           # Pave API on :8080
go run ./cmd/deploy-engine      # Deploy Engine on :8082
go run ./cmd/drift-detector     # Drift Detector on :8084
go run ./cmd/notification       # Notification Service on :8081
```

### Local Vault Dev Mode

Vault in dev mode:
- Auto-unsealed, no init ceremony
- Root token: `dev-token`
- All data in memory (lost on restart)
- KV v2 engine pre-mounted at `secret/`

This is sufficient for local development. The Secrets Engine and sidecar injection work the same way — they don't care if Vault is dev mode or production.

### Local Testing a Deploy

```bash
# Register a test service
curl -X POST http://localhost:8080/api/services \
  -H "Content-Type: application/json" \
  -d '{
    "name": "test-app",
    "team": "test-team",
    "runtime": "kubernetes",
    "namespace": "pave-staging-targets"
  }'

# Trigger a deploy
curl -X POST http://localhost:8080/api/deploys \
  -H "Content-Type: application/json" \
  -d '{
    "service": "test-app",
    "environment": "staging",
    "commit": "abc123",
    "image": "nginx:latest"
  }'

# Check status
curl http://localhost:8080/api/deploys/<deploy-id>
```

### Local Limitations

| Feature | Local behavior | Production behavior |
|---------|---------------|-------------------|
| Istio / canary | Not available. Canary flag is accepted but deploys go all-at-once. | Full traffic splitting via VirtualService |
| Vault auth | Dev token (static) | Kubernetes service account auth |
| S3 | MinIO (via Docker) or local filesystem fallback | AWS S3 |
| PCI approval | Skipped (no approval service in local by default) | Full approval workflow |
| Slack notifications | Logged to stdout | Delivered to Slack channels |

---

## Staging

Staging is a full Pave instance running in the staging Kubernetes cluster. It deploys to staging target namespaces — not to the production cluster.

### Access

```bash
# Configure kubectl for staging
export KUBECONFIG=~/.kube/config-staging
kubectl config use-context pave-staging

# Pave CLI pointed at staging
export PAVE_API_URL=https://pave-staging.internal/api
pave status --env staging
```

### Staging Configuration

| Property | Value |
|----------|-------|
| Kubernetes cluster | `staging-cluster` (separate from prod) |
| Namespace | `pave-system` (in staging cluster) |
| PostgreSQL | Dedicated instance, weekly refresh from anonymized production backup |
| Redis | Dedicated instance |
| Vault | Staging Vault namespace (`vault-staging/pave/`) |
| S3 | `pave-staging-artifacts`, `pave-staging-logs` |
| Target namespaces | `team-falcon-staging`, `team-atlas-staging`, `gridline-staging` |

### What Staging Proves

- Full deploy pipeline end-to-end (API -> queue -> engine -> cluster state change)
- Database migrations against production-volume data
- Canary deploys via Istio (staging cluster has Istio installed)
- RBAC enforcement (staging mirrors production team configs)
- Approval workflow (with test approvers)
- Secrets injection and rotation

### Staging Limitations

| Limitation | Why | Mitigation |
|-----------|-----|------------|
| No real team workloads | Staging target services are test apps, not real team code | Smoke tests simulate realistic deploy patterns |
| Lower resource allocation | 50% of production resources | Acceptable — staging is for correctness, not performance |
| Vault secrets are test values | Staging Vault doesn't have production secrets | Expected — secrets injection is tested, not secret values |
| No PagerDuty integration | Staging alerts go to #pave-staging Slack channel only | Alerts are still configured and fire; just routed differently |

---

## Production

Production Pave manages deploys to the production Kubernetes cluster. It shares the cluster with all product team workloads. Pave runs in `pave-system`, product teams run in their own namespaces.

### Access

```bash
# Configure kubectl for production
export KUBECONFIG=~/.kube/config-production
kubectl config use-context pave-production

# Pave CLI (default — production is the default environment)
pave status
```

### Production Configuration

See [infrastructure.md](./infrastructure.md) for full details.

### Production Constraints

- **No direct kubectl to pave-system** except during bootstrap (break-glass). All changes go through Pave's own deploy pipeline.
- **Deploy windows:** Business hours Mon-Thu preferred. Friday deploys require justification. Weekend deploys only for P0 incidents.
- **Monitoring:** 15-minute watch window after every deploy. Auto-rollback on error rate > 1%.

---

## Environment Parity

Parity between environments reduces "works in staging, breaks in prod" surprises.

### What Must Be Identical

| Aspect | Enforced how |
|--------|-------------|
| Container images | Same image SHA deployed to staging, then promoted to production |
| Go version | Pinned in `go.mod` and Dockerfile |
| PostgreSQL version | Same major version (16) in all environments |
| Redis version | Same major version (7) in all environments |
| Vault API version | Same client library version |
| Database schema | Migrations run in order: local -> staging -> production |
| RBAC rules | Staging mirrors production team structure (weekly sync) |

### What Can Differ

| Aspect | Why |
|--------|-----|
| Resource allocation | Staging runs at 50% of production resources. Performance testing happens in a dedicated load test environment (not documented here — it's temporary and spun up on demand). |
| Vault secrets | Staging uses test secrets. Expected and correct. |
| S3 bucket names | Prefixed with environment (`pave-staging-*` vs `pave-*`). |
| Alerting destination | Staging alerts go to Slack only. Production alerts go to PagerDuty. |
| Number of replicas | Staging may run single replicas where production runs two. |

### Configuration Management

Environment-specific config is injected via Kubernetes ConfigMaps and Secrets, not baked into images. The same image runs in every environment — only config changes.

```yaml
# Example: pave-api ConfigMap (production)
apiVersion: v1
kind: ConfigMap
metadata:
  name: pave-api-config
  namespace: pave-system
data:
  DATABASE_URL: "postgres://pave_user@pave-pg:5432/pave"  # Service DNS
  REDIS_URL: "redis://pave-redis:6379"
  VAULT_ADDR: "http://vault.vault-system:8200"
  ENVIRONMENT: "production"
  LOG_LEVEL: "info"
  ENABLE_CANARY: "true"
  ENABLE_APPROVAL_GATES: "true"
```

Sensitive values (database password, Vault token) come from Kubernetes Secrets, not ConfigMaps. In production, these are populated by Vault via the secrets sidecar.
