# PM — Ghost Feature Closure

## What happened

Engineer escalated during routine sanity reconciliation: "PDF export is broken, unused, and the library is dead. Fix or remove?"

PM doesn't guess. PM checks the requirement's lineage.

## The requirement was already dead

REQ-08 — Monthly report PDF export. Originated 2 years ago from a monthly reporting workflow.

That workflow was replaced by a live dashboard 18 months ago. The dashboard was the replacement. Nobody formally closed REQ-08 when the workflow died. It sat in the system, unfunded, unstaffed, unowned.

**Checked:**
- Original source: monthly reporting workflow (replaced 18 months ago by dashboard)
- Current stakeholder: none. The reporting workflow owner moved teams. No one inherited it.
- Usage: 3 invocations in 90 days, all from one intern, all produced 0-byte files, all abandoned
- Active requests for PDF export: zero

No stakeholder. No workflow. No users. No requests.

**Verify:** Search the ticket system for any open request mentioning PDF export or monthly report generation. There are none. The last related ticket was closed 18 months ago when the dashboard shipped.

## Decision: remove

The right answer isn't to find a new PDF library. It's to close REQ-08 as superseded and remove the feature from all inventories.

**Verify:** After removal, the inventory is smaller: REQ-08 is gone. The remaining requirements (REQ-12 dashboard reporting, REQ-14 email digest) all have active stakeholders who validated them within the last 60 days.

## Why shrinking is healthy

The system had 3 requirements. Now it has 2. That's not a loss — it's honesty. REQ-08 was dead weight generating false confidence ("we support PDF export") and wasting engineering attention during code reviews and inventory walks.

A smaller inventory where every item is real is better than a larger inventory where some items are ghosts.

**Verify:** Every remaining requirement in the inventory has: (a) an active stakeholder, (b) validation within 60 days, (c) a working proof in QA's inventory. If any requirement fails these three checks, it's a candidate for the same treatment REQ-08 got.
