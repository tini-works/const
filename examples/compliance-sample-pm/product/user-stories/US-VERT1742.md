## US-VERT1742 — The Vertragssoftware must enable enrollment and activation of contract participation...

| Field | Value |
|-------|-------|
| **ID** | US-VERT1742 |
| **Traced from** | [VERT1742](../compliances/SV/VERT1742.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E3: Contract & Enrollment](../epics/E3-contract-and-enrollment.md) |
| **Data Entity** | TNV, BST, ARZ |

### User Story

As a practice owner, I want the Vertragssoftware enable enrollment and activation of contract participation across all Betriebsstaetten of the same LANR when they share the same software, to prevent redundant per-location activations, so that contract participation is managed correctly.

### Acceptance Criteria

1. Given a physician with multiple Betriebsstaetten using the same software, when contract participation is activated for a patient, then it applies across all Betriebsstaetten of that LANR without separate per-location activation


### Actual Acceptance Criteria

**Status: Not Implemented**

1. **Not met.** No cross-Betriebsstaetten propagation logic found. The enrollment and participation services operate per care provider context. No mechanism propagates contract participation activation across multiple Betriebsstaetten of the same LANR.
