# Engineer Inventory — 005 Ghost Feature Removal

**Source:** Routine daily sanity check.

## Discovery Sequence

| Dimension | Check | Finding |
|-----------|-------|---------|
| Staleness | When was FLW-99 last touched? | 14 months ago |
| Correctness | Does it still work? | No — PDF library deprecated 8mo ago, returns 200 + empty body |
| Coverage | Does anyone use it? | 3 uses in 90 days, all by one intern, all 0-byte downloads |

## Flows Removed

| ID | Flow | Reason |
|----|------|--------|
| FLW-99 | Export to PDF — monthly report generation | Stale (14mo), broken (dep dead), unused (0 active users) |

## Code Removed

- PDF export endpoint, controller, service layer
- PDF library removed from package manifest

## Root Cause Analysis

The test mocked the PDF library. The mock passes forever — it doesn't know the real library died. No production observability existed for this flow, so the silent failure generated no alerts.

## Systemic Rule Added

Any flow untouched >6 months gets a manual correctness check during daily reconciliation. Staleness is the first signal — correctness and coverage checks follow.
