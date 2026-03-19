---
id: c3-310
title: TUI Architecture Deep Dive
type: component
category: feature
parent: c3-3
goal: Detailed TUI page system, focus zones, layout, and auth flow
summary: Page system, focus zone management, layout components, OIDC auth flow, and AppState patterns
c3-version: 4
---

# tui-architecture
## Goal

In-depth documentation of the TUI's page system, focus zone management, layout components (sidebar, statusbar, log window), Zitadel OIDC authentication flow, shared AppState, and complete Bubble Tea message flow.
## Container Connection

<!-- How does this component advance the parent container's Goal? -->
<!-- What would break in the container without this component? -->

<!--
COMPONENT CATEGORIES:

Foundation (01-09): Infrastructure choices that enable features.
  - Choice: What platform/technology/pattern was chosen
  - Provides: What capability it makes available to other components
  - Fulfills: Which container responsibility it satisfies

Feature (10+): Business capabilities built on foundations.
  - Focuses: What business concern this component addresses
  - Uses: Which foundation components it depends on
  - Follows: Which refs govern its behavior

WHY DOCUMENT:
- Enforce consistency (current and future work)
- Enforce quality (current and future work)
- Support auditing (verifiable, cross-referenceable)
- Be maintainable (worth the upkeep cost)

ANTI-GOALS:
- Over-documenting -> stale quickly, maintenance burden
- Text walls -> hard to review, hard to maintain
- Isolated content -> can't verify from multiple angles

PRINCIPLES:
- Diagrams over text. Always.
- Fewer meaningful sections > many shallow sections
- Add sections that elaborate the Goal - remove those that don't
- Cross-content integrity: same fact from different angles aids auditing

GUARDRAILS:
- Must have: Goal section
- Prefer: 2-4 focused sections
- Each section must serve the Goal - if not, delete
- If a section grows large, consider: diagram? split? ref-*?

REF HYGIENE (component level = component-specific concerns):
- Before writing: does a ref-* already cover this? Cite, don't duplicate.
- Each ref-* cited must directly serve the Goal - no tangential refs.
- If you're duplicating a ref, cite it instead.

Common sections (create whatever serves your Goal):
- Contract (Provides/Expects), Dependencies, Behavior, Edge Cases, Constraints

Delete this comment block after drafting.
-->
## Dependencies

| Direction | What | From/To |
|------|------|------|
| IN | TUI core | c3-301 |
| IN | Service registry | c3-301 |
| OUT | Page implementations | c3-301 |
## Code References

<!-- List concrete code files that implement this component -->
| File | Purpose |
|------|---------|
## Related Refs

<!-- ref-* documents that govern this component's behavior -->
| Ref | How It Serves Goal |
|-----|-------------------|
## Layer Constraints

This component operates within these boundaries:

**MUST:**
- Focus on single responsibility within its domain
- Cite refs for patterns instead of re-implementing
- Hand off cross-component concerns to container

**MUST NOT:**
- Import directly from other containers (use container linkages)
- Define system-wide configuration (context responsibility)
- Orchestrate multiple peer components (container responsibility)
- Redefine patterns that exist in refs
