# Round 06 — Incident

> "We ran Pave's own database migration to add the RBAC tables. The migration had a bug — it locked the deploy_queue table for 4 hours. Nobody could deploy anything. Three teams had P1 fixes queued. We had to manually apply SQL to unlock the table. The irony was not lost on anyone."
— Kai Tanaka (Senior Platform Engineer), post-mortem
