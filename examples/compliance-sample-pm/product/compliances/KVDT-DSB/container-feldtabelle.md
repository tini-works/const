## Container Field Table (Feldtabelle)

| Field | Value |
|-------|-------|
| **Source** | KVDT-DSB v6.02 |
| **Section** | 2.3.1 |
| **Scope** | Field validation rules for Container records |
| **Refer** | [con0](con0.md), [con9](con9.md), [besa](besa.md), [rvsa](rvsa.md), [container-regeltabelle](container-regeltabelle.md) |

The field table serves to validate field contents. Some validations can be performed immediately based on entries in this table, while further validations must branch to the [rule table](container-regeltabelle.md) (see Section 2.3.2) or subordinate tables. In the field table, each entry is uniquely assigned to one field. The entries "kvxn" (n=0,1,2,3) are references to the KV-Specifika master file (see Section 1.6.2).

### Fields

| FK | Field Name | Length | Type | Rule | Allowed Values | Example |
|----|-----------|--------|------|------|---------------|---------|
| 0201 | Practice (BSNR) or secondary practice site number (NBSNR) | 9 | n | (049), (061), (062), 750, 819, 857, 875, 878 | | 010123499 |
| 0203 | (N)BSNR / Hospital designation | <=60 | a | | | Gem.-Praxis Dr. Mueller, Hohl |
| 0205 | Street of (N)BSNR / hospital address | <=60 | a | | | Nordstr. 4 |
| 0208 | Telephone number | <=60 | a | | | 0221/473962 |
| 0209 | Fax number | <=60 | a | | | 0221/474562 |
| 0211 | Physician name or explanation | <=60 | a | | | Hansen |
| 0212 | Lifelong physician number (LANR) | 9 | n | 050 | | 123456699 |
| 0213 | Hospital IK (in the context of ASV billing) | 9 | n | 857 | | 261102323 |
| 0214 | KV region | 2 | n | 532 | 01 = Schleswig-Holstein, 02 = Hamburg, 03 = Bremen, 17 = Niedersachsen, 18 = Dortmund, 19 = Muenster, 20 = Dortmund, 21 = Aachen, 24 = Duesseldorf, 25 = Duisburg, 27 = Koeln, 28 = Linker Niederrhein, 31 = Ruhr, 37 = Bergisch-Land, 39 = Darmstadt, 40 = Frankfurt/Main, 41 = Giessen, 42 = Kassel, 43 = Limburg, 44 = Marburg, 45 = Wiesbaden, 47 = Koblenz, 48 = Rheinhessen, 49 = Pfalz, 50 = Trier, 51 = Rheinland-Pfalz, 55 = Karlsruhe, 60 = Freiburg, 61 = Stuttgart, 62 = Reutlingen, 63 = Muenchen Stadt u. Land, 64 = Oberbayern, 65 = Oberfranken, 66 = Mittelfranken, 67 = Unterfranken, 68 = Oberpfalz, 69 = Niederbayern, 70 = Schwaben, 72 = Berlin, 73 = Saarland, 78 = Mecklenburg-Vorpommern, 79 = Potsdam, 80 = Cottbus, 81 = Frankfurt/Oder, 83 = Brandenburg, 85 = Magdeburg, 86 = Halle, 87 = Dessau, 93 = Thueringen, 94 = Chemnitz, 95 = Dresden, 96 = Leipzig, 99 = Knappschaft | |
| 0215 | Postal code of (N)BSNR / hospital address | <=7 | a | | | 50859 |
| 0216 | City of (N)BSNR / hospital address | <=60 | a | | | Koeln |
| 0218 | E-mail of the practice site / practice / hospital | <=60 | a | | | dr.muster@med.de |
| 0219 | Physician title | <=100 | a | | | Dr. |
| 0220 | Physician first name | <=45 | a | | | Hans |
| 0221 | Physician name suffix | <=20 | a | | | von |
| 0222 | ASV team number | 9 | n | 059 | 00nnnnnnP with 00 = ASV-ID prefix, nnnnnn = unique number, P = check digit | 001234566 |
| 0223 | Pseudo-LANR for hospital physicians in the context of ASV billing | 9 | n | 063, 836 | | |
| 0224 | Product version of the connector | <=20 | a | | | |
| 0225 | TI application / TI component | 1-2 | n | 177 | 1 = eRezept, 3 = NFDM, 4 = eMP, 5 = KIM, 6 = eAU, 7 = eArztbrief, 8 = Kartenterminal, 9 = SMC-B, 10 = eHBA, 11 = ePA Stufe 3, 12 = eVDGA, 13 = TIM | 11 |
| 0226 | System support / practice equipment | 1 | n | 147 | 0 = no, 1 = yes | 1 |
| 0227 | Expiration date of the connector certificate | 8 | d | 872 | | |
| 0228 | Product name of the connector | <=60 | a | 874 | | iConnector Pro |
| 0300 | Billing of (certificate-mandatory) laboratory services | 1 | n | 147, 740 | 0 = no, 1 = yes | 1 |
| 0301 | pnSD/uu analyses | 1 | n | 107, 740, 741 | 0 = no, 1 = yes -- exclusively, 2 = yes -- partially | 2 |
| 0302 | Device type | <=60 | a | 741, 748 | | Geraet A 5673 |
| 0303 | Manufacturer | <=60 | a | | | Firma |
| 0304 | Analyte ID | 3 | n | 211, 740 | Values per key table S_NVV_RV_Zertifikat, OID 1.2.276.0.76.3.1.1.5.2.22, XML file: Element key/@V | 004 |
| 0305 | Proficiency test certificate | 1 | n | 107, 748 | 0 = no, 1 = yes, 2 = pnSD/uu analysis | 1 |
| 8000 | Record type | 4 | a | 209, 743 | con0 = Container-Header, con9 = Container-Closing, besa = Practice Site Data, rvsa = Proficiency Test Certificates | con0 |
| 9103 | Creation date | 8 | d | | | 20191231 |
| 9106 | Character set used | 1 | n | 182 | 4 = ISO 8859-15 | 4 |
| 9132 | Data packages contained in this file | 1 | n | 124, 743, kvx0 | 1 = ADT Data Package, 3 = Short-term Medical Billing Data Package, 6 = SADT Data Package, 7 = Hybrid-DRG Data Package | 1 |
