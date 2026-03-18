# Experience

What patients and receptionists see and do. Every screen, flow, and interaction in the clinic check-in system lives here.

## What's in this folder

| File | What it covers |
|------|---------------|
| **user-flows.md** | End-to-end journeys for every scenario: returning patient, new patient, mobile check-in, card scan failure, data leak prevention, concurrent edits, migration. The narrative version of the product. |
| **screen-specs.md** | Every screen broken down by region, content, and states. Kiosk (welcome through confirmation), receptionist dashboard, mobile check-in, admin migration tools. Engineers build from this. |
| **interaction-specs.md** | How things behave: transitions, animations, timing, error handling, edit patterns, session security. Companion to screen-specs. |
| **component-inventory.md** | Reusable UI components (status badges, progress indicators, medication cards, conflict banners, skeleton loaders) with variants, states, and sizing across kiosk/mobile/desktop. |
| **design-decisions.md** | Where design pushed back on PM, added requirements, or made trade-offs. 14 decisions with rationale (e.g., mandatory transition screen for data leak prevention, honest sync status over false green checkmarks). |
| **flow-diagrams.md** | Visual diagrams for the major flows: kiosk check-in, mobile check-in, kiosk-to-receptionist sync, concurrent edit resolution, Riverside migration pipeline. |
| **reconciliation-log.md** | Running record of when upstream changes arrived, what design artifacts were reevaluated, and what was re-verified or added. |

## How to find what you need

- **"What does screen X look like?"** -- `screen-specs.md`. Sections are numbered: 1.x = kiosk, 2.x = receptionist dashboard, 3.x = mobile, 4.x = admin, 5.x = loading & degraded states.
- **"What's the user journey for scenario Y?"** -- `user-flows.md`. 15 flows covering happy paths, error paths, and edge cases.
- **"How does this animation/transition/error work?"** -- `interaction-specs.md`. Organized by surface (kiosk, receptionist, mobile) plus cross-cutting error handling.
- **"What reusable components exist?"** -- `component-inventory.md`. Each component has kiosk and mobile variants with exact sizing and color specs.
- **"Why did we design it this way?"** -- `design-decisions.md`. Numbered DD-001 through DD-014. Each links to the story or bug that triggered it.
- **"Show me the flow visually"** -- `flow-diagrams.md`. Rendered diagrams with direct links.

## Verification

Every screen, flow, and component traces back to the product story that asked for it and the test case that proves it. Look for the **Trace** table at the top of each section:

- **Traced from** links to user stories and epics in `../product/`
- **Matched by** links to API endpoints and services in `../architecture/`
- **Proven by** links to test cases in `../quality/`
- **Confirmed by** names the person who verified the match and when

If a screen has no trace table, it's undocumented scope -- flag it.

## Key design decisions

The non-obvious ones worth reading on day one:

- **DD-001**: 800ms transition screen between patients is a designed safety net, not just a loading spinner
- **DD-002**: Green checkmark requires end-to-end sync proof -- no false success states
- **DD-003**: Mandatory medication step designed to be one-tap for unchanged lists
- **DD-004/DD-005**: Mobile uses one-step-per-screen + bottom sheets; kiosk uses scrollable page + inline edits
- **DD-008**: No "currently being edited by" indicator -- conflicts surface only at save time

Full list with rationale in `design-decisions.md`.
