-- 1. Write a SQL statement to insert a record with your own value into the table countries against each columns.
INSERT INTO countries VALUES("C1","HongKong",1001);

-- 2. Write a SQL statement to insert one row into the table countries against the column country_id and country_name.
INSERT INTO countries(country_id,country_name) VALUES("C1","HongKong");

-- 3. Write a SQL statement to create duplicate of countries table named country_new with all structure and data.
CREATE TABLE IF NOT EXISTS country_new
AS SELECT * FROM countries;

-- 4. Write a SQL statement to insert NULL values against region_id column for a row of countries table.
INSERT INTO countries(country_id,country_name,region_id) VALUES("C1","HongKong",NULL);

-- 5. Write a SQL statement to insert 3 rows by a single insert statement.
INSERT INTO countries VALUES("C1","HongKong",1001),("C2","USA",1002),("C3","UK",1003);

-- 6. Write a SQL statement insert rows from country_new table to countries table.
INSERT INTO countries 
SELECT * FROM country_new;

-- 7. Write a SQL statement to insert one row in jobs table to ensure that no duplicate value will be entered in the job_id column.
INSERT INTO jobs VALUES(1001,"OFFICER",8000);

-- 8. Write a SQL statement to insert one row in jobs table to ensure that no duplicate value will be entered in the job_id column.
-- the same with the above

-- 9. Write a SQL statement to insert a record into the table countries to ensure that, a country_id and region_id combination will be entered once in the table.
CREATE TABLE IF NOT EXISTS countries ( 
COUNTRY_ID integer NOT NULL,
COUNTRY_NAME varchar(40) NOT NULL,
REGION_ID integer NOT NULL,
PRIMARY KEY (COUNTRY_ID,REGION_ID)
);
INSERT INTO countries VALUES(101,"Italy",185);

-- 10. Write a SQL statement to insert rows into the table countries in which the value of country_id column will be unique and auto incremented.
CREATE TABLE IF NOT EXISTS countries ( 
COUNTRY_ID integer NOT NULL AUTO_INCREMENT PRIMARY KEY,
COUNTRY_NAME varchar(40) NOT NULL,
REGION_ID integer NOT NULL
);
INSERT INTO countries(country_name,region_id) VALUES("HongKong",502);

-- 11. Write a SQL statement to insert records into the table countries to ensure that the country_id column will not contain any duplicate data and this will be automatically incremented and the column country_name will be filled up by 'N/A' if no value assigned for that column.
CREATE TABLE IF NOT EXISTS countries ( 
COUNTRY_ID integer NOT NULL AUTO_INCREMENT PRIMARY KEY,
COUNTRY_NAME varchar(40) NOT NULL DEFAULT 'N/A',
REGION_ID integer NOT NULL
);
INSERT INTO countries(country_name) VALUES("N/A")

-- 12. Write a SQL statement to insert rows in the job_history table in which one column job_id is containing those values which are exists in job_id column of jobs table.


-- 13. Write a SQL statement to insert rows into the table employees in which a set of columns department_id and manager_id contains a unique value and that combined values must have exists into the table departments.


-- 14. Write a SQL statement to insert rows into the table employees in which a set of columns department_id and job_id contains the values which must have exists into the table departments and jobs.




