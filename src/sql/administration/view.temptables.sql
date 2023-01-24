
create view temp_tables (schema_name, relname, relkind, table_size_mb, indexes_size_mb, total_size_mb) as
SELECT
	n.nspname as SchemaName
	,c.relname as RelationName
	,CASE c.relkind
	WHEN 'r' THEN 'table'
	WHEN 'v' THEN 'view'
	WHEN 'i' THEN 'index'
	WHEN 'S' THEN 'sequence'
	WHEN 's' THEN 'special'
	END as RelationType
	,pg_catalog.pg_get_userbyid(c.relowner) as RelationOwner               
	,pg_size_pretty(pg_relation_size(n.nspname ||'.'|| c.relname)) as RelationSize
FROM pg_catalog.pg_class c
LEFT JOIN pg_catalog.pg_namespace n               
                ON n.oid = c.relnamespace
WHERE  c.relkind IN ('r','s') 
AND  (n.nspname !~ '^pg_toast' and nspname like 'pg_temp%')
ORDER BY pg_relation_size(n.nspname ||'.'|| c.relname) DESC

; 