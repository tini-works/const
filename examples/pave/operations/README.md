# Operations — Pave Deploy Platform

This vertical owns **operational reality** — how Pave runs, how we know it's running, and what we do when it stops.

We operate the platform that others use to operate their services. When Pave goes down, nobody can deploy — including us.

**Vertical owner:** Sasha Petrov (DevOps/SRE for Platform)

## Inventory

| File | What it covers |
|------|---------------|
| [infrastructure.md](infrastructure.md) | Kubernetes deployment, data stores, networking, DR strategy |
| [deployment-procedure.md](deployment-procedure.md) | How Pave deploys itself — including the bootstrap procedure when Pave is down |
| [monitoring-alerting.md](monitoring-alerting.md) | Every alert, what it watches, what it proves, dashboards, routing |
| [environment-guide.md](environment-guide.md) | Local, staging, production — setup and parity requirements |
| [runbook-pave-outage.md](runbook-pave-outage.md) | The meta runbook: what to do when the deploy platform can't deploy |
| [runbook-deploy-queue-corruption.md](runbook-deploy-queue-corruption.md) | Round 6 incident: diagnose and recover from queue corruption |
| [runbook-drift-detected.md](runbook-drift-detected.md) | Drift detection response: assess, resolve, verify |
| [runbook-canary-failure.md](runbook-canary-failure.md) | Canary auto-rollback or manual abort: investigate and re-attempt |
| [runbook-secret-rotation-failure.md](runbook-secret-rotation-failure.md) | Failed secret rotation: identify affected services, manual recovery |
| [reconciliation-log.md](reconciliation-log.md) | How operations responded to changes from other verticals |

## How this vertical matches

Operations matches against verified items from Architecture (components, ADRs), Product (user stories, SLAs), and Quality (test cases that must hold in production). Every monitor traces to an architecture component, every alert proves a product requirement is met at runtime, and every runbook responds to a quality failure detected in production.

The meta challenge: Pave is a deploy platform. Its Operations vertical must answer "how do you operate the tool that operates everything else?" — particularly when it breaks. The bootstrap procedure (deploying Pave without Pave) is the most operationally critical document in this vertical.
