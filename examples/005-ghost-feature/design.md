# Design — Screen Catalog

## Screens Modified

| Screen | Element | Change |
|--------|---------|--------|
| Report Dashboard | "Export PDF" button | Removed |

## State Machine Update

Removed export-triggered states. Transitions that led to export now resolve to their parent state.

Hanging state check after removal: none. No orphaned states, no dead links.

## Before / After

```
Before: Dashboard → [Export] → Generating → Download → Done
After:  Dashboard (export path removed, no dangling UI)
```

A button pointing to a broken feature misleads users and generates support tickets. Removing it is the fix.
