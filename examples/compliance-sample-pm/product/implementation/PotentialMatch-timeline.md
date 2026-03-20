# UnMatching: timeline

## File
`backend-core/app/app-core/api/timeline/`

## Analysis
- **What this code does**: Provides the core patient timeline API, which is the central clinical documentation module. Supports CRUD operations for timeline entries (diagnoses, services, prescriptions, forms, etc.), grouping by quarter, validation, print date tracking, suggestion rules, therapy management, and service code counting. Handles multiple event types for timeline changes (create, update, remove, hard-remove, auto-action, validation). This is one of the most central user-facing modules in the system.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-TIMELINE — Patient Timeline Clinical Documentation

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-TIMELINE |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E7 Clinical Documentation |
| **Data Entity** | TimelineModel, TimelineEntry, Diagnose, Service, Therapy, Psychotherapy |

### User Story
As a physician, I want to manage the patient timeline with full CRUD operations for clinical entries (diagnoses, services, prescriptions, forms), group them by quarter, validate entries, track print dates, manage therapies, and handle diagnosis takeover, so that all clinical documentation is centrally maintained and billable per quarterly requirements.

### Acceptance Criteria
1. Given a patient ID and optional filters (contract, date, encounter case, doctor, types), when the user requests the timeline, then matching timeline entries are returned
2. Given a valid timeline model, when the user creates an entry, then the entry is persisted and the created model is returned
3. Given an existing timeline entry, when the user edits it, then the updated model is returned
4. Given a timeline entry ID, when the user removes it (soft or hard delete), then the entry is removed accordingly
5. Given a patient and quarter context, when GroupByQuarter is called, then timeline entries are grouped by quarter
6. Given a timeline entry, when UpdatePrintDate is called with a form ID and print date, then the print date is tracked
7. Given suggestion rules, when UpdateSuggestionRuleApplied or IgnoreSdkrwRule is called, then the rule application state is updated
8. Given a patient context, when GetTherapies is called, then active therapies are returned
9. Given a service code and context, when GetAmountServiceCode is called, then the count of that service code is returned
10. Given timeline change events (create, update, remove, hard-remove, auto-action, validation), when events are received, then the timeline reacts with appropriate updates and WebSocket notifications
11. Given diagnosis validation needs, when ValidateDiagnose is called, then diagnosis validity is checked and results returned
12. Given psychotherapy context, when GetPsychotherapyTakeOver or GetPsychotherapyBefore2020 is called, then relevant psychotherapy history is returned
13. Given an enrollment ID, when GetTimelineByEnrollmentId is called, then timeline entries linked to that enrollment are returned

### Technical Notes
- Source: `backend-core/app/app-core/api/timeline/`
- Key functions: Get, Create, Edit, Remove, GroupByQuarter, UpdatePrintDate, GetTherapies, GetAmountServiceCode, ValidateDiagnose, DocumentSuggestion, MarkTreatmentRelevant, RestoreEntryHistory, Document88130, GetTakeOverDiagnosis, TakeOverDiagnosisWithScheinId, MarkAcceptedByKV, GetLastDocumentedQuarter, GetTimelineByEnrollmentId
- Integration points: `service/domains/timeline/common`, `service/domains/api/schein_common`, `service/domains/api/validation_timeline`, `service/domains/form/common`, `service/domains/eab_service_history/common`, `service/domains/repos/app_core/patient_encounter`
- Subscribes to EventTimelineCreate, EventTimelineUpdate, EventTimelineRemove, EventTimelineHardRemove, EventTimelineValidation, EventAutoAction
- WebSocket notifications at care-provider, user, device, and client levels

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 2B.1 Core Service Entry | [`compliances/phase-2B.1-core-service-entry.md`](../../compliances/phase-2B.1-core-service-entry.md) | P2-600, P2-610, P2-630 |
| 6.3 Supporting Components — Audit Trail | [`compliances/phase-6.3-supporting-components.md`](../../compliances/phase-6.3-supporting-components.md) | Audit Trail Service |
| 7.1 System Integrity & Date Controls | [`compliances/phase-7.1-system-integrity-date-controls.md`](../../compliances/phase-7.1-system-integrity-date-controls.md) | P2-30 |

### Compliance Mapping

#### 2B.1 Core Service Entry
**Source**: [`compliances/phase-2B.1-core-service-entry.md`](../../compliances/phase-2B.1-core-service-entry.md)

**Related Requirements**:
- "All treatment days must be sorted in ascending order. All service codes (Gebuehrennummern/GNR) for a treatment day must be arranged under FK 5001. The system must maintain the chronological order of service documentation." (P2-600)
- "Justification texts (Begruendungstexte) must be assignable to individual GNRs. Each service code may have associated justification text that must be transmitted under the prescribed FK (field key)." (P2-610)
- "Automatic day separation is not permitted. The system must offer an explicit TAGTRENNUNG (day separation) function with time capture." (P2-630)

#### 6.3 Supporting Components — Audit Trail Service
**Source**: [`compliances/phase-6.3-supporting-components.md`](../../compliances/phase-6.3-supporting-components.md)

**Related Requirements**:
- "Record all documentation entries with timestamp and user identity"
- "Track modifications: original value, new value, modification timestamp, modifying user"
- "Deletions must not physically remove data — mark as deleted with reason"

#### 7.1 System Integrity & Date Controls
**Source**: [`compliances/phase-7.1-system-integrity-date-controls.md`](../../compliances/phase-7.1-system-integrity-date-controls.md)

**Related Requirements**:
- "The billing software must ensure that service codes (GNR — Gebührenordnungsnummern) and ICD-10-GM diagnostic codes cannot be recorded with a date beyond the current system date." (P2-30)

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Given a patient ID and optional filters, when the user requests the timeline, then matching timeline entries are returned | P2-600: "All treatment days must be sorted in ascending order" |
| AC2: Given a valid timeline model, when the user creates an entry, then the entry is persisted | P2-600: "All service codes for a treatment day must be arranged under FK 5001" and P2-30: "service codes and ICD-10-GM diagnostic codes cannot be recorded with a date beyond the current system date" |
| AC3: Given an existing timeline entry, when the user edits it, then the updated model is returned | "Track modifications: original value, new value, modification timestamp, modifying user" (phase-6.3) |
| AC4: Given a timeline entry ID, when the user removes it (soft or hard delete), then the entry is removed accordingly | "Deletions must not physically remove data — mark as deleted with reason" (phase-6.3) |
| AC5: Given a patient and quarter context, when GroupByQuarter is called, then timeline entries are grouped by quarter | P2-600: chronological ordering of service documentation per treatment day |
| AC9: Given a service code and context, when GetAmountServiceCode is called, then the count of that service code is returned | P2-610: "Justification texts must be assignable to individual GNRs" — service code tracking supports justification |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
