/*********** LOGIN **********

:SETVAR Instance "192.168.13.33"
:SETVAR User "replicator"
:SETVAR Password "kiotviet@1"
:SETVAR Path "C:\Users\lam.vt\Documents\Citigo\"

:SETVAR Retail "login_retail.sql"
:SETVAR Fnb "login_fnb.sql"
:SETVAR Omni "login_omnichannel.sql"
:SETVAR RetailTS "login_retail_timesheet.sql"
:SETVAR FnBTS "login_fnb_timesheet.sql"

:CONNECT $(Instance) -U $(User) -P $(Password)
:OUT $(Path)\log.txt


:SETVAR DatabaseName "KiotVietTimeSheet34"

:r $(Path)$(FnBTS)
*/
SET NOEXEC OFF
GO
USE [master]
GO
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_audit_api')
	ALTER LOGIN [retail_audit_api] WITH PASSWORD = 0x02006a450c48e13637bc159a2760143931a99a3959ffa956d916da14fbcccc854666f8c0ad82a413d0a79c7aa34bf5d84e9eb549b2b5a5d1ee320a475859ea65326b2218ad2d HASHED
ELSE
	CREATE LOGIN [retail_audit_api] WITH PASSWORD = 0x02006a450c48e13637bc159a2760143931a99a3959ffa956d916da14fbcccc854666f8c0ad82a413d0a79c7aa34bf5d84e9eb549b2b5a5d1ee320a475859ea65326b2218ad2d HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_audit_svc')
	ALTER LOGIN [retail_audit_svc] WITH PASSWORD = 0x020093afaae216e3ab98ff82eed1ecd3757444121111e3b319c75ba208a85884b0ce9abca11e9a3f6a089287d5bfa88044e0730cc3d8fd94582ad6fd912063b10c95945c0873 HASHED
ELSE
	CREATE LOGIN [retail_audit_svc] WITH PASSWORD = 0x020093afaae216e3ab98ff82eed1ecd3757444121111e3b319c75ba208a85884b0ce9abca11e9a3f6a089287d5bfa88044e0730cc3d8fd94582ad6fd912063b10c95945c0873 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_auto_customer_group_svc')
	ALTER LOGIN [retail_auto_customer_group_svc] WITH PASSWORD = 0x0200f06b995f218774f6d115909282b16321ea91916606d192af3c1f9fa3ebe296780fb4d295f25fbd17176e3111d610016cea584bbad9457bf199e07f56bd369c4ff0c83f7c HASHED
ELSE
	CREATE LOGIN [retail_auto_customer_group_svc] WITH PASSWORD = 0x0200f06b995f218774f6d115909282b16321ea91916606d192af3c1f9fa3ebe296780fb4d295f25fbd17176e3111d610016cea584bbad9457bf199e07f56bd369c4ff0c83f7c HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_clear_data_svc')
	ALTER LOGIN [retail_clear_data_svc] WITH PASSWORD = 0x0200b957ffc8585dbd0e4e562920ecb755fcdc6bf21c79b82b5748b9e7cb722fdfd6455a702edd13d642d8762deb23e75592457a0e1e1ece13e773839138615e1747789c6e9e HASHED
ELSE
	CREATE LOGIN [retail_clear_data_svc] WITH PASSWORD = 0x0200b957ffc8585dbd0e4e562920ecb755fcdc6bf21c79b82b5748b9e7cb722fdfd6455a702edd13d642d8762deb23e75592457a0e1e1ece13e773839138615e1747789c6e9e HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_gmb_svc')
	ALTER LOGIN [retail_gmb_svc] WITH PASSWORD = 0x0200fadb4da34d753dc6853b812e2d88c68f2778f29a4bf7e91a242502700c78b6a33ec67f5c78d175d30d4332d24727216111289f827b820745b738b53b0cc361bcba56d4aa HASHED
ELSE
	CREATE LOGIN [retail_gmb_svc] WITH PASSWORD = 0x0200fadb4da34d753dc6853b812e2d88c68f2778f29a4bf7e91a242502700c78b6a33ec67f5c78d175d30d4332d24727216111289f827b820745b738b53b0cc361bcba56d4aa HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_identity_server')
	ALTER LOGIN [retail_identity_server] WITH PASSWORD = 0x0200fff684ec9a746add7980f4dfe4728e98d319dbd03549e1b4976a9ce6cfba8eceb05c48252f59e780f3c41efdd1f131a1cc409d9d0d1f7e2405bd5d964f585aee51e7bb9f HASHED
