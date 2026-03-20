# UnMatching: epa

## File
`backend-core/app/app-core/api/epa/`

## Analysis
- **What this code does**: Manages EPA (Elektronische Patientenakte / Electronic Patient Record) integration with Germany's telematics infrastructure. Provides a comprehensive API covering entitlement management, connector/card/terminal equipment discovery, health checks, telematic configuration, TSS token handling, VAU (Vertrauenswuerdige Ausfuehrungsumgebung) session management, VSD/KVNR operations, WebDAV file operations, XDS document management (upload, download, query, change, delete for both raw and processed documents), FHIR resource operations, document class/type/practice code lookups, metadata management by BSNR, and document sync with download-to-PVS capability. Includes real-time upload progress notifications via socket events.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-EPA — Electronic Patient Record (EPA) Integration

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-EPA |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E8=Integration Services |
| **Data Entity** | EPA, Patient, XDS Document, FHIR Resource, Entitlement, Connector, Card, Terminal |

### User Story
As a medical practice staff member, I want to manage electronic patient records (EPA) through Germany's telematics infrastructure, so that I can upload, download, query, and synchronize clinical documents with the national EPA system while managing entitlements and connector configurations.

### Acceptance Criteria
1. Given an authenticated care provider member, when they request entitlements for a patient, then the system returns the current EPA entitlement status
2. Given valid entitlement data, when the user sets entitlements, then the system updates the patient's EPA access permissions
3. Given connector configuration, when the user performs a health check, then the system verifies connectivity to the telematics infrastructure
4. Given a valid patient and document, when the user uploads an XDS document, then the system transmits it to the EPA and reports upload progress via WebSocket notifications
5. Given a patient KVNR, when the user queries XDS documents, then the system returns matching documents from the EPA
6. Given a document reference, when the user downloads an XDS document, then the system retrieves the document content from EPA
7. Given valid WebDAV parameters, when the user performs file operations (put, post, get, delete), then the system executes the corresponding WebDAV operation
8. Given FHIR resource parameters, when the user posts or retrieves FHIR data, then the system interacts with the EPA FHIR interface
9. Given a BSNR, when the user requests metadata, then the system returns EPA document metadata for that practice location
10. Given a sync request, when the user initiates document synchronization, then the system syncs documents between PVS and EPA

### Technical Notes
- Source: `backend-core/app/app-core/api/epa/`
- Key functions: GetEntitlements, SetEntitlements, ValidateEpaPatient, GetEquipment, GetCards, GetCardTerminals, HealthCheck, GetConnectorConfigs, GetTelematic, GetTSSToken, ReloadVAU, CreateVsdKvnr, SetEntitlementForKnvrByPnw, PutWebDav, PostWebDav, GetWebDav, DeleteWebDav, ChangeRawXdsDocument, DeleteRawXdsDocument, DownloadXdsDocument, DownloadAllXdsDocument, GetQueryXdsDocument, GetTaskXdsDocument, UploadXdsDocument, UploadRawXdsDocument, UploadAllXdsDocument, PostFhir, GetFhir, GetDocumentClasses, GetDocumentTypes, GetPracticeCodes, GetMetadataListByBsnr, GetEpaDocuments, UpdateEpaDocument, SyncDocuments, DownloadFileToPvs
- Integration points: `backend-core/service/domains/api/epa` (domain service), telematics connector, VAU, WebSocket socket notifications for upload progress

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 5.4 ePA — Electronic Patient Record | [`compliances/phase-5.4-epa-electronic-patient-record.md`](../../compliances/phase-5.4-epa-electronic-patient-record.md) | PDF/A Conversion, Document Upload, Document Retrieval, Entitlement Management, Patient Locator |

### Compliance Mapping

#### 5.4 ePA — Electronic Patient Record
**Source**: [`compliances/phase-5.4-epa-electronic-patient-record.md`](../../compliances/phase-5.4-epa-electronic-patient-record.md)

**Related Requirements**:
- "The system must convert documents to PDF/A format for ePA upload"
- "The system must upload documents to the patient's ePA (elektronische Patientenakte)"
- "The system must retrieve documents from the patient's ePA"
- "The system must manage access entitlements for the ePA"
- "The system must locate a patient's ePA across Aktensystem providers"

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: return current EPA entitlement status | Entitlement Management: request access authorization from patient |
| AC2: update patient's EPA access permissions | Entitlement Management: track entitlement validity periods |
| AC3: verify connectivity to telematics infrastructure | Integration: Ere.health Gateway REST API for VAU, IDP, ePA communication |
| AC4: upload XDS document, report progress via WebSocket | Document Upload: upload documents to patient's ePA with MIO profiles |
| AC5: query XDS documents by KVNR | Document Retrieval: browse available documents by category and date |
| AC6: download XDS document from EPA | Document Retrieval: download and display documents within PVS |
| AC7: WebDAV file operations | Integration: ePA-Aktensystem FHIR/IHE XDS |
| AC8: FHIR resource operations | Integration: ePA-Aktensystem FHIR/IHE XDS |
| AC9: EPA document metadata by BSNR | Document Retrieval: parse structured documents for data extraction |
| AC10: sync documents between PVS and EPA | Patient Locator: locate patient's ePA across Aktensystem providers |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
