## US-ABRD920 — Preventive treatment cases must be marked

| Field | Value |
|-------|-------|
| **ID** | US-ABRD920 |
| **Traced from** | [ABRD920](../compliances/SV/ABRD920.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E1: Billing Documentation](../epics/E1-billing-documentation.md) |
| **Data Entity** | BF, SVC |

### User Story

As a practice doctor, I want preventive treatment cases is marked, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Vorsorge-Behandlungsfall, when created, then it is flagged with the Vorsorge marker

### Actual Acceptance Criteria

1. The `schein.CreateSvScheins` and `schein.CreateSchein` support Vorsorge-flagged treatment cases.
2. The `billing_kv.MakeScheinBill` processes Vorsorge scheins in billing data.
3. The timeline supports treatment case categorization.
