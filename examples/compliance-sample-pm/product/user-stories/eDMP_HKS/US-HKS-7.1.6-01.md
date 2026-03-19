## US-HKS-7.1.6-01 — Practice doctor must document Verdachtsdiagnose Dermatologe with sub-diagnoses and sonstiger abklaerungsbeduerftiger Befund in HKS-D documents

| Field | Value |
|-------|-------|
| **ID** | US-HKS-7.1.6-01 |
| **Traced from** | [HKS-7.1.6-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/eHKS/HKS-7.1.6-01.md) |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Verdachtsdiagnose Dermatologe as Ja or Nein in HKS-D documents, and when Ja, to select sub-diagnoses from Melanom, Basalzellkarzinom, Spinozellulaeres Karzinom, anderer Hautkrebs, or sonstiger abklaerungsbeduerftiger Befund, so that the dermatologist's suspected diagnoses are captured for further diagnostic workup.

### Acceptance Criteria

1. Given an HKS-D document is created, when Verdachtsdiagnose Dermatologe is Ja, then at least one sub-diagnosis (Melanom, Basalzellkarzinom, Spinozellulaeres Karzinom, anderer Hautkrebs, or sonstiger abklaerungsbeduerftiger Befund) must be selected
2. Given Verdachtsdiagnose Dermatologe is Nein, when sub-diagnoses are selected, then an error is reported
3. Given Verdachtsdiagnose Dermatologe is Ja but no sub-diagnosis is selected, when validated, then an error is reported
