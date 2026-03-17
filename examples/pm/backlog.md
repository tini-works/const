# Backlog

Prioritized by urgency, dependency order, and business impact.

| # | Story | Epic | Priority | Status | Notes |
|---|-------|------|----------|--------|-------|
| BUG-002 | Data leak — previous patient visible on scan | E1 | P0 | Open | Security/HIPAA. Fix immediately. Block all other E1 work until resolved. |
| BUG-001 | Kiosk confirmation not syncing to receptionist | E1 | P1 | Open | Core flow is broken — patients complete check-in but staff can't see it. |
| BUG-003 | Concurrent edit causes silent data loss | E1 | P1 | Open | Insurance update silently lost. Data integrity risk. |
| US-005 | Medication list confirmation at check-in | E6 | P1 | Open | Hard deadline: Q3. Compliance/license risk. Start design now. |
| US-001 | Pre-populated check-in for returning patients | E1 | P2 | Open | Core value proposition. Foundation for everything else. |
| US-002 | Receptionist sees confirmed check-in data | E1 | P2 | Open | Depends on BUG-001 fix. |
| US-003 | Secure patient identification on scan | E1 | P2 | Open | Depends on BUG-002 fix. Hardened acceptance criteria post-incident. |
| US-006 | Peak-hour check-in performance | E1 | P2 | Open | Patients leaving the clinic. Revenue impact. |
| US-004 | Concurrent edit safety | E1 | P2 | Open | Depends on BUG-003 fix. Broader concurrency model. |
| US-009 | Cross-location patient record access | E3 | P2 | Open | Needed before second location opens (next month). |
| US-010 | Location-aware check-in | E3 | P2 | Open | Depends on US-009. |
| US-007 | Pre-visit mobile check-in | E2 | P3 | Open | High patient demand but not blocking. Depends on E1 stability. |
| US-008 | Receptionist visibility of mobile check-ins | E2 | P3 | Open | Depends on US-007. |
| US-011 | Insurance card photo capture | E4 | P3 | Open | Quality-of-life. Good for mobile check-in too. |
| US-012 | Patient data migration from Riverside | E5 | P3 | Open | Large effort. Depends on E3 (multi-location). See PRD. |
| US-013 | Duplicate detection and merge | E5 | P3 | Open | Depends on US-012. Critical to get right — no duplicates. |

## Priority definitions
- **P0:** Fix now. Production incident, data exposure, compliance violation.
- **P1:** Fix this sprint. Core flow broken or deadline-driven compliance.
- **P2:** Next up. High value, needed soon, or unblocks other work.
- **P3:** Planned. Important but can wait for dependencies or capacity.

## Sequencing notes

**Immediate (this sprint):**
- BUG-002 first — security incident, possible HIPAA reporting obligation
- BUG-001 and BUG-003 in parallel — both are data integrity issues in the core flow
- US-005 design kickoff — Q3 deadline means we need lead time

**Next sprint:**
- US-001 through US-004 — finish stabilizing the core check-in experience
- US-006 — performance work can happen alongside feature work
- US-009, US-010 — second location opens next month

**Following sprints:**
- US-007, US-008 — mobile check-in (E1 must be stable first)
- US-011 — photo capture (nice acceleration for mobile launch)
- US-012, US-013 — Riverside migration (E3 must be in place, PRD needs sign-off)
