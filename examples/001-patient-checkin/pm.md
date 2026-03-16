# PM — Patient Check-In

## The patient's words

> "Every time I visit, the receptionist asks me the same questions. My allergies, my insurance, my address. I already told you last time."

The patient doesn't know about HIS systems or data sync. They know one thing: they're repeating themselves and it feels like nobody remembers them.

## What we committed to

### 1. Data is there when the patient arrives

The patient's demographic data, allergies, and insurance should be pre-filled when they check in for a return visit.

Negotiated with Design. Design asked: "editable or locked? What if insurance changed?" We agreed: **editable, with changes flagged for staff review.** Better than either extreme — patients can correct errors, staff can verify changes.

**Verify:** Design has a "Welcome Back" screen (SCR-01) with pre-filled fields and edit toggles. Engineer's check-in flow retrieves data by MRN from HIS. QA's VP-01 runs a returning patient through the flow in staging and confirms data appears.

### 2. Allergies and insurance persist across visits

Data entered during one visit must be available at the next. Not re-entered. Not lost.

**Verify:** Engineer fetches from two HIS modules (demographics from Module A, allergies from Module B). QA's VP-01 and VP-02 both confirm cross-visit data is present.

### 3. Confirm, don't re-enter

Design originated this one. PM asked for "pre-filled data." Design pushed back: a pre-filled intake form is still an intake form. Returning patients deserve a different experience — a confirm step, not a form.

**Verify:** Design's check-in flow shows: Returning Patient → Confirm Info (not Full Intake). The confirm step replaces the intake form entirely.

### 4. Stale allergy data gets re-confirmed

Engineer surfaced this. HIS stores allergies in a separate module. That data can go stale — last updated 6, 12, 24 months ago. A returning patient "confirming" stale allergy data is a clinical safety risk. They might confirm allergies that are no longer accurate.

PM accepted this because patient safety is an external concern PM faces. This commitment didn't come from the patient — it came from the system revealing a risk the patient can't see.

**Verify:** Design has an "Allergy Re-confirmation" screen (SCR-03) that appears when allergy data is >6 months old. Engineer's FLW-04 checks the staleness. QA's VP-03 tests with a backdated record in staging and confirms the screen appears.

## What goes suspect if things change

- If the HIS API changes how demographics or allergies are returned → commitments 1, 2, 4 go suspect
- If Design changes the check-in flow → commitment 3 goes suspect
- If the patient's story changes (new complaints, new regulatory requirements) → all commitments need re-evaluation against the new reality
