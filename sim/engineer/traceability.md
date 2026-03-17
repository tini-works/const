# Engineering Traceability — Complete (Rounds 1-10)

Every box, where it lands in the system, and what proves it.

---

## PM Box -> System Mapping

| Box | System Component | Data Entity | API Endpoint(s) | Flow(s) |
|-----|-----------------|-------------|-----------------|---------|
| BOX-01: Patient recognized | Search Service | patients, search_index | GET /patients/search | Flow 1 |
| BOX-02: No re-asking | Check-in Service | checkin_sections (snapshot) | GET /checkins/token/{t} | Flow 4 |
| BOX-03: Confirm not re-enter | Check-in Service | checkin_sections | PATCH /checkins/token/{t}/sections/{s} | Flow 4 |
| BOX-04: Recognition experience | Check-in Service | patients.first_name | GET /checkins/token/{t}, POST .../complete | Flow 7 |
| BOX-05: 2s visibility | WebSocket Server + polling fallback | checkin_sessions | WebSocket events, GET /checkins/{id}/poll | Flow 10 |
| BOX-06: No false success | Check-in Service | checkin_sections | PATCH .../sections/{s} (server-ack gated) | Flow 4 |
| BOX-07: Fallback queue | Check-in Service | checkin_sessions | GET /checkins/queue | Flow 10, 16 |
| BOX-08: Mobile pre-check-in | Notification Service + Check-in Service | pre_checkin_links, checkin_sessions | GET /precheckin/{t}, POST .../verify | Flow 12 |
| BOX-09: Time window | Notification Service | pre_checkin_links | GET /precheckin/{t} | Flow 12 |
| BOX-10: Pre-checked-in recognized | Check-in Service | checkin_sessions (status, channel) | GET /checkins/queue | Flow 12 |
| BOX-11: Identity verification | Check-in Service | pre_checkin_links (verification_attempts) | POST /precheckin/{t}/verify | Flow 12 |
| BOX-12: No PHI cross-exposure | Client (SessionPurge module) | — (client-side) | — | Flow 11 |
| BOX-13: Screen clearing enforced | Client (SessionPurge module) | — | — | Flow 11 |
| BOX-14: Encryption at rest | PostgreSQL (AES-256), Object Storage (SSE) | All patient data | — | architecture.md |
| BOX-15: HIPAA access logging | Audit Service | patient_data_audit | GET /admin/audit | Flow 12 (failed attempts), all mutation flows |
| BOX-16: Minimum necessary | API Gateway (token scoping) | — | GET /checkins/token/{t} (first_name only) | Flow 12 |
| BOX-17: Breach incident response | — | — | — | Operational process, no API |
| BOX-18: PHI in transit | API Gateway (TLS) | — | All endpoints | infrastructure |
| BOX-19: Location-independent | Patient Service | patients (no location sharding) | GET /patients/search (cross-location) | Flow 16 |
| BOX-20: Works at any location | Check-in Service | checkin_sessions.location_id | POST /checkins, GET /checkins/queue | Flow 3, 16 |
| BOX-21: Location is context | Check-in Service + Patient Service | locations, visits.location_id | GET /checkins/queue, GET /patients/{id} | Flow 16 |
| BOX-22: Medications every visit | Check-in Service | checkin_sections (medications), data_categories | PATCH .../sections/{s} (confirm_medications) | Flow 5 |
| BOX-23: Variable-length medications | Patient Service | patient_data (medications JSONB array) | PATCH .../sections/{s} | Flow 5 |
| BOX-24: Medication audit | Audit Service | patient_data_audit | GET /admin/audit | Flow 5 |
| BOX-25: Medications in check-in | Check-in Service | checkin_sections | GET /checkins/token/{t}, POST .../complete | Flow 5 |
| BOX-26: Concurrent prevention | Check-in Service (DB constraint) | checkin_sessions (unique partial index) | POST /checkins (409) | Flow 9 |
| BOX-27: Conflict-safe finalization | Check-in Service (optimistic locking) | checkin_sessions.version | POST /checkins/{id}/finalize (409/412) | Flow 7, 15 |
| BOX-28: Lost data recoverable | Admin API | session_conflicts | GET /admin/sessions/conflicts, POST .../recover | Flow 15 |
| BOX-29: Photo capture | OCR Service + Object Storage | document_uploads | POST .../sections/{s}/upload | Flow 14 |
| BOX-30: OCR verification | OCR Service | document_uploads.ocr_result | GET .../ocr/{upload_id} | Flow 14 |
| BOX-31: Card images are PHI | Object Storage (encrypted) | document_uploads.storage_key | Signed URLs only | Flow 14 |
| BOX-32: 30 concurrent | Infrastructure (scaling) | — | All endpoints under load | Flow 19 |
| BOX-33: 60 aggregate | Infrastructure (scaling) | — | All endpoints under load | Flow 19 |
| BOX-34: Degradation visible | Check-in Service | checkin queue stats | GET /checkins/queue (stats block) | Flow 19 |
| BOX-35: Patient loss measurable | Check-in Service | checkin_sessions (abandonment tracking) | GET /checkins/queue (abandoned_today) | Flow 19 |
| BOX-36: Records importable | Migration Service | import_batches, import_records | POST /admin/import/batches, POST .../bulk-import | Flow 17 |
| BOX-37: Duplicates detected | Migration Service (dedup algorithm) | import_records (confidence, candidate_id) | GET /admin/import/duplicates | Flow 18 |
| BOX-38: Merge preserves data | Patient Service (merge) | patients, patient_data (provenance) | POST .../duplicates/{id}/resolve (merge) | Flow 18 |
| BOX-39: Non-degrading import | Migration Service (throttling) | import_batches.import_rate_limit | POST .../batches/{id}/pause | Flow 17 |
| BOX-40: Post-import searchable | Search Service | search_index | GET /patients/search (is_imported flag) | Flow 1 |
| BOX-41: Paper minimum data | Migration Service (validation) | import_records | POST /admin/import/paper-entry (validation) | Flow 17 |

