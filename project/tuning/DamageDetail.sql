DECLARE @p__linq__0 int
SELECT 
    [GroupBy2].[A1] AS [C1]
    FROM ( SELECT 
        SUM([Filter1].[A1]) AS [A1]
        FROM ( SELECT 
            (SELECT 
                SUM([Extent2].[Quantity]) AS [A1]
                FROM [dbo].[DamageDetail] AS [Extent2]
                WHERE [Extent1].[Id] = [Extent2].[DamageId]) AS [A1]
            FROM [dbo].[DamageItem] AS [Extent1]
            WHERE ([Extent1].[RetailerId] = @p__linq__0) AND ([Extent1].[BranchId] IN (52347, 52347, 52347)) AND (52347 = [Extent1].[BranchId]) AND ([Extent1].[TransDate] &gt;= convert(datetime2, '2021-04-01 00:00:00.0000000', 121)) AND ([Extent1].[TransDate] &lt; convert(datetime2, '2021-04-29 00:00:00.0000000', 121)) AND ([Extent1].[Status] IN (1,2))
        )  AS [Filter1]
    )  AS [GroupBy2]

/*
    Scan on DamageDetail - no index on DamageId
*/