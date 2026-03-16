# QA Inventory — Dark Mode

## Verification paths

| ID | What | How | Degradation signal |
|----|------|-----|-------------------|
| VP-40 | Toggle switches modes, preference persists across sessions | E2E: toggle, close, reopen, assert mode retained | localStorage clear events |
| VP-41 | 12 primary surfaces correct in reduced brightness | Screenshot diffing against approved baselines | Visual regression CI on every deploy |
| VP-42 | Non-tokenized areas meet WCAG AA contrast | Automated contrast ratio check on overlaid elements | New hardcoded colors bypass overlay |
| VP-43 | No regression in light mode | Existing visual regression suite | Existing monitors |

## Coverage

| Scope | Paths | Signal? |
|-------|-------|---------|
| Reduced brightness (v1) | VP-41, VP-42 | Yes |
| Persistent preference | VP-40 | Yes |

Full coverage for v1 scope.

## Known coverage gap

VP-42 has an honest gap: new hardcoded colors added by engineers will bypass the overlay and won't be caught until contrast check runs. Closes when design token system lands and hardcoded colors are eliminated.
