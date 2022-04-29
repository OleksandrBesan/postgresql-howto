
create view object_sizes (schema_name, relname, relkind, table_size_mb, indexes_size_mb, total_size_mb) as
SELECT t.schema_name,
       t.relname,
       t.relkind,
       t.table_size_obj / 1024 / 1024   AS table_size_mb,
       t.indexes_size_obj / 1024 / 1024 AS indexes_size_mb,
       t.total_size_obj / 1024 / 1024   AS total_size_mb
FROM (SELECT pg_namespace.nspname                           AS schema_name,
             pg_class.relname,
             pg_class.relkind,
             pg_table_size(pg_class.oid::regclass)          AS table_size_obj,
             pg_indexes_size(pg_class.oid::regclass)        AS indexes_size_obj,
             pg_total_relation_size(pg_class.oid::regclass) AS total_size_obj
      FROM pg_class
               JOIN pg_namespace ON pg_class.relnamespace = pg_namespace.oid) t
WHERE t.schema_name !~~ 'pg_%'::text
ORDER BY t.total_size_obj DESC;