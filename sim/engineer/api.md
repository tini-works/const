# API Contracts — Complete (Rounds 1-10)

Every endpoint the system exposes. Organized by service. Evolution from api-s01.md marked with story IDs.

---

## Search Service

### `GET /api/patients/search`

Standard patient lookup (S1). Prefix matching, fast. *Unchanged from S-01, response extended in S-05 and S-10.*

**Auth:** Receptionist session.

**Query params:**
| Param | Type | Required | Notes |
|-------|------|----------|-------|
| q | string | Yes | Min 2 chars. Matched against name prefix and DOB. |
| limit | integer | No | Default 10. Max 25. |
| **location_id** | UUID | No | **S-05.** Filter by location. Default: all locations. |

**Response `200 OK`:**
```json
{
  "results": [
    {
      "id": "uuid",
      "first_name": "Jane",
      "last_name": "Doe",
      "dob": "1985-03-14",
      "last_visit_date": "2025-11-02",
      "last_visit_location": "Downtown Clinic",
      "photo_url": "https://...",
      "has_active_checkin": false,
      "source_system": "native",
      "is_imported": false
    }
  ],
  "total": 3
}
```

**S-05 change:** `last_visit_location` now populated from `visits` join with `locations`.
**S-10 change:** `source_system` and `is_imported` fields added. `is_imported = true` for Riverside patients within 6 months of import.

**Performance target (S-09):** <200ms at p95 under 30 concurrent sessions. Search index read replica used during peak.

---

### `GET /api/patients/search/fuzzy`

Assisted search (S1b). *Unchanged from S-01, response extended in S-10.*

**Auth:** Receptionist session.

**Query params:** Same as S-01 (name, dob, phone, email, insurance_id, limit). At least one required.

**Response `200 OK`:**
```json
{
  "results": [
    {
      "id": "uuid",
      "first_name": "Jane",
      "last_name": "Doe",
      "dob": "1985-03-14",
      "last_visit_date": "2025-11-02",
      "last_visit_location": "Main Street",
      "photo_url": null,
      "confidence": 0.82,
      "matched_on": ["name", "phone"],
      "source_system": "riverside_ehr",
      "source_id": "RV-12345"
    }
  ],
  "total": 1
}
```

**S-10 change:** `source_system` and `source_id` added. During migration period, fuzzy search is critical for Riverside patients whose data may differ from verbal.

---

## Patient Service

### `GET /api/patients/{id}`

Full patient record with data sections and staleness. *Modified in S-05, S-06, S-10.*

**Auth:** Receptionist session.

**Response `200 OK`:**
```json
{
  "id": "uuid",
  "first_name": "Jane",
  "last_name": "Doe",
  "dob": "1985-03-14",
  "photo_url": "https://...",
  "phone": "555-0123",
  "email": "jane@example.com",
  "created_at": "2024-01-15T10:00:00Z",
  "merge_flag": null,
  "source_system": "native",
  "imported_at": null,
  "provenance_note": null,
  "last_visit": {
    "date": "2025-11-02",
    "location": "Downtown Clinic",
    "physician": "Dr. Smith"
  },
  "data_sections": [
    {
      "category": "address",
      "value": {"line1": "123 Main St", "city": "Springfield", "state": "IL", "zip": "62701"},
      "last_confirmed": "2025-01-10T09:00:00Z",
      "is_stale": true,
      "freshness_threshold_days": 365
    },
    {
      "category": "insurance",
      "value": {"provider": "BlueCross", "policy_number": "BC-12345", "group_number": "G-100"},
      "last_confirmed": "2025-09-15T14:00:00Z",
      "is_stale": true,
      "freshness_threshold_days": 180
    },
    {
      "category": "allergies",
      "value": {"items": [{"name": "Penicillin", "severity": "moderate", "reaction": "rash"}]},
      "last_confirmed": "2025-11-02T10:30:00Z",
      "is_stale": false,
      "freshness_threshold_days": null
    },
    {
      "category": "medications",
      "value": {"items": [{"drug_name": "Lisinopril", "dosage": "10mg", "frequency": "once daily", "prescriber": "Dr. Smith"}], "confirmed_empty": false},
      "last_confirmed": "2025-11-02T10:30:00Z",
      "is_stale": true,
      "freshness_threshold_days": 0,
      "required_every_visit": true
    }
  ],
  "has_active_checkin": false,
  "active_checkin_info": null
}
```

