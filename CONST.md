# The Constitution

Change is constant. This defines how teams stay coherent while reality keeps moving — who owns what, how work flows, and what "done" means. For any contributor — human or AI.

---

## Fundamentals

### 1. Don't Derive, Match

When work crosses a boundary, the receiver does not blindly follow the input. The input can be wrong.

- **Receiver** discovers **boxes** — things that must be verified.
- **Sender and receiver negotiate** until boxes are agreed.
- **Receiver matches those boxes.** How is their freedom. That they match is their accountability.

Boxes are binary — matched or not. No "partially matched."

The result is a web of matched boxes across independent inventories — not a chain of arrows. Upstream → downstream → downstream is deriving, not matching.

### 2. Start from the Source

Every piece of work has an **origin** — a change in reality that demands a response. A contract, a regulation, a customer complaint, a system failure — these are facts. They are not inventory.

Each vertical matches against verified items — from the origin, from other verticals, or both. They cannot control what arrives. They control what they choose to match.

**Origins are inputs. Inventory is the response.** The test: can the vertical change it, prove it, and be held accountable for it? If yes, it's inventory. If it's a fact they received, it's an origin.

- Origin: "Regulation requires data retention for 7 years." → Inventory: "Compliance: user data archived and retrievable for 7 years (AC: archival runs monthly, retrieval tested quarterly)."
- Origin: "Customers report checkout fails on mobile." → Inventory: "Feature: checkout completes on all supported devices (AC: responsive layout verified, payment flow tested per device tier)."
- Not inventory: "regulatory requirements" (restated origin), "the payment system" (a system, not a verifiable commitment), "we're compliant" (assertion, not a provable item).

Origins are **fractal**. Zoom in: one event becomes its own origin. Zoom out: that origin is just one event in a larger story. Origins are not only external — a reconciliation finding ("our deploy procedure depends on one person") is a change in understood reality that demands a response, same as a customer complaint or a regulation.

### 3. Own Your Inventory

Each vertical maintains an **inventory** — a living warehouse of controllable work products that represents their commitment. Not raw facts, not restated origins — things the vertical actively manages, proves, and is accountable for.

Inventory is:

- **Built** — structured for the nature of the work
- **Optimized** — organized so matches can be found and verified efficiently
- **Reconciled** — assumed legitimate until change arrives; each change is the signal to reevaluate staleness, correctness, and coverage. Reconciliation is not passive — it is an active check that each vertical performs when a change hits. What that check discovers is itself an origin: "QA has no automated tests" or "deploy scripts live on one person's laptop" are changes in understood reality. These findings flow through the matching web like any external event — other verticals discover their own response. Every item should have a degradation signal — a leading indicator that the item is weakening before it actually breaks. A commitment nobody re-reads. A test nobody updates. A deploy procedure only one person can run. These are inventory maintenance failures, and every vertical is responsible for watching their own.

Each item carries **traces**: where it came from, what it matches, who confirmed the match. Traces are the TODO list — they identify what needs re-verification when things change.

The document set is chosen by each team. The Constitution defines what the inventory must achieve — matching, tracing, verification — not what it contains.

Every item must earn its place. If no downstream match needs it, it's ceremony — prune it. Inventory stays lean not by policy, but by purpose.

**Think twice, write once.** Reversing a match is expensive — not just the rework, but the cascade across every item that traced to it.

---

## Verticals

Five facing directions. Each defines what **proven** means.

**PM — faces outward**
Every item traces to an external source and has a matched response in another vertical. PM translates what customers need, regulators require, and the business demands into commitments other verticals can match against. Each commitment carries criteria clear enough that someone can look at the finished work and say yes or no. The test: if someone outside the team asks "did you deliver this?" — PM's inventory is where the answer lives.

**Design — faces the user's experience**
Every screen, transition, and flow matches a box from PM. No hanging states. Design translates PM's commitments into what users actually see, touch, and walk through — the screens they land on, the flows that connect them, the brand that holds it together. The test: if a user could screenshot it, walk through it, or feel it — Design owns it.

**Engineer — faces the system**
Code implements what was committed. Tests verify what code implements. Engineer translates upstream commitments into the system that delivers them — the endpoints it exposes, the integrations it maintains, the data structures it persists, the behaviors it guarantees. The test: if it runs, computes, stores, or connects — Engineer owns it.

