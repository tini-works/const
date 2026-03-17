# Box Traceability — Complete (Rounds 1-10)

Every box must land on a screen. Every screen must serve a box.

## Diagrams

- **State machine (complete):** https://diashort.apps.quickable.co/d/5e79b04e
- **Screen evolution and coverage:** https://diashort.apps.quickable.co/d/0f9b04c7
- **State machine (Round 1 original):** https://diashort.apps.quickable.co/d/1b409822

---

## PM Boxes → Screen Mapping

| Box | Screen(s) | How It's Matched |
|-----|-----------|-----------------|
| BOX-01: Returning patient recognized | S1, S2 | Lookup returns matches before forms. S2 shows patient record. |
| BOX-02: Previously collected data not re-asked | S3P | All existing data pre-filled. No blank fields for existing data. Medications exception: always shown but pre-filled (S-06). |
| BOX-03: Confirm or update, not re-enter | S3P | Each section has "Still correct" / "Update." Insurance update includes photo capture option (S-08). |
| BOX-04: Experience communicates recognition | S3P (greeting), S2, S4 | Greeting by first name. Receptionist has context. Personalized closure. |
| BOX-05: Patient completion visible to receptionist in 2s | S3R, S5 | WebSocket live update on S3R with completion notification event. S5 queue as REST fallback. |
| BOX-06: No false success to patient | S3P | Green checkmark gated on server acknowledgment. Spinner during persist. Error + retry if fails. |
| BOX-07: Receptionist has fallback queue view | S5 | REST-based queue shows all sessions. Works without WebSocket. |
| BOX-08: Patient can pre-check-in from own device | S7, S6, S3P (mobile), S4 (mobile) | Link landing → identity verification → mobile confirmation flow → mobile completion. |
| BOX-09: Pre-check-in time window | S7 | Link landing shows time window states: too early, active, expired, already completed. |
| BOX-10: Pre-checked-in patients recognized at arrival | S5, S2 | Queue shows "pre-checked-in" status. S2 shows green banner with pre-check-in details. |
| BOX-11: Pre-check-in requires identity verification | S6 | DOB verification gate. 3 failed attempts = locked. No data shown before verification. |
| BOX-12: No PHI cross-patient exposure | S0, S3P, S4 | S0 welcome screen between sessions. Hard transition on session end. DOM/cache purge. No back-button access. |
| BOX-13: Screen clearing enforced | S0 | Programmatic transition to S0 on every session termination. Not advisory. |
| BOX-14: Data encrypted at rest | — | No design impact. Engineer/DevOps box. |
| BOX-15: HIPAA access logging | S6 (failed attempts logged) | Design impact limited to S6 lockout behavior. Logging is backend. |
| BOX-16: Minimum necessary standard | S3P, S6 | Patient sees only their data. S6 gates data access. Receptionist screens scoped to current patient. |
| BOX-17: Breach incident response | — | Operational process, no screen. |
| BOX-18: PHI in transit encrypted | — | No design impact. Engineer/DevOps box. |
| BOX-19: Patient data location-independent | S1, S3P | Search returns all patients regardless of location. Data shown without location filter. |
| BOX-20: Check-in works at any location | S1, S2, S3P | Same screens, same flow, regardless of location. Location is context, not barrier. |
| BOX-21: Location is context, not boundary | S5, S2 | S5 has location filter toggle. S2 shows last visit location. App header shows current location. |
| BOX-22: Medication list collected every visit | S3P | Medications section always expanded, always requires confirmation. 0-day staleness. |
| BOX-23: Variable-length structured medication data | S3P | List UI: add/remove/edit rows. Drug name, dosage, frequency, prescriber. Handles 0 to N medications. |
| BOX-24: Medication confirmation auditable | S3P | Explicit "I confirm this medication list is current" action creates unambiguous audit event. |
| BOX-25: Medications integrate with existing check-in | S3P | Medications section placed after allergies, before Done button. Same screen, same flow. |
| BOX-26: Concurrent check-in prevention airtight | S2 | Concurrent session state on S2 replaces action bar. Shows who has the active session, when, status. |
| BOX-27: Finalization conflict-safe | S8 | Conflict screen shows both sessions' changes. Receptionist resolves manually. |
| BOX-28: Lost data from concurrent finalization recoverable | S9 | Admin recovery screen shows dead sessions' data. Specific changes can be applied to patient record. |
| BOX-29: Patient can photograph insurance card | S3P (photo overlay) | Camera overlay with card frame guide within insurance update sub-flow on S3P. |
| BOX-30: OCR requires patient verification | S3P (verification step) | Field-by-field review of extracted data before submission. Patient confirms or edits each field. |
| BOX-31: Insurance card images are PHI | S3R | Card image shown to receptionist for verification. Image stored per HIPAA. Not shown to other patients (BOX-12). |
| BOX-32: 30 concurrent check-ins without degradation | — | Performance box. No direct design impact. Design handles degradation via BOX-34. |
| BOX-33: 60 concurrent across all locations | — | Performance box. No direct design impact. |
| BOX-34: Degraded performance visible to staff | S5, app header | System health indicator in header (green/amber/red). Queue header shows load metrics during peak. |
| BOX-35: Patient loss measurable | S5 | Abandonment tracking in queue. Timed-out and never-started sessions flagged as abandoned. |
| BOX-36: Riverside records importable | S10, S13 | Import dashboard tracks progress. Paper entry screen for manual input. |
| BOX-37: Duplicates detected before import | S11 | Duplicate review screen with side-by-side comparison and confidence tiers. |
| BOX-38: Merging preserves data from both sources | S12 | Field-by-field merge with conflict resolution. Both source records archived. |
| BOX-39: Import doesn't degrade live system | S10 | Import dashboard shows progress + pause control. Live system health in app header. |
| BOX-40: Post-import Riverside patients recognized | S1, S2, S3P | Imported patients in search index. S2 shows provenance note. S3P greeting includes Riverside note. |
| BOX-41: Paper records minimum viable data set | S13 | Required fields enforced. Incomplete records flagged. Illegible records routed to separate workflow. |

