# PM Inventory — 004 Dark Mode

**Source:** CEO competitive reaction. No customer story initially.

**PM grounded it:** 40% of sessions after 8 PM. Users work late. There's a real need — just not the one CEO described.

## Requirements

| ID | Requirement | External source | Downstream match | Status |
|----|-------------|----------------|-----------------|--------|
| REQ-401 | Low-light comfort viewing | Usage data (40% evening sessions) | Design → SCR-40..41 | PROVEN |
| REQ-402 | Full-screen dark mode coverage | UX principle (partial = jarring) | — | DEFERRED |
| REQ-403 | Persistent preference (cross-session, cross-device) | Standard expectation | Engineer → FLW-43 | PROVEN |
| REQ-404 | Design token system as infrastructure | Design discovery | — | ROADMAP |

## Boxes

| Box | Direction | Content | Status |
|-----|-----------|---------|--------|
| B1 | PM → Design | Reduced-brightness mode (v1 scope) | PROVEN |
| B2 | PM → Design | Full dark mode (all screens) | DEFERRED — blocked by B4 |
| B3 | PM → Design | Preference persists cross-session + cross-device | PROVEN |
| B4 | PM → Design/Eng | Design token system (infrastructure) | ROADMAP |

## Observations

- PM didn't parrot the CEO. Looked for data, found 40% evening usage. Grounded the request in a real user need.
- Design discovered the architectural blocker (200+ hardcoded colors, no token system). PM's response: renegotiate scope, not force the original ask.
- Result: 2-week deliverable + roadmap item. Not a 3-month surprise.
