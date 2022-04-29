# oracle_fdw manual
## Installing oracle client 
[Oracle client install in manual](./../Install/Install%20and%20Configure%20Oracle%20Client.md) 

## Installing oracle_fdw
Download and unpack oracle_fdw source 
```bash  
mkdir  ~/extensions_source  
mkdir  ~/extensions_source/oracle_fdw 
wget https://github.com/laurenz/oracle_fdw/archive/refs/tags/ORACLE_FDW_2_3_0.tar.gz -P  ~/extensions_source/oracle_fdw
cd ~/extensions_source/oracle_fdw
tar -xf ORACLE_FDW_2_3_0.tar.gz
cd oracle_fdw-ORACLE_FDW_2_3_0
```

Links and prepare
```bash   
sudo mkdir /usr/lib/oracle/21/client64/lib/oci
sudo ln -s /usr/include/oracle/21/client64 /usr/lib/oracle/21/client64/lib/oci/include
sudo chmod 777 ~/extensions_source/oracle_fdw/oracle_fdw-ORACLE_FDW_2_3_0
sudo ln -s /usr/include/oracle/21/client64 $ORACLE_HOME/includev

```

Compile and install
```bash   
cd ~/extensions_source/oracle_fdw/oracle_fdw-ORACLE_FDW_2_3_0
make
sudo make install
```
In Postgres DB 
```sql 
CREATE EXTENSION oracle_fdw;
```


## Configure oracle_fdw


### Create server
First you will need to create server.
```sql 
CREATE SERVER oracleDB FOREIGN DATA WRAPPER oracle_fdw
          OPTIONS (dbserver '//ip:1521/SID');
```

### Create mappings
Then to make this work you need to create mapping for authentification. For specific user
```sql
CREATE USER MAPPING FOR username 
SERVER oracleDB OPTIONS (user 'usernameExternalDB', password 'password Externall DB');
```
or for everyone on the server 
```sql
CREATE USER MAPPING FOR public 
SERVER oracleDB OPTIONS (user 'usernameExternalDB', password 'password Externall DB');
```
Thats will do not need to create mappings  and you can manage security by granting access to the server. 


### Create schema
```sql
create schema externallschema;
IMPORT FOREIGN SCHEMA "SCHEMA" from SERVER oracleDB into externallschema;
```

or you could create foreign table by youself with some calculations 


```sql
CREATE FOREIGN TABLE TABLENAME (
          id        integer,
          name      character varying(100)
       ) SERVER oracleDB 
	   OPTIONS (table '(SELECT *  FROM SCHEMA.TABLENAME)')
```


### Role model and security administration

First and foremost you need to create the role for the convinience matter: 
```sql
CREATE ROLE externallschema_reader;
```
Naming convention for me is usefull - schemaName_rolepermissionsName 

Granting usage of the server 
```sql
GRANT USAGE ON FOREIGN SERVER oracleDB TO externallschema_reader;
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
1. https://github.com/laurenz/oracle_fdw/releases/tag/ORACLE_FDW_2_3_0
2. https://githubmemory.com/repo/laurenz/oracle_fdw/issues/447
3. https://help.ubuntu.com/community/Oracle%20Instant%20Client
4. https://github.com/laurenz/oracle_fdw