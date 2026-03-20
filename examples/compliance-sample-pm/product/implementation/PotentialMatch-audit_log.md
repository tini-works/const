# UnMatching: audit_log

## File
`backend-core/app/app-core/api/audit_log/`

## Analysis
- **What this code does**: Provides an audit log service (AuditLogApp) that retrieves the change history for timeline entries. Subscribes to patient profile change events and timeline hard-delete events to maintain a complete audit trail. Enables users to view the full modification history of clinical documentation entries.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-AUDIT_LOG — Timeline Entry Change History Audit Trail

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-AUDIT_LOG |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E7: Clinical Documentation |
| **Data Entity** | HistoryDto, TimelineEntry |

### User Story

As a practitioner, I want to view the complete modification history of clinical timeline entries, so that I can audit changes to documentation and ensure data integrity.

### Acceptance Criteria

1. Given an authenticated care provider member and a valid timeline entry ID, when they request the entry history, then the system returns all historical change records for that entry.
2. Given a patient profile change event is published, when the audit log service receives it, then it updates relevant audit data to reflect the profile changes.
3. Given a timeline entry is hard-deleted, when the audit log service receives the deletion event, then it handles cleanup of associated audit records.

### Technical Notes
- Source: `backend-core/app/app-core/api/audit_log/`
- Key functions: GetEntryHistory, OnPatientUpdate, OnTimelineHardDelete
- Integration points: timeline (TimelineHardRemove events), patient_profile_common (PatientProfileChange events), audit_log/common (HistoryDto)

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 6.3 Supporting Components — Audit Trail Service | [`compliances/phase-6.3-supporting-components.md`](../../compliances/phase-6.3-supporting-components.md) | Audit Trail Service |

### Compliance Mapping

#### 6.3 Supporting Components — Audit Trail Service (§630f BGB)
**Source**: [`compliances/phase-6.3-supporting-components.md`](../../compliances/phase-6.3-supporting-components.md)

**Related Requirements**:
- "Record all documentation entries with timestamp and user identity"
- "Track modifications: original value, new value, modification timestamp, modifying user"
- "Deletions must not physically remove data — mark as deleted with reason"
- "Audit trail must be immutable (no retroactive modification of audit entries)"
- "Support audit trail export for legal/compliance review"
- "Retention period compliance per applicable regulations"

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Given an authenticated care provider member and a valid timeline entry ID, when they request the entry history, then the system returns all historical change records for that entry. | "Track modifications: original value, new value, modification timestamp, modifying user" and "Support audit trail export for legal/compliance review" |
| AC2: Given a patient profile change event is published, when the audit log service receives it, then it updates relevant audit data to reflect the profile changes. | "Record all documentation entries with timestamp and user identity" |
| AC3: Given a timeline entry is hard-deleted, when the audit log service receives the deletion event, then it handles cleanup of associated audit records. | "Deletions must not physically remove data — mark as deleted with reason" |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
