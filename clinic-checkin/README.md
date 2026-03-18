# Clinic Check-In System

A working example of [the Constitution](../CONST.md) applied to a real product — a clinic patient check-in system that evolved through 10 rounds of customer complaints, bugs, feature requests, compliance mandates, and business changes.

## How to read this

1. **Start with the [timeline](timeline/)** — ten real-world events that drove all the work
2. **Browse any area** that interests you — each owns its documents independently
3. **Follow the links** — every item traces upstream to its source and downstream to its proof
4. **Check the [MATRIX](MATRIX.md)** — who owns what, who consumes what, full content index

## Timeline

| # | Type | What happened |
|---|------|---------------|
| [01](timeline/round-01.md) | Complaint | Patient: "I already told you last time" — repeated data entry |
| [02](timeline/round-02.md) | Bug | Patient confirmed but receptionist saw nothing |
| [03](timeline/round-03.md) | Feature | "Can I check in from my phone before I arrive?" |
| [04](timeline/round-04.md) | P0 Bug | Another patient's data flashed on screen (data leak) |
| [05](timeline/round-05.md) | Business | Opening a second clinic, patients visit both |
| [06](timeline/round-06.md) | Compliance | State mandates medication list at every check-in |
| [07](timeline/round-07.md) | Bug | Two receptionists finalized same patient, lost one's edits |
| [08](timeline/round-08.md) | Feature | "Can I just take a photo of my insurance card?" |
| [09](timeline/round-09.md) | Performance | Monday morning crush — kiosks freezing, patients leaving |
| [10](timeline/round-10.md) | Acquisition | Acquiring Riverside Family Practice — 4,000 patients, dedup |

## Areas

| Folder | Owner | What's inside | Files |
|--------|-------|---------------|-------|
| [product/](product/) | Product Manager | Epics, user stories, PRDs, backlog, decision log, reconciliation log | 8 |
| [experience/](experience/) | Designer | Screen specs, interaction specs, user flows, components, design decisions, reconciliation log | 7 |
| [architecture/](architecture/) | Engineer | System design, ADRs, API spec, data model, tech design docs, reconciliation log | 11 |
| [quality/](quality/) | QA | Test plan, test suites, bug reports, coverage report, reconciliation log | 5 |
| [operations/](operations/) | DevOps | Infrastructure, deployment, monitoring, runbooks, environment guide, reconciliation log | 13 |

Each area maintains its own inventory — the working documents that team uses day to day. See the full [responsibility matrix](MATRIX.md) for who owns, consumes, and gets notified on every document.

## How inventories relate

Each team owns their inventory independently. Items connect through **matching** — negotiated agreements between teams — not derivation chains.

### Matching, not deriving

Each team independently discovers what must be true and matches it. The result is a web of negotiated matches, not a pipeline of arrows:

![Matching relationships between inventories](https://diashort.apps.quickable.co/e/5b1445de)

### Inventory items and their traces

Every item carries traces: where it came from, what it matches, and what proves it. When something changes, traces identify what goes suspect:

![Inventory item relationships across all areas](https://diashort.apps.quickable.co/e/037d4aa3)

### Verification lifecycle

Each item moves through states. Proof requires evidence — a human confirmed the match with something concrete, not just an assertion:

![Verification lifecycle: unverified → proven → suspect → re-verified](https://diashort.apps.quickable.co/e/c6018808)

Each team owns their traces. A trace says "we believe this matches that" — it's a human judgment recorded in that team's own inventory. When something changes, traces identify what's suspect.

## Where the Constitution shows up

The framework's concepts are embedded in the work, not called out:

| Constitution concept | Where it lives in practice |
|---------------------|---------------------------|
| **Don't derive, match** | Acceptance criteria in user stories are negotiated — Design pushes back ("editable or locked?"), Architecture surfaces constraints nobody else can see |
| **Start from the Source** | Every round starts with an origin — a change in reality that demands a response. Customer complaints, compliance mandates, system failures, business bets. "I tried three times" becomes an idempotency requirement. The origin creates the work. |
| **Own your inventory** | Each area owns its documents. Product doesn't write screen specs. Quality doesn't write architecture docs. |
| **Boxes** | Acceptance criteria in user stories, assertions in test cases, thresholds in monitoring rules |
| **Traces** | Each item records where it came from and what it matches. Traces are human judgments — they can be right or wrong. They're owned by the team, not shared infrastructure. |
| **Proven** | Proof requires evidence, not assertion. A test execution record, a review sign-off, a dated walkthrough. "All criteria verified" without a date is a claim, not proof. |
| **Lifecycle** | When a traced item changes, dependents become suspect. The owning vertical acknowledges, assesses impact, and re-verifies. When architecture changes an API, traces identify which screens, tests, and monitors matched against it. |
| **Reconciliation** | Inventory assumed legitimate until change arrives; each change is the signal to reevaluate staleness, correctness, and coverage. A test case that exists but was never run is not proof. Coverage gaps are tracked, not just listed. |
| **Learning** | When a match broke — cause and preventive action are recorded alongside the new evidence. Re-proving without understanding why is patching, not fixing. |

## By the numbers

| Metric | Count |
|--------|-------|
| Customer events processed | 10 |
| Epics | 6 |
| User stories | 16 (13 features + 3 bugs) |
| Screens | 20+ |
| API endpoints | ~40 |
| Architecture decisions | 10 |
| Test cases | 67 |
| Production monitors | 14+ |
| Runbooks | 8 |
| Documents total | 44+ |
