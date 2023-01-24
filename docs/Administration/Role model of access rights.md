# Role model of access rights for administration Postgresql

[sql scripts](../../src/sql/administration/role_model.sql)

## Naming convention of schemas and other objects. 

All sources need to be on its own schema. 
Schema should have naming convention. So , the logic behind naming correlated to the source of the data and its nature.
Do not just pile everything in one schema. 

For the convinience , im divided schemas on its purpuoses and the next nature: 
- dblink to another foreign server/db. 
- The data that downloaded from dblink by some ETL tool or just sql job
- Report schemas with aggragated or manipulated data from the sources above. 
- A bunch of schema for the externall applications 

Remember that schema in differents dbs could not see each other. 
Remember that the structure of schemas for the externall applications  correlated to its purpuoses in application. Do not pile everything in public schema, create schemas by business sources and need. 

## Basic sources and schemas

For example we have the next schema: 
```sql 
create schema justdata; 
```
The simple and extensive role model  of access rights to this schema could be divided into roles
- reader 
- writer 
- owner 
  
if you have the specific role in mind - you could extend the basic roles by your desire. (access to only specific tables by departments in your organization etc.)

```sql 
CREATE ROLE justdata_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA justdata TO justdata_reader;
GRANT USAGE ON SCHEMA justdata TO justdata_reader;

CREATE ROLE justdata_writer;
GRANT INSERT ON ALL TABLES IN SCHEMA justdata TO justdata_writer;
GRANT UPDATE ON ALL TABLES IN SCHEMA justdata TO justdata_writer;
GRANT DELETE ON ALL TABLES IN SCHEMA justdata TO justdata_writer;
GRANT USAGE ON SCHEMA justdata TO justdata_writer;

create role justdata_owner; 
GRANT USAGE ON schema justdata TO justdata_owner;
ALTER SCHEMA justdata OWNER TO justdata_owner; 
--Ad-hoc for the objects that apear after  every user (for example username) with role justdata_owner creates new object
ALTER DEFAULT PRIVILEGES  FOR ROLE username IN SCHEMA justdata GRANT SELECT ON TABLES TO justdata_reader;

```
 
## DBlinks - externall schemas

For the dblinks roles pretty the same, but techically you need also to grant usage to the foreign server (object for the dblinks).

```sql 
create schema externalldata; 

CREATE ROLE externalldata_reader;
GRANT USAGE ON FOREIGN SERVER api_scoring TO externalldata_reader;
GRANT USAGE ON schema externalldata TO externalldata_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA externalldata TO externalldata_reader;

CREATE ROLE externalldata_writer;
GRANT USAGE ON FOREIGN SERVER api_scoring TO externalldata_writer;
GRANT USAGE ON schema externalldata TO externalldata_writer;
GRANT SELECT ON ALL TABLES IN SCHEMA externalldata TO externalldata_writer;
GRANT INSERT ON ALL TABLES IN SCHEMA externalldata TO externalldata_writer;
GRANT DELETE ON ALL TABLES IN SCHEMA externalldata TO externalldata_writer;
GRANT UPDATE ON ALL TABLES IN SCHEMA externalldata TO externalldata_writer;
```


Also there is if you created mapping in externall dbs not for the public, you should create mapping for the user like this: 

```sql 
CREATE USER MAPPING FOR username 
SERVER oracleDB OPTIONS (user 'usernameExternalDB', password 'password Externall DB');
```
BEWARE! Use mapping do not work for role, you need to create mapping for each user. Tested on Postgresql 13.

## Create user and grant roles 

```sql
CREATE USER username WITH ENCRYPTED PASSWORD 'secretpassword'; 
GRANT externalldata_reader TO username; 
GRANT externalldata_writer TO username; 
```

For the convinience you could create roles that list other roles , and than give that role the user. 
## Reminder 
### Owner of objects 
Despite role model there , if one user creates some object, another user will not be have the possibility to change that. 

You should change owner of object to base owner of schema where object is - justdata_owner. 
Then everyone who has that role could change object. 