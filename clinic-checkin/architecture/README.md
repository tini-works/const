# Architecture

System-facing documents. How the clinic check-in system is built and why.

---

## What's here

| Document | What it covers |
|----------|---------------|
| [architecture.md](architecture.md) | Top-level system overview: services, data flows, infrastructure, security, and scaling strategy. Start here. |
| [adrs.md](adrs.md) | 10 Architecture Decision Records (ADR-001 through ADR-010). Every major technical choice with context, options considered, and consequences. |
| [api-spec.md](api-spec.md) | Full REST + WebSocket API specification. Request/response shapes, auth, error format, and traceability to screens and tests. |
| [data-model.md](data-model.md) | PostgreSQL schema: all tables, indexes, relationships, and a round-by-round evolution history. |
| [diagrams.md](diagrams.md) | Visual references: system architecture, ER diagram, sync sequence, concurrency flow, and migration pipeline. |

### Tech design docs

| Document | When to read it |
|----------|----------------|
| [tech-design-session-isolation.md](tech-design-session-isolation.md) | You're touching the kiosk session lifecycle or need to understand the P0 data leak fix (BUG-002). |
| [tech-design-mobile-checkin.md](tech-design-mobile-checkin.md) | You're working on the mobile pre-check-in flow: token auth, session management, partial completion. |
| [tech-design-ocr-pipeline.md](tech-design-ocr-pipeline.md) | You're working on insurance card photo capture or the OCR service. Also covers paper record scanning for migration. |
| [tech-design-scaling.md](tech-design-scaling.md) | You need to understand peak load handling: PgBouncer, read replicas, caching, search indexes, WebSocket batching. |
| [tech-design-migration-pipeline.md](tech-design-migration-pipeline.md) | You're working on the Riverside data migration: schema mapping, dedup algorithm, merge operations, rollback. |

---

## How to navigate

- **Understand the system end-to-end:** Start with [architecture.md](architecture.md), then [diagrams.md](diagrams.md) for visuals.
- **Know why we chose X:** Check [adrs.md](adrs.md). Each ADR records context, alternatives considered, and trade-offs.
- **Call or change an API endpoint:** Check [api-spec.md](api-spec.md). Each endpoint lists which screens, tests, and ADRs go suspect if it changes.
- **Understand or modify the database:** Check [data-model.md](data-model.md). Schema evolution table at the bottom shows what changed per round.
- **Deep-dive on a subsystem:** Read the relevant tech design doc (see table above).

## How verification works

- **ADRs** carry a `Last reviewed` date and status. When infrastructure or requirements change, ADRs are re-evaluated and the review date is updated.
- **API endpoints** list an "If this changes" section showing which screens, flows, tests, and ADRs become suspect and need re-verification.
- **Data model tables** list which API endpoints read/write them and what needs re-verification if the schema changes.
- **Tech design docs** link to their test cases and monitoring dashboards for operational verification.
