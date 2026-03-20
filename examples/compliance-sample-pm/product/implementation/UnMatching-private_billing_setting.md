# UnMatching: private_billing_setting

## File
`backend-core/app/app-core/api/private_billing_setting/`

## Analysis
- **What this code does**: Manages configuration settings for private billing per practice location (BSNR). Provides save and get operations for private billing settings, allowing practices to customize their private billing behavior on a per-BSNR basis.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-PRIVATE_BILLING_SETTING — Private Billing Settings per Practice Location

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-PRIVATE_BILLING_SETTING |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E1=Billing Documentation |
| **Data Entity** | PrivateBillingSetting, BSNR |

### User Story
As a practice administrator, I want to configure private billing settings per practice location (BSNR), so that each practice location can customize its private billing behavior according to its specific requirements.

### Acceptance Criteria
1. Given a BSNR ID and setting data, when the user saves private billing settings, then the system persists the configuration and returns the saved settings with its ID
2. Given a BSNR ID, when the user retrieves private billing settings, then the system returns the current configuration for that practice location

### Technical Notes
- Source: `backend-core/app/app-core/api/private_billing_setting/`
- Key functions: SavePrivateBillingSetting, GetPrivateBillingSetting
- Integration points: `backend-core/service/domains/private_billing_setting/common` (PrivateBillingSetting model)
