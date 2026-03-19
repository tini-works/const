## US-P2.6-20 — Service Documentation via Pseudo Fee Schedule Number 00001U

| Field | Value |
|-------|-------|
| **ID** | US-P2.6-20 |
| **Traced from** | [P2.6-20](../../compliances/KVDT/P2.6-20.md) |
| **Source** | KVDT v6.06 |
| **Status** | Draft |
| **Matched by** | Design: [c3-104](../../../.c3/c3-1-backend/c3-104-billing-system.md) · Engineer: [c3-109](../../../.c3/c3-1-backend/c3-109-billing-subsystems.md) · API: [c3-202](../../../.c3/c3-2-frontend/c3-202-hermes-bff.md) |
| **Proven by** | — |
| **Confirmed by** | — |
| **Epic** | — |
| **Data Entity** | Leistung, Abrechnung, Schein |

### User Story

As an **Abrechnungsverantwortliche**, I want the system to document spa physician service days using pseudo code "00001U",
so that lump-sum spa physician treatments are properly documented without individual service billing.

### Compliance Context

Spa physician billing is lump-sum-based, meaning no individual services are billed. Instead, proof of treatments is provided through service day documentation using the pseudo code "00001U". Failure to use this standardized approach would result in billing rejections.

### Acceptance Criteria

**Scenario 1: Service days documented with pseudo code 00001U** [derived]
Given a spa physician case is being documented
When the user records service days for the spa physician billing
Then each service day is documented with the pseudo code "00001U"
And no individual services are billed separately

**Scenario 2: Intercurrent diseases covered by lump sum** [derived]
Given a spa physician case includes intercurrent diseases or material costs
When the user attempts to document these items
Then the system treats them as covered by the lump-sum arrangement

### Traceability

- **Traced from:** [P2.6-20](../../compliances/KVDT/P2.6-20.md)
- **Matched by:**
  - Design: [c3-104 Billing System](../../../.c3/c3-1-backend/c3-104-billing-system.md)
  - Engineer: [c3-109 Billing Subsystems](../../../.c3/c3-1-backend/c3-109-billing-subsystems.md)
  - API: [c3-202 Hermes BFF](../../../.c3/c3-2-frontend/c3-202-hermes-bff.md)
- **Proven by:** —
- **Verification:** **unverified** — no test cases defined yet.
- **Confirmed by:** —
