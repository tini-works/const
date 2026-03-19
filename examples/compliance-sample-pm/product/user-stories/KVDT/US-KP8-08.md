## US-KP8-08 — Notice Regarding the "Service Start Date" (FK 5028) and "Service End Date" (FK 5029) Fields

| Field | Value |
|-------|-------|
| **ID** | US-KP8-08 |
| **Traced from** | [KP8-08](../../compliances/KVDT/KP8-08.md) |
| **Source** | KVDT v6.06 |
| **Status** | Draft |
| **Matched by** | Design: [c3-104](../../../.c3/c3-1-backend/c3-104-billing-system.md) · Engineer: [c3-109](../../../.c3/c3-1-backend/c3-109-billing-subsystems.md) · API: [c3-202](../../../.c3/c3-2-frontend/c3-202-hermes-bff.md) |
| **Proven by** | — |
| **Confirmed by** | — |
| **Epic** | — |
| **Data Entity** | Leistung, Abrechnung |

### User Story

As an **Abrechnungsverantwortliche**, I want **the system to warn me when the difference between Service Start Date (FK 5028) and Service End Date (FK 5029) exceeds 2 days for a Hybrid-DRG service**,
so that **I am aware the service will not be grouped into a Hybrid-DRG and can take corrective action**.

### Compliance Context

In outpatient treatment, the start and end dates of a Hybrid-DRG service may not be more than two days apart. Once the difference exceeds two days, no Hybrid-DRG grouping occurs, and the service cannot be reimbursed as a Hybrid-DRG. The bed-day calculation counts the admission day and each additional day, excluding the discharge day.

### Acceptance Criteria

**Scenario 1: Warning when date difference exceeds 2 days**
Given the user is recording Hybrid-DRG services
When the difference between the date in field 5029 (Service End Date) and field 5028 (Service Start Date) is greater than 2
Then the software must display a warning message indicating that for Hybrid-DRG services, the start and end dates may not be more than two days apart

**Scenario 2: No warning for valid date ranges** [derived]
Given the user is recording Hybrid-DRG services
When the difference between Service End Date and Service Start Date is 2 days or less (e.g., admission 17.02.2026, discharge 19.02.2026)
Then no warning is displayed

### Traceability

- **Traced from:** [KP8-08](../../compliances/KVDT/KP8-08.md)
- **Matched by:**
  - Design: [c3-104 Billing System](../../../.c3/c3-1-backend/c3-104-billing-system.md)
  - Engineer: [c3-109 Billing Subsystems](../../../.c3/c3-1-backend/c3-109-billing-subsystems.md)
  - API: [c3-202 Hermes BFF](../../../.c3/c3-2-frontend/c3-202-hermes-bff.md)
- **Proven by:** —
- **Verification:** **unverified** — no test cases defined yet.
- **Confirmed by:** —
