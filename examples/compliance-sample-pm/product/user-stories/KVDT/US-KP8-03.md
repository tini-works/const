## US-KP8-03 — OPS Codes for Hybrid-DRG Services

| Field | Value |
|-------|-------|
| **ID** | US-KP8-03 |
| **Traced from** | [KP8-03](../../compliances/KVDT/KP8-03.md) |
| **Source** | KVDT v6.06 |
| **Status** | Draft |
| **Matched by** | Design: [c3-104](../../../.c3/c3-1-backend/c3-104-billing-system.md) · Engineer: [c3-109](../../../.c3/c3-1-backend/c3-109-billing-subsystems.md) · API: [c3-202](../../../.c3/c3-2-frontend/c3-202-hermes-bff.md) |
| **Proven by** | — |
| **Confirmed by** | — |
| **Epic** | — |
| **Data Entity** | Leistung, Abrechnung, Stammdaten |

### User Story

As the **System**, the system must **ensure that each Hybrid-DRG service includes at least one valid OPS code from the master data file, with correct side localization when required**,
so that **Hybrid-DRG billing contains properly coded operations per OPS standards**.

### Compliance Context

Hybrid-DRG services must always be coded with an official OPS code. Missing or invalid OPS codes will prevent grouping into a Hybrid-DRG, causing billing rejection and reimbursement delays.

### Acceptance Criteria

**Scenario 1: At least one OPS code per Hybrid-DRG service**
Given the user records a Hybrid-DRG service (FK 5027)
When the billing data is prepared
Then at least one OPS code must be transmitted in FK 5035

**Scenario 2: OPS code existence and validity check**
Given the user enters an OPS code for a Hybrid-DRG service
When the system validates the code
Then the OPS code must exist in the OPS master data file (XML element `../opscode_liste/opscode/@V`)
And the OPS code must still be valid (date within the validity period of `../opscode_liste/opscode/gueltigkeit/@V`)

**Scenario 3: Side localization requested when required**
Given the entered OPS code is defined in the master data file with side localization (`../opscode_liste/opscode/kzseite/@V="J"`)
When the system processes the code
Then the system must request the side localization from the user
And suggest the corresponding side localizations for selection
And transfer the side localization specification in FK 5041

### Traceability

- **Traced from:** [KP8-03](../../compliances/KVDT/KP8-03.md)
- **Matched by:**
  - Design: [c3-104 Billing System](../../../.c3/c3-1-backend/c3-104-billing-system.md)
  - Engineer: [c3-109 Billing Subsystems](../../../.c3/c3-1-backend/c3-109-billing-subsystems.md)
  - API: [c3-202 Hermes BFF](../../../.c3/c3-2-frontend/c3-202-hermes-bff.md)
- **Code:** no code match found — Hybrid-DRG OPS code validation (FK 5027, FK 5035 in HDRG context) is not yet implemented. General OPS services exist at:
  - [`ares/service/domains/sdops/sdops_service/sdops_service.go`](../../../../ares/service/domains/sdops/sdops_service/sdops_service.go) — OPS code lookup/validation (may serve as foundation)
  - [`ares/service/timeline_validation/service/validation_timeline/validations/service_code/kv/precondition/kv.service.include.ops.validator.go`](../../../../ares/service/timeline_validation/service/validation_timeline/validations/service_code/kv/precondition/kv.service.include.ops.validator.go) — Existing OPS/laterality validation for KV billing
- **Proven by:** —
- **Verification:** **unverified** — no test cases defined yet.
- **Confirmed by:** —
