# Design Inventory — Index

Living warehouse of all design artifacts. This is the entry point for anyone reading Design's work.

---

## Documents

| Document | Purpose | Scope |
|----------|---------|-------|
| [screens.md](screens.md) | Complete screen inventory (16 screens, 3 actor classes) | Rounds 1-10 |
| [flow.md](flow.md) | Complete state machine (15 flows, transition table, dead-end audit) | Rounds 1-10 |
| [traceability.md](traceability.md) | Box-to-screen and screen-to-box cross-reference | Rounds 1-10 |
| [design-boxes.md](design-boxes.md) | Registry of all 23 Design-originated boxes | Rounds 1-10 |

### Per-Round Negotiations

| Document | Round | Story | Type |
|----------|-------|-------|------|
| [negotiation-s01.md](negotiation-s01.md) | R01 | Returning Patient Recognition | Feature |
| [negotiation-s02.md](negotiation-s02.md) | R02 | Receptionist Blind | Bug |
| [negotiation-s03.md](negotiation-s03.md) | R03 | Mobile Pre-Check-In | Feature |
| [negotiation-s04.md](negotiation-s04.md) | R04 | Data Breach / HIPAA | Critical Bug + Compliance |
| [negotiation-s05.md](negotiation-s05.md) | R05 | Second Location | Business |
| [negotiation-s06.md](negotiation-s06.md) | R06 | Medication Mandate | Compliance |
| [negotiation-s07.md](negotiation-s07.md) | R07 | Concurrent Check-In Bug | Bug |
| [negotiation-s08.md](negotiation-s08.md) | R08 | Insurance Photo Upload | Feature |
| [negotiation-s09.md](negotiation-s09.md) | R09 | Monday Morning Crush | Performance |
| [negotiation-s10.md](negotiation-s10.md) | R10 | Riverside Acquisition | Business (Major) |

### Superseded (Round 1 originals — kept for history, not authoritative)

| Document | Replaced by |
|----------|-------------|
| [screens-s01.md](screens-s01.md) | [screens.md](screens.md) |
| [flow-s01.md](flow-s01.md) | [flow.md](flow.md) |
| [traceability-s01.md](traceability-s01.md) | [traceability.md](traceability.md) |

---

## Diagrams

| Diagram | URL | Content |
|---------|-----|---------|
| State machine (complete) | https://diashort.apps.quickable.co/d/5e79b04e | All 16 screens, all transitions |
| Screen evolution & coverage | https://diashort.apps.quickable.co/d/0f9b04c7 | Growth by round, actor breakdown, box counts |
| State machine (Round 1) | https://diashort.apps.quickable.co/d/1b409822 | Original 6 screens (superseded) |

---

## Inventory Health

### Coverage
- **PM boxes matched:** 41/41 (BOX-01 through BOX-41). 4 boxes (14, 17, 18, 32/33) have no design impact by design — they are infrastructure/process boxes.
- **Design boxes matched:** 23/23 (BOX-D1 through BOX-D23). All have corresponding screens.
- **Engineer boxes addressed:** BOX-E1 through BOX-E5. All acknowledged, with design states where needed.
- **QA gaps addressed:** 9/9 gaps responded to. 7 closed or addressed. 2 deferred (G-01 first-visit flow, G-05 audit read mechanism).

### Staleness
- **screens-s01.md, flow-s01.md, traceability-s01.md** — Superseded by evolved versions. Kept for audit trail.
- All evolved documents (screens.md, flow.md, traceability.md) current through Round 10.

### Known Gaps
1. **First-visit flow not designed.** QA G-01 remains open. BOX-04 (experience communicates recognition) is weak-proven without a first-visit baseline. This is acknowledged debt.
2. **Admin audit query screen not designed.** G-05 notes audit trail has no read interface. If an audit screen is needed for HIPAA, it's future work.
3. **Incident management screen not designed.** BOX-17 (breach response) is a process, not a screen. If the process requires system support, it's future work.
4. **Drug name autocomplete not designed.** S-06 medications section uses free-text entry for Q3 deadline. Autocomplete from drug database is a future enhancement.
5. **Receptionist screen privacy mode not designed.** S-04 audit noted S2/S3R could be visible to other patients in the waiting area. Physical screen positioning is the primary mitigation; a software "blur sensitive fields" mode is future scope.

### Correctness
All boxes, screens, flows, and traceability cross-reference consistently. No orphan screens. No unmatched boxes. No hanging states (verified in flow.md dead-end audit).
