# PM Inventory — Dark Mode

## Origin

CEO: "Competitors have dark mode. We need it by Friday."

PM pulled usage data. 40% of sessions happen after 8 PM. There's a real need — just not the one CEO described. Reframed as low-light comfort, not competitive checkbox.

## Requirements

| ID | Requirement | Evidence | Status |
|----|-------------|----------|--------|
| REQ-401 | Low-light comfort viewing | 40% evening sessions | PROVEN |
| REQ-402 | Full-screen dark mode (all screens) | UX principle — partial coverage is jarring | DEFERRED |
| REQ-403 | Preference persists cross-session + cross-device | Standard expectation | PROVEN |
| REQ-404 | Design token system | Design discovery — 200+ hardcoded colors | ROADMAP |

## Contracts

| To | What | Status |
|----|------|--------|
| Design | Reduced-brightness mode, v1 scope | PROVEN |
| Design | Persistent preference (toggle + cross-device sync) | PROVEN |
| Design | Full dark mode, all screens | DEFERRED — needs REQ-404 |
| Design + Eng | Design token infrastructure | ROADMAP |

## What got renegotiated

Design found 200+ hardcoded colors and no token system. Full dark mode = design system migration, not a toggle. PM renegotiated with CEO:

- **Delivered:** reduced-brightness v1 in 2 weeks
- **Deferred:** full dark mode until token system exists
- **Roadmap:** design token infrastructure (REQ-404)

CEO got a Friday demo of the toggle. Eng got a sane scope. Nobody got a 3-month surprise.
