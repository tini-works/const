## US-ALLG1032 — KVK data records must be converted to eGK format per...

| Field | Value |
|-------|-------|
| **ID** | US-ALLG1032 |
| **Traced from** | [ALLG1032](../compliances/SV/ALLG1032.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E6: General & Documentation](../epics/E6-general-and-documentation.md) |
| **Data Entity** | EGK, PAT |

### User Story

As a practice owner, I want kVK data records is converted to eGK format per current KBV specifications (KBV_ITA_VGEX_Mapping_KVK.pdf), including for late-arriving cases (Nachzuegler), so that general compliance requirements are met.

### Acceptance Criteria

1. Given KVK data records including Nachzuegler cases, when imported, then they are converted to eGK format per current KBV mapping specifications

### Actual Acceptance Criteria

| Status | **Not Implemented** |
|--------|-------------------|

1. A KVK service exists at `backend-core/service/domains/ti_service/companion_service_provider/kvk_service.go`, but it handles KVK card reading, not KVK-to-eGK format conversion.
2. No KVK-to-eGK mapping implementation per KBV_ITA_VGEX_Mapping_KVK.pdf was found.
3. **Gap**: The system does not convert KVK data records to eGK format, including for late-arriving cases (Nachzuegler).
