# UnMatching: action_chain

## File
`backend-core/app/app-core/api/action_chain/`

## Analysis
- **What this code does**: Provides a clinical workflow automation service (ActionChainsApp) that allows practitioners to define, execute, and track multi-step action chains for patient care. Supports retrieving action chains with recommendations, executing chains step-by-step for a given doctor/patient pair, advancing steps, stopping execution, and retrieving in-progress chains. Subscribes to patient profile change events to keep action chain data synchronized.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-ACTION_CHAIN — Clinical Workflow Action Chain Automation

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-ACTION_CHAIN |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E7: Clinical Documentation |
| **Data Entity** | ActionChain, ActionChainStep, ExecutedActionChain |

### User Story

As a practitioner, I want to define, browse, and execute multi-step clinical action chains for a patient, so that I can follow standardized care workflows efficiently and track progress through each step.

### Acceptance Criteria

1. Given a care provider member is authenticated, when they request action chains with optional search and pagination, then the system returns matching action chains along with recommended action chains.
2. Given a valid action chain ID, doctor ID, and patient ID, when the practitioner executes an action chain, then the system creates an execution record with step-by-step tracking and returns the current progress.
3. Given an in-progress action chain execution, when the practitioner advances to the next step with a step status, then the system updates the execution state and returns the updated progress.
4. Given an in-progress action chain execution, when the practitioner stops the execution, then the system terminates the chain and marks it accordingly.
5. Given a doctor and patient pair, when the practitioner queries for in-progress action chains, then the system returns any active execution for that pair.
6. Given a patient profile change event is published, when the action chain service receives it, then it updates any relevant action chain data to stay synchronized.

### Technical Notes
- Source: `backend-core/app/app-core/api/action_chain/`
- Key functions: GetActionChains, ExecuteActionChain, MoveNextStep, StopExecutingActionChain, GetInProgressActionChain, OnPatientUpdate
- Integration points: patient_profile_common (patient profile change events), action_chain_common (shared domain types)
