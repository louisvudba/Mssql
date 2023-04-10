USE [master]
GO
/****** Object:  Database [FnBEventStoreTmp]    Script Date: 5/24/2021 3:32:49 PM ******/
CREATE DATABASE [FnBEventStoreTmp]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'FnBEventStoreTmp', FILENAME = N'E:\Database\FnBEventStoreTmp.mdf' , SIZE = 10MB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'FnBEventStoreTmp_log', FILENAME = N'F:\Database\FnBEventStoreTmp_log.ldf' , SIZE = 1MB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [FnBEventStoreTmp] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [FnBEventStoreTmp].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [FnBEventStoreTmp] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [FnBEventStoreTmp] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [FnBEventStoreTmp] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [FnBEventStoreTmp] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [FnBEventStoreTmp] SET ARITHABORT OFF 
GO
ALTER DATABASE [FnBEventStoreTmp] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [FnBEventStoreTmp] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [FnBEventStoreTmp] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [FnBEventStoreTmp] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [FnBEventStoreTmp] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [FnBEventStoreTmp] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [FnBEventStoreTmp] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [FnBEventStoreTmp] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [FnBEventStoreTmp] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [FnBEventStoreTmp] SET  DISABLE_BROKER 
GO
ALTER DATABASE [FnBEventStoreTmp] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [FnBEventStoreTmp] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [FnBEventStoreTmp] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [FnBEventStoreTmp] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [FnBEventStoreTmp] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [FnBEventStoreTmp] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [FnBEventStoreTmp] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [FnBEventStoreTmp] SET RECOVERY FULL 
GO
ALTER DATABASE [FnBEventStoreTmp] SET  MULTI_USER 
GO
ALTER DATABASE [FnBEventStoreTmp] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [FnBEventStoreTmp] SET DB_CHAINING OFF 
GO
ALTER DATABASE [FnBEventStoreTmp] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [FnBEventStoreTmp] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [FnBEventStoreTmp] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [FnBEventStoreTmp] SET QUERY_STORE = OFF
GO
USE [FnBEventStoreTmp]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [FnBEventStoreTmp]
GO
--/****** Object:  Table [dbo].[Events]    Script Date: 5/24/2021 3:32:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Events](
	[EventId] [uniqueidentifier] NOT NULL,
	[EventType] [nvarchar](max) NULL,
	[AggregateId] [uniqueidentifier] NOT NULL,
	[AggregateType] [nvarchar](50) NOT NULL,
	[RawData] [nvarchar](max) NOT NULL,
	[LocalTime] [bigint] NOT NULL,
	[OriginVersion] [bigint] NOT NULL,
	[LocalVersion] [bigint] NOT NULL,
	[TrackVersion] [bigint] NOT NULL,
	[TenantId] [int] NOT NULL,
	[BranchId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[ReplicaInfo] [nvarchar](500) NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Events] PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FrzeeAggregates]    Script Date: 5/24/2021 3:32:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FrzeeAggregates](
	[AggregateId] [uniqueidentifier] NOT NULL,
	[AggregateType] [nvarchar](50) NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_FrzeeAggregates] PRIMARY KEY CLUSTERED 
(
	[AggregateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NonClusteredIndex-AggregateId-AggregateType-TenantId-BranchId]    Script Date: 5/24/2021 3:32:50 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-AggregateId-AggregateType-TenantId-BranchId] ON [dbo].[Events]
(
	[LocalVersion] ASC,
	[OriginVersion] ASC,
	[AggregateId] ASC,
	[AggregateType] ASC,
	[TenantId] ASC,
	[BranchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [NonClusteredIndex-TenantId-BranchId-TrackVersion]    Script Date: 5/24/2021 3:32:50 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-TenantId-BranchId-TrackVersion] ON [dbo].[Events]
(
	[TenantId] ASC,
	[BranchId] ASC,
	[TrackVersion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UniqIndex-AggregateId-LocalVersion]    Script Date: 5/24/2021 3:32:50 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UniqIndex-AggregateId-LocalVersion] ON [dbo].[Events]
(
	[AggregateId] ASC,
	[LocalVersion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UniqIndex-AggregateId-TrackVersion]    Script Date: 5/24/2021 3:32:50 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UniqIndex-AggregateId-TrackVersion] ON [dbo].[Events]
(
	[AggregateId] ASC,
	[TrackVersion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [NonClusteredIndex-AggregateId-TenantId]    Script Date: 5/24/2021 3:32:50 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-AggregateId-TenantId] ON [dbo].[FrzeeAggregates]
(
	[AggregateId] ASC,
	[TenantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** STORED PROCEDURES ******/
