-- Zone 5
-- Block PriceBookDetail (lock escalation due to huge data)
exec sp_executesql N'SELECT [Distinct1].[C1] AS [C1],
       [Distinct1].[C2] AS [C2],
       [Distinct1].[C3] AS [C3],
       [Distinct1].[C4] AS [C4],
       [Distinct1].[C5] AS [C5],
       [Distinct1].[C6] AS [C6],
       [Distinct1].[C7] AS [C7],
       [Distinct1].[C8] AS [C8],
       [Distinct1].[C9] AS [C9]
FROM
(
    SELECT DISTINCT
           [UnionAll1].[Id] AS [C1],
           [UnionAll1].[PriceBookId] AS [C2],
           [UnionAll1].[ProductId] AS [C3],
           [UnionAll1].[Price] AS [C4],
           [UnionAll1].[CreatedDate] AS [C5],
           [UnionAll1].[ModifiedDate] AS [C6],
           [UnionAll1].[ModifiedBy] AS [C7],
           [UnionAll1].[Revision] AS [C8],
           [UnionAll1].[RetailerId] AS [C9]
    FROM
    (
        SELECT [Filter1].[Id1] AS [Id],
               [Filter1].[PriceBookId] AS [PriceBookId],
               [Filter1].[ProductId] AS [ProductId],
               [Filter1].[Price] AS [Price],
               [Filter1].[CreatedDate1] AS [CreatedDate],
               [Filter1].[ModifiedDate1] AS [ModifiedDate],
               [Filter1].[ModifiedBy1] AS [ModifiedBy],
               [Filter1].[Revision] AS [Revision],
               [Filter1].[RetailerId1] AS [RetailerId]
        FROM
        (
            SELECT [Extent1].[Id] AS [Id1],
                   [Extent1].[RetailerId] AS [RetailerId1],
                   [Extent1].[PriceBookId] AS [PriceBookId],
                   [Extent1].[ProductId] AS [ProductId],
                   [Extent1].[Price] AS [Price],
                   [Extent1].[CreatedDate] AS [CreatedDate1],
                   [Extent1].[ModifiedDate] AS [ModifiedDate1],
                   [Extent1].[ModifiedBy] AS [ModifiedBy1],
                   [Extent1].[Revision] AS [Revision],
                   [Extent2].[RetailerId] AS [RetailerId2]
            FROM [dbo].[PriceBookDetail] AS [Extent1]
                INNER JOIN [dbo].[PriceBook] AS [Extent2]
                    ON [Extent1].[PriceBookId] = [Extent2].[Id]
            WHERE ([Extent2].[StartDate] <= (SYSDATETIME()))
                  AND ([Extent2].[EndDate] >= (SYSDATETIME()))
                  AND ([Extent2].[IsActive] = 1)
                  AND ((CASE
                            WHEN ([Extent2].[isDeleted] IS NULL) THEN
                                cast(0 AS BIT)
                            ELSE
                                [Extent2].[isDeleted]
                        END
                       ) <> cast(1 AS BIT)
                      )
                  AND ([Extent2].[IsGlobal] = 1)
        ) AS [Filter1]
            INNER JOIN [dbo].[Product] AS [Extent3]
                ON [Filter1].[ProductId] = [Extent3].[Id]
        WHERE (@p__linq__0 IS NOT NULL)
              AND (@p__linq__1 IS NOT NULL)
              AND ([Filter1].[RetailerId2] = @p__linq__2)
              AND ([Extent3].[RetailerId] = @p__linq__3)
              AND
              (
                  ([Extent3].[isDeleted] IS NULL)
                  OR ([Extent3].[isDeleted] <> cast(1 AS BIT))
              )
        UNION ALL
        SELECT [Extent4].[Id] AS [Id],
               [Extent4].[PriceBookId] AS [PriceBookId],
               [Extent4].[ProductId] AS [ProductId],
               [Extent4].[Price] AS [Price],
               [Extent4].[CreatedDate] AS [CreatedDate],
               [Extent4].[ModifiedDate] AS [ModifiedDate],
               [Extent4].[ModifiedBy] AS [ModifiedBy],
               [Extent4].[Revision] AS [Revision],
               [Extent4].[RetailerId] AS [RetailerId]
        FROM [dbo].[PriceBookDetail] AS [Extent4]
            INNER JOIN [dbo].[PriceBook] AS [Extent5]
                ON [Extent4].[PriceBookId] = [Extent5].[Id]
            INNER JOIN [dbo].[PriceBookBranch] AS [Extent6]
                ON [Extent5].[Id] = [Extent6].[PriceBookId]
        WHERE ([Extent5].[StartDate] <= (SYSDATETIME()))
              AND ([Extent5].[EndDate] >= (SYSDATETIME()))
              AND ([Extent5].[IsActive] = 1)
              AND ((CASE
                        WHEN ([Extent5].[isDeleted] IS NULL) THEN
                            cast(0 AS BIT)
                        ELSE
                            [Extent5].[isDeleted]
                    END
                   ) <> cast(1 AS BIT)
                  )
              AND ([Extent5].[IsGlobal] <> cast(1 AS BIT))
              AND (@p__linq__4 IS NOT NULL)
              AND (@p__linq__5 IS NOT NULL)
              AND ([Extent5].[RetailerId] = @p__linq__6)
              AND ([Extent6].[BranchId] = @p__linq__7)
    ) AS [UnionAll1]
) AS [Distinct1]',N'@p__linq__0 nvarchar(4000),@p__linq__1 nvarchar(4000),@p__linq__2 int,@p__linq__3 int,@p__linq__4 nvarchar(4000),@p__linq__5 nvarchar(4000),@p__linq__6 int,@p__linq__7 int',@p__linq__0=N'TrackLinqTo:PriceBookApi.cs:line 947:Date 2021-05-05 14:49:44',@p__linq__1=N'TrackLinqTo:PriceBookApi.cs:line 947:Date 2021-05-05 14:49:44',@p__linq__2=184490,@p__linq__3=184490,@p__linq__4=N'TrackLinqTo:PriceBookApi.cs:line 947:Date 2021-05-05 14:49:44',@p__linq__5=N'TrackLinqTo:PriceBookApi.cs:line 947:Date 2021-05-05 14:49:44',@p__linq__6=184490,@p__linq__7=22235