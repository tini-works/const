## ADT Field Table (Feldtabelle)

| Field | Value |
|-------|-------|
| **Source** | KVDT-DSB v6.02 |
| **Section** | 3.5.1 |
| **Scope** | Field definitions and validation rules for ADT data package |

### Fields

| FK | Field Name | Length | Type | Rule | Allowed Values | Example |
|----|-----------|--------|------|------|---------------|---------|
| 0102 | Software Responsible (SV) | ≤ 60 | a | | | KBV Arztsoftware GmbH |
| 0103 | Software | ≤ 60 | a | | | DOCSFUN |
| 0105 | KBV Verification Number | 15-17 | a | 052, 204, 213 | | X/1401/36/id9 |
| 0111 | E-Mail Address of SV | ≤ 60 | a | | | test@kbv.de |
| 0121 | Street of SV | ≤ 60 | a | | | Ottostr. 1 |
| 0122 | Postal Code of SV | ≤ 7 | a | | | 56070 |
| 0123 | City of SV | ≤ 60 | a | | | Koblenz |
| 0124 | Phone Number of SV | ≤ 60 | a | | | 0261/4094 |
| 0125 | Fax Number of SV | ≤ 60 | a | | | 0261/40943 |
| 0126 | Regional System Operator (SB) | ≤ 60 | a | | | Fa. Datasoft |
| 0127 | Street of SB | ≤ 60 | a | | | Dürener Str. 322 |
| 0128 | Postal Code of SB | ≤ 7 | a | | | 50859 |
| 0129 | City of SB | ≤ 60 | a | | | Köln |
| 0130 | Phone Number of SB | ≤ 60 | a | | | 0221/10002 |
| 0131 | Fax Number of SB | ≤ 60 | a | | | 0221/34893 |
| 0132 | Release Version of Software | ≤ 60 | a | 840 | | 2.52b |
| 3000 | Patient Number | ≤ 20 | a | | | 2002 |
| 3003 | Certificate ID | ≤ 60 | a | | | |
| 3006 | CDM Version | 5-11 | a | 055, 307, 308, 790 | | 5.2.0 |
| 3010 | Date and Time of Online Verification and Update (Timestamp) | 14 | n | 060, 864, 869, 876 | | 20191024101010 |
| 3011 | Result of Online Verification and Update | 1 | n | 528 | 1 = VSD update on eGK performed; 2 = No VSD update on eGK required; 3 = VSD update on eGK technically not possible; 4 = Authentication certificate eGK invalid; 5 = Online verification of authentication certificate technically not possible; 6 = VSD update on eGK technically not possible and maximum offline period exceeded | |
| 3012 | Error Code | ≤ 5 | n | | | 12101 |
| 3013 | Verification Number of Professional Service | ≤ 128 | a | | | |
| 3100 | Name Suffix | ≤ 20 | a | | | Herzogin |
| 3101 | Last Name | ≤ 45 | a | | | Schmitz |
| 3102 | First Name | ≤ 45 | a | | | Erna |
| 3103 | Date of Birth | 8 | n | 021, 304, 313 | | 19661024 |
| 3104 | Title | ≤ 20 | a | | | Dr. |
| 3105 | Insurance Number | 6-12 | n | 053, 776 | | 1234567890 |
| 3107 | Street | ≤ 46 | a | | | Holzweg |
| 3108 | Insurance Type | 1 | n | 116, kvx3 | 1 = Member; 3 = Family Insured; 5 = Pensioner | 3 |
| 3109 | House Number | ≤ 9 | a | | | |
| 3110 | Gender | 1 | a | 533 | M = male; W = female; U = unknown; X = undetermined; D = diverse | |
| 3112 | Postal Code | ≤ 10 | a | 478, 479 | | 50859 |
| 3113 | City | ≤ 40 | a | | | Köln |
| 3114 | Residence Country Code | ≤ 3 | a | 784 | | |
| 3115 | Address Supplement | ≤ 40 | a | | | |
| 3116 | WOP | 2 | n | 531, 774 | 00 = Dummy for eGK; 01 = Schleswig-Holstein; 02 = Hamburg; 03 = Bremen; 17 = Niedersachsen; 20 = Westfalen-Lippe; 38 = Nordrhein; 46 = Hessen; (47 = Koblenz); (48 = Rheinhessen); (49 = Pfalz); (50 = Trier); 51 = Rheinland-Pfalz; 52 = Baden-Württemberg; (55 = Nordbaden); (60 = Südbaden); (61 = Nordwürttemberg); (62 = Südwürttemberg); 71 = Bayern; 72 = Berlin; 73 = Saarland; 78 = Mecklenburg-Vorpommern; 83 = Brandenburg; 88 = Sachsen-Anhalt; 93 = Thüringen; 98 = Sachsen | Gebrauch (bspw. KVK-WOP) |
| 3119 | Versicherten_ID | 10 | a | 054, 776, 537 | ≠ T555558879 | |
| 3120 | Prefix Word | ≤ 20 | a | | | bei der |
| 3121 | PostfachPLZ | ≤ 10 | a | 479, 783 | | |
| 3122 | PostfachOrt | ≤ 40 | a | | | |
| 3123 | Postfach | ≤ 8 | a | | | |
| 3124 | PostfachWohnsitzlaendercode | ≤ 3 | a | 784 | | |
| 3673 | Permanent Diagnosis (ICD Code) | 3,5,6 | a | 022, 486, 489, 490, 491, 492, 728, 729, 761, 817, 860 | | |
| 3674 | Diagnosis Certainty Permanent Diagnosis | 1 | a | 109, 860 | G = confirmed diagnosis; A = exclusion; V = suspected; Z = condition after | |
| 3675 | Laterality Permanent Diagnosis | 1 | a | 110 | R = right; L = left; B = bilateral | |
| 3676 | Diagnosis Explanation Permanent Diagnosis | ≤ 60 | a | | | |
| 3677 | Diagnosis Exception Status Permanent Diagnoses | ≤ 60 | a | 491 | | Zustand nach Geschlechtsumwandlung |
| 4101 | Quarter | 5 | n | 016, 324, 480, 706, kvx0 | | 12020 |
| 4102 | Issue Date | 8 | d | 405, 406 | | 20200101 |
| 4103 | Referral/Contact Type | 1 | n | 108, 870, 877 | 1 = TSS Terminal Case; 2 = TSS Acute Case; 3 = GP Referral Case; 4 = Open Consultation; 6 = TSS Routine Appointment | |
| 4104 | Billing VKNR | 5 | n | 017, 201, 212, 763, 790 | | 27106 |
| 4105 | Supplementary Information on Referral/Contact Type | ≤ 60 | a | | | |
| 4106 | Cost Bearer Billing Area (KTAB) | 2 | n | 174, 778, 779, 780, 818, 827, kvx2 | 00 = Primary billing; 01 = Social Insurance Agreement (SVA); 02 = Federal Care Act (BVG); 03 = Federal Compensation Act (BEG); 04 = Cross-border commuter (GG); 05 = Rhine Shipping (RHS); 06 = Social welfare recipients, excluding asylum seekers (SHT); 07 = Federal Displaced Persons Act (BVFG); 08 = Asylum seekers (AS); 09 = Pregnancy terminations | 00 |
| 4108 | Approval Number (mobile reader) | ≤ 40 | a | | | INGHC; ORGA930M;4.9.0: 1.0.0 (Hersteller-ID;ProduktKürzel;Produktversion (=Firmwareversion: Hardwareversion)) |
| 4109 | Last Card Read Date in Quarter | 8 | d | 480, 776, 790, 876 | | 20210505 |
| 4110 | Insurance Coverage End | 8 | d | 315 | | 20201010 |
| 4111 | Cost Bearer Identifier | 9 | n | 202 | | 101568008 |
| 4112 | eEB present | 1 | n | 142, 895 | 1 = yes | |
| 4114 | Referral Code | 14 | a | | | 14-digit referral code e.g. XN6P-F4HP-Z5KX |
| 4115 | Day of Appointment Referral | 8 | d | 877, 886, 887 | | |
| 4121 | Fee Schedule | 1 | n | 113, 210 | 0 = EBM; 1 = BMÄ; 2 = E-GO; 3 = GOÄ | 1 |
| 4122 | Billing Area | 2 | n | 131, kvx2 | 00 = no special billing area (default); 01 = Dialysis Physician Costs; 02 = Dialysis Material Costs; 03 = Methadone Substitution Treatment; 04 = personally provided emergency services by authorized hospital physicians; 05 = other emergency services by authorized hospital physicians; 06 = External Cytology; 07 = Diabetes Billing; 08 = Environmental Medicine; 09 = Rheumatology; 10 = Brain Performance Disorders; 14 = Ambulatory Surgery; 15 = AOP per §115b | 00 |
| 4123 | Person Group / Examination Category | 2 | n | 149, kvx3 | 01 = Injured Person; 02 = Severely Disabled Person; 03 = Relative; 04 = Surviving Dependent; 05 = Caregiver; 06 = Fitness Examination; 07 = Medical Care; 08 = Applicant; 09 = Initial Examination; 10 = Follow-up Examination; 11 = Supplementary Examination; 12 = Tracked Person | 03 |
| 4124 | SKT Supplementary Data | 5 ≤ 60 | a | 734, kvx3 | | Österreich |
| 4125 | Validity Period from ... to ... | 16 | n | 058, 363, kvx3 | | 2019100120191015 |
| 4126 | SKT Remarks | ≤ 60 | a | kvx3 | | |
| 4131 | Special Person Group | 2 | a | 534, 778, 779, 780, 818, 827 | 00 = no Special Person Group (default); 04 = BSHG (Federal Social Assistance Act) § 264 SGB V; 06 = SER (Social Compensation Law, formerly BVG); 07 = SVA identifier for inter-state health insurance law: persons residing domestically, billing by expenditure; 08 = SVA identifier, lump sum; 09 = Recipients of health services under §§ 4 and 6 of the Asylum Seekers' Benefits Act (AsylbLG) | |
| 4132 | DMP Identifier | 2 | a | 537 | 00 = no DMP identifier (default); 01 = Diabetes mellitus Typ 2; 02 = Breast Cancer; 03 = Coronary Heart Disease; 04 = Diabetes mellitus Typ 1; 05 = Asthma bronchiale; 06 = COPD (chronic obstructive pulmonary disease); 07 = Chronic Heart Failure; 08 = Depression; 09 = Back Pain; 10 = Rheumatology; 11 = Osteoporosis; 12 = Adipositas; 30 = Diabetes Typ 2 and KHK; 31 = Asthma and Diabetes Typ 2; 32 = COPD and Diabetes Typ 2; 33 = COPD and KHK; 34 = COPD, Diabetes Typ 2 and KHK; 35 = Asthma and KHK; 36 = Asthma, Diabetes Typ 2 and KHK; 37 = Breast Cancer and Diabetes Typ 2; 38 = Diabetes Typ 1 and KHK; 39 = Asthma and Diabetes Typ 1; 40 = Asthma and Breast Cancer; 41 = Breast Cancer and KHK; 42 = Breast Cancer and COPD; 43 = COPD and Diabetes Typ 1; 44 = Breast Cancer, Diabetes Typ 2 and KHK; 45 = Asthma, Breast Cancer and Diabetes Typ 2; 46 = Breast Cancer and Diabetes Typ 1; 47 = COPD, Diabetes Typ 1 and KHK; 48 = Breast Cancer, COPD and Diabetes Typ 2; 49 = Asthma, Diabetes Typ 1 and KHK; 50 = Asthma, Breast Cancer and KHK; 51 = Breast Cancer, COPD and KHK; 52 = Breast Cancer, COPD, Diabetes Typ 2 and KHK; 53 = Asthma, Breast Cancer, Diabetes Typ 2 and KHK; 54 = Breast Cancer, Diabetes Typ 1 and KHK; 55 = Asthma, Breast Cancer and Diabetes Typ 1; 56 = Asthma, Breast Cancer, Diabetes Typ 1 and KHK; 57 = Breast Cancer, COPD and Diabetes Typ 1; 58 = Breast Cancer, COPD, Diabetes Typ 1 and KHK | |
| 4133 | Insurance Coverage Start | 8 | d | 775 | | |
| 4134 | Cost Bearer Name | ≤ 45 | a | 777 | | |
| 4202 | Accident, Accident Consequences | 1 | n | 142 | 1 = yes | 1 |
| 4204 | Restricted Benefit Entitlement per §16 Abs. 3a SGB V | 1 | n | 142 | 1 = yes | |
| 4205 | Order | ≤ 60 | a | 744, 746, 755 | | |
| 4206 | Expected Day of Delivery | 8 | d | | | 20191012 |
| 4207 | Diagnosis / Suspected Diagnosis | ≤ 60 | a | 746 | | Verdacht auf Hepatitis |
| 4208 | Finding / Medication | ≤ 60 | a | 746 | | |
| 4209 | Supplementary Information on Examinations | ≤ 60 | a | 756 | | |
| 4214 | Treatment Day for IVD Services | 8 | d | 899, 900 | | |
| 4217 | (N)BSNR of Referrer | 9 | n | (049), (061), 319, 431, 820 | | |
| 4218 | (N)BSNR of Referring Physician | 9 | n | (049), (061), 319, 328, 720, 746, 821, 822 | | |
| 4219 | Referral from Other Physicians | ≤ 60 | a | 328 | | |
| 4220 | Referral to | ≤ 60 | a | 320 | | Radiologen |
| 4221 | Curative / Preventive / ESS / Inpatient Treatment | 1 | n | 205, 404, 754 | 1 = curative; 2 = preventive; 3 = Contraception regulation, sterilization, pregnancy termination; 4 = inpatient treatment | |
| 4225 | ASV Team Number of Referrer | 9 | n | 059, 431 | | |
| 4226 | ASV Team Number of Referring Physician | 9 | n | 059, 328, 838 | | |
| 4229 | Exception Indication | 5 | n | 432 | | 87777 |
| 4233 | Inpatient Treatment from... to... | 16 | n | 058, 354 | | 2019100120191015 |
| 4234 | Recognized Psychotherapy | 1 | n | 142 | 1 = yes | |
| 4235 | Date of Approval Decision | 8 | d | | | 20191001 |
| 4236 | Clarification of Somatic Causes before Psychotherapy | 1 | n | 142 | 1 = yes | |
| 4239 | Certificate Subgroup | 2 | n | 331, 354, 356, 426, 427, 754, 755, kvx2 | Allowed values for record type 0101: 00 = Outpatient Treatment (default); Allowed values for record type 0102: 20 = Self-referral; 21 = Commissioned services (default for sending practices); 23 = Consiliary examination; 24 = Co-/Continued treatment (default; except for sending practices); 26 = Inpatient co-treatment, reimbursement per outpatient principles; 27 = Referral certificate for laboratory examinations as commissioned service (Muster 10 and 10C); 28 = Requisition certificate for laboratory examinations at laboratory associations (Muster 10a); Allowed values for record type 0103: 30 = Inpatient treatment (default); 31 = Inpatient co-treatment; 32 = Vacation/illness substitute for inpatient treatment; Allowed values for record type 0104: 41 = Physician emergency service (default); 42 = Vacation/illness substitute; 43 = Emergency; 44 = Emergency service with taxi; 45 = Emergency physician/ambulance (rescue service); 46 = Central emergency service | 24 |
| 4241 | Lifelong Physician Number (LANR) of Referrer | 9 | n | 056, 762, 844 | | |
| 4242 | Lifelong Physician Number (LANR) of Referring Physician | 9 | n | 056, 721, 762, 845 | | |
| 4243 | Continuing Treating Physician | ≤ 60 | a | | | Dr. Meier |
| 4247 | Application Date (of approval decision) | 8 | d | | | |
| 4248 | Pseudo-LANR (for hospital physicians in ASV billing) of Referrer | 9 | n | 064, 844 | | |
| 4249 | Pseudo-LANR (for hospital physicians in ASV billing) of Referring Physician | 9 | n | 064, 845 | | |
| 4250 | Combination Treatment of Individual and Group Therapy | 1 | n | 142 | 1 = yes | |
| 4251 | Implementation Type of Combination Treatment | 1 | n | 176 | 1 = Sole implementation with predominantly individual therapy; 2 = Sole implementation with predominantly group therapy; 3 = Individual therapy share when conducted by two psychotherapists; 4 = Group therapy share when conducted by two psychotherapists | |
| 4252 | Total Number of Approved Therapy Units for Insured | ≤ 3 | n | 850, 852, 897 | | |
| 4253 | Approved GOP for Insured | 5, 6 | a | 042, 850, 853, 897 | | 35200 |
| 4254 | Number of Billed GOPs for Insured | ≤ 3 | n | | | |
| 4255 | Total Number of Approved Therapy Units for Reference Person | ≤ 3 | n | 851, 852 | | |
| 4256 | Approved GOP for Reference Person | 5, 6 | a | 042, 851, 853 | | 35200B |
| 4257 | Number of Billed GOPs for Reference Person | ≤ 3 | n | | | |
| 4299 | Lifelong Physician Number (LANR) of Contract Psychotherapist | 9 | n | 050, 762 | | |
| 5000 | Service Date | 8 | d | 304, 315, 324, 363, 899, 900 | | 20191001 |
| 5001 | Fee Schedule Number (GNR) | ≤ 9 bzw. 5, 6 | a | 203, 496, 497, 701, 702, 703, 704, 749, 770, 816, 828, 829, 830, 834, 843, 847, 848, 854, kvx1, kvx2 | | 03000 |
| 5002 | Type of Examination | ≤ 60 | a | | | Esterasereaktion |
| 5003 | (N)BSNR of Referring Specialist | 9 | n | 049 | | |
| 5005 | Multiplier | 3 | n | 535, 894 | | 002 |
| 5006 | Time | 4 | n | 005 | | 1215 |
| 5008 | DKM | ≤ 3 | n | kvx1 | | 4 |
| 5009 | Free-text Justification | ≤ 60 | a | | | Neuerkrankung |
| 5010 | Charge Number | ≤ 60 | a | 868 | | R3J404Y |
| 5011 | Material Cost Description | ≤ 60 | a | | | Norm-Silberstift |
| 5012 | Material Costs in Cents | ≤ 10 | n | 710 | | 12345 |
| 5013 | Percent of Service | 3 | n | | | 167 |
| 5015 | Organ | ≤ 60 | a | | | Niere |
| 5016 | Name of Physician | ≤ 60 | a | | | Dr. Pütz |
| 5017 | Visit Location for Home Visits | ≤ 60 | a | | | Neustadt |
| 5018 | Zone for Visits | 2 | a | 111 | | Z1 |
| 5019 | Place of Service / Device Location | ≤ 60 | a | | | |
| 5020 | Follow-up Examination | 1 | n | 147 | 0 = no; 1 = yes | 0 |
| 5021 | Year of Last Cancer Screening | 4 | n | 027 | | 2015 |
| 5023 | GO Number Suffix | 1 | a | | | b |
| 5024 | GNR Additional Indicator for Post-inpatient Services | 1 | a | 521 | N = post-inpatient service | N |
| 5025 | Admission Date | 8 | d | | | 20191001 |
| 5026 | Discharge Date | 8 | d | | | 20191005 |
| 5034 | OP Date | 8 | d | 701 | | 20191003 |
| 5035 | OP Code | ≤ 8 | a | 223, 702, 703, 705 | | 5-301.1 |
| 5036 | GNR as Justification | 5, 6 | a | 042, 702, 704 | | 02300 |
| 5037 | Total Suture Time (Minutes) | ≤ 3 | n | | | 60 |
| 5038 | Complication | ≤ 60 | a | | | Blutung |
| 5040 | Patient Number of eDocumentation Skin Cancer Screening | ≤ 8 | a | | | |
| 5041 | Laterality OPS | 1 | a | 110, 178, 705, 706 | R = right; L = left; B = bilateral (until treatment quarter Q4/2025) | R |
| 5042 | Quantity Contrast/Medication | ≤ 5 | n | 707 | | 80 |
| 5043 | Unit of Measure Contrast/Medication | 1 | n | 106 | 1 = ml; 2 = mg; 3 = µg | 1 |
| 5050 | Report ID Implant Register | 10 | a | 888, 894 | | |
| 5051 | Hash String Implant Register | ≤ 512 | a | 889 | | |
| 5052 | Hash Value Implant Register | 64 | a | 890 | | |
| 5074 | Name Manufacturer / Supplier | ≤ 60 | a | | | |
| 5075 | Article / Model Number | ≤ 60 | a | | | |
| 5076 | Invoice Number | ≤ 20 | a | | | |
| 5077 | HGNC Gene Symbol | ≤ 20 | a | 222, 770, 816, 828, 829, 830, 834, 843, 854, 891, 892, 893 | Values per Element /key/@DN of HGNC key table | |
| 5078 | Gene Name | ≤ 60 | a | 816, 891, 893 | | |
| 5079 | Type of Disease | ≤ 60 | a | 770, 816, 828, 834, 843, 847, 848, 854 | Free text | Sichelzellanämie |
| 5098 | (N)BSNR of Place of Service Delivery | 9 | n | (049), (061), (062), 716, 720, 724, 823, 859, 869 | | |
| 5099 | Lifelong Physician Number (LANR) of Contract Physician / Contract Psychotherapist | 9 | n | (050), (056), 715, 721, 723, 725, 762, 837 | | |
| 5100 | ASV Team Number of Contract Physician | 9 | n | 059, 789, 838 | | 001234566 |
| 5101 | Pseudo-LANR (for hospital physicians in ASV billing) of LE | 9 | n | 063, 837, 839 | | |
| 5102 | Hospital IK (in ASV billing) | 9 | n | 859 | | |
| 6001 | ICD Code | 3,5,6 | a | 022, 486, 489, 490, 491, 492, 728, 729, 761, 817, 828, 829, 830, 843, 854, 856 | | L50.0 |
| 6003 | Diagnosis Certainty | 1 | a | 109, 856 | V = suspected; Z = condition after; A = exclusion; G = confirmed diagnosis | Z |
| 6004 | Laterality | 1 | a | 110 | R = right; L = left; B = bilateral | |
| 6006 | Diagnosis Explanation | ≤ 60 | a | | | |
| 6008 | Diagnosis Exception Status | ≤ 60 | a | 491 | | Zustand nach Geschlechtsumwandlung |
| 8000 | Record Type | 4 | a | 175, 331, 426, 427, 356, 870, kvx2, kvx3 | adt0 = ADT Data Package Header; adt9 = ADT Data Package Trailer; 0101 = Outpatient Treatment; 0102 = Referral; 0103 = Inpatient Treatment; 0104 = Emergency Service / Substitute / Emergency | 0102 |
| 9102 | Recipient | 2 | n | 532, kvx0 | 01 = Schleswig-Holstein; 02 = Hamburg; 03 = Bremen; 17 = Niedersachsen; 18 = Dortmund; 19 = Münster; 20 = Dortmund; 21 = Aachen; 24 = Düsseldorf; 25 = Duisburg; 27 = Köln; 28 = Linker Niederrhein; 31 = Ruhr; 37 = Bergisch-Land; 39 = Darmstadt; 40 = Frankfurt/Main; 41 = Gießen; 42 = Kassel; 43 = Limburg; 44 = Marburg; 45 = Wiesbaden; 47 = Koblenz; 48 = Rheinhessen; 49 = Pfalz; 50 = Trier; 51 = Rheinland-Pfalz; 55 = Karlsruhe; 60 = Freiburg; 61 = Stuttgart; 62 = Reutlingen; 63 = München Stadt u. Land; 64 = Oberbayern; 65 = Oberfranken; 66 = Mittelfranken; 67 = Unterfranken; 68 = Oberpfalz; 69 = Niederbayern; 70 = Schwaben; 72 = Berlin; 73 = Saarland; 78 = Mecklenburg-Vorpommern; 79 = Potsdam; 80 = Cottbus; 81 = Frankfurt/Oder; 83 = Brandenburg; 85 = Magdeburg; 86 = Halle; 87 = Dessau; 88 = Sachsen-Anhalt; 93 = Thüringen; 94 = Chemnitz; 95 = Dresden; 96 = Leipzig; 99 = Knappschaft | 27 |
| 9115 | Creation Date ADT Data Package | 8 | d | | | 20191001 |
| 9204 | Billing Quarter | 5 | n | 016 | | 22020 |
| 9212 | Version of Record Description | ≤ 11 | a | 031, 813 | | |
| 9250 | AVWG Verification Number of AVS | 15-17 | a | 052, 204 | | Y/1/2001/36/id9 |
| 9251 | HMV Verification Number | 15-17 | a | 052, 204 | | Y/2/2001/36/xxx |
| 9260 | Number of Partial Billings | 2 | n | 129 | | 03 |
| 9261 | Billing Part x of y | 2 | n | 132, 738 | | 01 |
| 9901 | System Internal Parameter | ≤ 60 | a | 999* | | abcd/q<rs |
