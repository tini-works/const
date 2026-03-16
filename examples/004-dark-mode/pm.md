# PM — Dark Mode

## The CEO's words

> "Competitors have dark mode. We need it by Friday."

No customer story. No support tickets driving this. A competitive reaction. The Constitution doesn't forbid it — but you don't ship a CEO's whim without grounding it first.

## Finding the real story

PM didn't push back on the CEO. PM went looking for data.

**What the data showed:**
- 12 dark mode requests in 6 months (out of 2,000 total feedback items). Not a trend.
- No correlation between dark mode absence and churn. Nobody's leaving over this.
- But: **40% of sessions happen after 8 PM.** Users work late. Low-light viewing comfort is a real need — it's just not the one the CEO described.

**Verify:** Pull session time distribution from analytics. Filter to sessions starting after 8 PM. The 40% number should hold. If it doesn't, the entire scope rationale changes.

## What got negotiated

Design tried to map full dark mode to the codebase and found 200+ hardcoded color values with no token system. Full dark mode is a 3-month design system migration, not a toggle flip. This changed the conversation entirely.

PM took Design's finding back to the CEO:

| What the CEO wanted | What's actually deliverable | What we agreed |
|---------------------|---------------------------|----------------|
| "Dark mode by Friday" | Full dark mode = 3-month design system migration | Reduced-brightness v1 in 2 weeks |

The CEO got a Friday demo of the toggle working on primary screens. Engineering got a sane scope. Nobody got a 3-month surprise at month 2.

## What we committed to

### 1. Low-light comfort viewing (v1 — shipped)

Users in low-light conditions get a comfortable experience. Not "dark mode" — reduced brightness. Covers all screens via a combination of CSS custom properties on 12 primary surfaces and an opacity overlay on everything else.

**Verify:** Toggle reduced-brightness mode in Settings > Appearance. All 12 primary surfaces should use proper dark values (not just dimmed). Remaining surfaces should be visibly dimmed via overlay. No jarring white flashes when navigating between screens.

### 2. Preference persists across sessions and devices (shipped)

User toggles once. It sticks. Across tabs, across browser restarts, across devices (when logged in).

**Verify:** Toggle to reduced-brightness. Close the browser. Reopen. Mode should be retained (localStorage). Log in on a different device. Mode should sync (profile API).

### 3. Full dark mode — all screens individually tuned (deferred)

Blocked by the missing design token system. Partial dark mode with some screens light and some dark is worse than no dark mode at all — jarring transitions between themed and unthemed screens.

**Depends on:** REQ-404 (design token system). Cannot start until tokens replace the 200+ hardcoded colors.

**Verify:** Not verifiable yet. Will become verifiable when the token migration is complete. Track token migration progress against this commitment.

### 4. Design token system (roadmapped)

Design's discovery: no token system exists. This is infrastructure debt that blocks not just dark mode but any future theming, white-labeling, or brand customization.

**Verify:** Check if a design token file exists (e.g., `tokens.css`, `theme.ts`). Today it doesn't. When REQ-404 ships, this file should define all color values, and no CSS file should contain hardcoded hex values.

## What goes suspect if things change

- If evening session percentage drops significantly → commitment 1 rationale weakens (but v1 is already shipped, so this is about whether to pursue full dark mode)
- If Design completes the token migration → commitment 3 unblocks, scope discussion reopens
- If the CEO changes priority away from theming → commitment 4 roadmap timeline shifts
- If new hardcoded colors are added to the codebase → v1 overlay coverage degrades (QA's VP-42 tracks this)
