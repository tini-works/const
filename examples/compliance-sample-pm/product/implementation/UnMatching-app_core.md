# UnMatching: app_core

## File
`backend-core/app/app-core/api/app_core/`

## Analysis
- **What this code does**: Serves as the core application bootstrap service (AppCoreApp). Provides initial care provider configuration and user info retrieval (GetCareProviderInitial), employee lookup by IDs, and sample test endpoints. This is the entry point that returns configs, user roles, and employee data when the application starts.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [ ] Create new User Story for this functionality
- [x] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-APP_CORE — Application Bootstrap and Initial Configuration

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-APP_CORE |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5: Practice Software Core |
| **Data Entity** | Employee, CareProvider, Configs, UserInfo |

### User Story

As a practice software user, I want the application to provide initial care provider configuration and user information on startup, so that I can begin working with the correct context and permissions.

### Acceptance Criteria

1. Given any user (anonymous or authenticated) accesses the application, when they request the care provider initial data, then the system returns configurations, user info, status, and user roles.
2. Given an authenticated user, when they request employees by a list of IDs, then the system returns matching employee records with account, care provider, and type information.

### Technical Notes
- Source: `backend-core/app/app-core/api/app_core/`
- Key functions: GetCareProviderInitial, GetEmployeeByIds, SampleTest, SampleTestNoRedirect
- Integration points: common (shared domain types for Configs, UserType)