## Design Boxes → Screen Mapping

| Box | Screen(s) | How It's Matched |
|-----|-----------|-----------------|
| BOX-D1: Recognition failure graceful path | S1b | Assisted search, fuzzy matching, "Start as New, Merge Later" fallback. |
| BOX-D2: Two actors, two views | S2/S3R/S5 (receptionist), S3P (patient) | Receptionist has operational views. Patient has confirmation view. Different density, same data. |
| BOX-D3: Partial data handled without confusion | S3P | Missing fields in separate "We still need:" section. Visually distinct from pre-filled. |
| BOX-D4: Receptionist sees connection health | S3R | Green/amber/red dot indicator. Amber = polling fallback. Red = reconnecting. |
| BOX-D5: Patient completion produces unambiguous event | S3R | Status banner change, pulse animation on "Complete Check-in" button, optional audio cue. |
| BOX-D6: Mobile flow is responsive, not separate app | S3P (mobile) | Same components, responsive layout. No app download. Browser-based. |
| BOX-D7: Pre-check-in includes "what happens next" | S4 (mobile variant) | "You're all set. When you arrive, let the receptionist know." |
| BOX-D8: Partial pre-check-in handled | S2, S3P | Partial progress from phone preserved. Resumable on kiosk. S2 shows partial pre-check-in status. |
| BOX-D9: Kiosk has distinct idle state | S0 | Welcome screen with clinic branding, zero PHI. |
| BOX-D10: No intermediate data states during transitions | S3P → S0 | New session data loads behind S0. S0 dismissed only when new data ready. No flash of stale data. |
| BOX-D11: Receptionist sees current location context | App header | Persistent location indicator. Set at login/device config. |
| BOX-D12: Queue filters by location with cross-location toggle | S5 | Default: this location. Toggle: all locations. |
| BOX-D13: Medication confirmation cannot be conflated with scrolling | S3P | Explicit "I confirm this medication list is current" button. Activation requires review (scroll-gate or 3s delay). |
| BOX-D14: Empty medication list explicitly confirmed | S3P | "No, I am not taking any medications" as affirmative action. Distinct from skip. |
| BOX-D15: Concurrent blocking message is informative | S2 | Shows: who, when, status, location. Option to contact or take over (supervisor). |
| BOX-D16: Conflict shows both sessions for resolution | S8 | Side-by-side of applied vs. rejected changes. Resolution actions available. |
| BOX-D17: Photo capture has framing guidance | S3P (camera overlay) | Card-shaped overlay on viewfinder. "Position card within frame." Quality feedback. |
| BOX-D18: Manual entry fallback always available | S3P (insurance update) | "Having trouble? Enter manually" available from photo capture screen. |
| BOX-D19: Patient never sees system load state | S3P | Slower responses but no load messages. Timeouts show generic "trouble saving" message. |
| BOX-D20: Queue shows wait time and depth | S5 | Header shows count, average time, queue depth during busy/peak states. |
| BOX-D21: Duplicate review supports confidence tiers | S11 | High (>90%), Medium (60-90%), Low (<60%) filters. Priority ordering by confidence. |
| BOX-D22: Import dashboard shows real-time progress | S10 | Total, imported, pending, errors, duplicates. Rate and estimated completion. |
| BOX-D23: Merged record shows provenance | S12, S3P | S12 tags each resolved field with source. S3P may show "imported from Riverside" note. |

## Screen → Box Mapping (reverse — proves no orphan screens)

