# The Constitution

The operating manual for modern work with AI. Any contributor — human or AI — reads this to understand how work flows, who owns what, and what "done" means.

This is universal. It applies regardless of project type, team size, or domain.

---

## Four Fundamentals

### 1. Don't Derive, Match

Transitions between verticals are **box negotiations**, not handoffs.

When work crosses a boundary (customer reports a bug, PM formalizes a requirement, design hands off screens), the **receiver does not blindly follow the input**. The input can be wrong.

Instead:

- **Receiver** discovers **boxes** — things that must be verified. The more boxes, the better the clarification.
- **Sender and receiver negotiate** until boxes are agreed.
- **Receiver provides a solution that matches those boxes.** How they match is their freedom. That the boxes are matched is their accountability.

The requirement is not the truth. The boxes are the truth. Each side holds responsibility: the sender to elaborate and provide boxes, the receiver to fulfill by matching them.

### 2. Start from the Customer's Story

The customer describes what happens at their natural level. That's the flow.

A patient says: *"I visit the clinic. I don't want to re-enter my information."* They don't know about HIS, data sync, or screen states. They know what they experience.

Each vertical translates this story deeper into their domain:

- **PM** captures it as-told. Discovers boxes: "data must be there," "no re-entry."
- **Design** translates it into screens and state transitions — a journey through states.
- **Engineer** translates it into system flows — data sync, API calls, event sequences. One customer sentence becomes N technical flows.
- **QA** maps verification paths across all translations — proves the customer's sentence holds end-to-end.
- **DevOps** ensures the infrastructure supports the flow in production.

Flows are **fractal**. Zoom in: an event ("patient visits clinic") becomes its own flow with steps, screens, and system calls. Zoom out: that entire flow is just one event in the hospital-wide story. Every zoom level is valid. Every translation, at every depth, must trace back to the customer's words.

The customer defines the natural zoom level. **Translation is our job. Traceability is our obligation.**

### 3. Own Your Inventory

Each vertical maintains an **inventory** — a living warehouse of artifacts that represents their commitment.

Inventory is not documentation. It is:

- **Built** — structured for the nature of the work
- **Optimized** — organized so matches can be found and verified efficiently
- **Reconciled daily** — checked for sanity across three dimensions:
  - **Staleness**: items no longer relevant
  - **Correctness**: items no longer proven
  - **Coverage**: new reality not yet reflected

Inventory is the mechanism that makes matching possible at scale. Without it, boxes have nothing to match against.

### 4. Unidirectional Quality

Certain artifacts require a strict flow to retain their quality. Don't break the flow.

**Think twice, write once.** Shortcuts corrupt downstream proofs. Reversing is expensive — not just the rework, but the cascade of re-verification across every dependent box.

Respect the pipeline. If an artifact must flow through Design before it reaches Engineering, it flows through Design. The pipeline exists because each stage adds proof that later stages depend on.

---

## Verticals

Five verticals, each with a **facing direction**, an **inventory**, and a definition of what **proven** means for them.

### PM — faces outward

The interface between the outside world (customers, business, compliance, market) and the internal system.

**Inventory:**
- Requirements matched to user requests and reported bugs
- Compliance mappings — how each obligation is matched
- Business goal alignment — how each initiative matches strategic objectives

**Proven means:** Every item in the inventory can be traced to an external source (customer request, compliance requirement, business goal) and has a matched response in a downstream vertical.

### Design — faces the user's experience

Translates requirements into what the user sees and does.

**Inventory:**
- Screens — including nested regions within each screen
- State machine — an exhaustive tree of transitions between all screens and inner states. Every path a user can take is mapped.

**Proven means:** Every screen and transition in the inventory matches a box from PM, and the state machine has no hanging states — every path leads somewhere intentional.

### Engineer — faces the system

Translates design into a working system.

**Inventory:**
- System design artifacts — architecture, data models, APIs
- Flows — sequences that showcase matches against the ask from Design and PM
- Code — the implementation, traceable to flows

**Proven means:** Every flow in the inventory demonstrates a match against boxes from upstream. Code implements what flows describe. Tests verify what code implements.

### QA — faces proof integrity

The constitutional court. QA does not write the laws (boxes). QA audits that proofs hold across all verticals.

**Inventory — the proof registry:**
- Verification paths — for every match claimed in any vertical, how is it proven?
- Proof mechanisms — automated (tests, CI checks, monitors) and manual (reviews, walkthroughs)
- Proof degradation signals — how do we know when a proof has gone stale or broken?

**Proven means:** The proof registry covers every box across all verticals. No match exists without a verification path. No verification path exists without a mechanism. No mechanism exists without a degradation signal.

### DevOps — faces operational reality

Proves that the system **runs** as designed, not just that it was **built** as designed.

**Inventory — operational truth:**
- Infrastructure state — what's deployed, where, how
- Deployment pipelines — paths from code to production, each step proven
- Environment parity — test environments match production reality
- Observability coverage — can we detect when proofs break in production?

**Proven means:** Every deployment path is reproducible. Environments match what QA needs for proof. Observability covers every flow in Engineering's inventory. Operational incidents can be traced back to a broken match.

---

## Mechanics

### Boxes

A box is a **must-be-verified criterion** negotiated between sender and receiver at a transition boundary. Boxes are:

- **Negotiated** — not dictated. Both parties contribute to defining what must be true.
- **Binary** — matched or not. There is no "partially matched."
- **The contract** — freedom in how to match, accountability that the match holds.

### Transitions

Transitions are **event-driven**. When a vertical's inventory changes, the change propagates to every vertical that has boxes depending on the changed item.

- An upstream change **flags dependent items as suspect** — they lose their proven status.
- The dependent vertical must **explicitly re-verify** to restore proven status.

There is no scheduled handoff. The event is the trigger.

### Proven

Binary. An item is either proven or it is not.

- There are no intermediate states (no "in progress," no "assumed," no "90% done").
- An item becomes not-proven when upstream changes flag it as suspect **and** explicit verification confirms the invalidation.
- The forcing function: if you can't prove it, it's not proven.

### Freedom

Full autonomy within matches. A vertical can radically change its approach — redesign a screen, rewrite a service, restructure infrastructure — without approval, **as long as all boxes still match.**

Freedom is the reward for maintaining proven matches. The moment a match breaks, freedom is constrained until proof is restored.

### Sanity

Daily reconciliation of every inventory across three dimensions:

1. **Staleness** — remove what's no longer relevant
2. **Correctness** — re-verify what's claimed as proven
3. **Coverage** — add what's missing from current reality

Sanity is not a ceremony. It is inventory management. A warehouse that isn't reconciled daily is a warehouse you can't trust.
