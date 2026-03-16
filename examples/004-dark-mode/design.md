# Design Inventory — 004 Dark Mode

**Boxes received:** B1 (reduced brightness), B3 (persistent preference)

**Deferred:** B2 (full coverage — blocked by missing design tokens)

## Discovery: Architectural Gap

Started mapping screens for dark mode. Found: **no design token system.** 200+ hardcoded color values throughout the codebase. Full dark mode isn't a toggle — it's a design system migration.

Raised to PM: "B2 is a 3-month project. B1 can be matched in 2 weeks with reduced-brightness mode."

This produced B4 (design token infrastructure) as a roadmap item.

## Screens

| ID | Screen | Regions | Matches |
|----|--------|---------|---------|
| SCR-40 | Settings → Appearance | Toggle: Light / Reduced Brightness | B3 |
| SCR-41 | All screens — reduced brightness variant | 12 primary surfaces tokenized, remainder overlaid | B1 |

## State Machine (modified)

```
Settings → Appearance → Toggle →
    Light mode (default)
    Reduced brightness mode
    (auto-detect: prefers-color-scheme on first visit)
    (no page reload on switch)
```

**Hanging state check:** Binary toggle, both states stable. **No hanging states.**

## Known Gap

Non-tokenized surfaces use an opacity overlay. Meets WCAG AA but isn't ideal. Resolves when B4 (design tokens) lands.
