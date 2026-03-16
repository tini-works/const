# Design — Screen Removal and State Cleanup

## What was removed

The Report Dashboard had an "Export PDF" button. It pointed to a dead feature — the PDF library behind it was deprecated 8 months ago. Users who clicked it got a 0-byte download and no error message.

## Screen change: Report Dashboard

**Before:**
```
Report Dashboard
  ┌─────────────────────────┐
  │  [Date Range] [Filter]  │
  │                         │
  │  ... report data ...    │
  │                         │
  │  [Export PDF]  [Share]   │
  └─────────────────────────┘
```

**After:**
```
Report Dashboard
  ┌─────────────────────────┐
  │  [Date Range] [Filter]  │
  │                         │
  │  ... report data ...    │
  │                         │
  │  [Share]                │
  └─────────────────────────┘
```

The "Export PDF" button is gone. No placeholder. No "coming soon." The feature is removed, so the affordance is removed.

**Verify:** Load the Report Dashboard in staging. The Export PDF button is not present. The Share button still works. No layout breakage — the remaining elements fill the space naturally.

## State machine cleanup

**Before:**
```
Dashboard (idle)
    │
    ├── [Export PDF clicked]
    │       → Generating (spinner)
    │           → Download Ready → Done
    │           → Error → Dashboard
    │
    └── [Share clicked]
            → Share Dialog → Done
```

**After:**
```
Dashboard (idle)
    │
    └── [Share clicked]
            → Share Dialog → Done
```

Three states removed: Generating, Download Ready, and the Error state for export failures. The export branch is gone entirely.

**Verify:** Walk the state machine. Every state has at least one outbound transition. Every transition leads to a terminal state or a valid next state. No hanging states — the Dashboard still reaches Done through the Share path, and no orphaned states reference the removed export flow.

## Why removal, not redesign

A button pointing to a broken feature misleads users. It generates confusion (why is my download empty?) and support tickets. Removing the button is the honest response. If PDF export is ever needed again, it will come from a new requirement with a new stakeholder — not from resurrecting dead UI.
