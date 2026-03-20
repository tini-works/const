## US-KP8-01 — Support for Record Type HDRG of the KVDT Data Set Description

| Field | Value |
|-------|-------|
| **ID** | US-KP8-01 |
| **Traced from** | [KP8-01](../../compliances/KVDT/KP8-01.md) |
| **Source** | KVDT v6.06 |
| **Status** | Draft |
| **Matched by** | Design: [c3-104](../../../.c3/c3-1-backend/c3-104-billing-system.md) · Engineer: [c3-109](../../../.c3/c3-1-backend/c3-109-billing-subsystems.md) · API: [c3-202](../../../.c3/c3-2-frontend/c3-202-hermes-bff.md) |
| **Proven by** | — |
| **Confirmed by** | — |
| **Epic** | — |
| **Data Entity** | Abrechnung, Leistung |

### User Story

As an **Abrechnungsverantwortliche**, I want **the software to support entry and population of the data fields defined in the HDRG record type per the defined structure**,
so that **Hybrid-DRG billing files comply with the KVDT data set description**.

### Compliance Context

Hybrid-DRG billing requires a specific record type (HDRG) with defined data fields. Without correct support for this record type, the practice cannot generate compliant billing files for Hybrid-DRG services, leading to reimbursement failure.

### Acceptance Criteria

**Scenario 1: Manual entry and automatic population of HDRG fields**
Given Hybrid-DRG billing is implemented
When the user enters or the system populates data for the HDRG record type
Then the software must support manual entry of all defined fields
And support automatic population where data can be automatically filled (e.g., from read-in cards or master data)
And compliance with rules and cardinalities is ensured by the software

### Traceability

- **Traced from:** [KP8-01](../../compliances/KVDT/KP8-01.md)
- **Matched by:**
  - Design: [c3-104 Billing System](../../../.c3/c3-1-backend/c3-104-billing-system.md)
  - Engineer: [c3-109 Billing Subsystems](../../../.c3/c3-1-backend/c3-109-billing-subsystems.md)
  - API: [c3-202 Hermes BFF](../../../.c3/c3-2-frontend/c3-202-hermes-bff.md)
- **Code:** no code match found — Hybrid-DRG (HDRG) record type support is not yet implemented in the codebase.
- **Proven by:** —
- **Verification:** **unverified** — no test cases defined yet.
- **Confirmed by:** —
