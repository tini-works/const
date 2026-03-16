# Design Inventory — 005 Ghost Feature Removal

## Screens Removed

| ID | Screen | Reason |
|----|--------|--------|
| SCR-XX | "Export Report" button on dashboard | Feature removed — no active users, dependency dead |

## State Machine Modified

Removed export-triggered states. All transitions that previously led to export now lead to their parent state.

**Hanging state check after removal:** No orphaned states, no dead links. **No hanging states.**

## Observation

A screen pointing to a broken feature is worse than no screen. It misleads users and generates support questions. Removing it is a design improvement.