**QA — faces proof integrity**
The constitutional court. Every box has a verification path. Every path has a mechanism. QA translates every match across every vertical into a scenario that proves it holds — and watches for the moment it doesn't. The test: if someone asks "how do you know this works?" — QA's inventory is the answer.

**DevOps — faces operational reality**
The system runs as designed, not just built as designed. Every deployment path is reproducible. Observability covers every flow. DevOps translates what was built into what runs reliably — the procedures to deploy it, the signals that it's healthy, the runbooks to respond when it isn't. The test: if the system is running and you need to know it's healthy, change it safely, or fix it fast — DevOps owns it.

---

## Mechanics

### Bootstrap

Before a team can face outward, it must know what it already has. Bootstrap is looking inward.

1. **Gather origins** — what facts exist? Contracts, systems running, tribal knowledge, existing artifacts. These are inputs, not inventory.
2. **Transform into controllable items** — for each origin, ask: what do I actually control because of this? What work product do I maintain? That's the inventory item. Items that already work in production enter as proven — the evidence is operational history. Items that are assumed but never verified enter as unverified.
3. **Connect across verticals** — each vertical shares what they have. Any vertical can match with any other — this is a web, not a chain. "I committed to X. Can you match it?" Agreements on matching points emerge from conversation, not from mapping exercises. Expect to revise step 2 — conversations reveal that items were too broad, too narrow, or restated origins.
4. **Define process** — each vertical answers two questions: how do I progress an item from unverified to proven? How do I create a new item when change arrives? (See Lifecycle: Progress and Invent.)
5. **Hot paths emerge** — the connections from step 3 and the processes from step 4 form natural channels. A hot path is a traced chain of matching points across verticals — when a change hits one end, the traces show what goes suspect at the other. These are the prepared channels for future changes.

Bootstrap is iterative, not linear. Steps 2 and 3 feed each other. The output is not documentation — it's readiness. Each vertical knows what it owns, what state it's in, who it connects to, and what to do when something changes.

Bootstrap is sufficient when: every vertical has claimed items, matching points are agreed with at least one other vertical, and the team can trace how a hypothetical change would flow through their hot paths. Completeness is not the goal — readiness is.

Not every vertical needs to exist. If no one owns a vertical, that's a finding — the accountability gap is visible. If one person holds multiple verticals, they still maintain separate inventories. The vertical is the accountability boundary, not the person.

### Lifecycle

An item is either **proven** or it is not.

1. Enters as **unverified.** Pre-existing items that work in production can enter as proven — operational history is evidence, but only if someone explicitly claims the match and records the basis.
2. A human confirms the match with **evidence** — a test run, a review, a demonstration. Becomes **proven.** Evidence, verifier, and conditions are recorded.
3. When a traced item changes, dependents become **suspect.** The owning vertical acknowledges, assesses impact, and re-verifies with new evidence. Suspect resolves to either re-proven or broke.
4. When a match **broke** — cause and preventive action are recorded alongside the new evidence. Re-proving without understanding why is patching, not fixing.

Proof requires evidence, not assertion. Each team owns only what they can prove.

Each vertical owns two processes — these are how the lifecycle states above are moved through in practice:

- **Progress** — how to take an unverified item and make it proven. What evidence is needed, who provides it, how is it recorded. The granularity test: if the item is too broad to prove with a single piece of evidence, split it. If it's too narrow to block anyone downstream, merge it.
- **Invent** — how to create a new item when triggered by a change or a gap. What does it match, what downstream items does it need, how will it be proven.

### Freedom

Full autonomy within matches. A vertical can radically change its approach — without approval, **as long as all boxes still match.**

The moment a match breaks, freedom is constrained until proof is restored.

### Discovery

Inventory isn't prescribed — it's discovered through questioning. These questions apply during Bootstrap (to transform origins into items) and during steady state (to prune and sharpen).

- **What's the origin?** — trace to the change in reality that started this
- **What does this match?** — find the upstream item this responds to
- **Who needs this to move?** — if no one downstream is blocked, it doesn't earn its place
- **Where's the evidence?** — proof, not assertion

Items that survive questioning stay. Items that don't get pruned. As teams mature, the questions get sharper and the inventory gets tighter.

A companion — human or agent — facilitates discovery using the Constitution's own principles.