**S-06 addition:** `medications` category always present. `freshness_threshold_days: 0` means always stale. `required_every_visit: true` tells client this section cannot be skipped.

**S-07 addition:** When `has_active_checkin` is true, `active_checkin_info` is populated:
```json
{
  "active_checkin_info": {
    "session_id": "uuid",
    "initiated_by": "Receptionist Name",
    "initiated_at": "2026-03-16T15:00:00Z",
    "location": "Main Street Clinic",
    "status": "in_progress",
    "channel": "kiosk"
  }
}
```

**S-10 addition:** For imported patients, `provenance_note` is populated:
```json
{
  "provenance_note": "Patient data imported from Riverside Family Practice on 2026-02-15. Patient has not yet confirmed this data at our clinic."
}
```

---

### `PATCH /api/patients/{id}`

Receptionist direct edit. *Unchanged from S-01.*

---

### `POST /api/patients/bulk-import` (NEW — S-10)

Bulk import endpoint for migration pipeline.

**Auth:** Admin session.

**Request body:**
```json
{
  "batch_id": "uuid",
  "records": [
    {
      "source_id": "RV-12345",
      "source_system": "riverside_ehr",
      "first_name": "Maria",
      "last_name": "Rodriguez",
      "dob": "1972-08-20",
      "phone": "555-0456",
      "data_sections": [
        {"category": "address", "value": {"line1": "456 Oak Ave", "city": "Springfield"}},
        {"category": "insurance", "value": {"provider": "UnitedHealth", "policy_number": "UH-67890"}},
        {"category": "medications", "value": {"items": [{"drug_name": "Metformin", "dosage": "500mg", "frequency": "twice daily"}]}}
      ]
    }
  ]
}
```

**Response `200 OK`:**
```json
{
  "processed": 1,
  "results": [
    {
      "source_id": "RV-12345",
      "status": "imported",
      "patient_id": "uuid",
      "duplicate_check": {"confidence": 0.0, "candidate_id": null}
    }
  ]
}
```

**Response `200 OK` (with duplicates):**
```json
{
  "processed": 1,
  "results": [
    {
      "source_id": "RV-12345",
      "status": "duplicate_flagged",
      "patient_id": null,
      "duplicate_check": {"confidence": 0.85, "candidate_id": "uuid-of-existing-patient"}
    }
  ]
}
```

**Idempotent:** Re-importing the same `source_id` + `source_system` is a no-op. Returns `"status": "already_imported"`.

**Rate limit:** 10 records per request. 10 requests per second. Enforced by Migration Service, not API Gateway.

---

## Check-in Service

### `POST /api/checkins`

Create a check-in session. *Modified in S-03, S-05, S-07.*

**Auth:** Receptionist session (kiosk) or System (mobile pre-check-in from Notification Service).

**Request body:**
```json
{
  "patient_id": "uuid",
  "location_id": "uuid",
  "channel": "kiosk",
  "appointment_id": null
}
```

**S-03 change:** `channel` field ("kiosk" or "mobile"). `appointment_id` for mobile pre-check-in sessions.
**S-05 change:** `location_id` required. Determines which location this check-in belongs to.

**Response `201 Created`:**
```json
{
  "id": "uuid",
  "patient_id": "uuid",
  "location_id": "uuid",
  "channel": "kiosk",
  "status": "pending",
  "access_token": "a1b2c3d4...",
  "access_url": "/checkin/a1b2c3d4...",
  "expires_at": "2026-03-16T15:30:00Z",
  "version": 1,
  "sections": [
    {"id": "uuid", "category": "address", "status": "pending", "has_existing_data": true, "is_stale": true},
    {"id": "uuid", "category": "insurance", "status": "pending", "has_existing_data": true, "is_stale": true},
    {"id": "uuid", "category": "allergies", "status": "pending", "has_existing_data": true, "is_stale": false},
    {"id": "uuid", "category": "medications", "status": "pending", "has_existing_data": true, "is_stale": true, "required_every_visit": true}
  ]
}
```

