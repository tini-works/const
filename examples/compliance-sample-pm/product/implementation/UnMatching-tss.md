# UnMatching: tss

## File
`backend-core/app/app-core/api/tss/`

## Analysis
- **What this code does**: Provides the TSS (Terminservicestelle - Appointment Service Center) API for requesting referral codes. Supports two referral code request formats: M6 (specialist group based, with urgency and freetext) and PTV11 (service/procedure based). Integrates with KV appointment service for patient referral code generation.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-TSS — TSS Appointment Service Referral Code Requests

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-TSS |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E8 Integration Services |
| **Data Entity** | ReferralCode, SpecialistGroup, PatientInfo |

### User Story
As a physician, I want to request referral codes from the KV Appointment Service Center (Terminservicestelle) using either the M6 format (specialist group based with urgency) or the PTV11 format (service/procedure based), so that patients can receive timely specialist appointments as mandated by regulation.

### Acceptance Criteria
1. Given specialist group selections, urgency level, LANR, BSNR, KV username, optional freetext, patient info, and data submission confirmation, when the user requests a referral code via M6 format, then a reference code response with message ID and any issues/diagnostics is returned
2. Given service codes, procedure codes, LANR, BSNR, KV username, patient info, and data submission confirmation, when the user requests a referral code via PTV11 format, then a reference code response with message ID and any issues/diagnostics is returned
3. Given the KV appointment service returns errors, when the response contains issues, then diagnostics and error details (code, message) are returned to the caller

### Technical Notes
- Source: `backend-core/app/app-core/api/tss/`
- Key functions: RequestReferralCodeM6, RequestReferralCodePtv11
- Integration points: `service/domains/api/patient_profile_common` (PatientInfo), KV Terminservicestelle external service
- SpecialistGroupType enum: SPECIALITY, SUB_SPECIALITY, PROFESSIONAL_GROUP, ADDITIONAL_QUALIFICATION
- Both endpoints require CARE_PROVIDER_MEMBER role
