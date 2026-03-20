## US-P2.6-10 — Exclusion of Other Cost Carriers

| Field | Value |
|-------|-------|
| **ID** | US-P2.6-10 |
| **Traced from** | [P2.6-10](../../compliances/KVDT/P2.6-10.md) |
| **Source** | KVDT v6.06 |
| **Status** | Draft |
| **Matched by** | Design: [c3-104](../../../.c3/c3-1-backend/c3-104-billing-system.md) · Engineer: [c3-109](../../../.c3/c3-1-backend/c3-109-billing-subsystems.md) · API: [c3-202](../../../.c3/c3-2-frontend/c3-202-hermes-bff.md) |
| **Proven by** | — |
| **Confirmed by** | — |
| **Epic** | — |
| **Data Entity** | Abrechnung, Schein, Formular |

### User Story

As a **System**, The system must prevent spa physician billing (KADT) with Other Cost Carriers via KVDT while still allowing form printing,
so that spa physician services are correctly billed directly with the cost carrier rather than through an invalid KVDT path.

### Compliance Context

Spa physician billing with Other Cost Carriers is not possible via KVDT. If the system allowed such billing, it would be rejected, causing delays and financial issues. The regulation ensures that direct billing with the cost carrier is enforced for these cases.

### Acceptance Criteria

**Scenario 1: Warning issued for KADT billing with Other Cost Carriers** [derived]
Given a spa physician billing is to be processed via an Other Cost Carrier
When the user attempts to create a KADT billing
Then the system issues a WARNING that billing with Other Cost Carriers via KVDT is not possible

**Scenario 2: Further KADT processing blocked for Other Cost Carriers** [derived]
Given a spa physician billing is to be processed via an Other Cost Carrier
When the warning has been displayed
Then further processing for the purpose of KADT billing with Other Cost Carriers is not possible

**Scenario 3: Form printing remains possible with Other Cost Carriers** [derived]
Given a spa physician case involves an Other Cost Carrier
When the user requests printing of contract physician forms
Then the software allows printing of contract physician forms with Other Cost Carriers

### Traceability

- **Traced from:** [P2.6-10](../../compliances/KVDT/P2.6-10.md)
- **Matched by:**
  - Design: [c3-104 Billing System](../../../.c3/c3-1-backend/c3-104-billing-system.md)
  - Engineer: [c3-109 Billing Subsystems](../../../.c3/c3-1-backend/c3-109-billing-subsystems.md)
  - API: [c3-202 Hermes BFF](../../../.c3/c3-2-frontend/c3-202-hermes-bff.md)
- **Code:** no code match found
- **Proven by:** —
- **Verification:** **unverified** — no test cases defined yet.
- **Confirmed by:** —