---

## Design Box -> System Mapping

| Box | System Component | How Matched |
|-----|-----------------|-------------|
| BOX-D1: Graceful failure | Search Service (fuzzy) | GET /patients/search/fuzzy with confidence scores |
| BOX-D2: Two actor views | API Gateway + Check-in Service | Different response shapes for GET /checkins/{id} vs GET /checkins/token/{t} |
| BOX-D3: Partial data | Check-in Service | GET /checkins/token/{t} splits sections into existing/missing |
| BOX-D4: Connection health | WebSocket Server | Heartbeat + connection.health events |
| BOX-D5: Completion event | WebSocket Server | patient.complete event with prominent notification |
| BOX-D6: Responsive mobile | Client layer | Same codebase, responsive CSS. Same API surface. |
| BOX-D7: What happens next | Check-in Service | POST .../complete response includes appropriate message per channel |
| BOX-D8: Partial pre-check-in | Check-in Service | reinitiate endpoint preserves progress. New session detects recent expired mobile sessions. |
| BOX-D9: Kiosk idle state | Client layer | S0 rendered on session termination. No server component. |
| BOX-D10: No intermediate states | Client layer (SessionPurge) | S0 loads before new data, not after. Hard transition. |
| BOX-D11: Location context | Check-in Service | X-Location-Id header. GET /patients/{id} includes last_visit_location. |
| BOX-D12: Location filter | Check-in Service | GET /checkins/queue with location_id and all_locations params |
| BOX-D13: Medication confirmation not scrolling | Check-in Service | confirm_medications action requires full list in request body. Server validates. |
| BOX-D14: Empty med list confirmed | Check-in Service | confirmed_empty: true in medications value. Server tracks. |
| BOX-D15: Concurrent blocking informative | Check-in Service | 409 response includes who, when, where, status of existing session |
| BOX-D16: Conflict shows both | Check-in Service | 409 finalization response includes both sessions' changes. GET .../conflict endpoint. |
| BOX-D17: Photo framing | Client layer | Camera overlay with card frame guide. Client-side only. |
| BOX-D18: Manual fallback | Client layer | "Enter manually" option always available. PATCH with action:"update" works regardless of OCR. |
| BOX-D19: No load state to patient | Check-in Service + Client | Generic error messages only. No "system overloaded" text. |
| BOX-D20: Queue metrics | Check-in Service | GET /checkins/queue returns stats block during busy/peak |
| BOX-D21: Confidence tiers | Migration Service | GET /admin/import/duplicates with confidence_min/max filters |
| BOX-D22: Import progress | Migration Service | GET /admin/import/batches/{id} with real-time counts |
| BOX-D23: Provenance | Patient Service + Migration Service | provenance field on patient_data. provenance_note on patient record. |

