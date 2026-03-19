## US-HKS-7.1.8-03 — Practice doctor must document Histopathologie Spinozellulaeres Karzinom with Klassifikation and Grading in HKS-D documents

| Field | Value |
|-------|-------|
| **ID** | US-HKS-7.1.8-03 |
| **Traced from** | [HKS-7.1.8-03](../../compliances/raw/eDMP-HKS/eDMP-HKS/eHKS/HKS-7.1.8-03.md) |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Histopathologie Spinozellulaeres Karzinom as Ja or Nein in HKS-D documents, and when Ja, to record Klassifikation (in situ or invasiv) and Grading (Gx, G1, G2, G3, G4), so that squamous cell carcinoma histopathology findings are captured with classification and grading.

### Acceptance Criteria

1. Given an HKS-D document is created, when Histopathologie Spinozellulaeres Karzinom is Ja, then Klassifikation (in situ or invasiv) is selected
2. Given Klassifikation is invasiv, when documented, then Grading is one of Gx, G1, G2, G3, or G4
3. Given Histopathologie Spinozellulaeres Karzinom is Nein, then no sub-fields are required
