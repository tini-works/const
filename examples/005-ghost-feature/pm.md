# PM Inventory — 005 Ghost Feature Removal

**Source:** Engineer's routine sanity check exposed a dead feature.

## Requirements Removed

| ID | Requirement | Original source | Action | Reason |
|----|-------------|----------------|--------|--------|
| REQ-XX | Monthly report PDF export | Reporting workflow (2 years ago) | REMOVED | Workflow replaced 18 months ago, no active stakeholder, 0 active users |

## How PM was involved

Engineer escalated: "This flow is broken, unused, and unfixable without a new PDF library. Fix or remove?"

PM checked:
- Original requirement tied to monthly reporting workflow
- That workflow was replaced by a dashboard 18 months ago
- No current stakeholder needs PDF export
- 3 uses in 90 days, all by one intern, all failed

Decision: **remove.**

## Observations

- PM's inventory shrank. This is healthy.
- A requirement traced to a dead workflow with no active stakeholder is inventory rot.
- Removing it is as important as adding new items.
- Proven by absence of need: no stakeholder, no workflow, no users.