---

## Engineer Box -> System Mapping

| Box | System Component | How Matched |
|-----|-----------------|-------------|
| BOX-E1: No data loss on timeout | Check-in Service | Per-section persist. reinitiate endpoint. Partial pre-check-in recovery. |
| BOX-E2: Token-scoped access | API Gateway + Check-in Service | 64-char token, hashed in DB, scoped to one session. Extended for mobile (S-03). |
| BOX-E3: Staged updates | Check-in Service -> Patient Service | confirmed_value in checkin_sections. Applied only on finalize. |
| BOX-E4: Eventual consistency | Search Service | Event-driven index rebuild. <2s lag. BOX-O2 monitors drift. |
| BOX-E5: Concurrent prevention | Check-in Service (DB constraint) | Unique partial index. Cross-location (S-05). Version column for finalization (S-07). |
| BOX-E6: Medications server-enforced | Check-in Service | POST .../complete rejects if medications not confirmed. Server-side, not client-only. |
| BOX-E7: OCR is async | OCR Service | Upload returns 202. Client polls. Timeout falls back to manual. |
| BOX-E8: Import idempotent | Migration Service | source_id + source_system unique. Re-import is no-op. |
| BOX-E9: Finalization atomic | Check-in Service + Patient Service | Single DB transaction per BOX-O1. Events emitted after commit. |

---

## Screen -> API Mapping (complete)

| Screen | Primary API Call(s) | Actor | Auth |
|--------|---------------------|-------|------|
| S0 (Welcome) | — | Patient (kiosk) | None |
| S1 (Patient Lookup) | GET /api/patients/search | Receptionist | Session |
| S1b (Assisted Search) | GET /api/patients/search/fuzzy | Receptionist | Session |
| S2 (Patient Summary) | GET /api/patients/{id} | Receptionist | Session |
| S2 (Update Record) | PATCH /api/patients/{id} | Receptionist | Session |
| S3R (Check-in Monitor) | GET /api/checkins/{id} + WebSocket | Receptionist | Session |
| S3R (Polling fallback) | GET /api/checkins/{id}/poll | Receptionist | Session |
| S3P (Confirm Info) | GET /api/checkins/token/{t} + WebSocket | Patient | Token |
| S3P (Section action) | PATCH /api/checkins/token/{t}/sections/{s} | Patient | Token |
| S3P (Photo upload) | POST .../sections/{s}/upload, GET .../ocr/{id} | Patient | Token |
| S3P (Complete) | POST /api/checkins/token/{t}/complete | Patient | Token |
| S4 (Complete — kiosk) | POST /api/checkins/{id}/finalize | Receptionist | Session |
| S4 (Complete — mobile) | — (client-only, data already submitted) | Patient | — |
| S5 (Queue) | GET /api/checkins/queue | Receptionist | Session |
| S6 (Identity Verify) | POST /api/precheckin/{t}/verify | Patient | Link token |
| S7 (Link Landing) | GET /api/precheckin/{t} | Patient | Link token |
| S8 (Conflict) | GET /api/checkins/{id}/conflict, POST .../resolve-conflict | Receptionist | Session |
| S9 (Recovery) | GET /admin/sessions/conflicts, POST .../recover | Admin | Session |
| S10 (Import Dashboard) | GET /admin/import/batches/{id} | Admin | Session |
| S11 (Duplicate Review) | GET /admin/import/duplicates | Admin | Session |
| S12 (Merge Resolution) | POST /admin/import/duplicates/{id}/resolve | Admin | Session |
| S13 (Paper Entry) | POST /admin/import/paper-entry | Admin | Session |

