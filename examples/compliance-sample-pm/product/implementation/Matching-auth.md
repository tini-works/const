# Matching: auth

## File
`backend-core/app/app-core/api/auth/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST1231](../user-stories/US-VSST1231.md) | Versorgungssteuerung functions for substitute physician | AC1 |

## Evidence
- `auth.d.go` lines 83-89: `AuthApp` interface defines `Login`, `CallBack`, `Logout`, `Enforcer`, and `GetPermissions` methods providing the authorization framework (matches AC1 of [US-VSST1231](../user-stories/US-VSST1231.md))
- `auth.d.go` lines 34-37: `EnforcerRequest` struct with `Act` and `Obj` fields enables per-action authorization checks that can apply equally to any authenticated user role (matches AC1 of [US-VSST1231](../user-stories/US-VSST1231.md))
- `auth.d.go` lines 46-56: `Policy` and `Permission` structs define the role-based access control model that governs function availability (matches AC1 of [US-VSST1231](../user-stories/US-VSST1231.md))
- `auth.iml.go` lines 64-78: `Enforcer` method checks authorization using `UserId`, `CareProviderId`, and `BsnrId` -- the same enforcement applies regardless of whether the user is a Betreuarzt or Stellvertreterarzt (matches AC1 of [US-VSST1231](../user-stories/US-VSST1231.md))
- `auth.iml.go` lines 28-61: `GetPermissions` method retrieves implicit permissions for a user within a care provider context, enabling function parity verification (matches AC1 of [US-VSST1231](../user-stories/US-VSST1231.md))
- `auth.iml.go` lines 87-109: `Login` method authenticates users with `DOCTOR` role without distinguishing between primary and substitute physicians (matches AC1 of [US-VSST1231](../user-stories/US-VSST1231.md))

## Coverage
- Partial Match: The auth package provides the authorization framework (Enforcer, GetPermissions) that enables function access control. However, the specific enforcement that all Versorgungssteuerung functions available to the Betreuarzt are equally available to the Stellvertreterarzt depends on policy configuration rather than code-level enforcement. The gap is in explicit role parity validation for substitute physicians.
