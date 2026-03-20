# UnMatching: doctor_letter

## File
`backend-core/app/app-core/api/doctor_letter/`

## Analysis
- **What this code does**: Manages doctor letter (Arztbrief) creation and templates. Provides template browsing with header/footer management, sender/receiver resolution for patients, PDF generation with presigned URLs, and variable substitution in letter templates. Also handles private billing invoices and BG (Berufsgenossenschaft/occupational insurance) invoices, including bulk invoice data retrieval. Integrates with the timeline, private billing, and BG billing domains.
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

## US-PROPOSED-DOCTOR_LETTER — Doctor Letter and Invoice Generation

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-DOCTOR_LETTER |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E4 — Form Generation |
| **Data Entity** | DoctorLetter, LetterTemplate, HeaderFooter, TimelineModel |

### User Story
As a medical practitioner, I want to create doctor letters from templates with variable substitution, generate PDF output, and handle private and occupational insurance invoices, so that I can produce professional medical correspondence and billing documents for patients and referring physicians.

### Acceptance Criteria
1. Given an authenticated user, when they search letter templates by query with optional tag exclusion, then matching templates are returned.
2. Given an authenticated user, when they request template details by ID, then the full template with header/footer information is returned.
3. Given an authenticated user, when they resolve sender and receiver for a patient (optionally with Schein), then available senders, receivers, and private billing ID are returned.
4. Given an authenticated user, when they create a doctor letter for a patient with a treatment doctor, then the letter is persisted and a timeline entry is created.
5. Given an authenticated user, when they update an existing doctor letter's timeline model, then the letter is modified and the updated timeline entry is returned.
6. Given an authenticated user, when they request a PDF presigned URL for a doctor letter, then a downloadable URL is returned.
7. Given an authenticated user, when they handle a private invoice, then the invoice is processed with the doctor letter template and linked to the timeline.
8. Given an authenticated user, when they handle a BG (occupational insurance) invoice, then the invoice is processed with billing status tracking.
9. Given an authenticated user, when they request bulk invoice data for multiple private billing IDs, then all invoice data is returned.
10. Given an authenticated user, when they request value variables by categories for a template, then variable substitution data is returned.

### Technical Notes
- Source: `backend-core/app/app-core/api/doctor_letter/`
- Key functions: CreateDoctorLetter, UpdateDoctorLetter, GetTemplates, GetTemplateDetail, GetSenderAndReceiver, GetPdfPresignedUrl, GetHeaderFooters, HandlePrivateInvoice, HandleBgInvoice, GetBulkInvoiceData, HandleBgInvoicByForm, GetValueVariables
- Integration points: `service/domains/doctor_letter/common`, `service/domains/timeline/common`, `service/domains/private_billing/common`, `service/domains/bg_billing/common`

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 5.3 eArztbrief — Electronic Doctor Letter | [`compliances/phase-5.3-earztbrief-electronic-doctor-letter.md`](../../compliances/phase-5.3-earztbrief-electronic-doctor-letter.md) | HL7 CDA R2 Assembly, PDF/A Generation |

### Compliance Mapping

#### 5.3 eArztbrief — Electronic Doctor Letter
**Source**: [`compliances/phase-5.3-earztbrief-electronic-doctor-letter.md`](../../compliances/phase-5.3-earztbrief-electronic-doctor-letter.md)

**Related Requirements**:
- "Structured header with sender/recipient physician data"
- "Patient identification section"
- "Clinical content sections (diagnoses, findings, medications, therapy recommendations)"
- "Each eArztbrief must include a PDF/A document"
- "PDF/A-1b or PDF/A-3b conformant"
- "Print-optimized layout with practice letterhead"

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC3: resolve sender and receiver for a patient | HL7 CDA R2: structured header with sender/recipient physician data |
| AC4: create doctor letter with treatment doctor and timeline | HL7 CDA R2: clinical content sections; patient identification section |
| AC6: PDF presigned URL for doctor letter | PDF/A Generation: PDF/A-1b or PDF/A-3b conformant; print-optimized layout |
| AC10: value variables by categories for template | HL7 CDA R2: support for structured and narrative content |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
