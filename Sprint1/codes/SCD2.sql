--•	Implement Slowly Changing Dimension Type 2 in for the above data flow

-- Creating stream to track DML changes on source data
create or replace stream superstore_stream on table superstore_table; 

--it will not show any data until we make any DML changes
select * from superstore_stream;

--Target table creation
create or replace  
table super_target (Row_ID Number(8) not null,
                               Order_ID Varchar not null,
                               Order_Date Date,
                               Ship_Date Date,
                               Ship_Mode Varchar,
                               Customer_ID Varchar,
                               Customer_Name Varchar,
                               Segment Varchar,
                               Country Varchar,
                               City Varchar,
                               State Varchar,
                               Postal_Code Number,
                               Region Text,
                               Product_ID Varchar,
                               Category Text,
                               Sub_Category Text,
                               Product_Name Varchar,
                               Sales float,
                               Quantity Number,
                               Discount float,
                               Profit float, stream_type string default null, rec_version number default 0,REC_DATE TIMESTAMP_LTZ);

--Merged data into target table with versioning history which will capture through task

CREATE OR REPLACE TASK super_target_merge
  WAREHOUSE = superstore_wh
  SCHEDULE = '1 minute'
WHEN
  SYSTEM$STREAM_HAS_DATA('superstore_stream')
AS
merge into super_target t
using superstore_stream s
on t.Row_ID=s.Row_ID and (metadata$action='DELETE')
when matched and metadata$isupdate='FALSE' then update set rec_version=9999, stream_type='DELETE'
when matched and metadata$isupdate='TRUE' then update set rec_version=rec_version-1, stream_type='UPDATE'
when not matched then insert  (Row_ID,Order_ID,Order_Date,Ship_Date,Ship_Mode,Customer_ID,Customer_Name,Segment,Country,City,State,Postal_Code,Region,Product_ID,Category,
                               Sub_Category,Product_Name,Sales,Quantity,Discount,Profit,stream_type,rec_version,REC_DATE) values(s.Row_ID,s.Order_ID,s.Order_Date,s.Ship_Date,s.Ship_Mode,s.Customer_ID,s.Customer_Name,s.Segment,s.Country,s.City,s.State,s.Postal_Code,
                                                                                                                                 s.Region,s.Product_ID,s.Category,s.Sub_Category,s.Product_Name,s.Sales,s.Quantity,s.Discount,s.Profit, metadata$action,0,CURRENT_TIMESTAMP());                                                                                       
                                                                                                                                 

--We need to resume the task because it will be suspended on creation
ALTER TASK super_target_merge resume;

--Updating specific record of source table 
update superstore_table set order_id='CA-2016-DDDMMM' where row_id=333;

--listing contents of target table
select * from super_target where row_id=333;
