# Engineer Inventory — Dark Mode

## Matching

- Reduced-brightness mode (v1)
- Persistent preference (cross-session + cross-device)

## System

| ID | Component | Detail |
|----|-----------|--------|
| FLW-40 | 12 CSS custom properties | Primary bg, text, borders, accent — the most-used color values |
| FLW-41 | Mode switching | `prefers-color-scheme: dark` media query + manual toggle override |
| FLW-42 | Opacity overlay | `filter: brightness(0.85)` on non-tokenized surfaces |
| FLW-43 | Preference sync | localStorage for instant switch, profile API for cross-device |

## Explicit non-action

Did NOT refactor the 200+ hardcoded colors. That's deferred scope (design token system). The overlay covers non-tokenized areas. It's ugly in the code. It matches what was asked for.
