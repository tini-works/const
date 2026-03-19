## US-ABRD603 — Service lookup must filter by KV region

| Field | Value |
|-------|-------|
| **ID** | US-ABRD603 |
| **Traced from** | [ABRD603](../compliances/SV/ABRD603.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E1: Billing Documentation](../epics/E1-billing-documentation.md) |
| **Data Entity** | SVC, BST |

### User Story

As a practice doctor, I want service lookup filter by KV region, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Praxis in KV-Region X, when the user searches Leistungen, then only services valid for that KV-Region are shown

### Actual Acceptance Criteria

1. The `billing_kv.GetGroupEABServiceCode` retrieves KV-specific service codes grouped by region.
2. The `point_value.GetPointValues` and `point_value.GetPointValueByYear` provide KV region-specific point values.
3. The timeline service enforces region-scoped service filtering during documentation.
