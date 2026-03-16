# QA — Dark Mode v1 Proofs

Four things we prove. Each one is runnable. Each one has a way to know when it breaks. One known coverage gap, documented honestly.

---

## VP-40: Toggle switches modes, preference persists

**What we're proving:** A user can toggle between Light and Reduced Brightness. The preference survives browser close, and syncs across devices.

**Run:**
1. Open the app in a clean browser (no localStorage)
2. Set OS to dark mode
3. Assert: app auto-detects, applies Reduced Brightness
4. Go to Settings > Appearance
5. Toggle to Light
6. Assert: mode changes instantly, no page reload
7. Close the browser entirely
8. Reopen, navigate to the app
9. Assert: Light mode is still active (localStorage persists)
10. Log in on a second browser/device
11. Assert: Light mode syncs (profile API)
12. Toggle to Reduced Brightness on the second device
13. Return to first device, trigger a page load
14. Assert: Reduced Brightness is now active (profile API wins)

**If it breaks:** Monitor localStorage clear events. If users are losing their preference, either localStorage is being cleared (by another feature, by browser settings) or the profile API sync is failing. Check the PUT `/api/user/preferences` error rate.

---

## VP-41: 12 primary surfaces render correctly in reduced-brightness mode

**What we're proving:** The 12 CSS custom properties produce visually correct dark surfaces — not just dimmed versions of light mode, but properly designed dark values.

**Run:**
1. Toggle to Reduced Brightness
2. Navigate to: home, settings, profile, dashboard (covers all 12 primary surface types)
3. Screenshot each page
4. Diff against approved baselines (Design's v1-spec color values)
5. Assert: page background = `#1a1a2e`, card background = `#16213e`, primary text = `#e8e8e8` (and so on for all 12 values)
6. Toggle to Light
7. Screenshot same pages
8. Diff against light-mode baselines
9. Assert: no visual regressions in light mode

**If it breaks:** Visual regression CI runs on every deploy. If a new commit changes a primary surface color, the screenshot diff will catch it. Investigate whether the CSS custom property was overridden or removed.

---

## VP-42: Non-tokenized areas meet WCAG AA contrast in reduced-brightness mode

**What we're proving:** The opacity overlay (`filter: brightness(0.85)`) on non-tokenized surfaces doesn't push any text below WCAG AA contrast thresholds.

**Run:**
1. Toggle to Reduced Brightness
2. Run automated contrast checker across all pages (axe-core or similar)
3. For every text element on a non-tokenized surface:
   - Assert: contrast ratio >= 4.5:1 (body text) or >= 3:1 (large text / UI components)
4. Flag any elements below threshold
5. If failures: check whether the element has hardcoded colors that produce poor contrast when dimmed

**Known coverage gap:** New hardcoded colors added by engineers will be covered by the overlay automatically, but their post-overlay contrast is untested until the contrast checker runs. If a developer adds white text on a light yellow background, the overlay dims both equally — the contrast stays bad. **This gap closes when the design token system (B4) ships and hardcoded colors are eliminated.**

**If it breaks:** The gap is structural, not a bug. When the contrast checker flags a failure, the fix is to either: (a) add the affected surface to the 12 CSS custom properties (if it's a primary surface), or (b) accept it as known debt until tokens land.

---

## VP-43: No regression in light mode

**What we're proving:** The reduced-brightness implementation didn't break anything in the default light mode. CSS custom properties should resolve to the same values as before. The overlay should not apply in light mode.

**Run:**
1. Toggle to Light (or use default)
2. Run the existing visual regression suite
3. Assert: all existing baselines pass — zero diffs
4. Assert: no element has `filter: brightness(0.85)` applied
5. Assert: all CSS custom properties resolve to their light-mode values

**If it breaks:** Existing visual regression monitors. If light mode breaks, it means the CSS custom property defaults changed or the `.reduced-brightness` class is leaking. Check `<html>` — it should not have the class in light mode.

---

## Coverage

| Commitment | Verified by | Degradation signal |
|------------|-------------|-------------------|
| 1. Low-light comfort viewing | VP-41, VP-42 | Visual regression CI, contrast checker |
| 2. Preference persists | VP-40 | localStorage monitor, API error rate |
| No regression | VP-43 | Existing visual regression suite |

Every commitment has a proof. Every proof is runnable. Every proof has a degradation signal.

## The honest gap

VP-42's coverage is structural, not exhaustive. The overlay covers everything, but "covers" doesn't mean "looks good." New hardcoded colors can produce poor contrast when dimmed. The only permanent fix is the token system (B4). Until then, the contrast checker catches the worst cases, and everything else is accepted debt.
