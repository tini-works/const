# Boxes — Story 01 (Returning Patient Recognition)

## BOX-01: Returning patient is recognized

When a patient who has visited before arrives for a new visit, the system must identify them as a returning patient before any data collection begins.

**Traces to:** "I already told you last time" — the patient expects the system to know they've been here.

**Verified when:** The check-in flow distinguishes between first-visit and returning-visit, and retrieves existing patient data before presenting any forms.

**Status:** Accepted by all verticals. Under stress at peak load (S-09). Must work across locations (S-05). Must work for migrated Riverside patients (S-10).

---

## BOX-02: Previously collected data is not re-asked

Allergies, insurance, and address — data the patient has already provided — must not be collected again from scratch.

**Traces to:** "The receptionist asks me the same questions. My allergies, my insurance, my address."

**Verified when:** At check-in, the patient is not presented with blank fields for data that already exists in their record.

**Exception (S-06):** Medications must be confirmed every visit per state mandate. This is confirm-not-reenter, but always prompted.

**Status:** Accepted. Staleness thresholds confirmed — see PM Decisions below.

---

## BOX-03: Patient can confirm or update, not re-enter

The system may present existing data for review ("is this still correct?") but must not require full re-entry.

**Traces to:** "It's annoying" — the annoyance is effort duplication.

**Verified when:** Existing data is shown pre-filled. The patient's action is to confirm or edit, not to provide from scratch.

**Status:** Accepted. Extends to medications (S-06) and insurance photo upload (S-08).

---

## BOX-04: The experience communicates recognition

The patient must feel known. The interaction itself must signal "we remember you."

**Traces to:** "It feels like nobody remembers me."

**Verified when:** The check-in flow for returning patients is observably different from the first-visit flow. Greeting, reduced steps, pre-filled information.

**Status:** Accepted. QA flags as weak proof until first-visit flow exists for comparison (G-01). S-02 bug shows this box was violated when receptionist couldn't see patient's completion.

---

## PM Decisions on Previously Open Questions

**Staleness thresholds (CONFIRMED):**
- Insurance: 6 months (Design's proposal accepted)
- Address: 12 months (Design's proposal accepted)
- Allergies: never stale (Design's proposal accepted)
- Medications: 0 days — always confirm every visit (S-06 mandate)

**Identity verification method:** Name + DOB as primary lookup, insurance card scan as secondary. Design's proposal accepted.

**Multi-location data persistence:** YES, confirmed by clinic administrator (S-05). Data persists across all locations.

**Unfinalised session policy:** Accept Engineer's recommendation: auto-expire after 30 minutes, discard staged changes, write audit log entry. No follow-up task generated — the receptionist will handle it at next patient contact.

**HIPAA applicability:** CONFIRMED applicable. S-04 proves it. Compliance boxes now generated (see boxes-04.md).

**Audit trail retention:** 7 years (HIPAA minimum for medical records). Engineer to size storage accordingly.
