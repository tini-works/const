## BK-6.1.6-04 — Practice doctor must document Aktuelle adjuvante endokrine Therapie as Aromataseinhibitoren, Tamoxifen, Andere, Keine, or geplant

| Field | Value |
|-------|-------|
| **ID** | BK-6.1.6-04 |
| **Type** | Mandatory |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Section** | Sec 6.1.6 -- Behandlung (endokrine Therapie) |
| **Status** | TBC |
| **Goals** | BG-1a (KBV eDMP Certification) |
| **Verification Method** | UI functional test |
| **Matched by** | [US-BK-6.1.6-04](../../../../../user-stories/eDMP_HKS/US-BK-6.1.6-04.md) |

### Requirement

As a practice doctor, I want to document Aktuelle adjuvante endokrine Therapie selecting from Aromataseinhibitoren, Tamoxifen, Andere, Keine, or geplant in the Behandlung section, so that current adjuvant endocrine therapy is tracked for long-term treatment monitoring.

### Acceptance Criteria

1. Given an eDMP Brustkrebs Behandlung section is documented, when adjuvante endokrine Therapie is recorded, then exactly one of Aromataseinhibitoren, Tamoxifen, Andere, Keine, or geplant is selected
2. Given no value is selected, when validated, then an error is reported
