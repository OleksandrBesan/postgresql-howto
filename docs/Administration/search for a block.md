
# Search for the query  activity

```sql 
select  *,

       pg_blocking_pids(pid) as blocked_by
from pg_stat_activity
```

to cancel the task 
```sql 
select pg_cancel_backend(pid)
```

or terminate 

```sql
select pg_terminate_backend(pid)
```

# Search for db locks 

To see the locks that held by active processes within database server 


```sql
SELECT
  locktype,
  relation::REGCLASS,
  virtualxid AS virtxid,
  transactionid AS xid,
  (SELECT datname FROM pg_database WHERE oid = l.database) AS dbname,
  (SELECT relname FROM pg_class WHERE oid = l.classid) AS classname,
  objid,
  mode,
  granted
FROM pg_locks l
;
```