**Response `409 Conflict`:**
```json
{
  "error": "active_checkin_exists",
  "existing_session": {
    "id": "uuid",
    "initiated_by": "Receptionist Name",
    "initiated_at": "2026-03-16T15:00:00Z",
    "location": "Main Street Clinic",
    "status": "in_progress",
    "channel": "kiosk"
  }
}
```

**S-06 change:** Medications section always included with `required_every_visit: true` and `is_stale: true` (always).
**S-07 change:** `version: 1` in response. Used for optimistic locking on finalization.

---

### `GET /api/checkins/{id}`

Receptionist view of check-in session. *Modified in S-06, S-07, S-08.*

**Auth:** Receptionist session.

**Response `200 OK`:**
```json
{
  "id": "uuid",
  "patient_id": "uuid",
  "patient_name": "Jane Doe",
  "location_id": "uuid",
  "location_name": "Main Street Clinic",
  "channel": "kiosk",
  "status": "in_progress",
  "version": 3,
  "created_at": "2026-03-16T15:00:00Z",
  "last_activity_at": "2026-03-16T15:03:22Z",
  "expires_at": "2026-03-16T15:30:00Z",
  "sections": [
    {
      "id": "uuid",
      "category": "address",
      "status": "confirmed",
      "original_value": {"line1": "123 Main St"},
      "confirmed_value": null,
      "acted_at": "2026-03-16T15:01:10Z"
    },
    {
      "id": "uuid",
      "category": "medications",
      "status": "updated",
      "original_value": {"items": [{"drug_name": "Lisinopril", "dosage": "10mg", "frequency": "once daily"}]},
      "confirmed_value": {"items": [{"drug_name": "Lisinopril", "dosage": "20mg", "frequency": "once daily"}], "confirmed_empty": false},
      "acted_at": "2026-03-16T15:03:22Z",
      "required_every_visit": true
    },
    {
      "id": "uuid",
      "category": "insurance",
      "status": "updated",
      "original_value": {"provider": "BlueCross", "policy_number": "BC-12345"},
      "confirmed_value": {"provider": "Aetna", "policy_number": "AE-99999"},
      "card_images": [
        {"id": "uuid", "type": "insurance_card_front", "thumbnail_url": "https://signed-url...", "ocr_status": "completed"}
      ],
      "acted_at": "2026-03-16T15:02:45Z"
    }
  ]
}
```

**S-06 change:** Medications section with `required_every_visit` flag.
**S-08 change:** `card_images` array on insurance section when patient used photo upload. Includes signed thumbnail URL for receptionist view.

---

### `GET /api/checkins/{id}/poll` (NEW — S-02)

Polling fallback for receptionist when WebSocket is down.

**Auth:** Receptionist session.

**Response `200 OK`:** Same shape as `GET /api/checkins/{id}`, plus:
```json
{
  "...same as above...",
  "poll_interval_ms": 10000,
  "connection_health": "polling"
}
```

Returns current session state. Client polls every `poll_interval_ms`. Server may adjust interval based on load (S-09: increase to 15000ms during peak).

---

### `GET /api/checkins/token/{token}`

Patient view of check-in session. *Modified in S-02, S-06, S-08, S-10.*

**Auth:** Bearer token.

**Response `200 OK`:**
```json
{
  "session_id": "uuid",
  "patient_first_name": "Jane",
  "channel": "kiosk",
  "provenance_note": null,
  "sections": {
    "existing": [
      {
        "id": "uuid",
        "category": "address",
        "status": "pending",
        "value": {"line1": "123 Main St", "city": "Springfield"},
        "is_stale": true,
        "last_confirmed_display": "January 2025"
      },
      {
        "id": "uuid",
        "category": "insurance",
        "status": "pending",
        "value": {"provider": "BlueCross", "policy_number": "BC-12345"},
        "is_stale": true,
        "last_confirmed_display": "September 2025",
        "supports_photo_capture": true
      },
      {
        "id": "uuid",
        "category": "allergies",
        "status": "pending",
        "value": {"items": [{"name": "Penicillin"}]},
        "is_stale": false,
        "last_confirmed_display": "November 2025"
      },
      {
        "id": "uuid",
        "category": "medications",
        "status": "pending",
        "value": {"items": [{"drug_name": "Lisinopril", "dosage": "10mg", "frequency": "once daily"}], "confirmed_empty": false},
        "is_stale": true,
        "last_confirmed_display": "November 2025",
        "required_every_visit": true,
        "confirmation_label": "I confirm this medication list is current"
      }
    ],
    "missing": []
  },
  "can_complete": false
}
```

