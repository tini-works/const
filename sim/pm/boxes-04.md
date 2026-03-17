# Boxes — Story 04 (Data Breach) + HIPAA Compliance

Story 04 is a critical bug that also triggers the compliance boxes QA demanded in G-07.

---

## BOX-12: No PHI from one patient is ever visible to another patient

Zero tolerance. At no point in any flow should any patient see another patient's Protected Health Information. This includes during screen transitions, session initialization, search results, error messages, and loading states.

**Traces to:** "I saw someone else's name and allergies on the screen" — HIPAA violation.

**Verified when:**
1. Session termination (finalize, timeout, cancel) clears ALL patient data from the display before any new interaction
2. Kiosk returns to a clean, data-free welcome screen between patients
3. Client-side state (DOM, memory, cache) is purged on session end
4. Search results on the receptionist screen never leak into the patient-facing kiosk display
5. No browser back-button access to previous patient data

---

## BOX-13: Screen clearing is enforced, not advisory

The kiosk must programmatically clear patient data on session end. This is not dependent on the receptionist clicking "next patient" or the patient walking away.

**Traces to:** Root cause analysis of S-04 — likely a stale session rendering on the kiosk.

**Verified when:** Automated test: end a session, verify DOM contains zero PHI elements, begin a new session, verify no prior patient data is rendered at any point during initialization.

---

## BOX-14: HIPAA — Data encrypted at rest

All patient data (allergies, insurance, address, medications, audit trails) must be encrypted at rest using AES-256 or equivalent.

**Traces to:** HIPAA Security Rule, 45 CFR 164.312(a)(2)(iv).

**Verified when:** Database encryption is enabled and verified. Backups are encrypted. No patient data exists in plaintext on any persistent storage.

---

## BOX-15: HIPAA — Access logging

Every access to patient data (read, write, update) must be logged with: who accessed, what data, when, and from where.

**Traces to:** HIPAA Security Rule, 45 CFR 164.312(b).

**Verified when:** Audit log captures all access events. Logs are tamper-resistant (append-only or externally stored). Retention: 7 years minimum.

---

## BOX-16: HIPAA — Minimum necessary standard

Each actor sees only the data necessary for their role. The patient sees their own data. The receptionist sees what they need to verify. No actor sees more than required.

**Traces to:** HIPAA Privacy Rule, 45 CFR 164.502(b).

**Verified when:** Patient view shows only their own confirmation data. Receptionist view shows only the current check-in patient's data relevant to check-in. No browsing of patient records beyond the active session.

---

## BOX-17: Breach incident response process

When a data exposure occurs (as in S-04), a defined process must execute: identify affected patients, assess breach severity, determine notification obligations, document and report.

**Traces to:** HIPAA Breach Notification Rule, 45 CFR 164.400-414.

**Verified when:** Incident response procedure is documented. The S-04 incident is processed through it as the first case. Root cause, affected individuals, remediation, and reporting status are recorded.

---

## BOX-18: PHI in transit is encrypted

All data transmission between client devices (kiosks, phones) and servers must use TLS 1.2+. WebSocket connections must use WSS (encrypted WebSocket).

**Traces to:** HIPAA Security Rule, 45 CFR 164.312(e)(1).

**Verified when:** No unencrypted endpoints exist. Certificate validation is enforced. HSTS headers are set.
