# Story 04 — Another Patient's Data Flashed on Screen (Critical Bug)

## Customer's Words

> "For a split second when I scanned my card, I saw someone else's name and allergies on the screen before it switched to mine. I don't know whose info that was but I could read it. That's not OK."

## What the Customer Is Saying

1. **"Someone else's name and allergies"** — Protected Health Information (PHI) from another patient was displayed to the wrong person. This is not a UX issue. This is a data breach.

2. **"For a split second"** — The patient is minimizing the duration, but they could read it. Duration is irrelevant to the violation. Visible = exposed.

3. **"That's not OK"** — The patient knows this shouldn't happen. Trust is damaged. If they tell other patients, or report it, this becomes a compliance incident.

## Severity: CRITICAL

This is the highest severity event in the system to date. This is:
- A **HIPAA violation** — unauthorized disclosure of PHI to another individual
- A **trust-destroying event** — the patient now questions whether their own data is being shown to others
- A **regulatory reporting trigger** — depending on the data exposed, this may require breach notification

## Candidate Root Causes (for Engineering)

1. **Stale session on kiosk** — Previous patient's session was still rendered on the tablet. New card scan triggered a new lookup, but the old data was visible during the transition. This suggests the kiosk doesn't clear the screen between sessions.
2. **Search result caching** — The search API returned cached results from a previous query, briefly showing the wrong patient's data before the correct results loaded.
3. **Race condition in session initialization** — Two sessions overlapping on the same kiosk device. The new session's data load raced with the old session's render.
4. **Client-side state bleed** — Single-page app retaining DOM state from the previous patient's session.

## Immediate Actions Required

1. **Incident declaration** — This is a privacy incident regardless of root cause
2. **Screen clearing between sessions** — Every session termination (finalize, timeout, cancel) must clear all patient data from the display before any new interaction
3. **HIPAA breach assessment** — Was the exposed data of a type requiring breach notification? (Name + allergies = yes, likely a covered breach)
4. **Audit** — Identify the affected patients (the viewer and the exposed)

## Boxes This Generates

This generates compliance boxes that QA flagged as missing in G-07 (HIPAA compliance boxes are absent). That gap is no longer theoretical.
