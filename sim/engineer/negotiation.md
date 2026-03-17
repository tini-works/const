# Engineer Negotiation — Complete (Rounds 1-10)

## Boxes Received from Design (all rounds)

### Round 1 Boxes (from negotiation-s01.md — all accepted)

| Box | Verdict | Status |
|-----|---------|--------|
| BOX-01 through BOX-04 | Accepted | Implemented |
| BOX-D1 through BOX-D3 | Accepted | Implemented |

### Round 2 Boxes (S-02)

| Box | Verdict | Engineering Implications |
|-----|---------|------------------------|
| BOX-05: 2s visibility | **Accepted with nuance** | 2s applies to WebSocket path. Under polling fallback (S-02 degraded mode), target is 10s (polling interval). This is a conscious tradeoff — when WebSocket is down, real-time is not possible. Polling at 10s is the best we can do without reconnection. |
| BOX-06: No false success | **Accepted** | Server acknowledgment before green checkmark. Spinner during persist. Error + retry on failure. Per-section persist (BOX-E1) means each confirm tap is a round-trip. |
| BOX-07: Fallback queue | **Accepted** | Queue endpoint is pure REST, no WebSocket dependency. Always works. This is S5's primary architecture, not S3R's. |
| BOX-D4: Connection health | **Accepted** | WebSocket heartbeat (15s interval). Connection states: connected, degraded, reconnecting, dead. Exposed via connection.health event. |
| BOX-D5: Completion event | **Accepted** | patient.complete WebSocket event triggers visual notification on S3R. Payload includes completed_at. |

### Round 3 Boxes (S-03)

