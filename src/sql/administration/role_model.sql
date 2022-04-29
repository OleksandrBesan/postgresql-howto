-------------------------------------------------------
------ ROLE MODEL 
-------------------------------------------------------

create schema justdata; 
-------------------------------------------------------
-- Basic schema template
-------------------------------------------------------

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

-------------------------------------------------------
-- ETL DBLinks 
-------------------------------------------------------

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


 
---------------------------------------------
--test roles 

create schema test_roles;

--create role owner 
create role test_roles_owner; 
GRANT USAGE ON schema test_roles TO test_roles_owner;
ALTER SCHEMA test_roles OWNER TO test_roles_owner; 


--create role reader 
CREATE ROLE test_roles_reader;
GRANT USAGE ON SCHEMA test_roles TO test_roles_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA test_roles TO test_roles_reader;
  
--create test  users  
CREATE USER test_user WITH ENCRYPTED PASSWORD '12345';  --password just for the test , never ever create users with such a easy password=)
CREATE USER test_dbowner WITH ENCRYPTED PASSWORD '12345'; 
grant test_roles_owner to test_dbowner; 
grant test_roles_reader to test_user; 
ALTER DEFAULT PRIVILEGES  FOR ROLE test_dbowner IN SCHEMA test_roles GRANT SELECT ON TABLES TO test_roles_reader;

--login as test_dbowner
create table test_roles.test (
id text
);
insert into  test_roles.test values('ddwwd');
create table  test_roles.test2 as
select 3 id union all select 7
;
--login as test_user and test if role is working

select * from test_roles.test; 
select * from test_roles.test2; 
 

drop table test_roles.test; 
drop table test_roles.test2;  
drop schema test_roles; 
drop user test_dbowner ;
drop user test_user ;
drop role test_roles_owner ;
drop role test_roles_reader ;


