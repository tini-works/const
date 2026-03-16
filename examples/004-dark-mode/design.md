# Design Inventory — Dark Mode

## Received

- Reduced-brightness mode (v1)
- Persistent preference toggle

## Deferred

- Full-screen dark mode — blocked by missing design tokens

## Architectural discovery

Started mapping screens for dark mode. Found: **no design token system.** 200+ hardcoded color values throughout the codebase. Full dark mode isn't a toggle — it's a design system migration.

Raised to PM. Result: scope renegotiated to reduced-brightness v1 (2 weeks) + token system as roadmap item.

## Screens

| ID | Screen | Detail |
|----|--------|--------|
| SCR-40 | Settings > Appearance | Toggle: Light / Reduced Brightness. Auto-detect via `prefers-color-scheme` on first visit. No page reload on switch. |
| SCR-41 | All screens, reduced-brightness variant | 12 primary surfaces use CSS custom properties. Remaining surfaces get opacity overlay. |

## Known gap

Non-tokenized surfaces use an opacity overlay. Meets WCAG AA but colors aren't individually tuned. Resolves when design tokens land.
