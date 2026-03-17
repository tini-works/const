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

Matching is **not a pipeline.** Each vertical independently discovers what must be true and matches it. The result is a web of matched boxes across independent inventories — not a chain of arrows flowing from one vertical to the next. If your process looks like upstream → downstream → downstream, you are deriving, not matching.

### 2. Start from the Customer's Story

The customer describes what happens at their natural level. That's the flow.

A patient says: *"I visit the clinic. I don't want to re-enter my information."* They don't know about HIS, data sync, or screen states. They know what they experience.

Each vertical discovers boxes from the same story, in their own domain, in parallel:

- **PM** captures it as-told. Discovers boxes: "data must be there," "no re-entry."
- **Design** discovers what the user should see and do — screens, states, transitions.
- **Engineer** discovers what the system must do — data sync, API calls, event sequences. One customer sentence becomes N technical flows.
- **QA** discovers what must be proven — verification paths across all verticals.
- **DevOps** discovers what must run — infrastructure that supports the flows in production.

They work from the same story, not from each other's output. They iterate together to align their matches.

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

Each inventory item carries **traces** — records of matching decisions:

- **Where it came from** — what asked for this item to exist (customer story, business goal, upstream box)
- **What it matches** — which boxes in other inventories this item addresses
- **Who confirmed the match** — a human decided this item matches that box. The decision can be right or wrong. It is a judgment, not a derivation.

Traces are **not structural coupling.** Each vertical owns its own traces. A trace says "we believe this matches that" — it is a record of a human judgment, recorded in the team's own inventory. It is not a pointer that makes one inventory dependent on another's internal structure.

Traces serve two purposes:

1. **Verification** — "how do I know this item is still valid?" Follow its traces to what it matches. If the matched item changed, this item is suspect.
2. **Change impact** — "what else needs checking when this item changes?" Everything that traces to this item needs re-verification. Traces are the exhaustive TODO list.

The document set that makes up an inventory is **chosen by each team** for their work. The Constitution defines what the inventory must achieve — matching, tracing, verification — not what specific documents it contains. A PM might use PRDs, epics, and user stories. An engineer might use ADRs, API specs, and architecture docs. A different project might use entirely different artifacts. The principle doesn't change; the documents do.

### 4. Iterate Together, Own Separately

PM, Design, and Engineering work in parallel — not in sequence. The customer's story reaches all verticals at once. Each discovers boxes from their vantage point. They iterate together to negotiate matches.

- **PM** owns what the outside world needs — but doesn't dictate how Design or Engineering fulfills it.
- **Design** owns what the user sees and does — but needs Engineering's input on what's feasible and PM's input on what matters.
- **Engineering** owns the system — but needs Design's input on what users expect and PM's input on constraints.
- **QA** audits that the matches hold — across all of them, not after a handoff chain.
- **DevOps** proves it runs — in parallel with Engineering, not after.

The overlap is real. A designer and an engineer may co-discover that a screen needs a different flow because of a system constraint. That's matching in action — not a pipeline violation.

**What must not happen:** skipping the matching. If Engineering builds something without matching against Design's screens, the proof chain is broken. If Design specifies screens without matching against PM's acceptance criteria, the trace is missing. Each vertical owns its domain, but the matches between domains are the proof that the work is coherent.

**Think twice, write once.** Reversing a match is expensive — not just the rework, but the cascade of re-verification across every item that traced to it.

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

Transitions are **event-driven**. When a vertical's inventory changes, the change propagates through traces.

- An upstream change **flags dependent items as suspect** — they lose their proven status.
- Traces identify which items are affected: everything that traces to the changed item needs re-verification.
- The dependent vertical must **explicitly re-verify** to restore proven status — and must **acknowledge** the change and its impact assessment.

There is no scheduled handoff. The event is the trigger. The traces are the TODO list.

### Proven

Binary. An item is either proven or it is not.

- There are no intermediate states (no "in progress," no "assumed," no "90% done").
- The forcing function: if you can't prove it, it's not proven.

**Lifecycle:**

1. An item enters the inventory as **unverified** — it exists, but no one has confirmed the match holds.
2. A human confirms the match with **evidence** — a test that was run, a review that was done, a demonstration that was witnessed. The item becomes **proven.** The evidence, the verifier, and the conditions are recorded.
3. When an upstream item changes, traces identify dependent items. Those items become **suspect** — they were proven under conditions that may no longer hold.
4. The owning vertical must **explicitly re-verify** to restore proven status. Re-verification produces new evidence.

Proof requires **evidence, not assertion.** "All criteria verified" written in a document is a claim. A test execution record, a review sign-off, a dated walkthrough — those are evidence. A claim without evidence is not proof.

Each team **owns only what they can prove.** An item without evidence of verification is unverified, regardless of what any document claims about it.

### Freedom

Full autonomy within matches. A vertical can radically change its approach — redesign a screen, rewrite a service, restructure infrastructure — without approval, **as long as all boxes still match.**

Freedom is the reward for maintaining proven matches. The moment a match breaks, freedom is constrained until proof is restored.

### Sanity

Daily reconciliation of every inventory across three dimensions:

1. **Staleness** — remove what's no longer relevant
2. **Correctness** — re-verify what's claimed as proven
3. **Coverage** — add what's missing from current reality

Sanity is not a ceremony. It is inventory management. A warehouse that isn't reconciled daily is a warehouse you can't trust.

Reconciliation includes verifying that proofs have **evidence** — not just structure. A test case that exists but has never been run is not proof. A coverage report that claims "verified" without a date is not reconciled. Evidence degrades: a proof from six months ago may no longer hold. Reconciliation catches this.
