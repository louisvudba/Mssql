/*
<Database name="KiotVietShard20">
  <Locks>
    <Lock request_mode="S" request_status="GRANT" request_count="1" />
  </Locks>
  <Objects>
    <Object name="Invoice" schema_name="dbo">
      <Locks>
        <Lock resource_type="KEY" index_name="NCI-Invoice-RetID-BranchId-Status-PurDate" request_mode="S" request_status="GRANT" request_count="1" />
        <Lock resource_type="OBJECT" request_mode="IS" request_status="GRANT" request_count="1" />
        <Lock resource_type="PAGE" page_type="*" index_name="NCI-Invoice-RetID-BranchId-Status-PurDate" request_mode="IS" request_status="GRANT" request_count="1" />
      </Locks>
    </Object>
    <Object name="InvoiceDetail" schema_name="dbo">
      <Locks>
        <Lock resource_type="OBJECT" request_mode="S" request_status="GRANT" request_count="24" />
      </Locks>
    </Object>
    <Object name="InvoiceWarranty" schema_name="dbo">
      <Locks>
        <Lock resource_type="KEY" index_name="NCI-InvoiceId" request_mode="S" request_status="GRANT" request_count="1" />
        <Lock resource_type="OBJECT" request_mode="IS" request_status="GRANT" request_count="1" />
        <Lock resource_type="PAGE" page_type="*" index_name="NCI-InvoiceId" request_mode="IS" request_status="GRANT" request_count="1" />
      </Locks>
    </Object>
    <Object name="Product" schema_name="dbo">
      <Locks>
        <Lock resource_type="OBJECT" request_mode="IS" request_status="GRANT" request_count="1" />
      </Locks>
    </Object>
    <Object name="ProductBatchExpire" schema_name="dbo">
      <Locks>
        <Lock resource_type="OBJECT" request_mode="IS" request_status="GRANT" request_count="1" />
      </Locks>
    </Object>
  </Objects>
</Database>
*/


exec sp_executesql N'SELECT TOP (10)
       [Project2].[Id] AS [Id]
