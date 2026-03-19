## ASTH-6.1.9-04 — Behandlungsplanung must capture Therapieanpassung

| Field | Value |
|-------|-------|
| **ID** | ASTH-6.1.9-04 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Section** | Sec 6.1.9 — Behandlungsplanung |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-ASTH-6.1.9-04](../../../../../user-stories/eDMP_HKS/US-ASTH-6.1.9-04.md) |

### Requirement

As a practice doctor, I want to document therapy adjustments (Therapieanpassung) in the treatment planning section, so that changes to the patient's treatment plan are recorded per eDMP Asthma requirements.

### Acceptance Criteria

1. Given an eDMP Asthma Behandlungsplanung section is displayed, when Therapieanpassung is presented, then the doctor can document the therapy adjustment decision
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised
