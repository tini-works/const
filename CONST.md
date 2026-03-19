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

- Origin: "Client A's contract requires lot tracking." → Inventory: "Feature: outbound orders include verified lot numbers (AC: lot captured at receive, validated at pick, confirmed at ship)."
- Origin: "GDPR applies to EU users." → Inventory: "Compliance: personal data is deletable within 30 days of request (AC: deletion API exists, audit log proves execution)."
- Not inventory: "Client A contract requirements" (restated origin), "order fulfillment system" (a system, not a verifiable commitment), "we handle compliance" (assertion, not a provable item).

Origins are **fractal**. Zoom in: one event becomes its own origin. Zoom out: that origin is just one event in a larger story.

### 3. Own Your Inventory

Each vertical maintains an **inventory** — a living warehouse of controllable work products that represents their commitment. Not raw facts, not restated origins — things the vertical actively manages, proves, and is accountable for.

Inventory is:

- **Built** — structured for the nature of the work
- **Optimized** — organized so matches can be found and verified efficiently
- **Reconciled** — assumed legitimate until change arrives; each change is the signal to reevaluate staleness, correctness, and coverage

Each item carries **traces**: where it came from, what it matches, who confirmed the match. Traces are the TODO list — they identify what needs re-verification when things change.

The document set is chosen by each team. The Constitution defines what the inventory must achieve — matching, tracing, verification — not what it contains.

Every item must earn its place. If no downstream match needs it, it's ceremony — prune it. Inventory stays lean not by policy, but by purpose.

**Think twice, write once.** Reversing a match is expensive — not just the rework, but the cascade across every item that traced to it.

---

## Verticals

Five facing directions. Each defines what **proven** means.

**PM — faces outward**
Every item traces to an external source (customer, compliance, business goal) and has a matched response in another vertical. PM owns what was committed and to whom — the features promised, the compliance controls accepted, the quality thresholds agreed. If a client, regulator, or stakeholder could ask "did you deliver this?" — the answer lives in PM's inventory.

**Design — faces the user's experience**
Every screen, transition, and interaction matches a box from PM. No hanging states. Design owns what users see and do — the surfaces they touch, the flows they follow, the brand they experience. If a user could screenshot it or walk through it, it belongs to Design.

**Engineer — faces the system**
Every flow matches boxes from upstream. Code implements what flows describe. Tests verify what code implements. Engineer owns how the system works — the components built, the contracts between them, the data they shape, the tests that prove behavior. If it runs, computes, stores, or integrates, Engineer maintains it.

**QA — faces proof integrity**
The constitutional court. Every box has a verification path. Every path has a mechanism. Every mechanism has a degradation signal — a way to know when verification is weakening before it breaks completely. QA owns the proof that matches hold — the scenarios tested, the criteria applied, the coverage tracked. If someone asks "how do you know this works?" — QA's inventory is the answer.

**DevOps — faces operational reality**
The system runs as designed, not just built as designed. Every deployment path is reproducible. Observability covers every flow. Incidents trace back to a broken match. DevOps owns how the system lives in production — the procedures to deploy, the monitoring to detect, the runbooks to respond, the evidence that operations match what was built.

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