| Box | Verdict | Engineering Implications |
|-----|---------|------------------------|
| BOX-08: Mobile pre-check-in | **Accepted** | New service (Notification Service) for link generation. New endpoint surface (precheckin/*). Mobile sessions use same Check-in Service but with channel:"mobile" and appointment linkage. |
| BOX-09: Time window | **Accepted** | pre_checkin_links table with opens_at/expires_at. Server validates time window at link access. |
| BOX-10: Pre-checked-in visible | **Accepted** | Queue shows mobile sessions with distinct status. |
| BOX-11: Identity verification | **Accepted** | DOB verification gate with 3-attempt lockout. Permanent lockout — no reset from this link. Rate limiting at gateway. Failed attempts logged for HIPAA (BOX-15). |
| BOX-D6: Responsive, not separate | **Accepted** | Same API surface for kiosk and mobile. Responsive is a client concern. |
| BOX-D7: What happens next | **Accepted** | POST .../complete response varies by channel. Mobile: arrival instructions. Kiosk: seat message. |
| BOX-D8: Partial pre-check-in | **Accepted with constraint** | If mobile session expires, a new kiosk session can inherit partial progress. This requires cross-session data transfer — we check for recent expired sessions for the same patient and pre-populate. Adds complexity to session creation. |

### Round 4 Boxes (S-04 — HIPAA)

| Box | Verdict | Engineering Implications |
|-----|---------|------------------------|
| BOX-12: No PHI cross-exposure | **Accepted** | Client-side: SessionPurge module. Server-side: token invalidation. Combined enforcement. |
| BOX-13: Screen clearing enforced | **Accepted** | Programmatic, not advisory. Client replaces history, clears DOM, nullifies memory. |
| BOX-14: Encryption at rest | **Accepted** | PostgreSQL AES-256. Object Storage SSE. Already planned in S-01. |
| BOX-15: Access logging | **Accepted** | Audit endpoint: GET /admin/audit. 7-year retention. All mutations logged. Failed verifications logged. |
| BOX-16: Minimum necessary | **Accepted** | Patient view returns first_name only. Token-scoped to single session. No browsing. |
| BOX-17: Breach response | **N/A for engineer** | Operational process. |
| BOX-18: PHI in transit | **Accepted** | TLS everywhere. HTTPS only. WSS for WebSocket. |
| BOX-D9: Kiosk idle state | **Accepted** | Client-side only. S0 is static HTML — no API call. |
| BOX-D10: No intermediate states | **Accepted** | New session data loads behind S0. S0 dismissed only when new data ready. |

### Round 5 Boxes (S-05)

| Box | Verdict | Engineering Implications |
|-----|---------|------------------------|
| BOX-19: Location-independent | **Accepted** | Single patients table, no location sharding. This is a data architecture decision that pays off here. |
| BOX-20: Works at any location | **Accepted** | location_id added to sessions. All operations work cross-location. |
| BOX-21: Location is context | **Accepted** | locations table. X-Location-Id header. Queue filter. Visit history includes location. |
| BOX-D11: Location context visible | **Accepted** | App header driven by receptionist's session config. |
| BOX-D12: Queue location filter | **Accepted** | GET /checkins/queue with location_id and all_locations params. |

### Round 6 Boxes (S-06)

| Box | Verdict | Engineering Implications |
|-----|---------|------------------------|
| BOX-22: Medications every visit | **Accepted with enforcement** | freshness_days=0 makes it always stale. But I'm adding server-side enforcement: POST .../complete REJECTS if medications not confirmed. This is BOX-E6 (new). Client-side enforcement alone is insufficient — a client bug could skip medications. |
| BOX-23: Variable-length | **Accepted** | JSONB array with items[]. Supports 0 to N items. No fixed schema per medication — drug_name, dosage, frequency, prescriber (optional). |
| BOX-24: Auditable | **Accepted** | confirm_medications action creates audit entry with full medication list snapshot. Every add/remove/edit during the session is captured in the section's confirmed_value. |
| BOX-25: Integrated | **Accepted** | Medications is a data_category row, not special-cased code. Same section confirm/update pattern. display_order controls placement in S3P. |
| BOX-D13: Not scrolling | **Accepted** | confirm_medications action requires full list in request body. Server validates list matches current state. Patient must have actually reviewed it. |
| BOX-D14: Empty list confirmed | **Accepted** | confirmed_empty:true flag. Explicit action, not a skip. |

### Round 7 Boxes (S-07)

| Box | Verdict | Engineering Implications |
|-----|---------|------------------------|
| BOX-26: Airtight prevention | **Accepted** | Cross-location unique constraint (S-05 enabled this). 409 response includes full session details. |
| BOX-27: Conflict-safe finalization | **Accepted with new mechanism** | Optimistic locking via version column. expected_version in finalize request. 412 on mismatch, 409 on true conflict. |
| BOX-28: Lost data recoverable | **Accepted** | session_conflicts table. Admin recovery API. POST .../recover with specific section selection. |
| BOX-D15: Informative blocking | **Accepted** | 409 POST /checkins response includes who, when, where, status. |
| BOX-D16: Conflict shows both | **Accepted** | 409 POST /finalize response includes winning and losing session data. GET .../conflict endpoint for full view. |

### Round 8 Boxes (S-08)

| Box | Verdict | Engineering Implications |
|-----|---------|------------------------|
| BOX-29: Photo capture | **Accepted with async model** | Upload returns 202. OCR is async (2-10s). Client polls for result. This is BOX-E7 (new). |
| BOX-30: OCR verification | **Accepted** | OCR result is returned to patient for field-by-field review. NOT auto-applied. Patient must explicitly submit update. |
| BOX-31: Card images PHI | **Accepted** | Object Storage with encryption. Signed URLs (5-min expiry). 7-year retention. No direct access. |
| BOX-D17: Framing guidance | **Accepted** | Client-side only. Camera overlay. |
| BOX-D18: Manual fallback | **Accepted** | Always available. PATCH with action:"update" works regardless of OCR path. |

### Round 9 Boxes (S-09)

| Box | Verdict | Engineering Implications |
|-----|---------|------------------------|
| BOX-32: 30 concurrent | **Accepted with architecture** | Horizontal scaling for Check-in Service. Connection pool sizing. Read replica for search. |
| BOX-33: 60 aggregate | **Accepted** | Same architecture scales. Connection pool: 50 primary + 20 replica. |
| BOX-34: Degradation visible | **Accepted** | Queue stats block: active_count, avg_duration, peak_state. |
| BOX-35: Patient loss measurable | **Accepted** | Abandonment tracking: sessions that timeout without reaching in_progress. abandoned_today counter. |
| BOX-D19: No load to patient | **Accepted** | Generic error messages. No "system overloaded" text on patient screens. |
| BOX-D20: Queue metrics | **Accepted** | Stats block in queue response during busy/peak. |

### Round 10 Boxes (S-10)

| Box | Verdict | Engineering Implications |
|-----|---------|------------------------|
| BOX-36: Importable | **Accepted** | Migration Service. Bulk import API. Paper entry API. |
| BOX-37: Duplicates detected | **Accepted** | Dedup algorithm with tiered confidence. Auto-import at 0%, review at >0%. |
| BOX-38: Merge preserves data | **Accepted** | Field-by-field merge selection. "merge_both" for list fields. Both source records archived. Provenance tagged. |
| BOX-39: Non-degrading | **Accepted** | Throttled import (10/s). Pause during peak. BOX-E8 (idempotent). |
| BOX-40: Post-import searchable | **Accepted** | patient.imported event -> search index rebuild. is_imported flag. |
| BOX-41: Paper minimum data | **Accepted** | Validation: name + DOB + contact method. 422 if not met. |
| BOX-D21: Confidence tiers | **Accepted** | Confidence filters on duplicate review endpoint. |
| BOX-D22: Import progress | **Accepted** | Batch progress endpoint with real-time counts. |
| BOX-D23: Provenance | **Accepted** | provenance field on patient_data. provenance_note on patient. source_system and source_id. |

---

## Boxes I'm Adding Upward (complete)

### Round 1 Boxes (unchanged from negotiation-s01.md)

- **BOX-E1:** Session timeout produces no data loss
- **BOX-E2:** Patient access is token-scoped
- **BOX-E3:** Data updates are staged, not immediate
- **BOX-E4:** Search index is eventually consistent
- **BOX-E5:** Concurrent check-in prevention

### New Boxes (Rounds 2-10)

#### BOX-E6: Medication completion is server-enforced (S-06)

POST /checkins/token/{token}/complete will REJECT with 400 if the medications section has not been explicitly confirmed. This is not a client-side validation — it is a server-side gate.

**Why:** A client bug, a browser extension, or a network issue could bypass client-side medication confirmation. Given that this is a regulatory mandate (S-06), the server must be the final authority on whether the check-in is complete.

**Upstream impact:** QA must test this explicitly — confirm all sections except medications, attempt complete, assert 400.

#### BOX-E7: OCR is asynchronous with timeout fallback (S-08)

Photo upload returns 202. OCR processing takes 2-10 seconds. Client polls for result. If OCR is not complete within 10 seconds, client offers "Enter manually" fallback.

**Why:** OCR depends on an external cloud service. We cannot guarantee response time. Synchronous OCR would block the patient on an unpredictable wait. Async with polling and timeout keeps the patient experience responsive.

**Upstream impact:** Design must handle 3 OCR states in the UI: processing (spinner), completed (verification), failed (manual fallback).

#### BOX-E8: Import is idempotent on source_id (S-10)

Re-importing a record with the same source_id + source_system is a no-op. Returns "already_imported". No duplicate patient record created.

**Why:** Import pipelines fail and retry. Network issues cause partial batch failures. Idempotency ensures safety on retry without requiring the caller to track what was already imported.

**Upstream impact:** DevOps can restart failed import batches safely. QA must test the idempotency guarantee.

#### BOX-E9: Finalization is atomic (S-07 response to BOX-O1)

Finalization wraps all patient_data mutations in a single database transaction. Events are emitted AFTER commit. If any mutation fails, the entire finalization rolls back. Session remains in patient_complete state. Receptionist can retry.

**Why:** This answers DevOps BOX-O1. A partial finalization (e.g., insurance updated but allergies not) corrupts patient data integrity.

**Upstream impact:** This is a direct response to DevOps BOX-O1. QA must test the kill-mid-finalization scenario.

---

## Open Questions (resolved from S-01)

| Question | Resolution | Resolved by |
|----------|-----------|-------------|
| Unfinalised session policy | Auto-expire 30 min, discard, audit log | PM (R02 response) |
| HIPAA data-at-rest | AES-256 sufficient. HIPAA confirmed. | PM (R04, S-04) |
| Audit trail retention | 7 years (HIPAA standard) | PM (R02 response) |

## New Open Questions (Rounds 2-10)

| Question | Who | Context | Impact if unresolved |
|----------|-----|---------|---------------------|
| Appointment system integration model | PM/Admin | S-03: do we poll their API, receive webhooks, or manually generate links? | Mobile pre-check-in link generation blocked |
| OCR service selection | DevOps/PM | S-08: AWS Textract vs Azure Form Recognizer vs Google Document AI. Cost, accuracy, HIPAA BAA. | OCR pipeline blocked |
| Riverside EHR export format | PM/Admin | S-10: CSV, HL7, FHIR? Need sample data to build parser. | Import pipeline blocked |
| Riverside paper record digitization | PM/Admin | S-10: are paper records already scanned? If not, who scans them? | Paper entry flow scope unclear |
| Import rate during peak hours | PM/DevOps | S-10: should import fully pause during 8-10 AM peak, or just throttle down? | Degradation risk |
| Duplicate confidence auto-merge threshold | PM | S-10: should 100% confidence duplicates auto-merge, or always require human review? | Merge workflow scope |

---

## Responses to DevOps (from devops/negotiation-s01.md)

| DevOps Question | Engineer Response |
|----------------|-------------------|
| Q1: Finalization transaction scope | **YES.** Finalization is now wrapped in a single DB transaction (BOX-E9). Events emitted after commit. Addresses BOX-O1. |
| Q2: Event bus guaranteed delivery | Redis Streams with consumer groups. At-least-once delivery. Unacknowledged messages re-delivered after 60 seconds. Consumer acknowledgment required. |
| Q3: WebSocket reconnection | Exponential backoff: 1s, 2s, 4s, 8s, max 30s. Max 10 retries. After 10 failures: client switches to polling. Session survives — it's server-side state, not connection state. |
| Q4: Graceful shutdown timing | 30-second termination grace period confirmed. In-flight PATCH requests must complete. Kubernetes: terminationGracePeriodSeconds: 30. |

## Responses to QA (from qa/gaps.md)

| Gap | Engineer Response |
|-----|-------------------|
| G-01: UX no runnable proof | Not an engineer concern. Design must provide. |
| G-02: Reinitiation API missing | **RESOLVED.** POST /api/checkins/{id}/reinitiate now fully specified in api.md. |
| G-03: Staleness thresholds | **RESOLVED.** PM confirmed. Medications = 0 days added. |
| G-04: Unfinalised session policy | **RESOLVED.** Auto-expire 30 min, discard, audit. |
| G-05: Audit trail read mechanism | **RESOLVED.** GET /admin/audit endpoint added to api.md. |
| G-06: WebSocket no contract test | **ADDRESSED.** WebSocket events documented. Fallback polling endpoint added. QA must write contract tests. |
| G-07: HIPAA compliance boxes absent | **RESOLVED.** BOX-12 through BOX-18 exist. Architecture updated for HIPAA compliance. |
| G-08: BOX-E5 state missing from Design | **RESOLVED.** Design added S2 concurrent state, S8 conflict screen, S9 recovery screen. Engineer added optimistic locking. |
| G-09: Token in WebSocket query param | **ACKNOWLEDGED.** DevOps must confirm log scrubbing. Alternative: send token as first WebSocket message instead of query param. Recommend switching to message-based auth. Decision deferred to DevOps. |
