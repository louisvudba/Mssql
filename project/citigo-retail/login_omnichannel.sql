/*********** LOGIN ***********/
SET NOEXEC OFF
GO
USE [master]
GO
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'omni_channel_api')
	ALTER LOGIN [omni_channel_api] WITH PASSWORD = 0x020015ee97b0944b4d8f85ae8f636dd1307d05c524777de6cd1bcc96576f1685e79182c0c1664335e263eb7dbf786bae7acc7b57e8f3bf2cbf8c2aa5ee4d807c11ee773e7986 HASHED
ELSE
	CREATE LOGIN [omni_channel_api] WITH PASSWORD = 0x020015ee97b0944b4d8f85ae8f636dd1307d05c524777de6cd1bcc96576f1685e79182c0c1664335e263eb7dbf786bae7acc7b57e8f3bf2cbf8c2aa5ee4d807c11ee773e7986 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'omni_channel_core_api')
	ALTER LOGIN [omni_channel_core_api] WITH PASSWORD = 0x020057881a7a9e10682721a35394e4ab3011ef7b7650b2d775afe0a18823061b1317a5d3bfffcaddfd8ac7108ebef36722d6bba215619446bb500f65480d21395c4f4d586ca2 HASHED
ELSE
	CREATE LOGIN [omni_channel_core_api] WITH PASSWORD = 0x020057881a7a9e10682721a35394e4ab3011ef7b7650b2d775afe0a18823061b1317a5d3bfffcaddfd8ac7108ebef36722d6bba215619446bb500f65480d21395c4f4d586ca2 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'omni_lazada_onhand_svc')
	ALTER LOGIN [omni_lazada_onhand_svc] WITH PASSWORD = 0x02003eef5bb702d47a7b0baf5a6b32b4f81c0a9364377183cf44f7a897b6bc418532180be84f71439f596b9284cba4f44ccd5f50cebbab03094dc56423f09f2f5e461acfc5cf HASHED
ELSE
	CREATE LOGIN [omni_lazada_onhand_svc] WITH PASSWORD = 0x02003eef5bb702d47a7b0baf5a6b32b4f81c0a9364377183cf44f7a897b6bc418532180be84f71439f596b9284cba4f44ccd5f50cebbab03094dc56423f09f2f5e461acfc5cf HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'omni_lazada_order_svc')
	ALTER LOGIN [omni_lazada_order_svc] WITH PASSWORD = 0x02006757c35cca079effbf6a319596f2f4b2bebac2638173be607d6291d4733cee891ded7e07867a4c3a76287d93c06e1f4a3171a0730b4da2c398838075982823411fcbd169 HASHED
ELSE
	CREATE LOGIN [omni_lazada_order_svc] WITH PASSWORD = 0x02006757c35cca079effbf6a319596f2f4b2bebac2638173be607d6291d4733cee891ded7e07867a4c3a76287d93c06e1f4a3171a0730b4da2c398838075982823411fcbd169 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'omni_lazada_price_svc')
	ALTER LOGIN [omni_lazada_price_svc] WITH PASSWORD = 0x0200ebf3b8ea25874a6fab790a5e744c8ed1f18fa10fd1cf85bcb4fbda26463e28e4970967d028242dd90c46c4c053c1d36e9dd84f4631ec623c3357aed050d1a331019dd86d HASHED
ELSE
	CREATE LOGIN [omni_lazada_price_svc] WITH PASSWORD = 0x0200ebf3b8ea25874a6fab790a5e744c8ed1f18fa10fd1cf85bcb4fbda26463e28e4970967d028242dd90c46c4c053c1d36e9dd84f4631ec623c3357aed050d1a331019dd86d HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'omni_mapping_product_svc')
	ALTER LOGIN [omni_mapping_product_svc] WITH PASSWORD = 0x0200e20e6f2c593e2c6da24f5b596b7f7ee14f7e7d81b3ffdce1f29f72f7e433f92ce9cefa6e8af8e53d8f6636c72af5296216b20ab36c218c74a2134fab356f1f39b9499a89 HASHED