**S-06 change:** Medications section always in `existing` (unless patient has never had medications data). `required_every_visit: true`. `confirmation_label` provides the exact button text.
**S-08 change:** `supports_photo_capture: true` on insurance section tells client to offer camera option.
**S-10 change:** `provenance_note` for imported patients: "Your information was transferred from Riverside Family Practice."

---

### `PATCH /api/checkins/token/{token}/sections/{sectionId}`

Patient confirms, updates, or fills a section. *Modified in S-06.*

**Auth:** Bearer token.

**Request body — confirm (medications, S-06):**
```json
{
  "action": "confirm_medications",
  "value": {"items": [...current list...], "confirmed_empty": false}
}
```

**S-06 change:** For medications, the `confirm_medications` action requires the full current medication list in the request body. This ensures the patient explicitly reviewed the list, not just tapped a button. The server compares the submitted list against the original to detect any discrepancies.

For medications with no items:
```json
{
  "action": "confirm_medications",
  "value": {"items": [], "confirmed_empty": true}
}
```

All other actions (confirm, update, fill) unchanged from S-01.

**Response:** Unchanged.

---

### `POST /api/checkins/token/{token}/sections/{sectionId}/upload` (NEW — S-08)

Patient uploads insurance card photo.

**Auth:** Bearer token.

**Request:** `multipart/form-data`
| Field | Type | Required | Notes |
|-------|------|----------|-------|
| image | file | Yes | JPEG or PNG. Max 10MB. |
| document_type | string | Yes | "insurance_card_front" or "insurance_card_back" |

**Response `202 Accepted`:**
```json
{
  "upload_id": "uuid",
  "ocr_status": "processing",
  "poll_url": "/api/checkins/token/{token}/sections/{sectionId}/ocr/{upload_id}"
}
```

**Side effects:**
- Image stored in Object Storage (encrypted, PHI).
- OCR pipeline triggered asynchronously.
- `document_uploads` record created.

---

### `GET /api/checkins/token/{token}/sections/{sectionId}/ocr/{uploadId}` (NEW — S-08)

Poll for OCR result.

**Auth:** Bearer token.

**Response `200 OK` (processing):**
```json
{
  "ocr_status": "processing",
  "estimated_seconds": 3
}
```

**Response `200 OK` (completed):**
```json
{
  "ocr_status": "completed",
  "extracted_fields": {
    "provider": {"value": "Aetna", "confidence": 0.95},
    "policy_number": {"value": "AE-99999", "confidence": 0.88},
    "group_number": {"value": "G-200", "confidence": 0.72},
    "member_name": {"value": "Jane Doe", "confidence": 0.91}
  },
  "needs_verification": true
}
```

**Response `200 OK` (failed):**
```json
{
  "ocr_status": "failed",
  "reason": "image_quality",
  "message": "We couldn't read your card clearly. Please try again or enter manually."
}
```

Patient verifies/corrects extracted fields, then submits as a normal section update (`PATCH` with `action: "update"`).

---

### `POST /api/checkins/token/{token}/complete`

Patient taps "All Confirmed". *Modified in S-06.*

**Auth:** Bearer token.

**Response `200 OK`:** Unchanged.

**S-06 change:** Server validates that medications section has been explicitly confirmed (status = "confirmed" with `action` = "confirm_medications"). If medications are still pending, returns `400` with:
```json
{
  "error": "medications_not_confirmed",
  "message": "Please confirm your medication list before completing check-in."
}
```

---

### `POST /api/checkins/{id}/finalize`

Receptionist finalizes check-in. *Modified in S-07.*

**Auth:** Receptionist session.

**Request body (S-07):**
```json
{
  "expected_version": 5
}
```

**S-07 change:** `expected_version` is required. Prevents lost-update race condition. If the session's current version != expected_version, finalization is rejected.

