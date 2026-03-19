## HKS-6.1.4-01 — Practice doctor must document Verdachtsdiagnose with sub-diagnoses in HKS-A documents

| Field | Value |
|-------|-------|
| **ID** | HKS-6.1.4-01 |
| **Type** | Mandatory |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Section** | Sec 6.1.4 -- HKS-A Verdachtsdiagnose |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eHKS Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-HKS-6.1.4-01](../../../../../user-stories/eDMP_HKS/US-HKS-6.1.4-01.md) |

### Requirement

As a practice doctor, I want to document Verdachtsdiagnose as Ja or Nein in HKS-A documents, and when Ja, to select sub-diagnoses from Melanom, Basalzellkarzinom, Spinozellulaeres Karzinom, or anderer Hautkrebs, so that suspected diagnoses from the general practitioner screening are captured for dermatology referral.

### Acceptance Criteria

1. Given an HKS-A document is created, when Verdachtsdiagnose is Ja, then at least one sub-diagnosis (Melanom, Basalzellkarzinom, Spinozellulaeres Karzinom, or anderer Hautkrebs) must be selected
2. Given Verdachtsdiagnose is Nein, when sub-diagnoses are selected, then an error is reported
3. Given Verdachtsdiagnose is Ja but no sub-diagnosis is selected, when validated, then an error is reported
