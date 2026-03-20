# KVDT Code Index

Maps code files to KVDT compliance user stories.

| File (full path) | Description | Related User Stories | All US functions covered? |
|---|---|---|---|
| ares/service/domains/catalog_sdkt/catalog_sdkt_service.go | KT master data CRUD (create/edit/validate SDKT catalog items with IK/VKNR) | [US-K2-276](US-K2-276.md) | no |
| ares/service/domains/repos/masterdata_repo/sdkt/repo.go | SDKT repo with IK number search and VKNR-based lookup | [US-K2-276](US-K2-276.md) | no |
| ares/app/mvz/api/catalog_sdkt/catalog_sdkt.d.go | API definitions for catalog SDKT operations | [US-K2-276](US-K2-276.md) | unclear |
| ares/proto/app/mvz/catalog_sdkt.proto | Proto definitions for SDKT catalog | [US-K2-276](US-K2-276.md) | unclear |
| pkgs/pvs-hermes/bff/app_mvz_catalog_sdkt.ts | BFF types for catalog SDKT | [US-K2-276](US-K2-276.md) | unclear |
| pkgs/pvs-hermes/bff/catalog_sdkt_common.ts | Common types for SDKT catalog | [US-K2-276](US-K2-276.md) | unclear |
| ares/service/domains/api/patient_profile_common/insurance.extend.go | IsDummyVknrFunc filters fictitious VKNR 74799 from billing | [US-K2-480](US-K2-480.md) | no |
| ares/service/billing_kv/service.go | KV billing orchestration, TSS hints, fictitious patient filtering, psychotherapy 88130/88131 | [US-K2-480](US-K2-480.md), [US-K2-60](US-K2-60.md), [US-K2-512](US-K2-512.md), [US-K2-969](US-K2-969.md) | no |
| pkgs/pvs-hermes/bff/billing_kv_common.ts | Billing KV common types | [US-K2-480](US-K2-480.md), [US-K2-60](US-K2-60.md), [US-K2-900](US-K2-900.md), [US-K2-940](US-K2-940.md), [US-K2-947](US-K2-947.md) | unclear |
| pkgs/pvs-hermes/bff/app_mvz_billing_kv.ts | BFF types for KV billing | [US-K2-480](US-K2-480.md), [US-K2-60](US-K2-60.md) | unclear |
| ares/service/domains/tss/tss_service.go | TSS service with referral code handling via FHIR | [US-K2-512](US-K2-512.md) | no |
| ares/service/domains/tss/builder.go | TSS FHIR parameters builder for M6/PTV11 referral requests | [US-K2-512](US-K2-512.md) | no |
| ares/service/domains/tss/constant.go | TSS FHIR naming systems and constants | [US-K2-512](US-K2-512.md) | yes |
| ares/service/timeline_validation/service/validation_timeline/validations/service_code/kv/rule/tss.surcharge.suggestion.validator.go | TSS surcharge suggestion validation per service chain GNR | [US-K2-512](US-K2-512.md), [US-K2-620](US-K2-620.md), [US-K2-650](US-K2-650.md) | no |
| ares/service/schein/schein_service.go | Schein service with TSS-related fields, KV schein by IK number | [US-K2-512](US-K2-512.md) | no |
| ares/proto/app/mvz/tss.proto | TSS app proto definitions | [US-K2-512](US-K2-512.md) | unclear |
| pkgs/pvs-hermes/bff/app_mvz_tss.ts | BFF types for TSS | [US-K2-512](US-K2-512.md) | unclear |
| ares/pkg/con_file/builder.go | BuildBesa for besa record with LANR, FK 5034/5037 field handling | [US-K2-60](US-K2-60.md), [US-K2-900](US-K2-900.md), [US-K2-940](US-K2-940.md) | no |
| ares/service/domains/sdkv/service.go | SDKVService.GetSDKVByBsnrs for billing region lookup | [US-K2-60](US-K2-60.md) | no |
| ares/proto/app/mvz/billing_kv.proto | KV billing proto definitions | [US-K2-60](US-K2-60.md) | unclear |
| ares/service/timeline_validation/service/validation_timeline/validations/service_code/kv/rule/auto.convert.service.code.validator.go | AutoConvertServiceValidator for GNR replacement rules | [US-K2-620](US-K2-620.md), [US-K2-650](US-K2-650.md) | no |
| ares/service/domains/timeline/timeline_service/timeline_service.go | TimelineService with ChainId, Document88130, TerminalServiceCodes | [US-K2-620](US-K2-620.md), [US-K2-969](US-K2-969.md) | no |
| pkgs/pvs-hermes/bff/app_mvz_timeline.ts | BFF types for timeline/service entries | [US-K2-620](US-K2-620.md), [US-K2-969](US-K2-969.md) | unclear |
| pkgs/pvs-hermes/bff/service_domains_validation_timeline.ts | Validation timeline types | [US-K2-620](US-K2-620.md), [US-K2-650](US-K2-650.md), [US-K2-940](US-K2-940.md) | unclear |
| ares/service/domains/repos/masterdata_repo/sdebm/repo.go | SdebmRepo for EBM master data access | [US-K2-650](US-K2-650.md), [US-K2-947](US-K2-947.md) | no |
| ares/service/domains/error_code/error_code.d.go | ErrorCode definitions including Validation_ReplacedWithServiceCodeWhenBilling | [US-K2-650](US-K2-650.md) | no |
| ares/pkg/xdt/bdt/model/schein.go | Di5034/Di5037 field definitions for OP date and GSNZ | [US-K2-900](US-K2-900.md) | no |
| ares/service/domains/repos/masterdata_repo/sdebm/additional_field/rule_config.go | FK 5034/5037 additional field rules | [US-K2-900](US-K2-900.md), [US-K2-930](US-K2-930.md), [US-K2-940](US-K2-940.md) | no |
| ares/service/domains/internal/referral_data/service.go | ReferralDataService for referral form data management | [US-K2-930](US-K2-930.md) | no |
| ares/service/timeline_validation/service/validation_timeline/validations/service_code/kv/precondition/kv.service.include.ops.validator.go | OPSDate_5034 validation for OP date on supervisory services | [US-K2-930](US-K2-930.md), [US-K2-940](US-K2-940.md) | no |
| ares/proto/app/mvz/referral_data.proto | Referral data proto definitions | [US-K2-930](US-K2-930.md) | unclear |
| pkgs/pvs-hermes/bff/app_mvz_referral_data.ts | BFF types for referral data | [US-K2-930](US-K2-930.md) | unclear |
| pkgs/pvs-hermes/bff/referral_data_common.ts | Referral data common types | [US-K2-930](US-K2-930.md) | unclear |
| ares/service/domains/catalog_sdebm/catalog_sdebm_service.go | CatalogSdebmService for EBM catalog operations | [US-K2-947](US-K2-947.md) | no |
| ares/tools/sdebm/model/go_root_v1.60.xsd__001.go | EBM XML schema model with zeitbedarf_liste and pruefzeit elements | [US-K2-947](US-K2-947.md) | no |
| ares/service/timeline_validation/service/validation_timeline/validations/service_code/kv/precondition/kv.psychotherapy.validator.go | PsychotherapyValidator with 88130/88131 validation logic | [US-K2-969](US-K2-969.md) | no |
| ares/app/mvz/api/timeline/timeline.d.go | Document88130Request/Response API definitions | [US-K2-969](US-K2-969.md) | no |
| ares/service/schein/schein_service.kv.go | KV Schein service - certificate overview data | [US-K20-061](US-K20-061.md) | no |
| ares/service/schein/schein_service.go | Schein service - billing case creation and patient data | [US-K26-08](US-K26-08.md), [US-K4-50](US-K4-50.md) | no |
| ares/service/schein/schein_validation.go | Schein validation rules | [US-K4-20](US-K4-20.md) | no |
| ares/service/schein/field.go | Field validation rules for Schein | [US-K4-20](US-K4-20.md) | no |
| ares/service/billing_kv/mapper.go | KV billing mapper | [US-K4-10](US-K4-10.md) | unclear |
| ares/service/mail/mail_service.go | Mail service - KIM send/receive orchestration | [US-K26-01](US-K26-01.md), [US-K26-02](US-K26-02.md), [US-K26-04](US-K26-04.md), [US-K26-05](US-K26-05.md), [US-K26-06](US-K26-06.md), [US-K26-07](US-K26-07.md) | no |
| ares/service/mail/pop3_service.go | KIM POP3 receive service | [US-K26-05](US-K26-05.md), [US-K26-06](US-K26-06.md) | no |
| ares/service/mail/mail_setting_service.go | Mail settings service | [US-K26-05](US-K26-05.md) | unclear |
| ares/service/domains/ti_service/ti_setting.service.go | TI/Konnektor settings | [US-K26-05](US-K26-05.md) | no |
| ares/service/domains/catalog_sdebm/catalog_sdebm_service.go | SDEBM catalog service - EBM display/search/validation | [US-K2-947](US-K2-947.md), [US-K6-760](US-K6-760.md), [US-K6-790](US-K6-790.md) | no |
| ares/service/domains/repos/masterdata_repo/sdebm/repo.go | SDEBM master data repository | [US-K6-760](US-K6-760.md), [US-K6-790](US-K6-790.md) | no |
| ares/service/domains/repos/masterdata_repo/sdebm/additional_field/rule.go | SDEBM additional field rule definitions | [US-K6-800](US-K6-800.md) | no |
| ares/service/timeline_validation/service/validation_timeline/validations/service.validator.go | Service validator orchestrator (EBM checks) | [US-K6-770](US-K6-770.md), [US-K6-780](US-K6-780.md), [US-K6-790](US-K6-790.md), [US-K6-800](US-K6-800.md) | no |
| ares/service/timeline_validation/service/validation_timeline/validations/service_code/sv/condition.validator.go | EBM condition validator (Bedingungen) | [US-K6-770](US-K6-770.md), [US-K6-780](US-K6-780.md), [US-K6-800](US-K6-800.md) | no |
| ares/service/timeline_validation/service/validation_timeline/validations/service_code/kv/precondition/sdkv.validator.go | KV-specific condition validator | [US-K6-800](US-K6-800.md) | no |
| ares/service/domains/pkg/forms/personal_fields_builder.go | Personal fields builder for form population | [US-K26-02](US-K26-02.md), [US-K26-03](US-K26-03.md), [US-K4-40](US-K4-40.md) | no |
| ares/service/domains/pkg/forms/pdf_generator.go | PDF form generation | [US-K26-03](US-K26-03.md) | unclear |
| ares/service/domains/form/form_service/form_service.go | Form service logic | [US-K26-02](US-K26-02.md), [US-K26-03](US-K26-03.md), [US-K26-07](US-K26-07.md), [US-K4-40](US-K4-40.md) | no |
| ares/service/domains/form/common/form_common.d.go | Form common type definitions | [US-K26-03](US-K26-03.md), [US-K26-07](US-K26-07.md) | no |
| ares/pkg/con_file/extractor.go | ConFile extractor (record type parsing) | [US-K4-10](US-K4-10.md) | no |
| ares/app/mvz/internal/barcode/application.go | Barcode application (barcode logic for forms) | [US-K4-40](US-K4-40.md) | no |
| ares/app/mvz/api/mail/mail.d.go | Mail API definitions | [US-K26-01](US-K26-01.md), [US-K26-02](US-K26-02.md), [US-K26-04](US-K26-04.md), [US-K26-06](US-K26-06.md) | no |
| ares/app/mvz/api/billing_kv/billing_kv.d.go | Billing KV API definitions | [US-K4-10](US-K4-10.md), [US-K4-20](US-K4-20.md) | no |
| ares/app/mvz/api/schein/schein.d.go | Schein API definitions | [US-K20-061](US-K20-061.md) | no |
| pkgs/pvs-hermes/bff/app_mvz_schein.ts | Schein BFF API types | [US-K20-061](US-K20-061.md), [US-K4-50](US-K4-50.md) | no |
| pkgs/pvs-hermes/bff/app_mvz_mail.ts | Mail BFF API | [US-K26-01](US-K26-01.md), [US-K26-04](US-K26-04.md), [US-K26-06](US-K26-06.md) | no |
| pkgs/pvs-hermes/bff/mail_common.ts | Mail common types | [US-K26-01](US-K26-01.md), [US-K26-02](US-K26-02.md), [US-K26-04](US-K26-04.md), [US-K26-05](US-K26-05.md), [US-K26-07](US-K26-07.md) | no |
| pkgs/app_mvz/module_patient-management/patient-file/schein-overview/ScheinOverview.action.ts | Schein overview actions (FE) | [US-K20-061](US-K20-061.md) | no |
| pkgs/app_mvz/module_patient-management/patient-file/schein-overview/ScheinOverview.reducer.ts | Schein overview state (FE) | [US-K20-061](US-K20-061.md) | no |
| ext/companion/util/mobile_ct/cardreader.go | CardReader interface for terminal connectivity | [US-KP2-100](US-KP2-100.md) | no |
| ext/companion/util/mobile_ct/ct_cmd/select_egk.go | SelectEgk command for card terminal eGK selection | [US-KP2-100](US-KP2-100.md) | no |
| ext/companion/util/mobile_ct/ct_cmd/select_kvk.go | SelectKvk command for card terminal KVK selection | [US-KP2-100](US-KP2-100.md) | no |
| ext/companion/util/mobile_ct/pcsc/api.go | PC/SC card reader driver for USB/LAN interface | [US-KP2-100](US-KP2-100.md) | no |
| ext/companion/util/mobile_ct/sicct/constants.go | SICCT protocol constants for terminal communication | [US-KP2-100](US-KP2-100.md) | no |
| ares/service/domains/api/patient_profile_common/patient_card_validator.go | ShouldInvalidKVK validator - BPol VKNRs 74860/27860 | [US-KP2-101](US-KP2-101.md), [US-KP2-121](US-KP2-121.md) | yes |
| ares/service/domains/card_service/card_getter.go | KVK/eGK read processing, validation, error propagation | [US-KP2-101](US-KP2-101.md), [US-KP2-102](US-KP2-102.md), [US-KP2-121](US-KP2-121.md) | no |
| ares/service/domains/card_service/common/card_service_common.go | ReadPatientFromKVK, DecodeKVK, Mappingtabelle KVK logic | [US-KP2-101](US-KP2-101.md) | no |
| ares/pkg/api_telematik_util/model.kvk.go | KVK/eGK data model, Pruefungsnachweis parsing | [US-KP2-101](US-KP2-101.md), [US-KP2-185](US-KP2-185.md) | no |
| ares/service/domains/card_raw/service/card_raw_service.go | CardRawService - stores raw card data | [US-KP2-102](US-KP2-102.md) | no |
| ares/service/domains/card_raw/common/card_raw_common.d.go | Card raw data model (TiCardInfo, MobileCardInfo) | [US-KP2-102](US-KP2-102.md) | no |
| ares/service/domains/patient_finder/patient_finder_private.go | Patient matching by VKNR for BPol insured detection | [US-KP2-121](US-KP2-121.md) | no |
| ares/service/domains/card_service/card_service.go | readVsd (PN codes 1-6), validatePOI, online check logic | [US-KP2-185](US-KP2-185.md) | no |
| ares/pkg/api_telematik_util/egk_mapper.go | GetProofOfInsurance, GetCopaymentExemptionTillDate | [US-KP2-185](US-KP2-185.md), [US-KP2-190](US-KP2-190.md), [US-KP2-191](US-KP2-191.md) | no |
| ares/pkg/api_telematik_util/egk_validator.go | ShouldValidProofOfInsurance validator | [US-KP2-185](US-KP2-185.md) | no |
| ares/service/domains/card_raw/mobile/card_raw_mobile.go | MobileCardParser - no PN from mobile terminals | [US-KP2-185](US-KP2-185.md) | no |
| ares/service/domains/api/patient_profile_common/patient_profile_common.d.go | InsuranceInfo with copayment/proof fields | [US-KP2-185](US-KP2-185.md), [US-KP2-190](US-KP2-190.md), [US-KP2-191](US-KP2-191.md) | no |
| ares/service/domains/api/patient_profile_common/insurance.extend.go | Insurance info extension with copayment handling | [US-KP2-190](US-KP2-190.md) | no |
| ares/proto/service/domains/patient_profile_common.proto | Copayment exemption proto definitions | [US-KP2-190](US-KP2-190.md), [US-KP2-191](US-KP2-191.md) | no |
| ares/service/bdt/form_mapper.go | ZuzahLungsFrei form field mapping for Muster 4 | [US-KP2-191](US-KP2-191.md) | no |
| pkgs/pvs-hermes/bff/app_mvz_cardservice.ts | Card service BFF types | [US-KP2-101](US-KP2-101.md), [US-KP2-102](US-KP2-102.md), [US-KP2-121](US-KP2-121.md), [US-KP2-185](US-KP2-185.md) | no |
| pkgs/pvs-hermes/bff/app_mvz_card_raw.ts | Card raw data BFF types | [US-KP2-102](US-KP2-102.md) | no |
| pkgs/pvs-hermes/bff/patient_profile_common.ts | Copayment exemption fields in FE types | [US-KP2-190](US-KP2-190.md), [US-KP2-191](US-KP2-191.md) | no |
| pkgs/pvs-hermes/bff/insurance_common.ts | Insurance common types with copayment exemption | [US-KP2-190](US-KP2-190.md), [US-KP2-191](US-KP2-191.md) | no |
| ares/service/domains/patient_finder/patient_finder.go | PatientFindingService dispatches public/private patient finders | [US-KP2-300](US-KP2-300.md) | no |
| ares/service/domains/patient_finder/patient_finder_public.go | PublicFinder searches by insurance number, IK, name+DOB | [US-KP2-300](US-KP2-300.md), [US-KP2-310](US-KP2-310.md) | no |
| ares/service/domains/patient_finder/patient_finder_private.go | PrivateFinder searches and compares private patient data | [US-KP2-300](US-KP2-300.md) | no |
| pkgs/app_mvz/module_mobile-card-reader/review-patient-dialog/useReviewPatientStore.ts | Review patient comparison store for mobile card reader | [US-KP2-300](US-KP2-300.md), [US-KP2-310](US-KP2-310.md) | yes |
| ares/service/domains/internal/eeb/service.go | EEBService handles eEB sign/send, incoming mail, patient matching | [US-KP2-404](US-KP2-404.md), [US-KP2-405](US-KP2-405.md) | no |
| ares/service/domains/api/eeb/eeb.d.go | eEB domain API types | [US-KP2-404](US-KP2-404.md) | yes |
| ares/app/mvz/api/eeb/eeb.d.go | EEBApp interface (SignAndSend, GetInsurances, GetEEB) | [US-KP2-404](US-KP2-404.md) | yes |
| ares/service/domains/patient_finder/patient_finder_eeb.go | EEBPatientFinder matches eEB data to existing patients | [US-KP2-404](US-KP2-404.md) | yes |
| ares/pkg/bundle_builder/eeb/builder.go | FHIR bundle builder for eEB requests | [US-KP2-404](US-KP2-404.md) | yes |
| ares/pkg/bundle_builder/eeb/parser.go | eEB FHIR response parser | [US-KP2-404](US-KP2-404.md) | yes |
| ares/service/domains/repos/mvz/eeb/repo.go | eEB repository | [US-KP2-404](US-KP2-404.md) | yes |
| pkgs/pvs-hermes/bff/service_domains_eeb.ts | eEB service domain TypeScript types | [US-KP2-404](US-KP2-404.md) | yes |
| pkgs/pvs-hermes/bff/app_mvz_eeb.ts | eEB app BFF types | [US-KP2-404](US-KP2-404.md) | yes |
| ares/service/domains/api/schein_common/schein_common.d.go | Schein data model with TSS fields | [US-KP2-500](US-KP2-500.md), [US-KP2-502](US-KP2-502.md), [US-KP2-503](US-KP2-503.md), [US-KP2-511](US-KP2-511.md), [US-KP2-512](US-KP2-512.md), [US-KP2-513](US-KP2-513.md), [US-KP2-514](US-KP2-514.md) | no |
| pkgs/pvs-hermes/bff/schein_common.ts | Schein TypeScript types with TSS and validity fields | [US-KP2-500](US-KP2-500.md), [US-KP2-502](US-KP2-502.md), [US-KP2-503](US-KP2-503.md), [US-KP2-511](US-KP2-511.md), [US-KP2-512](US-KP2-512.md), [US-KP2-513](US-KP2-513.md), [US-KP2-514](US-KP2-514.md) | no |
| pkgs/app_mvz/module_kv_hzv_schein/CreateSchein.service.ts | Frontend Schein creation service | [US-KP2-500](US-KP2-500.md), [US-KP2-514](US-KP2-514.md) | no |
| pkgs/app_mvz/module_kv_hzv_schein/FormContent.helper.ts | Schein form validation/helper for TSS fields | [US-KP2-502](US-KP2-502.md), [US-KP2-503](US-KP2-503.md), [US-KP2-512](US-KP2-512.md) | no |
| ares/service/domains/tss/tss_service.go | TssService implements RequestReferralCodeM6/PTV11 | [US-KP2-505](US-KP2-505.md) | no |
| ares/service/domains/tss/builder.go | ParametersBuilder for FHIR referral requests | [US-KP2-505](US-KP2-505.md) | yes |
| ares/service/domains/tss/constant.go | TSS FHIR constants (Vermittlungscode, PTV11) | [US-KP2-505](US-KP2-505.md) | yes |
| pkgs/pvs-hermes/bff/app_mvz_tss.ts | TSS BFF types | [US-KP2-505](US-KP2-505.md) | yes |
| pkgs/app_mvz/hooks/useReferralThroughTss.store.ts | TSS referral store for frontend | [US-KP2-505](US-KP2-505.md) | yes |
| ares/share/bsnr.go | BSNR utility functions | [US-KP2-508](US-KP2-508.md), [US-KP2-511](US-KP2-511.md) | no |
| ares/service/schein/schein_validation.go | Schein validation including insurance snapshot, SKT checks | [US-KP2-514](US-KP2-514.md) | no |
| ares/service/schein/case_fields.json | Case field rules: re4205 required for 0102 subgroups | [US-KP2-560](US-KP2-560.md), [US-KP2-561](US-KP2-561.md) | no |
| ares/service/timeline_validation/service/validation_timeline/validations/service_code/kv/precondition/kv.service.hgnc.validator.go | KvServiceHgncValidator: HGNC (5077), GenName (5078), TypeOfIllness (5079), 999999 fallback | [US-KP2-612](US-KP2-612.md), [US-KP2-613](US-KP2-613.md), [US-KP2-614](US-KP2-614.md), [US-KP2-615](US-KP2-615.md), [US-KP2-616](US-KP2-616.md), [US-KP2-621](US-KP2-621.md), [US-KP2-624](US-KP2-624.md) | no |
| ares/service/timeline_validation/service/validation_timeline/validations/additionalInfo.validator.go | AdditionalInfoValidator for service billing fields including ICD-10 | [US-KP2-612](US-KP2-612.md), [US-KP2-617](US-KP2-617.md), [US-KP2-618](US-KP2-618.md) | no |
| ares/service/domains/repos/masterdata_repo/sdebm/additional_field/repo.go | AdditionalFieldRepo with Hgnc_Keys, Omim_Keys, GoaServiceKeys | [US-KP2-612](US-KP2-612.md), [US-KP2-613](US-KP2-613.md), [US-KP2-614](US-KP2-614.md), [US-KP2-615](US-KP2-615.md), [US-KP2-616](US-KP2-616.md), [US-KP2-617](US-KP2-617.md), [US-KP2-618](US-KP2-618.md), [US-KP2-624](US-KP2-624.md), [US-KP2-625](US-KP2-625.md) | no |
| ares/service/domains/repos/masterdata_repo/sdebm/additional_field/rule_config.go | AdditionalInfosRules with FK 5008, 5017 optional field rules | [US-KP2-625](US-KP2-625.md) | no |
| ares/service/domains/repos/masterdata_repo/sdebm/additional_field/fields.csv | Field definitions: 5008 DKM, 5017 Besuchsort, 5018 Zone | [US-KP2-625](US-KP2-625.md) | yes |
| ares/service/domains/hgnc/hgnc_service/sdhgnc_service.go | HgncService: Search, GetByDescription, NOT_FOUND_CODE=999999 | [US-KP2-621](US-KP2-621.md) | no |
| ares/service/domains/repos/masterdata_repo/sdhgnc/repo.go | SdhgncRepo: HGNC key table persistence | [US-KP2-621](US-KP2-621.md) | yes |
| ares/service/domains/hgnc/common/hgnc_common.d.go | HgncItem type definition | [US-KP2-621](US-KP2-621.md), [US-KP2-622](US-KP2-622.md), [US-KP2-623](US-KP2-623.md) | yes |
| ares/service/domains/catalog_hgnc_chain/catalog_hgnc_chain_service.go | CatalogHgncChainService: Create/Update/Delete/Search chains | [US-KP2-614](US-KP2-614.md), [US-KP2-615](US-KP2-615.md), [US-KP2-622](US-KP2-622.md), [US-KP2-623](US-KP2-623.md) | no |
| ares/service/domains/repos/mvz/catalog_hgnc_chain/entity/hgnc_chain_entity.go | HgncChainEntity with unique ID | [US-KP2-622](US-KP2-622.md) | yes |
| ares/app/mvz/api/catalog_hgnc_chain/catalog_hgnc_chain.d.go | API types: HgncChain, CRUD requests | [US-KP2-622](US-KP2-622.md) | yes |
| ares/proto/app/mvz/catalog_hgnc_chain.proto | Proto definition for HGNC chain service | [US-KP2-622](US-KP2-622.md) | yes |
| pkgs/pvs-hermes/bff/hgnc_common.ts | HgncItem TS types | [US-KP2-612](US-KP2-612.md), [US-KP2-613](US-KP2-613.md), [US-KP2-615](US-KP2-615.md), [US-KP2-616](US-KP2-616.md), [US-KP2-621](US-KP2-621.md) | yes |
| pkgs/pvs-hermes/bff/app_catalog_hgnc_chain.ts | HGNC chain BFF API | [US-KP2-614](US-KP2-614.md), [US-KP2-622](US-KP2-622.md), [US-KP2-623](US-KP2-623.md) | unclear |
| pkgs/app_mvz/module_kv_hzv_schein/general-form/AutoFill4205/service.ts | getOrderValues/saveOrderValue for Auftragstext | [US-KP2-560](US-KP2-560.md), [US-KP2-561](US-KP2-561.md) | yes |
| pkgs/app_mvz/module_kv_hzv_schein/CreateSchein.service.ts | Schein creation service with G4102 | [US-KP2-562](US-KP2-562.md) | no |
| pkgs/pvs-design-system/composer/service-node-lexical/plugins/additional-info-selection-plugin/components/additional-info-block/AdditionalInfoBlock.constant.ts | Field key constants: HGNC_KEY, PLACE_VISIT, etc. | [US-KP2-612](US-KP2-612.md), [US-KP2-613](US-KP2-613.md), [US-KP2-617](US-KP2-617.md), [US-KP2-618](US-KP2-618.md), [US-KP2-624](US-KP2-624.md), [US-KP2-625](US-KP2-625.md) | no |
| pkgs/pvs-design-system/composer/service-node-lexical/plugins/additional-info-selection-plugin/components/additional-info-block/components/additional-info-fields/HgncBlock.component.tsx | HGNC search UI with 999999 fallback, chain support | [US-KP2-613](US-KP2-613.md), [US-KP2-614](US-KP2-614.md), [US-KP2-616](US-KP2-616.md), [US-KP2-621](US-KP2-621.md), [US-KP2-623](US-KP2-623.md), [US-KP2-624](US-KP2-624.md) | no |
| pkgs/pvs-design-system/composer/service-node-lexical/plugins/additional-info-hgnc-chain-plugins.tsx | HGNC chain UI plugin: select, expand chains | [US-KP2-614](US-KP2-614.md), [US-KP2-615](US-KP2-615.md), [US-KP2-623](US-KP2-623.md) | no |
| ares/service/timeline_validation/service/validation_timeline/validations/service_code/kv/precondition/kv.service.include.ops.validator.go | OPS/batch/implant validation: FK 5010, 5035, 5036, 5041, 5050-5052 | [US-KP2-651](US-KP2-651.md), [US-KP2-652](US-KP2-652.md), [US-KP2-910](US-KP2-910.md), [US-KP2-912](US-KP2-912.md) | yes |
| ares/service/timeline_validation/service/validation_timeline/validations/service_code/kv/precondition/kv.psychotherapy.validator.go | Psychotherapy validator: 88130/88131, remaining contingent, rezidiv | [US-KP2-964](US-KP2-964.md), [US-KP2-965](US-KP2-965.md), [US-KP2-966](US-KP2-966.md), [US-KP2-967](US-KP2-967.md), [US-KP2-968](US-KP2-968.md), [US-KP2-970](US-KP2-970.md), [US-KP2-971](US-KP2-971.md), [US-KP2-972](US-KP2-972.md) | yes |
| ares/service/domains/api/validation_timeline/timeline_validation.d.go | Validation error codes: Psychotherapy, OPS_5041 | [US-KP2-910](US-KP2-910.md), [US-KP2-964](US-KP2-964.md), [US-KP2-965](US-KP2-965.md), [US-KP2-966](US-KP2-966.md), [US-KP2-967](US-KP2-967.md), [US-KP2-968](US-KP2-968.md), [US-KP2-970](US-KP2-970.md), [US-KP2-971](US-KP2-971.md) | yes |
| ares/service/domains/api/schein_common/schein_common.d.go | Schein common: Ps4234, Ps4251, Psychotherapy struct | [US-KP2-941](US-KP2-941.md), [US-KP2-942](US-KP2-942.md), [US-KP2-943](US-KP2-943.md), [US-KP2-944](US-KP2-944.md), [US-KP2-972](US-KP2-972.md) | yes |
| ares/service/domains/api/common/patientfile/patient_file.d.go | AdditionalInfo model for FK fields (5010, 5035) | [US-KP2-651](US-KP2-651.md), [US-KP2-652](US-KP2-652.md), [US-KP2-912](US-KP2-912.md) | unclear |
| ares/service/domains/repos/mvz/patient_encounter/encounter_common.d.go | EncounterPsychotherapy model | [US-KP2-964](US-KP2-964.md), [US-KP2-966](US-KP2-966.md), [US-KP2-972](US-KP2-972.md) | unclear |
| ares/service/domains/repos/mvz/schein/schein.extend.go | Schein psychotherapy data handling with interruption | [US-KP2-941](US-KP2-941.md), [US-KP2-942](US-KP2-942.md), [US-KP2-943](US-KP2-943.md), [US-KP2-944](US-KP2-944.md), [US-KP2-972](US-KP2-972.md) | unclear |
| ares/service/domains/repos/timeline_repo/timeline_psychotherapy_repo.go | Psychotherapy timeline repository | [US-KP2-964](US-KP2-964.md), [US-KP2-966](US-KP2-966.md), [US-KP2-967](US-KP2-967.md), [US-KP2-971](US-KP2-971.md) | unclear |
| ares/service/domains/timeline/utils/checkOver2Quarters.go | Cross-quarter check utility for two-quarter gap detection | [US-KP2-966](US-KP2-966.md), [US-KP2-967](US-KP2-967.md), [US-KP2-971](US-KP2-971.md) | yes |
| ares/service/domains/form/common/form_common.d.go | Form names: Muster_PTV_3, Muster_PTV_10, G81_EHIC_* | [US-KP2-945](US-KP2-945.md), [US-KP2-946](US-KP2-946.md), [US-KP2-960](US-KP2-960.md), [US-KP2-961](US-KP2-961.md), [US-KP2-962](US-KP2-962.md), [US-KP2-963](US-KP2-963.md) | yes |
| ares/service/rezidiv/service.go | Rezidiv (relapse prevention) service for GOP list | [US-KP2-968](US-KP2-968.md), [US-KP2-970](US-KP2-970.md), [US-KP2-971](US-KP2-971.md) | yes |
| ares/app/mvz/internal/form_print/form_print.go | Form printing implementation | [US-KP2-946](US-KP2-946.md), [US-KP2-961](US-KP2-961.md), [US-KP2-963](US-KP2-963.md) | unclear |
| ares/app/mvz/internal/form_print/form_factory.go | Form print factory | [US-KP2-946](US-KP2-946.md), [US-KP2-961](US-KP2-961.md), [US-KP2-963](US-KP2-963.md) | unclear |
| pkgs/pvs-hermes/bff/form_common.ts | BFF form types: Muster_PTV_3, G81_EHIC_* enums | [US-KP2-945](US-KP2-945.md), [US-KP2-946](US-KP2-946.md), [US-KP2-960](US-KP2-960.md), [US-KP2-961](US-KP2-961.md), [US-KP2-962](US-KP2-962.md), [US-KP2-963](US-KP2-963.md) | yes |
| pkgs/pvs-hermes/bff/service_domains_validation_timeline.ts | BFF validation timeline types with psychotherapy error codes | [US-KP2-910](US-KP2-910.md), [US-KP2-964](US-KP2-964.md), [US-KP2-965](US-KP2-965.md), [US-KP2-966](US-KP2-966.md), [US-KP2-967](US-KP2-967.md), [US-KP2-968](US-KP2-968.md), [US-KP2-970](US-KP2-970.md), [US-KP2-971](US-KP2-971.md) | unclear |
| pkgs/app_mvz/module_patient-management/patient-file/timeline/timeline-content/timeline-entry/psychotherapy-entry/Psychotherapy.tsx | Psychotherapy timeline entry component | [US-KP2-964](US-KP2-964.md), [US-KP2-972](US-KP2-972.md) | unclear |
| pkgs/app_mvz/module_form/muster-form/MusterForm.tsx | Muster form UI component (PTV 3/10 forms) | [US-KP2-960](US-KP2-960.md), [US-KP2-961](US-KP2-961.md), [US-KP2-962](US-KP2-962.md), [US-KP2-963](US-KP2-963.md) | unclear |
| ares/service/domains/repos/admin/bsnr_common/bsnr_common.d.go | BSNR model with HasRVSA, RvsaCertificateReagents, DeviceTypes | [US-KP20-030](US-KP20-030.md), [US-KP20-031](US-KP20-031.md) | yes |
| ares/app/admin/api/bsnr/bsnr_app.extend.go | BSNR validation for pnSD/uu and device types | [US-KP20-030](US-KP20-030.md), [US-KP20-031](US-KP20-031.md) | yes |
| ares/app/admin/internal/app/bsnr/bsnr.go | BSNR service app with RVSA certificate handling | [US-KP20-030](US-KP20-030.md), [US-KP20-031](US-KP20-031.md) | yes |
| ares/proto/service/domains/bsnr_common.proto | Proto definition for RVSACertificateReagents and DeviceType | [US-KP20-030](US-KP20-030.md), [US-KP20-031](US-KP20-031.md) | yes |
| pkgs/pvs-hermes/bff/bsnr_common.ts | TypeScript BFF with RVSACertificateReagents enum, DeviceType | [US-KP20-030](US-KP20-030.md), [US-KP20-031](US-KP20-031.md) | yes |
| pkgs/pvs-hermes/bff/app_bsnr.ts | BSNR app BFF interface | [US-KP20-030](US-KP20-030.md) | yes |
| ares/pkg/masterdata/model/sdops.go | Sdops model struct (Code, Description, Kzseite) | [US-KP6-840](US-KP6-840.md), [US-KP6-850](US-KP6-850.md), [US-KP6-860](US-KP6-860.md), [US-KP6-871](US-KP6-871.md) | yes |
| ares/pkg/masterdata/client.go | Master data client with SDOPS constant | [US-KP6-840](US-KP6-840.md), [US-KP6-850](US-KP6-850.md) | yes |
| ares/service/domains/repos/masterdata_repo/sdops/repo.go | SdopsRepo for OPS master data queries | [US-KP6-840](US-KP6-840.md), [US-KP6-850](US-KP6-850.md), [US-KP6-860](US-KP6-860.md), [US-KP6-870](US-KP6-870.md) | yes |
| ares/service/domains/sdops/sdops_service/sdops_service.go | SdopsService with OPS code lookup and laterality mapping | [US-KP6-840](US-KP6-840.md), [US-KP6-850](US-KP6-850.md), [US-KP6-870](US-KP6-870.md), [US-KP6-871](US-KP6-871.md) | yes |
| ares/service/domains/sdops/common/sdops_common.d.go | OpsItem type with IsLaterality flag | [US-KP6-840](US-KP6-840.md), [US-KP6-871](US-KP6-871.md) | yes |
| ares/service/domains/internal/billing/hpm_next_builder/mapper.go | Maps OPS code/laterality into billing payload | [US-KP6-870](US-KP6-870.md), [US-KP6-871](US-KP6-871.md) | yes |
| ares/service/domains/sdicd/sdicd_service/sdicd_service.go | ICD-10-GM diagnosis lookup and search service | [US-P2-05](US-P2-05.md) | no |
| ares/pkg/masterdata/model/sdicd.go | ICD-10-GM data model | [US-P2-05](US-P2-05.md) | no |
| ares/service/domains/repos/masterdata_repo/sdicd/repo.go | ICD-10-GM repository | [US-P2-05](US-P2-05.md) | no |
| ares/service/timeline_validation/service/validation_timeline/validations/diagnose.validator.go | Diagnosis validation rules | [US-P2-05](US-P2-05.md) | no |
| ares/service/timeline_validation/service/validation_timeline/validations/common/icd.utils.go | ICD utility functions for validation | [US-P2-05](US-P2-05.md) | no |
| ares/service/domains/pkg/forms/form_generator.go | Form generation service | [US-P2-06](US-P2-06.md) | no |
| ares/service/domains/pkg/forms/pdf_generator.go | PDF generation for forms | [US-P2-06](US-P2-06.md) | no |
| ares/pkg/formkey/muster.go | Form key/Muster definitions | [US-P2-06](US-P2-06.md) | no |
| ares/pkg/api_telematik_util/kvk_mapper.go | KVK-to-eGK data transformation (Mappingtabelle_KVK, WOP) | [US-P2-105](US-P2-105.md), [US-P2-135](US-P2-135.md), [US-P2-136](US-P2-136.md) | no |
| ares/service/domains/card_raw/ti/card_raw_ti.go | TI card raw data parsing (KVK/eGK) | [US-P2-105](US-P2-105.md) | no |
| ares/pkg/api_telematik_util/egk_mapper.go | eGK data mapper (WOP, Kostentraeger, coverage dates) | [US-P2-105](US-P2-105.md), [US-P2-135](US-P2-135.md), [US-P2-136](US-P2-136.md), [US-P2-166](US-P2-166.md) | no |
| ares/pkg/api_telematik_util/egk_private_mapper.go | eGK private insurance cost carrier mapping | [US-P2-136](US-P2-136.md) | no |
| ares/service/domains/card_raw/common/card_raw_common.d.go | CardInfo with ReadingDate field (Einlesedatum) | [US-P2-140](US-P2-140.md) | no |
| ares/service/domains/error_code/error_code.d.go | Error codes for invalid insurance dates | [US-P2-166](US-P2-166.md) | no |
| ares/service/domains/api/patient_profile_common/patient_profile_common.extend.go | Patient profile extension with card data merge logic | [US-P2-170](US-P2-170.md) | no |
| ares/service/domains/mobile_card_reader/service/mobile_card_reader_service.go | Mobile card reader service | [US-P2-180](US-P2-180.md) | no |
| ares/service/domains/mobile_card_reader/common/mobile_card_reader_common.d.go | Mobile card reader type definitions | [US-P2-180](US-P2-180.md) | no |
| ares/app/admin/api/mobile_card_reader/mobile_card_reader.d.go | Mobile card reader admin API | [US-P2-180](US-P2-180.md) | no |
| ares/service/domains/insurance_service/sdkt_validator/sdkt_validator.go | Validates cost unit validity, KV-Bereich, IK validity | [US-P2-210](US-P2-210.md), [US-P2-230](US-P2-230.md), [US-P2-260](US-P2-260.md), [US-P2-265](US-P2-265.md), [US-P2-285](US-P2-285.md) | no |
| ares/pkg/masterdata/model/sdkt.go | Sdkt model with IKNumbers, VKNR, KTABs, RestrictKvRegions | [US-P2-200](US-P2-200.md), [US-P2-210](US-P2-210.md), [US-P2-220](US-P2-220.md), [US-P2-230](US-P2-230.md), [US-P2-265](US-P2-265.md), [US-P2-285](US-P2-285.md) | no |
| ares/service/domains/api/catalog_sdkt_common/catalog_sdkt_common.d.go | SdktCatalog, IkNumber, KTAB types | [US-P2-200](US-P2-200.md), [US-P2-210](US-P2-210.md), [US-P2-220](US-P2-220.md), [US-P2-230](US-P2-230.md), [US-P2-285](US-P2-285.md), [US-P2-320](US-P2-320.md) | no |
| ares/proto/service/domains/catalog_sdkt_common.proto | IkNumber, KTABValue enum, KTAB message definitions | [US-P2-200](US-P2-200.md), [US-P2-210](US-P2-210.md), [US-P2-285](US-P2-285.md), [US-P2-320](US-P2-320.md) | no |
| ares/service/domains/insurance_service/insurance_validator/insurance_validator.go | Insurance date validation | [US-P2-210](US-P2-210.md), [US-P2-30](US-P2-30.md) | no |
| ares/service/domains/internal/billing/hpm_next_builder/builder.go | Maps BesonderePersonengruppe to billing | [US-P2-320](US-P2-320.md) | no |
| ares/service/domains/internal/billing/hpm_next_builder/mapper.go | Maps BesonderePersonengruppe from SpecialGroup | [US-P2-320](US-P2-320.md) | no |
| ares/proto/service/domains/patient_profile_common.proto | SpecialGroupDescription enum (00, 04, 06, 07, 08, 09) | [US-P2-320](US-P2-320.md), [US-P2-325](US-P2-325.md) | no |
| ares/proto/service/domains/schein_common.proto | ShowHintSpecialGroup09 setting | [US-P2-325](US-P2-325.md) | yes |
| ares/pkg/bundle_builder/base_bundle_builder.go | Maps BesonderePersonengruppe to billing bundle | [US-P2-320](US-P2-320.md) | no |
| pkgs/app_mvz/components/navigation-bar/IKNumberNotFound/IKNumberNotFound.tsx | UI for unknown IK handling | [US-P2-270](US-P2-270.md) | no |
| pkgs/app_mvz/module_sdkt/create-cost-unit-dialog/create-cost-unit-dialog.tsx | Create temporary cost unit dialog | [US-P2-270](US-P2-270.md), [US-P2-275](US-P2-275.md) | no |
| pkgs/app_mvz/module_sdkt/add-ik-number-dialog/AddIKNumberDialog.tsx | Add IK number to existing cost unit | [US-P2-270](US-P2-270.md) | no |
| pkgs/app_mvz/module_sdkt/cost-unit-dialog/cost-unit-dialog.tsx | Cost unit CRUD dialog | [US-P2-275](US-P2-275.md) | no |
| pkgs/app_mvz/module_sdkt/edit-cost-unit-dialog/edit-cost-unit-dialog.tsx | Edit temporary cost unit records | [US-P2-275](US-P2-275.md) | no |
| pkgs/app_mvz/module_setting/schein/ShowHintSpecialGroup09/Group.tsx | UI settings for SpecialGroup09 alert | [US-P2-325](US-P2-325.md) | yes |
| pkgs/app_mvz/module_insurance/components/PublicInsurance/PublicInsurance.tsx | Displays SpecialGroup09 alert | [US-P2-325](US-P2-325.md) | no |
| ares/service/domains/pkg/constant/message.go | Ersatzwert messaging (MessageABRD613) | [US-P2-40](US-P2-40.md) | no |
| ares/service/domains/catalog_sdkt/catalog_sdkt_service.go | Cost unit CRUD, search by IK, VKNR validation | [US-P2-410](US-P2-410.md), [US-P2-420](US-P2-420.md) | no |
| ares/service/domains/sdkv/service.go | SDKVService for KV-Spezifika-Stammdatei | [US-P2-440](US-P2-440.md), [US-P2-452](US-P2-452.md) | no |
| ares/service/domains/api/sdkv/sdkv_common.d.go | SDKV types for KV-specific data | [US-P2-440](US-P2-440.md), [US-P2-452](US-P2-452.md) | no |
| ares/pkg/masterdata/model/sdkv.go | SDKV masterdata model | [US-P2-440](US-P2-440.md), [US-P2-452](US-P2-452.md) | no |
| ares/service/domains/edmp/service/edmp_service.go | eDMP service for DMP enrollment | [US-P2-403](US-P2-403.md) | no |
| ares/service/domains/edmp/service/edoku_service.go | eDMP documentation service | [US-P2-403](US-P2-403.md) | no |
| ares/pkg/bundle_builder/constant.go | Billing constants including DMP-Kennzeichen | [US-P2-403](US-P2-403.md) | no |
| ares/pkg/hpm_service/hpm_next/model.go | HPM billing model for patient data transfer | [US-P2-460](US-P2-460.md) | no |
| ares/service/domains/internal/billing/model/billing_encounter_case_model.go | BillingEncounterCase with patient profile | [US-P2-460](US-P2-460.md) | no |
| ares/app/mvz/patient_profile/patient_bff.go | Patient profile BFF for gender, DOB | [US-P2-430](US-P2-430.md), [US-P2-470](US-P2-470.md) | no |
| pkgs/pvs-hermes/bff/service_domains_sdkv.ts | TypeScript BFF for SDKV service | [US-P2-440](US-P2-440.md), [US-P2-452](US-P2-452.md) | no |
| pkgs/app_mvz/module_sdkt/cost-unit-dialog/cost-unit-dialog.service.ts | Frontend cost unit search dialog | [US-P2-410](US-P2-410.md), [US-P2-420](US-P2-420.md) | no |
| pkgs/app_mvz/module_sdkt/add-ik-number-dialog/AddIKNumberDialog.service.ts | Frontend IK number dialog | [US-P2-420](US-P2-420.md) | no |
| ares/share/authorization.go | Casbin RBAC authorization with BSNR-aware policy | [US-P2-51](US-P2-51.md) | no |
| ares/share/claims/claim.go | JWT claims for role/user identification | [US-P2-51](US-P2-51.md) | no |
| ares/service/bsnr/bsnr_service.go | BSNRService managing physicians per BSNR with LANR | [US-P2-51](US-P2-51.md), [US-P2-52](US-P2-52.md), [US-P2-53](US-P2-53.md) | no |
| ares/app/admin/api/bsnr/bsnr_app.d.go | BSNR admin API with physician-BSNR management | [US-P2-51](US-P2-51.md), [US-P2-52](US-P2-52.md) | no |
| ares/service/domains/repos/admin/bsnr_repo/bsnr.d.go | BSNR repository storing BSNR-LANR associations | [US-P2-51](US-P2-51.md), [US-P2-52](US-P2-52.md) | no |
| ares/service/billing_kv/service.go | BillingKvService with quarter transition, Nachzügler, BSNR billing | [US-P2-510](US-P2-510.md), [US-P2-520](US-P2-520.md), [US-P2-521](US-P2-521.md), [US-P2-53](US-P2-53.md), [US-P2-558](US-P2-558.md) | no |
| ares/app/mvz/internal/billing_kv/application.go | Billing KV application with validYearQuarters | [US-P2-510](US-P2-510.md), [US-P2-520](US-P2-520.md), [US-P2-521](US-P2-521.md), [US-P2-53](US-P2-53.md) | no |
| ares/service/report/report_service.go | Report service for daily control lists | [US-P2-510](US-P2-510.md) | no |
| ares/service/report/report_repo.go | Report repository with BSNR-filtered queries | [US-P2-510](US-P2-510.md), [US-P2-53](US-P2-53.md) | no |
| ares/service/domains/internal/billing/service.go | Internal billing domain with retroactive billing | [US-P2-510](US-P2-510.md), [US-P2-521](US-P2-521.md) | no |
| ares/service/domains/api/patient_profile_common/patient_profile_common.extend.go | BillingAddress logic, address comparison | [US-P2-558](US-P2-558.md) | no |
| ares/pkg/con_file/builder_test.go | Tests for bsnrFields (FK 0225/0226 TI values) | [US-P2-66](US-P2-66.md), [US-P2-67](US-P2-67.md) | no |
| ares/service/domains/repos/mvz/patient_encounter/encounter_common.d.go | EncounterServiceTimeline and AdditionalInfo models (FK 5000/5001/5006/5012/5900) | [US-P2-600](US-P2-600.md), [US-P2-610](US-P2-610.md), [US-P2-630](US-P2-630.md), [US-P2-641](US-P2-641.md) | no |
| ares/service/bdt/bdt_service.go | BDT import handling FK 5098, 5099, 5101 | [US-P2-641](US-P2-641.md) | no |
| ares/pkg/xdt/bdt/model/schein.go | BDT schein model with BsnrCode (5098), Lanr (5099), Di5101 | [US-P2-641](US-P2-641.md) | no |
| ares/proto/app/admin/admin_app.proto | Employee detail with lanr and pseudoLanr fields | [US-P2-65](US-P2-65.md) | no |
| ares/proto/repo/profile/employee.proto | Employee profile with lanr and pseudoLanr | [US-P2-65](US-P2-65.md) | no |
| ares/service/domains/repos/profile/employee/employee.d.go | EmployeeProfile model with PseudoLanr | [US-P2-65](US-P2-65.md) | no |
| ares/service/domains/internal/profile/employee/employee_profile_mapper.go | Maps pseudo LANR in employee profile | [US-P2-65](US-P2-65.md) | no |
| ares/app/admin/internal/app/ti_connector_service.go | TI connector service: reads version, certificate expiry | [US-P2-66](US-P2-66.md), [US-P2-67](US-P2-67.md), [US-P2-68](US-P2-68.md), [US-P2-69](US-P2-69.md) | no |
| ares/app/admin/api/ti_connector/ti_connector.d.go | TI connector API types | [US-P2-66](US-P2-66.md), [US-P2-68](US-P2-68.md), [US-P2-69](US-P2-69.md) | no |
| ares/proto/app/admin/ti_connector.proto | TI connector proto definition | [US-P2-66](US-P2-66.md), [US-P2-68](US-P2-68.md), [US-P2-69](US-P2-69.md) | no |
| pkgs/pvs-hermes/bff/app_admin_ti_connector.ts | Frontend BFF for TI connector management | [US-P2-66](US-P2-66.md), [US-P2-68](US-P2-68.md), [US-P2-69](US-P2-69.md) | no |
| ares/pkg/api_telematik_util/egk_private_mapper.go | Maps PKV eGK card data for private insurance detection | [US-P2-790](US-P2-790.md) | no |
| ares/service/domains/billing_patient/service/billing_patient_service.go | Patient billing service for receipt generation | [US-P2-820](US-P2-820.md), [US-P2-840](US-P2-840.md), [US-P2-870](US-P2-870.md), [US-P2-880](US-P2-880.md), [US-P2-890](US-P2-890.md) | no |
| ares/app/mvz/api/billing_patient/billing_patient.d.go | API types for patient billing | [US-P2-820](US-P2-820.md), [US-P2-840](US-P2-840.md), [US-P2-870](US-P2-870.md), [US-P2-890](US-P2-890.md) | no |
| ares/service/domains/billing_patient/common/billing_patient_common/billing_patient_common.d.go | Billing patient common models | [US-P2-820](US-P2-820.md), [US-P2-840](US-P2-840.md), [US-P2-880](US-P2-880.md), [US-P2-890](US-P2-890.md) | no |
| ares/service/domains/repos/mvz/patient_bill/patient_bill.go | Patient bill repository with exclusion fields | [US-P2-820](US-P2-820.md), [US-P2-870](US-P2-870.md), [US-P2-890](US-P2-890.md) | no |
| pkgs/pvs-hermes/bff/app_mvz_billing_patient.ts | Frontend BFF for patient billing/receipt | [US-P2-820](US-P2-820.md), [US-P2-840](US-P2-840.md), [US-P2-870](US-P2-870.md), [US-P2-880](US-P2-880.md), [US-P2-890](US-P2-890.md) | no |
| ares/service/domains/point_value/service/point_value_service.go | Point value service with annual Orientierungswert (2022-2026) | [US-P2-830](US-P2-830.md) | yes |
| ares/app/mvz/api/point_value/point_value.d.go | API types for point value CRUD | [US-P2-830](US-P2-830.md) | yes |
| ares/service/domains/point_value/common/point_value_common.d.go | Point value common model | [US-P2-830](US-P2-830.md) | no |
| pkgs/pvs-hermes/bff/app_mvz_point_value.ts | Frontend BFF for point value | [US-P2-830](US-P2-830.md) | no |
| pkgs/app_mvz/module_point_value/PointValue.store.ts | Frontend point value store | [US-P2-830](US-P2-830.md) | no |
| ares/service/timeline_validation/service/validation_timeline/validations/service_code/kv/precondition/kv.service.include.icd.validator.go | Warns when EBM requires ICD justification | [US-P2-920](US-P2-920.md) | yes |
| ares/app/mvz/api/patient_search/patient_search.d.go | API with SearchingType: InsuranceNumber, Birthdate, SKT | [US-P2-948](US-P2-948.md) | yes |
| ares/app/mvz/patient_search/patient_search_bff.go | Patient search by insurance number, birthdate, SKT | [US-P2-948](US-P2-948.md) | yes |
| pkgs/pvs-hermes/bff/app_mvz_patient_search.ts | Frontend BFF for patient search | [US-P2-948](US-P2-948.md) | no |
| pkgs/app_mvz/module_patient-management/patient-search/PatientSearch.service.ts | Frontend patient search service | [US-P2-948](US-P2-948.md) | no |
| ares/service/domains/kv_connect/kv-connect-service.go | KV Connect (KIM) for electronic billing transmission | [US-P2-97](US-P2-97.md) | no |
| ares/service/domains/kv_connect/model.go | KV Connect model with KIM types | [US-P2-97](US-P2-97.md) | no |
| ares/service/billing_history/service/service.go | Billing history tracking one-click billing | [US-P2-97](US-P2-97.md) | no |
| pkgs/pvs-hermes/bff/app_mvz_one_click_billing.ts | Frontend BFF for 1Click billing via KIM | [US-P2-97](US-P2-97.md) | no |
| ares/pkg/con_file/extractor.go | CON file extractor reading FK 4121, FK 4104 | [US-P2-99](US-P2-99.md) | no |
| ares/service/domains/repos/admin/rvsa_certificate/repo.go | RVSA certificate repo parsing XML, GetRVSACertificate() | [US-P20-010](US-P20-010.md), [US-P20-020](US-P20-020.md), [US-P20-040](US-P20-040.md), [US-P20-041](US-P20-041.md) | no |
| ares/service/timeline_validation/service/validation_timeline/validations/service_code/kv/precondition/rvsa.validator.go | RVSAValidator comparing billing GOPs against RV analytes | [US-P20-020](US-P20-020.md), [US-P20-041](US-P20-041.md) | no |
| ares/service/domains/repos/profile/employee/employee.d.go | EmployeeProfile with TeamNumbers for ASV | [US-P21-005](US-P21-005.md) | no |
| ares/pkg/xdt/bdt/model/practice.go | AsvTeamNumbers (FK 0222) in BDT practice model | [US-P21-005](US-P21-005.md) | no |
| ares/pkg/xdt/bdt/model/schein.go | Schein model with Di5100 (FK 5100, ASV team number) | [US-P21-010](US-P21-010.md) | no |
| ares/service/domains/api/catalog_material_cost_common/catalog_material_cost_common.d.go | MaterialCostCatalog with Manufacturer (FK 5074), ArticleProductNumber (FK 5075) | [US-P21-015](US-P21-015.md) | no |
| ares/app/mvz/api/catalog_material_cost/catalog_material_cost.d.go | CatalogMaterialCostApp API | [US-P21-015](US-P21-015.md) | no |
| ares/service/domains/catalog_overview/service.material-cost.go | Material cost service implementation | [US-P21-015](US-P21-015.md) | no |
| pkgs/pvs-hermes/bff/catalog_material_cost_common.ts | Frontend MaterialCostCatalog types | [US-P21-015](US-P21-015.md) | no |
| pkgs/pvs-hermes/bff/app_mvz_catalog_material_cost.ts | Frontend catalog material cost BFF | [US-P21-015](US-P21-015.md) | no |
| ares/pkg/xpm/xpm.go | KVDT validation module (XPM) with quarter-based version mapping | [US-P5-10](US-P5-10.md), [US-P5-20](US-P5-20.md), [US-P5-30](US-P5-30.md) | no |
| ares/pkg/xkm/xkm.go | KBV crypto module (XKM) for encrypt/decrypt billing files | [US-P5-10](US-P5-10.md) | no |
| ares/app/mvz/config/mvz_app_configs.go | XKM/XPM URL configuration | [US-P5-10](US-P5-10.md) | no |
| ares/service/domains/repos/mvz/billing_kv_history/kv_billing_filecontent_repo.go | Billing file content storage/retrieval | [US-P5-30](US-P5-30.md) | no |
| ares/service/domains/sdkv/service.go | SDKVService providing KV-Specifika by BSNR/region | [US-P6-100](US-P6-100.md), [US-P6-110](US-P6-110.md), [US-P6-120](US-P6-120.md), [US-P6-130](US-P6-130.md), [US-P6-140](US-P6-140.md), [US-P6-145](US-P6-145.md) | no |
| ares/service/domains/api/sdkv/sdkv_common.d.go | SDKV types (Kvx0-Kvx3), SDKVService interface | [US-P6-100](US-P6-100.md), [US-P6-110](US-P6-110.md), [US-P6-130](US-P6-130.md), [US-P6-140](US-P6-140.md), [US-P6-145](US-P6-145.md), [US-P6-150](US-P6-150.md), [US-P6-160](US-P6-160.md) | no |
| ares/service/domains/api/sdkv/sdkv_common.extend.go | Get4106(), Get4122(), GetSubGroupByBsnr(), CaptureFieldInList() | [US-P6-140](US-P6-140.md), [US-P6-145](US-P6-145.md), [US-P6-150](US-P6-150.md), [US-P6-160](US-P6-160.md) | yes |
| ares/service/domains/repos/masterdata_repo/sdkv/repo.go | SdkvRepo read-only for SDKV master data | [US-P6-100](US-P6-100.md), [US-P6-110](US-P6-110.md), [US-P6-120](US-P6-120.md) | no |
| ares/service/domains/version_info/service/version_info_service.go | VersionInfoService tracking master data versions | [US-P6-100](US-P6-100.md), [US-P6-120](US-P6-120.md) | no |
| ares/service/domains/catalog_sdav/catalog_sdav_service.go | CatalogSdavService for SDAV physician directory | [US-P6-200](US-P6-200.md) | no |
| ares/service/domains/repos/masterdata_repo/sdav/repo.go | SdavRepo for SDAV master data with BSNR/LANR queries | [US-P6-200](US-P6-200.md) | no |
| ares/pkg/masterdata/model/sdav.go | Sdav model with LANR, BSNR, doctor info | [US-P6-200](US-P6-200.md) | no |
| ares/app/mvz/api/catalog_sdav/catalog_sdav.d.go | Generated API for SDAV catalog | [US-P6-200](US-P6-200.md) | no |
| pkgs/pvs-hermes/bff/catalog_sdav_common.ts | Frontend BFF types for SDAV catalog | [US-P6-200](US-P6-200.md) | no |
| pkgs/pvs-hermes/bff/app_mvz_catalog_sdav.ts | Frontend BFF for SDAV catalog API | [US-P6-200](US-P6-200.md) | no |
| ares/service/domains/repos/mvz/sdplz/repo.go | SDPLZRepository with embedded PLZ file, postal code map | [US-P6-400](US-P6-400.md), [US-P6-410](US-P6-410.md), [US-P6-420](US-P6-420.md) | no |
| ares/service/domains/api/patient_profile_common/insurance.extend.go | IsDummyVknrFunc checking VKNR 74799 | [US-P6-51](US-P6-51.md) | yes |
| ares/service/insurance/insurance_common.d.go | InsuraceVKNR_74799 constant | [US-P6-51](US-P6-51.md) | no |
| ares/service/domains/catalog_sdebm/catalog_sdebm_service.go | EBM catalog service with quarter-based retrieval | [US-P6-700](US-P6-700.md), [US-P6-710](US-P6-710.md), [US-P6-720](US-P6-720.md), [US-P6-740](US-P6-740.md), [US-P6-750](US-P6-750.md) | no |
| ares/service/domains/repos/masterdata_repo/sdebm/repo.go | SDEBM repository with YearQuarter queries | [US-P6-700](US-P6-700.md), [US-P6-710](US-P6-710.md), [US-P6-720](US-P6-720.md), [US-P6-740](US-P6-740.md), [US-P6-750](US-P6-750.md) | no |
| ares/pkg/masterdata/model/sdebm.go | Sdebm model with validity, evaluation, code | [US-P6-700](US-P6-700.md), [US-P6-710](US-P6-710.md), [US-P6-740](US-P6-740.md) | no |
| ares/service/etl/builder/sdebm_catalogs.go | ETL for SDEBM catalog | [US-P6-700](US-P6-700.md), [US-P6-710](US-P6-710.md), [US-P6-740](US-P6-740.md) | no |
| ares/service/timeline_validation/service/validation_timeline/validations/service_code/kv/precondition/kv.gender.validator.go | KvGenderValidator skipping gender check for X/D | [US-P6-801](US-P6-801.md) | yes |
| ares/service/timeline_validation/service/validation_timeline/validations/service_code/kv/rule/auto.convert.service.code.validator.go | AutoConvertServiceValidator for age-class sub-GOP | [US-P6-804](US-P6-804.md) | yes |
| ares/service/timeline_validation/service/validation_timeline/validations/service_code/kv/precondition/kv.age.service.validator.go | KvAgeServiceValidator for age-based validation | [US-P6-804](US-P6-804.md) | no |
| ares/service/timeline_validation/service/validation_timeline/validations/service_code/kv/precondition/warning.attribute.validator.go | Warning-level validation allowing override | [US-P6-830](US-P6-830.md) | no |
