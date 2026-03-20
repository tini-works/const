# UnMatching: evdga

## File
`backend-core/app/app-core/api/evdga/`

## Analysis
- **What this code does**: Provides the eVDGA (elektronische Verordnung digitaler Gesundheitsanwendungen) API for prescribing digital health applications. Supports creating prescription bundles, prescribing eVDGA items, re-sending prescriptions with or without signature, and managing a prescription bag (add, remove, update, clear items). Also supports aborting eVDGA prescriptions.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-EVDGA — Digital Health Application Prescribing (eVDGA)

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-EVDGA |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E6=Medication Management |
| **Data Entity** | eVDGA Prescription, Prescription Bundle, Prescription Bag |

### User Story
As a physician, I want to prescribe digital health applications (DiGA) electronically via eVDGA, so that patients can receive validated digital therapy prescriptions through the telematics infrastructure.

### Acceptance Criteria
1. Given a valid patient and DiGA selection, when the physician creates a prescription bundle, then the system generates an eVDGA bundle response
2. Given a prepared bundle, when the physician prescribes the eVDGA, then the system submits the electronic prescription and returns a confirmation
3. Given a previously sent prescription, when the physician re-sends without signature, then the system resubmits the prescription unsigned
4. Given a previously sent prescription, when the physician re-sends with signature, then the system resubmits with a new signature
5. Given eVDGA items, when the physician adds items to the prescription bag, then the bag is updated and the current bag contents are returned
6. Given a bag with items, when the physician removes an item, then the item is removed and the updated bag is returned
7. Given a bag with items, when the physician updates a bag item, then the item details are modified
8. Given a bag with items, when the physician clears all items, then all items are removed from the bag
9. Given an active eVDGA prescription, when the physician aborts it, then the prescription is cancelled

### Technical Notes
- Source: `backend-core/app/app-core/api/evdga/`
- Key functions: CreateBundle, PrescribeEvdga, ReSendWithoutSign, ReSendWithSign, AddToBag, RemoveFromBag, GetBag, UpdateBagItem, RemoveAllFromBag, AbortEvdga
- Integration points: `backend-core/service/domains/api/evdga` (domain service), telematics infrastructure for e-prescriptions

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| Phase 4.5 — eVDGA Digital Health Apps | [`compliances/phase-4.5-evdga-digital-health-apps.md`](../../compliances/phase-4.5-evdga-digital-health-apps.md) | DiGA Prescriptions, eVDGA FHIR Bundle Generation |

### Compliance Mapping

#### Phase 4.5 — eVDGA Digital Health Apps
**Source**: [`compliances/phase-4.5-evdga-digital-health-apps.md`](../../compliances/phase-4.5-evdga-digital-health-apps.md)

**Related Requirements**:
- "Search and select DiGA by name, indication, or DiGA-VE-ID"
- "Validate that the selected DiGA is currently listed and approved"
- "Generate the prescription with required fields: DiGA name, DiGA-VE-ID, PZN (if applicable), indication"
- "Conform to the gematik eVDGA FHIR profiles"
- "Include MedicationRequest referencing the DiGA"
- "Support the full lifecycle: create, sign (QES via eHBA), submit to E-Rezept Fachdienst"
- "Generate patient-readable copy with redemption information"

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Create a prescription bundle | Conform to gematik eVDGA FHIR profiles; Include MedicationRequest referencing the DiGA |
| AC2: Prescribe the eVDGA | Support the full lifecycle: create, sign (QES via eHBA), submit to E-Rezept Fachdienst |
| AC3: Re-send without signature | Support the full lifecycle management |
| AC4: Re-send with signature | Support the full lifecycle: sign (QES via eHBA) |
| AC5-AC8: Prescription bag management | Generate the prescription with required fields: DiGA name, DiGA-VE-ID, PZN, indication |
| AC9: Abort eVDGA prescription | Support the full lifecycle management |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
