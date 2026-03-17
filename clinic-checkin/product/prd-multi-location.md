# PRD: Multi-Location Support

## Problem
The clinic is opening a second location next month. Some patients will visit both. Today, patient data is implicitly single-location. If a patient visits Location B, they'd need to re-enter everything — defeating the core value of the check-in system.

## Users
- **Patients** who may visit more than one clinic location
- **Receptionists** who work at a specific location and need to see their location's patients
- **Clinic administrators** who need oversight across all locations

## Solution
Centralized patient records accessible from any location. Each location has its own kiosks and staff, but patient data is shared. Staff views are location-filtered by default but can search across locations when needed.

## Requirements

**Must have:**
- Single patient record across all locations — no location-specific copies
- Changes at one location immediately visible at all others
- Kiosks are associated with a specific location
- Receptionist dashboard defaults to current location's appointments
- Appointments are location-specific (patient books at Location A or B)
- Staff permissions are scoped per location (receptionist at A sees A's queue by default)

**Should have:**
- Cross-location search for staff (receptionist can look up a patient from the other location)
- Admin dashboard with cross-location view (all locations' check-in status)
- Location selector in mobile check-in (patient confirms which location they're visiting)

**Won't have (for now):**
- Offline mode for locations with connectivity issues
- Location-specific clinical workflows (all locations follow the same check-in flow)
- Inter-location transfers mid-visit

## Technical considerations
- Decision DEC-005: centralized database, not replication. See decision log.
- Performance: adding locations increases concurrent load. Current peak is 30 at one location. With two locations, plan for 50+ concurrent (see US-006 and DEC-007).
- The data model must support location as a dimension on appointments, kiosks, and staff — but not on patient records.

## Dependencies
- Core check-in (E1) must be stable — bugs from Rounds 2, 4, 7 must be fixed first
- Second location opens next month — timeline is tight

## Risks
- **Network dependency:** All locations depend on connectivity to the central system. Mitigation: cloud-hosted with high availability, read replicas for resilience.
- **Timeline:** One month to go-live. Mitigation: scope to must-haves only for launch. Admin dashboard and cross-location search can follow.
- **Staff training:** Staff at Location B are new. Mitigation: same system, same flows — training burden is the system itself, not a different system.

## Success metrics
- Patients visiting Location B see their pre-populated data on first visit (zero re-entry)
- No increase in check-in errors or support requests after Location B opens
- Staff at both locations report the system works identically

---

## Traceability

| Link type | References |
|-----------|------------|
| Epic | [E3: Multi-Location Support](epics.md#e3-multi-location-support) |
| User Stories | [US-009: Cross-location patient record access](user-stories.md#us-009-cross-location-patient-record-access), [US-010: Location-aware check-in](user-stories.md#us-010-location-aware-check-in) |
| Decisions | [DEC-005: Centralized patient record](decision-log.md#dec-005-centralized-patient-record-for-multi-location-not-syncreplicate), [DEC-007: Performance target](decision-log.md#dec-007-performance-target--50-concurrent-sessions-p95-under-3-seconds) |
| Architecture | [ADR-005: Centralized Database](../architecture/adrs.md#adr-005-centralized-database-for-multi-location-no-replication) |
| Screens | [2.1 Receptionist Dashboard](../experience/screen-specs.md#21-receptionist-dashboard--main-view) (location selector, multi-location behavior) |
| Flows | [Flow 11: Multi-Location Check-In](../experience/user-flows.md#11-multi-location-check-in), [Flow 12: Mobile Multi-Location](../experience/user-flows.md#12-mobile-check-in--multi-location) |
| API | [GET /dashboard/queue](../architecture/api-spec.md#get-dashboardqueue) (location_id filter), [POST /checkins](../architecture/api-spec.md#post-checkins) (location_id), [WebSocket /ws/dashboard/{location_id}](../architecture/api-spec.md#websocket-wsdashboardlocation_id) |
| Tests | [TC-501](../quality/test-suites.md#tc-501-cross-location-patient-record--data-consistency), [TC-502](../quality/test-suites.md#tc-502-location-aware-kiosk), [TC-503](../quality/test-suites.md#tc-503-receptionist--location-filter-and-search), [TC-504](../quality/test-suites.md#tc-504-mobile-check-in--location-displayed) |
