# The Constitution

How work flows, who owns what, and what "done" means. For any contributor — human or AI. Universal across project type, team size, or domain.

---

## Fundamentals

### 1. Don't Derive, Match

When work crosses a boundary, the **receiver does not blindly follow the input.** The input can be wrong.

- **Receiver** discovers **boxes** — things that must be verified.
- **Sender and receiver negotiate** until boxes are agreed.
- **Receiver provides a solution that matches those boxes.** How they match is their freedom. That the boxes are matched is their accountability.

Boxes are binary — matched or not. There is no "partially matched."

The result is a web of matched boxes across independent inventories — not a chain of arrows. If your process looks like upstream → downstream → downstream, you are deriving, not matching.

### 2. Start from the Customer's Story

The customer describes what happens at their natural level. That's the flow.

A patient says: *"I visit the clinic. I don't want to re-enter my information."* They don't know about HIS, data sync, or screen states. They know what they experience.

Each vertical discovers boxes from the same story, in their own domain, in parallel. They work from the same story, not from each other's output. They iterate together to align their matches.

Flows are **fractal**. Zoom in: an event becomes its own flow. Zoom out: that flow is just one event in a larger story. Every zoom level is valid. Every translation must trace back to the customer's words.

### 3. Own Your Inventory

Each vertical maintains an **inventory** — a living warehouse of artifacts that represents their commitment.

Inventory is not documentation. It is:

- **Built** — structured for the nature of the work
- **Optimized** — organized so matches can be found and verified efficiently
- **Reconciled** — checked for staleness (no longer relevant), correctness (no longer proven), and coverage (new reality not yet reflected)

Each inventory item carries **traces** — records of matching decisions:

- **Where it came from** — what asked for this item to exist
- **What it matches** — which boxes this item addresses
- **Who confirmed the match** — a human judgment, not a derivation

Traces are owned by the team, not shared infrastructure. They serve two purposes:

1. **Verification** — follow traces to check if matched items changed. If they did, this item is suspect.
2. **Change impact** — everything that traces to a changed item needs re-verification. Traces are the TODO list.

The document set is **chosen by each team.** The Constitution defines what the inventory must achieve — matching, tracing, verification — not what specific documents it contains.

### 4. Iterate Together, Own Separately

All verticals work in parallel from the customer's story. Each discovers boxes from their vantage point. They iterate together to negotiate matches.

The overlap is real. A designer and an engineer may co-discover that a screen needs a different flow because of a system constraint. That's matching in action.

**What must not happen:** skipping the matching. Each vertical owns its domain, but the matches between domains are the proof that the work is coherent.

**Think twice, write once.** Reversing a match is expensive — not just the rework, but the cascade of re-verification across every item that traced to it.

---

## Verticals

Five verticals, each with a **facing direction** and a definition of what **proven** means.

### PM — faces outward

**Proven:** Every item traces to an external source (customer, compliance, business goal) and has a matched response in another vertical.

### Design — faces the user's experience

**Proven:** Every screen and transition matches a box from PM. The state machine has no hanging states.

### Engineer — faces the system

**Proven:** Every flow demonstrates a match against boxes from upstream. Code implements what flows describe. Tests verify what code implements.

### QA — faces proof integrity

The constitutional court. Audits that proofs hold across all verticals.

**Proven:** Every box has a verification path. Every path has a mechanism. Every mechanism has a degradation signal.

### DevOps — faces operational reality

Proves the system **runs** as designed, not just that it was built as designed.

**Proven:** Every deployment path is reproducible. Environments match what QA needs. Observability covers every flow. Incidents trace back to a broken match.

---

## Mechanics

### Transitions

Event-driven. When a vertical's inventory changes, the change propagates through traces.

- Dependent items become **suspect** — they lose their proven status.
- Traces identify which items are affected.
- The dependent vertical must **acknowledge** the change, assess impact, and **explicitly re-verify.**

The event is the trigger. The traces are the TODO list.

### Proven

Binary. An item is either proven or it is not.

**Lifecycle:**

1. An item enters as **unverified.**
2. A human confirms the match with **evidence** — a test run, a review, a demonstration. The item becomes **proven.** Evidence, verifier, and conditions are recorded.
3. When an upstream item changes, traces identify dependents. Those items become **suspect.**
4. The owning vertical **re-verifies** with new evidence to restore proven status.

Proof requires **evidence, not assertion.** A claim without evidence is not proof. Evidence degrades — a proof from six months ago may no longer hold. Reconciliation catches this.

Each team **owns only what they can prove.**

### Freedom

Full autonomy within matches. A vertical can radically change its approach — redesign a screen, rewrite a service, restructure infrastructure — without approval, **as long as all boxes still match.**

Freedom is the reward for maintaining proven matches. The moment a match breaks, freedom is constrained until proof is restored.
