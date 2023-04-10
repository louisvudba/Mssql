/*
- Scope: Zone 29
- Table Scan: ProductAttribute
(100 rows affected)
Table 'ProductAttribute'. Scan count 1, logical reads 1366300, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 16, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'ProductBranch'. Scan count 100, logical reads 403, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'PriceBookDetail'. Scan count 0, logical reads 300, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Product'. Scan count 15, logical reads 7773, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Category'. Scan count 1, logical reads 3, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'PriceBook'. Scan count 0, logical reads 2, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
- Ticket: https://workplace.citigo.com.vn/browse/KO-275
*/

SET STATISTICS IO ON
EXEC sp_executesql N'SELECT [Project2].[Id2] AS [Id],
       [Project2].[Id1] AS [Id1],
       [Project2].[ProductId2] AS [ProductId],
       [Project2].[BranchId] AS [BranchId],
       [Project2].[RetailerId1] AS [RetailerId],
       [Project2].[Id3] AS [Id2],
       [Project2].[CategoryId] AS [CategoryId],
       [Project2].[Description] AS [Description],
       [Project2].[isActive] AS [isActive],
       [Project2].[Name1] AS [Name],
       [Project2].[AllowsSale] AS [AllowsSale],
       [Project2].[ProductType] AS [ProductType],
       [Project2].[Name] AS [Name1],
       [Project2].[FullName] AS [FullName],
       [Project2].[ProductId] AS [ProductId1],
       [Project2].[C1] AS [C1],
       [Project2].[C2] AS [C2],
       [Project2].[Id] AS [Id3],
       [Project2].[C3] AS [C3],
       [Project2].[Code] AS [Code],
       [Project2].[C4] AS [C4],
       [Project2].[C5] AS [C5],
       [Project2].[C6] AS [C6],
       [Project2].[C7] AS [C7],
       [Project2].[C8] AS [C8],
       [Project2].[Unit] AS [Unit],
       [Project2].[MasterUnitId] AS [MasterUnitId],
       [Project2].[MasterProductId] AS [MasterProductId], 
       /*[Project2].[C9] AS [C9],
       [Project2].[AttributeId] AS [AttributeId],
       [Project2].[ProductId1] AS [ProductId2],
       [Project2].[Value] AS [Value],
       [Project2].[Id4] AS [Id4] ,*/
	   CASE
               WHEN ([Extent6].[RetailerId] IS NULL) THEN
                   CAST(NULL AS INT)
               ELSE
                   1
           END AS [C9],
	  [Extent6].[AttributeId] AS [AttributeId],
      [Extent6].[ProductId] AS [ProductId2],
	  [Extent6].[Value] AS [Value],
	  [Extent6].[Id] AS [Id4],
	  [Extent6].[RetailerId] AS [RetailerId]
      /*[Project2].[RetailerId] AS [RetailerId1]*/
