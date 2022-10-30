--create warehouse
create warehouse superstore_wh;

--create database
create database superstore_db;

--Integration object creation for external stage
create or replace storage integration superstore_storage
  type = external_stage
  storage_provider = s3
  enabled = true
  storage_aws_role_arn = 'arn:aws:iam::387666169593:role/superstore_role'
  storage_allowed_locations = ('s3://superstorebucket6/');
  
--Description of Integration object
DESC INTEGRATION superstore_storage;

--File format
create or replace file format csv_format
type = csv field_delimiter = ',' skip_header = 1 null_if = ('NULL', 'null') empty_field_as_null = true
field_optionally_enclosed_by='"';

--Description of file format
desc file format csv_format;

--Create an External Stage to load the data continuously

create or replace stage  superstore_stage
  storage_integration = superstore_storage
  url = 's3://superstorebucket6/'
  file_format =  csv_format;

--list of files in exteranl stage
list @superstore_stage;