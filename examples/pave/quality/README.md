# Quality — Pave Deploy Platform

This vertical owns **proof integrity** — every box has a verification path, every path has a mechanism, every mechanism has a degradation signal.

**QA Lead:** Dani Reeves

## Inventory

| File | What it covers |
|------|---------------|
| [test-plan.md](test-plan.md) | Testing strategy, scope, environments, priorities, entry/exit criteria |
| [test-suites.md](test-suites.md) | ~58 test cases across 8 suites, organized by feature area |
| [bug-reports.md](bug-reports.md) | 3 documented bugs: multi-commit blame, bypass overwrite, queue corruption |
| [coverage-report.md](coverage-report.md) | Story-to-test mapping, gap analysis, traceability completeness |
| [reconciliation-log.md](reconciliation-log.md) | How QA responded to changes from other verticals |

## How this vertical matches

QA matches against verified items from Product (user stories, epics), Architecture (ADRs, API spec), Experience (CLI spec, dashboard specs), and Operations (monitoring, alerting). Every test case traces to a user story acceptance criteria it **proves**, a CLI command or API endpoint it **tests**, and a production monitor that **watches** for regressions.

The users of this platform are ~300 engineers deploying multiple times per day. A missed deploy safety bug doesn't affect one patient — it can break production for the entire company. QA priorities reflect this: deploy safety and rollback are critical gates, everything else follows.
