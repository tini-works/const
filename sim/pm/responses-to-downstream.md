# PM Responses to Downstream Questions

Answers to open questions raised by Design, Engineer, QA, and DevOps during Round 1 negotiations, now informed by Rounds 2-10.

---

## To Design (from negotiation-s01.md)

### Q1: Identity verification method
**ANSWER:** Name + DOB as primary lookup, insurance card scan as secondary. Confirmed.
**Additional context from S-08:** Insurance card photo upload is coming as a feature. The card scan for verification and the card photo for data update may use the same camera/scanning capability.
**Additional context from S-03:** Mobile pre-check-in needs stronger identity verification (BOX-11). Kiosk flow stays with receptionist-supervised Name+DOB. Mobile flow adds a verification gate (DOB confirmation minimum).

### Q2: Data freshness thresholds
**ANSWER CONFIRMED:**
- Insurance: 6 months
- Address: 12 months
- Allergies: never stale
- **NEW — Medications: 0 days (always confirm).** State mandate (S-06). This is non-negotiable.

### Q3: Multi-location
**ANSWER:** YES, data persists across locations. Confirmed by clinic administrator (S-05). Design's assumption was correct. This is now a first-class requirement (BOX-19..21).

### New work for Design from Rounds 2-10:
- **S-02:** Receptionist queue/list view (BOX-07). WebSocket fallback behavior. Design the "receptionist can't see patient completion" failure state.
- **S-03:** Mobile-optimized check-in flow. Pre-check-in status on receptionist's queue.
- **S-04:** Screen clearing between sessions. Welcome/idle screen for kiosk.
- **S-06:** Medications section in check-in flow. Variable-length list with add/remove/update. Always expanded, never skippable.
- **S-07:** Concurrent check-in error state on receptionist screen (this was BOX-E5/G-08 — now proven critical).
- **S-08:** Camera/photo capture UI in check-in flow. OCR result verification screen.
- **S-09:** Load indicator and warning states on receptionist UI.
- **S-10:** Import review interface — side-by-side duplicate comparison, merge controls. (This may be an admin-only tool, not part of check-in flow.)

---

## To Engineer (from negotiation-s01.md)

### Q1: Unfinalised session policy
**ANSWER:** Auto-expire after 30 minutes, discard staged changes, write audit log entry. Engineer's recommendation (a) accepted. No follow-up task generated. If the patient returns, a new session is created.

### Q2: HIPAA data-at-rest requirements
**ANSWER:** HIPAA is confirmed applicable (S-04 proved it). AES-256 at the storage layer is sufficient for encryption at rest. See BOX-14. Full HIPAA compliance boxes in boxes-04.md.

### Q3: Audit trail retention
**ANSWER:** 7 years minimum (HIPAA standard for medical records). Size storage accordingly.

### New work for Engineer from Rounds 2-10:
- **S-02:** WebSocket reliability — fallback polling when WebSocket fails. Must prove BOX-05 (receptionist visibility within 2s, fallback within 10s).
- **S-03:** New access model for mobile pre-check-in. Patient-initiated sessions with identity verification. Appointment system integration.
- **S-04:** Session-end screen clearing. Client-side state purge. This is a client + API concern (session termination must trigger client cleanup).
- **S-05:** Multi-location architecture. Centralized data store serving multiple locations. Location as a context attribute, not a data boundary.
- **S-06:** Medications data model (variable-length, structured). New data category with 0-day staleness. Must be ready by Q3.
- **S-07:** Fix BOX-E5. The concurrent prevention constraint failed. Diagnose, fix, add finalization-time conflict detection. BOX-26..28.
- **S-08:** OCR/document intelligence service. Image capture, storage (PHI), extraction pipeline.
- **S-09:** Performance engineering. Load test for 30 concurrent/location, 60 aggregate. Identify bottlenecks.
- **S-10:** Data migration pipeline. Duplicate detection algorithm. Merge workflow. Bulk import throttling.

---

## To QA (from gaps.md)

### G-01 (UX claims no runnable proof)
**STATUS:** Still valid. Design must produce first-visit flow. PM is not blocking this — Design has freedom.

### G-02 (Reinitiation API missing)
**STATUS:** Still valid. Engineer must add `/reinitiate` to API spec.

### G-03 (Staleness thresholds assumed)
**RESOLVED.** PM confirms Design's proposed thresholds. See above. Add medications = 0 days.

### G-04 (Unfinalised session policy undefined)
**RESOLVED.** Auto-expire after 30 min, discard, audit log. See above.

### G-05 (Audit trail no read mechanism)
**STATUS:** Still valid short-term (DB query acceptable for now). Long-term audit query endpoint needed. HIPAA (S-04) increases urgency — audit access is a compliance requirement (BOX-15).

### G-06 (WebSocket no contract test)
**VALIDATED BY S-02.** The bug QA predicted happened. WebSocket failure caused receptionist blindness. This gap is now P0. BOX-05 adds the specific requirement.

### G-07 (HIPAA compliance boxes absent)
**RESOLVED.** S-04 triggered HIPAA compliance boxes. See boxes-04.md (BOX-12..18).

### G-08 (BOX-E5 state missing from Design)
**VALIDATED BY S-07.** The concurrent check-in bug happened. Design must add this state. Engineer must fix the prevention. This is now P0.

### G-09 (Token in WebSocket query param)
**STATUS:** Still valid. DevOps must confirm infrastructure-level log scrubbing of WebSocket query params. BOX-O4 covers this, but operational proof is needed.

---

## To DevOps (from negotiation-s01.md)

### Q1: Finalization transaction scope
**STATUS:** PM confirms this must be transactional (BOX-O1). S-07 (concurrent finalization) adds urgency.

### Q2: Event bus guaranteed delivery
**STATUS:** Must be at-least-once delivery. S-02 (receptionist blind) suggests events may be lost. Investigate.

### Q3: WebSocket reconnection
**STATUS:** S-02 validates this concern. WebSocket must auto-reconnect with fallback to polling. Define reconnection strategy.

### Q4: Graceful shutdown timing
**STATUS:** 30-second minimum grace period confirmed. In-flight section saves must complete.

### New work for DevOps from Rounds 2-10:
- **S-04:** Log scrubbing must be proven operational (BOX-O4). HIPAA breach may trigger external audit of infrastructure.
- **S-05:** Multi-location infrastructure. Centralized database serving multiple locations. Network latency between locations.
- **S-09:** Capacity planning for peak load. Horizontal scaling for check-in service. Connection pool sizing. Kiosk device performance assessment.
- **S-10:** Bulk import infrastructure. Throttled import pipeline that doesn't degrade production. Search index rebuild strategy.