ELSE
	CREATE LOGIN [retail_identity_server] WITH PASSWORD = 0x0200fff684ec9a746add7980f4dfe4728e98d319dbd03549e1b4976a9ce6cfba8eceb05c48252f59e780f3c41efdd1f131a1cc409d9d0d1f7e2405bd5d964f585aee51e7bb9f HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_imp_exp_svc')
	ALTER LOGIN [retail_imp_exp_svc] WITH PASSWORD = 0x0200844b066f65c1c48ed9359b26e6ee662d6d8d9b7e3b851ec685fede5ecea7cde175e51cf59dbf796e5eb6124407087471cdbe4208c0290abc1a2723008673b4dcba00d749 HASHED
ELSE
	CREATE LOGIN [retail_imp_exp_svc] WITH PASSWORD = 0x0200844b066f65c1c48ed9359b26e6ee662d6d8d9b7e3b851ec685fede5ecea7cde175e51cf59dbf796e5eb6124407087471cdbe4208c0290abc1a2723008673b4dcba00d749 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_internal_api')
	ALTER LOGIN [retail_internal_api] WITH PASSWORD = 0x020087f7917aa39c70c954446095d98281620f4987072ac9da80a3523a573c5656a186236de3058097f5e0cf847b3208ad443ad9d6dce1b571515c9f54f68540a1975d4ea82a HASHED
ELSE
	CREATE LOGIN [retail_internal_api] WITH PASSWORD = 0x020087f7917aa39c70c954446095d98281620f4987072ac9da80a3523a573c5656a186236de3058097f5e0cf847b3208ad443ad9d6dce1b571515c9f54f68540a1975d4ea82a HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_kiot_api')
	ALTER LOGIN [retail_kiot_api] WITH PASSWORD = 0x02003a6cd91c92a6e1fa7ac7f638b71dff7d813e4a2a5a085b623905a94280389cc43792f6c08f3dce4790ad47f3d95641c9063efda4d2b88ad6e8882b62307884ab2bf1ac0c HASHED
ELSE
	CREATE LOGIN [retail_kiot_api] WITH PASSWORD = 0x02003a6cd91c92a6e1fa7ac7f638b71dff7d813e4a2a5a085b623905a94280389cc43792f6c08f3dce4790ad47f3d95641c9063efda4d2b88ad6e8882b62307884ab2bf1ac0c HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_kvaa_api')
	ALTER LOGIN [retail_kvaa_api] WITH PASSWORD = 0x02001b2987affeb2479a1ab786f4890ddad25e7ed167dbb691c24f3ec786bd67a2f00544a6f09df049e71ce9cc563b6f3dcab9f0185d5019dd84a57dc7943b554628e299a73d HASHED
ELSE
	CREATE LOGIN [retail_kvaa_api] WITH PASSWORD = 0x02001b2987affeb2479a1ab786f4890ddad25e7ed167dbb691c24f3ec786bd67a2f00544a6f09df049e71ce9cc563b6f3dcab9f0185d5019dd84a57dc7943b554628e299a73d HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_kyc_api')
	ALTER LOGIN [retail_kyc_api] WITH PASSWORD = 0x0200e397f797016cb0a91862923f42ce03663dfac34d7d92cd486fb8dd7f63e3f4ed138dc1cf90a1aef3635c66ab1982a6e2d48e1cd3ade3270ca731fe629636626a0f2d2d64 HASHED
ELSE
	CREATE LOGIN [retail_kyc_api] WITH PASSWORD = 0x0200e397f797016cb0a91862923f42ce03663dfac34d7d92cd486fb8dd7f63e3f4ed138dc1cf90a1aef3635c66ab1982a6e2d48e1cd3ade3270ca731fe629636626a0f2d2d64 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_limit_svc')
	ALTER LOGIN [retail_limit_svc] WITH PASSWORD = 0x020028bd4d1612295df661703f352a5d7999766a99bf95bd06d4e714ac891465e6f22c5962d6633c1efe166fde37f986e893001f040f12663929a71fa8518b5d10bd5540ff57 HASHED
