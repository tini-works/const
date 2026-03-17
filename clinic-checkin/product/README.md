# Product

This is the outward-facing layer of the project. Everything here defines **what we're building and why** -- the interface between the outside world (patients, clinic staff, regulators, business deals) and the internal teams (design, engineering, QA).

If architecture is "how," this folder is "what" and "why."

## What's here

| File | What it does |
|------|-------------|
| `epics.md` | The six major initiatives (E1-E6), each with goals, scope, dependencies, and current verification status. Start here for the big picture. |
| `user-stories.md` | Every story and bug, with acceptance criteria, context on why it exists, and full traceability links. This is the source of truth for "what does done look like." |
| `backlog.md` | Prioritized work queue (P0-P3) with sequencing rationale. Also tracks coverage gaps identified from QA. |
| `decision-log.md` | Eight key product decisions (DEC-001 through DEC-008) with options considered, what we chose, and why. Read this before proposing something we already decided. |
| `prd-mobile-checkin.md` | PRD for mobile check-in (E2). Problem, solution, requirements, risks, success metrics. |
| `prd-multi-location.md` | PRD for multi-location support (E3). Driven by second clinic opening next month. |
| `prd-riverside-acquisition.md` | PRD for migrating 4,000 patients from acquired practice (E5). Covers EMR import, paper digitization, and duplicate detection. |

## Finding what you need

- **"What are we working on right now?"** -- `backlog.md`, top of the table (sorted by priority)
- **"Why did we decide X?"** -- `decision-log.md`, search by topic
- **"What are the acceptance criteria for this story?"** -- `user-stories.md`, find the story ID
- **"What's the full scope of an initiative?"** -- `epics.md`, find the epic
- **"What does this feature need to do, end to end?"** -- the relevant `prd-*.md` file

## How verification works

Every user story carries a verification status:

- **proven** -- all acceptance criteria have passing tests with evidence. We trust this.
- **suspect** -- core flow works, but specific scenarios lack test coverage (noted inline). Treat with caution.
- **unverified** -- no test evidence yet.

Each story's verification section names the exact test cases that prove it and when it was last checked. If a story says "suspect," it explains what's missing (e.g., "SMS delivery untested," "cross-browser matrix not verified").

## How tracing works

Every story traces in two directions:

- **Where it came from** ("Traced from"): the epic, the round it was identified, or the PRD that defined it
- **What matches it downstream** ("Matched by"): screen specs, user flows, API endpoints, architecture decisions, and test cases

This means you can start at any story and follow links to see how it's designed (screens, flows), how it's built (APIs, ADRs), and how it's verified (test cases). Nothing exists in isolation.
