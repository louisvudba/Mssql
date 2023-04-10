### Indexes

```sql
DECLARE @SchemaName VARCHAR(100);
DECLARE @TableName VARCHAR(256);
DECLARE @IndexName VARCHAR(256);
DECLARE @ColumnName VARCHAR(100);
DECLARE @is_unique VARCHAR(100);
DECLARE @IndexTypeDesc VARCHAR(100);
DECLARE @FileGroupName VARCHAR(100);
DECLARE @is_disabled VARCHAR(100);
DECLARE @filter_definition VARCHAR(500);
DECLARE @has_filter BIT;
DECLARE @IndexOptions VARCHAR(MAX);
DECLARE @IndexColumnId INT;
DECLARE @IsDescendingKey INT;
DECLARE @IsIncludedColumn INT;
DECLARE @TSQLScripCreationIndex VARCHAR(MAX);
DECLARE @TSQLScripDisableIndex VARCHAR(MAX);
DECLARE @TSQLScripDropIndex VARCHAR(MAX);

DECLARE CursorIndex CURSOR FOR
SELECT SCHEMA_NAME(t.schema_id) [schema_name],
       t.name,
       ix.name,
       CASE
           WHEN ix.is_unique = 1 THEN
               'UNIQUE '
           ELSE
               ''
       END,
       ix.type_desc,
       CASE
           WHEN ix.is_padded = 1 THEN
               'PAD_INDEX = ON, '
           ELSE
               'PAD_INDEX = OFF, '
       END + CASE
                 WHEN ix.allow_page_locks = 1 THEN
                     'ALLOW_PAGE_LOCKS = ON, '
                 ELSE
                     'ALLOW_PAGE_LOCKS = OFF, '
             END + CASE
                       WHEN ix.allow_row_locks = 1 THEN
                           'ALLOW_ROW_LOCKS = ON, '
                       ELSE
                           'ALLOW_ROW_LOCKS = OFF, '
                   END + CASE
                             WHEN INDEXPROPERTY(t.object_id, ix.name, 'IsStatistics') = 1 THEN
                                 'STATISTICS_NORECOMPUTE = ON, '
                             ELSE
                                 'STATISTICS_NORECOMPUTE = OFF, '
                         END + CASE
                                   WHEN ix.ignore_dup_key = 1 THEN
                                       'IGNORE_DUP_KEY = ON, '
                                   ELSE
                                       'IGNORE_DUP_KEY = OFF, '
                               END + 'SORT_IN_TEMPDB = OFF, FILLFACTOR = 90' AS IndexOptions,
       ix.is_disabled,
       FILEGROUP_NAME(ix.data_space_id) FileGroupName,
       ix.filter_definition,
       ix.has_filter
FROM sys.tables t
    INNER JOIN sys.indexes ix
        ON t.object_id = ix.object_id
WHERE ix.type > 0
      AND ix.is_primary_key = 0
      AND ix.is_unique_constraint = 0 --and schema_name(tb.schema_id)= @SchemaName and tb.name=@TableName
      AND t.is_ms_shipped = 0
      AND t.name <> 'sysdiagrams'
      AND SCHEMA_NAME(t.schema_id) = 'dbo'
	  AND t.name NOT LIKE '[_]%'
	  AND t.name NOT LIKE '%Bak%'
	  AND ix.is_unique = 0
ORDER BY SCHEMA_NAME(t.schema_id),
         t.name,
         ix.name;

OPEN CursorIndex;
FETCH NEXT FROM CursorIndex
INTO @SchemaName,
     @TableName,
     @IndexName,
     @is_unique,
     @IndexTypeDesc,
     @IndexOptions,
     @is_disabled,
     @FileGroupName,
     @filter_definition,
     @has_filter;

WHILE (@@fetch_status = 0)
BEGIN
    DECLARE @IndexColumns VARCHAR(MAX);
    DECLARE @IncludedColumns VARCHAR(MAX);

    SET @IndexColumns = '';
    SET @IncludedColumns = '';

    DECLARE CursorIndexColumn CURSOR FOR
    SELECT col.name,
           ixc.is_descending_key,
           ixc.is_included_column
    FROM sys.tables tb
        INNER JOIN sys.indexes ix
            ON tb.object_id = ix.object_id
        INNER JOIN sys.index_columns ixc
            ON ix.object_id = ixc.object_id
               AND ix.index_id = ixc.index_id
        INNER JOIN sys.columns col
            ON ixc.object_id = col.object_id
               AND ixc.column_id = col.column_id
    WHERE ix.type > 0
          AND
          (
              ix.is_primary_key = 0
              OR ix.is_unique_constraint = 0
          )
          AND SCHEMA_NAME(tb.schema_id) = @SchemaName
          AND tb.name = @TableName
          AND ix.name = @IndexName
    ORDER BY ixc.index_column_id;

    OPEN CursorIndexColumn;
    FETCH NEXT FROM CursorIndexColumn
    INTO @ColumnName,
         @IsDescendingKey,
         @IsIncludedColumn;

    WHILE (@@fetch_status = 0)
    BEGIN
        IF @IsIncludedColumn = 0
            SET @IndexColumns = @IndexColumns + QUOTENAME(@ColumnName) + CASE
                                                                  WHEN @IsDescendingKey = 1 THEN
                                                                      ' DESC, '
                                                                  ELSE
                                                                      ' ASC, '
                                                              END;
        ELSE
            SET @IncludedColumns = @IncludedColumns + QUOTENAME(@ColumnName) + ', ';

        FETCH NEXT FROM CursorIndexColumn
        INTO @ColumnName,
             @IsDescendingKey,
             @IsIncludedColumn;
    END;

    CLOSE CursorIndexColumn;
    DEALLOCATE CursorIndexColumn;

    SET @IndexColumns = SUBSTRING(@IndexColumns, 1, LEN(@IndexColumns) - 1);
    SET @IncludedColumns = CASE
                               WHEN LEN(@IncludedColumns) > 0 THEN
                                   SUBSTRING(@IncludedColumns, 1, LEN(@IncludedColumns) - 1)
                               ELSE
                                   ''
                           END;
    --  print @IndexColumns
    --  print @IncludedColumns

    SET @TSQLScripCreationIndex = '';
    SET @TSQLScripDisableIndex = '';
	SET @TSQLScripDropIndex = '';
    SET @TSQLScripCreationIndex
        = 'CREATE ' + @is_unique + @IndexTypeDesc + ' INDEX ' + QUOTENAME(@IndexName) + ' ON ' + QUOTENAME(@SchemaName)
          + '.' + QUOTENAME(@TableName) + '(' + @IndexColumns + ') '
          + CASE
                WHEN LEN(@IncludedColumns) > 0 THEN
                    CHAR(13) + 'INCLUDE (' + @IncludedColumns + ')'
                ELSE
                    ''
            END + CASE
                      WHEN @has_filter = 1 THEN
                          CHAR(13) + 'WHERE ' + @filter_definition
                      ELSE
                          ''
                  END + CHAR(13) + 'WITH (' + @IndexOptions + ') ON ' + QUOTENAME(@FileGroupName) + ';';
	
	SET @TSQLScripDropIndex = 'DROP INDEX IF EXISTS ' + QUOTENAME(@IndexName) + ' ON ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + ';';
	
	PRINT @TSQLScripCreationIndex
	PRINT @TSQLScripDropIndex

    IF @is_disabled = 1
    BEGIN
        SET @TSQLScripDisableIndex
            = CHAR(13) + 'ALTER INDEX ' + QUOTENAME(@IndexName) + ' ON ' + QUOTENAME(@SchemaName) + '.'
              + QUOTENAME(@TableName) + ' DISABLE;' + CHAR(13);
        PRINT @TSQLScripDisableIndex;
    END;

    FETCH NEXT FROM CursorIndex
    INTO @SchemaName,
         @TableName,
         @IndexName,
         @is_unique,
         @IndexTypeDesc,
         @IndexOptions,
         @is_disabled,
         @FileGroupName,
         @filter_definition,
         @has_filter;

END;
CLOSE CursorIndex;
```