ELSE
	CREATE LOGIN [retail_limit_svc] WITH PASSWORD = 0x020028bd4d1612295df661703f352a5d7999766a99bf95bd06d4e714ac891465e6f22c5962d6633c1efe166fde37f986e893001f040f12663929a71fa8518b5d10bd5540ff57 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_mhql')
	ALTER LOGIN [retail_mhql] WITH PASSWORD = 0x02003e874b82a71f4108729da86e8e3e89d694d606bcca95f062978b1450c85338b3ab07454e4b0a82964b741acf0cba965f1ad9d6604a90665136172b625d2cc1c911fddeb3 HASHED
ELSE
	CREATE LOGIN [retail_mhql] WITH PASSWORD = 0x02003e874b82a71f4108729da86e8e3e89d694d606bcca95f062978b1450c85338b3ab07454e4b0a82964b741acf0cba965f1ad9d6604a90665136172b625d2cc1c911fddeb3 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_mobile_api')
	ALTER LOGIN [retail_mobile_api] WITH PASSWORD = 0x020080c03d7f03e834aa21e63c5b7ba0cc53bec76804dcbaec8447dc1d9b34dba837d4e3cd8754915ee1841566c8db2dcadada7c27a996dff29b8ddec1d5f3d7a06d6d470330 HASHED
ELSE
	CREATE LOGIN [retail_mobile_api] WITH PASSWORD = 0x020080c03d7f03e834aa21e63c5b7ba0cc53bec76804dcbaec8447dc1d9b34dba837d4e3cd8754915ee1841566c8db2dcadada7c27a996dff29b8ddec1d5f3d7a06d6d470330 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_pricebook_svc')
	ALTER LOGIN [retail_pricebook_svc] WITH PASSWORD = 0x02004715ca96c939a6c3e38837975d62f7b65579ce825a7d00cd47de09e7bd522c71dbe89aae485082c90c7625e9517fdcb2042b253ec297fa2fd4d68d3ee35aa12f9fee8269 HASHED
ELSE
	CREATE LOGIN [retail_pricebook_svc] WITH PASSWORD = 0x02004715ca96c939a6c3e38837975d62f7b65579ce825a7d00cd47de09e7bd522c71dbe89aae485082c90c7625e9517fdcb2042b253ec297fa2fd4d68d3ee35aa12f9fee8269 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_promotion_api')
	ALTER LOGIN [retail_promotion_api] WITH PASSWORD = 0x0200ee303dc42ec90c563d7f8efedd8e6305a9f136c57ab523003c5a970c8194bb4d0e3501cd6db9e5af9de34f37b0a728715a9ebd1470306138684e692404298a3cc60f34c5 HASHED
ELSE
	CREATE LOGIN [retail_promotion_api] WITH PASSWORD = 0x0200ee303dc42ec90c563d7f8efedd8e6305a9f136c57ab523003c5a970c8194bb4d0e3501cd6db9e5af9de34f37b0a728715a9ebd1470306138684e692404298a3cc60f34c5 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_public_api')
	ALTER LOGIN [retail_public_api] WITH PASSWORD = 0x02003f1cbacb01894b9a63ee85e0ad63bb194b86ad5de970c2d765007e82c806d8c0aa6917aefb772c27fc361aab3b0fd799a0a765153bb0f2bc35802a33ef29c2353f193fca HASHED
ELSE
	CREATE LOGIN [retail_public_api] WITH PASSWORD = 0x02003f1cbacb01894b9a63ee85e0ad63bb194b86ad5de970c2d765007e82c806d8c0aa6917aefb772c27fc361aab3b0fd799a0a765153bb0f2bc35802a33ef29c2353f193fca HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_qlkv')
	ALTER LOGIN [retail_qlkv] WITH PASSWORD = 0x0200b92f6459cdf56d9eaef8747a15ec83fc23c4b35cef37abd503b4649829e5e5d9fcb6342e32f9577092dcee53bfdf3b54975bd3d1133e44c4ea00bbddee577d5d3bb44aee HASHED
ELSE
	CREATE LOGIN [retail_qlkv] WITH PASSWORD = 0x0200b92f6459cdf56d9eaef8747a15ec83fc23c4b35cef37abd503b4649829e5e5d9fcb6342e32f9577092dcee53bfdf3b54975bd3d1133e44c4ea00bbddee577d5d3bb44aee HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_report_api')
	ALTER LOGIN [retail_report_api] WITH PASSWORD = 0x02002f68a0ec137d6f6ba16845889f910f01cd1076a8d5eae27ed1d67d06af9cbee16115b745b96c5632b9916e6b407ea7ab8c663fa239ba4d80d7c3455660185f30defa4078 HASHED
