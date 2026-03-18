# Experience — Pave Deploy Platform

This vertical owns **Developer Experience (DX)** — the surfaces through which ~300 engineers interact with Pave.

Unlike a traditional "Design" vertical that focuses on pixel-perfect UI for end users, this vertical focuses on:

- **CLI ergonomics** — the primary interface. Engineers live in terminals.
- **Error messages** — every error includes remediation steps. "What broke" is useless without "what to do next."
- **Onboarding** — new teams (and acquired startups with non-standard stacks) can adopt Pave without reading a 40-page runbook.
- **Dashboard** — oversight, not daily workflow. Canary monitoring, deploy health, audit logs, approval queues.
- **Cognitive load reduction** — fewer things to remember, fewer flags to look up, fewer Slack questions to the platform team.

**Vertical owner:** Rina Okafor (Developer Experience Designer)

## Inventory

| File | What it covers |
|------|---------------|
| [cli-spec.md](cli-spec.md) | CLI commands, flags, output formats, error handling |
| [dashboard-specs.md](dashboard-specs.md) | Web dashboard screens — deploy queue, canary monitor, audit log, etc. |
| [onboarding-flows.md](onboarding-flows.md) | User journeys — deploy, rollback, onboarding, emergency bypass, etc. |
| [design-decisions.md](design-decisions.md) | Where DX pushed back on PM or added requirements |
| [error-catalog.md](error-catalog.md) | Every error Pave produces, with remediation steps |
| [reconciliation-log.md](reconciliation-log.md) | How DX responded to changes in other verticals |

## How this vertical matches

DX matches against verified items from Product (user stories, epics) and Architecture (API endpoints, ADRs). Every CLI command traces to a user story and is proven by a test case. Every dashboard screen traces to a product need and is matched by an API endpoint.

The "users" here are software engineers. They will read these docs critically and test every edge case. DX that wastes their time loses trust fast.
