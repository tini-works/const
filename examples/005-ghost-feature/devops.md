# DevOps Inventory — 005 Ghost Feature Removal

**No infrastructure to remove.** The PDF export had no dedicated infrastructure.

That's the problem.

## Gap Discovered

The PDF export feature had:
- No observability signal in production
- No degradation alert
- No way to detect that it silently broke

This is why it died without anyone noticing for 8 months.

## Systemic Rule Added

**Observability audit:** Every flow in Engineer's inventory must map to at least one production signal.

| Rule | Detail |
|------|--------|
| Coverage requirement | Every Engineer flow → ≥1 production observability signal |
| Audit frequency | Part of daily sanity reconciliation |
| Violation response | Flag flow as unobservable, escalate to Engineer + QA |

An unobservable flow is a ghost waiting to happen.
