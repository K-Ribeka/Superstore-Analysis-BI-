--Create a scheduler to schedule the job at 12:00 AM IST hours every Thursday to perform previous step

--Created task to load data from external stage  

CREATE or replace TASK superstore_task
  WAREHOUSE = superstore_wh,
  SCHEDULE = 'USING CRON 0 0 * * THU Asia/Kolkata'
  --SCHEDULE = '1 MINUTE'
  TIMESTAMP_INPUT_FORMAT = 'YYYY-MM-DD HH24'
AS
copy into superstore_table
from (select t.$1 , t.$2 , t.$3 , t.$4 , t.$5 , t.$6 , t.$7, t.$8, t.$9, t.$10 ,
       t.$11 , t.$12 , t.$13 , t.$14 , t.$15 , t.$16 , t.$17, t.$18, t.$19, t.$20,t.$21
      from @superstore_stage/ t)
file_format = csv_format
pattern = '.*Superstore[1-5].csv'
on_error = 'skip_file';

--We need to resume the task because it will be suspended on creation
alter task superstore_task resume;

--listing all task
show tasks;

--viewing data
select * from superstore_table;

--suspending task
alter task superstore_task suspend;
