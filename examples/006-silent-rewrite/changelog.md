# 006 — Freedom in Action: Engineer Rewrites a Service, Nobody Notices

**Trigger:** Engineer decides the order-processing service (Python, monolith) should be rewritten in Go (microservice).

In a traditional org: proposal, architecture review, manager approval, migration plan, stakeholder buy-in, feature flag strategy, 3 months of meetings.

In the Constitution: **do the boxes still match?**

---

### Step 1: Engineer checks existing boxes

Before writing a single line of Go, the engineer reads their inventory. What boxes are they accountable for?

#### Inventory (pre-existing state)

```
PM
  Boxes held by Engineer (for order processing)
    B1: Order status is queryable by customer and support within 5 seconds of state change
    B2: Order processing handles up to 500 concurrent orders without degradation

Design
  Boxes held by Engineer
    B3: Order confirmation screen appears within 2 seconds of payment

QA
  Verification paths (47 total for order processing)
    VP-01..VP-47: covering order creation, payment capture, fulfillment trigger,
                  status updates, refund flow, edge cases
  All currently PROVEN against Python implementation

DevOps
  Boxes held by Engineer
    B4: 99.9% uptime SLA
    B5: P95 latency < 500ms
  Current metrics
    P95 latency: 380ms (within SLA but not great)
    Uptime: 99.94% (within SLA)
```

**All boxes are known. All are currently proven. The engineer proceeds.**

---

### Step 2: Engineer rewrites — no permission asked

The engineer writes the Go service. This is internal to their vertical. No boxes are being renegotiated. No upstream inventory is affected.

**What they do:**
- Write Go service matching the same API contract
- Same endpoints, same request/response shapes, same event emissions
- Internal implementation is completely different (goroutines vs threads, different DB driver, etc.)

**What they don't do:**
- Ask PM for approval (PM's boxes don't mention implementation language)
- Tell Design (Design's box is about screen timing, not backend stack)
- Write a proposal or RFC

#### Inventory

```
Engineer
  System design
    ~ Order processing service: Python monolith → Go microservice
    Implementation changed. API contract unchanged.
    Status: IN PROGRESS (not yet proven)

  All other inventories unchanged — no boxes affected yet.
```

---

### Step 3: Engineer runs all 47 verification paths

The rewrite is done. Before deploying, the engineer runs QA's verification paths against the Go service.

All 47 pass.

#### Inventory

```
Engineer
  System design
    ~ Order processing service: Go microservice
    + All 47 verification paths pass against new implementation
    Status: LOCALLY PROVEN (not yet in production)

QA
  Verification paths
    VP-01..VP-47: run against Go service → ALL PASS
    Note: proofs re-established against new implementation
```

---

### Step 4: Deploy to staging — performance improves

Engineer deploys to staging. Runs load test.

**Results:**
- P95 latency: 380ms → 90ms (4x improvement)
- Memory usage: 2.1GB → 340MB
- Cold start: 12s → 0.8s

All within existing boxes. In fact, significantly exceeding them.

#### Inventory

```
Engineer
  System design
    ~ Order processing: Go microservice
    Staging metrics:
      P95 latency: 90ms (box requires <500ms) ✓
      Concurrent capacity: tested 2000 (box requires 500) ✓

DevOps
  Staging verification
    + B4 (uptime): staging health checks green
    + B5 (latency): 90ms P95 — well within 500ms SLA
    + Load test: 2000 concurrent orders, no degradation
```

---

### Step 5: Canary deploy to production

Engineer canary-deploys to 5% production traffic. Monitors.

#### Inventory

```
Engineer
  Deployment
    + Canary: 5% traffic to Go service, 95% to Python service
    + 24-hour canary window

DevOps
  Observability (canary period)
    + Error rate comparison: Go 0.02% vs Python 0.03% (Go is cleaner)
    + Latency comparison: Go P95 92ms vs Python P95 375ms
    + No anomalies in order completion rate
```

---

### Step 6: Full rollout — transition mechanic fires

Engineer promotes Go service to 100%. Python service decommissioned.

**The transition mechanic fires automatically** because Engineer's inventory changed. Two verticals are notified:

**QA notified** — Engineer's implementation changed. QA must explicitly re-verify.
**DevOps notified** — Deployment pipeline inventory changed. DevOps must verify operational boxes.

**PM not notified** — none of PM's boxes were affected.
**Design not notified** — none of Design's boxes were affected.

#### Inventory

```
PM
  (not notified — B1, B2 unaffected)
  Boxes: unchanged, still PROVEN

Design
  (not notified — B3 unaffected)
  Boxes: unchanged, still PROVEN

Engineer
  System design
    ~ Order processing: Go microservice (LIVE, 100% traffic)
    ~ Python service: DECOMMISSIONED
  Boxes matched
    B1 ← order status queryable <5s ✓ (faster than before)
    B2 ← 2000 concurrent tested ✓ (4x headroom)
    B3 ← confirmation <2s ✓ (90ms backend)
    B4 ← 99.9% uptime ✓
    B5 ← P95 <500ms ✓ (92ms actual)

QA
  Verification paths
    ~ VP-01..VP-47: re-run against production Go service → ALL PASS
    Status: PROVEN (re-verified post-transition)

DevOps
  Infrastructure
    ~ Order processing: Go microservice, new container image, new resource profile
    ~ Python runtime dependencies: REMOVED from production
  Observability
    ~ Dashboards updated: new service name, same metrics
    ~ Alerts: same thresholds, now targeting Go service
  Boxes matched
    B4 ← uptime 99.97% during rollout ✓
    B5 ← P95 92ms ✓
```

---

### Step 7: The next standup

PM and Design learn about the rewrite at the next standup. Their reaction:

> "Cool. Our boxes still match?"
> "Yes."
> "Great."

End of discussion.

---

### Final inventory snapshot

```
PM (not involved — correct)
  B1, B2 still PROVEN. No action required.

Design (not involved — correct)
  B3 still PROVEN. No action required.

Engineer (full rewrite, zero approval needed)
  Python → Go. All 47 verification paths pass.
  All 5 boxes match. Performance exceeds SLA by 4x.

QA (auto-notified, re-verified)
  VP-01..VP-47 PROVEN against new implementation.

DevOps (auto-notified, verified)
  Infrastructure updated. Observability remapped. Boxes match.
```

**Freedom is the reward for maintaining proven matches.** The engineer changed everything about *how* the service works. Nothing about *what* it proves changed. No permission needed.

**This only works because proofs are real.** If the 47 verification paths were mocked or shallow, the Go rewrite could ship broken and nobody would know until customers complained. Freedom without rigorous proof is just recklessness.
