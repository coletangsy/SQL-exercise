-- 1. Write a SQL statement to change the email column of employees table with 'not available' for all employees.
UPDATE employees
SET EMAIL = "not available";

-- 2. Write a SQL statement to change the email and commission_pct column of employees table with 'not available' and 0.10 for all employees.
UPDATE employees
SET EMAIL = "not available" , commission_pct = 0.10;

-- 3. Write a SQL statement to change the email and commission_pct column of employees table with 'not available' and 0.10 for those employees whose department_id is 110.
UPDATE employees
SET EMAIL = "not available" , commission_pct = 0.10
WHERE department_id = 110;

-- 4. Write a SQL statement to change the email column of employees table with 'not available' for those employees whose department_id is 80 and gets a commission is less than .20%
UPDATE employees
SET EMAIL = "not available"
WHERE department_id = 80 AND commission_pct <0.20;

-- 5. Write a SQL statement to change the email column of employees table with 'not available' for those employees who belongs to the 'Accouning' department.
UPDATE employees
SET EMAIL = "not available"
WHERE JOB_ID = "FI_ACCOUNT";

-- correct:
UPDATE employees
SET EMAIL = "not available"
WHERE department_id = (
	SELECT department_id
    FROM departments
    WHERE department_name = "Accounting");

-- 6. Write a SQL statement to change salary of employee to 8000 whose ID is 105, if the existing salary is less than 5000.
UPDATE employees
SET SALARY = 8000
WHERE EMPLOYEE_ID = 105 AND SALARY <5000;

-- 7. Write a SQL statement to change job ID of employee which ID is 118, to SH_CLERK if the employee belongs to department, which ID is 30 and the existing job ID does not start with SH.
UPDATE employees
SET JOB_ID = SH_CLERK
WHERE EMPLOYEE_ID = 118 AND DEPARTMENT_ID = 30 AND JOB_ID NOT LIKE "SH%";

-- 8. Write a SQL statement to increase the salary of employees under the department 40, 90 and 110 according to the company rules that, salary will be increased by 25% for the department 40, 15% for department 90 and 10% for the department 110 and the rest of the departments will remain same.
UPDATE employees
SET SALARY = CASE DEPARTMENT_ID
		WHEN 40 THEN SALARY + SALARY * 0.25
		WHEN 90 THEN SALARY + SALARY * 0.15
		WHEN 110 THEN SALARY + SALARY * 0.10
		ELSE SALARY
    END
	WHERE DEPARTMENT_ID IN (40,90,110);
    
-- 9. Write a SQL statement to increase the minimum and maximum salary of PU_CLERK by 2000 as well as the salary for those employees by 20% and commission percent by .10.
UPDATE employees, jobs
SET jobs.min_salary = jobs.min_salary + 2000, jobs.max_salary = jobs.max_salary + 2000,
employees.salary = employees.salary + employees.salary * 0.20,
employees.commission_pct = employees.commission_pct + 0.10
WHEN employees.JOB_ID = "PU_CLERK" AND jobs.id = "PU_CLERK";
