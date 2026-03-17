# Technical Design: Mobile Pre-Check-In

**Related:** Epic E2, US-007, US-008, PRD Mobile Check-In, ADR-001

---

## Problem

Patients want to complete check-in from their phone before arriving at the clinic. The kiosk is a bottleneck during peak hours and adds nothing for returning patients who just need to confirm unchanged data. We need a mobile web flow (no native app — DEC-004) that is secure, handles partial completion, and integrates with the existing receptionist dashboard.

---

## Approach

### Token-Based Link Flow

Each mobile check-in is initiated by sending the patient a link containing a single-use, time-bounded token. The token encodes the appointment ID, patient ID, and expiration. No account creation, no app download, no stored credentials.

**Link generation:**
```
https://checkin.clinic.example.com/m/{token}

Token payload (JWT, signed):
{
  "appointment_id": "uuid",
  "patient_id": "uuid",
  "exp": 1710666900  // appointment time as Unix timestamp
}
```

**Link delivery:**
- SMS via Twilio (primary): triggered 24 hours before appointment by a scheduled job
- Email (secondary): triggered simultaneously
- Reminder: 2 hours before appointment if the link hasn't been used

The Notification Service handles delivery. The scheduler queries appointments for the next 24 hours and enqueues link-send jobs.

### Identity Verification

Before any PHI is displayed, the patient must verify their identity with DOB + last 4 digits of phone number. This is a low-friction challenge that prevents someone who intercepts the SMS from accessing the record.

**Flow:**
1. Patient opens link
2. Server validates token (not expired, not already used to completion)
3. Patient enters DOB + last 4 of phone
4. Server matches against the patient record linked to the token
5. On match: issue a session JWT (valid until appointment time, or 5 minutes of inactivity)
6. On mismatch: allow 3 attempts, then lock with "contact the clinic" message

**Why not a stronger auth?** This is a pre-visit check-in, not a patient portal. The token is already scoped to a specific appointment and patient. DOB + phone last-4 is sufficient to prevent casual unauthorized access. Stronger auth (e.g., SMS OTP) adds friction that would kill adoption. HIPAA requires "reasonable and appropriate safeguards" — tokenized link + knowledge-based verification meets this bar for a check-in flow.

### Session Management

**Session lifecycle:**
1. Created on successful identity verification
2. Valid until appointment time or 5 minutes of inactivity
3. Extended by any API interaction (resets the 5-minute timer)
4. Destroyed on check-in completion, explicit logout, or expiration

**State persistence for partial completion:**
- After each step is completed (demographics confirmed, insurance confirmed, etc.), the Check-In Service persists the progress: `check_ins.current_step` and `check_ins.status = 'in_progress'`
- If the patient closes the browser and reopens the link, they re-verify identity and resume from the last completed step
- The receptionist dashboard shows "Mobile — Partial" with the step they left off at

**Security cleanup on completion:**
- After the confirmation screen, the server invalidates the session
- The client clears all browser storage (localStorage, sessionStorage, cookies)
- The back button shows "already checked in" — no cached PHI

### Integration with Existing Systems

**Kiosk duplicate prevention:**
When a patient who completed mobile check-in scans their card at the kiosk, the Check-In Service detects an existing completed check-in for today's appointment and returns `409 already_checked_in`. The kiosk shows the "You're already checked in" message without re-running the full flow.

**Receptionist dashboard:**
Mobile check-in events publish the same events to the Notification Service as kiosk check-ins. The dashboard WebSocket channel receives updates with `channel: "mobile"` and appropriate status badges (Mobile — Complete, Mobile — Partial).

---

## Sequence Diagram

```
Patient              Browser            Check-In Service      Notification Service     Dashboard
  │                    │                      │                       │                    │
  │  open link         │                      │                       │                    │
  ├───────────────────>│  GET /m/{token}      │                       │                    │
  │                    ├─────────────────────>│                       │                    │
  │                    │  200 (token valid)   │                       │                    │
  │                    │<────────────────────│                       │                    │
  │  enter DOB+phone   │                      │                       │                    │
  ├───────────────────>│  POST /verify-identity│                      │                    │
  │                    ├─────────────────────>│                       │                    │
  │                    │  200 + session JWT   │                       │                    │
  │                    │<────────────────────│                       │                    │
  │                    │                      │                       │                    │
  │                    │  GET /patients/{id}  │                       │                    │
  │                    ├─────────────────────>│                       │                    │
  │                    │  200 (patient data)  │                       │                    │
  │                    │<────────────────────│                       │                    │
  │                    │                      │                       │                    │
  │  review steps...   │  PATCH /checkins/.../progress (per step)    │                    │
  │  ─ ─ ─ ─ ─ ─ ─ ─ >│─ ─ ─ ─ ─ ─ ─ ─ ─ >│                       │                    │
  │                    │                      │  publish: mobile_partial                   │
  │                    │                      ├──────────────────────>│                    │
  │                    │                      │                       │  push: partial      │
  │                    │                      │                       ├───────────────────>│
  │                    │                      │                       │                    │
  │  confirm check-in  │                      │                       │                    │
  ├───────────────────>│  POST /checkins/.../complete                 │                    │
  │                    ├─────────────────────>│                       │                    │
  │                    │                      │  publish: mobile_complete                  │
  │                    │                      ├──────────────────────>│                    │
  │                    │                      │                       │  push: complete     │
  │                    │                      │                       ├───────────────────>│
  │                    │                      │                       │                    │
  │                    │  200 (completed)     │                       │                    │
  │                    │<────────────────────│                       │                    │
  │  confirmation screen│                     │                       │                    │
  │<───────────────────│  clear session       │                       │                    │
```

---

## Trade-Offs

| Decision | Trade-off |
|----------|-----------|
| Mobile web, not native app | Lower friction (no download) but limited device integration (push notifications, background updates). Acceptable: we don't need those for check-in. |
| DOB + phone last-4 for verification | Lower security than OTP but higher adoption. Acceptable for a check-in flow (not a portal). |
| Step-by-step persistence | Adds DB writes per step (5 writes per check-in). Acceptable: volume is low (dozens, not thousands). |
| Session timeout at 5 min | May frustrate patients with interruptions. Mitigated by 1-minute warning banner. Required for HIPAA. |

---

## Dependencies

- Check-In Service: must support the `channel: "mobile"` check-in type
- Notification Service: must support SMS/email link delivery + mobile status WebSocket pushes
- Medication confirmation step (Round 6) must be included in the mobile flow from day one
- Multi-location (Round 5): mobile check-in link must encode location for display
