# Responsibility & Content Matrix

Who owns what. Who consumes what. Where to find what.

## RACI by document

**O** = Owns (creates, maintains, reconciles) · **C** = Reads (matches against) · **N** = Notified (must acknowledge change + assess impact)

| Document | Product | Experience | Architecture | Quality | Operations |
|----------|---------|------------|--------------|---------|------------|
| **product/** | | | | | |
| [epics.md](product/epics.md) | **O** | C | C | C | N |
| [user-stories.md](product/user-stories.md) | **O** | C | C | C | N |
| [prd-mobile-checkin.md](product/prd-mobile-checkin.md) | **O** | C | C | N | N |
| [prd-multi-location.md](product/prd-multi-location.md) | **O** | C | C | N | C |
| [prd-riverside-acquisition.md](product/prd-riverside-acquisition.md) | **O** | C | C | C | C |
| [backlog.md](product/backlog.md) | **O** | C | C | C | C |
| [decision-log.md](product/decision-log.md) | **O** | C | C | C | C |
| **experience/** | | | | | |
| [screen-specs.md](experience/screen-specs.md) | C | **O** | C | C | N |
| [interaction-specs.md](experience/interaction-specs.md) | | **O** | C | C | N |
| [user-flows.md](experience/user-flows.md) | C | **O** | C | C | N |
| [component-inventory.md](experience/component-inventory.md) | | **O** | C | | |
| [design-decisions.md](experience/design-decisions.md) | N | **O** | C | | N |
| [flow-diagrams.md](experience/flow-diagrams.md) | C | **O** | C | C | |
| **architecture/** | | | | | |
| [architecture.md](architecture/architecture.md) | N | C | **O** | C | C |
| [api-spec.md](architecture/api-spec.md) | | C | **O** | C | C |
| [data-model.md](architecture/data-model.md) | | | **O** | C | C |
| [adrs.md](architecture/adrs.md) | N | N | **O** | C | C |
| [diagrams.md](architecture/diagrams.md) | | C | **O** | C | C |
| [tech-design-session-isolation.md](architecture/tech-design-session-isolation.md) | N | C | **O** | C | C |
| [tech-design-mobile-checkin.md](architecture/tech-design-mobile-checkin.md) | N | C | **O** | C | C |
| [tech-design-ocr-pipeline.md](architecture/tech-design-ocr-pipeline.md) | | | **O** | C | C |
| [tech-design-scaling.md](architecture/tech-design-scaling.md) | N | | **O** | C | C |
| [tech-design-migration-pipeline.md](architecture/tech-design-migration-pipeline.md) | C | | **O** | C | C |
| **quality/** | | | | | |
| [test-plan.md](quality/test-plan.md) | C | C | C | **O** | C |
| [test-suites.md](quality/test-suites.md) | C | | C | **O** | C |
| [bug-reports.md](quality/bug-reports.md) | C | C | C | **O** | C |
| [coverage-report.md](quality/coverage-report.md) | C | C | C | **O** | N |
| **operations/** | | | | | |
| [infrastructure.md](operations/infrastructure.md) | | | C | | **O** |
| [deployment-procedure.md](operations/deployment-procedure.md) | | | C | N | **O** |
| [monitoring-alerting.md](operations/monitoring-alerting.md) | N | | C | C | **O** |
| [environment-guide.md](operations/environment-guide.md) | | | C | C | **O** |
| [runbook-sync-failure.md](operations/runbook-sync-failure.md) | | | C | N | **O** |
| [runbook-data-leak.md](operations/runbook-data-leak.md) | N | | C | N | **O** |
| [runbook-concurrent-edit.md](operations/runbook-concurrent-edit.md) | | | C | N | **O** |
| [runbook-peak-load.md](operations/runbook-peak-load.md) | N | | C | N | **O** |
| [runbook-import-failure.md](operations/runbook-import-failure.md) | C | | C | N | **O** |
| [runbook-service-outage.md](operations/runbook-service-outage.md) | | | C | | **O** |
| [runbook-database-failure.md](operations/runbook-database-failure.md) | | | C | | **O** |

## Content index

### product/ — what the outside world needs

| File | Contains | Key IDs |
|------|----------|---------|
| [epics.md](product/epics.md) | 6 epics: patient recognition, mobile check-in, multi-location, insurance photo, Riverside acquisition, medication compliance | E1–E6 |
| [user-stories.md](product/user-stories.md) | 13 user stories + 3 bug stories with acceptance criteria | US-001–US-013, BUG-001–BUG-003 |
| [backlog.md](product/backlog.md) | Prioritized work with status and cross-links | — |
| [decision-log.md](product/decision-log.md) | 8 product decisions with context and rationale | DEC-001–DEC-008 |
| [prd-mobile-checkin.md](product/prd-mobile-checkin.md) | Full PRD: mobile pre-check-in from personal device | — |
| [prd-multi-location.md](product/prd-multi-location.md) | Full PRD: shared patient data across clinic locations | — |
| [prd-riverside-acquisition.md](product/prd-riverside-acquisition.md) | Full PRD: acquiring 4,000-patient practice, dedup, migration | — |

### experience/ — what users see and do

| File | Contains | Key IDs |
|------|----------|---------|
| [screen-specs.md](experience/screen-specs.md) | 16+ screens across kiosk, receptionist, mobile, admin | S1.1–S5.x |
| [interaction-specs.md](experience/interaction-specs.md) | Behaviors: transitions, loading, errors, validation, accessibility | — |
| [user-flows.md](experience/user-flows.md) | 15 journey maps: happy paths, error paths, edge cases | Flows 1–15 |
| [component-inventory.md](experience/component-inventory.md) | 14 reusable components: badges, cards, banners, inputs | — |
| [design-decisions.md](experience/design-decisions.md) | 14 design decisions with pushback context | DD-001–DD-014 |
| [flow-diagrams.md](experience/flow-diagrams.md) | 5 interactive diagrams (embeddable SVG) | — |

### architecture/ — how the system works

| File | Contains | Key IDs |
|------|----------|---------|
| [architecture.md](architecture/architecture.md) | System decomposition: 7 services, data stores, security model | — |
| [api-spec.md](architecture/api-spec.md) | ~40 REST endpoints with request/response shapes | — |
| [data-model.md](architecture/data-model.md) | 15 PostgreSQL tables with relationships and indexes | — |
| [adrs.md](architecture/adrs.md) | 10 architecture decisions with context and consequences | ADR-001–ADR-010 |
| [diagrams.md](architecture/diagrams.md) | 5 technical diagrams (embeddable SVG) | — |
| [tech-design-session-isolation.md](architecture/tech-design-session-isolation.md) | BUG-002 fix: 3-layer session purge protocol | — |
| [tech-design-mobile-checkin.md](architecture/tech-design-mobile-checkin.md) | Token-based mobile flow, identity verification, dedup | — |
| [tech-design-ocr-pipeline.md](architecture/tech-design-ocr-pipeline.md) | Insurance card OCR: upload, processing, confidence scoring | — |
| [tech-design-scaling.md](architecture/tech-design-scaling.md) | Peak load strategy: pooling, caching, read replicas, HPA | — |
| [tech-design-migration-pipeline.md](architecture/tech-design-migration-pipeline.md) | Riverside import: schema mapping, dedup algorithm, rollback | — |

### quality/ — what's proven, what's broken, what's risky

| File | Contains | Key IDs |
|------|----------|---------|
| [test-plan.md](quality/test-plan.md) | Testing strategy, scope, environments, priorities, exit criteria | — |
| [test-suites.md](quality/test-suites.md) | 72 test cases across 12 suites | TC-101–TC-1204 |
| [bug-reports.md](quality/bug-reports.md) | 3 bugs: sync failure, data leak, concurrent edit | BUG-001–BUG-003 |
| [coverage-report.md](quality/coverage-report.md) | Story-to-test mapping, gaps, traceability completeness | — |

### operations/ — what's running, what to do when it breaks

| File | Contains | Key IDs |
|------|----------|---------|
| [infrastructure.md](operations/infrastructure.md) | Services, databases, caches, storage, networking, DR | — |
| [deployment-procedure.md](operations/deployment-procedure.md) | CI/CD pipeline, rollback procedures, deploy windows | — |
| [monitoring-alerting.md](operations/monitoring-alerting.md) | 7 dashboards, P0/P1/P2 alerts, thresholds, on-call routing | — |
| [environment-guide.md](operations/environment-guide.md) | Local, staging, production setup with parity requirements | — |
| [runbook-sync-failure.md](operations/runbook-sync-failure.md) | Kiosk-to-dashboard sync broken (BUG-001 pattern) | — |
| [runbook-data-leak.md](operations/runbook-data-leak.md) | PHI exposure response, HIPAA breach assessment | — |
| [runbook-concurrent-edit.md](operations/runbook-concurrent-edit.md) | Version conflict diagnosis and recovery (BUG-003 pattern) | — |
| [runbook-peak-load.md](operations/runbook-peak-load.md) | Monday morning crush: bottleneck diagnosis, immediate relief | — |
| [runbook-import-failure.md](operations/runbook-import-failure.md) | Migration pipeline failure by stage, batch rollback | — |
| [runbook-service-outage.md](operations/runbook-service-outage.md) | Total service outage: diagnosis, response, recovery | — |
| [runbook-database-failure.md](operations/runbook-database-failure.md) | Database failure: failover, storage, connection exhaustion | — |

## How to read the matrix

- **Start from your role.** Find the **O** column — those are your documents to maintain.
- **Follow C across.** Documents you read are your matching inputs. If they change, check if your matches still hold.
- **Follow N.** Notification means you must acknowledge the change and assess impact to your inventory. Unacknowledged notifications leave items suspect.
- **Traces, not chains.** Each item traces to what it matches. When something changes, its traces identify what needs re-verification — not through a linear chain, but through the web of matching decisions each team recorded.

## Timeline

The [timeline/](timeline/) directory contains 10 customer events (rounds 01–10) that drove all of this work. Read them to understand why each document exists.
