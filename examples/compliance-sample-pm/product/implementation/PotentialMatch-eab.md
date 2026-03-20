# UnMatching: eab

## File
`backend-core/app/app-core/api/eab/`

## Analysis
- **What this code does**: Manages EAB (Elektronischer Arztbrief / Electronic Doctor Letter) workflows. Supports creating and updating EABs linked to doctor letters, digital signing via QES, sending via KIM (Kommunikation im Medizinwesen) email, PDF upload, patient assignment/unassignment with automatic matching, insurance validation by IK number, Schein existence checks, consent documenting, and XML data extraction. Integrates with the timeline, mail, and patient profile systems.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

## Classification
- [x] User-facing feature
- [ ] Infrastructure/utility
- [ ] Dead code

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-EAB — Electronic Doctor Letter (EAB) Workflow

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-EAB |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E8 — Integration Services |
| **Data Entity** | EABModel, EmailItem, MailAccountDto |

### User Story
As a medical practitioner, I want to create electronic doctor letters (EAB) linked to doctor letters, digitally sign them via QES, send them via KIM email, and manage patient assignment with automatic matching, so that I can securely exchange medical correspondence with other healthcare providers through the standardized KIM infrastructure.

### Acceptance Criteria
1. Given an authenticated user, when they create an EAB from a doctor letter ID, then the EAB is initialized and returned.
2. Given an authenticated user, when they update an EAB with timeline model data, then the EAB and timeline are updated.
3. Given an authenticated user, when they sign one or more EABs by IDs, then the QES digital signing process is initiated.
4. Given an authenticated user, when they send an EAB via KIM with email details and BSNR code, then the EAB is transmitted to the recipient.
5. Given an authenticated user, when they request KIM accounts for a BSNR code, then available mail accounts are returned.
6. Given an authenticated user, when they upload a PDF for an EAB, then the PDF is stored and a URL is returned.
7. Given an authenticated user, when they assign or unassign a patient to/from a mail, then the patient linkage is updated.
8. Given an authenticated user, when they check for automatic patient assignment on a mail, then the system attempts to match the patient and checks for existing Schein.
9. Given an authenticated user, when they validate email addresses, then invalid KIM addresses are filtered out.
10. Given an authenticated user, when they check insurance by IK number, then the system verifies the insurance exists in the catalog.
11. Given an authenticated user, when they request consent documenting data, then the consent information is returned.
12. Given an authenticated user, when they extract patient XML data from an EAB, then the parsed data is returned.

### Technical Notes
- Source: `backend-core/app/app-core/api/eab/`
- Key functions: CreateEAB, UpdateEAB, Sign, SendMail, GetKIMAccounts, UploadPDF, AssignPatient, UnAssignPatient, CheckAutomaticallyAssignPatient, PreparePatientCompare, ValidateEmailAddresses, CheckExistInsuranceByIKNumber, CheckExistSchein, GetConsentDocumenting, GetPatientXMLData, GetEAB, DeleteEAB, UpdateStatusEAB
- Integration points: `service/domains/eab/common`, `service/domains/qes/common`, `service/mail/common`, `service/domains/timeline/common`, `service/domains/api/catalog_sdkt_common`, `service/domains/api/patient_profile_common`

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 5.3 eArztbrief — Electronic Doctor Letter | [`compliances/phase-5.3-earztbrief-electronic-doctor-letter.md`](../../compliances/phase-5.3-earztbrief-electronic-doctor-letter.md) | HL7 CDA R2 Assembly, KIM S/MIME Envelopes, Delivery Status Tracking, Incoming Letter Matching, Auto-Billing GOP 86900/86901 |

### Compliance Mapping

#### 5.3 eArztbrief — Electronic Doctor Letter
**Source**: [`compliances/phase-5.3-earztbrief-electronic-doctor-letter.md`](../../compliances/phase-5.3-earztbrief-electronic-doctor-letter.md)

**Related Requirements**:
- "Encrypt and sign the CDA document using S/MIME"
- "Recipient address lookup from KIM directory (by LANR/BSNR)"
- "Support for multiple recipients per letter"
- "Match to patient records using patient identification data"
- "Support for manual matching when automatic matching fails"
- "GOP 86900: Auto-generate for sending an eArztbrief"
- "GOP 86901: Auto-generate for receiving and processing an eArztbrief"

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: create EAB from doctor letter ID | HL7 CDA R2 Assembly: structured header with sender/recipient data |
| AC3: sign EABs via QES | KIM S/MIME: encrypt and sign CDA document using S/MIME |
| AC4: send EAB via KIM with email details and BSNR | KIM S/MIME: recipient address lookup from KIM directory (by LANR/BSNR) |
| AC5: return available KIM mail accounts for BSNR | KIM S/MIME: recipient address lookup |
| AC7: assign/unassign patient to mail | Incoming Letter Matching: match to patient records |
| AC8: automatic patient assignment on mail | Incoming Letter Matching: match to patient records using patient identification data; support for manual matching when automatic fails |
| AC9: validate KIM email addresses | KIM S/MIME: recipient address lookup from KIM directory |
| AC12: extract patient XML data from EAB | Incoming Letter Matching: parse incoming CDA documents |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
