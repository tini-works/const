# UnMatching: point_value

## File
`backend-core/app/app-core/api/point_value/`

## Analysis
- **What this code does**: Manages EBM point values (Punktwerte) used in German statutory health insurance billing. Provides CRUD operations for yearly point values: listing with pagination, retrieving by year, updating custom values, and resetting to defaults. Point values convert EBM service points into monetary amounts for billing calculations.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-POINT_VALUE — EBM Point Value Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-POINT_VALUE |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E1=Billing Documentation |
| **Data Entity** | PointValue |

### User Story
As a practice administrator, I want to manage yearly EBM point values (Punktwerte) used for statutory health insurance billing calculations, so that the system correctly converts EBM service points into monetary amounts for billing.

### Acceptance Criteria
1. Given a pagination request, when the user lists point values, then the system returns paginated yearly point values with their current and default status
2. Given a specific year, when the user retrieves the point value, then the system returns the point value model for that year
3. Given a custom point value, when the user updates it, then the system saves the custom value and marks it as updated
4. Given a custom point value ID, when the user resets it, then the system reverts to the default point value and confirms success

### Technical Notes
- Source: `backend-core/app/app-core/api/point_value/`
- Key functions: GetPointValues, GetPointValueByYear, UpdatePointValue, ResetPointValue
- Integration points: `backend-core/service/domains/point_value/common` (PointValueModel), `backend-core/service/domains/api/common` (PaginationRequest/Response)

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 3.2 Patient Receipts | [`compliances/phase-3.2-patient-receipts.md`](../../compliances/phase-3.2-patient-receipts.md) | P2-820 |
| 2B.1 Core Service Entry | [`compliances/phase-2B.1-core-service-entry.md`](../../compliances/phase-2B.1-core-service-entry.md) | KP2-570 |

### Compliance Mapping

#### 3.2 Patient Receipts
**Source**: [`compliances/phase-3.2-patient-receipts.md`](../../compliances/phase-3.2-patient-receipts.md)

**Related Requirements**:
- "The patient receipt must list the services the physician documents for their own billing. Only valued services from the SDEBM (EBM master data) are included. The orientation values give patients an indication of the economic value of services rendered."

#### 2B.1 Core Service Entry
**Source**: [`compliances/phase-2B.1-core-service-entry.md`](../../compliances/phase-2B.1-core-service-entry.md)

**Related Requirements**:
- "Programmed fee rule application (programmierte Beregelung) must implement the billing provisions of the fee schedule. The system must automatically apply EBM billing rules, including exclusions, frequency limits, and bundling rules when services are documented."

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: paginated yearly point values with current and default status | P2-820: orientation values from EBM for patient receipts |
| AC2: point value model for specific year | KP2-570: fee rule application implementing billing provisions |
| AC3: save custom point value | KP2-570: EBM billing rules applied to service documentation |
| AC4: reset to default point value | P2-820: valued services from SDEBM |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
