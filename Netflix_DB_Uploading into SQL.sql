create database netflix_db;

use netflix_db;

CREATE TABLE netflix(
	show_id VARCHAR(10),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(210) DEFAULT NULL,
	cast VARCHAR(1000) DEFAULT NULL,
	country	VARCHAR(150) DEFAULT NULL,
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),	
	listed_in VARCHAR(100),
	description VARCHAR(260)
    )
;

show variables like 'secure_file_priv';
set sql_mode='';

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/netflix_titles.csv"
INTO TABLE netflix
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES;

set global local_infile=1;
