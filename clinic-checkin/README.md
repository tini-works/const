# Clinic Check-In System

A working example of the Constitution applied to a real product.

## Read order

Start with `timeline/` — ten events that drove the work. Then browse any area that interests you.

### Timeline

| # | What happened |
|---|---------------|
| 01 | Patient: "I already told you last time" — repeated data entry |
| 02 | Bug: patient confirmed but receptionist saw nothing |
| 03 | "Can I check in from my phone before I arrive?" |
| 04 | Another patient's data flashed on screen (data leak) |
| 05 | Opening a second clinic, patients visit both |
| 06 | State mandates medication list at every check-in |
| 07 | Two receptionists finalized same patient, lost one's edits |
| 08 | "Can I just take a photo of my insurance card?" |
| 09 | Monday morning crush — kiosks freezing, patients leaving |
| 10 | Acquiring Riverside Family Practice — 4,000 patients, dedup |

### Areas

| Folder | What's inside |
|--------|---------------|
| `product/` | Epics, user stories, PRDs, backlog, decision log |
| `experience/` | Screen specs, interaction specs, user flows, components, design decisions |
| `architecture/` | System design, ADRs, API spec, data model, tech design docs |
| `quality/` | Test plan, test suites, bug reports, coverage report |
| `operations/` | Infrastructure, deployment, monitoring, runbooks |

Each area maintains its own documents — the artifacts that team actually uses in their work.

### Where the Constitution lives

Not in the documents — in how the work flows:

- Acceptance criteria in user stories are negotiated, not dictated
- Design pushes back on product ("editable or locked?"). Architecture surfaces constraints nobody else can see.
- Each area owns its inventory. Product doesn't write screen specs. Quality doesn't write architecture docs.
- Work flows product → experience → architecture. Discoveries flow back up through product, not around it.
- A story is proven when test cases pass and monitoring shows green — not when someone writes "done."
