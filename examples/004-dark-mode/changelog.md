# 004 — Startup: "Add Dark Mode"

**Trigger:** CEO saw a competitor's dark mode. Wants it by Friday.

There is no customer story. This is a competitive reaction. The Constitution doesn't forbid it — but Fundamental #2 says start from the customer's story.

---

### Step 1: PM looks for the story

PM doesn't parrot the CEO's request. Goes looking for grounding.

**Research:**
- 12 dark mode feature requests in 6 months (out of 2,000 total)
- No correlation with churn
- But: 40% of sessions happen after 8 PM (users work late)

**Boxes created — now grounded in data, not CEO's whim:**
- `B1` Users in low-light conditions should have a comfortable viewing experience
- `B2` Dark mode must cover all screens (partial = jarring transitions)
- `B3` User preference must persist across sessions and devices

#### Inventory

```
PM
  Requirements
    + [REQ-401] Low-light comfort viewing                → source: usage data (40% after 8PM)
    + [REQ-402] Full-screen coverage                     → source: UX principle (partial = worse)
    + [REQ-403] Persistent preference                    → source: cross-device expectation
  Boxes sent
    + B1 → Design
    + B2 → Design
    + B3 → Design

Design        (empty)
Engineer      (empty)
QA            (empty)
DevOps        (empty)
```

---

### Step 2: Design discovers the real problem

Design starts mapping screens to plan dark mode coverage. Finds:

> Colors are hardcoded in 200+ places. There is no design token system. Dark mode isn't a toggle — it's a design system migration.

Design raises this to PM:

> "B2 (all screens) is a 3-month project with current architecture. We can match B1 (comfortable viewing) faster with a reduced-brightness mode."

**Box renegotiation:**
- `B1` revised → Reduced-brightness mode for v1 (2-week scope)
- `B2` deferred → Full dark mode after design token migration (roadmap)
- `B4` new → Design token system must be established as infrastructure

#### Inventory

```
PM
  Requirements
    [REQ-401] Low-light comfort viewing
    ~ [REQ-402] Full-screen coverage → DEFERRED (blocked by architecture)
    [REQ-403] Persistent preference
    + [REQ-404] Design token system                      → source: Design discovery
  Boxes
    ~ B1 → Design (reduced-brightness mode, 2-week scope)  ← REVISED
    ~ B2 → DEFERRED (requires design tokens first)         ← DEFERRED
    B3 → Design
    + B4 → Design/Engineer (design token infrastructure)    ← NEW, roadmap

Design
  Boxes received
    + B1 (revised — reduced brightness), B3, B4 (deferred)
  Discovery
    + No design token system exists. 200+ hardcoded color values.
    + Full dark mode requires token migration first.
  Screens           (not yet)
  State machine     (not yet)

Engineer      (empty)
QA            (empty)
DevOps        (empty)
```

---

### Step 3: Design produces the v1 spec — reduced brightness

Design scopes to what's achievable in 2 weeks without a token system.

#### Inventory

```
PM             (unchanged)

Design
  Boxes received
    B1 (reduced brightness), B3
  Screens
    + [SCR-40] Settings → Appearance toggle (Light / Reduced Brightness)
    + [SCR-41] All screens — reduced-brightness variant
        12 primary surfaces get token treatment
        Remaining surfaces get opacity overlay
  State machine
    + Settings → toggle → mode switch (no page reload)
    + OS-level prefers-color-scheme → auto-detect on first visit
  Boxes sent
    + B1, B3 → Engineer

Engineer      (empty)
QA            (empty)
DevOps        (empty)
```

---

### Step 4: Engineer matches — minimal scope, no gold-plating

Engineer receives Design's spec. Does not refactor the entire color system. That's B2-deferred. Matches the current boxes only.

#### Inventory

```
PM             (unchanged)
Design         (unchanged)

Engineer
  Flows
    + [FLW-40] CSS custom properties for 12 most-used color values
    + [FLW-41] Media query for prefers-color-scheme: dark + manual toggle
    + [FLW-42] Remaining hardcoded colors: subtle opacity overlay (0.85 filter)
    + [FLW-43] Preference storage: localStorage + user profile sync API
  System design
    + 12 CSS custom properties (primary bg, text, borders, accent, etc.)
    + Opacity overlay for non-tokenized areas (ugly in code, matches the box)
    + Toggle state: localStorage for instant, API sync for cross-device
  Boxes matched
    + B1 ← FLW-40, FLW-41, FLW-42 (all surfaces addressed)
    + B3 ← FLW-43 (localStorage + profile sync)
  Note
    + Engineer does NOT refactor the 200+ hardcoded colors.
      That's B4 (deferred). Freedom means matching current boxes, not gold-plating.

QA            (empty)
DevOps        (empty)
```

---

### Step 5: QA scopes proof to v1 — no over-testing

QA doesn't test "full dark mode" — that doesn't exist yet. Proof matches the actual scope.

#### Inventory

```
PM             (unchanged)
Design         (unchanged)
Engineer       (unchanged)

QA
  Verification paths
    + [VP-40] Toggle switches modes, preference persists across sessions
        Mechanism: E2E test — toggle, close, reopen, assert mode
        Degradation: monitor localStorage clear events
    + [VP-41] 12 primary surfaces render correctly in reduced-brightness mode
        Mechanism: screenshot diffing against approved baselines (12 surfaces)
        Degradation: visual regression CI on every deploy
    + [VP-42] Non-tokenized areas meet WCAG AA contrast in reduced-brightness
        Mechanism: automated contrast ratio check on overlay'd elements
        Degradation: new hardcoded colors bypass overlay → coverage gap
    + [VP-43] No regression in light mode
        Mechanism: existing visual regression suite (must still pass)
        Degradation: existing monitors
  Proof coverage
    B1 → VP-41, VP-42
    B3 → VP-40

DevOps        (empty — no infrastructure change for this feature)
```

---

### Step 6: Ship — and note what's NOT shipped

No DevOps inventory changes for this feature. It's a frontend-only change. CSS + localStorage + a profile API call that already exists.

#### Inventory

```
PM
  [REQ-401] Low-light comfort viewing                — PROVEN (v1 shipped)
  [REQ-402] Full-screen coverage                     — DEFERRED (pending REQ-404)
  [REQ-403] Persistent preference                    — PROVEN
  [REQ-404] Design token system                      — ROADMAP (infrastructure)

Design
  SCR-40..41, state machine                          — PROVEN
  B2 (full dark mode)                                — DEFERRED, linked to REQ-404

Engineer
  FLW-40..43                                         — PROVEN
  Note: opacity overlay is tech debt, lives until B4 is addressed

QA
  VP-40..43                                          — PROVEN
  VP-42 has a known coverage gap: new hardcoded colors bypass overlay

DevOps
  (no changes)
```

---

### Final inventory snapshot

```
PM (3 proven, 1 deferred, 1 roadmap)
  Grounded a CEO whim in data. Scoped to 2 weeks. Roadmapped the rest.

Design (2 screens, 1 state machine, 1 architectural finding)
  Caught the missing token system. Prevented a 3-month detour.

Engineer (4 flows, minimal scope, explicit tech debt noted)
  Overlay is ugly. Boxes match. That's the deal.

QA (4 verification paths, known coverage gap documented)
  Won't over-test what doesn't exist yet.

DevOps (nothing — correct for a CSS-only change)
```

**The framework didn't say no to the CEO. It said: "here's what box negotiation reveals about scope." Two-week deliverable + roadmap item, not a 3-month surprise.**
