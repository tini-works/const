# Examples — The Constitution in Practice

Each example is a project. Each project has:

- `changelog.md` — step-by-step log of how work flows through all verticals
- Per-role inventory files — the actual artifacts each role maintains for THIS project

Inventory is project-specific. A healthcare check-in inventory looks nothing like an auth migration inventory. There is no universal template.

Every inventory item that claims to be "proven" has a **Verify:** section — concrete steps you can follow to check if the claim still holds. If you can't verify it, it's not proven.

---

| # | Scenario | Nature | What it shows |
|---|----------|--------|---------------|
| 001 | Patient check-in | Healthcare feature | Customer story → fractal translation, engineer surfaces clinical safety risk upward |
| 002 | Silent checkout failure | E-commerce bug | Customer's exact words ("tried 3 times") create an idempotency proof |
| 003 | Auth library migration | Platform migration | Multi-service coordination, suspect flagging, pre-existing rot exposed |
| 004 | Dark mode | Startup scope negotiation | CEO whim → data-grounded scope, Design catches missing architecture |
| 005 | Ghost feature | Maintenance cleanup | Inventory shrinks — staleness → broken → unused → removed |
| 006 | Service rewrite | Engineering freedom | Full Python→Go rewrite, zero approval, contracts held |
