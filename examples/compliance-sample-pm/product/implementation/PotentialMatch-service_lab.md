# UnMatching: service_lab

## File
`backend-core/service/lab/`

## Analysis
- **What this code does**: Provides LDT (Labordatentransfer - Lab Data Transfer) validation and parsing utilities. Defines field structures, validation rules, error types with severity levels (error/warning/info), and record/object type definitions for validating LDT data files according to KBV specifications.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [ ] Create new User Story for this functionality
- [x] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

## Classification
- [x] This is infrastructure/utility code (no story needed)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-LAB — LDT Lab Data Transfer Validation Framework

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-LAB |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E8=Integration Services |
| **Data Entity** | Field, ObjectType, RecordType, Rule, LDTError |

### User Story
As a system component processing lab data, I want a validation framework for LDT (Labordatentransfer) files according to KBV specifications, so that lab data files can be validated for field formats, object type structures, and record type completeness with severity-based error reporting.

### Acceptance Criteria
1. Given an LDT field definition, when IsValid is called, then all associated rules are evaluated and validation errors are collected
2. Given an LDT object type with multiple fields, when IsValid is called, then all fields are validated and errors are aggregated
3. Given an LDT record type with object types and rules, when IsValid is called, then both record-level rules and nested object/field rules are evaluated
4. Given a validation error, when reported, then it includes the error status (error/warning/info), rule ID, and contextual information (field, object type, or record type)
5. Given field format definitions, when fields are validated, then alphanumeric (alnum) and numeric (num) format constraints are enforced

### Technical Notes
- Source: `backend-core/service/lab/`
- Key functions: Field.IsValid, ObjectType.IsValid, RecordType.IsValid, LDTError.Error, Rule (with Validator interface)
- Integration points: Used by gdt service (LDT processing), KBV specification compliance

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 3.3 Laboratory Proficiency Testing | [`compliances/phase-3.3-laboratory-proficiency-testing.md`](../../compliances/phase-3.3-laboratory-proficiency-testing.md) | P20-010, P20-070 |

### Compliance Mapping

#### 3.3 Laboratory Proficiency Testing
**Source**: [`compliances/phase-3.3-laboratory-proficiency-testing.md`](../../compliances/phase-3.3-laboratory-proficiency-testing.md)

**Related Requirements**:
- "Every billing software for laboratory services must provide a function to capture RV-relevant analytes and manage proficiency test certificates (Ringversuchszertifikate)."
- "The RVSA dataset must be transmitted as part of the billing per the KVDT dataset specification."

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Given an LDT field definition, when IsValid is called, then all associated rules are evaluated | P20-010: capture RV-relevant analytes (LDT validation ensures lab data conforms to KBV specifications for proficiency testing) |
| AC3: Given an LDT record type with object types and rules, when IsValid is called, then both record-level rules and nested object/field rules are evaluated | P20-070: RVSA dataset must be transmitted as part of the billing per the KVDT dataset specification (LDT validation supports correct dataset generation) |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
