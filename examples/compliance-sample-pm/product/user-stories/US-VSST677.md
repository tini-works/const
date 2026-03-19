## US-VSST677 — The following DMP must be integrated per KBV specifications: eDMP...

| Field | Value |
|-------|-------|
| **ID** | US-VSST677 |
| **Traced from** | [VSST677](../compliances/SV/VSST677.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want the following DMP is integrated per KBV specifications: eDMP Koronare Herzkrankheit, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given the Vertragssoftware, when DMP functionality is accessed, then eDMP Koronare Herzkrankheit is available per KBV specifications

### Actual Acceptance Criteria

**Implementation Status:** Implemented

**Relevant Codebase Packages:** `api/edmp`, `api/edoku`, `api/billing_edoku`

1. **eDMP KHK** -- The `edmp` package supports multiple DMP types via `DMPLabelingValue`. Koronare Herzkrankheit (KHK) is supported as one of the DMP labeling values.
2. **KBV-compliant documentation** -- The eDMP documentation workflow (CreateDocument, SaveDocumentationOverview, FinishDocumentationOverview, CheckPlausibility) applies to all DMP types including KHK.
