# 001 — Patient Check-In: "I don't want to re-enter my info"

**Trigger:** Patient complaint during clinic feedback session.

> "Every time I visit, the receptionist asks me the same questions. My allergies, my insurance, my address. I already told you last time."

---

### Step 1: PM discovers boxes from the complaint

PM hears the patient's story. Does not jump to solutions. Extracts what must be true.

**Boxes created:**
- `B1` Returning patient's demographic data must be pre-filled at check-in
- `B2` Allergies and insurance must persist across visits
- `B3` Patient can review and confirm (not re-enter) their data

PM sends B1-B3 to Design.

#### Inventory

```
PM
  Requirements
    + [REQ-101] Returning patient data pre-fill        → source: patient feedback
    + [REQ-102] Cross-visit data persistence            → source: patient feedback
    + [REQ-103] Confirm-not-reenter flow                → source: patient feedback
  Boxes sent
    + B1 → Design (pre-filled data)
    + B2 → Design (persistence)
    + B3 → Design (confirm flow)

Design        (empty — waiting on box negotiation)
Engineer      (empty — waiting on Design)
QA            (empty — waiting on flows)
DevOps        (empty — waiting on system scope)
```

---

### Step 2: Design negotiates — doesn't blindly accept

Design receives B1-B3. Pushes back:

> "B1 says 'pre-filled' — does that mean editable or locked? What if insurance changed between visits?"

**Negotiation result:**
- `B1` revised → Data is pre-filled **and editable**. Changed fields flagged for staff review.
- `B4` new (from Design) → A "confirm info" step replaces intake form for returning patients.

#### Inventory

```
PM
  Requirements
    [REQ-101] Returning patient data pre-fill           → source: patient feedback
    [REQ-102] Cross-visit data persistence              → source: patient feedback
    [REQ-103] Confirm-not-reenter flow                  → source: patient feedback
  Boxes sent
    ~ B1 → Design (pre-filled + editable, changes flagged)    ← REVISED
    B2 → Design (persistence)
    B3 → Design (confirm flow)
    + B4 → Design (confirm step replaces intake)               ← NEW from Design

Design
  Boxes received
    + B1 (pre-filled + editable, changes flagged)
    + B2 (persistence)
    + B3 (confirm flow)
    + B4 (confirm step replaces intake)
  Screens                (not yet)
  State machine          (not yet)

Engineer      (empty)
QA            (empty)
DevOps        (empty)
```

---

### Step 3: Design translates into screens and states

Design produces artifacts matching B1-B4.

**Created:**
- Screen: "Welcome Back" — pre-filled fields, edit toggles, confirm button
- State machine mapping all paths

#### Inventory

```
PM             (unchanged)

Design
  Boxes received
    B1, B2, B3, B4
  Screens
    + [SCR-01] "Welcome Back" — pre-filled fields, edit toggles, confirm button
    + [SCR-02] "Staff Review Queue" — flagged changes for receptionist review
  State machine
    + New Patient → Full Intake → Ready
    + Returning Patient → Confirm Info →
        (edits?) → Staff Review Queue → Ready
        (no edits) → Ready
  Boxes sent
    + B1-B4 → Engineer (with screen specs and state machine)

Engineer      (empty)
QA            (empty)
DevOps        (empty)
```

---

### Step 4: Engineer translates — and discovers a problem

Engineer receives Design's specs. Translates into system flows. Discovers a system concern:

> HIS stores allergies in a different module than demographics. Two API calls, potential consistency issue. If allergy data is stale (>6 months), the "confirm" flow is clinically unsafe.

**New box surfaced upward:**
- `B5` (Engineer → Design/PM): If allergy data is stale (>6 months since last update), force re-confirmation even for returning patients.

B5 is negotiated. PM agrees — clinical safety. Design adds a conditional state.

#### Inventory

