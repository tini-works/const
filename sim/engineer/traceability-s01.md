# Engineering Traceability — Story 01

Every box, where it lands in the system, and what proves it.

## Data Model Diagram

https://diashort.apps.quickable.co/d/b8e8f816

## Box -> System Mapping

| Box | System Component | Data Entity | API Endpoint(s) | Flow(s) |
|-----|-----------------|-------------|-----------------|---------|
| BOX-01: Patient recognized | Search Service | patients, search_index | GET /patients/search | Flow 1 |
| BOX-02: No re-asking | Check-in Service | checkin_sections (snapshot from patient_data) | GET /checkins/token/{t} | Flow 4 |
| BOX-03: Confirm not re-enter | Check-in Service | checkin_sections | PATCH /checkins/token/{t}/sections/{s} | Flow 4 |
| BOX-04: Recognition experience | Check-in Service | patients.first_name | GET /checkins/token/{t}, POST /checkins/token/{t}/complete | Flow 6 |
| BOX-D1: Graceful failure | Search Service (fuzzy) | patients, search_index | GET /patients/search/fuzzy | Flow 2 |
| BOX-D2: Two actor views | API Gateway (routing) | checkin_sessions, checkin_sections | GET /checkins/{id} vs GET /checkins/token/{t} | Flow 3, 4, 6 |
| BOX-D3: Partial data | Check-in Service | checkin_sections (original_value null) | GET /checkins/token/{t} (existing/missing split) | Flow 5 |
| BOX-E1: No data loss on timeout | Check-in Service | checkin_sections (per-action persist) | POST /checkins/{id}/reinitiate | Flow 7 |
| BOX-E2: Token-scoped access | API Gateway | checkin_sessions.access_token | All /checkins/token/* endpoints | Flow 3 |
| BOX-E3: Staged updates | Check-in + Patient Service | checkin_sections -> patient_data (on finalize only) | POST /checkins/{id}/finalize | Flow 6 |
| BOX-E4: Eventual consistency | Search Service | search_index | (internal: event-driven rebuild) | Flow 1, 8 |
| BOX-E5: Concurrent prevention | Check-in Service (DB constraint) | checkin_sessions (unique partial index) | POST /checkins | Flow 9 |

## Screen -> API Mapping

| Screen | Primary API Call | Actor | Auth |
|--------|-----------------|-------|------|
| S1 (Patient Lookup) | GET /api/patients/search | Receptionist | Session |
| S1b (Assisted Search) | GET /api/patients/search/fuzzy | Receptionist | Session |
| S2 (Patient Summary) | GET /api/patients/{id} | Receptionist | Session |
| S2 (Update Record) | PATCH /api/patients/{id} | Receptionist | Session |
| S3R (Check-in Monitor) | GET /api/checkins/{id} + WebSocket | Receptionist | Session |
| S3P (Confirm Info) | GET /api/checkins/token/{t} + WebSocket | Patient | Token |
| S3P (Section action) | PATCH /api/checkins/token/{t}/sections/{s} | Patient | Token |
| S3P (Complete) | POST /api/checkins/token/{t}/complete | Patient | Token |
| S4 (Complete) | POST /api/checkins/{id}/finalize | Receptionist | Session |

## Event Chain

```
patient.created / patient.updated
  -> Search Service: rebuild index entry
  -> Audit Service: log change

checkin.created
  -> WebSocket Server: open channel for session

checkin.section.updated
  -> WebSocket Server -> Receptionist UI: live section status

checkin.patient.complete
  -> WebSocket Server -> Receptionist UI: enable "Complete Check-in"

checkin.finalized
  -> Patient Service: apply staged updates -> patient.updated (cascade)
  -> WebSocket Server: close channel
  -> Access token invalidated

checkin.expired (hard TTL)
  -> WebSocket Server: notify both actors, close channel
  -> Access token invalidated
  -> Staged data preserved in checkin_sections (not deleted)
```

## Upstream Dependencies (things PM/Design should know about)

| ID | What | Who needs to know | Status |
|----|------|-------------------|--------|
| BOX-E1 | Per-section persist means ~100ms latency per tap | Design | Surfaced in negotiation |
| BOX-E2 | Patient URL is one-shot, no bookmarking | PM | Surfaced in negotiation |
| BOX-E3 | Receptionist finalization is a review gate, not decoration | Design | Surfaced in negotiation |
| BOX-E3 | Unfinalised session policy needed | PM | Open question |
| BOX-E4 | Search results lag up to 2s after record changes | Design | Surfaced in negotiation |
| BOX-E5 | "Already being checked in" state needed on S2 | Design | New state, needs addition to state machine |
| HIPAA | Encryption at rest, audit retention policy | PM | Open question |
