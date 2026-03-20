# UnMatching: feature_flag

## File
`backend-core/app/app-core/api/feature_flag/`

## Analysis
- **What this code does**: Provides a feature flag retrieval API that returns the current feature flags for the authenticated user. Includes event notification capabilities (NATS and WebSocket) to broadcast feature flag updates to care provider members, individual users, devices, and client sessions.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [ ] Create new User Story for this functionality
- [x] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-FEATURE_FLAG — Feature Flag Retrieval and Notification

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-FEATURE_FLAG |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5=Practice Software Core |
| **Data Entity** | FeatureFlag |

### User Story
As an authenticated user, I want to retrieve current feature flags for my session, so that the application can enable or disable functionality based on configuration without requiring redeployment.

### Acceptance Criteria
1. Given an authenticated user, when they request feature flags, then the system returns the current feature flag configuration for that user
2. Given a feature flag update occurs, when the change is published, then all affected care provider members, users, devices, and client sessions receive real-time notifications via NATS and WebSocket

### Technical Notes
- Source: `backend-core/app/app-core/api/feature_flag/`
- Key functions: GetFeatureFlag (service), NotifyFeatureFlagUpdated (NATS event), NotifyCareProviderFeatureFlagUpdated / NotifyUserFeatureFlagUpdated / NotifyDeviceFeatureFlagUpdated / NotifyClientFeatureFlagUpdated (WebSocket)
- Integration points: `backend-core/service/domains/api/feature_flag` (domain service), socket_service (WebSocket notifications), `backend-core/app/app-core/config` (SocketServiceClientMod)