ELSE
	CREATE LOGIN [retail_report_api] WITH PASSWORD = 0x02002f68a0ec137d6f6ba16845889f910f01cd1076a8d5eae27ed1d67d06af9cbee16115b745b96c5632b9916e6b407ea7ab8c663fa239ba4d80d7c3455660185f30defa4078 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_sale_api')
	ALTER LOGIN [retail_sale_api] WITH PASSWORD = 0x0200b8550681b2ab6f91886da82e626ca5538b8653270b1d41b4fcc5ae6bad40b0ab97de82c3b587c37a004e47bf2669a97157c12cd8a75c07ecf596f88199d73f3083955ea6 HASHED
ELSE
	CREATE LOGIN [retail_sale_api] WITH PASSWORD = 0x0200b8550681b2ab6f91886da82e626ca5538b8653270b1d41b4fcc5ae6bad40b0ab97de82c3b587c37a004e47bf2669a97157c12cd8a75c07ecf596f88199d73f3083955ea6 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_shipping_api')
	ALTER LOGIN [retail_shipping_api] WITH PASSWORD = 0x020085bb165ad65080f83b76814f727ad7695fa9dcf2d1474360553d602160eaad91d7f6f07e81a0b1ec14a302e9469b1715ce2ee1971d20832e832684fccd2dcc5b25a949f8 HASHED
ELSE
	CREATE LOGIN [retail_shipping_api] WITH PASSWORD = 0x020085bb165ad65080f83b76814f727ad7695fa9dcf2d1474360553d602160eaad91d7f6f07e81a0b1ec14a302e9469b1715ce2ee1971d20832e832684fccd2dcc5b25a949f8 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_shipping_svc')
	ALTER LOGIN [retail_shipping_svc] WITH PASSWORD = 0x020030f41f1ae5e715362f1c42f3857a1008182f5e2cf34e1d2a5b7a79fa42e2eac07e17afa8d4301f91434b7c29f56c1d1ceff2b882cdd4d18edf5a456011a1b16c82da179b HASHED
ELSE
	CREATE LOGIN [retail_shipping_svc] WITH PASSWORD = 0x020030f41f1ae5e715362f1c42f3857a1008182f5e2cf34e1d2a5b7a79fa42e2eac07e17afa8d4301f91434b7c29f56c1d1ceff2b882cdd4d18edf5a456011a1b16c82da179b HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_sms_svc')
	ALTER LOGIN [retail_sms_svc] WITH PASSWORD = 0x0200423b1ff41ee6daa21cb69203a3e1a728371d93dbd6a72c9fb05d2f930f6fd0933620e101e44f4bcd649beef35a32edef88ce4b727303c67ebc046681a963bf8a881f8d84 HASHED
ELSE
	CREATE LOGIN [retail_sms_svc] WITH PASSWORD = 0x0200423b1ff41ee6daa21cb69203a3e1a728371d93dbd6a72c9fb05d2f930f6fd0933620e101e44f4bcd649beef35a32edef88ce4b727303c67ebc046681a963bf8a881f8d84 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_sync_es_log_svc')
	ALTER LOGIN [retail_sync_es_log_svc] WITH PASSWORD = 0x0200e808b0379bd16e194206a54e2cd91305ee83aca25dbe31991a76329037bf14d9536232421a9fb7047f6ecdf298b607d93c4edd06d5ad24d5ad95cb8555505df88d70198c HASHED
ELSE
	CREATE LOGIN [retail_sync_es_log_svc] WITH PASSWORD = 0x0200e808b0379bd16e194206a54e2cd91305ee83aca25dbe31991a76329037bf14d9536232421a9fb7047f6ecdf298b607d93c4edd06d5ad24d5ad95cb8555505df88d70198c HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_sync_es_svc')
	ALTER LOGIN [retail_sync_es_svc] WITH PASSWORD = 0x02008ea83b27bd15c52a8284a50d71885b7a5babbeffdeae1bd0da69aa705c859a51caa668da1a105f5673b3a306f3948e95be3f7487c4a0b69b5f03a964b5b8a71ad04bb93c HASHED
