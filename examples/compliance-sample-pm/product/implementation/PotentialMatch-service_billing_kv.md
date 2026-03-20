# UnMatching: service_billing_kv

## File
`backend-core/service/billing_kv/`

## Analysis
- **What this code does**: Provides the KV (Kassenaerztliche Vereinigung) billing service, which is a core billing module. Handles KV billing file generation with CON file creation, XPM/XKM encryption, QES signing via TI connector, and charset encoding (ISO 8859-15). Integrates with schein, patient, EAU, eRezept, SDKV, and EAB services for comprehensive quarterly KV billing case compilation and submission.
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

## US-PROPOSED-BILLING_KV — KV Quarterly Billing File Generation and Validation

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-BILLING_KV |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E1=Billing Documentation |
| **Data Entity** | BillingKVHistory, Schein, ConFile, Patient, Employee |

### User Story
As a medical practice administrator, I want to generate, validate, and submit quarterly KV billing files (KVDT CON files) with XPM/XKM encryption and QES signing, so that billing cases are compiled accurately and transmitted securely to the Kassenaerztliche Vereinigung.

### Acceptance Criteria
1. Given a set of scheins for a billing quarter, when the troubleshoot process is triggered, then all billing cases are compiled and validation hints (coding rules, psychotherapy checks, service code hints) are returned
2. Given valid billing data, when CON file generation is executed, then a properly formatted KVDT CON file is created with ISO 8859-15 encoding
3. Given a generated CON file, when encryption is requested, then XPM and XKM encrypted files are created and uploaded to MinIO storage
4. Given a billing history, when queried by quarter, then grouped scheins by quarter are returned with associated patient and doctor data
5. Given patient encounters with psychotherapy codes, when suggestion hints are checked, then patients not yet included in billing but matching hint criteria are identified
6. Given a billing history ID, when hints are requested, then grouped validation errors per patient are returned with severity levels

### Technical Notes
- Source: `backend-core/service/billing_kv/`
- Key functions: Troubleshoot, MakeScheinBill, GetValidQuarterYear, makeConFile, createXKMFileAndTestFile, uploadResultConFile, GetGroupScheinsByQuarter, ValidateCodingRuleByPatientId, GetHintsByBillingId, GetSuggestionHintsPatientNotInBilling, CheckHintsPsychotherapy
- Integration points: schein, patient_profile, patient_participation, EAU, eRezept, SDKV, EAB, TI connector (QES signing), MinIO (file storage), con_file pkg, xpm/xkm encryption pkgs

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 3.1 KV Billing File Generation & Transmission | [`compliances/phase-3.1-kv-billing-file-generation-transmission.md`](../../compliances/phase-3.1-kv-billing-file-generation-transmission.md) | P2-95, P2-96, P2-97, P2-870, P2-880, P2-890 |

### Compliance Mapping

#### 3.1 KV Billing File Generation & Transmission
**Source**: [`compliances/phase-3.1-kv-billing-file-generation-transmission.md`](../../compliances/phase-3.1-kv-billing-file-generation-transmission.md)

**Related Requirements**:
- "The user must be supported by the software vendor in locating the encrypted KVDT billing file in the file system."
- "The software must provide a 1-Click-Abrechnung (one-click billing) function via KV-Connect."
- "The software must provide a function for transmitting the online billing based on KIM (1ClickAbrechnung V2.1)."
- "The system must provide billing statistics and summary functions."
- "The billing file must be packaged and named according to the KVDT specification."
- "The system must handle billing transmission confirmations."

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: compile billing cases and return validation hints | P2-870: billing statistics and summary functions |
| AC2: CON file generation with ISO 8859-15 encoding | P2-880: billing file packaging and naming per KVDT spec |
| AC3: XPM/XKM encrypted files created and uploaded | P2-95: encrypted billing file location documentation |
| AC4: grouped scheins by quarter with patient and doctor data | P2-870: billing statistics and summary functions |
| AC5: suggestion hints for patients not yet in billing | P2-870: billing statistics and summary functions |
| AC6: grouped validation errors per patient with severity | P2-870: billing statistics; P2-880: file packaging per KVDT |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
