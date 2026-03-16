# Design System & Screen Registry

Every screen users can reach. Every state they can be in. Every path between them. If it's not here, it doesn't exist.

**Proven: 8/8 screens (100%)** | No hanging states

---

## Screen Catalog

| ID | Screen | Key regions | Traces to |
|----|--------|-------------|-----------|
| SCR-01 | Welcome Back (returning patient check-in) | Pre-filled demographic fields, edit toggles, confirm button | REQ-101, REQ-103 |
| SCR-02 | Staff Review Queue | Flagged-change list for receptionist | REQ-101 |
| SCR-03 | Allergy Re-confirmation | Forced allergy re-entry when data >6mo stale | REQ-104 |
| SCR-10 | Checkout Error — Card Problem | "There's a problem with your card" / Update payment CTA | REQ-201, REQ-202 |
| SCR-11 | Checkout Error — Temporary Decline | "Couldn't process right now" / Retry CTA | REQ-201, REQ-202 |
| SCR-12 | Checkout Error — Contact Bank | "Contact your bank" / Alt payment + support CTA | REQ-201, REQ-202 |
| SCR-40 | Settings → Appearance | Light / Reduced Brightness toggle | REQ-401, REQ-403 |
| SCR-41 | All screens — Reduced Brightness variant | 12 primary surfaces tokenized, rest overlaid | REQ-401 |

## Screens Removed

| ID | Screen | Why |
|----|--------|-----|
| SCR-XX | "Export Report" button on dashboard | Feature dead — no users, dependency deprecated, PM closed requirement |

## User Flows

### Patient Check-In

```
Is returning patient?
  No  → Full Intake Form → Ready
  Yes → Welcome Back (SCR-01) →
          Allergies stale (>6mo)? → Allergy Re-confirm (SCR-03) → back to SCR-01
          Edits made? → Staff Review Queue (SCR-02) → Ready
          No edits → Ready
```

### Checkout Payment Error

```
Pay button → Processing →
  Success → Confirmation
  Failure → categorize error →
    Card problem → SCR-10 → "Update Card" → back to Payment
    Temporary   → SCR-11 → "Retry" → back to Processing
    Bank issue  → SCR-12 → Alt payment or Contact support
    (all paths) → cart + shipping preserved
```

### Appearance Settings

```
Settings → Appearance (SCR-40) → Toggle →
  Light mode (default)
  Reduced Brightness mode
  Auto-detect on first visit (prefers-color-scheme)
  No page reload on switch
```

## Design Tokens

| Token | Current state | Notes |
|-------|--------------|-------|
| 12 primary color tokens | Shipped (CSS custom properties) | bg, text, borders, accent, etc. |
| 200+ hardcoded colors | NOT tokenized | Covered by opacity overlay for now |
| Full token system | **Roadmap** | Required before full dark mode (REQ-402) |

## What Design protects daily

1. **No hanging states.** Every screen reachable by a user must have a way out. After every change, trace all paths. Dead ends are Design bugs.
2. **Every screen traces to a PM requirement.** If the requirement is dead, the screen should be dead (see: Export Report button — carried a dead screen for months).
3. **Known gaps are documented, not hidden.** The opacity overlay is imperfect. The 200+ hardcoded colors aren't tokenized. These are explicit, tracked gaps — not surprises.

## Active negotiations

| With | What Design pushed back on | Result |
|------|---------------------------|--------|
| PM | "Pre-filled" — editable or locked? | Editable + change flagging |
| PM | "Actionable reason" — can't show raw gateway errors | Categorized messaging |
| PM | "Dark mode by Friday" — 200+ hardcoded colors, no tokens | Reduced brightness v1 (2 weeks) + token system roadmap |

Design doesn't just receive specs. It negotiates scope, catches architectural gaps, and often originates requirements PM didn't think of (cart preservation, confirm-step, token system).
