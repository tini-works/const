# UnMatching: referral_data

## File
`backend-core/app/app-core/api/referral_data/`

## Analysis
- **What this code does**: Provides an API for managing referral data (Ueberweisungsdaten). Exposes two endpoints: GetReferralData to retrieve referral data and CreateReferralData to create new referral records. Used in the context of patient referrals between physicians.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-REFERRAL_DATA — Patient Referral Data Management

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-REFERRAL_DATA |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E7 Clinical Documentation |
| **Data Entity** | ReferralData |

### User Story
As a physician, I want to create and retrieve referral data for patient referrals between physicians, so that referral information is documented and accessible for inter-physician coordination.

### Acceptance Criteria
1. Given an authenticated care provider member, when they request referral data, then the current referral data is returned
2. Given valid referral information, when the user creates a new referral data record, then the referral is persisted in the system

### Technical Notes
- Source: `backend-core/app/app-core/api/referral_data/`
- Key functions: GetReferralData, CreateReferralData
- Integration points: `service/domains/referral_data/common` (GetReferralDataResponse, CreateReferralDataRequest)
- All endpoints require CARE_PROVIDER_MEMBER role

---

## POTENTIAL COMPLIANCE RELATION

### Related Compliance Documents

| Compliance | Source File | Relevant Section |
|------------|-------------|------------------|
| 2B.8 HZV/FAV Referral & OPS Rules | [`compliances/phase-2B.8-hzv-fav-referral-ops-rules.md`](../../compliances/phase-2B.8-hzv-fav-referral-ops-rules.md) | [ABRD457](../compliances/SV/ABRD457.md), [ABRD1009](../compliances/SV/ABRD1009.md), [ABRD675](../compliances/SV/ABRD675.md), [ABRD850](../compliances/SV/ABRD850.md) |

### Compliance Mapping

#### 2B.8 HZV/FAV Referral & OPS Rules
**Source**: [`compliances/phase-2B.8-hzv-fav-referral-ops-rules.md`](../../compliances/phase-2B.8-hzv-fav-referral-ops-rules.md)

**Related Requirements**:
- "When referring an HZV patient who is not enrolled in a FAV contract, the referral form (Ueberweisungsformular) must include automatically generated text indicating the patient's HZV enrollment status."
- "When referring a FAV patient, the referral form must include auto-generated text per the FAV contract specifications."
- "When referring a FAV patient, the referral form must include additional contract-specific text fields as defined in the FAV specifications."
- "In connection with issuing a referral (Muster 6) for a FAV patient, the contract software must support generating a cover letter (Begleitschreiben)."

**Mapping to Proposed AC**:
| Proposed AC | Related Compliance Requirement |
|-------------|-------------------------------|
| AC1: Given an authenticated care provider member, when they request referral data, then the current referral data is returned | [ABRD457](../compliances/SV/ABRD457.md): referral form must include automatically generated text indicating the patient's HZV enrollment status |
| AC2: Given valid referral information, when the user creates a new referral data record, then the referral is persisted | [ABRD1009](../compliances/SV/ABRD1009.md): referral form must include auto-generated text per FAV contract specifications; [ABRD850](../compliances/SV/ABRD850.md): support generating a cover letter for FAV referrals |

---

## Recommended Action
- [ ] Review compliance mapping with Compliance Officer
- [ ] Formalize User Story with compliance requirements
- [ ] Add to compliance traceability matrix
