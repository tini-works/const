## US-P2.6-30 — KV-Specifika Master File of KV Westfalen-Lippe for Spa Physician Billing

| Field | Value |
|-------|-------|
| **ID** | US-P2.6-30 |
| **Traced from** | [P2.6-30](../../compliances/KVDT/P2.6-30.md) |
| **Source** | KVDT v6.06 |
| **Status** | Draft |
| **Matched by** | Design: [c3-116](../../../.c3/c3-1-backend/c3-116-medical-catalogs.md) · Engineer: [c3-104](../../../.c3/c3-1-backend/c3-104-billing-system.md) · API: [c3-202](../../../.c3/c3-2-frontend/c3-202-hermes-bff.md) |
| **Proven by** | — |
| **Confirmed by** | — |
| **Epic** | — |
| **Data Entity** | Stammdaten, Abrechnung |

### User Story

As a **Praxisadministrator**, I want the system to provide the currently valid KV-Specifika master file of KV Westfalen-Lippe,
so that spa physician billing uses the correct regional billing parameters.

### Compliance Context

Spa physician billing requires region-specific data from KV Westfalen-Lippe. Without access to the currently valid KV-Specifika master file, the practice cannot correctly bill spa physician services, risking rejections and compliance violations.

### Acceptance Criteria

**Scenario 1: KV-Specifika master file data is available** [derived]
Given the user is performing spa physician billing
When the user accesses billing-relevant information
Then the system provides the information from the currently valid KV-Specifika master file of KV Westfalen-Lippe relevant for billing spa physician services

**Scenario 2: Master file is up to date** [derived]
Given a new version of the KV-Specifika master file of KV Westfalen-Lippe has been delivered
When the new quarter begins
Then the system uses the updated master file data for spa physician billing

### Traceability

- **Traced from:** [P2.6-30](../../compliances/KVDT/P2.6-30.md)
- **Matched by:**
  - Design: [c3-116 Medical Catalogs](../../../.c3/c3-1-backend/c3-116-medical-catalogs.md)
  - Engineer: [c3-104 Billing System](../../../.c3/c3-1-backend/c3-104-billing-system.md)
  - API: [c3-202 Hermes BFF](../../../.c3/c3-2-frontend/c3-202-hermes-bff.md)
- **Code:**
  - `ares/service/domains/sdkv/service.go` — SDKV (KV-Specifika) service logic
  - `ares/service/domains/repos/masterdata_repo/sdkv/repo.go` — SDKV master data repository
  - `ares/proto/service/domains/sdkv_common.proto` — SDKV common proto definitions
  - `ares/proto/app/mvz/sdkv.proto` — SDKV app proto
- **Proven by:** —
- **Verification:** **unverified** — no test cases defined yet.
- **Confirmed by:** —