ELSE
	CREATE LOGIN [omni_mapping_product_svc] WITH PASSWORD = 0x0200e20e6f2c593e2c6da24f5b596b7f7ee14f7e7d81b3ffdce1f29f72f7e433f92ce9cefa6e8af8e53d8f6636c72af5296216b20ab36c218c74a2134fab356f1f39b9499a89 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'omni_product_subcribe_svc')
	ALTER LOGIN [omni_product_subcribe_svc] WITH PASSWORD = 0x0200231dbc80065809600d55593283b7eed6a65097275fb8f7c9573db92dd32e16022be92fe8010e26d62c2009e6b091ca89d3b44736f2d2bd51b3a83dfb375c58b46609a60b HASHED
ELSE
	CREATE LOGIN [omni_product_subcribe_svc] WITH PASSWORD = 0x0200231dbc80065809600d55593283b7eed6a65097275fb8f7c9573db92dd32e16022be92fe8010e26d62c2009e6b091ca89d3b44736f2d2bd51b3a83dfb375c58b46609a60b HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'omni_resycn_product_svc')
	ALTER LOGIN [omni_resycn_product_svc] WITH PASSWORD = 0x0200fa9d2a7943ea5059acc0cd34b46325920de54b559c0cd8315677bad34589a504003c814acc6eec014762c71e10d166517dd893a5a18aad7ffea71f44df9aa0731896e704 HASHED
ELSE
	CREATE LOGIN [omni_resycn_product_svc] WITH PASSWORD = 0x0200fa9d2a7943ea5059acc0cd34b46325920de54b559c0cd8315677bad34589a504003c814acc6eec014762c71e10d166517dd893a5a18aad7ffea71f44df9aa0731896e704 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'omni_schedule_svc')
	ALTER LOGIN [omni_schedule_svc] WITH PASSWORD = 0x020082c8bf3e069fb8ab1a14436fdb09ca3e30bf62955759d4f974963bcdddd80aa387af0dee8d16ab90ec9f7bce21b20196402fe095b6785c661821681aea0c9fe1d1983ac9 HASHED
ELSE
	CREATE LOGIN [omni_schedule_svc] WITH PASSWORD = 0x020082c8bf3e069fb8ab1a14436fdb09ca3e30bf62955759d4f974963bcdddd80aa387af0dee8d16ab90ec9f7bce21b20196402fe095b6785c661821681aea0c9fe1d1983ac9 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'omni_shopee_item_name_svc')
	ALTER LOGIN [omni_shopee_item_name_svc] WITH PASSWORD = 0x0200b39b1e649f641e218759053d8f482a8f3ea1b9ce071437213ca743741b3dfde7155c05b855d0c4b3deb1e383f8840902e684d5bcea04707450683c9ea8b25620c73c3bb9 HASHED
ELSE
	CREATE LOGIN [omni_shopee_item_name_svc] WITH PASSWORD = 0x0200b39b1e649f641e218759053d8f482a8f3ea1b9ce071437213ca743741b3dfde7155c05b855d0c4b3deb1e383f8840902e684d5bcea04707450683c9ea8b25620c73c3bb9 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'omni_shopee_onhand_svc')
	ALTER LOGIN [omni_shopee_onhand_svc] WITH PASSWORD = 0x02004d7567e0596378420c7eda9913b86084d2682c46e4dec18acc758013a2d1ab01ef45359ae7535eb1c15835505884ccec2359f2b7033a6c20e8233016f59125f7baa20bc0 HASHED
ELSE
	CREATE LOGIN [omni_shopee_onhand_svc] WITH PASSWORD = 0x02004d7567e0596378420c7eda9913b86084d2682c46e4dec18acc758013a2d1ab01ef45359ae7535eb1c15835505884ccec2359f2b7033a6c20e8233016f59125f7baa20bc0 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'omni_shopee_order_svc')
	ALTER LOGIN [omni_shopee_order_svc] WITH PASSWORD = 0x02007e6b0d4ec11721410df6dd1635c8c259d8b725b0a8abbe60b203b3877f537400978691e79b2d7b3387cd36bdd92a250ff10eade9a37af77e4412c3a8c4bf4e144082cf11 HASHED
