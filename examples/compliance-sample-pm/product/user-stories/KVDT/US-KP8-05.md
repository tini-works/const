## US-KP8-05 — 1ClickBilling for Hybrid-DRGs via KIM

| Field | Value |
|-------|-------|
| **ID** | US-KP8-05 |
| **Traced from** | [KP8-05](../../compliances/KVDT/KP8-05.md) |
| **Source** | KVDT v6.06 |
| **Status** | Draft |
| **Matched by** | Design: [c3-104](../../../.c3/c3-1-backend/c3-104-billing-system.md) · Engineer: [c3-109](../../../.c3/c3-1-backend/c3-109-billing-subsystems.md) · API: [c3-202](../../../.c3/c3-2-frontend/c3-202-hermes-bff.md) |
| **Proven by** | — |
| **Confirmed by** | — |
| **Epic** | — |
| **Data Entity** | Abrechnung, Konnektor |

### User Story

As an **Abrechnungsverantwortliche**, I want **a function for transmitting Hybrid-DRG billing via KIM using the 1ClickHybridDRG procedure**,
so that **Hybrid-DRG billing can be submitted electronically to the Kassenaerztliche Vereinigung**.

### Compliance Context

Starting from Q1 2025, 1ClickHybridDRG can be used via KIM for transmitting Hybrid-DRG billing, provided the respective KV supports the procedure. Without this function, practices must rely on alternative submission methods which may not be available in all regions.

### Acceptance Criteria

**Scenario 1: 1ClickHybridDRG functions available**
Given Hybrid-DRG billing is implemented
And the respective Kassenaerztliche Vereinigung supports the 1ClickHybridDRG procedure
When the user accesses the Hybrid-DRG billing transmission
Then the software must provide the functions for billing Hybrid-DRG services in accordance with "1ClickHybridDRG" in the latest current version [Spezifikation_1ClickHybridDRG]

### Traceability

- **Traced from:** [KP8-05](../../compliances/KVDT/KP8-05.md)
- **Matched by:**
  - Design: [c3-104 Billing System](../../../.c3/c3-1-backend/c3-104-billing-system.md)
  - Engineer: [c3-109 Billing Subsystems](../../../.c3/c3-1-backend/c3-109-billing-subsystems.md)
  - API: [c3-202 Hermes BFF](../../../.c3/c3-2-frontend/c3-202-hermes-bff.md)
- **Proven by:** —
- **Verification:** **unverified** — no test cases defined yet.
- **Confirmed by:** —
