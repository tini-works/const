## besa — Practice Site Data

| Field | Value |
|-------|-------|
| **Satzart** | besa |
| **German Name** | Betriebsstaettendaten |
| **Source** | KVDT-DSB v6.02 |
| **Section** | 2.2.3 Satzart: Betriebsstaettendaten "besa" |
| **Data Package** | Container |
| **Refer** | [con0](con0.md), [con9](con9.md), [rvsa](rvsa.md), [container-feldtabelle](container-feldtabelle.md), [container-regeltabelle](container-regeltabelle.md) |

### Purpose

The Practice Site Data record contains all identifying and address information for the billing practice site(s) and their associated physicians. It is the second record in every KVDT file and must be present exactly once. It captures BSNR/NBSNR, physician LANR numbers, practice addresses, connector/TI component information, and KV region data for all practice sites appearing in the billing file.

### Ordering Rules

Record "besa" must be present exactly once per file. It must be stored as the second record (immediately after [con0](con0.md)).

### Field Table (Satztabelle)

The besa record has a deeply nested hierarchy. The "Occ" column shows the hierarchy level and occurrence count. Levels are separated by dots (e.g., "L1=n" means level 1, occurring n times; "L2=1" means level 2 under the parent, occurring once).

| FK | Occ | Field Name | Type | Condition | Notes |
|----|-----|-----------|------|-----------|-------|
| 8000 | L1=1 | Record type | M | | Record type Practice Site Data |
| 0201 | L1=n | Practice (BSNR) or secondary practice site number (NBSNR) | m | Regel 857, Regel 875, Regel 878 | Billing practice site and, if applicable, all secondary practice site numbers appearing in this billing file; note on laboratory communities with out-of-region LG members, see Section 3.6.3 |
| 0203 | L2=1 | (N)BSNR / Hospital designation | m | | |
| 0212 | L2=n | Lifelong physician number (LANR) | m | Regel 836, Regel 875 | |
| 0219 | L3=1 | Physician title | k | | Relevant for out-of-region LG members |
| 0220 | L3=1 | Physician first name | k | | Relevant for out-of-region LG members |
| 0221 | L3=1 | Physician name suffix | k | | Relevant for out-of-region LG members |
| 0211 | L3=1 | Physician name or explanation | m | | |
| 0222 | L3=n | ASV team number | K | | |
| 0223 | L3=n | Pseudo-LANR for hospital physicians in the context of ASV billing | m | Regel 836 | |
| 0219 | L4=1 | Physician title | k | | |
| 0220 | L4=1 | Physician first name | k | | |
| 0221 | L4=1 | Physician name suffix | k | | |
| 0211 | L4=1 | Physician name or explanation | m | | Explanation for pseudo physician number |
| 0222 | L4=n | ASV team number | m | | |
| 0205 | L2=1 | Street of (N)BSNR / hospital address | m | | |
| 0215 | L2=1 | Postal code of (N)BSNR / hospital address | m | | |
| 0216 | L2=1 | City of (N)BSNR / hospital address | m | | |
| 0208 | L2=1 | Telephone number | m | | Area code, phone number of the practice site / practice / hospital |
| 0209 | L2=1 | Fax number | k | | Area code, fax number of the practice site / practice / hospital |
| 0218 | L2=1 | E-mail of the practice site / practice / hospital | k | | |
| 0224 | L2=1 | Product version of the connector | m | If the information can be captured via the external interface of the base application directory service | See Chapter 7 |
| 0227 | L2=1 | Expiration date of the connector certificate | m | Regel 872 | |
| 0228 | L2=n | Product name of the connector | m | Regel 874 | |
| 0225 | L2=n | TI application / TI component | m | Regel 858, Regel 862 | See Chapter 7 |
| 0226 | L2=1 | System support / practice equipment | m | | See Chapter 7 |
| 0213 | L1=n | Hospital IK (in the context of ASV billing) | m | Regel 857 | May be used in the context of ASV billing of a hospital |
| 0214 | L2=1 | KV region | m | | |
| 0203 | L2=1 | (N)BSNR / Hospital designation | m | | |
| 0212 | L2=n | Lifelong physician number (LANR) | m | Regel 836 | |
| 0219 | L3=1 | Physician title | k | | |
| 0220 | L3=1 | Physician first name | k | | |
| 0221 | L3=1 | Physician name suffix | k | | |
| 0211 | L3=1 | Physician name or explanation | m | | Explanation for pseudo physician number |
| 0222 | L3=n | ASV team number | m | | |
| 0205 | L2=1 | Street of (N)BSNR / hospital address | m | | |
| 0215 | L2=1 | Postal code of (N)BSNR / hospital address | m | | |
| 0216 | L2=1 | City of (N)BSNR / hospital address | m | | |
| 0208 | L2=1 | Telephone number | m | | Area code, phone number of the practice site / practice / hospital |
| 0209 | L2=1 | Fax number | k | | Area code, fax number of the practice site / practice / hospital |
| 0218 | L2=1 | E-mail of the practice site / practice / hospital | k | | |
| 0224 | L2=1 | Product version of the connector | m | If the information can be captured via the external interface of the base application directory service | See Chapter 7 |
| 0227 | L2=1 | Expiration date of the connector certificate | m | Regel 872 | |
| 0228 | L2=n | Product name of the connector | m | Regel 874 | |
| 0225 | L2=n | TI application / TI component | m | Regel 858, Regel 862 | See Chapter 7 |
| 0226 | L2=1 | System support / practice equipment | m | | See Chapter 7 |
