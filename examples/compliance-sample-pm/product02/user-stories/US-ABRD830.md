## US-ABRD830 — Service lookup must filter by IK group

| Field | Value |
|-------|-------|
| **ID** | US-ABRD830 |
| **Traced from** | [ABRD830](../compliances/SV/ABRD830.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want service lookup filter by IK group, so that billing documentation is compliant and audit-ready.

### Acceptance Criteria

1. Given a Leistungssuche, when the Patient belongs to an IK-Gruppe, then only services valid for that IK-Gruppe are returned

### Actual Acceptance Criteria

1. The `billing_kv.GetGroupEABServiceCode` retrieves service codes with IK group filtering.
2. The `billing.GetContractTypeByIds` provides IK group associations.
3. The timeline service supports filtering by IK group membership.
