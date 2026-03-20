# UnMatching: user_settings

## File
`backend-core/app/app-core/api/user_settings/`

## Analysis
- **What this code does**: Provides the user settings API for saving, retrieving, removing, and resetting per-user application settings. Supports key-value settings for UI preferences (timeline font, default catalog, default doctor specialist, etc.), app lock state management, and bulk reset across all users. Settings keys include display hints, schein selection, visited GBA lists, error key lists, and failed enrollments.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-USER_SETTINGS — Per-User Application Settings Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-USER_SETTINGS |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5=Practice Software Core |
| **Data Entity** | UserSettings, AppLockState |

### User Story
As a care provider member, I want to save, retrieve, remove, and reset my personal application settings (e.g., timeline font, default catalog, default doctor specialist, last selected schein), so that my UI preferences persist across sessions and I can lock the application when needed.

### Acceptance Criteria
1. Given an authenticated care provider member, when they save settings as key-value pairs, then the settings are persisted for that user
2. Given an authenticated user with saved settings, when they request settings by key names, then the corresponding values are returned
3. Given an authenticated user, when they remove specific settings, then those settings are deleted from their profile
4. Given an authenticated user with SYSTEM role, when they reset settings for all users, then the specified settings are cleared across all user profiles
5. Given an authenticated user, when they set the app lock state, then the application lock is toggled accordingly
6. Given an authenticated user, when they query the app lock state, then the current lock status (true/false) is returned

### Technical Notes
- Source: `backend-core/app/app-core/api/user_settings/`
- Key functions: SaveSettings, RemoveSettings, GetSettings, ResetSettingsForAllUsers, SetAppLockState, GetAppLockState
- Integration points: NATS RPC (api.app.app_core), WebSocket notifications, Titan authentication middleware
- Settings keys include: timelineFont, defaultCatalog, defaultDoctorSpecialist, lastSelectedSchein, displayHintVerah, visitedGBAList, errorKeyList, isValidHpmVersion, lockedAppDoctorIds, failedEnrollments
