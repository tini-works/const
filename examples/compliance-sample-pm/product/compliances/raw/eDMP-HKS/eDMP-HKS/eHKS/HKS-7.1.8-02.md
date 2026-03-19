## HKS-7.1.8-02 — Practice doctor must document Histopathologie Basalzellkarzinom with horizontaler and vertikaler Tumordurchmesser in HKS-D documents

| Field | Value |
|-------|-------|
| **ID** | HKS-7.1.8-02 |
| **Type** | Mandatory |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Section** | Sec 7.1.8 -- Histopathologie (Basalzellkarzinom) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eHKS Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-HKS-7.1.8-02](../../../../../user-stories/eDMP_HKS/US-HKS-7.1.8-02.md) |

### Requirement

As a practice doctor, I want to document Histopathologie Basalzellkarzinom as Ja or Nein in HKS-D documents, and when Ja, to record horizontaler and vertikaler Tumordurchmesser, so that basal cell carcinoma histopathology findings are captured with tumour dimensions.

### Acceptance Criteria

1. Given an HKS-D document is created, when Histopathologie Basalzellkarzinom is Ja, then horizontaler Tumordurchmesser (mm) is recorded
2. Given Histopathologie Basalzellkarzinom is Ja, when documented, then vertikaler Tumordurchmesser (mm) is recorded
3. Given Histopathologie Basalzellkarzinom is Nein, then no sub-fields are required