---

## Event Chain (complete)

```
patient.created / patient.updated / patient.merged / patient.imported
  -> Search Service: rebuild index entry
  -> Audit Service: log change
  -> Cache: invalidate patient:{id}:summary

checkin.created
  -> WebSocket Server: open channel for session
  -> Cache: create checkin:{id}:state

checkin.section.updated
  -> WebSocket Server -> Receptionist UI: live section status
  -> Cache: update checkin:{id}:state

checkin.patient.complete
  -> WebSocket Server -> Receptionist UI: enable "Complete Check-in"
  -> Cache: update checkin:{id}:state

checkin.finalized
  -> Patient Service: apply staged updates -> patient.updated (cascade)
  -> WebSocket Server: close channel
  -> Cache: invalidate checkin:{id}:state
  -> Access token invalidated

checkin.expired (hard TTL)
  -> WebSocket Server: notify both actors, close channel
  -> Cache: invalidate checkin:{id}:state
  -> Access token invalidated
  -> Staged data preserved in checkin_sections (not deleted)

checkin.conflict (S-07)
  -> session_conflicts record created
  -> WebSocket -> losing receptionist: conflict notification
  -> Admin notification (if configured)

import.record.processed (S-10)
  -> S10 dashboard: progress updated
  -> If imported: patient.imported event (cascade to search index)
  -> If duplicate: available in S11 review queue

ocr.completed (S-08)
  -> Check-in Service: OCR result available for polling
  -> WebSocket -> receptionist: photo.uploaded with thumbnail

pre_checkin.link.generated (S-03)
  -> Notification Service: send SMS/email
  -> pre_checkin_links.status -> 'sent'
```

---

## Upstream Dependencies (things PM/Design/QA/DevOps should know)

| ID | What | Who | Status |
|----|------|-----|--------|
| BOX-E1 | Per-section persist = ~100ms latency per tap | Design | Acknowledged |
| BOX-E2 | Patient URL is one-shot, no bookmarking | PM | Acknowledged |
| BOX-E3 | Receptionist finalization is a review gate | Design | Acknowledged |
| BOX-E4 | Search results lag up to 2s | Design | Acknowledged |
| BOX-E5 | Concurrent prevention is cross-location | PM, Design | S-05 confirmed |
| BOX-E6 | Medications completion enforced server-side | QA | New — needs verification test |
| BOX-E7 | OCR is async, 2-10s latency | Design | New — client must handle spinner + fallback |
| BOX-E8 | Import is idempotent on source_id | QA, DevOps | New — needs verification |
| BOX-E9 | Finalization is atomic (single transaction) | DevOps, QA | Matches BOX-O1 |
| HIPAA | Encryption at rest + 7-year audit retention | PM | Confirmed |
| S-09 | Connection pool: 50 primary + 20 replica | DevOps | New — needs provisioning |
| S-09 | Check-in Service must be horizontally scalable | DevOps | New — stateless, behind LB |
| S-10 | Import throttled at 10/s, pauses during peak | DevOps | New — needs monitoring |
| S-10 | Search index grows by ~4,000 records | DevOps | New — index sizing |