### Foreign Keys

```sql
SELECT
  Drop_FK = 'ALTER TABLE [' + FK.FKTableSchema +
    '].[' + FK.FKTableName + '] DROP CONSTRAINT [' + FK.FKName + ']; ',
  Add_FK_NFR = 'ALTER TABLE [' + FK.FKTableSchema +
    '].[' + FK.FKTableName +
    '] WITH CHECK ADD CONSTRAINT [' + FK.FKName +
    '] FOREIGN KEY([' + FK.FKTableColumn +
    ']) REFERENCES [' + schema_name(sys.objects.schema_id) +
    '].[' + sys.objects.[name] + ']([' + sys.columns.[name] +
    ']) ' + (CASE WHEN FK.update_referential_action = 1 OR FK.delete_referential_action = 1 THEN 'ON' ELSE '' END) +
	' ' + (CASE WHEN FK.update_referential_action = 1 THEN 'UPDATE ' + FK.update_referential_action_desc ELSE '' END) + 
	' ' + (CASE WHEN FK.delete_referential_action = 1 THEN 'DELETE ' + FK.delete_referential_action_desc ELSE '' END) + 
	' NOT FOR REPLICATION; '
	,FK.update_referential_action_desc, FK.delete_referential_action_desc 
	FROM sys.objects
INNER JOIN sys.columns
  ON (sys.columns.[object_id] = sys.objects.[object_id])
INNER JOIN (
  SELECT
    sys.foreign_keys.[name] AS FKName,
    schema_name(sys.objects.schema_id) AS FKTableSchema,
    sys.objects.[name] AS FKTableName,
    sys.columns.[name] AS FKTableColumn,
    sys.foreign_keys.referenced_object_id AS referenced_object_id,
    sys.foreign_key_columns.referenced_column_id AS referenced_column_id,
	sys.foreign_keys.update_referential_action,
	sys.foreign_keys.update_referential_action_desc COLLATE SQL_Latin1_General_CP1_CI_AS update_referential_action_desc,
	sys.foreign_keys.delete_referential_action,
	sys.foreign_keys.delete_referential_action_desc COLLATE SQL_Latin1_General_CP1_CI_AS delete_referential_action_desc
  FROM sys.foreign_keys
  INNER JOIN sys.foreign_key_columns
    ON (sys.foreign_key_columns.constraint_object_id = sys.foreign_keys.[object_id])
  INNER JOIN sys.objects
    ON (sys.objects.[object_id] = sys.foreign_keys.parent_object_id)
  INNER JOIN sys.columns
    ON (sys.columns.[object_id] = sys.objects.[object_id])
      AND (sys.columns.column_id = sys.foreign_key_columns.parent_column_id)
) FK
  ON (FK.referenced_object_id = sys.objects.[object_id])
    AND (FK.referenced_column_id = sys.columns.column_id)
WHERE (sys.objects.[type] = 'U')
  AND (sys.objects.is_ms_shipped = 0)
  AND (sys.objects.[name] NOT IN ('sysdiagrams'))
```