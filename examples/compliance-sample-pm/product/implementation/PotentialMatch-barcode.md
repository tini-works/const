# UnMatching: barcode

## File
`backend-core/app/app-core/api/barcode/`

## Analysis
- **What this code does**: Provides a barcode and QR code generation service (BarcodeApp). Generates barcodes for prescriptions and forms based on patient, employee, form name, prescription ID, and topic. Also provides a generic QR code generation endpoint from arbitrary content. Returns base64-encoded images for display or printing on medical forms.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [ ] Create new User Story for this functionality
- [x] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-BARCODE — Barcode and QR Code Generation for Medical Forms

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-BARCODE |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E4: Form Generation |
| **Data Entity** | Barcode, QrCode, Prescription, Form |

### User Story

As an authenticated user, I want to generate barcodes for prescriptions and medical forms and QR codes from arbitrary content, so that I can embed machine-readable codes on printed documents for automated processing.

### Acceptance Criteria

1. Given a patient ID, employee ID, form name, prescription ID, and topic, when the user requests a barcode, then the system returns a base64-encoded barcode image and its content string.
2. Given arbitrary text content, when the user requests a QR code, then the system returns a base64-encoded QR code image.

### Technical Notes
- Source: `backend-core/app/app-core/api/barcode/`
- Key functions: GetBarcode, GetQrCode
- Integration points: barcode/common (TopicName), form/common (FormName, Prescribe)

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 5.1 BFB Form Printing | [`compliances/phase-5.1-bfb-form-printing.md`](../../compliances/phase-5.1-bfb-form-printing.md) | PDF417 Barcode Generation |

### Compliance Mapping

#### 5.1 BFB Form Printing
**Source**: [`compliances/phase-5.1-bfb-form-printing.md`](../../compliances/phase-5.1-bfb-form-printing.md)

**Related Requirements**:
- "Forms requiring machine-readable data must include PDF417 barcodes"
- "Generate PDF417 barcodes conforming to the KBV barcode specification"
- "Encode all required data fields per form type"
- "Position barcodes precisely within the designated form area"
- "Ensure barcode readability meets minimum quality standards for scanner processing"

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Given a patient ID, employee ID, form name, prescription ID, and topic, when the user requests a barcode, then the system returns a base64-encoded barcode image | Generate PDF417 barcodes conforming to the KBV barcode specification; Encode all required data fields per form type |
| AC2: Given arbitrary text content, when the user requests a QR code, then the system returns a base64-encoded QR code image | Ensure barcode readability meets minimum quality standards for scanner processing |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
