# Engineer Inventory — 006 Silent Service Rewrite

**Trigger:** Engineer decided to rewrite order-processing from Python monolith to Go microservice.

## Pre-Rewrite: Box Check

Before writing a line of Go, the engineer reads their inventory. What boxes are they accountable for?

| Box | Source | Content | Status |
|-----|--------|---------|--------|
| B1 | PM | Order status queryable <5s after state change | PROVEN |
| B2 | PM | 500 concurrent orders without degradation | PROVEN |
| B3 | Design | Confirmation screen within 2s of payment | PROVEN |
| B4 | DevOps | 99.9% uptime SLA | PROVEN |
| B5 | DevOps | P95 latency < 500ms | PROVEN |

All boxes known. All currently proven. Proceed.

## What Changed

| Aspect | Before | After |
|--------|--------|-------|
| Language | Python | Go |
| Architecture | Monolith module | Microservice |
| P95 latency | 380ms | 92ms |
| Memory | 2.1GB | 340MB |
| Cold start | 12s | 0.8s |
| API contract | v1 | v1 (unchanged) |

## What Did NOT Change

- API endpoints (same paths, same request/response shapes)
- Event emissions (same events, same payloads)
- Boxes (all 5 still match — better, actually)

## No Permission Asked

No proposal. No RFC. No architecture review. No notification to PM or Design. Their boxes were unaffected.

QA auto-notified (transition mechanic). 47 verification paths re-run — all pass.

DevOps auto-notified (deployment pipeline changed). Operational boxes verified — all exceeded SLA.

## Deployment Sequence

1. Go service written, all 47 verification paths pass locally
2. Staging deploy, load test: 2000 concurrent (4x headroom), P95 92ms
3. Canary: 5% traffic, 24h — Go 0.02% error vs Python 0.03%
4. Full rollout, Python service decommissioned

## Post-Rewrite Box Status

| Box | Required | Actual | Margin |
|-----|----------|--------|--------|
| B1 | <5s | <1s | 5x |
| B2 | 500 concurrent | 2000 tested | 4x |
| B3 | <2s | 92ms | 20x |
| B4 | 99.9% uptime | 99.97% during rollout | ✓ |
| B5 | <500ms P95 | 92ms | 5x |

Freedom is the reward for maintaining proven matches.
