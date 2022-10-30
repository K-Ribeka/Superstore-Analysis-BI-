--Create an alternative of the above step for auto ingestion of new record sets uploaded on the blob storage into respective snowflake table

--Snowpipe created with auto-ingestion

create or replace pipe superstore_pipe auto_ingest=true as
    copy into superstore_table
    from @superstore_stage;

--description of snowpipe from where we will get notification channel
desc pipe superstore_pipe;
 
--show pipe
show pipes;

--Checking Status of snowpipe    
select SYSTEM$PIPE_STATUS('superstore_pipe');

--Validation of data loading through snowpipe in mentioned timeframe
select * from table(validate_pipe_load(
pipe_name=>'superstore_pipe',
start_time=>dateadd(minute, -5, current_timestamp())));
  
--Checking all the loaded files in mentioned timeframe
select * from table(information_schema.copy_history(table_name=>'superstore_table', start_time=> dateadd(hours, -1, current_timestamp())));

--fetching all data from source table 
select * from superstore_table;
