# UnMatching: service_domains

## File
`backend-core/service/domains/`

## Analysis
- **What this code does**: Contains the main entry point for the domains microservice, which hosts all shared domain services. Initializes configuration defaults for MongoDB, MinIO, HPM, Redis, authentication, PDF generation, XSL transformation, and other infrastructure. This is the deployable binary that runs the domain services.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [ ] Create new User Story for this functionality
- [x] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

## Classification
- [x] This is infrastructure/utility code (no story needed)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-DOMAINS — Domain Services Application Host and Configuration

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-DOMAINS |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5=Practice Software Core |
| **Data Entity** | Application, Configuration (MongoDB, MinIO, HPM, Redis, Auth, PDF, XSL) |

### User Story
As a system operator, I want a deployable microservice binary that initializes and hosts all shared domain services with proper infrastructure configuration, so that domain services for billing, enrollment, patient management, catalogs, and more are available to the application layer via NATS RPC.

### Acceptance Criteria
1. Given the domains service starts, when configuration is loaded, then default values for MongoDB, MinIO, HPM, Redis, authentication, PDF generation, and XSL transformation are properly initialized
2. Given all domain service modules, when the application bootstraps, then all service APIs (billing, enrollment, patient, catalog, profile, feature flags, hooks, etc.) are registered and accessible
3. Given the domains service is running, when health checks are performed, then the service reports its availability status

### Technical Notes
- Source: `backend-core/service/domains/`
- Key functions: application.go (bootstrap), API registrations for billing, enrollment, patient, patient_participation, patient_overview, catalog_overview, feature_flag, hooks, doctor_participate, eeb, epa, evdga, bmp, profile, admin_service, sysadmin, ptv_import, referral_data
- Integration points: All domain service modules, Titan NATS framework, MongoDB, MinIO, Redis, HPM, PDF generation, XSL transformation, Hestia socket services
