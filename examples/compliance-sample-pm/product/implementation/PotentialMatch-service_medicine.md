# UnMatching: service_medicine

## File
`backend-core/service/medicine/`

## Analysis
- **What this code does**: Contains the main entry point for the medicine microservice, which handles medication-related functionality (MMI integration, medication database lookups). Runs as a standalone NATS-based microservice with health check support, connecting to MongoDB and MinIO for data storage.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

## Classification
- [x] E6=Medication Management

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-MEDICINE — Medication Prescription and Shopping Bag Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-MEDICINE |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E6=Medication Management |
| **Data Entity** | MedicineShoppingBag, MedicationPrescription, FormInfo |

### User Story
As a physician, I want to manage a medication shopping bag and generate prescriptions for patients, so that I can efficiently prescribe medications with proper form types, dosage information, and contract-specific rules.

### Acceptance Criteria
1. Given a patient encounter, when I add a medication via `AddToShoppingBag`, then the medication is added to the patient's shopping bag with contract and BSNR context
2. Given medications in the shopping bag, when I update quantity via `UpdateShoppingBagQuantity`, then the quantity is adjusted with minimum validation of 1
3. Given a shopping bag with medications, when I call `Prescribe`, then a prescription is generated with form infos, print date, treatment doctor, and encounter case
4. Given a medication in the shopping bag, when I update form type via `UpdateForm`, then the current form type is changed for the selected medicines
5. Given a BSNR-scoped prescription workflow, when I use `PrescribeBSNR`, then prescriptions are generated at the practice level without patient-specific context
6. Given medication details, when I update shopping bag information via `UpdateShoppingBagInformation`, then intake interval, package size, free text, e-prescription flag, and special exceedings are persisted
7. Given a patient profile change, when `OnPatientUpdate` is triggered, then the medicine service reacts to updated patient data

### Technical Notes
- Source: `backend-core/service/medicine/`
- Key functions: AddToShoppingBag, Prescribe, PrescribeBSNR, UpdateShoppingBagQuantity, UpdateShoppingBagInformation, RemoveFromShoppingBag, UpdateForm, DeleteMedicationPrescribe
- Integration points: MMI (medication database), MongoDB, MinIO, NATS RPC, patient_profile_common, medicine_common

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| AVWG P3-621 — Prescribing from Pharmaceutical Master Data | [`product/compliances/AVWG/P3-621.md`](../compliances/AVWG/P3-621.md) | Section 3.8 Verordnungsinhalte |
| AVWG P3-700 — Creation of Prescriptions | [`product/compliances/AVWG/P3-700.md`](../compliances/AVWG/P3-700.md) | Section 3.9 Erstellung von Verordnungen |
| AVWG P3-625 — Dosage Information | [`product/compliances/AVWG/P3-625.md`](../compliances/AVWG/P3-625.md) | Section 3.8 Verordnungsinhalte |
| AVWG P3-800 — Medication Plan per § 31a SGB V | [`product/compliances/AVWG/P3-800.md`](../compliances/AVWG/P3-800.md) | Section 3.10 Medikationsplan |

### Compliance Mapping

#### AVWG P3-621 — Prescribing from Pharmaceutical Master Data
**Source**: [`product/compliances/AVWG/P3-621.md`](../compliances/AVWG/P3-621.md)

**Related Requirements**:
- "The prescribing software must implement a prescription of pharmaceuticals and other products included in the pharmaceutical supply pursuant to § 31 SGB V from the pharmaceutical master data."
- "When prescribing from the pharmaceutical master data, modification of the data adopted on the basis of the PZN by the contracted physician is not permitted."
- "For a paper-based prescription, only a multiple of the package size of one product (one PZN) may be prescribed per prescription line."

#### AVWG P3-700 — Creation of Prescriptions
**Source**: [`product/compliances/AVWG/P3-700.md`](../compliances/AVWG/P3-700.md)

**Related Requirements**:
- "The prescribing software must support both the printing of paper-based prescriptions and the creation of electronic prescriptions pursuant to § 86 SGB V."
- "The contract physician must be able to decide, based on the legal requirements, which variant per acceptance criterion 1 they wish to use."

#### AVWG P3-625 — Dosage Information
**Source**: [`product/compliances/AVWG/P3-625.md`](../compliances/AVWG/P3-625.md)

**Related Requirements**:
- "The prescribing software must enable the specification of dosage information on a prescription."

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Add medication to shopping bag with contract and BSNR context | P3-621: Prescribing from pharmaceutical master data |
| AC2: Update shopping bag quantity with minimum validation | P3-621: Only a multiple of the package size may be prescribed; must be whole number |
| AC3: Generate prescription with form infos, print date, treatment doctor | P3-700: Support both paper-based and electronic prescriptions |
| AC4: Update form type for selected medicines | P3-700: Switch between variants without renewed selection of already selected products |
| AC6: Update shopping bag info (intake interval, dosage, e-prescription flag) | P3-625: Enable specification of dosage information on a prescription |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
