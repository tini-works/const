# API Contracts — Story 01

Every endpoint the system exposes for the returning patient check-in flow. Organized by service.

---

## Search Service

### `GET /api/patients/search`

Standard patient lookup (S1). Prefix matching, fast.

**Auth:** Receptionist session.

**Query params:**
| Param | Type | Required | Notes |
|-------|------|----------|-------|
| q | string | Yes | Search term. Minimum 2 characters. Matched against name prefix and DOB. |
| limit | integer | No | Default 10. Max 25. |

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
      "has_active_checkin": false
    }
  ],
  "total": 3
}
```

**Response `400`:** `q` is missing or <2 characters.

**Notes:**
- `has_active_checkin` is true if this patient has a non-finalized, non-expired check-in session. Used to warn the receptionist before selecting (see BOX-E5).
- Results sorted by relevance (exact matches first) then by last visit date (most recent first).

---

### `GET /api/patients/search/fuzzy`

Assisted search (S1b). Looser matching, multiple criteria, confidence scores.

**Auth:** Receptionist session.

**Query params:**
| Param | Type | Required | Notes |
|-------|------|----------|-------|
| name | string | No | Fuzzy name match (Levenshtein distance <= 2). |
| dob | string | No | Partial DOB. Accepts "1985", "1985-03", or "1985-03-14". |
| phone | string | No | Exact or partial (last 4 digits). |
| email | string | No | Exact match. |
| insurance_id | string | No | Matches current or historical insurance policy numbers. |
| limit | integer | No | Default 10. Max 25. |

At least one param (other than limit) is required.

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
      "photo_url": null,
      "confidence": 0.82,
      "matched_on": ["name", "phone"]
    }
  ],
  "total": 1
}
```

**Notes:**
- `confidence` is 0.0-1.0. Computed from how many criteria matched and how closely.
- `matched_on` tells the receptionist which criteria produced this result.
- Results sorted by confidence descending.

---

## Patient Service

### `GET /api/patients/{id}`

