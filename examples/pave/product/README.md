# Product — Pave

Product vertical for Pave, the internal deploy pipeline.

**Owner:** Marcus Chen (Platform Engineering Lead, de facto PM)

## What's here

| Document | Purpose |
|----------|---------|
| [epics.md](epics.md) | 8 epics (E1–E8) with scope, traceability, and verification status |
| [user-stories.md](user-stories.md) | 17 user stories (US-001–US-017) + 3 bug stories (BUG-001–BUG-003) |
| [decision-log.md](decision-log.md) | 8 product decisions (DEC-001–DEC-008) with context, options, and rationale |
| [reconciliation-log.md](reconciliation-log.md) | 10 reconciliation events (REC-001–REC-010) tracking how change propagated through inventory |
| [backlog.md](backlog.md) | Prioritized backlog with status, cross-links, and coverage gaps |
| [prd-canary-deploys.md](prd-canary-deploys.md) | PRD for canary deploys (E2) |
| [prd-multi-stack-onboarding.md](prd-multi-stack-onboarding.md) | PRD for multi-stack onboarding / Gridline (E3) |

## Context

Pave is an internal platform. The "customers" are ~300 engineers across ~20 product teams. Marcus faces inward — navigating politics (VP metrics mandates, CTO replacement proposals), compliance (SOC2, PCI), and the constant tension between "Pave should do more" and "Pave is the bottleneck."

The 10 rounds trace Pave's evolution from a CI wrapper to a deploy governance platform, driven by incidents, acquisitions, audits, and organizational pressure.