FROM
(
    SELECT [Project2].[Id] AS [Id],
           [Project2].[CreatedDate] AS [CreatedDate],
           ROW_NUMBER() OVER (ORDER BY [Project2].[CreatedDate] DESC) AS [row_number]
    FROM
    (
        SELECT [Distinct1].[Id] AS [Id],
               [Distinct1].[CreatedDate] AS [CreatedDate]
        FROM
        (
            SELECT DISTINCT
                   [Filter1].[Id1] AS [Id],
                   [Filter1].[InvoiceId1] AS [InvoiceId],
                   [Filter1].[Quantity] AS [Quantity],
                   [Filter1].[Price] AS [Price],
                   [Filter1].[Discount1] AS [Discount],
                   [Filter1].[CreatedDate1] AS [CreatedDate],
                   [Filter1].[Note] AS [Note],
                   [Filter1].[SerialNumbers] AS [SerialNumbers],
                   [Filter1].[ProductFormulaHistoryId] AS [ProductFormulaHistoryId],
                   [Filter1].[ProductBatchExpireId] AS [ProductBatchExpireId],
                   [Filter1].[Uuid1] AS [Uuid],
                   [Filter1].[CustomerId] AS [CustomerId],
                   [Filter1].[Id2] AS [Id1],
                   [Filter1].[ProductId1] AS [ProductId],
                   [Filter1].[RetailerId1] AS [RetailerId],
                   [Filter1].[BatchName] AS [BatchName],
                   [Filter1].[ExpireDate1] AS [ExpireDate],
                   [Filter1].[DisplayType] AS [DisplayType],
                   [Filter1].[CreatedDate2] AS [CreatedDate1],
                   [Filter1].[ModifiedDate1] AS [ModifiedDate],
                   [Filter1].[Revision] AS [Revision],
                   [Filter1].[FullName] AS [FullName],
                   [Filter1].[FullNameVirgule] AS [FullNameVirgule],
                   [Filter1].[BatchExpireId] AS [BatchExpireId],
                   CAST([Filter1].[BranchId] AS BIGINT) AS [C1],
                   [Filter1].[ProductId2] AS [ProductId1],
                   CASE
                       WHEN ([Filter1].[ProductQty] IS NULL) THEN
                           cast(1 AS FLOAT(53))
                       ELSE
                           [Filter1].[ProductQty]
                   END AS [C2]
            FROM
            (
                SELECT [Extent1].[Id] AS [Id1],
                       [Extent1].[InvoiceId] AS [InvoiceId1],
                       [Extent1].[Quantity] AS [Quantity],
                       [Extent1].[Price] AS [Price],
                       [Extent1].[Discount] AS [Discount1],
                       [Extent1].[CreatedDate] AS [CreatedDate1],
                       [Extent1].[Note] AS [Note],
                       [Extent1].[SerialNumbers] AS [SerialNumbers],
                       [Extent1].[ProductFormulaHistoryId] AS [ProductFormulaHistoryId],
                       [Extent1].[ProductBatchExpireId] AS [ProductBatchExpireId],
                       [Extent1].[Uuid] AS [Uuid1],
                       [Extent2].[RetailerId] AS [RetailerId2],
                       [Extent2].[BranchId] AS [BranchId],
                       [Extent2].[CustomerId] AS [CustomerId],
                       [Extent3].[Id] AS [Id2],
                       [Extent3].[ProductId] AS [ProductId1],
                       [Extent3].[RetailerId] AS [RetailerId1],
                       [Extent3].[BatchName] AS [BatchName],
                       [Extent3].[ExpireDate] AS [ExpireDate1],
                       [Extent3].[DisplayType] AS [DisplayType],
                       [Extent3].[CreatedDate] AS [CreatedDate2],
                       [Extent3].[ModifiedDate] AS [ModifiedDate1],
                       [Extent3].[Revision] AS [Revision],
                       [Extent3].[FullName] AS [FullName],
                       [Extent3].[FullNameVirgule] AS [FullNameVirgule],
                       [Extent3].[BatchExpireId] AS [BatchExpireId],
                       [Extent4].[ProductId] AS [ProductId2],
                       [Extent4].[ExpireDate] AS [ExpireDate2],
                       [Extent4].[ProductQty] AS [ProductQty]
                FROM [dbo].[InvoiceDetail] AS [Extent1]
                    INNER JOIN [dbo].[Invoice] AS [Extent2]
                        ON [Extent1].[InvoiceId] = [Extent2].[Id]
                    LEFT OUTER JOIN [dbo].[ProductBatchExpire] AS [Extent3]
                        ON [Extent1].[ProductBatchExpireId] = [Extent3].[Id]
                    INNER JOIN [dbo].[InvoiceWarranty] AS [Extent4]
                        ON ([Extent1].[InvoiceId] = [Extent4].[InvoiceId])
                           AND ([Extent4].[InvoiceDetailUuid] = [Extent1].[Uuid])
                WHERE (1 = [Extent1].[UseWarranty])
                      AND (NOT (
                                   (1 = [Extent1].[IsReturn])
                                   AND ([Extent1].[IsReturn] IS NOT NULL)
                               )
                          )
                      AND ([Extent2].[BranchId] IN ( 5423, 64680, 5423, 64680, 5423, 64680, 5423, 64680, 5423, 64680,
                                                     5423, 64680, 64680, 5423, 64680, 5423, 64680, 5423, 64680
                                                   )
                          )
                      AND (1 = CAST([Extent2].[Status] AS INT))
                      AND (NOT (
                                   (3 = [Extent4].[WarrantyType])
                                   AND ([Extent4].[WarrantyType] IS NOT NULL)
                               )
                          )
            ) AS [Filter1]
                INNER JOIN [dbo].[Product] AS [Extent5]
                    ON [Filter1].[ProductId2] = [Extent5].[Id]
            WHERE ([Filter1].[RetailerId2] = @p__linq__0)
                  AND ([Filter1].[ExpireDate2] >= @p__linq__1)
                  AND ([Extent5].[FullName] LIKE @p__linq__2 ESCAPE N''~'')   
        ) AS [Distinct1]
    ) AS [Project2]
) AS [Project2]
WHERE [Project2].[row_number] > 10
ORDER BY [Project2].[CreatedDate] DESC',N'@p__linq__0 int,@p__linq__1 datetime2(7),@p__linq__2 nvarchar(4000)',@p__linq__0=574244,@p__linq__1='2021-05-08 00:00:00',@p__linq__2=N'%IZI 280%'