# 005 — Sanity Reconciliation Catches a Ghost Feature

**Trigger:** Routine daily sanity check on Engineer's inventory.

No customer story. No ticket. No request. Just an engineer doing inventory reconciliation.

---

### Step 1: Engineer spots a stale item during reconciliation

Daily sanity. Engineer walks their inventory. Notices a flow: "Export to PDF — monthly report generation."

**Staleness check:** When was this last touched? 14 months ago.

#### Inventory

```
Engineer
  Flows (pre-existing)
    ...
    [FLW-99] Export to PDF — monthly report generation   ← last modified 14 months ago
    ...
  Sanity flag
    + [FLW-99] flagged STALE (14 months untouched)
```

---

### Step 2: Correctness check — the flow is silently broken

Engineer runs the flow manually. It fails silently.

**Discovery:** The PDF library was deprecated 8 months ago. The export returns HTTP 200 with an empty response body. No error. No log. No alert.

Why didn't tests catch it? The test mocks the PDF library. The mock still passes. The real dependency is dead.

#### Inventory

```
Engineer
  Flows
    ~ [FLW-99] Export to PDF                             ← STALE → NOT PROVEN
        Staleness: 14 months
        Correctness: BROKEN (PDF library deprecated, silent 200 + empty body)
        Root cause: dependency died 8 months ago, no one noticed

QA
  Proof registry (pre-existing)
    [VP-99] Export to PDF generates valid PDF
        Mechanism: unit test with mocked PDF library     ← FALSE PROOF
        Status: passing (mock doesn't know library is dead)
        Degradation signal: none configured               ← GAP
  Sanity flag
    + [VP-99] proof mechanism is disconnected from reality
```

---

### Step 3: Coverage check — does anyone use this?

Engineer checks analytics before deciding whether to fix or remove.

**Findings:**
- 3 invocations in the last 90 days
- All from the same internal user (an intern)
- All resulted in 0-byte file downloads, all abandoned

Nobody uses this. The 3 attempts were someone discovering it's broken and giving up.

#### Inventory

```
Engineer
  Flows
    ~ [FLW-99] Export to PDF
        Staleness: 14 months
        Correctness: BROKEN
        + Coverage: 3 uses in 90 days, all failed, all from one intern
        Recommendation: REMOVE

QA
  ~ [VP-99] FALSE PROOF (mocked test, real dep dead, no users)
```

---

### Step 4: PM confirms — feature is not needed

Engineer escalates to PM: "This flow is broken, unused, and unfixable without a new PDF library. Should we fix or remove?"

PM checks: Is there an active requirement for PDF export?
- Original requirement was from 2 years ago, tied to a monthly reporting workflow
- That workflow was replaced by a dashboard 18 months ago
- No current stakeholder needs PDF export

**Decision: remove.**

#### Inventory

```
PM
  Requirements
    ~ [REQ-XX] Monthly report PDF export                 ← SUPERSEDED
        Original source: reporting workflow (replaced 18 months ago)
        Status: CLOSED — no active stakeholder
        Action: remove from all inventories

Design         (checking for screen references)
Engineer       (pending removal)
QA             (pending removal)
DevOps         (checking for operational references)
```

---

### Step 5: Coordinated removal across all verticals

Every vertical removes the ghost feature from their inventory.

#### Inventory changes (all in one step — the removal is the event)

```
PM
  ~ [REQ-XX] Monthly report PDF export → REMOVED (closed as superseded)

Design
  ~ [SCR-XX] "Export Report" button on dashboard → REMOVED
  ~ State machine: removed export-triggered states

Engineer
  ~ [FLW-99] Export to PDF → REMOVED
  ~ Code: PDF export endpoint, controller, service layer → DELETED
  ~ Dependencies: PDF library removed from package manifest

QA
  ~ [VP-99] Export to PDF verification → REMOVED
  ~ Mocked test suite for PDF export → DELETED

DevOps
  (no infrastructure was dedicated to this feature — nothing to remove)
  + Note: no observability existed for this flow — that's WHY it died silently
```

---

### Step 6: Post-mortem — what allowed this ghost to exist?

This isn't just a cleanup story. It's a systemic failure that sanity reconciliation caught.

**Three failures enabled the ghost:**

1. **Test mocked the dependency** — QA's proof mechanism was disconnected from reality. The mock passes forever regardless of the real library's status.

2. **No degradation signal** — DevOps had no observability on export success/failure. The flow could die silently without triggering any alert.

3. **No staleness reconciliation** — Nobody checked the inventory for 14 months. The flow sat there, broken, consuming mental overhead for every engineer who read the codebase.

**Preventive action:**
- Engineer adds a sanity check to inventory reviews: any flow untouched >6 months gets a manual correctness check
- QA adds a rule: mocked tests for external dependencies must have a companion integration test or a degradation signal
- DevOps adds a coverage audit: every flow in Engineer's inventory must have at least one observability signal in production

#### Inventory (new preventive items)

```
QA
  Rules
    + No mocked-only proof for external dependencies.
      Every mock test must have either:
      (a) a companion integration test against real dependency, OR
      (b) a production degradation signal that fires when the dependency dies

DevOps
  Observability audit
    + Every flow in Engineer's inventory must map to ≥1 production signal.
      Flows with zero signals are flagged as unobservable.
```

---

### Final inventory snapshot

```
All verticals: ghost feature fully removed.

Net inventory change: SMALLER (fewer items, all remaining items proven).

New systemic rules:
  QA: no mock-only proofs for external deps
  DevOps: every flow needs production observability
  Engineer: 6-month staleness trigger for manual review
```

**The right answer wasn't to fix the PDF export. It was to delete it.** Sanity reconciliation — checking staleness, then correctness, then coverage — led to the right outcome: a smaller, more honest inventory.
