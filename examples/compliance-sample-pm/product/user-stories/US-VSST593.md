## US-VSST593 — The Vertragssoftware must provide a function to document and modify...

| Field | Value |
|-------|-------|
| **ID** | US-VSST593 |
| **Traced from** | [VSST593](../compliances/SV/VSST593.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | PAT |

### User Story

As a practice staff, I want the Vertragssoftware provide a function to document and modify employment data for the current patient: employment status (yes/no), weekly hours, occupation description, occupation type (physical/mental), and related fields, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a patient, when the employment documentation function is opened, then fields for employment status, weekly hours, occupation description, occupation type, and related data are editable and saveable

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/patient_profile`, `api/patient_encounter`

1. **Patient profile management** -- The `patient_profile` API package provides comprehensive patient data management including profile editing.
2. **Gap: Employment data fields** -- The specific fields for employment status (yes/no), weekly hours, occupation description, occupation type (physical/mental) need verification in the patient profile data model. The patient_profile package exists but the employment-specific fields are not confirmed.