| Screen | Boxes Served |
|--------|-------------|
| S0: Kiosk Welcome/Idle | BOX-12, BOX-13, BOX-D9, BOX-D10 |
| S1: Patient Lookup | BOX-01, BOX-19, BOX-20, BOX-40 |
| S1b: Assisted Search | BOX-D1, BOX-37 (at point of care) |
| S2: Patient Summary | BOX-01, BOX-04, BOX-D2, BOX-10, BOX-21, BOX-26, BOX-D8, BOX-D15 |
| S3R: Check-in Monitor | BOX-D2, BOX-05, BOX-31, BOX-D4, BOX-D5 |
| S3P: Confirm Your Info | BOX-02, BOX-03, BOX-04, BOX-06, BOX-12, BOX-16, BOX-22, BOX-23, BOX-24, BOX-25, BOX-29, BOX-30, BOX-D3, BOX-D6, BOX-D13, BOX-D14, BOX-D17, BOX-D18, BOX-D19, BOX-D23 |
| S4: Check-in Complete | BOX-04, BOX-12, BOX-13, BOX-D7 |
| S5: Check-in Queue | BOX-07, BOX-10, BOX-21, BOX-34, BOX-35, BOX-D4, BOX-D12, BOX-D20 |
| S6: Identity Verification | BOX-11, BOX-15, BOX-16 |
| S7: Link Landing | BOX-08, BOX-09 |
| S8: Finalization Conflict | BOX-27, BOX-D16 |
| S9: Session Recovery | BOX-28, BOX-D16 |
| S10: Import Dashboard | BOX-36, BOX-39, BOX-D22 |
| S11: Duplicate Review | BOX-37, BOX-D21 |
| S12: Merge Resolution | BOX-38, BOX-D23 |
| S13: Paper Record Entry | BOX-36, BOX-41 |
| App header (persistent) | BOX-D11, BOX-34 |

**Every screen serves at least one box. No orphans.**

---

## Unmatched / Pending

1. **BOX-14 (encryption at rest)** — No design impact. Engineer/DevOps box. Correct that it has no screen.
2. **BOX-17 (breach incident response)** — Operational process, no current screen. Future: may need an incident management screen if the process requires system-supported workflow.
3. **BOX-18 (PHI in transit)** — No design impact. Engineer/DevOps box.
4. **BOX-32, BOX-33 (performance targets)** — No direct design impact. Performance is invisible to UX when targets are met. BOX-34 handles the degradation case.

## Engineer Boxes with Design Implications

| Box | Design Response | Status |
|-----|----------------|--------|
| BOX-E1: No data loss on timeout | Flow 8 (abort/interruption). Partial progress saved and restorable. | Matched |
| BOX-E2: Token-scoped access (kiosk) | No visible design impact — token is in URL, not shown to user. | Matched |
| BOX-E2 extended (mobile, S-03) | S6 identity verification gate replaces token-only access for mobile. | Matched |
| BOX-E3: Staged data (not immediate write) | S3R flagged items are a review gate, not decorative. Receptionist approves staged changes at finalization. | Matched |
| BOX-E4: Search index eventually consistent | S1 may show brief inconsistency after S2 "Update Record." Not a bug. No design change needed — receptionist proceeds with existing search results. | Acknowledged |
| BOX-E5: Concurrent check-in prevention | S2 concurrent session state. S8 conflict resolution. S9 recovery. | Matched (post S-07 fix) |

## QA Gaps with Design Responses

| Gap | Design Response | Status |
|-----|----------------|--------|
| G-01: UX claims no runnable proof | First-visit flow still not designed. Acknowledged as debt. Will address when first-visit story arrives. | Open |
| G-02: Reinitiation API missing | Design impact: Flow 8 (re-initiation from S5/S2) depends on this API. Engineer must provide. | Blocked on Engineer |
| G-03: Staleness thresholds assumed | **Resolved.** PM confirmed thresholds. Added medications = 0 days. | Closed |
| G-04: Unfinalised session policy | **Resolved.** Auto-expire 30 min, discard, audit. Design: session shows as "Timed Out" in S5 queue. | Closed |
| G-05: Audit trail no read mechanism | No current design impact. Future: admin audit query screen may be needed. | Deferred |
| G-06: WebSocket no contract test | **Validated by S-02.** Design added: connection health indicator (BOX-D4), completion notification (BOX-D5), S5 queue as REST fallback (BOX-07). | Design addressed; Engineer/QA own tests |
| G-07: HIPAA compliance boxes absent | **Resolved by S-04.** Design added: S0 welcome screen, screen clearing, PHI audit of all screens. | Closed |
| G-08: BOX-E5 state missing from Design | **Fixed.** S2 concurrent session state added. S8 and S9 added for conflict handling. Lesson: when Engineer adds a constraint box, Design must immediately add the UX state. | Closed |
| G-09: Token in WebSocket query param | No design impact. DevOps/Engineer must handle token placement. | Not a design concern |
