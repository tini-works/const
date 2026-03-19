## US-KP8-02 — Encoding of Primary and Secondary Diagnoses

| Field | Value |
|-------|-------|
| **ID** | US-KP8-02 |
| **Traced from** | [KP8-02](../../compliances/KVDT/KP8-02.md) |
| **Source** | KVDT v6.06 |
| **Status** | Draft |
| **Matched by** | Design: [c3-104](../../../.c3/c3-1-backend/c3-104-billing-system.md) · Engineer: [c3-109](../../../.c3/c3-1-backend/c3-109-billing-subsystems.md) · API: [c3-202](../../../.c3/c3-2-frontend/c3-202-hermes-bff.md) |
| **Proven by** | — |
| **Confirmed by** | — |
| **Epic** | — |
| **Data Entity** | Diagnose, Abrechnung |

### User Story

As the **System**, the system must **validate that ICD-10-GM codes for Hybrid-DRG primary and secondary diagnoses are terminal, exist in the master data, and include at least one primary code**,
so that **Hybrid-DRG billing data meets ICD-10-GM coding guidelines and German Coding Directives (DKR)**.

### Compliance Context

ICD-10-GM coding guidelines require terminal (most specific) codes and mandate that secondary codes cannot stand alone without a primary code. Non-terminal or missing primary codes in Hybrid-DRG billing will be rejected, delaying reimbursement.

### Acceptance Criteria

**Scenario 1: ICD-10-GM code existence validation**
Given the user enters an ICD-10-GM code for primary diagnosis (FK 6009) or secondary diagnosis (FK 6011)
When the system validates the code
Then the code must exist in the ICD-10-GM master data file [SDICD] (XML element `../diagnosen_liste/diagnose/icd-code/@V`)

**Scenario 2: At least one primary code required**
Given only ICD codes with notation markers (*) or (!) are present
When the system validates the diagnosis coding
Then the software must generate a notice that specifying a primary code is required
And prevent the transfer of exclusively secondary codes into the billing file

**Scenario 3: Non-terminal ICD-10-GM code rejected**
Given the user enters an ICD-10-GM code ending with "-"
When the system validates the code
Then the software must generate a notice that the code is not terminal and may not be used for billing
And prevent the transfer of the non-terminal code into the billing file

### Traceability

- **Traced from:** [KP8-02](../../compliances/KVDT/KP8-02.md)
- **Matched by:**
  - Design: [c3-104 Billing System](../../../.c3/c3-1-backend/c3-104-billing-system.md)
  - Engineer: [c3-109 Billing Subsystems](../../../.c3/c3-1-backend/c3-109-billing-subsystems.md)
  - API: [c3-202 Hermes BFF](../../../.c3/c3-2-frontend/c3-202-hermes-bff.md)
- **Proven by:** —
- **Verification:** **unverified** — no test cases defined yet.
- **Confirmed by:** —