ELSE
	CREATE LOGIN [retail_sync_es_svc] WITH PASSWORD = 0x02008ea83b27bd15c52a8284a50d71885b7a5babbeffdeae1bd0da69aa705c859a51caa668da1a105f5673b3a306f3948e95be3f7487c4a0b69b5f03a964b5b8a71ad04bb93c HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_tracking_log_svc')
	ALTER LOGIN [retail_tracking_log_svc] WITH PASSWORD = 0x0200cc6a4348b0759d09e09d927d7511a5793a519b5731658ac65cee95e6d95ab88ed20f07dabaa3dc79b9febf2aa7ed668e0f721c2029d08351f150aaceb01a7e543456c0ad HASHED
ELSE
	CREATE LOGIN [retail_tracking_log_svc] WITH PASSWORD = 0x0200cc6a4348b0759d09e09d927d7511a5793a519b5731658ac65cee95e6d95ab88ed20f07dabaa3dc79b9febf2aa7ed668e0f721c2029d08351f150aaceb01a7e543456c0ad HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_tracking_recovery_api')
	ALTER LOGIN [retail_tracking_recovery_api] WITH PASSWORD = 0x0200c1c5cd81c1c4ac3ea3d373310399d0222f754b802dec6739e803c60b7766f9cc68356d912e49b4f969f4803d547fbbab3704981d34cb39e286de53370cf8b5213a3c345b HASHED
ELSE
	CREATE LOGIN [retail_tracking_recovery_api] WITH PASSWORD = 0x0200c1c5cd81c1c4ac3ea3d373310399d0222f754b802dec6739e803c60b7766f9cc68356d912e49b4f969f4803d547fbbab3704981d34cb39e286de53370cf8b5213a3c345b HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_tracking_recovery_svc')
	ALTER LOGIN [retail_tracking_recovery_svc] WITH PASSWORD = 0x020071479bfbba400b0b2c119011e7b4ac7c0beea36f031c55526db4daf2693f519d6e6afb79f42d9954f38d33ee2d2ccc27aca8c28de88f944d05204635f00e5e169ab506b1 HASHED
ELSE
	CREATE LOGIN [retail_tracking_recovery_svc] WITH PASSWORD = 0x020071479bfbba400b0b2c119011e7b4ac7c0beea36f031c55526db4daf2693f519d6e6afb79f42d9954f38d33ee2d2ccc27aca8c28de88f944d05204635f00e5e169ab506b1 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_tracking_rerun_svc')
	ALTER LOGIN [retail_tracking_rerun_svc] WITH PASSWORD = 0x0200e2e55f120daac033de3eb3e1eb21ea28d379dd9373a9c096aaecba0706b1131a5e571b0f3bc5bc5a75ffb6bf05ca0d0d92c676d0d0bb4e2ea52c98c81bd3b542a9e3d9c4 HASHED
ELSE
	CREATE LOGIN [retail_tracking_rerun_svc] WITH PASSWORD = 0x0200e2e55f120daac033de3eb3e1eb21ea28d379dd9373a9c096aaecba0706b1131a5e571b0f3bc5bc5a75ffb6bf05ca0d0d92c676d0d0bb4e2ea52c98c81bd3b542a9e3d9c4 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_tracking_svc')
	ALTER LOGIN [retail_tracking_svc] WITH PASSWORD = 0x02003955652b8c4b3a2861c505e7ff5bcaae7978d81bb9c4f8636a8498b0d52180acbbce2a5daffea7885d89dc45f2721e40125000ac1dc0deb487dcfe460f03240456b5fd31 HASHED
ELSE
	CREATE LOGIN [retail_tracking_svc] WITH PASSWORD = 0x02003955652b8c4b3a2861c505e7ff5bcaae7978d81bb9c4f8636a8498b0d52180acbbce2a5daffea7885d89dc45f2721e40125000ac1dc0deb487dcfe460f03240456b5fd31 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_util_svc')
	ALTER LOGIN [retail_util_svc] WITH PASSWORD = 0x020048e4607ea70ecdab14793ed2b52f10faf95048582c7d6ffedde6ed711bfc7a955a564f3239bcca62a0fb244696d3df36eb23709a107801ec7608848d4ba7c2456c371d04 HASHED
ELSE
	CREATE LOGIN [retail_util_svc] WITH PASSWORD = 0x020048e4607ea70ecdab14793ed2b52f10faf95048582c7d6ffedde6ed711bfc7a955a564f3239bcca62a0fb244696d3df36eb23709a107801ec7608848d4ba7c2456c371d04 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_warranty_api')
	ALTER LOGIN [retail_warranty_api] WITH PASSWORD = 0x0200c98f22cc3a9260c04d475d2799877ec5b0c20041b331a81b8d9b39d86145137781cb9c47f535c57b4023942cf1840cc25181fb57f4631a1dfc27932a47165914d09454fa HASHED
