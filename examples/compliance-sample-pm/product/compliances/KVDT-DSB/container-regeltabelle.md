## Container Rule Table (Regeltabelle)

| Field | Value |
|-------|-------|
| **Source** | KVDT-DSB v6.02 |
| **Section** | 2.3.2 |
| **Scope** | Validation rules for Container records |
| **Refer** | [con0](con0.md), [con9](con9.md), [besa](besa.md), [rvsa](rvsa.md), [container-feldtabelle](container-feldtabelle.md) |

### Rules

| R-Nr | Category | Check | Status | Description |
|------|----------|-------|--------|-------------|
| 049 | Format | kknnnnnmm with kk = allowed content per Regel 162, nnnnn = serial number, mm = [undefined] | F | (N)BSNR |
| 050 | Format | nnnnnnnmff with nnnnnn = ID (where "nnnnnn" must not equal "555555"), m = check digit, ff = allowed content per Anlage 35 of the BAR key directory; tolerated substitute value for digits 8-9: 00 | F | Lifelong physician number (LANR). Check digit determination procedure see footnote. |
| 059 | Format | 00nnnnnnP with 00 = ASV-ID prefix, nnnnnn = unique number, P = check digit | I | Check digit determination procedure see footnote. |
| 061 | Format | 35kknnnnn with 35 = hospitals providing services under § 75 Abs. 1a SGB V, kk = allowed content per Regel 162, nnnnn = serial number | F | (N)BSNR KH, hospitals providing services in the context of the appointment service center (Anlage 28 BMV-Ae). BSNR structure see footnote. |
| 062 | Format | 74kknnn63 with 74 = KBV, kk = allowed content per Regel 162, nnn = serial number, 63 = SAPV identifier | F | (N)BSNR SAPV. BSNR structure see footnote. |
| 063 | Format | 555555nff with 555555 = pseudo physician number for hospital physicians in the context of ASV billing, n = sequence number, ff = specialty group code per the respectively valid Anlage 2 of the KBV guideline pursuant to § 75 Abs. 7 SGB V on the assignment of physician, practice site, and practice network numbers | F | Pseudo-LANR for hospital physicians in the context of ASV billing (ASV-AV Anlage 3 specialty group encodings). Value range: n ::= 0 \| 1 \| ... \| 9 |
| 100 | Allowed content | 0 | F | |
| 107 | Allowed content | 0, 1, 2 | F | |
| 124 | Allowed content | 1, 3, 6, 7 | F | |
| 147 | Allowed content | 0, 1 | F | |
| 162 | Allowed content | 01-03, 06-21, 24, 25, 27, 28, 31, 37-73, 78-81, 83, 85-88, 93-96, 98, 99 | F | UKV/OKV identifier in the practice site number + Knappschaft |
| 177 | Allowed content | 1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 | F | |
| 182 | Allowed content | 4 | F | ISO 8859-15 |
| 209 | Allowed content | con0, besa, con9, rvsa | F | |
| 211 | Existence | Key table S_NVV_RV_Zertifikat, OID 1.2.276.0.76.3.1.1.5.2.22 | W | |
| 532 | Allowed content | 01-03, 17, 18, 19, 20, 21, 24, 25, 27, 28, 31, 37, 39-45, 47-51, 55, 60-70, 72, 73, 78-81, 83, 85-87, 93-96, 99 | F | |
| 740 | Context | If field content of FK 0300 = 1, then field 0301 must be present and at least one field 0304 must be present. | W | |
| 741 | Context | If field content of FK 0301 = 1 or 2, then field 0302 must be present. | W | |
| 743 | Context | If field content of FK 8000 = con0 and field content of FK 9132 = 1 and a field 0201 in the record type "besa" (content of FK 8000 = besa) is present, then a record "rvsa" (content of FK 8000 = rvsa) must be present. | W | RVSA record linked to the existence of the ADT data package, see footnote. |
| 748 | Context | If field content of FK 0305 = 2 is present, then at least one field 0302 must be present. | W | |
| 750 | Context | The value in FK 0201 of record type "rvsa" must match one of the values from FK 0201 of record type "besa". | W | |
| 762 | Context | The (substitute) value "888888800" is obsolete and not permitted as field content of FK 0212, 4241, 4242, 5099. | F | |
| 819 | Context | If the content of positions 1-2 of field 0201 = 35, then format rule 061 applies to the content of field 0201. If the content of positions 1-2 of field 0201 = 74, then format rule 062 applies to the content of field 0201. If the content of positions 1-2 of field 0201 is not 35 and not 74, then format rule 049 applies to the content of field 0201. | See Regel 049, 061, 062 | |
| 836 | Context | At least one field FK 0212 or one field FK 0223 must be present. Both field identifiers may also occur together. | F | |
| 857 | Context | Either field 0201 or field 0213 must be present at least once (in the record). Both field identifiers may also occur together. | F | |
| 858 | Context | In field 0225 (TI application / TI component), each allowed value of field identifier 0225 per Regel 177 must occur exactly once per each (N)BSNR (FK 0201) or hospital IK (FK 0213). | F | |
| 862 | Context | In field 0225 (TI application / TI component), each value of field identifier 0225 per Regel 177 may occur at most once per each (N)BSNR (FK 0201) or hospital IK (FK 0213). | F | |
| 872 | Context | If field 0224 is transmitted, then field 0227 must also be transmitted. | F | |
| 874 | Context | If field 0224 is transmitted, then field 0228 must also be transmitted. | W | |
| 875 | Context | The value of a "LANR" (FK 0212) may only occur once under a "(N)BSNR" (FK 0201). | F | A LANR always represents only one person, therefore it may only be transmitted once per BSNR. |
| 878 | Context | The value of a "(N)BSNR" (FK 0201) may only occur once in the besa record. | W | A BSNR may only be transmitted once in the besa record. |
