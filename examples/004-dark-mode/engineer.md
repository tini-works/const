# Engineer — v1 Reduced Brightness

Four implementation pieces. Minimal scope. Matches the boxes, nothing more.

---

## FLW-40: CSS custom properties for 12 primary surfaces

**What it does:** Defines 12 CSS custom properties on `:root` with light-mode defaults. A `.reduced-brightness` class on `<html>` swaps them.

```css
:root {
  --color-bg-page: #ffffff;
  --color-bg-card: #f8f9fa;
  --color-text-primary: #212529;
  --color-text-secondary: #6c757d;
  --color-border: #dee2e6;
  --color-nav-bg: #f8f9fa;
  --color-nav-text: #212529;
  --color-btn-primary-bg: #0d6efd;
  --color-btn-primary-text: #ffffff;
  --color-input-bg: #ffffff;
  --color-input-border: #ced4da;
  --color-accent: #0d6efd;
}

html.reduced-brightness {
  --color-bg-page: #1a1a2e;
  --color-bg-card: #16213e;
  --color-text-primary: #e8e8e8;
  --color-text-secondary: #a0a0b0;
  --color-border: #2a2a4a;
  --color-nav-bg: #0f3460;
  --color-nav-text: #e8e8e8;
  --color-btn-primary-bg: #1a73e8;
  --color-btn-primary-text: #ffffff;
  --color-input-bg: #1a1a2e;
  --color-input-border: #2a2a4a;
  --color-accent: #4dabf7;
}
```

**Why 12 and not 200+:** The 12 properties cover the primary surfaces (nav, cards, page backgrounds, buttons, inputs). These are the surfaces users see most. The remaining 200+ hardcoded colors are covered by the overlay (FLW-42). Refactoring all 200+ is B4 (deferred). Engineer matches current boxes, not future ones.

**Verify:** Inspect any primary surface element in DevTools. Its `background-color` or `color` should resolve to a `var(--color-*)` reference. Toggle the `.reduced-brightness` class on `<html>`. The computed value should change.

**Depends on:** Design's v1-spec (SCR-41) for the exact color values.

---

## FLW-41: Mode switching — media query + manual toggle

**What it does:** Two paths to activate reduced-brightness mode:

1. **Auto-detect:** `@media (prefers-color-scheme: dark)` — if the user's OS is in dark mode and they haven't set a manual preference, apply reduced-brightness automatically
2. **Manual toggle:** JavaScript adds/removes `.reduced-brightness` class on `<html>` — no page reload

```js
// On page load
const stored = localStorage.getItem('color-mode');
if (stored) {
  applyMode(stored);  // manual preference wins
} else if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
  applyMode('reduced-brightness');  // OS fallback
}

// On toggle
function toggleMode() {
  const next = currentMode === 'light' ? 'reduced-brightness' : 'light';
  applyMode(next);
  localStorage.setItem('color-mode', next);
  syncToProfile(next);  // async, non-blocking
}
```

**Verify:** Set OS to dark mode. Clear localStorage. Load the app. Should be in reduced-brightness. Toggle to light in Settings. Reload. Should stay light (localStorage wins). Change OS back to light. Reload. Still light (manual override persists).

**Depends on:** FLW-40 (CSS properties must exist for the class toggle to have effect).

---

## FLW-42: Opacity overlay for non-tokenized surfaces

**What it does:** All elements that still use hardcoded colors get a CSS filter to dim them in reduced-brightness mode.

```css
html.reduced-brightness .non-tokenized {
  filter: brightness(0.85);
}
```

In practice, this is applied broadly and the 12 tokenized surfaces are excluded (they handle their own colors via custom properties).

**Why this is ugly and intentional:** An opacity overlay is a blunt tool. Colors aren't individually tuned. Some elements will look washed out. But it covers all 200+ hardcoded colors without touching them. The alternative — refactoring every hardcoded value — is a 3-month project. The overlay matches the v1 box (B1: comfortable viewing in low light). It doesn't match B2 (full dark mode), which is deferred.

**Verify:** In reduced-brightness mode, inspect a non-tokenized element (one that still uses a hardcoded hex color). It should have `filter: brightness(0.85)` applied. Run an automated contrast check on overlaid text. All should meet WCAG AA (4.5:1).

**Depends on:** Nothing — it's a catch-all that works regardless of the token state of any element.

---

## FLW-43: Preference sync — localStorage + profile API

**What it does:** Two-layer persistence for the user's mode preference.

| Layer | Purpose | Speed | Scope |
|-------|---------|-------|-------|
| localStorage | Instant persistence | Synchronous, no network | Single browser |
| Profile API (`PUT /api/user/preferences`) | Cross-device sync | Async, non-blocking | All devices when logged in |

**Read priority on page load:**
1. Check localStorage (instant, no flash of wrong mode)
2. On login, fetch profile API preference. If different from localStorage, **profile wins** (it's the cross-device source of truth). Update localStorage to match.

**Write flow on toggle:**
1. Update localStorage immediately
2. Fire async `PUT /api/user/preferences { "colorMode": "reduced-brightness" }` — non-blocking, no UI wait

**Verify:** Toggle mode. Check localStorage — `color-mode` key should update. Check network tab — a PUT to `/api/user/preferences` should fire. Log in on a different browser. The mode should match. Change mode on the second browser. Return to the first. On next page load or login event, the mode should sync.

**Depends on:** The profile API endpoint already exists (used for other user preferences). No new backend work needed.

---

## Explicit non-action

**Did NOT refactor the 200+ hardcoded colors.** That work belongs to B4 (design token system, roadmapped). The overlay in FLW-42 covers the gap. It's intentional tech debt — documented, scoped, and accepted by PM and Design.

The temptation to "clean up while we're in there" is scope creep. The box says B1 (comfortable viewing) and B3 (persistent preference). The implementation matches those boxes. Nothing more.

## Dependency chain

```
FLW-40 (CSS properties)
    └── FLW-41 depends on this (toggle needs properties to swap)
        └── FLW-43 depends on this (persistence needs toggle to exist)
FLW-42 (overlay) — independent, no dependencies
```

## What goes suspect if this changes

- If new CSS is added with hardcoded colors → FLW-42's overlay covers it automatically, but FLW-40's token list may need expanding if it's a primary surface
- If the profile API changes its preferences endpoint → FLW-43 breaks for cross-device sync (localStorage still works)
- If someone removes the `.reduced-brightness` class handling → all four flows break
- If the design token system ships (B4) → FLW-42 (overlay) can be removed entirely, FLW-40 expands from 12 to all properties
