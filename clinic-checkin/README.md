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
| [product/](product/) | Product Manager | Epics, user stories, PRDs, backlog, decision log | 7 |
| [experience/](experience/) | Designer | Screen specs, interaction specs, user flows, components, design decisions | 6 |
| [architecture/](architecture/) | Engineer | System design, ADRs, API spec, data model, tech design docs | 10 |
| [quality/](quality/) | QA | Test plan, test suites, bug reports, coverage report | 4 |
| [operations/](operations/) | DevOps | Infrastructure, deployment, monitoring, runbooks, environment guide | 11 |

Each area maintains its own inventory — the working documents that team uses day to day. See the full [responsibility matrix](MATRIX.md) for who owns, consumes, and gets notified on every document.

## Traceability

Every item links both ways — upstream to its source, downstream to its proof:

```
customer story
  → user story (acceptance criteria)
    → screen spec (what the user sees)
      → API endpoint (how the system does it)
        → test case (proof it works)
          → production monitor (proof it keeps working)
```

Break any link and you know exactly what's suspect. Follow any link and you can verify the claim.

## Where the Constitution shows up

The framework's concepts are embedded in the work, not called out:

| Constitution concept | Where it lives in practice |
|---------------------|---------------------------|
| **Don't derive, match** | Acceptance criteria in user stories are negotiated — Design pushes back ("editable or locked?"), Architecture surfaces constraints nobody else can see |
| **Start from the customer's story** | Every round starts with verbatim customer words. "I tried three times" becomes an idempotency requirement. The words create the work. |
| **Own your inventory** | Each area owns its documents. Product doesn't write screen specs. Quality doesn't write architecture docs. |
| **Unidirectional quality** | Work flows product → experience → architecture. Discoveries flow back up through product, not around it. |
| **Boxes** | Acceptance criteria in user stories, assertions in test cases, thresholds in monitoring rules |
| **Proven** | A story is proven when test cases pass and monitoring shows green — not when someone writes "done" |
| **Transitions** | When architecture changes an API, the screen spec that uses it goes suspect. The [MATRIX](MATRIX.md) shows who gets notified. |
| **Sanity** | The backlog is reconciled. The coverage report shows gaps. Bug reports trace to ADRs. Runbooks trace to incidents. |

## By the numbers

| Metric | Count |
|--------|-------|
| Customer events processed | 10 |
| Epics | 6 |
| User stories | 16 (13 features + 3 bugs) |
| Screens | 16+ |
| API endpoints | ~40 |
| Architecture decisions | 10 |
| Test cases | 72 |
| Production monitors | 14+ |
| Runbooks | 7 |
| Documents total | 38 |
