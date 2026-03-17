# Operations

This is where design meets reality. Everything here exists to prove the system runs as designed in production -- and to get it back when it doesn't.

## What's here

| File | What it does |
|------|-------------|
| `infrastructure.md` | Every deployed component, its config, networking, capacity numbers, and how to rebuild from scratch. |
| `deployment-procedure.md` | CI/CD pipeline, rolling deploy strategy, rollback procedures, deploy windows, and secrets management. |
| `monitoring-alerting.md` | Prometheus/Grafana dashboards, alert rules (P0/P1/P2), on-call rotation, and acknowledgment protocol. |
| `environment-guide.md` | Local dev setup, staging access, production access rules, and environment parity requirements. |

## Runbooks

| Runbook | When to use |
|---------|-------------|
| `runbook-service-outage.md` | A service is down. Kiosks say "system unavailable." |
| `runbook-database-failure.md` | Database unreachable -- PgBouncer, primary, replica, storage, or connection issues. |
| `runbook-data-leak.md` | Patient PHI exposed to another patient. P0 + HIPAA breach assessment. |
| `runbook-sync-failure.md` | Patients check in but the receptionist dashboard doesn't update. |
| `runbook-peak-load.md` | System is slow during rush hours -- p95 spiking, pool exhaustion, search hanging. |
| `runbook-concurrent-edit.md` | Version conflict errors spiking, or worse, silent data loss from concurrent edits. |
| `runbook-import-failure.md` | Riverside migration batch failing -- schema mapping, OCR, dedup, or transaction errors. |

## How to use this

- **Something is on fire** -- find the right runbook above and follow it step by step.
- **Deploying a change** -- read `deployment-procedure.md`. Never skip CI, even for P0 hotfixes.
- **Setting up monitoring** -- `monitoring-alerting.md` has every dashboard, alert rule, and custom metric.
- **Onboarding / local dev** -- start with `environment-guide.md`, you'll be running locally in 10 minutes.
- **Understanding what's deployed** -- `infrastructure.md` maps every component to its architecture reference.

## How verification works

- **Infrastructure** carries a `last-verified` date. Re-verify when infra changes or every 30 days.
- **Runbooks** carry `last-tested` (staging walkthrough) and `last-triggered` (production use) dates.
- **Alerts** follow an acknowledgment protocol: identify affected items, assess impact, plan re-verification, and record it. An acknowledged alert without impact assessment is an ignored alert with extra steps.