ELSE
	CREATE LOGIN [omni_shopee_order_svc] WITH PASSWORD = 0x02007e6b0d4ec11721410df6dd1635c8c259d8b725b0a8abbe60b203b3877f537400978691e79b2d7b3387cd36bdd92a250ff10eade9a37af77e4412c3a8c4bf4e144082cf11 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'omni_shopee_price_svc')
	ALTER LOGIN [omni_shopee_price_svc] WITH PASSWORD = 0x02004c2e8b43b5751c668acd8d035583ce732f5562752bee23fb14c4ca0e6fb0140b41dca67695bc927d4f9ec9cf42dfe853d9895ab41872f2bd25fb31bc670db3b1714b24d1 HASHED
ELSE
	CREATE LOGIN [omni_shopee_price_svc] WITH PASSWORD = 0x02004c2e8b43b5751c668acd8d035583ce732f5562752bee23fb14c4ca0e6fb0140b41dca67695bc927d4f9ec9cf42dfe853d9895ab41872f2bd25fb31bc670db3b1714b24d1 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'omni_tiki_onhand_svc')
	ALTER LOGIN [omni_tiki_onhand_svc] WITH PASSWORD = 0x0200392769288a35d0c53d5efbb9fb16d1cda0d35045da7b866b8909121782a0cf688f07ef89aec22df3107d014cd046bfe5daa41a394f7d505c211bea1e82c447be981febc0 HASHED
ELSE
	CREATE LOGIN [omni_tiki_onhand_svc] WITH PASSWORD = 0x0200392769288a35d0c53d5efbb9fb16d1cda0d35045da7b866b8909121782a0cf688f07ef89aec22df3107d014cd046bfe5daa41a394f7d505c211bea1e82c447be981febc0 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'omni_tiki_order_svc')
	ALTER LOGIN [omni_tiki_order_svc] WITH PASSWORD = 0x0200e8df9bce3ab1b28521e61e7cbca528762d32c2f803f3a914d3d45b3c38fd0b20d3dcc0aa941df094780c0a301f58fb94dbf6546e3d28f6bce1383a5af610973431c030c8 HASHED
ELSE
	CREATE LOGIN [omni_tiki_order_svc] WITH PASSWORD = 0x0200e8df9bce3ab1b28521e61e7cbca528762d32c2f803f3a914d3d45b3c38fd0b20d3dcc0aa941df094780c0a301f58fb94dbf6546e3d28f6bce1383a5af610973431c030c8 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'omni_tiki_price_svc')
	ALTER LOGIN [omni_tiki_price_svc] WITH PASSWORD = 0x020049a1917482d33a815eb6aefab3bdcdf9ea2162c903c97394ad5875de204eb81ec4d8299b122d0f8db835bd2dcff9148fc0374a5db81da36e7a10ff91a88f6a0f2a1d0d7c HASHED
ELSE
	CREATE LOGIN [omni_tiki_price_svc] WITH PASSWORD = 0x020049a1917482d33a815eb6aefab3bdcdf9ea2162c903c97394ad5875de204eb81ec4d8299b122d0f8db835bd2dcff9148fc0374a5db81da36e7a10ff91a88f6a0f2a1d0d7c HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF

USE [$(DatabaseName)]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'omni_channel_api' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'omni_channel_api', 'omni_channel_api';
ELSE
	BEGIN
		CREATE USER [omni_channel_api] FOR LOGIN [omni_channel_api];
		ALTER ROLE [db_owner] ADD MEMBER [omni_channel_api];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'omni_channel_core_api' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'omni_channel_core_api', 'omni_channel_core_api';
ELSE
	BEGIN
		CREATE USER [omni_channel_core_api] FOR LOGIN [omni_channel_core_api];
		ALTER ROLE [db_owner] ADD MEMBER [omni_channel_core_api];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'omni_lazada_onhand_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'omni_lazada_onhand_svc', 'omni_lazada_onhand_svc';
