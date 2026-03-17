# PRD: Mobile Check-In

## Problem
Patients arrive early to deal with kiosk check-in. They want to confirm their information from home before they leave. Standing at a kiosk is not a good experience — it's a bottleneck during peak hours and adds nothing for returning patients who just need to confirm unchanged data.

## Users
- **Patients** with upcoming appointments who have a smartphone
- **Receptionists** who need to know which patients have completed check-in before arrival

## Solution
A mobile-optimized web flow that lets patients complete check-in before arriving. No app download. Patient receives a link (SMS or email) before their appointment, opens it in their browser, verifies their identity, confirms or updates their information, and is done. When they walk in, the receptionist sees them as already checked in.

## Flow

1. **Trigger:** System sends check-in link 24 hours before appointment (configurable)
2. **Identity verification:** Patient confirms identity (DOB + last 4 of phone, or similar low-friction method)
3. **Review & confirm:** Demographics, insurance, allergies, medications — same steps as kiosk
4. **Completion:** Patient sees confirmation. Status updates in receptionist dashboard.
5. **Arrival:** Patient arrives, receptionist sees "checked in via mobile," patient goes to waiting area

## Requirements

**Must have:**
- Mobile-responsive web flow (no app)
- SMS and email delivery of check-in link
- Identity verification before showing PHI
- Same data confirmation flow as kiosk (demographics, insurance, allergies, medications)
- Receptionist dashboard shows mobile check-in status and channel
- Check-in link expires at appointment time
- HTTPS, session timeout, no data cached on device after completion

**Should have:**
- Insurance card photo capture within mobile flow
- Partial completion — patient can start on mobile, finish at kiosk
- Reminder if check-in link hasn't been used 2 hours before appointment

**Won't have (for now):**
- Native app
- Appointment scheduling (separate product area)
- Telehealth integration

## Dependencies
- E1 must be stable (returning patient data, no sync bugs, no data leaks)
- E6 medication confirmation must be included in the mobile flow
- E4 insurance photo capture is a nice-to-have at launch but not required

## Risks
- **Low adoption:** Patients may not use it. Mitigation: track usage, keep kiosk as fallback, don't degrade the kiosk experience.
- **Security:** PHI on personal devices. Mitigation: no data cached, session timeout, identity verification before data display, HTTPS only.
- **Duplicate check-in:** Patient does mobile and kiosk. Mitigation: system detects existing check-in and skips redundant steps.

## Success metrics
- 30% of appointments use mobile check-in within 3 months of launch
- Average kiosk wait time decreases during peak hours
- Patient satisfaction score for check-in experience improves

---

## Traceability

| Link type | References |
|-----------|------------|
| Epic | [E2: Mobile Check-In](epics.md#e2-mobile-check-in) |
| User Stories | [US-007: Pre-visit mobile check-in](user-stories.md#us-007-pre-visit-check-in-from-personal-device), [US-008: Receptionist visibility of mobile check-ins](user-stories.md#us-008-receptionist-visibility-of-mobile-check-ins) |
| Decisions | [DEC-004: Mobile web, not native app](decision-log.md#dec-004-mobile-check-in-via-mobile-web-not-native-app) |
| Screens | [3.1 Mobile Landing](../experience/screen-specs.md#31-mobile--link-landing--identity-verification), [3.2 Mobile Review](../experience/screen-specs.md#32-mobile--review-screens-demographics-insurance-allergies-medications), [3.3 Mobile Confirmation](../experience/screen-specs.md#33-mobile--confirmation-screen) |
| Flows | [Flow 6: Mobile Happy Path](../experience/user-flows.md#6-mobile-check-in--happy-path), [Flow 7: Partial Completion](../experience/user-flows.md#7-mobile-check-in--partial-completion), [Flow 8: Duplicate Prevention](../experience/user-flows.md#8-mobile-check-in--kiosk-arrival-duplicate-prevention), [Flow 12: Mobile Multi-Location](../experience/user-flows.md#12-mobile-check-in--multi-location) |
| API | [POST /patients/verify-identity](../architecture/api-spec.md#post-patientsverify-identity), [POST /mobile-checkin/send-link](../architecture/api-spec.md#post-mobile-checkinsend-link), [GET /mobile-checkin/{token}/status](../architecture/api-spec.md#get-mobile-checkintokenstatus) |
| Tests | [TC-401](../quality/test-suites.md#tc-401-mobile-check-in--happy-path) through [TC-407](../quality/test-suites.md#tc-407-mobile--already-checked-in-via-mobile), [TC-606](../quality/test-suites.md#tc-606-medication-step-on-mobile), [TC-804](../quality/test-suites.md#tc-804-photo-capture-on-mobile) |
