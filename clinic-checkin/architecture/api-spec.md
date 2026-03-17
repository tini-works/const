# API Specification — Clinic Check-In System

Base URL: `https://api.clinic-checkin.example.com/v1`

All endpoints require HTTPS. All request/response bodies are JSON. Timestamps are ISO 8601 UTC. IDs are UUIDs.

---

## Authentication

| Client | Auth Method | Details |
|--------|------------|---------|
| Kiosk | API key + kiosk ID header | `X-Kiosk-Id: {uuid}`, `Authorization: Bearer {api-key}` |
| Mobile | Token from check-in link | `Authorization: Bearer {mobile-token}` |
| Staff Dashboard | Session cookie or JWT | Standard auth flow, permissions scoped by location |

---

## 1. Patient Identification

### POST /patients/identify

Look up a patient by card scan or name search. Used by kiosk and receptionist.

> **Matches:** Screen [1.1 Kiosk Welcome](../experience/screen-specs.md#11-kiosk-welcome-screen), Screen [1.9 Name Search](../experience/screen-specs.md#19-kiosk-name-search-screen), Screen [2.1 Dashboard Search](../experience/screen-specs.md#21-receptionist-dashboard--main-view); Flows [1. Returning Patient Kiosk](../experience/user-flows.md#1-returning-patient--kiosk-check-in-happy-path), [2. New Patient Kiosk](../experience/user-flows.md#2-new-patient--kiosk-check-in), [3. Card Scan Failures](../experience/user-flows.md#3-card-scan-failures)
> **Proven by:** [TC-101](../quality/test-suites.md#tc-101-returning-patient--happy-path-check-in), [TC-104](../quality/test-suites.md#tc-104-card-scan-failure--fallback-to-name-search), [TC-105](../quality/test-suites.md#tc-105-card-scan--no-matching-record), [TC-902](../quality/test-suites.md#tc-902-patient-search-performance-under-load), [TC-1203](../quality/test-suites.md#tc-1203-rate-limiting-on-patient-search)
> **If this changes:** Screens 1.1, 1.9, 2.1 become suspect. TC-101, TC-104, TC-105, TC-902, TC-1203 need re-verification. Kiosk card scan flow and dashboard search are the primary blast radius.

**Request:**
```json
{
  "method": "card_scan",         // "card_scan" | "name_search"
  "card_id": "ABC123456",        // for card_scan
  "search_query": "Johnson",    // for name_search (min 2 chars)
  "location_id": "uuid"
}
```

**Response (200 — card_scan, single match):**
```json
{
  "patient": {
    "id": "uuid",
    "first_name": "Sarah",
    "date_of_birth": "1982-03-15"
  },
  "has_active_checkin": false,
  "active_checkin_channel": null,
  "appointment": {
    "id": "uuid",
    "appointment_time": "2025-03-17T09:15:00Z",
    "location_id": "uuid",
    "location_name": "Main Street Clinic"
  }
}
```

Minimal PHI returned — just enough for identity confirmation screen. Full record fetched only after patient confirms identity.

**Response (200 — name_search, multiple matches):**
```json
{
  "results": [
    {
      "id": "uuid",
      "first_name": "Sarah",
      "last_name": "Johnson",
      "date_of_birth": "1982-03-15"
    },
    {
      "id": "uuid",
      "first_name": "Samuel",
      "last_name": "Johnson",
      "date_of_birth": "1975-08-22"
    }
  ],
  "total_count": 2
}
```

**Response (404):**
```json
{
  "error": "patient_not_found",
  "message": "No matching patient record found."
}
```

**Response (429):**
```json
{
  "error": "rate_limited",
  "message": "Too many search requests. Please wait.",
  "retry_after_seconds": 5
}
```

---

### POST /patients/verify-identity

Mobile check-in identity verification.

> **Matches:** Screen [3.1 Mobile Identity Verification](../experience/screen-specs.md#31-mobile--link-landing--identity-verification); Flow [6. Mobile Check-In Happy Path](../experience/user-flows.md#6-mobile-check-in--happy-path)
> **Proven by:** [TC-401](../quality/test-suites.md#tc-401-mobile-check-in--happy-path), [TC-402](../quality/test-suites.md#tc-402-mobile--identity-verification-failure), [TC-1204](../quality/test-suites.md#tc-1204-mobile-token-expiry-enforcement)
> **If this changes:** Screen 3.1 and mobile check-in flow become suspect. Token expiry and identity verification tests need re-run.

**Request:**
```json
{
  "token": "mobile-checkin-token-xyz",
  "date_of_birth": "1982-03-15",
  "phone_last4": "5678"
}
```

**Response (200):**
```json
{
  "verified": true,
  "session_token": "jwt-session-token",
  "patient_id": "uuid",
  "appointment": {
    "id": "uuid",
    "appointment_time": "2025-03-17T09:15:00Z",
    "location_id": "uuid",
    "location_name": "Main Street Clinic"
  },
  "session_expires_at": "2025-03-17T09:00:00Z"
}
```

**Response (401):**
```json
{
  "error": "identity_mismatch",
  "message": "The information provided does not match our records.",
  "attempts_remaining": 2
}
```

**Response (410):**
```json
{
  "error": "link_expired",
  "message": "This check-in link has expired."
}
```

**Response (409):**
```json
{
  "error": "already_checked_in",
  "message": "You've already checked in for this appointment.",
  "checked_in_at": "2025-03-17T08:30:00Z",
  "channel": "mobile"
}
```

---

## 2. Patient Record

### GET /patients/{id}

Full patient record. Used after identity confirmation.

> **Matches:** Screens [1.4 Demographics](../experience/screen-specs.md#14-check-in-review-screen--demographics), [1.5 Insurance](../experience/screen-specs.md#15-check-in-review-screen--insurance), [1.6 Allergies](../experience/screen-specs.md#16-check-in-review-screen--allergies), [1.7 Medications](../experience/screen-specs.md#17-check-in-review-screen--medications), [2.2 Patient Detail Panel](../experience/screen-specs.md#22-receptionist--patient-detail-side-panel), [3.2 Mobile Review](../experience/screen-specs.md#32-mobile--review-screens-demographics-insurance-allergies-medications)
> **Proven by:** [TC-101](../quality/test-suites.md#tc-101-returning-patient--happy-path-check-in), [TC-401](../quality/test-suites.md#tc-401-mobile-check-in--happy-path), [TC-501](../quality/test-suites.md#tc-501-cross-location-patient-record--data-consistency)
> **If this changes:** All review screens (1.4-1.7, 2.2, 3.2) become suspect. Response shape changes cascade to kiosk, mobile, and dashboard clients.

**Response (200):**
```json
{
  "id": "uuid",
  "version": 5,
  "first_name": "Sarah",
  "last_name": "Johnson",
  "middle_name": "M",
  "date_of_birth": "1982-03-15",
  "phone": "555-867-5309",
  "email": "sarah@example.com",
  "address": {
    "line1": "123 Oak Street",
    "line2": null,
    "city": "Springfield",
    "state": "IL",
    "zip_code": "62701"
  },
  "patient_confirmed": true,
  "migration_source": null,
  "data_confidence": null,
  "allergies": [
    {
      "id": "uuid",
      "name": "Penicillin",
      "reaction_type": "anaphylaxis",
      "severity": "severe"
    }
  ],
  "medications": [
    {
      "id": "uuid",
      "name": "Lisinopril",
      "dosage": "10mg",
      "frequency": "once_daily"
    },
    {
      "id": "uuid",
      "name": "Metformin",
      "dosage": "500mg",
      "frequency": "twice_daily",
      "source": "migrated_emr",
      "data_confidence": 0.92
    }
  ],
  "insurance": {
    "primary": {
      "id": "uuid",
      "payer_name": "Blue Cross",
      "member_id": "XYZ789012",
      "group_number": "88273",
      "plan_type": "PPO",
      "effective_date": "2025-01-01",
      "card_front_url": "/storage/insurance/uuid-front.jpg",
      "card_back_url": "/storage/insurance/uuid-back.jpg",
      "ocr_extracted": true,
      "ocr_confidence": {
        "member_id": 0.97,
        "group_number": 0.72,
        "payer_name": 0.99
      }
    },
    "secondary": null
  },
  "visit_history": [
    {
      "date": "2025-02-10",
      "location_name": "Main Street Clinic"
    }
  ]
}
```

---

### PATCH /patients/{id}

Update patient record. Supports partial updates. Enforces optimistic locking.

> **Matches:** Screens [1.4 Demographics Edit](../experience/screen-specs.md#14-check-in-review-screen--demographics), [2.2 Patient Detail Panel](../experience/screen-specs.md#22-receptionist--patient-detail-side-panel); Flow [10. Concurrent Edit Conflict](../experience/user-flows.md#10-concurrent-edit-conflict-bug-003-fix)
> **Proven by:** [TC-102](../quality/test-suites.md#tc-102-returning-patient--edit-demographics-during-check-in), [TC-701](../quality/test-suites.md#tc-701-two-receptionists--conflict-detection), [TC-704](../quality/test-suites.md#tc-704-no-conflict--normal-save), [TC-705](../quality/test-suites.md#tc-705-concurrent-edit--same-field-by-two-users), [TC-1201](../quality/test-suites.md#tc-1201-patch-patientsid--version-required)
> **If this changes:** Conflict resolution flow (Flow 10), version mechanism (ADR-003), and all concurrency tests become suspect. Dashboard conflict banner rendering depends on the 409 response shape.

**Request:**
```json
{
  "version": 5,
  "phone": "555-999-1234",
  "address": {
    "line1": "456 Elm Ave",
    "city": "Springfield",
    "state": "IL",
    "zip_code": "62702"
  }
}
```

The `version` field is **required**. The server checks `WHERE version = 5` on update.

**Response (200):**
```json
{
  "id": "uuid",
  "version": 6,
  "updated_fields": ["phone", "address"],
  "updated_at": "2025-03-17T09:18:00Z"
}
```

**Response (409 — version conflict):**
```json
{
  "error": "version_conflict",
  "message": "This record was modified since you loaded it.",
  "current_version": 6,
  "conflicting_changes": {
    "changed_by": "Maria R.",
    "changed_at": "2025-03-17T09:17:45Z",
    "fields": {
      "insurance.primary.payer_name": {
        "old": "Aetna",
        "new": "Blue Cross"
      }
    }
  }
}
```

The client uses `conflicting_changes` to render the conflict banner.

**Response (422 — validation error):**
```json
{
  "error": "validation_failed",
  "fields": {
    "phone": "Invalid phone number format",
    "address.zip_code": "Invalid zip code"
  }
}
```

---

## 3. Clinical Data

> **Matches:** Screens [1.6 Allergies](../experience/screen-specs.md#16-check-in-review-screen--allergies), [1.7 Medications](../experience/screen-specs.md#17-check-in-review-screen--medications); Stories [US-001](../product/user-stories.md#us-001-pre-populated-check-in-for-returning-patients), [US-005](../product/user-stories.md#us-005-medication-list-confirmation-at-check-in)
> **Proven by:** [TC-601](../quality/test-suites.md#tc-601-medication-step-is-mandatory--cannot-skip) through [TC-606](../quality/test-suites.md#tc-606-medication-step-on-mobile)

### POST /patients/{id}/allergies

```json
{
  "name": "Latex",
  "reaction_type": "rash",
  "severity": "moderate"
}
```

**Response (201):**
```json
{
  "id": "uuid",
  "name": "Latex",
  "reaction_type": "rash",
  "severity": "moderate",
  "created_at": "2025-03-17T09:18:00Z"
}
```

### DELETE /patients/{id}/allergies/{allergy_id}

Soft deletes the allergy record. Returns 204.

### PUT /patients/{id}/allergies/{allergy_id}

Updates an existing allergy. Same shape as POST, returns updated record.

---

### POST /patients/{id}/medications

```json
{
  "name": "Amlodipine",
  "dosage": "5mg",
  "frequency": "once_daily"
}
```

**Response (201):** Same shape as allergies.

### DELETE /patients/{id}/medications/{medication_id}

Soft deletes. Returns 204.

### PUT /patients/{id}/medications/{medication_id}

Updates medication details.

---

## 4. Insurance

### PUT /patients/{id}/insurance/{type}

Update insurance record. `type` is `primary` or `secondary`.

> **Matches:** Screen [1.5 Insurance Review](../experience/screen-specs.md#15-check-in-review-screen--insurance); Story [US-011](../product/user-stories.md#us-011-photo-capture-of-insurance-card)
> **Proven by:** [TC-801](../quality/test-suites.md#tc-801-photo-capture--happy-path-on-kiosk) through [TC-805](../quality/test-suites.md#tc-805-insurance-card-photos-stored-and-accessible-to-staff)

```json
{
  "payer_name": "Blue Cross",
  "member_id": "XYZ789012",
  "group_number": "88273",
  "plan_type": "PPO",
  "effective_date": "2025-01-01"
}
```

### POST /patients/{id}/insurance/{type}/photo

Upload insurance card photos. Multipart form data.

> **Matches:** Screen [1.5a Photo Capture Overlay](../experience/screen-specs.md#15a-insurance-card-photo-capture-overlay); Flow [9. Insurance Card Photo Capture](../experience/user-flows.md#9-insurance-card-photo-capture)
> **Proven by:** [TC-801](../quality/test-suites.md#tc-801-photo-capture--happy-path-on-kiosk), [TC-802](../quality/test-suites.md#tc-802-photo-capture--ocr-failure), [TC-804](../quality/test-suites.md#tc-804-photo-capture-on-mobile)

**Request:**
```
Content-Type: multipart/form-data

card_front: (binary image data)
card_back: (binary image data)
```

**Response (202 — accepted for processing):**
```json
{
  "processing_id": "uuid",
  "status": "processing"
}
```

### GET /patients/{id}/insurance/{type}/photo/status/{processing_id}

Poll for OCR results.

> **Matches:** Screen [1.5 Insurance Review (OCR processing state)](../experience/screen-specs.md#15-check-in-review-screen--insurance); Flow [9. Insurance Card Photo Capture](../experience/user-flows.md#9-insurance-card-photo-capture)
> **Proven by:** [TC-801](../quality/test-suites.md#tc-801-photo-capture--happy-path-on-kiosk), [TC-802](../quality/test-suites.md#tc-802-photo-capture--ocr-failure)

**Response (200 — complete):**
```json
{
  "status": "complete",
  "extracted_fields": {
    "payer_name": { "value": "Blue Cross Blue Shield", "confidence": 0.99 },
    "member_id": { "value": "XYZ789012", "confidence": 0.97 },
    "group_number": { "value": "88273", "confidence": 0.72 },
    "plan_type": { "value": "PPO", "confidence": 0.85 },
    "effective_date": { "value": "2025-01-01", "confidence": 0.91 }
  },
  "card_front_url": "/storage/insurance/uuid-front.jpg",
  "card_back_url": "/storage/insurance/uuid-back.jpg"
}
```

**Response (200 — still processing):**
```json
{
  "status": "processing",
  "estimated_seconds_remaining": 3
}
```

**Response (200 — failed):**
```json
{
  "status": "failed",
  "error": "Image quality too low for extraction.",
  "card_front_url": "/storage/insurance/uuid-front.jpg",
  "card_back_url": "/storage/insurance/uuid-back.jpg"
}
```

---

## 5. Check-In Flow

### POST /checkins

Start a new check-in.

> **Matches:** Screen [1.3 Identity Confirmation](../experience/screen-specs.md#13-patient-identification-confirmation-screen); Flow [1. Returning Patient Kiosk](../experience/user-flows.md#1-returning-patient--kiosk-check-in-happy-path), Flow [8. Mobile to Kiosk Duplicate Prevention](../experience/user-flows.md#8-mobile-check-in--kiosk-arrival-duplicate-prevention)
> **Proven by:** [TC-101](../quality/test-suites.md#tc-101-returning-patient--happy-path-check-in), [TC-405](../quality/test-suites.md#tc-405-mobile-then-kiosk--duplicate-prevention), [TC-901](../quality/test-suites.md#tc-901-50-concurrent-kiosk-check-ins--response-time)
> **If this changes:** Duplicate prevention logic (Flow 8), dashboard queue sync (WebSocket push), and check-in completion flow all become suspect. The 409 "already checked in" response shape is consumed by both kiosk and mobile clients.

```json
{
  "appointment_id": "uuid",
  "patient_id": "uuid",
  "channel": "kiosk",
  "kiosk_id": "uuid",
  "location_id": "uuid"
}
```

**Response (201):**
```json
{
  "check_in_id": "uuid",
  "status": "in_progress",
  "current_step": 1
}
```

**Response (409 — already checked in):**
```json
{
  "error": "already_checked_in",
  "message": "Patient has already checked in for this appointment.",
  "existing_check_in": {
    "channel": "mobile",
    "completed_at": "2025-03-17T08:30:00Z"
  }
}
```

---

### PATCH /checkins/{id}/progress

Update check-in progress (step completed).

> **Matches:** Screens [1.4](../experience/screen-specs.md#14-check-in-review-screen--demographics)–[1.7](../experience/screen-specs.md#17-check-in-review-screen--medications), [3.2 Mobile Review](../experience/screen-specs.md#32-mobile--review-screens-demographics-insurance-allergies-medications); Flow [7. Mobile Partial Completion](../experience/user-flows.md#7-mobile-check-in--partial-completion)
> **Proven by:** [TC-404](../quality/test-suites.md#tc-404-mobile--partial-completion-and-resume)

```json
{
  "current_step": 3,
  "step_data": {
    "step_name": "allergies",
    "action": "confirmed_unchanged"
  }
}
```

**Response (200):**
```json
{
  "check_in_id": "uuid",
  "current_step": 3,
  "status": "in_progress"
}
```

---

### POST /checkins/{id}/complete

Finalize the check-in. Creates the medication confirmation audit record.

> **Matches:** Screen [1.8 Confirmation](../experience/screen-specs.md#18-check-in-confirmation-screen), Screen [3.3 Mobile Confirmation](../experience/screen-specs.md#33-mobile--confirmation-screen); Flows [1. Returning Patient Kiosk](../experience/user-flows.md#1-returning-patient--kiosk-check-in-happy-path), [5. Kiosk-to-Receptionist Sync](../experience/user-flows.md#5-kiosk-to-receptionist-sync-bug-001-fix), [6. Mobile Check-In](../experience/user-flows.md#6-mobile-check-in--happy-path)
> **Proven by:** [TC-101](../quality/test-suites.md#tc-101-returning-patient--happy-path-check-in), [TC-201](../quality/test-suites.md#tc-201-successful-sync--green-checkmark), [TC-202](../quality/test-suites.md#tc-202-sync-timeout--yellow-warning-on-kiosk), [TC-602](../quality/test-suites.md#tc-602-medication-confirmation--confirmed-unchanged), [TC-1202](../quality/test-suites.md#tc-1202-post-checkinsidcomplete--medication-confirmation-required)
> **If this changes:** Medication confirmation audit trail (ADR-004), kiosk sync ack mechanism (ADR-001), WebSocket push, and both confirmation screens become suspect. This is the highest-impact endpoint — it writes to `check_ins`, `medication_confirmations`, and triggers the dashboard sync.

```json
{
  "medication_confirmation": {
    "type": "confirmed_unchanged",
    "medication_snapshot": [
      { "name": "Lisinopril", "dosage": "10mg", "frequency": "once_daily" },
      { "name": "Metformin", "dosage": "500mg", "frequency": "twice_daily" }
    ]
  }
}
```

**Response (200 — sync confirmed):**
```json
{
  "check_in_id": "uuid",
  "status": "completed",
  "sync_status": "confirmed",
  "completed_at": "2025-03-17T09:20:00Z",
  "synced_at": "2025-03-17T09:20:02Z"
}
```

**Response (200 — sync timeout):**
```json
{
  "check_in_id": "uuid",
  "status": "completed",
  "sync_status": "timeout",
  "completed_at": "2025-03-17T09:20:00Z",
  "synced_at": null,
  "message": "Check-in saved but receptionist notification is delayed."
}
```

**Response (500 — save failed):**
```json
{
  "error": "save_failed",
  "message": "Unable to save check-in. Please try again."
}
```

---

## 6. Mobile Check-In Links

### POST /mobile-checkin/send-link

Trigger sending a check-in link to a patient. Called by the scheduler or manually by staff.

> **Matches:** Flow [6. Mobile Check-In Happy Path](../experience/user-flows.md#6-mobile-check-in--happy-path); Story [US-007](../product/user-stories.md#us-007-pre-visit-check-in-from-personal-device)
> **Proven by:** [TC-401](../quality/test-suites.md#tc-401-mobile-check-in--happy-path)

```json
{
  "appointment_id": "uuid",
  "delivery_method": "sms",
  "phone": "555-867-5309"
}
```

**Response (201):**
```json
{
  "mobile_token": "token-xyz",
  "expires_at": "2025-03-17T09:15:00Z",
  "delivery_status": "sent"
}
```

### GET /mobile-checkin/{token}/status

Check if a mobile check-in link is valid.

> **Matches:** Screen [3.1 Mobile Link Landing](../experience/screen-specs.md#31-mobile--link-landing--identity-verification)
> **Proven by:** [TC-403](../quality/test-suites.md#tc-403-mobile--expired-link), [TC-407](../quality/test-suites.md#tc-407-mobile--already-checked-in-via-mobile), [TC-1204](../quality/test-suites.md#tc-1204-mobile-token-expiry-enforcement)

**Response (200):**
```json
{
  "valid": true,
  "appointment": {
    "date": "2025-03-17",
    "time": "09:15",
    "location_name": "Main Street Clinic"
  },
  "check_in_status": "not_started"
}
```

---

## 7. Receptionist Dashboard

### GET /dashboard/queue

Get today's appointment queue for a location.

> **Matches:** Screen [2.1 Dashboard Main View](../experience/screen-specs.md#21-receptionist-dashboard--main-view); Stories [US-002](../product/user-stories.md#us-002-receptionist-sees-confirmed-check-in-data), [US-008](../product/user-stories.md#us-008-receptionist-visibility-of-mobile-check-ins)
> **Proven by:** [TC-201](../quality/test-suites.md#tc-201-successful-sync--green-checkmark), [TC-204](../quality/test-suites.md#tc-204-dashboard-real-time-update--websocket-push), [TC-503](../quality/test-suites.md#tc-503-receptionist--location-filter-and-search), [TC-903](../quality/test-suites.md#tc-903-dashboard-stability-during-peak)

**Query params:**
- `location_id` (required, or `all` for cross-location)
- `date` (optional, defaults to today)
- `page` (optional, default 1)
- `per_page` (optional, default 50)

**Response (200):**
```json
{
  "location": {
    "id": "uuid",
    "name": "Main Street Clinic"
  },
  "date": "2025-03-17",
  "appointments": [
    {
      "id": "uuid",
      "time": "09:15",
      "patient": {
        "id": "uuid",
        "name": "Johnson, Sarah"
      },
      "check_in_status": "checked_in",
      "check_in_channel": "kiosk",
      "check_in_time": "2025-03-17T09:17:00Z",
      "sync_status": "confirmed"
    },
    {
      "id": "uuid",
      "time": "09:30",
      "patient": {
        "id": "uuid",
        "name": "Williams, James"
      },
      "check_in_status": "mobile_partial",
      "check_in_channel": "mobile",
      "check_in_time": "2025-03-17T08:45:00Z",
      "current_step": 2,
      "sync_status": null
    }
  ],
  "summary": {
    "total": 18,
    "checked_in": 12,
    "pending": 6
  },
  "page": 1,
  "total_pages": 1
}
```

### GET /dashboard/search

Search patients across all locations.

> **Matches:** Screen [2.1 Dashboard Search](../experience/screen-specs.md#21-receptionist-dashboard--main-view); Flow [11. Multi-Location Check-In](../experience/user-flows.md#11-multi-location-check-in)
> **Proven by:** [TC-503](../quality/test-suites.md#tc-503-receptionist--location-filter-and-search), [TC-902](../quality/test-suites.md#tc-902-patient-search-performance-under-load)

**Query params:**
- `q` (required, min 2 chars)

**Response (200):**
```json
{
  "results": [
    {
      "id": "uuid",
      "name": "Johnson, Sarah",
      "date_of_birth": "1982-03-15",
      "phone": "555-867-5309",
      "next_appointment": {
        "date": "2025-03-17",
        "time": "09:15",
        "location_name": "Main Street Clinic"
      }
    }
  ],
  "total_count": 1
}
```

---

## 8. Real-Time Updates

### WebSocket: /ws/dashboard/{location_id}

Server pushes check-in status updates to connected receptionist dashboards.

> **Matches:** Screen [2.1 Dashboard (real-time updates)](../experience/screen-specs.md#21-receptionist-dashboard--main-view); Flow [5. Kiosk-to-Receptionist Sync](../experience/user-flows.md#5-kiosk-to-receptionist-sync-bug-001-fix); Stories [US-002](../product/user-stories.md#us-002-receptionist-sees-confirmed-check-in-data), [BUG-001](../product/user-stories.md#bug-001-kiosk-confirmation-not-syncing-to-receptionist-screen)
> **Proven by:** [TC-201](../quality/test-suites.md#tc-201-successful-sync--green-checkmark), [TC-202](../quality/test-suites.md#tc-202-sync-timeout--yellow-warning-on-kiosk), [TC-203](../quality/test-suites.md#tc-203-sync-failure--dashboard-retry), [TC-204](../quality/test-suites.md#tc-204-dashboard-real-time-update--websocket-push)
> **Monitored by:** [WebSocket Connections per location](../operations/monitoring-alerting.md#p1----notify-during-business-hours), [Sync Failure Rate](../operations/monitoring-alerting.md#4-check-in-flow-dashboard)
> **If this changes:** ADR-001 (ack mechanism), kiosk confirmation screen (green/yellow checkmark), polling fallback, and all sync tests become suspect. Message format changes break both the dashboard client and the kiosk completion flow.

**Message format (server -> client):**
```json
{
  "type": "checkin_update",
  "appointment_id": "uuid",
  "patient_id": "uuid",
  "check_in_status": "checked_in",
  "channel": "kiosk",
  "timestamp": "2025-03-17T09:17:00Z"
}
```

**Acknowledgment (client -> server):**
```json
{
  "type": "ack",
  "appointment_id": "uuid",
  "received_at": "2025-03-17T09:17:01Z"
}
```

This ack is the "end-to-end sync confirmation" that triggers the green checkmark on the kiosk.

**Fallback:** If WebSocket connection drops, the dashboard falls back to polling `GET /dashboard/queue` every 5 seconds. WebSocket reconnection is attempted automatically with exponential backoff.

**Connection heartbeat:** Server sends ping every 30 seconds. Client responds with pong. If no pong received within 10 seconds, server considers connection dead and cleans up.

---

## 9. Migration (Round 10)

> **Matches:** Screens [4.1 Migration Dashboard](../experience/screen-specs.md#41-admin--migration-dashboard), [4.2 Duplicate Review](../experience/screen-specs.md#42-admin--duplicate-review-screen); Flows [13. First Visit After Migration](../experience/user-flows.md#13-riverside-migration--first-visit-after-migration), [14. Duplicate Detection Staff Review](../experience/user-flows.md#14-duplicate-detection--staff-review-riverside); Stories [US-012](../product/user-stories.md#us-012-patient-data-migration-from-riverside), [US-013](../product/user-stories.md#us-013-duplicate-patient-detection-and-merge); Epic [E5](../product/epics.md#e5-riverside-practice-acquisition)
> **Proven by:** [TC-1001](../quality/test-suites.md#tc-1001-emr-import--valid-records) through [TC-1011](../quality/test-suites.md#tc-1011-no-auto-merge-verification)
> **Monitored by:** [Migration Dashboard](../operations/monitoring-alerting.md#5-migration-dashboard-temporary----during-riverside-migration)
> **If this changes:** ADR-008 (dedup algorithm), ADR-010 (pipeline architecture), rollback mechanism, and duplicate review screens become suspect. Schema mapping changes affect the `patients` table shape — cascades to `GET /patients/{id}` and all downstream consumers.

### POST /migration/batches

Create a new migration batch.

```json
{
  "name": "Riverside EMR Import - Batch 1",
  "source_system": "riverside_emr"
}
```

### POST /migration/batches/{batch_id}/import

Upload records for import. Accepts array of source records.

```json
{
  "records": [
    {
      "source_id": "RSV-001",
      "data": {
        "first_name": "Sarah",
        "last_name": "Johnson",
        "dob": "03/15/1982",
        "phone": "(555) 867-5309",
        "insurance_payer": "Aetna",
        "insurance_id": "ABC123",
        "allergies": ["Penicillin"],
        "medications": [
          { "name": "Metformin", "dose": "500mg", "freq": "BID" }
        ]
      }
    }
  ]
}
```

**Response (202 — accepted for processing):**
```json
{
  "batch_id": "uuid",
  "records_accepted": 100,
  "processing_status": "in_progress"
}
```

### GET /migration/batches/{batch_id}

Get batch status and summary.

**Response (200):**
```json
{
  "id": "uuid",
  "name": "Riverside EMR Import - Batch 1",
  "status": "completed_with_errors",
  "total_records": 500,
  "imported": 420,
  "flagged": 45,
  "errors": 12,
  "duplicates_found": 23,
  "duplicates_resolved": 18,
  "started_at": "2025-03-17T10:00:00Z",
  "completed_at": "2025-03-17T10:45:00Z"
}
```

### GET /migration/records

List migration records with filters.

**Query params:**
- `batch_id` (required)
- `status` (optional: `needs_review`, `potential_duplicate`, `import_error`, etc.)
- `page`, `per_page`

### GET /migration/duplicates/{id}

Get duplicate comparison for staff review.

**Response (200):**
```json
{
  "id": "uuid",
  "confidence_score": 0.92,
  "match_reasons": ["name_dob_match", "phone_match"],
  "our_record": {
    "id": "uuid",
    "first_name": "Sarah",
    "last_name": "Johnson",
    "middle_name": "M",
    "date_of_birth": "1982-03-15",
    "phone": "555-867-5309",
    "insurance": { "payer_name": "Blue Cross", "member_id": "XYZ789" },
    "allergies": [{ "name": "Penicillin", "severity": "severe" }],
    "medications": [{ "name": "Lisinopril", "dosage": "10mg" }]
  },
  "riverside_record": {
    "source_id": "RSV-001",
    "first_name": "Sarah",
    "last_name": "Johnson",
    "middle_name": null,
    "date_of_birth": "1982-03-15",
    "phone": "555-867-5309",
    "insurance": { "payer_name": "Aetna", "member_id": "ABC123" },
    "allergies": [{ "name": "Penicillin", "severity": "severe" }],
    "medications": [{ "name": "Metformin", "dosage": "500mg" }]
  },
  "field_comparison": {
    "first_name": "match",
    "last_name": "match",
    "middle_name": "differs",
    "date_of_birth": "match",
    "phone": "match",
    "insurance.payer_name": "differs",
    "insurance.member_id": "differs"
  }
}
```

### POST /migration/duplicates/{id}/resolve

Resolve a duplicate.

```json
{
  "resolution": "merged",
  "merge_decisions": {
    "middle_name": "keep_ours",
    "insurance": "keep_theirs",
    "medications": "merge_both"
  }
}
```

**Response (200):**
```json
{
  "resolution": "merged",
  "merged_patient_id": "uuid",
  "resolved_at": "2025-03-17T11:00:00Z"
}
```

### POST /migration/batches/{batch_id}/rollback

Rollback an entire batch import.

**Response (200):**
```json
{
  "batch_id": "uuid",
  "status": "rolled_back",
  "records_rolled_back": 420,
  "rolled_back_at": "2025-03-17T12:00:00Z"
}
```

---

## Error Format (Global)

All errors follow the same shape:

```json
{
  "error": "error_code",
  "message": "Human-readable description",
  "details": {}
}
```

**Standard HTTP status codes:**
| Code | Usage |
|------|-------|
| 200 | Success |
| 201 | Created |
| 202 | Accepted (async processing) |
| 204 | Deleted (no content) |
| 400 | Bad request / malformed input |
| 401 | Authentication failed |
| 403 | Insufficient permissions |
| 404 | Resource not found |
| 409 | Conflict (version mismatch, duplicate check-in) |
| 410 | Gone (expired link) |
| 422 | Validation failed |
| 429 | Rate limited |
| 500 | Server error |