ELSE
	BEGIN
		CREATE USER [omni_lazada_onhand_svc] FOR LOGIN [omni_lazada_onhand_svc];
		ALTER ROLE [db_owner] ADD MEMBER [omni_lazada_onhand_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'omni_lazada_order_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'omni_lazada_order_svc', 'omni_lazada_order_svc';
ELSE
	BEGIN
		CREATE USER [omni_lazada_order_svc] FOR LOGIN [omni_lazada_order_svc];
		ALTER ROLE [db_owner] ADD MEMBER [omni_lazada_order_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'omni_lazada_price_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'omni_lazada_price_svc', 'omni_lazada_price_svc';
ELSE
	BEGIN
		CREATE USER [omni_lazada_price_svc] FOR LOGIN [omni_lazada_price_svc];
		ALTER ROLE [db_owner] ADD MEMBER [omni_lazada_price_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'omni_mapping_product_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'omni_mapping_product_svc', 'omni_mapping_product_svc';
ELSE
	BEGIN
		CREATE USER [omni_mapping_product_svc] FOR LOGIN [omni_mapping_product_svc];
		ALTER ROLE [db_owner] ADD MEMBER [omni_mapping_product_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'omni_product_subcribe_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'omni_product_subcribe_svc', 'omni_product_subcribe_svc';
ELSE
	BEGIN
		CREATE USER [omni_product_subcribe_svc] FOR LOGIN [omni_product_subcribe_svc];
		ALTER ROLE [db_owner] ADD MEMBER [omni_product_subcribe_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'omni_resycn_product_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'omni_resycn_product_svc', 'omni_resycn_product_svc';
ELSE
	BEGIN
		CREATE USER [omni_resycn_product_svc] FOR LOGIN [omni_resycn_product_svc];
		ALTER ROLE [db_owner] ADD MEMBER [omni_resycn_product_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'omni_schedule_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'omni_schedule_svc', 'omni_schedule_svc';
ELSE
	BEGIN
		CREATE USER [omni_schedule_svc] FOR LOGIN [omni_schedule_svc];
		ALTER ROLE [db_owner] ADD MEMBER [omni_schedule_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'omni_shopee_item_name_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'omni_shopee_item_name_svc', 'omni_shopee_item_name_svc';
ELSE
	BEGIN
		CREATE USER [omni_shopee_item_name_svc] FOR LOGIN [omni_shopee_item_name_svc];
		ALTER ROLE [db_owner] ADD MEMBER [omni_shopee_item_name_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'omni_shopee_onhand_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'omni_shopee_onhand_svc', 'omni_shopee_onhand_svc';
ELSE
	BEGIN
		CREATE USER [omni_shopee_onhand_svc] FOR LOGIN [omni_shopee_onhand_svc];
		ALTER ROLE [db_owner] ADD MEMBER [omni_shopee_onhand_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'omni_shopee_order_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'omni_shopee_order_svc', 'omni_shopee_order_svc';
ELSE
	BEGIN
		CREATE USER [omni_shopee_order_svc] FOR LOGIN [omni_shopee_order_svc];
		ALTER ROLE [db_owner] ADD MEMBER [omni_shopee_order_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'omni_shopee_price_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'omni_shopee_price_svc', 'omni_shopee_price_svc';
ELSE
	BEGIN
		CREATE USER [omni_shopee_price_svc] FOR LOGIN [omni_shopee_price_svc];
		ALTER ROLE [db_owner] ADD MEMBER [omni_shopee_price_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'omni_tiki_onhand_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'omni_tiki_onhand_svc', 'omni_tiki_onhand_svc';
ELSE
	BEGIN
		CREATE USER [omni_tiki_onhand_svc] FOR LOGIN [omni_tiki_onhand_svc];
		ALTER ROLE [db_owner] ADD MEMBER [omni_tiki_onhand_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'omni_tiki_order_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'omni_tiki_order_svc', 'omni_tiki_order_svc';
ELSE
	BEGIN
		CREATE USER [omni_tiki_order_svc] FOR LOGIN [omni_tiki_order_svc];
		ALTER ROLE [db_owner] ADD MEMBER [omni_tiki_order_svc];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'omni_tiki_price_svc' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'omni_tiki_price_svc', 'omni_tiki_price_svc';
ELSE
	BEGIN
		CREATE USER [omni_tiki_price_svc] FOR LOGIN [omni_tiki_price_svc];
		ALTER ROLE [db_owner] ADD MEMBER [omni_tiki_price_svc];
	END