-- LINK : https://en.wikibooks.org/wiki/SQL_Exercises/Employee_management
-- 2.1 Select the last name of all employees.
SELECT LastName
FROM employees;

-- 2.2 Select the last name of all employees, without duplicates.
SELECT DISTINCT LastName
FROM employees;

-- 2.3 Select all the data of employees whose last name is "Smith".
SELECT *
FROM employees
WHERE LastName = "Smith";

-- 2.4 Select all the data of employees whose last name is "Smith" or "Doe".
SELECT *
FROM employees
WHERE LastName = "Smith" OR LastName = "Doe";

-- 2.5 Select all the data of employees that work in department 14.
SELECT *
FROM employees
WHERE Department = 14;

-- 2.6 Select all the data of employees that work in department 37 or department 77.
SELECT *
FROM employees
WHERE Department = 37 OR Department = 77;

-- 2.7 Select all the data of employees whose last name begins with an "S".
SELECT *
FROM employees
WHERE LastName LIKE "S%";

-- 2.8 Select the sum of all the departments' budgets.
SELECT SUM(Budget) AS Sum_of_departments
FROM departments;

-- 2.9 Select the number of employees in each department (you only need to show the department code and the number of employees).
SELECT Department, COUNT(SSN) AS no_of_employees
FROM employees
GROUP BY Department;

-- 2.10 Select all the data of employees, including each employee's department's data.
SELECT a.*, b.*
FROM employees a
JOIN  departments b ON a.department = b.code;

-- 2.11 Select the name and last name of each employee, along with the name and budget of the employee's department.
SELECT a.Name, a.LastName, b.Name, b.Budget
FROM employees a
JOIN departments b ON a.department = b.code;

-- 2.12 Select the name and last name of employees working for departments with a budget greater than $60,000.
SELECT a.Name, a.LastName
FROM employees a
JOIN departments b ON a.Department = b.code
WHERE Budget > 60000;

# OR
SELECT Name, LastName
FROM employees
WHERE Department IN (
					SELECT Code
					FROM departments
					WHERE Budget > 60000);
                    
-- 2.13 Select the departments with a budget larger than the average budget of all the departments.
SELECT *
FROM departments
WHERE Budget > (
	SELECT AVG(Budget) AS avg_budget
	FROM departments);
    
-- 2.14 Select the names of departments with more than two employees.
SELECT Name
FROM departments
WHERE Code IN (
	SELECT Department
	FROM employees
	GROUP BY Department
	HAVING COUNT(SSN) > 2);

-- 2.15 Very Important - Select the name and last name of employees working for departments with second lowest budget.
SELECT Name,LastName
FROM employees
WHERE department = 
(SELECT temp.code
FROM (SELECT *
		FROM departments
		ORDER BY Budget ASC LIMIT 2) temp
ORDER BY Budget DESC LIMIT 1);

-- 2.16  Add a new department called "Quality Assurance", with a budget of $40,000 and departmental code 11. 
# SELECT *
# FROM departments;

INSERT INTO departments
VALUE (11,"Quality Assurance",40000);

-- And Add an employee called "Mary Moore" in that department, with SSN 847-21-9811.
# SELECT *
# FROM employees;

INSERT INTO employees
VALUE (847219811,"Mary","Moore",11);

-- 2.17 Reduce the budget of all departments by 10%.
# SELECT *
# FROM departments;

UPDATE departments
SET budget = budget * 0.9

-- 2.18 Reassign all employees from the Research department (code 77) to the IT department (code 14).
# SELECT *
# FROM employees

UPDATE employees
SET Department = 14
WHERE Department = 17;

-- 2.19 Delete from the table all employees in the IT department (code 14).
DELETE FROM employees
WHERE Department = 14

-- 2.20 Delete from the table all employees who work in departments with a budget greater than or equal to $60,000.
DELETE FROM employees
WHERE Department IN (SELECT Code
	FROM departments;
	WHERE budget >= 60000)
    
-- 2.21 Delete from the table all employees.
DELETE FROM employees

