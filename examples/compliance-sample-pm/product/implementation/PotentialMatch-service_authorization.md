# UnMatching: service_authorization

## File
`backend-core/service/authorization/`

## Analysis
- **What this code does**: Provides role-based access control (RBAC) policy management. Supports creating/removing policies and policy groups, and retrieving policies grouped by BSNR (practice location). Maps Casbin-style authorization policies to user profiles with first/last name enrichment for display.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-SERVICE_AUTHORIZATION — Role-Based Access Control Policy Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-SERVICE_AUTHORIZATION |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5=Practice Software Core |
| **Data Entity** | Policy, PolicyGroup, PolicyViewModel, PoliciesViewModel |

### User Story
As a practice administrator, I want to manage role-based access control policies for users grouped by BSNR (practice location), so that staff members have appropriate permissions scoped to their assigned practice locations.

### Acceptance Criteria
1. Given an administrator, when they create a policy with group, care provider ID, BSNR, object, and action, then the Casbin policy is persisted
2. Given an administrator, when they remove a policy, then the corresponding Casbin policy entry is deleted
3. Given an administrator, when they create a policy group linking a user to a group and BSNR, then the user is assigned to that role group
4. Given an administrator, when they remove a policy group, then the user is unlinked from that role group
5. Given an authenticated user, when they query policies for a user ID, then policies are returned grouped by BSNR with enriched user profile data (first name, last name)

### Technical Notes
- Source: `backend-core/service/authorization/`
- Key functions: CreatePolicy, RemovePolicy, CreatePolicyGroup, RemovePolicyGroup, GetPolicy
- Integration points: Casbin authorization engine (pkg/authorization), EmployeeProfileService (profile enrichment), submodule DI

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 7.2 User & Practice Administration | [`compliances/phase-7.2-user-practice-administration.md`](../../compliances/phase-7.2-user-practice-administration.md) | P2-51 |
| 7.6 HZV/FAV Contract Infrastructure | [`compliances/phase-7.6-hzv-fav-contract-infrastructure.md`](../../compliances/phase-7.6-hzv-fav-contract-infrastructure.md) | [ALLG653](../compliances/SV/ALLG653.md) |

### Compliance Mapping

#### 7.2 User & Practice Administration
**Source**: [`compliances/phase-7.2-user-practice-administration.md`](../../compliances/phase-7.2-user-practice-administration.md)

**Related Requirements**:
- "A Practice Management System (PVS) must implement a user and rights management system so that, within the scope of KV billing, all services can be assigned to both a service location and a contract physician/contract psychotherapist."
- "The system must support role-based access control that links each user to their physician lifetime identifier (LANR — Lebenslange Arztnummer) and their assigned practice location."

#### 7.6 HZV/FAV Contract Infrastructure
**Source**: [`compliances/phase-7.6-hzv-fav-contract-infrastructure.md`](../../compliances/phase-7.6-hzv-fav-contract-infrastructure.md)

**Related Requirements**:
- "The currently valid provisions of the KBV KVDT Requirements Catalog apply. The following functions described therein apply without restriction to the contract software: P2-51 — User and rights management (LANR + location assignment)"

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Given an administrator, when they create a policy with group, care provider ID, BSNR, object, and action | P2-51: user and rights management system so that all services can be assigned to both a service location and a contract physician |
| AC3: Given an administrator, when they create a policy group linking a user to a group and BSNR | P2-51: role-based access control that links each user to their LANR and their assigned practice location |
| AC5: Given an authenticated user, when they query policies for a user ID, then policies are returned grouped by BSNR | P2-51: services can be assigned to both a service location and a contract physician |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
