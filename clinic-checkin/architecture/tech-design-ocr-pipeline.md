# Technical Design: Insurance Card OCR & Photo Storage

**Related:** Epic E4, US-011, ADR-006, ADR-009

---

## Problem

Patients struggle to manually enter insurance card numbers, especially at the kiosk. Typos in member IDs and group numbers cause claim rejections downstream. Patients want to photograph their card and have the system extract the fields.

This same image processing capability is reused in Round 10 for paper record digitization during the Riverside migration.

---

## Approach

### Architecture

```
Client (Kiosk / Mobile)
    │
    │  multipart upload: front.jpg + back.jpg
    ▼
Check-In Service
    │
    ├──> Object Storage (S3/MinIO): store images
    │       returns: front_key, back_key
    │
    ├──> OCR Service: extract fields
    │       input: front_key, back_key
    │       output: structured fields + confidence scores
    │
    └──> Return processing_id to client
         Client polls for results
```

The OCR Service is a separate deployable that wraps a third-party OCR API (currently Google Cloud Vision). The Check-In Service never calls the OCR provider directly — always through the OCR Service's stable internal API. This allows us to swap providers without touching the check-in code (ADR-006).

### Image Capture Flow

**Client-side (kiosk and mobile):**

1. Open camera viewfinder with card-shaped guide overlay
2. Patient captures front of card
3. Client-side quality check:
   - Image dimensions: minimum 1200x800px
   - Brightness check: reject if too dark (average luminance < 50/255)
   - Blur detection: Laplacian variance threshold (reject if < 100)
4. If quality check fails: prompt retake with specific feedback
5. Repeat for back of card
6. Upload both images to the Check-In Service

**Why client-side quality checks?** Uploading a blurry/dark image, waiting 3-5 seconds for OCR, then finding out it failed is a poor UX. Catching obvious quality issues before upload saves time and bandwidth, especially on mobile.

### Image Upload & Storage

**Upload endpoint:** `POST /patients/{id}/insurance/{type}/photo`

**Processing:**
1. Receive multipart upload (front + back images)
2. Validate image format (JPEG or PNG) and size (max 10MB per image)
3. Generate S3 keys: `insurance-cards/{patient_id}/{timestamp}-front.jpg`
4. Upload to S3 with server-side encryption (SSE-S3)
5. Create a processing job and return `processing_id` to the client
6. Send images to OCR Service asynchronously

**Why async?** OCR takes 3-5 seconds. Holding the HTTP connection open for that long is fragile, especially on mobile networks. The async pattern (submit -> poll for results) is more resilient.

### OCR Extraction

**OCR Service internal API:**

```
POST /ocr/insurance-card
Content-Type: application/json

{
  "front_image_key": "s3://clinic-checkin-files/insurance-cards/{patient_id}/...-front.jpg",
  "back_image_key": "s3://clinic-checkin-files/insurance-cards/{patient_id}/...-back.jpg"
}
```

**Processing steps:**
1. Download images from S3
2. Send to Google Cloud Vision (document text detection)
3. Parse raw OCR text to extract structured fields using pattern matching:
   - Member ID: look for patterns like "Member ID:", "ID#:", followed by alphanumeric string
   - Group Number: look for "Group:", "Group #:", followed by alphanumeric string
   - Payer Name: typically the largest/most prominent text on the card
   - Plan Type: look for "PPO", "HMO", "EPO", "POS"
   - Effective Date: date patterns near "Effective", "Eff. Date"
4. Calculate per-field confidence:
   - Base confidence from OCR engine
   - Adjusted by extraction pattern quality (exact label match = higher, fuzzy match = lower)
   - Adjusted by field validation (member ID matches expected format = higher)

**Response:**
```json
{
  "status": "complete",
  "fields": {
    "payer_name": { "value": "Blue Cross Blue Shield", "confidence": 0.99 },
    "member_id": { "value": "XYZ789012345", "confidence": 0.97 },
    "group_number": { "value": "88273", "confidence": 0.72 },
    "plan_type": { "value": "PPO", "confidence": 0.88 },
    "effective_date": { "value": "2025-01-01", "confidence": 0.91 }
  },
  "raw_text": "... (full OCR text for debugging) ...",
  "processing_time_ms": 3200
}
```

### Confidence Thresholds

| Confidence | UI Treatment | Action |
|-----------|-------------|--------|
| >= 0.85 | Blue highlight ("Read from your card") | Pre-populate, patient reviews |
| 0.50 - 0.84 | Yellow highlight ("Please verify this field") | Pre-populate but draw attention |
| < 0.50 | Not pre-populated | Field left empty for manual entry |

These thresholds are configurable. We'll tune them after seeing real-world OCR results.

### Reuse for Riverside Paper Records (Round 10)

The same OCR Service handles scanned paper records from the Riverside migration, with a different extraction profile:

```
POST /ocr/patient-record
Content-Type: application/json

{
  "document_key": "s3://clinic-checkin-files/scanned-records/{batch_id}/{source_id}.pdf",
  "extraction_profile": "patient_demographics"
}
```

The extraction profile tells the OCR Service which fields to look for (name, DOB, address, phone, insurance, allergies, medications) and which patterns to use. Insurance card extraction and patient record extraction share the OCR engine but use different parsing logic.

---

## Storage Design

### S3 Bucket Structure

```
clinic-checkin-files/
├── insurance-cards/
│   └── {patient_id}/
│       ├── 2025-03-17T091800Z-front.jpg
│       └── 2025-03-17T091800Z-back.jpg
├── scanned-records/
│   └── {batch_id}/
│       ├── RSV-001-page1.pdf
│       └── RSV-001-page2.pdf
└── ocr-results/
    └── {processing_id}.json       # cached OCR output for debugging/reprocessing
```

### Access Pattern

Images are never served directly from S3 to the browser. The Check-In Service generates presigned URLs on demand:

```typescript
async function getInsuranceCardUrl(patientId: string, side: 'front' | 'back'): Promise<string> {
  const key = await db.insuranceRecords.findFirst({
    where: { patient_id: patientId },
    select: { [`card_${side}_url`]: true }
  });

  return s3.getSignedUrl('getObject', {
    Bucket: 'clinic-checkin-files',
    Key: key,
    Expires: 900  // 15 minutes
  });
}
```

Staff clicks a thumbnail in the patient detail panel -> frontend requests presigned URL from API -> browser loads image directly from S3 via the presigned URL. The URL expires after 15 minutes. No images pass through the application server.

---

## Error Handling

| Failure | Behavior |
|---------|----------|
| Image upload fails (network) | Client retries. After 3 retries: "Upload failed. Enter your information manually." |
| S3 upload fails | Return 500. Client shows manual entry fallback. |
| OCR timeout (> 15s) | Return partial results if available, or failed status. Client shows manual entry fallback. |
| OCR returns garbage | Low confidence scores cause fields to be left empty. Patient enters manually. |
| S3 unavailable for presigned URL | Staff sees "Image unavailable" placeholder. No system crash. |

The critical design principle: OCR failure is never blocking. The patient can always fall back to manual entry. OCR is an accelerator, not a gatekeeper.

---

## Performance

- Expected OCR processing time: 3-5 seconds per card (both sides)
- Image upload: depends on network; kiosk (LAN) ~1 second, mobile (cellular) ~3-5 seconds
- Client polls for OCR results every 1 second
- Total expected time from capture to populated fields: 5-10 seconds

For the Riverside migration, paper record OCR is a batch process and not latency-sensitive. Processing 2,000 scanned records at ~5 seconds each = ~2.8 hours. This runs as a background job.
