/*********** LOGIN ***********/
SET NOEXEC OFF
GO
USE [master]
GO
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_api_audit')
	ALTER LOGIN [fnb_api_audit] WITH PASSWORD = 0x02007f9f1e2fa45cdc3d5fe5676a9a26548141f6b985cdc971204daeea3e3aebeefafc0f9f3c26406be365fe3a7807cb8d79d2059e653c7f07d71918a3b9d56c557e765226b4 HASHED
ELSE
	CREATE LOGIN [fnb_api_audit] WITH PASSWORD = 0x02007f9f1e2fa45cdc3d5fe5676a9a26548141f6b985cdc971204daeea3e3aebeefafc0f9f3c26406be365fe3a7807cb8d79d2059e653c7f07d71918a3b9d56c557e765226b4 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_api_mobile')
	ALTER LOGIN [fnb_api_mobile] WITH PASSWORD = 0x0200c481715f5e32ca0580bfe97f8685fc0401cad6ceb7764d17c573a4317592d56285b73c81f64bcfdffbe7a3d954a34388fac761ee768345995a319edec880eefbeae912a5 HASHED
ELSE
	CREATE LOGIN [fnb_api_mobile] WITH PASSWORD = 0x0200c481715f5e32ca0580bfe97f8685fc0401cad6ceb7764d17c573a4317592d56285b73c81f64bcfdffbe7a3d954a34388fac761ee768345995a319edec880eefbeae912a5 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_api_promotion')
	ALTER LOGIN [fnb_api_promotion] WITH PASSWORD = 0x0200ab2fa7c1a3f85f407b96b8d9e4613b07b3630cf8df0a6a851fee0d76636523da16224b27b510403f1b8f09a1c771f743cd91f5870c7619d8ab0cb2356c678dbe27a7ebf1 HASHED
ELSE
	CREATE LOGIN [fnb_api_promotion] WITH PASSWORD = 0x0200ab2fa7c1a3f85f407b96b8d9e4613b07b3630cf8df0a6a851fee0d76636523da16224b27b510403f1b8f09a1c771f743cd91f5870c7619d8ab0cb2356c678dbe27a7ebf1 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_api_public')
	ALTER LOGIN [fnb_api_public] WITH PASSWORD = 0x02008816c1a70c15531a99fc416945c6487ac791b7f711697abc3ae8951073c187e1eda43313b8197557514e5a89e4a81d03d43d897f3e5a0563bae864cf242f6271914847ba HASHED
ELSE
	CREATE LOGIN [fnb_api_public] WITH PASSWORD = 0x02008816c1a70c15531a99fc416945c6487ac791b7f711697abc3ae8951073c187e1eda43313b8197557514e5a89e4a81d03d43d897f3e5a0563bae864cf242f6271914847ba HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_api_report')
	ALTER LOGIN [fnb_api_report] WITH PASSWORD = 0x02008f9b7c79f1840e4a1714201c285a4610c8b151a0652995db13b9c111a596dd618aa309048a757bc3b1a253019d389103992612926a8878ffb290b9d00ec3dd4cf940d900 HASHED
ELSE
	CREATE LOGIN [fnb_api_report] WITH PASSWORD = 0x02008f9b7c79f1840e4a1714201c285a4610c8b151a0652995db13b9c111a596dd618aa309048a757bc3b1a253019d389103992612926a8878ffb290b9d00ec3dd4cf940d900 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_api_shipping')
	ALTER LOGIN [fnb_api_shipping] WITH PASSWORD = 0x02005284af41ebffd6a5cc03909924dfbc1214fd7edef59c51d89458395f99f4d9fc355c1309fd746de428b475ac42b90a4a9fc4ad01ac58d1a5001f1b9e6af0805c4bc9b9b1 HASHED
ELSE
	CREATE LOGIN [fnb_api_shipping] WITH PASSWORD = 0x02005284af41ebffd6a5cc03909924dfbc1214fd7edef59c51d89458395f99f4d9fc355c1309fd746de428b475ac42b90a4a9fc4ad01ac58d1a5001f1b9e6af0805c4bc9b9b1 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_api_webhook')
	ALTER LOGIN [fnb_api_webhook] WITH PASSWORD = 0x02007cb31716c00be4239db0460bfad1062c2ebf46b96705aee8ad41f3c947b975fdd1fa59eb9b57017fac7afa108db931f3b5da498cadf09cb236a6ea889ed5eea73a85846d HASHED
ELSE
	CREATE LOGIN [fnb_api_webhook] WITH PASSWORD = 0x02007cb31716c00be4239db0460bfad1062c2ebf46b96705aee8ad41f3c947b975fdd1fa59eb9b57017fac7afa108db931f3b5da498cadf09cb236a6ea889ed5eea73a85846d HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_cross_check_pay_api')
	ALTER LOGIN [fnb_cross_check_pay_api] WITH PASSWORD = 0x020092a2a7f35634bf06a7a498c08b7ba89020dbc03dbe4fc4bd57d532568db3342c7788caab6f22ee1fae579a8f3fe160ec4fdb8f2605a5d461b6a5dedca4265c79452ce526 HASHED
ELSE
	CREATE LOGIN [fnb_cross_check_pay_api] WITH PASSWORD = 0x020092a2a7f35634bf06a7a498c08b7ba89020dbc03dbe4fc4bd57d532568db3342c7788caab6f22ee1fae579a8f3fe160ec4fdb8f2605a5d461b6a5dedca4265c79452ce526 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_order_notification_svc')
	ALTER LOGIN [fnb_order_notification_svc] WITH PASSWORD = 0x0200d58d54f5bae57b22d5403546aa4fc148394501da2dc0b55e8d4b6582f75592b659159fb3aae1e0ff332ae36e5033e203ef7a6c6de9291acccf1088719444c139a271b4c2 HASHED
ELSE
	CREATE LOGIN [fnb_order_notification_svc] WITH PASSWORD = 0x0200d58d54f5bae57b22d5403546aa4fc148394501da2dc0b55e8d4b6582f75592b659159fb3aae1e0ff332ae36e5033e203ef7a6c6de9291acccf1088719444c139a271b4c2 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_svc_audit')
	ALTER LOGIN [fnb_svc_audit] WITH PASSWORD = 0x0200036a4c105d9788a7f9584f9cdb8f484df1e2de0d03ba841b98d7079138cd57bd504e2a5d03efd6d319569400ce1963343fd2e1d6aebd2265698d8ac80bcb55b338ec6c97 HASHED
ELSE
	CREATE LOGIN [fnb_svc_audit] WITH PASSWORD = 0x0200036a4c105d9788a7f9584f9cdb8f484df1e2de0d03ba841b98d7079138cd57bd504e2a5d03efd6d319569400ce1963343fd2e1d6aebd2265698d8ac80bcb55b338ec6c97 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_svc_auto_customer_group')
	ALTER LOGIN [fnb_svc_auto_customer_group] WITH PASSWORD = 0x0200925678ffda8eccccf1f50e8faff0590cef9f279fae5ae4bc75f0119e6bc3f6010eb95480289652d95de2113e538c82c0da097cdcb615254b0cbf7f02cd127596eebfb9c1 HASHED
ELSE
	CREATE LOGIN [fnb_svc_auto_customer_group] WITH PASSWORD = 0x0200925678ffda8eccccf1f50e8faff0590cef9f279fae5ae4bc75f0119e6bc3f6010eb95480289652d95de2113e538c82c0da097cdcb615254b0cbf7f02cd127596eebfb9c1 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_svc_gmb')
	ALTER LOGIN [fnb_svc_gmb] WITH PASSWORD = 0x020049f10a83548b301756d0403240ac2444f248e88d8a55fe58110c0fab8e3f086a77732ba32e535e56aaa8145a73c3b9a04d029d3645be12b3fcf8915b21362c4a49166382 HASHED
ELSE
	CREATE LOGIN [fnb_svc_gmb] WITH PASSWORD = 0x020049f10a83548b301756d0403240ac2444f248e88d8a55fe58110c0fab8e3f086a77732ba32e535e56aaa8145a73c3b9a04d029d3645be12b3fcf8915b21362c4a49166382 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_svc_imp_exp')
	ALTER LOGIN [fnb_svc_imp_exp] WITH PASSWORD = 0x020025e79604becc733312a408f900f3885034012d5fa6923861b3e8c69b1137a47f221660619c4a5b7b4724e5da89fc695452550fc75c8695e6a6b1bd338edd85b47bc4801f HASHED
ELSE
	CREATE LOGIN [fnb_svc_imp_exp] WITH PASSWORD = 0x020025e79604becc733312a408f900f3885034012d5fa6923861b3e8c69b1137a47f221660619c4a5b7b4724e5da89fc695452550fc75c8695e6a6b1bd338edd85b47bc4801f HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_svc_pricebook')
	ALTER LOGIN [fnb_svc_pricebook] WITH PASSWORD = 0x02003ea1c3d162b9fb80710ec5df384e04590e4b66fed2497e49e8798d3d7ac0fca94a4e2e31db6802cf752684dcec109cbda33f6b17231be4dc70d80725d9f683aa67e23ef0 HASHED
ELSE
	CREATE LOGIN [fnb_svc_pricebook] WITH PASSWORD = 0x02003ea1c3d162b9fb80710ec5df384e04590e4b66fed2497e49e8798d3d7ac0fca94a4e2e31db6802cf752684dcec109cbda33f6b17231be4dc70d80725d9f683aa67e23ef0 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_svc_shipping')
	ALTER LOGIN [fnb_svc_shipping] WITH PASSWORD = 0x0200fbfb47f398b96848e1e553a2b91811099238f37ba9e55260c24dbed3d4acb5f85851106c66e1abded021d3525bab0a4275a382adf47b71533f54c7998b19f8c3b9fb0847 HASHED
ELSE
	CREATE LOGIN [fnb_svc_shipping] WITH PASSWORD = 0x0200fbfb47f398b96848e1e553a2b91811099238f37ba9e55260c24dbed3d4acb5f85851106c66e1abded021d3525bab0a4275a382adf47b71533f54c7998b19f8c3b9fb0847 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_svc_util')
	ALTER LOGIN [fnb_svc_util] WITH PASSWORD = 0x020096ed745b8c696229033889caa6258ee3e22ca19cb1c70d283a7ac4b2e9bbbdc2622136b9e69c5e6859160e66d43fe15108417550e05c658318b24ed0715bfdf4b1a538f0 HASHED
ELSE
	CREATE LOGIN [fnb_svc_util] WITH PASSWORD = 0x020096ed745b8c696229033889caa6258ee3e22ca19cb1c70d283a7ac4b2e9bbbdc2622136b9e69c5e6859160e66d43fe15108417550e05c658318b24ed0715bfdf4b1a538f0 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_svc_webhook')
	ALTER LOGIN [fnb_svc_webhook] WITH PASSWORD = 0x0200dfa4283872a11b49c62f96c5d0155fd044d15ca6c323da63eefd5097a188ef8d9f0ab88c22aed47362c2c3275c68c497d8291a8875a9b9d5010080a26a4d641f4fd7abdc HASHED
ELSE
	CREATE LOGIN [fnb_svc_webhook] WITH PASSWORD = 0x0200dfa4283872a11b49c62f96c5d0155fd044d15ca6c323da63eefd5097a188ef8d9f0ab88c22aed47362c2c3275c68c497d8291a8875a9b9d5010080a26a4d641f4fd7abdc HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_svc_zalo')
	ALTER LOGIN [fnb_svc_zalo] WITH PASSWORD = 0x0200f28652b5abc035afd2314aae75cd1b938786e016b098f346a5a54a799552abc3386e3d876c3a7c80d1714d65bf0aa71576c8c51184771e211375515601a720b272cc77a3 HASHED
ELSE
	CREATE LOGIN [fnb_svc_zalo] WITH PASSWORD = 0x0200f28652b5abc035afd2314aae75cd1b938786e016b098f346a5a54a799552abc3386e3d876c3a7c80d1714d65bf0aa71576c8c51184771e211375515601a720b272cc77a3 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_sync_order_svc')
	ALTER LOGIN [fnb_sync_order_svc] WITH PASSWORD = 0x020044328c0fdb20a90496b3de0c2b84bcc0da04aed8959d75d23dd623ec078cb2be496ac365229cbb71d12050bbab94b33bd83493d6d08c79dc66e8dd1f3d77ea9c78375606 HASHED
ELSE
	CREATE LOGIN [fnb_sync_order_svc] WITH PASSWORD = 0x020044328c0fdb20a90496b3de0c2b84bcc0da04aed8959d75d23dd623ec078cb2be496ac365229cbb71d12050bbab94b33bd83493d6d08c79dc66e8dd1f3d77ea9c78375606 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_tracking_rerun_svc')
	ALTER LOGIN [fnb_tracking_rerun_svc] WITH PASSWORD = 0x0200310c9f0ae18ec8e23f058a2086e618fe375e2b697c1daa4bb4fcae28d129c9abfb81b1fb301a69e818e16f4e4617d8e7e003c81fa0ee0729ed40eb53e6ea239608f7ba06 HASHED
ELSE
	CREATE LOGIN [fnb_tracking_rerun_svc] WITH PASSWORD = 0x0200310c9f0ae18ec8e23f058a2086e618fe375e2b697c1daa4bb4fcae28d129c9abfb81b1fb301a69e818e16f4e4617d8e7e003c81fa0ee0729ed40eb53e6ea239608f7ba06 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_tracking_svc')
	ALTER LOGIN [fnb_tracking_svc] WITH PASSWORD = 0x0200bc202dd84220367168d7678aa493467a9ea11c592141967d1db4a7309214bcdeae9f35600000765d83d3cb911738180594645a82ba60dba452147daad64035012c08fe9f HASHED
ELSE
	CREATE LOGIN [fnb_tracking_svc] WITH PASSWORD = 0x0200bc202dd84220367168d7678aa493467a9ea11c592141967d1db4a7309214bcdeae9f35600000765d83d3cb911738180594645a82ba60dba452147daad64035012c08fe9f HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_web_mhql')
	ALTER LOGIN [fnb_web_mhql] WITH PASSWORD = 0x02004011a1da9775ad5cb79887bcaf3cfb67bf8b3ff39ece7212161bf728446abd6f46a521c5394389e2f0ca4889be7bae0d7d5621813936a06807e4df21509472f80db90db7 HASHED
ELSE
	CREATE LOGIN [fnb_web_mhql] WITH PASSWORD = 0x02004011a1da9775ad5cb79887bcaf3cfb67bf8b3ff39ece7212161bf728446abd6f46a521c5394389e2f0ca4889be7bae0d7d5621813936a06807e4df21509472f80db90db7 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_web_webhook')
	ALTER LOGIN [fnb_web_webhook] WITH PASSWORD = 0x0200e47d4efd6d36d9ce9847f91a3b88dc8c5a11241654144a599522a108615cf6644d8c16c2c8e2c2f2ce59b1da2a327158761ce6214ba15c5c5ec4e58e0dcaedc521a873f4 HASHED
ELSE
	CREATE LOGIN [fnb_web_webhook] WITH PASSWORD = 0x0200e47d4efd6d36d9ce9847f91a3b88dc8c5a11241654144a599522a108615cf6644d8c16c2c8e2c2f2ce59b1da2a327158761ce6214ba15c5c5ec4e58e0dcaedc521a873f4 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF

USE [$(DatabaseName)]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_api_audit' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_api_audit', 'fnb_api_audit';
ELSE
	BEGIN
		CREATE USER [fnb_api_audit] FOR LOGIN [fnb_api_audit];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_api_audit];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_api_mobile' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_api_mobile', 'fnb_api_mobile';
ELSE
	BEGIN
		CREATE USER [fnb_api_mobile] FOR LOGIN [fnb_api_mobile];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_api_mobile];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_api_promotion' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_api_promotion', 'fnb_api_promotion';
ELSE
	BEGIN
		CREATE USER [fnb_api_promotion] FOR LOGIN [fnb_api_promotion];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_api_promotion];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_api_public' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_api_public', 'fnb_api_public';
ELSE
	BEGIN
		CREATE USER [fnb_api_public] FOR LOGIN [fnb_api_public];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_api_public];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_api_report' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_api_report', 'fnb_api_report';
ELSE
	BEGIN
		CREATE USER [fnb_api_report] FOR LOGIN [fnb_api_report];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_api_report];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_api_shipping' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_api_shipping', 'fnb_api_shipping';
ELSE
	BEGIN
		CREATE USER [fnb_api_shipping] FOR LOGIN [fnb_api_shipping];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_api_shipping];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_api_webhook' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_api_webhook', 'fnb_api_webhook';
ELSE
	BEGIN
		CREATE USER [fnb_api_webhook] FOR LOGIN [fnb_api_webhook];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_api_webhook];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_cross_check_pay_api' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_cross_check_pay_api', 'fnb_cross_check_pay_api';
ELSE
	BEGIN
		CREATE USER [fnb_cross_check_pay_api] FOR LOGIN [fnb_cross_check_pay_api];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_cross_check_pay_api];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_order_notification_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_order_notification_svc', 'fnb_order_notification_svc';
ELSE
	BEGIN
		CREATE USER [fnb_order_notification_svc] FOR LOGIN [fnb_order_notification_svc];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_order_notification_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_svc_audit' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_svc_audit', 'fnb_svc_audit';
ELSE
	BEGIN
		CREATE USER [fnb_svc_audit] FOR LOGIN [fnb_svc_audit];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_svc_audit];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_svc_auto_customer_group' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_svc_auto_customer_group', 'fnb_svc_auto_customer_group';
ELSE
	BEGIN
		CREATE USER [fnb_svc_auto_customer_group] FOR LOGIN [fnb_svc_auto_customer_group];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_svc_auto_customer_group];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_svc_gmb' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_svc_gmb', 'fnb_svc_gmb';
ELSE
	BEGIN
		CREATE USER [fnb_svc_gmb] FOR LOGIN [fnb_svc_gmb];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_svc_gmb];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_svc_imp_exp' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_svc_imp_exp', 'fnb_svc_imp_exp';
ELSE
	BEGIN
		CREATE USER [fnb_svc_imp_exp] FOR LOGIN [fnb_svc_imp_exp];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_svc_imp_exp];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_svc_pricebook' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_svc_pricebook', 'fnb_svc_pricebook';
ELSE
	BEGIN
		CREATE USER [fnb_svc_pricebook] FOR LOGIN [fnb_svc_pricebook];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_svc_pricebook];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_svc_shipping' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_svc_shipping', 'fnb_svc_shipping';
ELSE
	BEGIN
		CREATE USER [fnb_svc_shipping] FOR LOGIN [fnb_svc_shipping];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_svc_shipping];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_svc_util' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_svc_util', 'fnb_svc_util';
ELSE
	BEGIN
		CREATE USER [fnb_svc_util] FOR LOGIN [fnb_svc_util];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_svc_util];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_svc_webhook' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_svc_webhook', 'fnb_svc_webhook';
ELSE
	BEGIN
		CREATE USER [fnb_svc_webhook] FOR LOGIN [fnb_svc_webhook];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_svc_webhook];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_svc_zalo' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_svc_zalo', 'fnb_svc_zalo';
ELSE
	BEGIN
		CREATE USER [fnb_svc_zalo] FOR LOGIN [fnb_svc_zalo];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_svc_zalo];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_sync_order_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_sync_order_svc', 'fnb_sync_order_svc';
ELSE
	BEGIN
		CREATE USER [fnb_sync_order_svc] FOR LOGIN [fnb_sync_order_svc];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_sync_order_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_tracking_rerun_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_tracking_rerun_svc', 'fnb_tracking_rerun_svc';
ELSE
	BEGIN
		CREATE USER [fnb_tracking_rerun_svc] FOR LOGIN [fnb_tracking_rerun_svc];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_tracking_rerun_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_tracking_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_tracking_svc', 'fnb_tracking_svc';
ELSE
	BEGIN
		CREATE USER [fnb_tracking_svc] FOR LOGIN [fnb_tracking_svc];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_tracking_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_web_mhql' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_web_mhql', 'fnb_web_mhql';
ELSE
	BEGIN
		CREATE USER [fnb_web_mhql] FOR LOGIN [fnb_web_mhql];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_web_mhql];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_web_webhook' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_web_webhook', 'fnb_web_webhook';
ELSE
	BEGIN
		CREATE USER [fnb_web_webhook] FOR LOGIN [fnb_web_webhook];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_web_webhook];
	END
