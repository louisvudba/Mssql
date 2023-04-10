:connect VM-KV-DB1 -U replicator -P kiotviet@1
use [KiotVietYC1]
exec sp_dropsubscription @publication = N'KvPubKYC01', @article = N'Customer', @subscriber = N'all', @destination_db = N'all'
exec sp_droparticle @publication = N'KvPubKYC01', @article = N'Customer', @force_invalidate_snapshot = 1
TRUNCATE TABLE dbo.Customer
GO

:connect VM-KV-DBREP1 -U replicator -P kiotviet@1
use [KiotVietYC1]
TRUNCATE TABLE dbo.Customer
GO

:connect VM-KV-DBREP1-R3 -U replicator -P kiotviet@1
use [KiotVietYC1]
TRUNCATE TABLE dbo.Customer
GO

:connect VM-KV-DB1 -U replicator -P kiotviet@1
use [KiotVietYC1]
exec sp_addarticle @publication = N'KvPubKYC01', @article = N'Customer', @source_owner = N'dbo', @source_object = N'Customer', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Customer', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboCustomer]', @del_cmd = N'CALL [sp_MSdel_dboCustomer]', @upd_cmd = N'SCALL [sp_MSupd_dboCustomer]'
GO