ELSE
	CREATE LOGIN [retail_warranty_api] WITH PASSWORD = 0x0200c98f22cc3a9260c04d475d2799877ec5b0c20041b331a81b8d9b39d86145137781cb9c47f535c57b4023942cf1840cc25181fb57f4631a1dfc27932a47165914d09454fa HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_webhook_api')
	ALTER LOGIN [retail_webhook_api] WITH PASSWORD = 0x0200650358ba30e6b9dd0be240bd4eef633bc5f6f44207f36c13d40d4e9f125f1dc37f6a4f1e03997e6d0a2f3c554cc22c7def5fa74330a79a7c08d65a5870a528a027027ffe HASHED
ELSE
	CREATE LOGIN [retail_webhook_api] WITH PASSWORD = 0x0200650358ba30e6b9dd0be240bd4eef633bc5f6f44207f36c13d40d4e9f125f1dc37f6a4f1e03997e6d0a2f3c554cc22c7def5fa74330a79a7c08d65a5870a528a027027ffe HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_webhook_server')
	ALTER LOGIN [retail_webhook_server] WITH PASSWORD = 0x02009b0c98f62c6f85f4c76dd4449a5ef776de5f32efa28275c7a93c27cd1fcf01175b12555b8edeba6873f0703ea1b15997dd82dfbb4efb17e4a7f9758296695f481fd13c8d HASHED
ELSE
	CREATE LOGIN [retail_webhook_server] WITH PASSWORD = 0x02009b0c98f62c6f85f4c76dd4449a5ef776de5f32efa28275c7a93c27cd1fcf01175b12555b8edeba6873f0703ea1b15997dd82dfbb4efb17e4a7f9758296695f481fd13c8d HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_webhook_svc')
	ALTER LOGIN [retail_webhook_svc] WITH PASSWORD = 0x02004f9f571806d82989fe47b902b3a324caba7b616b683ca9508af7fcc501614f83a420d820513726a25d9a60445edf5a7ede1310322ee167820664d65e2953ca5032cf04fe HASHED
ELSE
	CREATE LOGIN [retail_webhook_svc] WITH PASSWORD = 0x02004f9f571806d82989fe47b902b3a324caba7b616b683ca9508af7fcc501614f83a420d820513726a25d9a60445edf5a7ede1310322ee167820664d65e2953ca5032cf04fe HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_zalo_svc')
	ALTER LOGIN [retail_zalo_svc] WITH PASSWORD = 0x0200497391442c2f0e7d29974a2605bd2b95a80aa98649531010e0e1e027f0933222c00a97ceeec98420b3ccea35c2766ea35656336cd0d735d9908acb4f18901ee7594a2bc0 HASHED
ELSE
	CREATE LOGIN [retail_zalo_svc] WITH PASSWORD = 0x0200497391442c2f0e7d29974a2605bd2b95a80aa98649531010e0e1e027f0933222c00a97ceeec98420b3ccea35c2766ea35656336cd0d735d9908acb4f18901ee7594a2bc0 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF

USE [$(DatabaseName)]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_audit_api' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_audit_api', 'retail_audit_api';
ELSE
	BEGIN
		CREATE USER [retail_audit_api] FOR LOGIN [retail_audit_api];
		ALTER ROLE [db_owner] ADD MEMBER [retail_audit_api];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_audit_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_audit_svc', 'retail_audit_svc';
