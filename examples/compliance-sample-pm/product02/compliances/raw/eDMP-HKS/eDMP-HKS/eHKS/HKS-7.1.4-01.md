## HKS-7.1.4-01 — Practice doctor must document Patient kommt auf Ueberweisung im Rahmen HKS as Ja or Nein in HKS-D documents

| Field | Value |
|-------|-------|
| **ID** | HKS-7.1.4-01 |
| **Type** | Mandatory |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Section** | Sec 7.1.4 -- HKS-D Ueberweisung |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eHKS Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-HKS-7.1.4-01](../../../../user-stories/eDMP_HKS/US-HKS-7.1.4-01.md) |

### Requirement

As a practice doctor, I want to document whether the patient was referred within the HKS programme (Patient kommt auf Ueberweisung im Rahmen HKS) as Ja or Nein in HKS-D documents, so that the referral pathway is captured for dermatologist screening documentation.

### Acceptance Criteria

1. Given an HKS-D document is created, when Patient kommt auf Ueberweisung im Rahmen HKS is recorded, then exactly one of Ja or Nein is selected
2. Given no value is selected, when validated, then an error is reported