**Response `200 OK`:** Unchanged from S-01.

**Response `409 Conflict` (NEW — S-07):**
```json
{
  "error": "finalization_conflict",
  "message": "Another session was finalized first.",
  "conflict": {
    "winning_session": {
      "id": "uuid",
      "finalized_by": "Receptionist A",
      "finalized_at": "2026-03-16T15:10:00Z",
      "changes_applied": [
        {"category": "insurance", "new_value": {"provider": "Aetna"}}
      ]
    },
    "your_session": {
      "id": "uuid",
      "changes_not_applied": [
        {"category": "address", "new_value": {"line1": "456 Oak Ave"}}
      ]
    }
  }
}
```

**Response `412 Precondition Failed` (NEW — S-07):**
```json
{
  "error": "version_mismatch",
  "message": "Session state has changed. Please refresh and try again.",
  "current_version": 6,
  "expected_version": 5
}
```

**Side effects (updated for S-07):**
- **Within a single DB transaction (BOX-O1):**
  - For each section: patient_data is updated or inserted
  - Audit rows created
  - Session status -> "finalized", finalized_at -> now, finalized_by -> receptionist
  - Version incremented
  - Access token invalidated
- **After transaction commits:**
  - `patient.updated` event emitted
  - `checkin.finalized` event emitted
  - WebSocket channel closed

---

### `POST /api/checkins/{id}/reinitiate` (Gap G-02 resolved)

Re-initiate a timed-out or paused session. *Was missing in S-01, identified by QA gap G-02.*

**Auth:** Receptionist session.

**Request body:** None.

**Response `200 OK`:**
```json
{
  "id": "uuid",
  "access_token": "new_token_value",
  "access_url": "/checkin/new_token_value",
  "expires_at": "2026-03-16T16:00:00Z",
  "version": 4,
  "sections": [
    {"id": "uuid", "category": "address", "status": "confirmed", "acted_at": "..."},
    {"id": "uuid", "category": "insurance", "status": "pending", "acted_at": null},
    {"id": "uuid", "category": "allergies", "status": "pending", "acted_at": null},
    {"id": "uuid", "category": "medications", "status": "pending", "acted_at": null}
  ],
  "preserved_progress": true
}
```

**Response `400`:** Session is in terminal state (finalized, cancelled).
**Response `404`:** Session not found.

**Side effects:**
- Old access token invalidated.
- New access token generated.
- `expires_at` reset to now + 30 minutes.
- `last_activity_at` reset to now.
- `status` -> "pending" (if was "in_progress" or timed out).
- `version` incremented.
- Previously confirmed/updated sections retain their state.
- Pending sections remain pending.

---

### `POST /api/checkins/{id}/resolve-conflict` (NEW — S-07)

Resolve a finalization conflict. Used from S8 (Finalization Conflict screen).

**Auth:** Receptionist session.

**Request body:**
```json
{
  "conflict_id": "uuid",
  "resolution": "apply",
  "sections_to_apply": ["address", "allergies"]
}
```

`resolution` values:
- `"apply"` — apply selected sections from the losing session to the patient record
- `"discard"` — discard all changes from the losing session
- `"partial"` — same as apply, but only specified sections

**Response `200 OK`:**
```json
{
  "resolution": "applied",
  "sections_applied": ["address", "allergies"],
  "patient_id": "uuid"
}
```

**Side effects:**
- `session_conflicts.resolution` updated.
- For applied sections: patient_data updated, audit rows created.
- `patient.updated` event emitted.

---

### `GET /api/checkins/{id}/conflict` (NEW — S-07)

Get conflict details for display on S8.

**Auth:** Receptionist session.

**Response `200 OK`:** Conflict details as shown in the `409` finalization response, plus losing session's full section data.

---

## Check-in Queue (NEW — S-02)

### `GET /api/checkins/queue`

Queue view for receptionist (S5).

**Auth:** Receptionist session.

**Query params:**
| Param | Type | Required | Notes |
|-------|------|----------|-------|
| location_id | UUID | No | **S-05.** Filter by location. Default: receptionist's location. |
| all_locations | boolean | No | **S-05.** If true, return sessions from all locations. |
| status | string | No | Filter by status. Comma-separated. |

**Response `200 OK`:**
```json
{
  "location": {"id": "uuid", "name": "Main Street Clinic"},
  "showing": "this_location",
  "sessions": [
    {
      "id": "uuid",
      "patient_name": "Jane D.",
      "status": "in_progress",
      "channel": "kiosk",
      "started_at": "2026-03-16T15:00:00Z",
      "duration_seconds": 180,
      "assigned_to": "Receptionist Name",
      "location_name": "Main Street Clinic",
      "sections_complete": 2,
      "sections_total": 4
    }
  ],
  "stats": {
    "active_count": 15,
    "avg_duration_seconds": 240,
    "peak_state": "busy",
    "abandoned_today": 3
  }
}
```

**S-03 change:** Sessions with `channel: "mobile"` and `status: "patient_complete"` show as "Pre-checked-in".
**S-09 change:** `stats` block included when active_count > 10. `peak_state`: "normal" (<10), "busy" (10-20), "peak" (20+).

---

## Pre-Check-In (NEW — S-03)

### `GET /api/precheckin/{token}`

Patient opens pre-check-in link (S7).

**Auth:** None (token in URL).

**Response `200 OK` (link active, pre-verification):**
```json
{
  "status": "active",
  "clinic_name": "Main Street Clinic",
  "appointment_date": "2026-03-17",
  "appointment_time": "10:30 AM",
  "requires_verification": true
}
```

**Response `200 OK` (too early):**
```json
{
  "status": "too_early",
  "opens_at": "2026-03-16T10:30:00Z",
  "message": "Pre-check-in opens 24 hours before your appointment."
}
```

**Response `200 OK` (already completed):**
```json
{
  "status": "completed",
  "message": "You've already completed your pre-check-in."
}
```

**Response `200 OK` (expired):**
```json
{
  "status": "expired",
  "message": "This check-in link has expired."
}
```

**Response `404`:** Invalid or revoked link.

---

### `POST /api/precheckin/{token}/verify`

Identity verification (S6).

**Auth:** None (token in URL).

**Request body:**
```json
{
  "dob": "1985-03-14"
}
```

**Response `200 OK` (verified):**
```json
{
  "status": "verified",
  "checkin_token": "a1b2c3d4...",
  "checkin_url": "/checkin/a1b2c3d4..."
}
```

On successful verification, a check-in session is created automatically. The returned `checkin_token` is used for all subsequent `GET/PATCH /api/checkins/token/*` calls — same API surface as kiosk check-in.

**Response `401` (incorrect, attempts remaining):**
```json
{
  "status": "incorrect",
  "attempts_remaining": 2,
  "message": "That doesn't match our records."
}
```

**Response `403` (locked):**
```json
{
  "status": "locked",
  "message": "This link has been locked for security."
}
```

**Side effects:**
- Each failed attempt: `pre_checkin_links.verification_attempts` incremented. Logged in audit trail (BOX-15).
- On 3rd failure: `pre_checkin_links.status` -> "locked". Permanent for this link.
- On success: check-in session created via same path as `POST /api/checkins` with `channel: "mobile"` and `appointment_id`.
- Rate limited: 5 requests/minute per IP.

---

## Session Recovery (NEW — S-07)

### `GET /api/admin/sessions/conflicts`

List unresolved conflicts (S9).

**Auth:** Admin session.

**Response `200 OK`:**
```json
{
  "conflicts": [
    {
      "id": "uuid",
      "patient_name": "Jane Doe",
      "created_at": "2026-03-16T15:10:00Z",
      "resolution": "pending",
      "winning_session_id": "uuid",
      "losing_session_id": "uuid"
    }
  ]
}
```

### `GET /api/admin/sessions/{id}/history`

Full session history for a patient (S9).

**Auth:** Admin session.

**Response `200 OK`:**
```json
{
  "patient_id": "uuid",
  "patient_name": "Jane Doe",
  "sessions": [
    {
      "id": "uuid",
      "status": "finalized",
      "created_at": "...",
      "finalized_at": "...",
      "sections": ["...full section data..."]
    },
    {
      "id": "uuid",
      "status": "conflict",
      "created_at": "...",
      "sections": ["...full section data..."],
      "conflict_id": "uuid"
    }
  ]
}
```

### `POST /api/admin/sessions/{id}/recover`

Apply specific changes from a dead session to the patient record (S9).

**Auth:** Admin session.

**Request body:**
```json
{
  "sections": [
    {"category": "address", "value": {"line1": "456 Oak Ave"}}
  ],
  "reason": "Recovering lost data from concurrent session conflict"
}
```

**Response `200 OK`:**
```json
{
  "applied": ["address"],
  "audit_entry_id": "uuid"
}
```

---

## Import and Migration (NEW — S-10)

### `POST /api/admin/import/batches`

Create an import batch (S10).

**Auth:** Admin session.

**Request body:**
```json
{
  "source_system": "riverside_ehr",
  "total_records": 3200,
  "import_rate_limit": 10
}
```

**Response `201 Created`:**
```json
{
  "id": "uuid",
  "status": "pending",
  "total_records": 3200
}
```

### `GET /api/admin/import/batches/{id}`

Import progress (S10).

**Auth:** Admin session.

**Response `200 OK`:**
```json
{
  "id": "uuid",
  "source_system": "riverside_ehr",
  "status": "in_progress",
  "total_records": 3200,
  "imported": 1500,
  "errors": 12,
  "duplicates_flagged": 87,
  "rate": 8.5,
  "estimated_remaining_minutes": 35,
  "started_at": "...",
  "last_processed_at": "..."
}
```

### `POST /api/admin/import/batches/{id}/pause`

Pause import. **Auth:** Admin session. **Response `200 OK`:** `{"status": "paused"}`

### `POST /api/admin/import/batches/{id}/resume`

Resume import. **Auth:** Admin session. **Response `200 OK`:** `{"status": "in_progress"}`

### `GET /api/admin/import/duplicates`

List flagged duplicates for review (S11).

**Auth:** Admin session.

**Query params:**
| Param | Type | Required | Notes |
|-------|------|----------|-------|
| batch_id | UUID | No | Filter by batch. |
| confidence_min | decimal | No | Minimum confidence (e.g., 0.6). |
| confidence_max | decimal | No | Maximum confidence (e.g., 0.9). |
| status | string | No | "pending", "merged", "not_duplicate", "deferred". |
| limit | integer | No | Default 20. |
| offset | integer | No | Pagination. |

**Response `200 OK`:**
```json
{
  "total": 87,
  "duplicates": [
    {
      "import_record_id": "uuid",
      "confidence": 0.85,
      "source_record": {
        "source_id": "RV-12345",
        "first_name": "Maria",
        "last_name": "Rodriguez",
        "dob": "1972-08-20",
        "data": {"...all imported fields..."}
      },
      "existing_record": {
        "patient_id": "uuid",
        "first_name": "Maria",
        "last_name": "Rodriguez-Garcia",
        "dob": "1972-08-20",
        "data": {"...all current fields..."}
      },
      "match_signals": ["exact_dob", "similar_name", "same_phone"]
    }
  ]
}
```

### `POST /api/admin/import/duplicates/{importRecordId}/resolve`

Resolve a duplicate (S11/S12).

**Auth:** Admin session.

**Request body — not duplicate:**
```json
{
  "resolution": "not_duplicate"
}
```
Record is imported as a new patient.

**Request body — merge:**
```json
{
  "resolution": "merge",
  "target_patient_id": "uuid",
  "field_selections": {
    "address": "source",
    "insurance": "target",
    "allergies": "target",
    "medications": "merge_both",
    "phone": "source"
  }
}
```

**Response `200 OK`:**
```json
{
  "resolution": "merged",
  "patient_id": "uuid",
  "fields_from_source": ["address", "phone"],
  "fields_from_target": ["insurance", "allergies"],
  "fields_merged": ["medications"]
}
```

**Side effects:**
- Import record updated with resolution.
- Patient record updated per field selections.
- Source import record archived (not deleted).
- Audit trail records merge decisions with provenance.
- `patient.merged` event emitted.

**Request body — defer:**
```json
{
  "resolution": "deferred"
}
```
Flagged for later review.

---

### `POST /api/admin/import/paper-entry` (NEW — S-10)

