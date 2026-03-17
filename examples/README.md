# Example — Clinic Check-In System

A working example of the Constitution applied to a real product: a clinic patient check-in system.

## How to read this

Start with the **rounds** — these are the customer asks that drove the work. Then look at how each role's inventory evolved.

### The rounds

Ten rounds of real-world events: customer complaints, bugs, feature requests, compliance mandates, business changes.

| Round | What happened |
|-------|---------------|
| 01 | Patient: "I already told you last time" — repeated data entry complaint |
| 02 | Bug: patient confirmed info but receptionist's screen showed nothing |
| 03 | Feature: "Can I check in from my phone before I arrive?" |
| 04 | Critical bug: another patient's data flashed on screen (data leak) |
| 05 | Business: opening a second clinic location, shared patients |
| 06 | Compliance: state mandates medication list at every check-in |
| 07 | Bug: two receptionists finalized the same patient, lost one's edits |
| 08 | Feature: "Can I just take a photo of my insurance card?" |
| 09 | Performance: Monday morning crush — kiosks freezing, patients leaving |
| 10 | Business: acquiring Riverside Family Practice — 4,000 patients, dedup needed |

### Each role's inventory

Each role maintains the documents they actually use in their profession. No framework jargon — just real work artifacts.

| Role | Documents | What they track |
|------|-----------|-----------------|
| **PM** | Epics, User Stories, PRDs, Backlog, Decision Log | What the outside world needs, prioritized and scoped |
| **Design** | Screen Specs, Interaction Specs, User Flows, Components, Design Decisions | What users see and do, every state and transition |
| **Engineer** | Architecture, ADRs, API Spec, Data Model, Tech Design Docs | How the system works, why decisions were made |
| **QA** | Test Plan, Test Suites, Bug Reports, Coverage Report | What's proven, what's broken, what's risky |
| **DevOps** | Infrastructure, Deployment, Monitoring, Runbooks, Environments | What's running, how to deploy, what to do when it breaks |

### How the Constitution shows up

The Constitution's concepts are embedded in the work, not called out:

- **"Don't derive, match"** → PM's user story acceptance criteria are negotiated with Design and Engineering. Design pushes back ("editable or locked?"). Engineering surfaces constraints PM can't see.
- **"Start from the customer's story"** → Every round starts with the customer's exact words. Those words create the requirements — not the other way around.
- **"Own your inventory"** → Each role maintains their own documents. PM doesn't write screen specs. QA doesn't write architecture docs. Each vertical owns what they're accountable for.
- **"Unidirectional quality"** → Work flows PM → Design → Engineering. When Engineering discovers something (like the allergy staleness risk), it flows back up through PM, not around it.
- **Boxes** → They're the acceptance criteria in user stories, the assertions in test cases, the thresholds in monitoring rules.
- **Proven** → A user story is proven when QA's test cases pass. A deployment is proven when monitoring shows green. Not a status column — a verifiable state.
- **Sanity** → The backlog is reconciled. The coverage report shows gaps. The risk register flags what could break silently.
