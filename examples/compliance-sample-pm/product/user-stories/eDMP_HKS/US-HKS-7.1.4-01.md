## US-HKS-7.1.4-01 — Practice doctor must document Patient kommt auf Ueberweisung im Rahmen HKS as Ja or Nein in HKS-D documents

| Field | Value |
|-------|-------|
| **ID** | US-HKS-7.1.4-01 |
| **Traced from** | [HKS-7.1.4-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/eHKS/HKS-7.1.4-01.md) |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether the patient was referred within the HKS programme (Patient kommt auf Ueberweisung im Rahmen HKS) as Ja or Nein in HKS-D documents, so that the referral pathway is captured for dermatologist screening documentation.

### Acceptance Criteria

1. Given an HKS-D document is created, when Patient kommt auf Ueberweisung im Rahmen HKS is recorded, then exactly one of Ja or Nein is selected
2. Given no value is selected, when validated, then an error is reported
