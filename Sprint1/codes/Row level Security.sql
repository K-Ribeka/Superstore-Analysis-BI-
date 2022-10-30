--•	Implement Row Level Security on the above dataset

--creating roles
create or replace role CONSUMER;
create or replace role CORPORATE;
create or replace role "HOME OFFICE";

--Creating users & granting specific roles to users

create or replace user superstore_consumer password = 'temp123' default_Role = 'CONSUMER';
grant role CONSUMER to user superstore_consumer;

create or replace user superstore_corporate password = 'temp123' default_Role = 'CORPORATE';
grant role CORPORATE to user superstore_corporate;

create or replace user superstore_home_office password = 'temp123' default_Role = 'HOME OFFICE';
grant role "HOME OFFICE" to user superstore_home_office;

--Granting roles to current user
grant role CONSUMER to user SUPERSTORE;
grant role CORPORATE to user SUPERSTORE;
grant role "HOME OFFICE" to user SUPERSTORE;

--Granting access to roles on warehouse
grant usage on warehouse superstore_wh to role CONSUMER;
grant usage on warehouse superstore_wh to role CORPORATE;
grant usage on warehouse superstore_wh to role "HOME OFFICE";

--Granting access to roles on database
grant usage on database SUPERSTORE_DB to role CONSUMER;
grant usage on database SUPERSTORE_DB to role CORPORATE;
grant usage on database SUPERSTORE_DB to role "HOME OFFICE";

--Granting access to roles on schema
grant usage on schema PUBLIC to role CONSUMER;
grant usage on schema PUBLIC to role CORPORATE;
grant usage on schema PUBLIC to role "HOME OFFICE";

--Creating secure view
create or replace secure view superstore_view as
select *
from superstore_table 
where upper(segment) = upper(current_role());

--show views
show views;

--Granting access to roles on secure view
grant select on view SUPERSTORE_VIEW to role CONSUMER;
grant select on view SUPERSTORE_VIEW to role CORPORATE;
grant select on view SUPERSTORE_VIEW to role "HOME OFFICE";

--Changing role
use role CORPORATE;

--Viewing data
select * from superstore_view;
