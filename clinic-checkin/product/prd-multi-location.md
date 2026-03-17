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
