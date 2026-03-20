# UnMatching: service_timeline_validation

## File
`backend-core/service/timeline_validation/`

## Analysis
- **What this code does**: Contains the main entry point for the timeline validation microservice. Runs as a standalone NATS-based service that validates timeline entries (clinical documentation) against business rules. Provides health check support and clean shutdown handling.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [ ] Create new User Story for this functionality
- [x] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

## Classification
- [x] E1=Billing Documentation

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-TIMELINE-VALIDATION — Timeline Entry Business Rule Validation

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-TIMELINE-VALIDATION |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E1=Billing Documentation |
| **Data Entity** | ValidationError, Timeline, Schein |

### User Story
As a physician, I want timeline entries (service codes and diagnoses) to be automatically validated against billing rules, coding rules, and contract-specific constraints, so that I receive immediate feedback on documentation errors before quarterly billing submission.

### Acceptance Criteria
1. Given a new timeline entry, when `RunValidateOnCreatingTimeline` is triggered, then validation rules are executed and errors are saved
2. Given an updated timeline entry, when `RunValidateOnUpdatingTimeline` is triggered, then validation is re-run and errors are updated
3. Given a deleted timeline entry, when `RunValidateOnDeletingTimeline` is triggered, then related validation errors are cleaned up
4. Given a validation request, when `RunValidation` is called, then common, KV-specific, and SV-specific validation flows are executed based on the contract type
5. Given KV billing, when the KV validation flow runs, then EBM service code preconditions, coding rules, and GOA validations are checked
6. Given psychotherapy-related codes, when validation runs, then specific psychotherapy error codes are evaluated
7. Given EDMP enrollments, when `FindActiveEMDPByPatientId` is called, then active DMP programs are considered in validation context

### Technical Notes
- Source: `backend-core/service/timeline_validation/`
- Key functions: RunValidation, RunValidateOnCreatingTimeline, RunValidateOnUpdatingTimeline, RunValidateOnDeletingTimeline, runKvValidationFlow, runSvValidationFlow, runCommonValidationFlow, runCodingRule
- Integration points: NATS RPC (standalone microservice), sdebm repo, timeline_repo, contract service, catalog_overview, EDMP repo, sdops_service, patient_overview, Gotenberg, WebSocket notifications (TimelineNotifier)

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 2B.1 Core Service Entry | [`compliances/phase-2B.1-core-service-entry.md`](../../compliances/phase-2B.1-core-service-entry.md) | KP2-570 |
| 3.1 KV Billing File Generation & Transmission | [`compliances/phase-3.1-kv-billing-file-generation-transmission.md`](../../compliances/phase-3.1-kv-billing-file-generation-transmission.md) | P2-870 |
| 7.5 Validation & Crypto Modules | [`compliances/phase-7.5-validation-crypto-modules.md`](../../compliances/phase-7.5-validation-crypto-modules.md) | P5-10, P2-05 |

### Compliance Mapping

#### 2B.1 Core Service Entry
**Source**: [`compliances/phase-2B.1-core-service-entry.md`](../../compliances/phase-2B.1-core-service-entry.md)

**Related Requirements**:
- "Programmed fee rule application (programmierte Beregelung) must implement the billing provisions of the fee schedule. The system must automatically apply EBM billing rules, including exclusions, frequency limits, and bundling rules when services are documented." (KP2-570)

#### 3.1 KV Billing File Generation & Transmission
**Source**: [`compliances/phase-3.1-kv-billing-file-generation-transmission.md`](../../compliances/phase-3.1-kv-billing-file-generation-transmission.md)

**Related Requirements**:
- "The system must provide billing statistics and summary functions. These enable the practice to review the billing content before submission, including case counts, service totals, and revenue estimates." (P2-870)

#### 7.5 Validation & Crypto Modules
**Source**: [`compliances/phase-7.5-validation-crypto-modules.md`](../../compliances/phase-7.5-validation-crypto-modules.md)

**Related Requirements**:
- "Through appropriate organizational measures, it must be ensured that users can deploy the current KVDT validation module (XPM) and KBV crypto module (XKM) in a timely manner." (P5-10)
- "The software must correctly implement the requirements regarding the application of ICD-10-GM." (P2-05)

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Given a new timeline entry, when RunValidateOnCreatingTimeline is triggered, then validation rules are executed and errors are saved | KP2-570: "The system must automatically apply EBM billing rules, including exclusions, frequency limits, and bundling rules when services are documented" |
| AC4: Given a validation request, when RunValidation is called, then common, KV-specific, and SV-specific validation flows are executed | KP2-570: "Programmed fee rule application must implement the billing provisions of the fee schedule" |
| AC5: Given KV billing, when the KV validation flow runs, then EBM service code preconditions, coding rules, and GOA validations are checked | P2-05: "The software must correctly implement the requirements regarding the application of ICD-10-GM" and KP2-570: EBM billing rules |
| AC6: Given psychotherapy-related codes, when validation runs, then specific psychotherapy error codes are evaluated | KP2-570: fee rule application covering psychotherapy-specific billing provisions |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
