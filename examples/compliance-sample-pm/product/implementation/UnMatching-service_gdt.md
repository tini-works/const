# UnMatching: service_gdt

## File
`backend-core/service/gdt/`

## Analysis
- **What this code does**: Provides GDT (Geraetedatentransfer - Device Data Transfer) and LDT (Labordatentransfer - Lab Data Transfer) file generation and parsing. The GDT builder constructs GDT-format files with patient profile data, insurance info, and schein data using configurable character encoding. The LDT components handle lab order creation, patient data exchange, and lab result parsing. A substantial module for external device/lab integration.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

## Classification
- [x] Create new User Story for this functionality

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-GDT — GDT/LDT Device and Lab Data Transfer Integration

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-GDT |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E8=Integration Services |
| **Data Entity** | GDTFile, LDTOrder, LDTPatientData, LDTResult, PatientProfile, Schein, InsuranceInfo |

### User Story
As a practice staff member, I want the system to generate GDT files for external medical devices and LDT files for lab order creation, patient data exchange, and lab result parsing, so that the practice can integrate with external medical devices and laboratory systems using standard German data transfer formats.

### Acceptance Criteria
1. Given a patient profile and schein data, when a GDT file is built, then the output conforms to GDT format with correct line lengths, field tags, and configurable character encoding (ISO 8859-15/IBM437)
2. Given patient and insurance data, when the GDT builder populates fields, then patient identity, insurance number, insurance name, and schein data are correctly mapped to GDT field identifiers
3. Given a lab order request, when an LDT order file is built, then the output includes patient data, insurance info, employee/doctor data, and order details in LDT format with the correct version header (LDT1014.01)
4. Given an LDT lab result file, when it is parsed, then the results are correctly extracted with associated patient and test data
5. Given patient data exchange requirements, when LDT patient data is generated, then complete patient profile and insurance information is formatted according to LDT specification

### Technical Notes
- Source: `backend-core/service/gdt/`
- Key functions: GDTBuilder (NewGDTBuilder, SetSchein, GetCurrentInsuranceNumber, Build), LDTBuilder (NewLDTBuilder, GetCurrentInsuranceStatus), LDT order creation (ldt_order.go), LDT patient data (ldt_patient_data.go), LDT result parsing (ldt_result.go), utils (encoding helpers)
- Integration points: patient_profile_common, schein_common, document_setting_common (GDT/LDT export config, character encoding), employee profile repo, field_transfer pkg