ELSE
	BEGIN
		CREATE USER [retail_audit_svc] FOR LOGIN [retail_audit_svc];
		ALTER ROLE [db_owner] ADD MEMBER [retail_audit_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_auto_customer_group_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_auto_customer_group_svc', 'retail_auto_customer_group_svc';
ELSE
	BEGIN
		CREATE USER [retail_auto_customer_group_svc] FOR LOGIN [retail_auto_customer_group_svc];
		ALTER ROLE [db_owner] ADD MEMBER [retail_auto_customer_group_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_clear_data_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_clear_data_svc', 'retail_clear_data_svc';
ELSE
	BEGIN
		CREATE USER [retail_clear_data_svc] FOR LOGIN [retail_clear_data_svc];
		ALTER ROLE [db_owner] ADD MEMBER [retail_clear_data_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_gmb_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_gmb_svc', 'retail_gmb_svc';
ELSE
	BEGIN
		CREATE USER [retail_gmb_svc] FOR LOGIN [retail_gmb_svc];
		ALTER ROLE [db_owner] ADD MEMBER [retail_gmb_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_identity_server' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_identity_server', 'retail_identity_server';
ELSE
	BEGIN
		CREATE USER [retail_identity_server] FOR LOGIN [retail_identity_server];
		ALTER ROLE [db_owner] ADD MEMBER [retail_identity_server];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_imp_exp_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_imp_exp_svc', 'retail_imp_exp_svc';
ELSE
	BEGIN
		CREATE USER [retail_imp_exp_svc] FOR LOGIN [retail_imp_exp_svc];
		ALTER ROLE [db_owner] ADD MEMBER [retail_imp_exp_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_internal_api' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_internal_api', 'retail_internal_api';
ELSE
	BEGIN
		CREATE USER [retail_internal_api] FOR LOGIN [retail_internal_api];
		ALTER ROLE [db_owner] ADD MEMBER [retail_internal_api];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_kiot_api' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_kiot_api', 'retail_kiot_api';
ELSE
	BEGIN
		CREATE USER [retail_kiot_api] FOR LOGIN [retail_kiot_api];
		ALTER ROLE [db_owner] ADD MEMBER [retail_kiot_api];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_kvaa_api' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_kvaa_api', 'retail_kvaa_api';
ELSE
	BEGIN
		CREATE USER [retail_kvaa_api] FOR LOGIN [retail_kvaa_api];
		ALTER ROLE [db_owner] ADD MEMBER [retail_kvaa_api];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_kyc_api' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_kyc_api', 'retail_kyc_api';
ELSE
	BEGIN
		CREATE USER [retail_kyc_api] FOR LOGIN [retail_kyc_api];
		ALTER ROLE [db_owner] ADD MEMBER [retail_kyc_api];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_limit_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_limit_svc', 'retail_limit_svc';
ELSE
	BEGIN
		CREATE USER [retail_limit_svc] FOR LOGIN [retail_limit_svc];
		ALTER ROLE [db_owner] ADD MEMBER [retail_limit_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_mhql' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_mhql', 'retail_mhql';
ELSE
	BEGIN
		CREATE USER [retail_mhql] FOR LOGIN [retail_mhql];
		ALTER ROLE [db_owner] ADD MEMBER [retail_mhql];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_mobile_api' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_mobile_api', 'retail_mobile_api';
ELSE
	BEGIN
		CREATE USER [retail_mobile_api] FOR LOGIN [retail_mobile_api];
		ALTER ROLE [db_owner] ADD MEMBER [retail_mobile_api];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_pricebook_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_pricebook_svc', 'retail_pricebook_svc';
ELSE
	BEGIN
		CREATE USER [retail_pricebook_svc] FOR LOGIN [retail_pricebook_svc];
		ALTER ROLE [db_owner] ADD MEMBER [retail_pricebook_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_promotion_api' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_promotion_api', 'retail_promotion_api';
ELSE
	BEGIN
		CREATE USER [retail_promotion_api] FOR LOGIN [retail_promotion_api];
		ALTER ROLE [db_owner] ADD MEMBER [retail_promotion_api];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_public_api' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_public_api', 'retail_public_api';
ELSE
	BEGIN
		CREATE USER [retail_public_api] FOR LOGIN [retail_public_api];
		ALTER ROLE [db_owner] ADD MEMBER [retail_public_api];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_qlkv' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_qlkv', 'retail_qlkv';
ELSE
	BEGIN
		CREATE USER [retail_qlkv] FOR LOGIN [retail_qlkv];
		ALTER ROLE [db_owner] ADD MEMBER [retail_qlkv];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_report_api' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_report_api', 'retail_report_api';
ELSE
	BEGIN
		CREATE USER [retail_report_api] FOR LOGIN [retail_report_api];
		ALTER ROLE [db_owner] ADD MEMBER [retail_report_api];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_sale_api' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_sale_api', 'retail_sale_api';
ELSE
	BEGIN
		CREATE USER [retail_sale_api] FOR LOGIN [retail_sale_api];
		ALTER ROLE [db_owner] ADD MEMBER [retail_sale_api];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_shipping_api' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_shipping_api', 'retail_shipping_api';
ELSE
	BEGIN
		CREATE USER [retail_shipping_api] FOR LOGIN [retail_shipping_api];
		ALTER ROLE [db_owner] ADD MEMBER [retail_shipping_api];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_shipping_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_shipping_svc', 'retail_shipping_svc';
ELSE
	BEGIN
		CREATE USER [retail_shipping_svc] FOR LOGIN [retail_shipping_svc];
		ALTER ROLE [db_owner] ADD MEMBER [retail_shipping_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_sms_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_sms_svc', 'retail_sms_svc';
ELSE
	BEGIN
		CREATE USER [retail_sms_svc] FOR LOGIN [retail_sms_svc];
		ALTER ROLE [db_owner] ADD MEMBER [retail_sms_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_sync_es_log_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_sync_es_log_svc', 'retail_sync_es_log_svc';
ELSE
	BEGIN
		CREATE USER [retail_sync_es_log_svc] FOR LOGIN [retail_sync_es_log_svc];
		ALTER ROLE [db_owner] ADD MEMBER [retail_sync_es_log_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_sync_es_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_sync_es_svc', 'retail_sync_es_svc';
ELSE
	BEGIN
		CREATE USER [retail_sync_es_svc] FOR LOGIN [retail_sync_es_svc];
		ALTER ROLE [db_owner] ADD MEMBER [retail_sync_es_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_tracking_log_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_tracking_log_svc', 'retail_tracking_log_svc';
ELSE
	BEGIN
		CREATE USER [retail_tracking_log_svc] FOR LOGIN [retail_tracking_log_svc];
		ALTER ROLE [db_owner] ADD MEMBER [retail_tracking_log_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_tracking_recovery_api' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_tracking_recovery_api', 'retail_tracking_recovery_api';
ELSE
	BEGIN
		CREATE USER [retail_tracking_recovery_api] FOR LOGIN [retail_tracking_recovery_api];
		ALTER ROLE [db_owner] ADD MEMBER [retail_tracking_recovery_api];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_tracking_recovery_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_tracking_recovery_svc', 'retail_tracking_recovery_svc';
ELSE
	BEGIN
		CREATE USER [retail_tracking_recovery_svc] FOR LOGIN [retail_tracking_recovery_svc];
		ALTER ROLE [db_owner] ADD MEMBER [retail_tracking_recovery_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_tracking_rerun_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_tracking_rerun_svc', 'retail_tracking_rerun_svc';
ELSE
	BEGIN
		CREATE USER [retail_tracking_rerun_svc] FOR LOGIN [retail_tracking_rerun_svc];
		ALTER ROLE [db_owner] ADD MEMBER [retail_tracking_rerun_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_tracking_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_tracking_svc', 'retail_tracking_svc';
ELSE
	BEGIN
		CREATE USER [retail_tracking_svc] FOR LOGIN [retail_tracking_svc];
		ALTER ROLE [db_owner] ADD MEMBER [retail_tracking_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_util_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_util_svc', 'retail_util_svc';
ELSE
	BEGIN
		CREATE USER [retail_util_svc] FOR LOGIN [retail_util_svc];
		ALTER ROLE [db_owner] ADD MEMBER [retail_util_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_warranty_api' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_warranty_api', 'retail_warranty_api';
ELSE
	BEGIN
		CREATE USER [retail_warranty_api] FOR LOGIN [retail_warranty_api];
		ALTER ROLE [db_owner] ADD MEMBER [retail_warranty_api];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_webhook_api' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_webhook_api', 'retail_webhook_api';
ELSE
	BEGIN
		CREATE USER [retail_webhook_api] FOR LOGIN [retail_webhook_api];
		ALTER ROLE [db_owner] ADD MEMBER [retail_webhook_api];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_webhook_server' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_webhook_server', 'retail_webhook_server';
ELSE
	BEGIN
		CREATE USER [retail_webhook_server] FOR LOGIN [retail_webhook_server];
		ALTER ROLE [db_owner] ADD MEMBER [retail_webhook_server];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_webhook_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_webhook_svc', 'retail_webhook_svc';
ELSE
	BEGIN
		CREATE USER [retail_webhook_svc] FOR LOGIN [retail_webhook_svc];
		ALTER ROLE [db_owner] ADD MEMBER [retail_webhook_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_zalo_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_zalo_svc', 'retail_zalo_svc';
ELSE
	BEGIN
		CREATE USER [retail_zalo_svc] FOR LOGIN [retail_zalo_svc];
		ALTER ROLE [db_owner] ADD MEMBER [retail_zalo_svc];
	END