```
PM
  Requirements
    [REQ-101] Returning patient data pre-fill
    [REQ-102] Cross-visit data persistence
    [REQ-103] Confirm-not-reenter flow
    + [REQ-104] Stale allergy re-confirmation           → source: Engineer safety concern
  Boxes sent
    B1-B4 → Design
    + B5 → Design (stale allergy guard, from Engineer)   ← UPWARD BOX

Design
  Boxes received
    B1, B2, B3, B4, + B5
  Screens
    [SCR-01] "Welcome Back"
    [SCR-02] "Staff Review Queue"
    + [SCR-03] "Allergy Re-confirmation" — forced when data >6mo stale
  State machine
    New Patient → Full Intake → Ready
    Returning Patient → Confirm Info →
        + (allergies stale?) → Allergy Re-confirmation → Confirm Info
        (edits?) → Staff Review Queue → Ready
        (no edits) → Ready

Engineer
  Flows
    + [FLW-01] Check-in scan → lookup patient by MRN → fetch last-visit snapshot
    + [FLW-02] Fetch demographics (HIS Module A) + fetch allergies (HIS Module B)
    + [FLW-03] Diff current vs last-visit → populate form → flag changes
    + [FLW-04] Allergy staleness check (>6mo → force re-confirm)
  System design
    + Two-source data fetch (demographics + allergies from separate HIS modules)
    + Staleness threshold: 6 months on allergy records
  Boxes matched
    + B1 ← FLW-01, FLW-03
    + B2 ← FLW-02
    + B3 ← FLW-03
    + B4 ← FLW-01 (returning patient detection)
    + B5 ← FLW-04

QA            (empty — waiting on flows)
DevOps        (empty — waiting on system scope)
```

---

### Step 5: QA maps verification paths

QA takes Engineer's flows and Design's state machine. Maps every path to a proof mechanism.

#### Inventory

```
PM             (unchanged)
Design         (unchanged)
Engineer       (unchanged)

QA
  Verification paths
    + [VP-01] Returning patient, no changes → confirm flow, no staff review
        Mechanism: integration test with test patient, assert no review queue entry
        Degradation: monitor review queue for false positives
    + [VP-02] Returning patient, insurance changed → staff review queue populated
        Mechanism: integration test, mutate insurance, assert queue entry
        Degradation: monitor queue miss rate
    + [VP-03] Allergy data >6 months stale → forced re-confirmation screen
        Mechanism: integration test with backdated allergy record
        Degradation: monitor allergy-fetch response age headers
    + [VP-04] New patient → full intake flow (regression)
        Mechanism: existing intake test suite (must still pass)
        Degradation: existing monitors
  Proof coverage
    + B1 → VP-01, VP-02
    + B2 → VP-01, VP-02, VP-03
    + B3 → VP-01
    + B4 → VP-01, VP-04
    + B5 → VP-03

DevOps        (empty)
```

---

### Step 6: DevOps closes the loop

DevOps takes Engineer's system design and QA's degradation signals. Ensures the system runs as designed in production.

#### Inventory

```
PM             (unchanged)
Design         (unchanged)
Engineer       (unchanged)
QA             (unchanged)

DevOps
  Infrastructure
    + HIS API integration — demographics endpoint, allergies endpoint
    + SLA box: HIS API response time < 2s at check-in
  Environment parity
    + Test environment seeded with realistic patient data
    + Varying staleness dates (fresh, 3mo, 6mo, 12mo, 24mo)
  Observability
    + [OBS-01] Alert: allergy-fetch failure rate > 1% over 5min window
    + [OBS-02] Dashboard: check-in flow latency (P50, P95, P99)
    + [OBS-03] Alert: staff review queue depth > 50 (anomaly detection)
  Boxes matched
    + B1-B4 operational support ← SLA, environment parity
    + B5 production safety ← OBS-01, OBS-03
```

---

### Final inventory snapshot

```
PM (3 boxes sent, 1 requirement added from Engineer)
  REQ-101..104, B1..B5

Design (5 boxes received, 3 screens, 1 state machine)
  SCR-01..03, state machine with allergy-stale branch

Engineer (4 flows, 2 system design items, 5 boxes matched)
  FLW-01..04, two-source fetch, staleness threshold

QA (4 verification paths, 5 boxes covered, degradation signals on all)
  VP-01..04, full proof coverage

DevOps (1 SLA, 1 env parity config, 3 observability items)
  OBS-01..03, test data seeding
```

**One patient sentence → 5 boxes, 3 screens, 4 flows, 4 verification paths, 3 observability rules.**

Every artifact traces back to: *"I already told you last time."*
