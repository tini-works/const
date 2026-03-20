## US-KP8-07 — Notice Regarding the "Anesthesia Hours" Field (FK 5030)

| Field | Value |
|-------|-------|
| **ID** | US-KP8-07 |
| **Traced from** | [KP8-07](../../compliances/KVDT/KP8-07.md) |
| **Source** | KVDT v6.06 |
| **Status** | Draft |
| **Matched by** | Design: [c3-104](../../../.c3/c3-1-backend/c3-104-billing-system.md) · Engineer: [c3-109](../../../.c3/c3-1-backend/c3-109-billing-subsystems.md) · API: [c3-202](../../../.c3/c3-2-frontend/c3-202-hermes-bff.md) |
| **Proven by** | — |
| **Confirmed by** | — |
| **Epic** | — |
| **Data Entity** | Leistung, Abrechnung |

### User Story

As an **Abrechnungsverantwortliche**, I want **the system to warn me when anesthesia hours greater than zero are entered for a Hybrid-DRG service**,
so that **I understand the service will not be reimbursed as a Hybrid-DRG and can correct the entry if needed**.

### Compliance Context

Services containing anesthesia hours are classified as DRG (not Hybrid-DRG) services and will not be grouped or reimbursed as Hybrid-DRGs. Without this warning, the user may unknowingly submit a billing file with services that will be rejected.

### Acceptance Criteria

**Scenario 1: Warning for anesthesia hours greater than zero**
Given the user is recording Hybrid-DRG services
When the user enters a value greater than "0" in field 5030 (Anesthesia hours)
Then the software must display a warning message indicating:
And that Hybrid-DRG services including anesthesia hours will not be reimbursed as a Hybrid-DRG service, because no Hybrid-DRG applies
And that anesthesia times occurring during anesthesia are not to be specified in the billing

### Traceability

- **Traced from:** [KP8-07](../../compliances/KVDT/KP8-07.md)
- **Matched by:**
  - Design: [c3-104 Billing System](../../../.c3/c3-1-backend/c3-104-billing-system.md)
  - Engineer: [c3-109 Billing Subsystems](../../../.c3/c3-1-backend/c3-109-billing-subsystems.md)
  - API: [c3-202 Hermes BFF](../../../.c3/c3-2-frontend/c3-202-hermes-bff.md)
- **Code:** no code match found — Hybrid-DRG anesthesia hours warning (FK 5030) is not yet implemented.
- **Proven by:** —
- **Verification:** **unverified** — no test cases defined yet.
- **Confirmed by:** —
