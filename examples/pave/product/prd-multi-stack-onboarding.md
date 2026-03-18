# PRD: Multi-Stack Onboarding

## Problem
Pave only supports Kubernetes workloads. Gridline — an acquired startup with 30 people — runs Bash scripts and Docker Compose. No K8s. They must be on Pave within 90 days for SOC2 compliance. Telling them "migrate to K8s first" doubles the timeline and is the wrong sequencing: deploy governance is more urgent than runtime modernization.

This isn't only about Gridline. Two teams are considering ECS. One legacy service runs on bare metal. If Pave can only manage K8s, it can't be the "only sanctioned way to get code to production" — it's just the sanctioned way for K8s teams.

## Users
- **Gridline developers** (30 people) who need to ship through Pave using their existing Docker Compose setup
- **Future non-K8s teams** who need Pave without a runtime migration
- **Platform engineers** who need to maintain adapters for multiple runtimes
- **Rina Okafor (DX)** who designs the onboarding experience

## Solution
A universal service definition schema (`pave.yaml`) that decouples deploy governance from runtime. Teams declare what their service is — name, owner, runtime, build, deploy, health check — and Pave adapts. Under the hood, runtime-specific adapters handle the differences. The team interacts with the same CLI and dashboard regardless of runtime.

## Flow

1. **Init:** `pave init` in the service repo — interactive prompts guide the team through creating `pave.yaml`
2. **Validate:** `pave validate` checks the config against the schema, reports errors with line numbers
3. **First deploy:** `pave deploy` — Pave selects the right adapter based on the declared runtime
4. **Verify:** Deployment completes, health check passes, service appears in Pave dashboard
5. **Done:** Team now has atomic deploys, rollback, audit trail, and RBAC — regardless of runtime

## Requirements

**Must have:**
- `pave.yaml` schema covering: service name, team, runtime, build config, deploy config, health check, environments, secrets
- Runtime adapters: Kubernetes (existing), Docker Compose (Gridline requirement)
- `pave init` interactive scaffolding
- `pave validate` schema validation with clear error messages
- Same CLI commands work regardless of runtime (deploy, rollback, status)
- Schema versioning — old versions supported with deprecation warnings
- Guided onboarding documentation with examples per runtime

**Should have:**
- ECS adapter
- Migration guide: "from Bash scripts to pave.yaml"
- Template library: starter `pave.yaml` files for common stacks
- Dry-run mode: `pave deploy --dry-run` shows what would happen without doing it

**Won't have (for now):**
- Bare metal adapter (no current demand)
- Automatic runtime detection (team must declare their runtime)
- Runtime migration tooling (migrating from Docker Compose to K8s is out of scope)

## Dependencies
- E1 must be stable — deploy safety applies to all runtimes
- E4 RBAC — Gridline teams need access controls from day one
- Drift detection (US-003) needs adapter extension for non-K8s fingerprinting

## Gridline-Specific Constraints
- 30 engineers, most unfamiliar with Pave
- Currently deploy via `./deploy.sh` which runs `docker-compose up -d`
- No CI/CD pipeline — they push to main and run the script
- Must have: CI integration (GitHub Actions template), Docker Compose adapter, basic onboarding
- 90-day hard deadline for SOC2

## Risks
- **Adapter maintenance burden:** Each runtime is a separate codepath. Mitigation: clean adapter interface, integration tests per runtime, limit supported runtimes.
- **Feature parity:** Non-K8s adapters may lag K8s in features (e.g., canary requires Istio, which Docker Compose doesn't have). Mitigation: document feature matrix per runtime, be honest about gaps.
- **Gridline cultural resistance:** "We've always deployed with a script, why do we need this?" Mitigation: Rina designs onboarding experience, show value immediately (audit trail, rollback), don't force workflow changes beyond what's necessary.

## Success metrics
- Gridline fully onboarded to Pave within 90 days
- Gridline's first deploy through Pave takes < 1 hour (including `pave init`)
- Zero onboarding-related incidents in first 30 days
- At least 2 additional non-K8s teams onboarded within 6 months

---

## Traceability

| Link type | References |
|-----------|------------|
| Epic | [E3: Multi-Stack Onboarding](epics.md#e3-multi-stack-onboarding) |
| User Stories | [US-006: Compatibility mode for non-K8s stacks](user-stories.md#us-006-compatibility-mode-for-non-k8s-stacks), [US-007: Service definition schema — pave.yaml](user-stories.md#us-007-service-definition-schema--paveyaml) |
| Decisions | [DEC-004: Schema, not custom integrations](decision-log.md#dec-004-onboarding-via-service-definition-schema-not-custom-integrations) |
| Architecture | [ADR-004: pave.yaml Schema](../architecture/adrs.md#adr-004-pave-yaml-service-definition-schema), [ADR-005: Adapter Pattern](../architecture/adrs.md#adr-005-adapter-pattern-for-multi-runtime-support) |
| Experience | [CLI: `pave init`](../experience/cli-spec.md#pave-init), [CLI: `pave validate`](../experience/cli-spec.md#pave-validate), [Onboarding Flow](../experience/onboarding-flows.md#guided-onboarding), [Onboarding: Docker Compose](../experience/onboarding-flows.md#onboarding-docker-compose) |
| Tests | [TC-301](../quality/test-suites.md#tc-301-onboarding--k8s-service-via-pave-init) through [TC-306](../quality/test-suites.md#tc-306-onboarding--docker-compose-to-pave) |
| Confirmed by | Marcus Chen (Platform Engineering Lead), 2025-08-05 |
