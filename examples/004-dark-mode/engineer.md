# Engineer Inventory — 004 Dark Mode

**Boxes to match:** B1 (reduced brightness), B3 (persistent preference)

**Not matching:** B2 (full dark mode — deferred), B4 (design tokens — roadmap)

## Flows

| ID | Flow | Matches |
|----|------|---------|
| FLW-40 | CSS custom properties for 12 most-used color values | B1 |
| FLW-41 | Media query `prefers-color-scheme: dark` + manual toggle | B1 |
| FLW-42 | Opacity overlay (0.85 filter) for non-tokenized surfaces | B1 |
| FLW-43 | Preference: localStorage (instant) + profile API sync (cross-device) | B3 |

## System Design

| Item | Detail |
|------|--------|
| 12 CSS custom properties | Primary bg, text, borders, accent, etc. |
| Opacity overlay | 0.85 filter on non-tokenized areas |
| Toggle state | localStorage for instant switch + API sync for cross-device |

## Explicit Non-Action

Engineer does NOT refactor the 200+ hardcoded colors. That's B2/B4 (deferred). The overlay is ugly in the code. The boxes match. That's the deal.

Freedom means matching what's asked, not gold-plating what isn't.
