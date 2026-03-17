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
