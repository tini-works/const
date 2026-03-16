# Design — v1 Reduced Brightness Spec

Two screens. One state machine. Scoped to what's achievable in 2 weeks without a token system.

---

## SCR-40: Settings > Appearance

**Who sees this:** Any user, from the Settings page.

**What it shows:**
- "Appearance" section with a toggle: **Light** / **Reduced Brightness**
- Current mode is highlighted
- No page reload on switch — mode changes instantly

**Behavior:**
- First visit: auto-detect via `prefers-color-scheme: dark` media query. If the OS is in dark mode, default to Reduced Brightness. Otherwise, default to Light.
- Manual toggle overrides auto-detection permanently (until user toggles again)
- Toggle state is saved to localStorage immediately (instant persistence) and synced to user profile API (cross-device persistence)

**Exists because:** Commitment 1 (low-light comfort) and Commitment 2 (persistent preference).

**Verify:** Open Settings > Appearance. Toggle to Reduced Brightness. Page should not reload. Background and text colors should change on the settings page itself. Close browser. Reopen. Settings should still show Reduced Brightness active.

---

## SCR-41: All screens — reduced-brightness variant

**What changes:** Every screen in the app has a reduced-brightness variant. But the variant is applied in two tiers:

**Tier 1 — 12 primary surfaces (CSS custom properties):**
These get proper dark values, not just dimming. Backgrounds become dark, text becomes light, borders adjust for contrast.

| Surface | Light value | Reduced-brightness value |
|---------|------------|-------------------------|
| Page background | `#ffffff` | `#1a1a2e` |
| Card background | `#f8f9fa` | `#16213e` |
| Primary text | `#212529` | `#e8e8e8` |
| Secondary text | `#6c757d` | `#a0a0b0` |
| Border | `#dee2e6` | `#2a2a4a` |
| Navigation bg | `#f8f9fa` | `#0f3460` |
| Navigation text | `#212529` | `#e8e8e8` |
| Button primary bg | `#0d6efd` | `#1a73e8` |
| Button primary text | `#ffffff` | `#ffffff` |
| Input background | `#ffffff` | `#1a1a2e` |
| Input border | `#ced4da` | `#2a2a4a` |
| Accent | `#0d6efd` | `#4dabf7` |

**Tier 2 — everything else (opacity overlay):**
All non-tokenized surfaces get `filter: brightness(0.85)`. This dims them uniformly. Not individually tuned, but meets WCAG AA contrast requirements.

**Exists because:** Commitment 1 (low-light comfort). The two-tier approach exists because the architecture (200+ hardcoded colors, no tokens) makes full individual theming a 3-month project.

**Verify:** In reduced-brightness mode, navigate through the app. Tier 1 surfaces (nav, cards, page backgrounds, buttons) should have distinctly different colors — not just dimmed. Tier 2 surfaces should be visibly dimmed but still readable. No white flashes between pages. Run an automated contrast check — all text should meet WCAG AA (4.5:1 for body text, 3:1 for large text).

---

## State machine

```
User visits app
    │
    ├── First visit, no stored preference
    │       → Check OS prefers-color-scheme
    │           ├── dark → Apply Reduced Brightness, save to localStorage
    │           └── light → Apply Light, save to localStorage
    │
    └── Returning visit, preference stored
            → Read localStorage → Apply stored mode
            → On login: read profile API → if different from localStorage, profile wins
                (profile = cross-device source of truth)

User toggles in Settings
    → Apply immediately (no reload)
    → Save to localStorage (instant)
    → POST to profile API (async, cross-device sync)
```

**Verify:** Set OS to dark mode. Clear localStorage. Visit the app. Should auto-detect and apply Reduced Brightness. Toggle to Light manually. Close and reopen. Light should persist (manual override beats OS preference). Log in on a different browser. Mode should sync to Light (profile API).

---

## What Design negotiated

| With | What was proposed | What Design pushed back on | What we agreed |
|------|-------------------|---------------------------|----------------|
| PM/CEO | "Dark mode by Friday" | 200+ hardcoded colors, no token system. Full dark mode = 3-month migration. | Reduced brightness v1 in 2 weeks. Full dark mode roadmapped behind token system. |
| Engineer | "Should we refactor colors while we're in there?" | No. That's scope creep into B4 (deferred). v1 is overlay + 12 properties. | Engineer matches v1 spec only. Token migration is a separate project. |

## What goes suspect if this changes

- If the 12 primary surfaces change (new nav layout, new card design) → Tier 1 values need updating
- If WCAG requirements change (AA → AAA) → Tier 2 overlay ratio may need adjustment from 0.85 to something lower
- If the token system lands → Tier 2 disappears entirely, all surfaces become Tier 1
