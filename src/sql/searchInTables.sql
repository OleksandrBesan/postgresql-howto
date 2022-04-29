
select t.table_schema,
       t.table_name,
       c.column_name,
       t.table_type
from information_schema.tables t
inner join information_schema.columns c on c.table_name = t.table_name
                                and c.table_schema = t.table_schema
where c.column_name = 'lang'
      and t.table_schema not in ('information_schema', 'pg_catalog') 
order by t.table_schema;
; 