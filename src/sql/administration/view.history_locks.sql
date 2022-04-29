

create view history_locks (datname, relation, transactionid, mode, granted, usename, query, query_start, age, pid) as
SELECT a.datname,
       l.relation::regclass      AS relation,
       l.transactionid,
       l.mode,
       l.granted,
       a.usename,
       a.query,
       a.query_start,
       age(now(), a.query_start) AS age,
       a.pid
FROM pg_stat_activity a
         JOIN pg_locks l ON l.pid = a.pid
ORDER BY a.query_start
;
