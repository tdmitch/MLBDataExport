SELECT DISTINCT SCH.name AS SchemaName  
      ,OBJ.name AS ObjName  
      ,OBJ.type_desc AS ObjType  
      ,INDX.name AS IndexName  
      ,INDX.type_desc AS IndexType  
      ,PART.partition_number AS PartitionNumber  
      ,PART.rows AS PartitionRows  
      ,STAT.row_count AS StatRowCount  
      ,STAT.used_page_count * 8 AS UsedSizeKB  
      ,STAT.reserved_page_count * 8 AS ReservedSizeKB  
      ,PART.data_compression_desc  
      ,DS.name AS FilegroupName  
      ,(STAT.reserved_page_count - STAT.used_page_count) * 8 AS Unused  
FROM sys.partitions AS PART  
     INNER JOIN sys.dm_db_partition_stats AS STAT  
         ON PART.partition_id = STAT.partition_id  
            AND PART.partition_number = STAT.partition_number  
     INNER JOIN sys.objects AS OBJ  
         ON STAT.object_id = OBJ.object_id  
     INNER JOIN sys.schemas AS SCH  
         ON OBJ.schema_id = SCH.schema_id  
     INNER JOIN sys.indexes AS INDX  
         ON STAT.object_id = INDX.object_id  
            AND STAT.index_id = INDX.index_id  
     INNER JOIN sys.data_spaces AS DS  
         ON INDX.data_space_id = DS.data_space_id  
WHERE 
	obj.type_desc = 'USER_TABLE'
ORDER BY OBJ.name  
        ,INDX.name  
        ,PART.partition_number