USE [master]
GO
GO
IF OBJECT_ID('dbo.sp_getbackupinfo') IS NULL
  EXEC ('CREATE PROCEDURE dbo.sp_getbackupinfo AS RETURN 0;');
GO
ALTER PROCEDURE sp_getbackupinfo 
    @FileName NVARCHAR(500) = ''
AS
BEGIN
    DECLARE @BackupHeader TABLE
    (
        BackupName NVARCHAR(128),
        BackupDescription NVARCHAR(255),
        BackupType SMALLINT,
        ExpirationDate DATETIME,
        Compressed TINYINT,
        Position SMALLINT,
        DeviceType TINYINT,
        UserName NVARCHAR(128),
        ServerName NVARCHAR(128),
        DatabaseName NVARCHAR(128),
        DatabaseVersion INT,
        DatabaseCreationDate DATETIME,
        BackupSize NUMERIC(20, 0),
        FirstLSN NUMERIC(25, 0),
        LastLSN NUMERIC(25, 0),
        CheckpointLSN NUMERIC(25, 0),
        DatabaseBackupLSN NUMERIC(25, 0),
        BackupStartDate DATETIME,
        BackupFinishDate DATETIME,
        SortOrder SMALLINT,
        CodePage SMALLINT,
        UnicodeLocaleId INT,
        UnicodeComparisonStyle INT,
        CompatibilityLevel TINYINT,
        SoftwareVendorId INT,
        SoftwareVersionMajor INT,
        SoftwareVersionMinor INT,
        SoftwareVersionBuild INT,
        MachineName NVARCHAR(128),
        Flags INT,
        BindingID UNIQUEIDENTIFIER,
        RecoveryForkID UNIQUEIDENTIFIER,
        --following columns introduced in SQL 2008
        Collation NVARCHAR(128),
        FamilyGUID UNIQUEIDENTIFIER,
        HasBulkLoggedData BIT,
        IsSnapshot BIT,
        IsReadOnly BIT,
        IsSingleUser BIT,
        HasBackupChecksums BIT,
        IsDamaged BIT,
        BeginsLogChain BIT,
        HasIncompleteMetaData BIT,
        IsForceOffline BIT,
        IsCopyOnly BIT,
        FirstRecoveryForkID UNIQUEIDENTIFIER,
        ForkPointLSN NUMERIC(25, 0),
        RecoveryModel NVARCHAR(60),
        DifferentialBaseLSN NUMERIC(25, 0),
        DifferentialBaseGUID UNIQUEIDENTIFIER,
        BackupTypeDescription NVARCHAR(60),
        BackupSetGUID UNIQUEIDENTIFIER NULL,
        CompressedBackupSize BIGINT,
        --following columns introduced in SQL 2012
        Containment TINYINT,
        --following columns introduced in SQL 2014
        KeyAlgorithm NVARCHAR(32),
        EncryptorThumbprint VARBINARY(20),
        EncryptorType NVARCHAR(32)
    );

    INSERT INTO @BackupHeader
	EXEC ('RESTORE HEADERONLY FROM DISK=''''' + @FileName + '''');

    SELECT * FROM @BackupHeader
END