Full patient record with data sections and staleness computation (S2).

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
    }
  ],
  "has_active_checkin": false
}
```

**Response `404`:** Patient not found.

**Notes:**
- `is_stale` is computed server-side: `today - last_confirmed > freshness_threshold_days`.
- `freshness_threshold_days: null` means "never stale" (allergies).
- `has_active_checkin` prevents starting a second session (BOX-E5).
- Data sections with no value (null) are returned with `"value": null` — client renders these in the "missing" group.

---

### `PATCH /api/patients/{id}`

Receptionist direct edit (S2 "Update Record" flow). Updates patient record fields directly.

**Auth:** Receptionist session.

**Request body:**
```json
{
  "data_sections": [
    {
      "category": "insurance",
      "value": {"provider": "Aetna", "policy_number": "AE-99999", "group_number": "G-200"}
    }
  ]
}
```

**Response `200 OK`:** Updated patient record (same shape as GET).

**Side effects:**
- `last_confirmed` is set to now for each updated section.
- `confirmed_by` is set to the receptionist's user ID.
- `source` is set to `"receptionist_edit"`.
- Audit row created.
- `patient.updated` event emitted (search index rebuilds).

---

## Check-in Service

### `POST /api/checkins`

Create a check-in session (receptionist clicks "Begin Check-in" on S2).

**Auth:** Receptionist session.

**Request body:**
```json
{
  "patient_id": "uuid"
}
```

**Response `201 Created`:**
```json
{
  "id": "uuid",
  "patient_id": "uuid",
  "status": "pending",
  "access_token": "a1b2c3d4...",
  "access_url": "/checkin/a1b2c3d4...",
  "expires_at": "2026-03-16T15:30:00Z",
  "sections": [
    {
      "id": "uuid",
      "category": "address",
      "status": "pending",
      "has_existing_data": true,
      "is_stale": true
    },
    {
      "id": "uuid",
      "category": "insurance",
      "status": "pending",
      "has_existing_data": true,
      "is_stale": true
    },
    {
      "id": "uuid",
      "category": "allergies",
      "status": "pending",
      "has_existing_data": true,
      "is_stale": false
    }
  ]
}
```

**Response `409 Conflict`:**
```json
{
  "error": "active_checkin_exists",
  "existing_session_id": "uuid",
  "initiated_by": "Receptionist Name",
  "initiated_at": "2026-03-16T15:00:00Z"
}
```

**Side effects:**
- Patient data is snapshotted into `checkin_sections.original_value`.
- `access_token` is generated (cryptographically random, 64 chars). Returned in plaintext here. Stored hashed in DB.
- `checkin.created` event emitted.
- WebSocket channel created for this session.

**Notes:**
- `access_token` is shown exactly once in this response. The receptionist's client uses it to generate the patient-facing URL.
- `access_url` is the path the patient's device navigates to. Contains the token.

---

### `GET /api/checkins/{id}`

Receptionist view of a check-in session (S3R).

**Auth:** Receptionist session.

**Response `200 OK`:**
```json
{
  "id": "uuid",
  "patient_id": "uuid",
  "patient_name": "Jane Doe",
  "status": "in_progress",
  "created_at": "2026-03-16T15:00:00Z",
  "last_activity_at": "2026-03-16T15:03:22Z",
  "expires_at": "2026-03-16T15:30:00Z",
  "sections": [
    {
      "id": "uuid",
      "category": "address",
      "status": "confirmed",
      "original_value": {"line1": "123 Main St", "city": "Springfield", "state": "IL", "zip": "62701"},
      "confirmed_value": null,
      "acted_at": "2026-03-16T15:01:10Z"
    },
    {
      "id": "uuid",
      "category": "insurance",
      "status": "updated",
      "original_value": {"provider": "BlueCross", "policy_number": "BC-12345", "group_number": "G-100"},
      "confirmed_value": {"provider": "Aetna", "policy_number": "AE-99999", "group_number": "G-200"},
      "acted_at": "2026-03-16T15:02:45Z"
    },
    {
      "id": "uuid",
      "category": "allergies",
      "status": "pending",
      "original_value": {"items": [{"name": "Penicillin", "severity": "moderate", "reaction": "rash"}]},
      "confirmed_value": null,
      "acted_at": null
    }
  ]
}
```

**Notes:**
- Receptionist sees both `original_value` and `confirmed_value` for diff display.
- `confirmed_value: null` + `status: "confirmed"` means patient confirmed the original value without changes.
- `status: "updated"` with both values present means the receptionist can compare old vs. new.

---

### `GET /api/checkins/token/{token}`

Patient view of their check-in session (S3P).

**Auth:** Bearer token (the access_token from session creation). No user session required.

**Response `200 OK`:**
```json
{
  "session_id": "uuid",
  "patient_first_name": "Jane",
  "sections": {
    "existing": [
      {
        "id": "uuid",
        "category": "address",
        "status": "pending",
        "value": {"line1": "123 Main St", "city": "Springfield", "state": "IL", "zip": "62701"},
        "is_stale": true,
        "last_confirmed_display": "January 2025"
      },
      {
        "id": "uuid",
        "category": "insurance",
        "status": "pending",
        "value": {"provider": "BlueCross", "policy_number": "BC-12345", "group_number": "G-100"},
        "is_stale": true,
        "last_confirmed_display": "September 2025"
      },
      {
        "id": "uuid",
        "category": "allergies",
        "status": "pending",
        "value": {"items": [{"name": "Penicillin", "severity": "moderate", "reaction": "rash"}]},
        "is_stale": false,
        "last_confirmed_display": "November 2025"
      }
    ],
    "missing": []
  },
  "can_complete": false
}
```

**Response `401`:** Invalid or expired token.
**Response `410 Gone`:** Session finalized or expired.

**Notes:**
- Patient view returns `patient_first_name` only (no last name — privacy in shared spaces per Design spec).
- Sections are pre-split into `existing` and `missing` (BOX-D3).
- `can_complete` is true only when all sections have status != "pending".
- `last_confirmed_display` is a human-friendly date string (month + year). No exact timestamps for patients.
- No `original_value`/`confirmed_value` split — patient sees only the current display value.

---

### `PATCH /api/checkins/token/{token}/sections/{sectionId}`

Patient confirms or updates a section (S3P interaction).

**Auth:** Bearer token.

**Request body — confirm:**
```json
{
  "action": "confirm"
}
```

**Request body — update:**
```json
{
  "action": "update",
  "value": {"provider": "Aetna", "policy_number": "AE-99999", "group_number": "G-200"}
}
```

**Request body — fill missing:**
```json
{
  "action": "fill",
  "value": {"provider": "Aetna", "policy_number": "AE-99999", "group_number": "G-200"}
}
```

**Response `200 OK`:**
```json
{
  "section_id": "uuid",
  "status": "confirmed",
  "can_complete": false
}
```

**Response `401`:** Invalid/expired token.
**Response `410 Gone`:** Session expired or finalized.
**Response `422`:** Invalid value structure for the category.

**Side effects:**
- `checkin_sections` row updated: `status`, `confirmed_value`, `acted_at`.
- `checkin_sessions.last_activity_at` updated (resets 5-min inactivity timer).
- `checkin.section.updated` event emitted -> WebSocket -> receptionist sees live update on S3R.
- `can_complete` recalculated: true if all sections are non-pending.

---

### `POST /api/checkins/token/{token}/complete`

Patient taps "All Confirmed" (S3P completion).

**Auth:** Bearer token.

**Request body:** None.

**Response `200 OK`:**
```json
{
  "status": "patient_complete",
  "message": "You're all checked in, Jane. Please take a seat — we'll call you shortly."
}
```

**Response `400`:** Not all sections are resolved (can_complete was false).
**Response `401`/`410`:** Token invalid/session gone.

**Side effects:**
- `checkin_sessions.status` -> `"patient_complete"`.
- `checkin_sessions.patient_completed_at` -> now.
- `checkin.patient.complete` event emitted -> WebSocket -> receptionist sees "Complete Check-in" button activate on S3R.

---

### `POST /api/checkins/{id}/finalize`

Receptionist finalizes check-in (S3R "Complete Check-in").

**Auth:** Receptionist session.

**Request body:** None.

**Response `200 OK`:**
```json
{
  "status": "finalized",
  "patient_id": "uuid",
  "updates_applied": [
    {
      "category": "insurance",
      "action": "updated",
      "old_value": {"provider": "BlueCross", "policy_number": "BC-12345"},
      "new_value": {"provider": "Aetna", "policy_number": "AE-99999"}
    }
  ],
  "sections_confirmed": ["address", "allergies"]
}
```

**Response `400`:** Session status is not "patient_complete".

**Side effects:**
- For each section with `status: "confirmed"`: `patient_data.last_confirmed` updated to now.
- For each section with `status: "updated"` or `"missing_filled"`: `patient_data.value` updated, `last_confirmed` set to now, `source` set to `"checkin_update"`.
- Audit rows created for every change.
- `checkin_sessions.status` -> `"finalized"`, `finalized_at` -> now.
- Access token invalidated.
- `patient.updated` event emitted (search index rebuilds).
- `checkin.finalized` event emitted.

---

## WebSocket Events

Connection: `ws://host/ws/checkins/{sessionId}`

**Auth:** Receptionist connects with session cookie. Patient connects with access token as query param.

### Events (server -> receptionist)

| Event | Payload | When |
|-------|---------|------|
| `section.updated` | `{sectionId, category, status, confirmed_value}` | Patient confirms/updates a section |
| `patient.complete` | `{completed_at}` | Patient taps "All Confirmed" |
| `session.timeout` | `{partial_progress: [...]}` | 5-min inactivity reached |

### Events (server -> patient)

| Event | Payload | When |
|-------|---------|------|
| `timeout.warning` | `{minutes_remaining: 2}` | 3 min of inactivity |
| `timeout.warning` | `{minutes_remaining: 1}` | 4 min of inactivity |
| `session.expired` | `{}` | 5 min inactivity or 30 min hard TTL |
