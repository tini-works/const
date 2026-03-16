# Design — Architectural Discovery

This document exists because Design found a structural problem that changed the entire project scope. The discovery is the reason the CEO's "dark mode by Friday" became "reduced brightness in 2 weeks + roadmap."

## What Design was asked to do

Map every screen for a dark mode variant. Standard work — take the screen list, produce dark versions, hand to Engineering.

## What Design found instead

Started auditing the codebase for color usage. Expected to find a design token file or a theme configuration. Found neither.

**The state of colors in the codebase:**
- **200+ hardcoded color values** scattered across CSS files, inline styles, and component-level styles
- **No design token system.** No `tokens.css`, no `theme.ts`, no centralized color definitions
- **No naming convention.** Colors are hex values (`#2d2d2d`, `#f5f5f5`), not semantic names (`--color-surface-primary`)
- **Duplicates everywhere.** The same shade of gray appears as 4 different hex values in different files

**Verify:** Search the codebase for hardcoded hex color values: `grep -rn '#[0-9a-fA-F]\{3,8\}' src/`. Count should exceed 200. Search for a token file: `find src/ -name 'tokens.*' -o -name 'theme.*'`. Should return nothing.

## Why this blocks full dark mode

Dark mode requires swapping every color in the UI between two palettes. To do that, you need:

1. Every color defined in one place (tokens)
2. Every component referencing tokens, not hardcoded values
3. A mechanism to swap the token set (light vs dark)

Without step 1, you can't do step 2. Without step 2, you can't do step 3. The codebase is missing step 1.

**Full dark mode = design token migration first.** That's not a feature — it's a design system infrastructure project. Estimated at 3 months of incremental work (can't big-bang replace 200+ color references without visual regressions).

```
What CEO asked for:       "Add dark mode toggle"
What that actually means: Create token system → Migrate 200+ colors → Build theme switching → Test every screen
                          └── 3 months ──────────────────────────────────────────────────────────────────────┘
```

## What Design proposed instead

A two-phase approach:

| Phase | Scope | Timeline | Depends on |
|-------|-------|----------|------------|
| v1: Reduced brightness | 12 primary surfaces get CSS custom properties. Everything else gets an opacity overlay. | 2 weeks | Nothing — can start now |
| v2: Full dark mode | Every surface individually themed via tokens | 3+ months | Token system (B4/REQ-404) |

PM accepted this. CEO got a working demo within the sprint. Engineering got a scope they could actually deliver. The roadmap item is documented, not forgotten.

**Verify:** After v1 ships, check the 12 primary surfaces — they should use `var(--color-*)` references. Check remaining surfaces — they should have the opacity overlay applied. The gap between these two groups is the scope of v2.

## What goes suspect if this changes

- If someone starts a design token migration → v2 unblocks, this discovery becomes historical context
- If new features add more hardcoded colors → the 200+ count grows, making v2 harder
- If the team adopts a component library with built-in theming → the migration path changes entirely
