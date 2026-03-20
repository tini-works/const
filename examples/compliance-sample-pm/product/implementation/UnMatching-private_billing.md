# UnMatching: private_billing

## File
`backend-core/app/app-core/api/private_billing/`

## Analysis
- **What this code does**: Provides comprehensive private patient billing (Privatabrechnung/GOA) management. Supports listing billings with search/filter/pagination, retrieving billing by ID or Schein ID, updating billing doctor assignments, managing payment status (mark as paid, partially paid, unpaid, cancelled), toggling review status, retrieving printed invoices and bulk GOA service timelines, and filtering by doctor, insurance, status, and amount range. Subscribes to patient profile change events to keep billing records synchronized.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-PRIVATE_BILLING — Private Patient Billing (GOA) Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-PRIVATE_BILLING |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E1=Billing Documentation |
| **Data Entity** | PrivateBilling, PrivateBillingItem, Invoice, Doctor, Insurance, Patient, Timeline |

### User Story
As a medical practice staff member, I want to manage private patient billing (Privatabrechnung/GOA) including listing, filtering, payment tracking, and invoice management, so that the practice can efficiently handle private insurance billing workflows and payment reconciliation.

### Acceptance Criteria
1. Given search, filter, and pagination parameters, when the user lists private billings, then the system returns matching billing records with doctor, insurance, status, and amount details
2. Given a billing ID, when the user retrieves a private billing, then the system returns the complete billing item
3. Given a Schein ID, when the user retrieves private billing by Schein, then the system returns the associated billing record
4. Given a billing and invoice number, when the user marks it as paid, then the billing status is updated and a timeline entry is created
5. Given a billing and partial amount, when the user marks it as partially paid, then the system records the partial payment and updates the billing status
6. Given a paid billing, when the user marks it as unpaid, then the billing status reverts to unpaid
7. Given a billing, when the user marks it as cancelled, then the billing is cancelled
8. Given a billing ID, when the user toggles review status, then the review flag is toggled on/off
9. Given a doctor assignment, when the user updates the billing doctor, then the doctor is reassigned to the affected billing records
10. Given a patient and billing ID, when the user retrieves printed invoices, then the system returns associated timeline models
11. Given multiple billing IDs, when the user requests bulk GOA service timelines, then the system returns timeline and invoice info for each billing
12. Given a patient profile change event, when published, then the private billing records are updated to reflect the new patient data
13. Given filter requests, when the user queries available doctors, insurances, statuses, or amount ranges, then the system returns the applicable filter options

### Technical Notes
- Source: `backend-core/app/app-core/api/private_billing/`
- Key functions: GetPrivateBillings, GetPrivateBillingById, GetPrivateBillingByScheinId, UpdatePrivateBillingDoctor, MarkPrivateBillingPaid, MarkPrivateBillingPartiallyPaid, MarkPrivateBillingUnpaid, MarkPrivateBillingCancelled, ToggleReviewPrivateBilling, GetPrintedInvoices, GetBulkGoaServiceTimelines, OnPatientUpdate, GetListDoctor, GetListInsurance, GetListStatus, GetRangeAmount
- Integration points: `backend-core/service/domains/private_billing/common` (PrivateBillingItem, PrivateBillingFilter), `backend-core/service/domains/timeline/common` (TimelineModel), `backend-core/service/domains/api/patient_profile_common` (EventPatientProfileChange subscriber), `backend-core/service/domains/api/common` (PaginationRequest/Response)
