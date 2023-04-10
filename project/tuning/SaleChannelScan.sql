/*
    Scan on SaleChannel, OrderDetail, OrderPromotion
*/


DECLARE @p__linq__0 int,@p__linq__1 int
SELECT 
    [UnionAll2].[C2] AS [C1], 
    [UnionAll2].[C3] AS [C2], 
    [UnionAll2].[C4] AS [C3], 
    [UnionAll2].[C5] AS [C4], 
    [UnionAll2].[C6] AS [C5], 
    [UnionAll2].[C7] AS [C6], 
    [UnionAll2].[C8] AS [C7], 
    [UnionAll2].[C9] AS [C8], 
    [UnionAll2].[C10] AS [C9], 
    [UnionAll2].[C11] AS [C10], 
    [UnionAll2].[C12] AS [C11], 
    [UnionAll2].[C13] AS [C12], 
    [UnionAll2].[C14] AS [C13], 
    [UnionAll2].[C15] AS [C14], 
    [UnionAll2].[C16] AS [C15], 
    [UnionAll2].[C17] AS [C16], 
    [UnionAll2].[C18] AS [C17], 
    [UnionAll2].[C19] AS [C18], 
    [UnionAll2].[C20] AS [C19], 
    [UnionAll2].[C21] AS [C20], 
    [UnionAll2].[C22] AS [C21], 
    [UnionAll2].[C23] AS [C22], 
    [UnionAll2].[C24] AS [C23], 
    [UnionAll2].[C25] AS [C24], 
    [UnionAll2].[C26] AS [C25], 
    [UnionAll2].[C27] AS [C26], 
    [UnionAll2].[C28] AS [C27], 
    [UnionAll2].[C29] AS [C28], 
    [UnionAll2].[C30] AS [C29], 
    [UnionAll2].[C31] AS [C30], 
    [UnionAll2].[C32] AS [C31], 
    [UnionAll2].[C33] AS [C32], 
    [UnionAll2].[C34] AS [C33], 
    [UnionAll2].[C35] AS [C34], 
    [UnionAll2].[C36] AS [C35], 
    [UnionAll2].[C37] AS [C36], 
    [UnionAll2].[C38] AS [C37], 
    [UnionAll2].[C39] AS [C38], 
    [UnionAll2].[C40] AS [C39], 
    [UnionAll2].[C41] AS [C40], 
    [UnionAll2].[C42] AS [C41], 
    [UnionAll2].[C43] AS [C42], 
    [UnionAll2].[C44] AS [C43], 
    [UnionAll2].[C1] AS [C44], 
    [UnionAll2].[C45] AS [C45], 
    [UnionAll2].[C46] AS [C46], 
    [UnionAll2].[C47] AS [C47], 
    [UnionAll2].[C48] AS [C48], 
    [UnionAll2].[C49] AS [C49], 
    [UnionAll2].[C50] AS [C50], 
    [UnionAll2].[C51] AS [C51], 
    [UnionAll2].[C52] AS [C52], 
    [UnionAll2].[C53] AS [C53], 
    [UnionAll2].[C54] AS [C54], 
    [UnionAll2].[C55] AS [C55], 
    [UnionAll2].[C56] AS [C56], 
    [UnionAll2].[C57] AS [C57], 
    [UnionAll2].[C58] AS [C58], 
    [UnionAll2].[C59] AS [C59], 
    [UnionAll2].[C60] AS [C60], 
    [UnionAll2].[C61] AS [C61], 
    [UnionAll2].[C62] AS [C62], 
    [UnionAll2].[C63] AS [C63], 
    [UnionAll2].[C64] AS [C64], 
    [UnionAll2].[C65] AS [C65], 
    [UnionAll2].[C66] AS [C66], 
    [UnionAll2].[C67] AS [C67], 
    [UnionAll2].[C68] AS [C68], 
    [UnionAll2].[C69] AS [C69], 
    [UnionAll2].[C70] AS [C70], 
    [UnionAll2].[C71] AS [C71], 
    [UnionAll2].[C72] AS [C72], 
    [UnionAll2].[C73] AS [C73], 
    [UnionAll2].[C74] AS [C74], 
    [UnionAll2].[C75] AS [C75], 
    [UnionAll2].[C76] AS [C76], 
    [UnionAll2].[C77] AS [C77], 
    [UnionAll2].[C78] AS [C78], 
    [UnionAll2].[C79] AS [C79], 
    [UnionAll2].[C80] AS [C80], 
    [UnionAll2].[C81] AS [C81], 
    [UnionAll2].[C82] AS [C82], 
    [UnionAll2].[C83] AS [C83], 
    [UnionAll2].[C84] AS [C84], 
    [UnionAll2].[C85] AS [C85], 
    [UnionAll2].[C86] AS [C86], 
    [UnionAll2].[C87] AS [C87], 
    [UnionAll2].[C88] AS [C88], 
    [UnionAll2].[C89] AS [C89], 
    [UnionAll2].[C90] AS [C90], 
    [UnionAll2].[C91] AS [C91], 
    [UnionAll2].[C92] AS [C92], 
    [UnionAll2].[C93] AS [C93], 
    [UnionAll2].[C94] AS [C94], 
    [UnionAll2].[C95] AS [C95], 
    [UnionAll2].[C96] AS [C96], 
    [UnionAll2].[C97] AS [C97], 
    [UnionAll2].[C98] AS [C98], 
    [UnionAll2].[C99] AS [C99], 
    [UnionAll2].[C100] AS [C100], 
    [UnionAll2].[C101] AS [C101], 
    [UnionAll2].[C102] AS [C102]
    FROM  (SELECT 
        [UnionAll1].[C1] AS [C1], 
        [UnionAll1].[BranchId] AS [C2], 
        [UnionAll1].[Id] AS [C3], 
        [UnionAll1].[CustomerId] AS [C4], 
        [UnionAll1].[CashierId] AS [C5], 
        [UnionAll1].[PurchaseDate] AS [C6], 
        [UnionAll1].[Code] AS [C7], 
        [UnionAll1].[PaymentType] AS [C8], 
        [UnionAll1].[BranchId1] AS [C9], 
        [UnionAll1].[Description] AS [C10], 
        [UnionAll1].[Status] AS [C11], 
        [UnionAll1].[ModifiedDate] AS [C12], 
        [UnionAll1].[RetailerId] AS [C13], 
        [UnionAll1].[Discount] AS [C14], 
        [UnionAll1].[SoldById] AS [C15], 
        [UnionAll1].[TableId] AS [C16], 
        [UnionAll1].[CreatedDate] AS [C17], 
        [UnionAll1].[CreatedBy] AS [C18], 
        [UnionAll1].[ModifiedBy] AS [C19], 
        [UnionAll1].[DiscountRatio] AS [C20], 
        [UnionAll1].[Extra] AS [C21], 
        [UnionAll1].[EndPurchaseDate] AS [C22], 
        [UnionAll1].[BookingTitle] AS [C23], 
        [UnionAll1].[Total] AS [C24], 
        [UnionAll1].[TotalPayment] AS [C25], 
        [UnionAll1].[UsingCod] AS [C26], 
        [UnionAll1].[Surcharge] AS [C27], 
        [UnionAll1].[Point] AS [C28], 
        [UnionAll1].[Uuid] AS [C29], 
        [UnionAll1].[SaleChannelId] AS [C30], 
        [UnionAll1].[IsFavourite] AS [C31], 
        [UnionAll1].[Id1] AS [C32], 
        [UnionAll1].[CreatedDate1] AS [C33], 
        [UnionAll1].[CreatedBy1] AS [C34], 
        [UnionAll1].[ModifiedDate1] AS [C35], 
        [UnionAll1].[ModifiedBy1] AS [C36], 
        [UnionAll1].[Name] AS [C37], 
        [UnionAll1].[Description1] AS [C38], 
        [UnionAll1].[IsActive] AS [C39], 
        [UnionAll1].[Position] AS [C40], 
        [UnionAll1].[RetailerId1] AS [C41], 
        [UnionAll1].[Img] AS [C42], 
        [UnionAll1].[IsNotDelete] AS [C43], 
        [UnionAll1].[OmniChannelId] AS [C44], 
        [UnionAll1].[Id2] AS [C45], 
        [UnionAll1].[OrderId] AS [C46], 
        [UnionAll1].[ProductId] AS [C47], 
        [UnionAll1].[Quantity] AS [C48], 
        [UnionAll1].[Price] AS [C49], 
        [UnionAll1].[Discount1] AS [C50], 
        [UnionAll1].[CreatedDate2] AS [C51], 
        [UnionAll1].[DiscountRatio1] AS [C52], 
        [UnionAll1].[Delivery] AS [C53], 
        [UnionAll1].[Note] AS [C54], 
        [UnionAll1].[ProcessingQty] AS [C55], 
        [UnionAll1].[DeliveryQty] AS [C56], 
        [UnionAll1].[LatestUpdate] AS [C57], 
        [UnionAll1].[SerialNumbers] AS [C58], 
        [UnionAll1].[IsMaster] AS [C59], 
        [UnionAll1].[SalePromotionId] AS [C60], 
        [UnionAll1].[Uuid1] AS [C61], 
        [UnionAll1].[ProductFormulaHistoryId] AS [C62], 
        [UnionAll1].[UseWarranty] AS [C63], 
        [UnionAll1].[ProductBatchExpireId] AS [C64], 
        [UnionAll1].[ViewDiscount] AS [C65], 
        [UnionAll1].[CoConditionGiftPoint] AS [C66], 
        [UnionAll1].[RetailerId2] AS [C67], 
        [UnionAll1].[C2] AS [C68], 
        [UnionAll1].[C3] AS [C69], 
        [UnionAll1].[C4] AS [C70], 
        [UnionAll1].[C5] AS [C71], 
        [UnionAll1].[C6] AS [C72], 
        [UnionAll1].[C7] AS [C73], 
        [UnionAll1].[C8] AS [C74], 
        [UnionAll1].[C9] AS [C75], 
        [UnionAll1].[C10] AS [C76], 
        [UnionAll1].[C11] AS [C77], 
        [UnionAll1].[C12] AS [C78], 
        [UnionAll1].[C13] AS [C79], 
        [UnionAll1].[C14] AS [C80], 
        [UnionAll1].[C15] AS [C81], 
        [UnionAll1].[C16] AS [C82], 
        [UnionAll1].[C17] AS [C83], 
        [UnionAll1].[C18] AS [C84], 
        [UnionAll1].[C19] AS [C85], 
        [UnionAll1].[C20] AS [C86], 
        [UnionAll1].[C21] AS [C87], 
        [UnionAll1].[C22] AS [C88], 
        [UnionAll1].[C23] AS [C89], 
        [UnionAll1].[C24] AS [C90], 
        [UnionAll1].[C25] AS [C91], 
        [UnionAll1].[C26] AS [C92], 
        [UnionAll1].[C27] AS [C93], 
        [UnionAll1].[C28] AS [C94], 
        [UnionAll1].[C29] AS [C95], 
        [UnionAll1].[C30] AS [C96], 
        [UnionAll1].[C31] AS [C97], 
        [UnionAll1].[C32] AS [C98], 
        [UnionAll1].[C33] AS [C99], 
        [UnionAll1].[C34] AS [C100], 
        [UnionAll1].[C35] AS [C101], 
        [UnionAll1].[C36] AS [C102]
        FROM  (SELECT 
            CASE WHEN ([Extent3].[RetailerId] IS NULL) THEN CAST(NULL AS int) ELSE 1 END AS [C1], 
            [Extent1].[BranchId] AS [BranchId], 
            [Extent1].[Id] AS [Id], 
            [Extent1].[CustomerId] AS [CustomerId], 
            [Extent1].[CashierId] AS [CashierId], 
            [Extent1].[PurchaseDate] AS [PurchaseDate], 
            [Extent1].[Code] AS [Code], 
            [Extent1].[PaymentType] AS [PaymentType], 
            [Extent1].[BranchId] AS [BranchId1], 
            [Extent1].[Description] AS [Description], 
            [Extent1].[Status] AS [Status], 
            [Extent1].[ModifiedDate] AS [ModifiedDate], 
            [Extent1].[RetailerId] AS [RetailerId], 
            [Extent1].[Discount] AS [Discount], 
            [Extent1].[SoldById] AS [SoldById], 
            [Extent1].[TableId] AS [TableId], 
            [Extent1].[CreatedDate] AS [CreatedDate], 
            [Extent1].[CreatedBy] AS [CreatedBy], 
            [Extent1].[ModifiedBy] AS [ModifiedBy], 
            [Extent1].[DiscountRatio] AS [DiscountRatio], 
            [Extent1].[Extra] AS [Extra], 
            [Extent1].[EndPurchaseDate] AS [EndPurchaseDate], 
            [Extent1].[BookingTitle] AS [BookingTitle], 
            [Extent1].[Total] AS [Total], 
            [Extent1].[TotalPayment] AS [TotalPayment], 
            [Extent1].[UsingCod] AS [UsingCod], 
            [Extent1].[Surcharge] AS [Surcharge], 
            [Extent1].[Point] AS [Point], 
            [Extent1].[Uuid] AS [Uuid], 
            [Extent1].[SaleChannelId] AS [SaleChannelId], 
            [Extent1].[IsFavourite] AS [IsFavourite], 
            [Extent2].[Id] AS [Id1], 
            [Extent2].[CreatedDate] AS [CreatedDate1], 
            [Extent2].[CreatedBy] AS [CreatedBy1], 
            [Extent2].[ModifiedDate] AS [ModifiedDate1], 
            [Extent2].[ModifiedBy] AS [ModifiedBy1], 
            [Extent2].[Name] AS [Name], 
            [Extent2].[Description] AS [Description1], 
            [Extent2].[IsActive] AS [IsActive], 
            [Extent2].[Position] AS [Position], 
            [Extent2].[RetailerId] AS [RetailerId1], 
            [Extent2].[Img] AS [Img], 
            [Extent2].[IsNotDelete] AS [IsNotDelete], 
            [Extent2].[OmniChannelId] AS [OmniChannelId], 
            [Extent3].[Id] AS [Id2], 
            [Extent3].[OrderId] AS [OrderId], 
            [Extent3].[ProductId] AS [ProductId], 
            [Extent3].[Quantity] AS [Quantity], 
            [Extent3].[Price] AS [Price], 
            [Extent3].[Discount] AS [Discount1], 
            [Extent3].[CreatedDate] AS [CreatedDate2], 
            [Extent3].[DiscountRatio] AS [DiscountRatio1], 
            [Extent3].[Delivery] AS [Delivery], 
            [Extent3].[Note] AS [Note], 
            [Extent3].[ProcessingQty] AS [ProcessingQty], 
            [Extent3].[DeliveryQty] AS [DeliveryQty], 
            [Extent3].[LatestUpdate] AS [LatestUpdate], 
            [Extent3].[SerialNumbers] AS [SerialNumbers], 
            [Extent3].[IsMaster] AS [IsMaster], 
            [Extent3].[SalePromotionId] AS [SalePromotionId], 
            [Extent3].[Uuid] AS [Uuid1], 
            [Extent3].[ProductFormulaHistoryId] AS [ProductFormulaHistoryId], 
            [Extent3].[UseWarranty] AS [UseWarranty], 
            [Extent3].[ProductBatchExpireId] AS [ProductBatchExpireId], 
            [Extent3].[ViewDiscount] AS [ViewDiscount], 
            [Extent3].[CoConditionGiftPoint] AS [CoConditionGiftPoint], 
            [Extent3].[RetailerId] AS [RetailerId2], 
            CAST(NULL AS bigint) AS [C2], 
            CAST(NULL AS bigint) AS [C3], 
            CAST(NULL AS bigint) AS [C4], 
            CAST(NULL AS int) AS [C5], 
            CAST(NULL AS decimal(19,4)) AS [C6], 
            CAST(NULL AS float) AS [C7], 
            CAST(NULL AS decimal(19,4)) AS [C8], 
            CAST(NULL AS datetime2) AS [C9], 
            CAST(NULL AS bigint) AS [C10], 
            CAST(NULL AS int) AS [C11], 
            CAST(NULL AS bigint) AS [C12], 
            CAST(NULL AS bigint) AS [C13], 
            CAST(NULL AS bigint) AS [C14], 
            CAST(NULL AS varchar(1)) AS [C15], 
            CAST(NULL AS varchar(1)) AS [C16], 
            CAST(NULL AS varchar(1)) AS [C17], 
            CAST(NULL AS int) AS [C18], 
            CAST(NULL AS int) AS [C19], 
            CAST(NULL AS varchar(1)) AS [C20], 
            CAST(NULL AS int) AS [C21], 
            CAST(NULL AS bigint) AS [C22], 
            CAST(NULL AS float) AS [C23], 
            CAST(NULL AS float) AS [C24], 
            CAST(NULL AS decimal(19,4)) AS [C25], 
            CAST(NULL AS float) AS [C26], 
            CAST(NULL AS int) AS [C27], 
            CAST(NULL AS bigint) AS [C28], 
            CAST(NULL AS float) AS [C29], 
            CAST(NULL AS decimal(19,4)) AS [C30], 
            CAST(NULL AS varchar(1)) AS [C31], 
            CAST(NULL AS varchar(1)) AS [C32], 
            CAST(NULL AS varchar(1)) AS [C33], 
            CAST(NULL AS varchar(1)) AS [C34], 
            CAST(NULL AS varchar(1)) AS [C35], 
            CAST(NULL AS int) AS [C36]
            FROM   [dbo].[Order] AS [Extent1]
            LEFT OUTER JOIN [dbo].[SaleChannel] AS [Extent2] ON [Extent1].[SaleChannelId] = [Extent2].[Id]
            LEFT OUTER JOIN [dbo].[OrderDetail] AS [Extent3] ON [Extent1].[Id] = [Extent3].[OrderId]
            WHERE ([Extent1].[RetailerId] = @p__linq__0) AND ([Extent1].[BranchId] IN (48725, 48725, 48725, 48725, 48725)) AND ([Extent1].[Status] IN (1,5,2)) AND ([Extent1].[BranchId] = @p__linq__1)
        UNION ALL
            SELECT 
            2 AS [C1], 
            [Extent4].[BranchId] AS [BranchId], 
            [Extent4].[Id] AS [Id], 
            [Extent4].[CustomerId] AS [CustomerId], 
            [Extent4].[CashierId] AS [CashierId], 
            [Extent4].[PurchaseDate] AS [PurchaseDate], 
            [Extent4].[Code] AS [Code], 
            [Extent4].[PaymentType] AS [PaymentType], 
            [Extent4].[BranchId] AS [BranchId1], 
            [Extent4].[Description] AS [Description], 
            [Extent4].[Status] AS [Status], 
            [Extent4].[ModifiedDate] AS [ModifiedDate], 
            [Extent4].[RetailerId] AS [RetailerId], 
            [Extent4].[Discount] AS [Discount], 
            [Extent4].[SoldById] AS [SoldById], 
            [Extent4].[TableId] AS [TableId], 
            [Extent4].[CreatedDate] AS [CreatedDate], 
            [Extent4].[CreatedBy] AS [CreatedBy], 
            [Extent4].[ModifiedBy] AS [ModifiedBy], 
            [Extent4].[DiscountRatio] AS [DiscountRatio], 
            [Extent4].[Extra] AS [Extra], 
            [Extent4].[EndPurchaseDate] AS [EndPurchaseDate], 
            [Extent4].[BookingTitle] AS [BookingTitle], 
            [Extent4].[Total] AS [Total], 
            [Extent4].[TotalPayment] AS [TotalPayment], 
            [Extent4].[UsingCod] AS [UsingCod], 
            [Extent4].[Surcharge] AS [Surcharge], 
            [Extent4].[Point] AS [Point], 
            [Extent4].[Uuid] AS [Uuid], 
            [Extent4].[SaleChannelId] AS [SaleChannelId], 
            [Extent4].[IsFavourite] AS [IsFavourite], 
            [Extent5].[Id] AS [Id1], 
            [Extent5].[CreatedDate] AS [CreatedDate1], 
            [Extent5].[CreatedBy] AS [CreatedBy1], 
            [Extent5].[ModifiedDate] AS [ModifiedDate1], 
            [Extent5].[ModifiedBy] AS [ModifiedBy1], 
            [Extent5].[Name] AS [Name], 
            [Extent5].[Description] AS [Description1], 
            [Extent5].[IsActive] AS [IsActive], 
            [Extent5].[Position] AS [Position], 
            [Extent5].[RetailerId] AS [RetailerId1], 
            [Extent5].[Img] AS [Img], 
            [Extent5].[IsNotDelete] AS [IsNotDelete], 
            [Extent5].[OmniChannelId] AS [OmniChannelId], 
            CAST(NULL AS bigint) AS [C2], 
            CAST(NULL AS bigint) AS [C3], 
            CAST(NULL AS bigint) AS [C4], 
            CAST(NULL AS float) AS [C5], 
            CAST(NULL AS decimal(19,4)) AS [C6], 
            CAST(NULL AS decimal(19,4)) AS [C7], 
            CAST(NULL AS datetime2) AS [C8], 
            CAST(NULL AS float) AS [C9], 
            CAST(NULL AS varchar(1)) AS [C10], 
            CAST(NULL AS varchar(1)) AS [C11], 
            CAST(NULL AS float) AS [C12], 
            CAST(NULL AS float) AS [C13], 
            CAST(NULL AS datetime2) AS [C14], 
            CAST(NULL AS varchar(1)) AS [C15], 
            CAST(NULL AS bit) AS [C16], 
            CAST(NULL AS int) AS [C17], 
            CAST(NULL AS varchar(1)) AS [C18], 
            CAST(NULL AS int) AS [C19], 
            CAST(NULL AS bit) AS [C20], 
            CAST(NULL AS bigint) AS [C21], 
            CAST(NULL AS decimal(19,4)) AS [C22], 
            CAST(NULL AS bit) AS [C23], 
            CAST(NULL AS int) AS [C24], 
            [Extent6].[Id] AS [Id2], 
            [Extent6].[InvoiceId] AS [InvoiceId], 
            [Extent6].[OrderId] AS [OrderId], 
            [Extent6].[SurchargeId] AS [SurchargeId], 
            [Extent6].[SurValue] AS [SurValue], 
            [Extent6].[SurValueRatio] AS [SurValueRatio], 
            [Extent6].[Price] AS [Price], 
            [Extent6].[CreatedDate] AS [CreatedDate2], 
            [Extent6].[ReturnId] AS [ReturnId], 
            [Extent6].[RetailerId] AS [RetailerId2], 
            CAST(NULL AS bigint) AS [C25], 
            CAST(NULL AS bigint) AS [C26], 
            CAST(NULL AS bigint) AS [C27], 
            CAST(NULL AS varchar(1)) AS [C28], 
            CAST(NULL AS varchar(1)) AS [C29], 
            CAST(NULL AS varchar(1)) AS [C30], 
            CAST(NULL AS int) AS [C31], 
            CAST(NULL AS int) AS [C32], 
            CAST(NULL AS varchar(1)) AS [C33], 
            CAST(NULL AS int) AS [C34], 
            CAST(NULL AS bigint) AS [C35], 
            CAST(NULL AS float) AS [C36], 
            CAST(NULL AS float) AS [C37], 
            CAST(NULL AS decimal(19,4)) AS [C38], 
            CAST(NULL AS float) AS [C39], 
            CAST(NULL AS int) AS [C40], 
            CAST(NULL AS bigint) AS [C41], 
            CAST(NULL AS float) AS [C42], 
            CAST(NULL AS decimal(19,4)) AS [C43], 
            CAST(NULL AS varchar(1)) AS [C44], 
            CAST(NULL AS varchar(1)) AS [C45], 
            CAST(NULL AS varchar(1)) AS [C46], 
            CAST(NULL AS varchar(1)) AS [C47], 
            CAST(NULL AS varchar(1)) AS [C48], 
            CAST(NULL AS int) AS [C49]
            FROM   [dbo].[Order] AS [Extent4]
            LEFT OUTER JOIN [dbo].[SaleChannel] AS [Extent5] ON [Extent4].[SaleChannelId] = [Extent5].[Id]
            INNER JOIN [dbo].[InvoiceOrderSurcharge] AS [Extent6] ON [Extent4].[Id] = [Extent6].[OrderId]
            WHERE ([Extent4].[RetailerId] = @p__linq__0) AND ([Extent4].[BranchId] IN (48725, 48725, 48725, 48725, 48725)) AND ([Extent4].[Status] IN (1,5,2)) AND ([Extent4].[BranchId] = @p__linq__1)) AS [UnionAll1]
    UNION ALL
        SELECT 
        3 AS [C1], 
        [Extent7].[BranchId] AS [BranchId], 
        [Extent7].[Id] AS [Id], 
        [Extent7].[CustomerId] AS [CustomerId], 
        [Extent7].[CashierId] AS [CashierId], 
        [Extent7].[PurchaseDate] AS [PurchaseDate], 
        [Extent7].[Code] AS [Code], 
        [Extent7].[PaymentType] AS [PaymentType], 
        [Extent7].[BranchId] AS [BranchId1], 
        [Extent7].[Description] AS [Description], 
        [Extent7].[Status] AS [Status], 
        [Extent7].[ModifiedDate] AS [ModifiedDate], 
        [Extent7].[RetailerId] AS [RetailerId], 
        [Extent7].[Discount] AS [Discount], 
        [Extent7].[SoldById] AS [SoldById], 
        [Extent7].[TableId] AS [TableId], 
        [Extent7].[CreatedDate] AS [CreatedDate], 
        [Extent7].[CreatedBy] AS [CreatedBy], 
        [Extent7].[ModifiedBy] AS [ModifiedBy], 
        [Extent7].[DiscountRatio] AS [DiscountRatio], 
        [Extent7].[Extra] AS [Extra], 
        [Extent7].[EndPurchaseDate] AS [EndPurchaseDate], 
        [Extent7].[BookingTitle] AS [BookingTitle], 
        [Extent7].[Total] AS [Total], 
        [Extent7].[TotalPayment] AS [TotalPayment], 
        [Extent7].[UsingCod] AS [UsingCod], 
        [Extent7].[Surcharge] AS [Surcharge], 
        [Extent7].[Point] AS [Point], 
        [Extent7].[Uuid] AS [Uuid], 
        [Extent7].[SaleChannelId] AS [SaleChannelId], 
        [Extent7].[IsFavourite] AS [IsFavourite], 
        [Extent8].[Id] AS [Id1], 
        [Extent8].[CreatedDate] AS [CreatedDate1], 
        [Extent8].[CreatedBy] AS [CreatedBy1], 
        [Extent8].[ModifiedDate] AS [ModifiedDate1], 
        [Extent8].[ModifiedBy] AS [ModifiedBy1], 
        [Extent8].[Name] AS [Name], 
        [Extent8].[Description] AS [Description1], 
        [Extent8].[IsActive] AS [IsActive], 
        [Extent8].[Position] AS [Position], 
        [Extent8].[RetailerId] AS [RetailerId1], 
        [Extent8].[Img] AS [Img], 
        [Extent8].[IsNotDelete] AS [IsNotDelete], 
        [Extent8].[OmniChannelId] AS [OmniChannelId], 
        CAST(NULL AS bigint) AS [C2], 
        CAST(NULL AS bigint) AS [C3], 
        CAST(NULL AS bigint) AS [C4], 
        CAST(NULL AS float) AS [C5], 
        CAST(NULL AS decimal(19,4)) AS [C6], 
        CAST(NULL AS decimal(19,4)) AS [C7], 
        CAST(NULL AS datetime2) AS [C8], 
        CAST(NULL AS float) AS [C9], 
        CAST(NULL AS varchar(1)) AS [C10], 
        CAST(NULL AS varchar(1)) AS [C11], 
        CAST(NULL AS float) AS [C12], 
        CAST(NULL AS float) AS [C13], 
        CAST(NULL AS datetime2) AS [C14], 
        CAST(NULL AS varchar(1)) AS [C15], 
        CAST(NULL AS bit) AS [C16], 
        CAST(NULL AS int) AS [C17], 
        CAST(NULL AS varchar(1)) AS [C18], 
        CAST(NULL AS int) AS [C19], 
        CAST(NULL AS bit) AS [C20], 
        CAST(NULL AS bigint) AS [C21], 
        CAST(NULL AS decimal(19,4)) AS [C22], 
        CAST(NULL AS bit) AS [C23], 
        CAST(NULL AS int) AS [C24], 
        CAST(NULL AS bigint) AS [C25], 
        CAST(NULL AS bigint) AS [C26], 
        CAST(NULL AS bigint) AS [C27], 
        CAST(NULL AS int) AS [C28], 
        CAST(NULL AS decimal(19,4)) AS [C29], 
        CAST(NULL AS float) AS [C30], 
        CAST(NULL AS decimal(19,4)) AS [C31], 
        CAST(NULL AS datetime2) AS [C32], 
        CAST(NULL AS bigint) AS [C33], 
        CAST(NULL AS int) AS [C34], 
        [Extent9].[Id] AS [Id2], 
        [Extent9].[OrderId] AS [OrderId], 
        [Extent9].[ProductId] AS [ProductId], 
        [Extent9].[PromotionName] AS [PromotionName], 
        [Extent9].[PromotionTypeName] AS [PromotionTypeName], 
        [Extent9].[PromotionApplicationType] AS [PromotionApplicationType], 
        [Extent9].[PromotionId] AS [PromotionId], 
        [Extent9].[SalePromotionId] AS [SalePromotionId], 
        [Extent9].[PromotionInfo] AS [PromotionInfo], 
        [Extent9].[Type] AS [Type], 
        [Extent9].[RelatedProductId] AS [RelatedProductId], 
        [Extent9].[ProductQty] AS [ProductQty], 
        [Extent9].[RelatedProductQty] AS [RelatedProductQty], 
        [Extent9].[Discount] AS [Discount1], 
        [Extent9].[DiscountRatio] AS [DiscountRatio1], 
        [Extent9].[TargetType] AS [TargetType], 
        [Extent9].[GiftPoint] AS [GiftPoint], 
        [Extent9].[GiftPointRatio] AS [GiftPointRatio], 
        [Extent9].[ProductPrice] AS [ProductPrice], 
        [Extent9].[RelatedCategoryIds] AS [RelatedCategoryIds], 
        [Extent9].[RelatedProductIds] AS [RelatedProductIds], 
        [Extent9].[ProductIds] AS [ProductIds], 
        [Extent9].[ReceivedVoucherCodes] AS [ReceivedVoucherCodes], 
        [Extent9].[PrintPromotionInfo] AS [PrintPromotionInfo], 
        [Extent9].[RetailerId] AS [RetailerId2]
        FROM   [dbo].[Order] AS [Extent7]
        LEFT OUTER JOIN [dbo].[SaleChannel] AS [Extent8] ON [Extent7].[SaleChannelId] = [Extent8].[Id]
        INNER JOIN [dbo].[OrderPromotion] AS [Extent9] ON [Extent7].[Id] = [Extent9].[OrderId]
        WHERE ([Extent7].[RetailerId] = @p__linq__0) AND ([Extent7].[BranchId] IN (48725, 48725, 48725, 48725, 48725)) AND ([Extent7].[Status] IN (1,5,2)) AND ([Extent7].[BranchId] = @p__linq__1)) AS [UnionAll2]
    ORDER BY [UnionAll2].[C3] ASC, [UnionAll2].[C32] ASC, [UnionAll2].[C1] ASC