--Question 1: employees earning more than their managers using Self-Join
SELECT 
    e.Name AS EmployeeName,
FROM Employee e
LEFT JOIN Employee m
ON e.ManagerID = m.EmployeeID
where e.salary > m.salary

--Question 2: Using Common Table Expression to rank employees by salary within each department
WITH dep_Sal AS (
    SELECT 
        e.name AS employee, 
        e.salary, 
        d.name AS department, 
        RANK() OVER (PARTITION BY e.departmentid ORDER BY e.salary DESC) AS salary_rank_by_department
    FROM 
        employee e
    JOIN 
        department d
    ON 
        e.departmentid = d.id
)
-- Selecting the highest-salary employee in each department
SELECT 
    department, 
    employee, 
    salary
FROM 
    dep_Sal
WHERE 
    salary_rank_by_department = 1;

--Question 3: A company's executives are interested in seeing who earns the most in each of the company's departments. A high earner in a department is an employee who has a salary in the top three unique salaries for that department.

--Write a solution to find the employees who are high earners in each of the departments.

--Solution with CTE

WITH dep_Sal AS (
    SELECT 
        e.name AS employee, 
        e.salary, 
        d.name AS department, 
        Dense_RANK() OVER (PARTITION BY e.departmentid ORDER BY e.salary DESC) AS salary_rank_by_department
    FROM 
        employee e
    JOIN 
        department d
    ON 
        e.departmentid = d.id
)
-- Selecting the 3 highest-salary employees in each department
SELECT 
    department, 
    employee, 
    salary
FROM 
    dep_Sal
WHERE 
    salary_rank_by_department between 1 and 3;

--Question 4: How many employees are in each department
--Solved using aggregate and group by function 

SELECT name as Department, COUNT(*) AS Total_Employees
FROM Employees
GROUP BY Department_id;

-------Find the salary gap between the highest and lowest paid employee in each department
SELECT 
    e.Department,  MAX(e.salary) as max_sal, MIN(e.salary) as min_sal,
    MAX(e.salary) - MIN(e.salary) AS Salary_Gap
FROM 
   [dbo].[Employee]e
JOIN 
   [dbo].[Employee]d ON e.[EmployeeID] = d.departmentid
GROUP BY 
    e.Department 

----How many years has an employee been with the company since their hire date
SELECT distinct([EmployeeID]), [EmployeeName], DATEDIFF(year, [HireDate], Getdate()) as year_of_employment
From [dbo].[Employee]

---count the number of employees who have spent between 5 to 10 years
WITH CTE AS 
(
SELECT distinct([EmployeeID]), [EmployeeName], DATEDIFF(year, [HireDate], Getdate()) as year_of_employment
From [dbo].[Employee]
)
SELECT 
     Count(case when year_of_employment between 5 and 10 then [EmployeeID]  else null end)as emp_year_count 
from cte
