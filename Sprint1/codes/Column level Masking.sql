--Implement Column Level Security on the above dataset.

--Role Creation
create or replace role superstore_role;

--Creating mask policy
CREATE MASKING POLICY superstore_policy AS (VAL STRING) RETURNS STRING ->
      CASE
        WHEN CURRENT_ROLE() IN ('SUPERSTORE_ROLE') THEN VAL
        ELSE '**-****-******'
      END;
      
--Applying masking on target table 
alter table if exists super_target modify column order_id set masking policy superstore_policy;
alter table if exists super_target modify column customer_id set masking policy superstore_policy;
alter table if exists super_target modify column customer_name set masking policy superstore_policy;
      
--Checking if mask policy is applied    
desc  table super_target;
      
--Granting access to superstore_role on target table
GRANT SELECT ON super_target TO ROLE superstore_role;

--Granting access to superstore_role on db,schema & warehouse
grant usage on warehouse superstore_wh to role superstore_role;
grant usage on database superstore_db to role superstore_role;
grant usage on schema public to role superstore_role;
  
--Checking current user
select current_user();
   
--Granting role to current user
grant role superstore_role to user SUPERSTORE;
  
--Changing role
use role ACCOUNTADMIN;
 
--Viewing data through superstore_role
select * from super_target;
    
