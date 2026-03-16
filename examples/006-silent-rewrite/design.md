# Design Inventory — Order Processing

Not involved. API contract unchanged — same endpoints, same response shapes.

Confirmation screen now renders faster (backend dropped from 380ms to 92ms). That's not our concern. Our contract is "confirmation visible < 2s" and it was already proven before the rewrite.