Manual entry for paper records (S13).

**Auth:** Admin session.

**Request body:**
```json
{
  "batch_id": "uuid",
  "first_name": "John",
  "last_name": "Smith",
  "dob": "1960-05-12",
  "phone": "555-0789",
  "data_sections": [
    {"category": "address", "value": {"line1": "789 Elm St", "city": "Springfield"}},
    {"category": "medications", "value": {"items": [{"drug_name": "Aspirin", "dosage": "81mg", "frequency": "once daily"}]}}
  ],
  "source_image_key": "s3://phi-documents/paper-scans/batch-123/page-42.pdf",
  "flags": ["incomplete_insurance"]
}
```

**Validation:**
- Required: first_name, last_name, dob, at least one contact method (phone or address). Per BOX-41.
- Optional: all data_sections.
- `flags` tracks data quality issues.

**Response `201 Created`:**
```json
{
  "import_record_id": "uuid",
  "status": "imported",
  "patient_id": "uuid",
  "duplicate_check": {"confidence": 0.0, "candidate_id": null}
}
```

Same dedup pipeline as EHR import. If duplicate detected, returns `"status": "duplicate_flagged"`.

---

## Audit (NEW — addresses G-05)

### `GET /api/admin/audit`

Query audit trail. Addresses QA gap G-05.

**Auth:** Admin session.

**Query params:**
| Param | Type | Required | Notes |
|-------|------|----------|-------|
| patient_id | UUID | No | Filter by patient. |
| category | string | No | Filter by data category. |
| source | string | No | Filter by source (checkin_update, receptionist_edit, import, merge). |
| from | datetime | No | Start date. |
| to | datetime | No | End date. |
| limit | integer | No | Default 50. Max 200. |
| offset | integer | No | Pagination. |

**Response `200 OK`:**
```json
{
  "total": 150,
  "entries": [
    {
      "id": "uuid",
      "patient_id": "uuid",
      "patient_name": "Jane Doe",
      "category": "insurance",
      "old_value": {"provider": "BlueCross"},
      "new_value": {"provider": "Aetna"},
      "changed_by": "Receptionist Name",
      "source": "checkin_update",
      "session_id": "uuid",
      "created_at": "2026-03-16T15:10:00Z"
    }
  ]
}
```

---

## WebSocket Events (evolved from S-01)

Connection: `ws://host/ws/checkins/{sessionId}`

**Auth:** Receptionist: session cookie. Patient: access token as query param.

**S-02 changes:**
- Server sends `ping` every 15 seconds. Client must respond with `pong` within 5 seconds.
- If client misses 2 consecutive pings, server marks connection as dead and closes it.
- Client auto-reconnects with exponential backoff: 1s, 2s, 4s, 8s, max 30s, max 10 retries.
- After 10 failed retries, client switches to `GET /api/checkins/{id}/poll`.

### Events (server -> receptionist)

| Event | Payload | When | Added/Modified |
|-------|---------|------|----------------|
| `section.updated` | `{sectionId, category, status, confirmed_value}` | Patient confirms/updates a section | S-01 |
| `patient.complete` | `{completed_at}` | Patient taps "All Confirmed" | S-01 |
| `session.timeout` | `{partial_progress: [...]}` | 5-min inactivity reached | S-01 |
| `connection.health` | `{status: "connected"\|"degraded"\|"reconnecting"}` | Connection state change | S-02 |
| `medications.updated` | `{sectionId, action, items_added, items_removed, items_modified}` | Patient modifies medication list | S-06 |
| `photo.uploaded` | `{sectionId, upload_id, document_type, thumbnail_url}` | Patient uploads insurance card photo | S-08 |

### Events (server -> patient)

| Event | Payload | When | Added/Modified |
|-------|---------|------|----------------|
| `timeout.warning` | `{minutes_remaining: 2}` | 3 min of inactivity | S-01 |
| `timeout.warning` | `{minutes_remaining: 1}` | 4 min of inactivity | S-01 |
| `session.expired` | `{}` | 5 min inactivity or 30 min hard TTL | S-01 |
| `session.cancelled` | `{reason: "supervisor_takeover"\|"receptionist_cancel"}` | Session cancelled by staff | S-07 |
