# QA Inventory — 004 Dark Mode

**Boxes to cover:** B1 (reduced brightness), B3 (persistent preference)

## Verification Paths

| ID | Path | Mechanism | Degradation signal | Covers |
|----|------|-----------|-------------------|--------|
| VP-40 | Toggle switches modes, preference persists | E2E: toggle, close, reopen, assert mode | Monitor localStorage clear events | B3 |
| VP-41 | 12 primary surfaces correct in reduced brightness | Screenshot diffing (12 surfaces, approved baselines) | Visual regression CI on every deploy | B1 |
| VP-42 | Non-tokenized areas meet WCAG AA contrast | Automated contrast ratio check on overlay'd elements | New hardcoded colors bypass overlay | B1 |
| VP-43 | No regression in light mode | Existing visual regression suite | Existing monitors | — |

## Coverage Matrix

| Box | Verification paths | Degradation signal? |
|-----|-------------------|-------------------|
| B1 | VP-41, VP-42 | Yes |
| B3 | VP-40 | Yes |

**Full coverage for v1 scope.**

## Known Coverage Gap

VP-42 has a degradation risk: new hardcoded colors added by engineers will bypass the overlay. QA documents this explicitly. The gap closes when B4 (design tokens) lands.

QA doesn't over-test what doesn't exist yet.
