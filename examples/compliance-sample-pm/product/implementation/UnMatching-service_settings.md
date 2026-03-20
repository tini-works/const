# UnMatching: service_settings

## File
`backend-core/service/settings/`

## Analysis
- **What this code does**: Provides the application settings service for managing per-feature, per-BSNR settings. Supports saving, removing, and retrieving key-value settings with WebSocket change notification. Includes default color configuration constants and generic settings repository backed by MongoDB. Settings are scoped by feature type and optional BSNR ID.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [ ] Create new User Story for this functionality
- [x] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

## Classification
- [x] E5=Practice Software Core

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-SETTINGS — Per-Feature Application Settings Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-SETTINGS |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5=Practice Software Core |
| **Data Entity** | Settings (key-value map per feature and BSNR) |

### User Story
As a practice administrator, I want to manage application settings scoped by feature type and practice location (BSNR), so that each feature and location can have independent configuration with real-time change notifications.

### Acceptance Criteria
1. Given a feature and settings data, when I call `SaveSettingFlow`, then the key-value settings are persisted in MongoDB scoped by feature type
2. Given a feature and optional BSNR, when I call `GetSettingsFlow`, then the matching settings are retrieved from the repository
3. Given settings that change, when `NotifyChangesFlow` is called, then a WebSocket notification is sent to connected clients
4. Given a feature's settings, when I call `RemoveSettingFlow`, then the settings are deleted and a change notification is triggered
5. Given VOS feature settings, when saving VOS settings, then the system validates that VOS is enabled before allowing configuration changes
6. Given default color settings, then DEFAULT_BACKGROUND (#FFFFFF), DEFAULT_TEXT (#13324B), and DEFAULT_ACTIVITY_LOG (#DCE0E4) are provided

### Technical Notes
- Source: `backend-core/service/settings/`
- Key functions: SaveSettingFlow, GetSettingsFlow, RemoveSettingFlow, NotifyChangesFlow, validate (VOS check)
- Integration points: MongoDB (settings repository), WebSocket (SettingsSocketNotifier), settings_common.SettingsFeatures enum
