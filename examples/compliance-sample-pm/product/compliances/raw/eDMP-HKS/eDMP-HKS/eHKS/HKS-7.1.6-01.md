## HKS-7.1.6-01 — Practice doctor must document Verdachtsdiagnose Dermatologe with sub-diagnoses and sonstiger abklaerungsbeduerftiger Befund in HKS-D documents

| Field | Value |
|-------|-------|
| **ID** | HKS-7.1.6-01 |
| **Type** | Mandatory |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Section** | Sec 7.1.6 -- Verdachtsdiagnose Dermatologe |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eHKS Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-HKS-7.1.6-01](../../../../../user-stories/eDMP_HKS/US-HKS-7.1.6-01.md) |

### Requirement

As a practice doctor, I want to document Verdachtsdiagnose Dermatologe as Ja or Nein in HKS-D documents, and when Ja, to select sub-diagnoses from Melanom, Basalzellkarzinom, Spinozellulaeres Karzinom, anderer Hautkrebs, or sonstiger abklaerungsbeduerftiger Befund, so that the dermatologist's suspected diagnoses are captured for further diagnostic workup.

### Acceptance Criteria

1. Given an HKS-D document is created, when Verdachtsdiagnose Dermatologe is Ja, then at least one sub-diagnosis (Melanom, Basalzellkarzinom, Spinozellulaeres Karzinom, anderer Hautkrebs, or sonstiger abklaerungsbeduerftiger Befund) must be selected
2. Given Verdachtsdiagnose Dermatologe is Nein, when sub-diagnoses are selected, then an error is reported
3. Given Verdachtsdiagnose Dermatologe is Ja but no sub-diagnosis is selected, when validated, then an error is reported
