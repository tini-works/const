## ASTH-6.1.9-03 — Behandlungsplanung must capture Schriftlicher Selbstmanagementplan

| Field | Value |
|-------|-------|
| **ID** | ASTH-6.1.9-03 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Section** | Sec 6.1.9 — Behandlungsplanung |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-ASTH-6.1.9-03](../../../../../user-stories/eDMP_HKS/US-ASTH-6.1.9-03.md) |

### Requirement

As a practice doctor, I want to document whether a written self-management plan (Schriftlicher Selbstmanagementplan) was provided to the patient, so that patient empowerment measures are tracked per eDMP Asthma requirements.

### Acceptance Criteria

1. Given an eDMP Asthma Behandlungsplanung section is displayed, when Schriftlicher Selbstmanagementplan is presented, then the doctor can indicate whether a plan was provided
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised
