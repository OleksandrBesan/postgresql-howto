# postgres_fdw manual
## Installing postgres_fdw 
postgres_fdw - extension to create dblinks to the postgres databases .

```sql 
CREATE EXTENSION postgres_fdw;
```

## Configure postgres_fdw

### Create server
First you will need to create server.
```sql 
CREATE SERVER postgresDB
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'ip', port '5432', dbname 'db');
```

### Create mappings
Then to make this work you need to create mapping for authentification. For specific user
```sql
CREATE USER MAPPING FOR username 
SERVER postgresDB OPTIONS (user 'usernameExternalDB', password 'password Externall DB');
```
or for everyone on the server 
```sql
CREATE USER MAPPING FOR public 
SERVER postgresDB OPTIONS (user 'usernameExternalDB', password 'password Externall DB');
```
Thats will do not need to create mappings  and you can manage security by granting access to the server. 


### Create schema
```sql
create schema externallschema;
IMPORT FOREIGN SCHEMA public from SERVER postgresDB into externallschema;
```

### Role model and security administration

First and foremost you need to create the role for the convinience matter: 
```sql
CREATE ROLE externallschema_reader;
```
Naming convention for me is usefull - schemaName_rolepermissionsName 

Granting usage of the server 
```sql
GRANT USAGE ON FOREIGN SERVER postgresDB TO externallschema_reader;
```
Granting usage of the schema 
```sql
GRANT USAGE ON schema externallschema TO externallschema_reader;
```

Granting select on all imported tables
```sql
GRANT SELECT ON ALL TABLES IN SCHEMA externallschema TO externallschema_reader;
```

And then you can grant this role to user in need =) 

```sql
GRANT externallschema_reader TO user;
```

# References 

1. [CREATE USER MAPPING](https://www.postgresql.org/docs/current/sql-createusermapping.html)