FROM
(
    SELECT [Limit1].[Id] AS [Id],
           [Limit1].[ProductId] AS [ProductId],
           [Limit1].[Id1] AS [Id1],
           [Limit1].[Code] AS [Code],
           [Limit1].[Name] AS [Name],
           [Limit1].[CategoryId] AS [CategoryId],
           [Limit1].[Description] AS [Description],
           [Limit1].[AllowsSale] AS [AllowsSale],
           [Limit1].[isActive] AS [isActive],
           [Limit1].[ProductType] AS [ProductType],
           [Limit1].[MasterProductId] AS [MasterProductId],
           [Limit1].[Unit] AS [Unit],
           [Limit1].[MasterUnitId] AS [MasterUnitId],
           [Limit1].[FullName] AS [FullName],
           [Limit1].[Id2] AS [Id2],
           [Limit1].[Name1] AS [Name1],
           [Limit1].[Id3] AS [Id3],
           [Limit1].[C1] AS [C1],
           [Limit1].[C2] AS [C2],
           [Limit1].[C3] AS [C3],
           [Limit1].[C4] AS [C4],
           [Limit1].[C5] AS [C5],
           [Limit1].[C6] AS [C6],
           [Limit1].[C7] AS [C7],
           [Limit1].[C8] AS [C8],
          /* [Extent6].[Id] AS [Id4],
           [Extent6].[RetailerId] AS [RetailerId],
           [Extent6].[AttributeId] AS [AttributeId],
           [Extent6].[ProductId] AS [ProductId1],
           [Extent6].[Value] AS [Value],*/
           [Limit1].[ProductId1] AS [ProductId2],
           [Limit1].[BranchId] AS [BranchId],
           [Limit1].[RetailerId] AS [RetailerId1]
		 /*  ,
           CASE
               WHEN ([Extent6].[RetailerId] IS NULL) THEN
                   CAST(NULL AS INT)
               ELSE
                   1
           END AS [C9]*/
    FROM
    (
        SELECT [Project1].[Id] AS [Id],
               [Project1].[ProductId] AS [ProductId],
               [Project1].[Id1] AS [Id1],
               [Project1].[Code] AS [Code],
               [Project1].[Name] AS [Name],
               [Project1].[CategoryId] AS [CategoryId],
               [Project1].[Description] AS [Description],
               [Project1].[AllowsSale] AS [AllowsSale],
               [Project1].[isActive] AS [isActive],
               [Project1].[ProductType] AS [ProductType],
               [Project1].[MasterProductId] AS [MasterProductId],
               [Project1].[Unit] AS [Unit],
               [Project1].[MasterUnitId] AS [MasterUnitId],
               [Project1].[FullName] AS [FullName],
               [Project1].[Id2] AS [Id2],
               [Project1].[Name1] AS [Name1],
               [Project1].[Id3] AS [Id3],
               [Project1].[C1] AS [C1],
               [Project1].[C2] AS [C2],
               [Project1].[C3] AS [C3],
               [Project1].[C4] AS [C4],
               [Project1].[C5] AS [C5],
               [Project1].[C6] AS [C6],
               [Project1].[C7] AS [C7],
               [Project1].[C8] AS [C8],
               [Project1].[ProductId1] AS [ProductId1],
               [Project1].[BranchId] AS [BranchId],
               [Project1].[RetailerId] AS [RetailerId]
        FROM
        (
            SELECT [Extent1].[Id] AS [Id],
                   [Extent1].[ProductId] AS [ProductId],
                   [Extent2].[Id] AS [Id1],
                   [Extent2].[Code] AS [Code],
                   [Extent2].[Name] AS [Name],
                   [Extent2].[CategoryId] AS [CategoryId],
                   [Extent2].[Description] AS [Description],
                   [Extent2].[AllowsSale] AS [AllowsSale],
                   [Extent2].[isActive] AS [isActive],
                   [Extent2].[ProductType] AS [ProductType],
                   [Extent2].[MasterProductId] AS [MasterProductId],
                   [Extent2].[Unit] AS [Unit],
                   [Extent2].[MasterUnitId] AS [MasterUnitId],
                   [Extent2].[FullName] AS [FullName],
                   [Extent3].[Id] AS [Id2],
                   [Extent3].[Name] AS [Name1],
                   [Extent5].[Id] AS [Id3],
                   CASE
                       WHEN ([Extent2].[BasePrice] >= cast(0 AS DECIMAL(18))) THEN
                           [Extent2].[BasePrice]
                       ELSE
                           cast(0 AS DECIMAL(18))
                   END AS [C1],
                   CASE
                       WHEN (NOT (
                                     ([Extent4].[ProductId] IS NULL)
                                     AND ([Extent4].[BranchId] IS NULL)
                                     AND ([Extent4].[RetailerId] IS NULL)
                                 )
                            ) THEN
                           ROUND([Extent4].[Cost], @p__linq__5)
                       ELSE
                           cast(0 AS DECIMAL(18))
                   END AS [C2],
                   CASE
                       WHEN ([Extent4].[LatestPurchasePrice] IS NULL) THEN
                           cast(0 AS DECIMAL(18))
                       ELSE
                           [Extent4].[LatestPurchasePrice]
                   END AS [C3],
                   CASE
                       WHEN ([Extent4].[OnHand] IS NULL) THEN
                           cast(0 AS FLOAT(53))
                       ELSE
                           [Extent4].[OnHand]
                   END AS [C4],
                   CASE
                       WHEN ([Extent4].[Reserved] IS NULL) THEN
                           cast(0 AS FLOAT(53))
                       ELSE
                           [Extent4].[Reserved]
                   END AS [C5],
                   CASE
                       WHEN ([Extent4].[MinQuantity] IS NULL) THEN
                           cast(0 AS FLOAT(53))
                       ELSE
                           [Extent4].[MinQuantity]
                   END AS [C6],
                   CASE
                       WHEN ([Extent4].[MaxQuantity] IS NULL) THEN
                           cast(0 AS FLOAT(53))
                       ELSE
                           [Extent4].[MaxQuantity]
                   END AS [C7],
                   CASE
                       WHEN ([Extent1].[Price] >= cast(0 AS DECIMAL(18))) THEN
                           [Extent1].[Price]
                       ELSE
                           cast(0 AS DECIMAL(18))
                   END AS [C8],
                   [Extent4].[ProductId] AS [ProductId1],
                   [Extent4].[BranchId] AS [BranchId],
                   [Extent4].[RetailerId] AS [RetailerId]
            FROM [dbo].[PriceBookDetail] AS [Extent1]
                INNER JOIN [dbo].[Product] AS [Extent2]
                    ON [Extent1].[ProductId] = [Extent2].[Id]
                INNER JOIN [dbo].[Category] AS [Extent3]
                    ON [Extent2].[CategoryId] = [Extent3].[Id]
                LEFT OUTER JOIN [dbo].[ProductBranch] AS [Extent4]
                    ON ([Extent1].[ProductId] = [Extent4].[ProductId])
                       AND (@p__linq__0 = [Extent4].[BranchId])
                INNER JOIN [dbo].[PriceBook] AS [Extent5]
                    ON [Extent1].[PriceBookId] = [Extent5].[Id]
            WHERE ([Extent2].[isActive] = 1)
                  AND
                  (
                      ([Extent2].[isDeleted] IS NULL)
                      OR ([Extent2].[isDeleted] <> 1)
                  )
                  AND ([Extent2].[RetailerId] = @p__linq__1)
                  AND ([Extent3].[RetailerId] = @p__linq__2)
                  AND ([Extent1].[PriceBookId] = @p__linq__3)
                  AND ([Extent5].[RetailerId] = @p__linq__4)
                  AND ((CASE
                            WHEN ([Extent5].[isDeleted] IS NULL) THEN
                                cast(0 AS BIT)
                            ELSE
                                [Extent5].[isDeleted]
                        END
                       ) <> 1
                      )
        ) AS [Project1]
        ORDER BY [Project1].[C1] DESC OFFSET 0 ROWS FETCH NEXT 100 ROWS ONLY
    ) AS [Limit1]
        
) AS [Project2]
LEFT OUTER JOIN [dbo].[ProductAttribute] AS [Extent6] 
            ON [Project2].[Id1] = [Extent6].[ProductId]
ORDER BY [Project2].[C1] DESC,
         [Project2].[Id2] ASC,
         [Project2].[Id1] ASC,
         [Project2].[ProductId2] ASC,
         [Project2].[BranchId] ASC,
         [Project2].[RetailerId1] ASC,
         [Project2].[Id3] ASC,
         [Project2].[ProductId] ASC,
         [Project2].[Id] ASC'
,N'@p__linq__0 int,@p__linq__1 int,@p__linq__2 int,@p__linq__3 bigint,@p__linq__4 int,@p__linq__5 int'
,@p__linq__0=0,@p__linq__1=864834,@p__linq__2=864834,@p__linq__3=3301,@p__linq__4=864834,@p__linq__5=2