**Traceability:**
- Traced from: [E1: Returning Patient Recognition](epics.md#e1-returning-patient-recognition) — Round 1 patient complaint
- Matched by:
  - [Screen 1.1: Kiosk Welcome](../experience/screen-specs.md#11-kiosk-welcome-screen), [Screen 1.3: Identity Confirmation](../experience/screen-specs.md#13-patient-identification-confirmation-screen), [Screen 1.4: Demographics Review](../experience/screen-specs.md#14-check-in-review-screen--demographics), [Screen 1.5: Insurance Review](../experience/screen-specs.md#15-check-in-review-screen--insurance), [Screen 1.6: Allergies Review](../experience/screen-specs.md#16-check-in-review-screen--allergies), [Screen 1.8: Confirmation](../experience/screen-specs.md#18-check-in-confirmation-screen)
  - [Flow 1: Returning Patient — Kiosk Check-In](../experience/user-flows.md#1-returning-patient--kiosk-check-in-happy-path), [Flow 2: New Patient — Kiosk Check-In](../experience/user-flows.md#2-new-patient--kiosk-check-in), [Flow 3: Card Scan Failures](../experience/user-flows.md#3-card-scan-failures)
  - API: [POST /patients/identify](../architecture/api-spec.md#post-patientsidentify), [GET /patients/{id}](../architecture/api-spec.md#get-patientsid), [PATCH /patients/{id}](../architecture/api-spec.md#patch-patientsid)
  - Compliance: [KP2-121](compliances/KVDT/KP2-121.md)
- Proven by: [TC-101](../quality/test-suites.md#tc-101-returning-patient--happy-path-check-in), [TC-102](../quality/test-suites.md#tc-102-returning-patient--edit-demographics-during-check-in), [TC-103](../quality/test-suites.md#tc-103-new-patient--kiosk-check-in), [TC-104](../quality/test-suites.md#tc-104-card-scan-failure--fallback-to-name-search)
- Verification: **proven** — TC-101 through TC-105 passing in staging, all 5 AC covered. Verified 2024-03-15.
- Confirmed by: Sarah Chen (PM Lead), 2024-03-15
