## US-VERT791 — Module contract prerequisite — main contract must be active before...

| Field | Value |
|-------|-------|
| **ID** | US-VERT791 |
| **Traced from** | [VERT791](../compliances/SV/VERT791.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | VTG |

### User Story

As a practice owner, I want module contract prerequisite — main contract is active before module contracts can be used, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a Modulvertrag, when the Hauptvertrag is not active, then module contract activation is blocked


### Actual Acceptance Criteria

**Status: Partially Implemented**

1. **Partially met.** Contract data model includes `ModuleChargeSystems` separate from main `ChargeSystems`, indicating module contract awareness. However, no explicit enforcement logic found that blocks module contract activation when the Hauptvertrag (main contract) is not active.
