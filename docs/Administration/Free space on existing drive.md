
# Free space on existing tablespaces 

Firstly you need to estimate the main tables in tablespace with troubles 

```sql 
SELECT t.schema_name,
       t.relname,
       t.relkind,
       t.table_size_obj / 1024 / 1024   AS table_size_mb,
       t.indexes_size_obj / 1024 / 1024 AS indexes_size_mb,
       t.total_size_obj / 1024 / 1024   AS total_size_mb, tb.spcname
FROM (SELECT pg_namespace.nspname                           AS schema_name,
             pg_class.relname,
             pg_class.relkind,
             pg_class.reltablespace,
             pg_class.relnamespace,
             pg_table_size(pg_class.oid::regclass)          AS table_size_obj,
             pg_indexes_size(pg_class.oid::regclass)        AS indexes_size_obj,
             pg_total_relation_size(pg_class.oid::regclass) AS total_size_obj
      FROM pg_class
               JOIN pg_namespace ON pg_class.relnamespace = pg_namespace.oid) t
left join pg_tablespace tb on tb.oid=t.reltablespace
WHERE t.schema_name !~~ 'pg_%'::text
ORDER BY   t.total_size_obj DESC;
```

## Defragmantation 

### Install pgstattuple

```sql 
CREATE EXTENSION pgstattuple;
``` 

### Table Fragmentation Details & free space by clean up 

```sql 
SELECT * FROM pgstattuple('test');
``` 
The following query will show the next columns 
 
| Column             | Type   | Description                          |
| ------------------ | ------ | ------------------------------------ |
| table_len          | bigint | Physical relation length in bytes    |
| tuple_count        | bigint | Number of live tuples                |
| tuple_len          | bigint | Total length of live tuples in bytes |
| tuple_percent      | float8 | Percentage of live tuples            |
| dead_tuple_count   | bigint | Number of dead tuples                |
| dead_tuple_len     | bigint | Total length of dead tuples in bytes |
| dead_tuple_percent | float8 | Percentage of dead tuples            |
| free_space         | bigint | Total free space in bytes            |
| free_percent       | float8 | Percentage of free space             |

The main chararcteristics to see is free_percent - that what you can free in you space. 

To free space you need to do 
```sql
VACUUM (VERBOSE, FULL) test;
```

Actually its usefull to run VACUUM ones in a while on heavily updated tables. 
## Manual cleanup

You can always ssh to your server and check the free spaces on disk 
```bash 
df -h
```
What can be manually cleaup:
1. If your server is standby and your configures wal files, than you should clean up them pgarchivecleanup .
2. Clean up the pg logs

## Move to another drive  , if nothing works 

Sometimes , actually you can only add a new drive and move tables into that new tablespace. Manual how to do that is [here](./Install%20drive%20Ubuntu%20and%20Tablespace%20Postgresql.md)