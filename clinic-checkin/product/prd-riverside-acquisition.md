# PRD: Riverside Family Practice Acquisition — Patient Migration

## Problem
We're acquiring Riverside Family Practice. They have 4,000 patients, roughly half in a different EMR system and half on paper. Some of their patients are already our patients. We need to bring everyone into our system without creating duplicates, losing data, or degrading the patient experience.

## Scale
- 4,000 patient records total
- ~2,000 electronic records in Riverside's EMR (different system/schema)
- ~2,000 paper records
- Unknown overlap with our existing patient base (estimate: 5-15% based on geographic proximity)

## Users
- **Riverside patients** who will now check in through our system
- **Clinic administrator** managing the migration
- **Staff** who will review flagged records and resolve duplicates
- **Existing patients** who may also be Riverside patients — their records must not be corrupted

## Solution

### Phase 1: Electronic record migration
- Map Riverside's EMR schema to our data model
- Import records with validation — flag missing required fields
- Run duplicate detection against our existing patient base
- Staff reviews and resolves all flagged duplicates and incomplete records

### Phase 2: Paper record digitization
- Scan all paper records
- OCR extraction of structured fields (name, DOB, address, insurance, allergies, medications)
- High-confidence extractions enter the system as "pending patient confirmation"
- Low-confidence or failed extractions are flagged for manual entry
- Remaining gaps filled on-demand when the patient visits

### Phase 3: Verification and go-live
- Migrated patients can check in at any location
- First visit: patient is prompted to review and confirm all migrated data
- Riverside locations added to the multi-location system
- Migration report delivered to administrator

## Requirements

**Must have:**
- Field mapping between Riverside EMR and our data model
- Validation on import — reject or flag records that don't meet minimum data requirements
- Duplicate detection: matching on name + DOB, phone, SSN (if available), address
- All potential duplicates surfaced to staff with confidence scores — no auto-merge (DEC-006)
- Merge preserves audit trail — both original records remain accessible as reference
- Paper record scanning and OCR pipeline
- Migration report: total processed, imported, flagged, duplicates found, duplicates resolved
- Rollback capability: ability to undo a batch import if systemic issues are found

**Should have:**
- Confidence scoring on OCR extraction (field-level)
- Batch processing for staff review (review 10 duplicates at a time, not one by one)
- Progress dashboard for administrator (how many records migrated, how many pending)
- Patient notification: letter or message to Riverside patients explaining the transition

**Won't have (for now):**
- Historical visit records from Riverside (only demographic/clinical data, not visit history)
- Riverside billing data migration (handled by finance separately)
- Automated patient identity verification (e.g., sending patients a link to confirm their own records)

## Dependencies
- E3 (multi-location) must be in place — Riverside locations need to be added to the system
- E1 (core check-in) must handle the "first visit confirmation" flow for migrated data
- E6 (medication list) must be part of the data model — migrated medication data must conform

## Risks
- **False merges:** Merging two different patients is a safety issue (combined medication lists, allergies). Mitigation: no auto-merge, staff reviews all matches (DEC-006).
- **Data quality:** Riverside's data may be incomplete, inconsistent, or outdated. Mitigation: validation on import, patient confirmation on first visit.
- **Scale of paper records:** 2,000 paper records is a significant digitization effort. Mitigation: OCR first pass reduces manual work; on-demand completion for low-priority records.
- **Timeline pressure:** Acquisition deals have external deadlines. Mitigation: phase the work — electronic records first, paper records on a longer timeline. Patients with appointments in the next 30 days get priority.

## Success metrics
- 100% of Riverside electronic records processed (imported or flagged) within 4 weeks
- Zero false merges (no patient safety incidents from incorrect record combination)
- 90% of paper records OCR-processed within 8 weeks
- Riverside patients check in at any location without needing to re-enter data already in the system
- Staff duplicate review throughput: 50+ records per day per reviewer
