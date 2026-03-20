# UnMatching: bg_billing

## File
`backend-core/app/app-core/api/bg_billing/`

## Analysis
- **What this code does**: Provides a BG (Berufsgenossenschaft / occupational insurance) billing management service (BgBillingApp). Supports retrieving billing records by ID or Schein ID, listing billings with search/filter/pagination, managing UV-GOA service codes and timeline data, retrieving printed invoices, and marking billings as paid/unpaid/cancelled. Also provides filter helpers for doctors, insurances, statuses, and price ranges.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-BG_BILLING — Occupational Insurance (BG) Billing Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-BG_BILLING |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E1: Billing Documentation |
| **Data Entity** | BgBillingItem, BillingRecord, UvGoaServiceCode, InvoiceInfo |

### User Story

As a practice staff member, I want to manage occupational insurance (BG) billing records including viewing, filtering, searching, marking payment status, and retrieving UV-GOA service codes and printed invoices, so that I can handle the complete BG billing workflow for occupational injury and illness cases.

### Acceptance Criteria

1. Given an authenticated care provider member, when they request BG billings with search, pagination, and filters, then the system returns matching billing items with total count.
2. Given a valid billing ID, when the user requests a BG billing by ID, then the system returns the complete billing item details.
3. Given a valid Schein ID, when the user requests a BG billing by Schein ID, then the system returns the associated billing record.
4. Given a billing ID, when the user requests UV-GOA service codes, then the system returns service timeline data and invoice information.
5. Given a patient ID and billing ID, when the user requests printed invoices, then the system returns associated timeline models.
6. Given a billing with an invoice number, when the user marks it as paid, then the system updates the billing status and returns the updated timeline model.
7. Given a paid billing, when the user marks it as unpaid, then the system reverts the payment status.
8. Given a billing, when the user marks it as cancelled, then the system updates the billing to cancelled status.
9. Given an authenticated user, when they request filter options, then the system returns available doctors, insurances, statuses, and price ranges for filtering.

### Technical Notes
- Source: `backend-core/app/app-core/api/bg_billing/`
- Key functions: GetBgBilling, GetBgBillingById, GetBgBillingByScheinId, GetUvGoaServiceCode, GetUvGoaServiceCodeByIds, GetPrintedInvoices, MarkBgBillingPaid, MarkBgBillingUnpaid, MarkBgBillingCancelled, GetListDoctor, GetListInsurance, GetListStatus, GetRangeAmount
- Integration points: bg_billing/common (BgBillingItem, BillingRecord), timeline/common (TimelineModel), patient_profile_common (InsuranceInfo)
