# Design Decisions — Clinic Check-In System

Where I pushed back on PM, where I added requirements PM didn't specify, trade-offs made, and rationale.

---

## DD-001: Mandatory Session Transition Screen (not just a tech fix)

**Triggered by:** [BUG-002](../product/user-stories.md#bug-002-data-leak--previous-patients-data-visible-on-scan), [US-003](../product/user-stories.md#us-003-secure-patient-identification-on-scan)
**Matched by:** [ADR-002](../architecture/adrs.md#adr-002-session-purge-protocol-for-kiosk-state-isolation)
**Confirmed by:** Jamie Park (Design Lead), 2024-11-05

**PM said:** BUG-002 is a backend/session issue — fix the data leak.

**Design added:** A mandatory visual transition screen (800ms minimum) between every patient session on the kiosk. This isn't just an engineering concern — the *design* must guarantee that no patient ever sees a flash of someone else's data, regardless of how fast the backend clears the session.

**Rationale:** Engineering can clear the DOM and component state, but race conditions are notoriously hard to eliminate entirely. The transition screen is a **designed safety net**: even if a race condition exists in the code, the patient sees a branded loading screen, not someone else's PHI. Defense in depth — the design layer adds a guarantee the code layer might not deliver 100% of the time.

**Trade-off:** Adds ~1 second to every check-in initiation. Acceptable for a healthcare product where trust is existential.

---

## DD-002: "Confirm and check in" requires end-to-end sync proof

**Triggered by:** [BUG-001](../product/user-stories.md#bug-001-kiosk-confirmation-not-syncing-to-receptionist-screen), [US-002](../product/user-stories.md#us-002-receptionist-sees-confirmed-check-in-data)
**Matched by:** [POST /checkins/{id}/complete](../architecture/api-spec.md#post-checkinsidcomplete), [WebSocket /ws/dashboard/{location_id}](../architecture/api-spec.md#websocket-wsdashboardlocation_id), [ADR-001](../architecture/adrs.md#adr-001-websocket-with-polling-fallback-for-real-time-dashboard-updates)
**Confirmed by:** Jamie Park (Design Lead), 2024-10-15

**PM said:** BUG-001 — kiosk confirmation should sync to receptionist.

**Design decision:** The green checkmark on the kiosk is gated on *receptionist-side confirmation*, not just kiosk-side save. If the sync hasn't been confirmed within 5 seconds, the patient sees a yellow warning asking them to notify the front desk — not a green checkmark.

**PM pushback expected:** "This makes the success rate look worse." Yes. But a false green checkmark is worse than an honest yellow warning. Patients who see green and then get asked to re-do paperwork at the desk lose trust in the system. Patients who see yellow and tell the receptionist "I checked in but it didn't go through" are still better off than the paper form fallback.

**Rationale:** Honest status is better than optimistic status in healthcare. The previous design (green = kiosk save succeeded) was a lie — it told the patient everything was fine when the receptionist had no data.

---

## DD-003: Medications step is non-skippable but designed to be fast

**Triggered by:** [US-005](../product/user-stories.md#us-005-medication-list-confirmation-at-check-in), [E6](../product/epics.md#e6-compliance--medication-list-at-check-in)
**Matched by:** [POST /checkins/{id}/complete](../architecture/api-spec.md#post-checkinsidcomplete), [ADR-004](../architecture/adrs.md#adr-004-immutable-medication-confirmation-audit-records)
**Confirmed by:** Sarah Chen (PM), 2024-11-20

**PM said:** Medication confirmation is mandatory per state regulation. Cannot be skipped.

**Design consideration:** A mandatory step in every check-in adds friction. For a patient whose medications haven't changed, this is annoying.

**Design solution:**
- If the medication list is unchanged from last visit, the "Continue" button is labeled "I've reviewed my medications — Continue" and is enabled immediately. One tap.
- The patient doesn't need to tap each medication individually.
- The compliance requirement (confirmation at every visit) is met by the act of viewing the list and tapping continue.
- If the list IS empty, the patient must actively choose "No current medications" — there's no way to skip past an empty list.

**What I added that PM didn't specify:**
- The compliance notice text ("This is required at every visit") is always visible but styled subtly — not a scary red banner. Patients shouldn't feel punished for a regulatory requirement.
- The confirmation timestamp captures not just the time but the *type*: "confirmed unchanged," "modified," or "confirmed none." This gives auditors more information without adding patient friction.

---

## DD-004: Mobile check-in uses one-step-per-screen, not a single long form

**Triggered by:** [US-007](../product/user-stories.md#us-007-pre-visit-check-in-from-personal-device), [E2](../product/epics.md#e2-mobile-check-in)
**Matched by:** [POST /patients/verify-identity](../architecture/api-spec.md#post-patientsverify-identity), [PATCH /checkins/{id}/progress](../architecture/api-spec.md#patch-checkinsidprogress)
**Confirmed by:** Jamie Park (Design Lead), 2024-10-28

**PM said:** Mobile check-in follows the same flow as kiosk — demographics, insurance, allergies, medications.

**Design decision:** On mobile, each section is its own screen (swipe/tap through steps). On kiosk, all sections are on a scrollable single page with a stepper.

**Rationale:** On a phone, a long scrollable form with inline editing is painful — sections push each other off-screen, the keyboard covers content, and the user loses their place. One section per screen with clear forward/back navigation is the established mobile pattern for multi-step forms. Each step feels quick and manageable.

**Trade-off:** More screen transitions on mobile. But each individual screen is focused and fast.

---

## DD-005: Edits use bottom-sheet on mobile, inline on kiosk

**Triggered by:** [US-001](../product/user-stories.md#us-001-pre-populated-check-in-for-returning-patients), [US-007](../product/user-stories.md#us-007-pre-visit-check-in-from-personal-device)
**Matched by:** [PATCH /patients/{id}](../architecture/api-spec.md#patch-patientsid), [GET /patients/{id}](../architecture/api-spec.md#get-patientsid)
**Confirmed by:** Jamie Park (Design Lead), 2024-10-28

**PM didn't specify** how editing should work on different surfaces.

**Design decision:**
- Kiosk: inline expand (section opens up in place)
- Mobile: full-screen bottom sheet slides up

**Rationale:** Kiosk has plenty of screen space — inline expansion works well and keeps context visible. On mobile, inline expansion pushes surrounding content off-screen and creates disorienting layout shifts. A bottom sheet is a standard mobile pattern that gives the edit form full focus without losing the context of what screen the user is on.

---

## DD-006: Side-by-side comparison for duplicate review, not a diff list

**Triggered by:** [US-013](../product/user-stories.md#us-013-duplicate-patient-detection-and-merge), [E5](../product/epics.md#e5-riverside-practice-acquisition)
**Matched by:** [GET /migration/duplicates/{id}](../architecture/api-spec.md#get-migrationduplicatesid), [POST /migration/duplicates/{id}/resolve](../architecture/api-spec.md#post-migrationduplicatesidresolve), [ADR-008](../architecture/adrs.md#adr-008-duplicate-detection-algorithm-for-riverside-migration)
**Confirmed by:** Sarah Chen (PM), 2024-12-22

**PM said:** Duplicate detection requires staff review with confidence scores. Staff can merge, keep separate, or flag.

**Design decision:** The duplicate review is a side-by-side comparison (our record left, Riverside record right) rather than a sequential list or diff view.

**Rationale:** Staff need to see *both records simultaneously* to make a judgment call. A diff list ("Field X differs: value A vs value B") loses the gestalt — the reviewer can't see the whole patient at once. Side-by-side lets them scan both records as a whole, spot obvious matches/mismatches, and make confident decisions faster. This matters at scale: staff need to review hundreds of potential duplicates.

**What I added that PM didn't specify:**
- Color coding: matching fields in green, differing fields in yellow. Instant visual scan.
- Field-level merge controls: radio buttons for each differing field (keep ours / keep theirs / edit). PM specified "most recent data wins by default" — I implemented this as the default radio selection, but the staff member can override field by field. This prevents the "most recent" heuristic from overwriting a correct older value with an incorrect newer one.
- Batch review: staff can select multiple records from the migration dashboard and step through them sequentially without returning to the list each time (PM mentioned batch processing as a should-have; I built the flow for it).

---

## DD-007: Skeleton screens instead of spinners for data loading

**Triggered by:** [US-006](../product/user-stories.md#us-006-peak-hour-check-in-performance), [E1](../product/epics.md#e1-returning-patient-recognition)
**Matched by:** [ADR-007](../architecture/adrs.md#adr-007-scaling-strategy-for-50-concurrent-sessions)
**Confirmed by:** Jamie Park (Design Lead), 2024-12-18

**PM said (via US-006):** System must remain responsive during peak hours. Show a loading state, not a frozen screen.

**Design decision:** Use skeleton screens (gray placeholder bars matching the layout structure) instead of centered spinners for all data-loading transitions.

**Rationale:** Spinners tell the user "wait." Skeleton screens tell the user "content is coming and will appear here." Skeleton screens feel faster (perceived performance) and prevent the jarring layout shift that happens when a spinner disappears and content pops in. For a kiosk that elderly patients use, reducing visual surprise matters.

**Where I draw the line:** Inline operations (saving an edit, confirming check-in) still use spinners — skeleton screens are for page/section-level loads. A spinner on a button is clear and appropriate.

---

## DD-008: No "currently being edited by" indicator

**Triggered by:** [US-004](../product/user-stories.md#us-004-concurrent-edit-safety-for-patient-records), [BUG-003](../product/user-stories.md#bug-003-concurrent-edit-causes-silent-data-loss)
**Matched by:** [PATCH /patients/{id}](../architecture/api-spec.md#patch-patientsid), [ADR-003](../architecture/adrs.md#adr-003-optimistic-concurrency-control-via-version-field)
**Confirmed by:** Jamie Park (Design Lead), 2024-12-10

**PM said (BUG-003):** Optimistic concurrency control. Detect conflicts on save.

**Design decision I considered and rejected:** Showing "This record is currently being edited by [Name]" when two staff members have the same patient open.

**Why I rejected it:**
- It implies pessimistic locking (other person is editing, you should wait) which contradicts the optimistic model
- It creates anxiety — the staff member sees the warning and either waits (inefficient) or edits anyway (then gets the conflict on save anyway)
- In practice, concurrent edits on the same patient are rare. Adding visual noise for a rare event degrades the normal experience.

**What I did instead:** The conflict is surfaced *only at save time*, with clear information about what changed and who changed it. This keeps the normal experience clean and handles the edge case gracefully when it occurs.

---

## DD-009: Kiosk auto-return countdown is visible and interruptible

**Triggered by:** [US-003](../product/user-stories.md#us-003-secure-patient-identification-on-scan), [BUG-002](../product/user-stories.md#bug-002-data-leak--previous-patients-data-visible-on-scan)
**Matched by:** [ADR-002](../architecture/adrs.md#adr-002-session-purge-protocol-for-kiosk-state-isolation)
**Confirmed by:** Jamie Park (Design Lead), 2024-11-05

**PM didn't specify** what happens after check-in completion on the kiosk.

**Design decision:** After the success screen, a visible 10-second countdown starts. The kiosk then returns to the welcome screen with a full session purge. Tapping the screen during the countdown resets it to 10 seconds.

**Rationale:**
- Prevents the next patient from seeing any residual data (reinforces BUG-002 fix)
- The countdown is *visible* so the current patient knows the screen will change — they don't walk away wondering if they need to do something else
- The countdown is *interruptible* because some patients (especially elderly) may still be reading the confirmation screen and need more time
- 10 seconds is enough for most patients to read "You're checked in" and walk away, but short enough that the kiosk isn't blocked for the next patient

---

## DD-010: Migration notice is informational, not alarming

**Triggered by:** [US-012](../product/user-stories.md#us-012-patient-data-migration-from-riverside), [E5](../product/epics.md#e5-riverside-practice-acquisition)
**Matched by:** [GET /patients/{id}](../architecture/api-spec.md#get-patientsid), [ADR-010](../architecture/adrs.md#adr-010-migration-pipeline-architecture--batch-import-with-rollback)
**Confirmed by:** Sarah Chen (PM), 2024-12-22

**PM said:** First visit after Riverside migration should prompt patient to review all migrated data.

**Design decision:** The migration notice is a subtle blue info banner, not a warning or error state. Text: "We recently migrated your records from Riverside Family Practice. Please carefully review all your information to make sure it's correct."

**Rationale:** These patients didn't ask to be migrated. They're visiting a clinic that acquired their previous practice. The last thing we want is to make them feel like something is wrong with their records. The notice is informational ("we migrated, please review") not alarming ("WARNING: your data may be incorrect").

**What I added:** Low-confidence OCR fields from paper records are highlighted in yellow with "Please verify this field." This draws attention to specific uncertain fields without making the entire record feel unreliable.

---

## DD-011: Mobile session timeout at 5 minutes, with warning at 4

**Triggered by:** [US-007](../product/user-stories.md#us-007-pre-visit-check-in-from-personal-device), [E2](../product/epics.md#e2-mobile-check-in)
**Matched by:** [GET /mobile-checkin/{token}/status](../architecture/api-spec.md#get-mobile-checkintokenstatus), [POST /patients/verify-identity](../architecture/api-spec.md#post-patientsverify-identity)
**Confirmed by:** Jamie Park (Design Lead), 2024-10-28

**PM said:** HTTPS, session timeout, no data cached on device after completion.

**PM didn't specify** the timeout duration or warning behavior.

**Design decision:** 5-minute inactivity timeout with a 1-minute warning banner.

**Rationale:**
- Too short (2 min): patients get timed out while dealing with a real-life interruption (doorbell, child, etc.)
- Too long (15 min): PHI sits visible on an unlocked phone that might be left on a table
- 5 minutes is the standard for healthcare web applications (HIPAA-aligned)
- The 1-minute warning gives patients a chance to tap the screen and stay alive, rather than being surprised by a timeout

---

## DD-012: Search always searches all locations

**Triggered by:** [US-009](../product/user-stories.md#us-009-cross-location-patient-record-access), [US-010](../product/user-stories.md#us-010-location-aware-check-in), [E3](../product/epics.md#e3-multi-location-support)
**Matched by:** [GET /dashboard/search](../architecture/api-spec.md#get-dashboardsearch), [GET /dashboard/queue](../architecture/api-spec.md#get-dashboardqueue), [ADR-005](../architecture/adrs.md#adr-005-centralized-database-for-multi-location-no-replication)
**Confirmed by:** Sarah Chen (PM), 2024-11-12

**PM said:** Cross-location search as a should-have for staff.

**Design decision:** Search is ALWAYS cross-location, regardless of the location filter on the dashboard. The location filter controls the queue view. Search is a different mental model — "find this patient wherever they are."

**Rationale:** If a patient calls Location A asking about their check-in at Location B, the receptionist at A needs to find them. Making search location-filtered would force the receptionist to switch locations first, which is an unnecessary step and a potential source of confusion ("I searched but couldn't find them" — because they were searching the wrong location).

**What the filter does:** The queue table filter controls what the receptionist sees in their day-to-day queue. It defaults to their location. This is about their daily workflow: "who's checking in at MY desk right now."

**What search does:** Finds any patient across the entire system. This is about answering questions: "where is this patient, what's their status."

Two different tools for two different needs. They don't need to be coupled.

---

## DD-013: Confidence scores are visible but not decisive

**Triggered by:** [US-013](../product/user-stories.md#us-013-duplicate-patient-detection-and-merge), [E5](../product/epics.md#e5-riverside-practice-acquisition)
**Matched by:** [GET /migration/duplicates/{id}](../architecture/api-spec.md#get-migrationduplicatesid), [POST /migration/duplicates/{id}/resolve](../architecture/api-spec.md#post-migrationduplicatesidresolve), [ADR-008](../architecture/adrs.md#adr-008-duplicate-detection-algorithm-for-riverside-migration)
**Confirmed by:** Sarah Chen (PM), 2024-12-22

**PM said:** Duplicate detection surfaces potential matches with confidence scores. No auto-merge.

**Design consideration:** Confidence scores can create a false sense of certainty. "95% match" sounds like a sure thing, but it could be two different people with the same name and birthday (it happens, especially in healthcare).

**Design decision:**
- Confidence score is shown prominently on the review screen — staff should see it
- But the merge controls are *exactly the same* regardless of score — full side-by-side comparison, field-level review, explicit confirmation
- There's no "quick merge" shortcut for high-confidence matches
- The confirmation dialog for merge is the same regardless of confidence

**Rationale:** [DEC-006](../product/decision-log.md#dec-006-duplicate-detection-requires-staff-confirmation--no-auto-merge) says no auto-merge. I'm extending that principle to the UI: no *easy* merge either. The cost of a false merge (combining two different patients' medication lists) is a safety incident. Every merge deserves the same care, whether the score is 55% or 99%.

---

## DD-014: "Already checked in" kiosk message for mobile-first patients

**Triggered by:** [US-007](../product/user-stories.md#us-007-pre-visit-check-in-from-personal-device), [E2](../product/epics.md#e2-mobile-check-in)
**Matched by:** [POST /checkins](../architecture/api-spec.md#post-checkins), [POST /patients/identify](../architecture/api-spec.md#post-patientsidentify)
**Confirmed by:** Jamie Park (Design Lead), 2024-10-28

**PM said:** If the patient checks in via mobile and also tries kiosk, the system recognizes them and skips redundant steps.

**Design decision:** The kiosk shows a friendly acknowledgment, not just a redirect: "You're already checked in! We received your information earlier. Please have a seat in the waiting area."

**What I could have done instead:** Skip the identity confirmation entirely and go straight to "already checked in." But that would mean a card scan with no feedback — the patient might think the kiosk is broken.

**What I actually do:** Card scan → transition screen → identity confirmation → "You're already checked in." The patient still sees their name and DOB (confirming the kiosk read their card correctly), but instead of the full check-in flow, they get the completion message immediately.
