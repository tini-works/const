# Pave — Internal Deploy Platform

A working example of [the Constitution](../../CONST.md) applied to an internal platform — a deploy pipeline serving ~20 product teams that evolved through 10 rounds of incidents, bypasses, compliance mandates, political pressure, and an existential threat.

## What makes this example different

The [clinic-checkin](../clinic-checkin/) example has external customers — patients who don't understand the system. Pave's customers are internal engineers who think they understand the system *better than the platform team*. This changes everything:

- **The origin is ambiguous.** When an engineer SSH's to prod to fix a P0, is that a bypass or evidence that the platform has a gap?
- **The platform eats itself.** When Pave's own database migration breaks the deploy queue, the tool that enforces the Constitution needs the Constitution applied to it.
- **Metrics can be gamed.** When the VP mandates deploy frequency as a KPI, teams split PRs to pad numbers. The origin looks legitimate but the response breaks the intent.
- **Existence isn't guaranteed.** The CTO asks: "Why not buy Humanitec?" Every vertical must produce evidence, not assertion.

## How to read this

1. **Start with the [timeline](timeline/)** — ten events that drove all the work
2. **Browse any area** that interests you — each owns its documents independently
3. **Follow the links** — every item traces upstream to its source and downstream to its proof
4. **Check the [MATRIX](MATRIX.md)** — who owns what, who consumes what, full content index

## Timeline

| # | Type | What happened |
|---|------|---------------|
| [01](timeline/round-01.md) | Incident | Team Falcon deployed 3 PRs on Friday at 5pm, broke checkout. 40 min to identify blame. |
| [02](timeline/round-02.md) | Bypass | Team Kite SSH'd to prod for a P0 fix. Monday's deploy reverted it. |
| [03](timeline/round-03.md) | Feature | "Can we get canary deploys?" — Team Atlas (payments) |
| [04](timeline/round-04.md) | Scaling | Acquired startup (Gridline) deploys with Bash scripts. Must onboard to Pave in 90 days. |
| [05](timeline/round-05.md) | Security | SOC2 audit: every engineer has prod deploy access. Intern deployed twice. |
| [06](timeline/round-06.md) | Incident | Pave's own DB migration locked the deploy queue for 4 hours. Nobody could deploy. |
| [07](timeline/round-07.md) | Political | VP mandates deploy frequency KPI. Teams game it. Failure rate triples. |
| [08](timeline/round-08.md) | Feature | "We need secrets rotation without redeploy." — Team Sentry |
| [09](timeline/round-09.md) | Compliance | PCI DSS v4.0: security team must approve every deploy to payment services. |
| [10](timeline/round-10.md) | Existential | CTO: "Convince me why we shouldn't replace Pave with Humanitec." |

## Areas

| Folder | Owner | What's inside | Files |
|--------|-------|---------------|-------|
| [product/](product/) | Platform Lead (Marcus Chen) | Epics, user stories, PRDs, backlog, decision log, reconciliation log | 8 |
| [experience/](experience/) | DX Designer (Rina Okafor) | CLI spec, dashboard specs, onboarding flows, error catalog, design decisions, reconciliation log | 7 |
| [architecture/](architecture/) | Senior Platform Engineer (Kai Tanaka) | System design, ADRs, API spec, data model, tech design docs, reconciliation log | 10 |
| [quality/](quality/) | QA Lead (Dani Reeves) | Test plan, test suites, bug reports, coverage report, reconciliation log | 6 |
| [operations/](operations/) | DevOps/SRE (Sasha Petrov) | Infrastructure, deployment (meta: Pave deploys itself), monitoring, runbooks, reconciliation log | 11 |

Each area maintains its own inventory — the working documents that team uses day to day. See the full [responsibility matrix](MATRIX.md) for who owns, consumes, and gets notified on every document.

## How inventories relate

Each team owns their inventory independently. Items connect through **matching** — negotiated agreements between teams — not derivation chains.

### Matching, not deriving

Each vertical matches against verified items — from the origin, from other verticals, or both. The result is a web of negotiated matches, not a pipeline of arrows.

### The meta layer

Pave is a deploy platform operated by a DevOps/SRE team. This creates a unique dynamic:

- **Operations operates the thing that operates everything else.** When Pave goes down, nobody deploys — including the team that fixes Pave. The [bootstrap procedure](operations/deployment-procedure.md) exists because the platform must be able to heal itself.
- **Architecture builds the system that builds and deploys systems.** The deploy engine, canary controller, and secrets engine are infrastructure that serves infrastructure teams.
- **Quality proves the tool that helps others prove their work.** Test suites exercise deploy pipelines, not just endpoints.
- **Experience designs the experience for people who design experiences.** CLI ergonomics matter more than dashboards because the users live in their terminals.

## Where the Constitution shows up

| Constitution concept | Where it lives in practice |
|---------------------|---------------------------|
| **Don't derive, match** | Team Atlas requests canary deploys. Architecture doesn't just implement the request — they push back: "Canary needs Istio. Your service doesn't have it." The negotiation produces boxes both sides agree on. |
| **Start from the Source** | Round 2: Team Kite's SSH bypass is the origin, not a violation. It reveals that Pave has no emergency deploy path. The bypass IS the signal. |
| **Own your inventory** | Operations owns the runbooks. When Pave's own DB migration breaks the queue (Round 6), Operations writes the runbook from the incident, not from Architecture's spec. |
| **Boxes** | Deploy safety: every deploy is one commit, every rollback completes in under 2 minutes. These are binary — met or not. |
| **Traces** | Every ADR traces to the user story that triggered it, the tests that verify it, and the monitors that watch it in production. |
| **Proven** | Round 10 forces the question: can every epic produce evidence? 4 of 8 have strong evidence. 4 have gaps. The gaps are documented, not hidden. |
| **Lifecycle** | When the VP mandates deploy frequency (Round 7), the platform team doesn't just comply — they negotiate. Raw frequency is gameable. They counter-propose meaningful metrics. The VP agrees to trial. |
| **Reconciliation** | Every round triggers a reconciliation event. REC-010 (the existential threat) forces all epics to produce an evidence inventory. |
| **Learning** | BUG-003 (deploy queue corruption) taught the team to never run DDL during business hours. The preventive action is recorded alongside the fix. |

## By the numbers

| Metric | Count |
|--------|-------|
| Events processed | 10 |
| Epics | 8 |
| User stories | 17 + 3 bugs |
| CLI commands specified | 20+ |
| Dashboard screens | 8 |
| API endpoints | ~35 |
| Architecture decisions | 9+ |
| Test cases | 58 |
| Production monitors | 15+ |
| Runbooks | 5 |
| Documents total | 52 |