CREATE PROCEDURE [dbo].[sp_clean_completed_events] 
AS
BEGIN	
    SET NOCOUNT ON;
	DECLARE @Deleted_Rows INT;
	SET @Deleted_Rows = 1;
	CREATE TABLE #deletingAggregate (
			AggregateId uniqueidentifier PRIMARY KEY
	)

	CleanCompletedEvent:
		 INSERT INTO #deletingAggregate
	     (
	        AggregateId
	     )
		SELECT TOP 500 e.AggregateId
		FROM dbo.Events e
		INNER JOIN dbo.FrzeeAggregates fa ON e.AggregateId = fa.AggregateId
		WHERE e.CreatedDate < dateadd(month,-2,GETDATE())
		GROUP BY e.AggregateId

		BEGIN TRANSACTION [Tran1];
		BEGIN TRY
				DELETE FROM dbo.Events
				WHERE AggregateId IN (SELECT AggregateId FROM #deletingAggregate da)

				DELETE FROM dbo.FrzeeAggregates
				WHERE AggregateId IN (SELECT AggregateId FROM #deletingAggregate da)
				 
				SET @Deleted_Rows = @@ROWCOUNT;				

				COMMIT TRANSACTION [Tran1];
				TRUNCATE TABLE #deletingAggregate;
		END TRY
		BEGIN CATCH
				ROLLBACK TRANSACTION [Tran1]				
				SET @Deleted_Rows = 0;
		END CATCH
		
	IF(@Deleted_Rows > 0) GOTO CleanCompletedEvent;
END
GO
CREATE PROCEDURE [dbo].[sp_get_insertable_events] 
    @json NVARCHAR(MAX)
AS
BEGIN
	-- @json must have structe follow below 
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
	/* data temp table */
	CREATE TABLE #datafnb  (
        [EventId] [UNIQUEIDENTIFIER] ,
        [EventType] [NVARCHAR](MAX),
        [AggregateId] [UNIQUEIDENTIFIER] ,
        [AggregateType] [NVARCHAR](50) ,
        [RawData] [NVARCHAR](MAX) ,
        [LocalTime] [BIGINT] ,
        [OriginVersion] [BIGINT] ,
        [LocalVersion] [BIGINT] ,
        [TrackVersion] [BIGINT] ,
        [TenantId] [INT] ,
        [BranchId] [INT] ,
        [UserId] [INT] ,
        [ReplicaInfo] [NVARCHAR](500),
        INDEX IX1 CLUSTERED([EventId])
    );
	INSERT #datafnb
	(
		EventId,
		EventType,
		AggregateId,
		AggregateType,
		RawData,
		LocalTime,
		OriginVersion,
		LocalVersion,
		TrackVersion,
		TenantId,
		BranchId,
		UserId,
		ReplicaInfo    
	)
	SELECT *
	FROM OPENJSON(@json)
	WITH (
        [EventId] [UNIQUEIDENTIFIER] ,
        [EventType] [NVARCHAR](MAX),
        [AggregateId] [UNIQUEIDENTIFIER] ,
        [AggregateType] [NVARCHAR](50) ,
        [RawData] [NVARCHAR](MAX) ,
        [LocalTime] [BIGINT] ,
        [OriginVersion] [BIGINT] ,
        [LocalVersion] [BIGINT] ,
        [TrackVersion] [BIGINT] ,
        [TenantId] [INT] ,
        [BranchId] [INT] ,
        [UserId] [INT] ,
        [ReplicaInfo] [NVARCHAR](500)
    )

    SELECT 
        d.EventId,
        d.EventType,
        d.AggregateId,
        d.AggregateType,
        d.RawData,
        d.LocalTime,
        d.OriginVersion,
        d.LocalVersion,
        d.TrackVersion,
        d.TenantId,
        d.BranchId,
        d.UserId,
        d.ReplicaInfo,
        GETDATE() AS CreatedDate
    FROM #datafnb AS d
    LEFT JOIN dbo.[Events] AS eo on d.EventId = eo.EventId
    WHERE eo.EventId IS NULL
END;
GO
CREATE PROCEDURE [dbo].[sp_replicate_events] 
    @json NVARCHAR(MAX)
AS
BEGIN
	-- @json must have structe follow below 
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
	/* data temp table */
	CREATE TABLE #datafnb  (
        [EventId] [UNIQUEIDENTIFIER] ,
        [EventType] [NVARCHAR](MAX),
        [AggregateId] [UNIQUEIDENTIFIER] ,
        [AggregateType] [NVARCHAR](50) ,
        [RawData] [NVARCHAR](MAX) ,
        [LocalTime] [BIGINT] ,
        [OriginVersion] [BIGINT] ,
        [LocalVersion] [BIGINT] ,
        [TrackVersion] [BIGINT] ,
        [TenantId] [INT] ,
        [BranchId] [INT] ,
        [UserId] [INT] ,
        [ReplicaInfo] [NVARCHAR](500),
        INDEX IX1 CLUSTERED([EventId])
    );
	INSERT #datafnb
	(
		EventId,
		EventType,
		AggregateId,
		AggregateType,
		RawData,
		LocalTime,
		OriginVersion,
		LocalVersion,
		TrackVersion,
		TenantId,
		BranchId,
		UserId,
		ReplicaInfo    
	)
	SELECT *
	FROM OPENJSON(@json)
	WITH (
        [EventId] [UNIQUEIDENTIFIER] ,
        [EventType] [NVARCHAR](MAX),
        [AggregateId] [UNIQUEIDENTIFIER] ,
        [AggregateType] [NVARCHAR](50) ,
        [RawData] [NVARCHAR](MAX) ,
        [LocalTime] [BIGINT] ,
        [OriginVersion] [BIGINT] ,
        [LocalVersion] [BIGINT] ,
        [TrackVersion] [BIGINT] ,
        [TenantId] [INT] ,
        [BranchId] [INT] ,
        [UserId] [INT] ,
        [ReplicaInfo] [NVARCHAR](500)
    )

	/* data need to be inserted temp table */
	CREATE TABLE #datafnbresult  (
        [EventId] [UNIQUEIDENTIFIER] ,
        [EventType] [NVARCHAR](MAX),
        [AggregateId] [UNIQUEIDENTIFIER] ,
        [AggregateType] [NVARCHAR](50) ,
        [RawData] [NVARCHAR](MAX) ,
        [LocalTime] [BIGINT] ,
        [OriginVersion] [BIGINT] ,
        [LocalVersion] [BIGINT] ,
        [TrackVersion] [BIGINT] ,
        [TenantId] [INT] ,
        [BranchId] [INT] ,
        [UserId] [INT] ,
        [ReplicaInfo] [NVARCHAR](500),
		[Rn] [BIGINT]
	);

    BEGIN TRANSACTION [Tran1];
    BEGIN TRY
		INSERT INTO #datafnbresult
		(
			EventId,
			EventType,
			AggregateId,
			AggregateType,
			RawData,
			LocalTime,
			OriginVersion,
			LocalVersion,
			TrackVersion,
			TenantId,
			BranchId,
			UserId,
			ReplicaInfo,
			Rn
		)
		SELECT 
            d.EventId,
            d.EventType,
            d.AggregateId,
            d.AggregateType,
            d.RawData,
            d.LocalTime,
            d.OriginVersion,
            d.LocalVersion,
            d.TrackVersion,
            d.TenantId,
            d.BranchId,
            d.UserId,
            d.ReplicaInfo,
			ROW_NUMBER() OVER ( ORDER BY d.TrackVersion ASC) Rn		
		FROM #datafnb AS d
		LEFT JOIN dbo.[Events] AS eo on d.EventId = eo.EventId
		WHERE eo.EventId IS NULL
		IF EXISTS (SELECT 1 FROM #datafnbresult AS d)
		BEGIN
            -- insert to table events
			INSERT INTO dbo.[Events]
			(
			    EventId,
			    EventType,
			    AggregateId,
			    AggregateType,
			    RawData,
			    LocalTime,
			    OriginVersion,
			    LocalVersion,
			    TrackVersion,
			    TenantId,
			    BranchId,
			    UserId,
			    ReplicaInfo,
				CreatedDate
			)
			SELECT
                EventId,
                EventType,
                AggregateId,
                AggregateType,
                RawData,
                LocalTime,
                OriginVersion,
                LocalVersion,
                TrackVersion,
                TenantId,
                BranchId,
                UserId,
                ReplicaInfo,
				DATEADD(millisecond, Rn * 100, GETDATE()) AS CreatedDate 
            FROM #datafnbresult
			ORDER BY TrackVersion ASC

            -- freeze orders
            INSERT INTO dbo.[FrzeeAggregates]
            (
                AggregateId,
                AggregateType,
                TenantId
            )
            SELECT 
                d.AggregateId AS AggregateId,
                d.AggregateType AS AggregateType,
                d.TenantId AS TenantId
            FROM
                #datafnbresult AS d
            LEFT JOIN dbo.[FrzeeAggregates] AS frz ON d.AggregateId = frz.AggregateId
            WHERE frz.AggregateType IS NULL AND (d.EventType = N'CompletedOrderEvent' OR d.EventType = N'CancelledOrderEvent')
			GROUP BY d.AggregateId, d.AggregateType, d.TenantId
		END
        COMMIT TRANSACTION [Tran1];

		SELECT 
			d.EventId,
			d.EventType,
			d.AggregateId,
			d.AggregateType,
			d.RawData,
			d.LocalTime,
			d.OriginVersion,
			d.LocalVersion,
			d.TrackVersion,
			d.TenantId,
			d.BranchId,
			d.UserId,
			d.ReplicaInfo
		FROM #datafnbresult AS d
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION [Tran1];
		THROW;
    END CATCH;
END;
GO
USE [master]
GO
ALTER DATABASE [FnBEventStoreTmp] SET  READ_WRITE 
GO
USE [FnBEventStoreTmp]
GO
EXEC sys.sp_cdc_enable_db
GO
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name = N'Events',
@role_name = NULL, -- Role
@filegroup_name = N'PRIMARY', -- Primary filegroup
@supports_net_changes = 0
GO
EXEC sys.sp_cdc_help_change_data_capture
GO