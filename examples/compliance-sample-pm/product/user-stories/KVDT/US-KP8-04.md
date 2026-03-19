## US-KP8-04 — Support for Billing File Export

| Field | Value |
|-------|-------|
| **ID** | US-KP8-04 |
| **Traced from** | [KP8-04](../../compliances/KVDT/KP8-04.md) |
| **Source** | KVDT v6.06 |
| **Status** | Draft |
| **Matched by** | Design: [c3-104](../../../.c3/c3-1-backend/c3-104-billing-system.md) · Engineer: [c3-109](../../../.c3/c3-1-backend/c3-109-billing-subsystems.md) · API: [c3-202](../../../.c3/c3-2-frontend/c3-202-hermes-bff.md) |
| **Proven by** | — |
| **Confirmed by** | — |
| **Epic** | — |
| **Data Entity** | Abrechnung |

### User Story

As an **Abrechnungsverantwortliche**, I want **to generate a Hybrid-DRG billing file at any time, with case selection, validation, encryption, and the ability to view the output path**,
so that **Hybrid-DRG billing can be submitted independently of the quarterly reference period**.

### Compliance Context

Hybrid-DRG billing is not linked to the quarterly billing cycle and must be possible at any point in time. The billing file must be validated against the KVDT validation module and encrypted with the XKM before submission to ensure data integrity and compliance.

### Acceptance Criteria

**Scenario 1: On-demand billing file creation**
Given Hybrid-DRG billing cases exist
When the user initiates billing file creation
Then the software must allow creation at any time
And the user can select which Hybrid-DRG billing cases to include

**Scenario 2: Validation and encryption of billing file**
Given the billing file has been generated
When the software processes the file
Then the generated billing data (record type Hybrid-DRG) must be validated against the latest KVDT validation module
And after successful validation, the billing file must be encrypted with the "Hybrid-DRG" mode of the XKM in the latest version and with the latest key
And the billed billing cases must be marked accordingly in the software

**Scenario 3: User can view billing file path**
Given a billing file has been generated
When the user requests the file location
Then the software must display the path of the generated billing file

### Traceability

- **Traced from:** [KP8-04](../../compliances/KVDT/KP8-04.md)
- **Matched by:**
  - Design: [c3-104 Billing System](../../../.c3/c3-1-backend/c3-104-billing-system.md)
  - Engineer: [c3-109 Billing Subsystems](../../../.c3/c3-1-backend/c3-109-billing-subsystems.md)
  - API: [c3-202 Hermes BFF](../../../.c3/c3-2-frontend/c3-202-hermes-bff.md)
- **Proven by:** —
- **Verification:** **unverified** — no test cases defined yet.
- **Confirmed by:** —
