-- 1. Write a SQL statement to change the email column of employees table with 'not available' for all employees.
UPDATE employees
SET EMAIL = "not available";

-- 2. Write a SQL statement to change the email and commission_pct column of employees table with 'not available' and 0.10 for all employees.
UPDATE employees
SET EMAIL = "not available" AND commission_pct = 0.10;

-- 3. Write a SQL statement to change the email and commission_pct column of employees table with 'not available' and 0.10 for those employees whose department_id is 110.
UPDATE employees
SET EMAIL = "not available" AND commission_pct = 0.10
WHERE department_id = 110;

-- 4. Write a SQL statement to change the email column of employees table with 'not available' for those employees whose department_id is 80 and gets a commission is less than .20%
UPDATE employees
SET EMAIL = "not available"
WHERE department_id = 80 AND commission_pct <0.20;

-- 5. Write a SQL statement to change the email column of employees table with 'not available' for those employees who belongs to the 'Accouning' department.
UPDATE employees
SET EMAIL = "not available"
WHERE JOB_ID = "FI_ACCOUNT";

-- 6. Write a SQL statement to change salary of employee to 8000 whose ID is 105, if the existing salary is less than 5000.
UPDATE employees
SET SALARY = 8000
WHERE EMPLOYEE_ID = 105 & SALARY <5000;

-- 7. Write a SQL statement to change job ID of employee which ID is 118, to SH_CLERK if the employee belongs to department, which ID is 30 and the existing job ID does not start with SH.


-- 8. Write a SQL statement to increase the salary of employees under the department 40, 90 and 110 according to the company rules that, salary will be increased by 25% for the department 40, 15% for department 90 and 10% for the department 110 and the rest of the departments will remain same.

-- 9. Write a SQL statement to increase the minimum and maximum salary of PU_CLERK by 2000 as well as the salary for those employees by 20% and commission percent by .10.

