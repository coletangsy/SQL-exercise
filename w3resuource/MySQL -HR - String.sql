-- 1. Write a query to get the job_id and related employee's id.
SELECT job_id, GROUP_CONCAT(employee_id, " ") AS "EMPLOYEE_ID"
FROM employees
GROUP BY job_id;

-- 2. Write a query to update the portion of the phone_number in the employees table, within the phone number the substring '124' will be replaced by '999'.
UPDATE employees
SET phone_number = REPLACE(phone_number, "124","999")
WHERE phone_number LIKE "%124%";

-- 3. Write a query to get the details of the employees where the length of the first name greater than or equal to 8
SELECT *
FROM employees
WHERE LENGTH(FIRST_NAME) >= 8;

-- 4. Write a query to display leading zeros before maximum and minimum salary.
SELECT JOB_ID, LPAD(MIN_SALARY,7,'0') AS "MINIMUM", LPAD(MAX_SALARY,7,'0') AS "MAXIMUM"
FROM jobs;

-- 5. Write a query to append '@example.com' to email field.
UPDATE employees
SET EMAIL = CONCAT(EMAIL,"@example.com");
 
-- 6. Write a query to get the employee id, first name and hire month.
SELECT EMPLOYEE_ID, FIRST_NAME, SUBSTRING(HIRE_DATE,6,7) AS "HIRE_MONTH"
FROM employees;

-- 7. Write a query to get the employee id, email id (discard the last three characters).
SELECT EMPLOYEE_ID, REVERSE(SUBSTR(REVERSE(EMAIL_ID),4)) AS "EMAIL"
FROM employees;

-- 8. Write a query to find all employees where first names are in upper case.
SELECT *
FROM employees
WHERE FIRST_NAME = BINARY UPPER(FIRST_NAME);

-- 9. Write a query to extract the last 4 character of phone numbers. 
SELECT EMPLOYEE_ID, RIGHT(PHONE_NUMBER,4) AS 'PHONE'
FROM employees;

-- 10. Write a query to get the last word of the street address.
SELECT SUBSTING_INDEX(REPLACE(REPLACE(REPLACE(STREET_ADDRESS,","," "),"("," "),")"," ")," ",-1)
FROM locations;

-- 11. Write a query to get the locations that have minimum street length.
SELECT MIN(LENGTH(REPLACE(REPLACE(REPLACE(STREET_ADDRESS,","," "),"("," "),")"," ")))
FROM locations;

-- SUGGESTED
SELECT * 
FROM locations
WHERE LENGTH(STREET_ADDRESS) <= (
	SELECT MIN(LENGTH(STREET_ADDRESS)) FROM locations);

-- 12. Write a query to display the first word from those job titles which contains more than one words. 
SELECT SUBSTRING_INDEX(JOB_TITLE," ",1) AS "FIRSTWORD"
FROM jobs
WHERE JOB_TITLE LIKE "%[]%";

-- 13. Write a query to display the length of first name for employees where last name contain character 'c' after 2nd position.
SELECT LENGTH(FIRST_NAME)
FROM employees
WHERE LAST_NAME LIKE "_c%";

-- 14. Write a query that displays the first name and the length of the first name for all employees whose name starts with the letters 'A', 'J' or 'M'. Give each column an appropriate label. Sort the results by the employees' first names.
SELECT FIRST_NAME AS "NAME", LENGTH(FIRST_NAME) AS "LENGTH"
FROM employees
WHERE FIRST_NAME REGEXP '[AJM]'
ORDER BY FIRST_NAME;

-- SUGGESTED
SELECT FIRST_NAME AS "NAME", LENGTH(FIRST_NAME) AS "LENGTH"
FROM employees
WHERE FIRST_NAME LIKE "J%" OR FIRST_NAME LIKE "M%" OR FIRST_NAME LIKE "A%"
ORDER BY FIRST_NAME;

-- 15. Write a query to display the first name and salary for all employees. Format the salary to be 10 characters long, left-padded with the $ symbol. Label the column SALARY. 
SELECT FIRST_NAME, CONCAT("$", LPAD(SALARY,10,"0")) AS "SALARY"
FROM employees;

-- SUGGESTED 
SELECT FIRST_NAME, LPAD(SALARY,10,"$") AS "SALARY"
FROM employees;

-- 16. Write a query to display the first eight characters of the employees' first names and indicates the amounts of their salaries with '$' sign. Each '$' sign signifies a thousand dollars. Sort the data in descending order of salary.

-- SUGGESTED
SELECT LEFT(FIRST_NAME,8) , REPEAT("$", FLOOR(SALARY/1000))) AS "SALARY ($)", SALARY 
FROM employees
ORDER BY SALARY DESC;

-- 17. Write a query to display the employees with their code, first name, last name and hire date who hired either on seventh day of any month or seventh month in any year. 
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE
FROM employees
WHERE MID(HIRE_DATE,6,2) = "07" OR MID(HIRE_DATE,9,2) = "07" ;

-- SUGGESTED
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE
FROM employees
WHERE POSITION("07" IN DATE_FORMAT(HIRE_DATE, "%D %M %Y")) > 0;