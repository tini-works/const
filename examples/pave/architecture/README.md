# Architecture — Pave Deploy Platform

This vertical owns **system design** — the components, data model, APIs, and technical decisions that make Pave work.

**Vertical owner:** Kai Tanaka (Senior Platform Engineer)

## Inventory

| File | What it covers |
|------|---------------|
| [architecture.md](architecture.md) | System decomposition, component diagram, data stores, security model |
| [api-spec.md](api-spec.md) | Internal API specification (~35 endpoints) |
| [data-model.md](data-model.md) | PostgreSQL schema, relationships, indexes |
| [adrs.md](adrs.md) | Architecture Decision Records (ADR-001 through ADR-014) |
| [tech-design-canary.md](tech-design-canary.md) | Canary deploy: Istio traffic splitting, metric comparison, auto-rollback |
| [tech-design-drift-detection.md](tech-design-drift-detection.md) | Drift detection: reconciliation loop, state fingerprinting, resolution workflow |
| [tech-design-secrets-engine.md](tech-design-secrets-engine.md) | Vault integration: sidecar injection, rotation flow, emergency rotation |
| [tech-design-event-sourced-queue.md](tech-design-event-sourced-queue.md) | Event-sourced deploy queue: event types, state derivation, recovery |
| [reconciliation-log.md](reconciliation-log.md) | How architecture responded to changes from other verticals |

## How this vertical matches

Architecture matches against verified items from Product (user stories, epics, decisions) and receives requirements from Experience (CLI ergonomics, dashboard needs) and Operations (monitoring, runbooks). Every ADR traces to a triggering story or bug, is verified by test cases in Quality, and is monitored by alerts in Operations.

The "users" of these artifacts are the platform team itself (6 engineers), SRE (Sasha Petrov), and the 20 product teams consuming the platform. Decisions are optimized for operational simplicity — we have 6 people, not 60.
