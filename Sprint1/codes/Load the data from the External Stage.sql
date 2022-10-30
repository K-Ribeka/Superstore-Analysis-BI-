--Load the data from the External Stage to the respective Table

--Table creation 
create or replace table superstore_table (
    Row_ID Number(8) not null,
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
                               Profit float);
                               
--Load data into table 
copy into superstore_table
from (select t.$1 , t.$2 , t.$3 , t.$4 , t.$5 , t.$6 , t.$7, t.$8 , t.$9 , t.$10 ,
       t.$11 , t.$12 , t.$13 , t.$14 , t.$15 , t.$16 , t.$17, t.$18, t.$19 , t.$20 , t.$21
      from @superstore_stage/ t)
file_format = csv_format
pattern = '.*.csv'
on_error = 'skip_file';
   
--Displaying data of table
select * from superstore_table;