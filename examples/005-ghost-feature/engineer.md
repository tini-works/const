# Engineer — System Registry

## Active Flows

| ID | Flow | Last touched | Status |
|----|------|-------------|--------|
| FLW-12 | Dashboard data aggregation | 2026-03 | Active |
| FLW-15 | Email digest generation | 2026-02 | Active |
| ~~FLW-99~~ | ~~PDF export — monthly report~~ | ~~2024-01~~ | **Removed** |

## FLW-99 Discovery

Source: routine sanity check.

| Dimension | Check | Finding |
|-----------|-------|---------|
| Staleness | Last touched? | 14 months ago |
| Correctness | Still works? | No — PDF library deprecated 8mo ago, returns 200 + empty body |
| Coverage | Anyone using it? | 3 calls in 90 days, all 0-byte downloads |

Staleness flagged it. Correctness confirmed it's broken. Coverage confirmed nobody cares.

## Code Removed

- PDF export endpoint, controller, service layer
- PDF library removed from package manifest

## Lesson

The test mocked the PDF library. Mock passes forever — it doesn't know the real library died. No production signal existed for this flow, so the silent failure generated no alert.

**New rule:** Flows untouched >6 months get a manual correctness check during sanity reconciliation. Staleness is the first signal; correctness and coverage checks follow.
