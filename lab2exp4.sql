Database changed
mysql> 
mysql> CREATE TABLE regions (region_id INT PRIMARY KEY, region_name VARCHAR(50) NOT NULL);
ERROR 1050 (42S01): Table 'regions' already exists
mysql> 
mysql> CREATE TABLE countries (country_id VARCHAR(5) PRIMARY KEY, country_name VARCHAR(50) NOT NULL, region_id INT, FOREIGN KEY (region_id) REFERENCES regions(region_id));
ERROR 1050 (42S01): Table 'countries' already exists
mysql> 
mysql> CREATE TABLE locations (location_id INT PRIMARY KEY, street_address VARCHAR(100), postal_code VARCHAR(20), city VARCHAR(50), state_province VARCHAR(50), country_id VARCHAR(5), 
    -> FOREIGN KEY (country_id) REFERENCES countries(country_id));
ERROR 1050 (42S01): Table 'locations' already exists
mysql> 
mysql> CREATE TABLE departments (dept_id INT PRIMARY KEY, dept_name VARCHAR(50) NOT NULL, location_id INT, FOREIGN KEY (location_id) REFERENCES locations(location_id));
ERROR 1050 (42S01): Table 'departments' already exists
mysql> 
mysql> CREATE TABLE jobs (job_id VARCHAR(10) PRIMARY KEY, job_title VARCHAR(50), min_salary DECIMAL(10,2), max_salary DECIMAL(10,2));
ERROR 1050 (42S01): Table 'jobs' already exists
mysql> 
mysql> CREATE TABLE employees (employee_id INT PRIMARY KEY, first_name VARCHAR(50), last_name VARCHAR(50), email VARCHAR(100), phone_no VARCHAR(20), hire_date DATE, job_id VARCHAR(10), salary DECIMAL(10,2), 
    -> manager_id INT, dept_id INT, FOREIGN KEY (job_id) REFERENCES jobs(job_id), FOREIGN KEY (manager_id) REFERENCES employees(employee_id), FOREIGN KEY (dept_id) REFERENCES departments(dept_id));
ERROR 1050 (42S01): Table 'employees' already exists
mysql> 
mysql> CREATE TABLE dependents (dependent_id INT PRIMARY KEY, first_name VARCHAR(50), last_name VARCHAR(30), relationship VARCHAR(30), employee_id INT, FOREIGN KEY (employee_id) REFERENCES employees(employee_id));
ERROR 1050 (42S01): Table 'dependents' already exists
mysql> 
mysql> INSERT INTO regions VALUES (1,'Asia'),(2,'Europe');
ERROR 1062 (23000): Duplicate entry '1' for key 'PRIMARY'
mysql> 
mysql> INSERT INTO countries VALUES ('IN','India',1),('UK','United Kingdom',2);
ERROR 1062 (23000): Duplicate entry 'IN' for key 'PRIMARY'
mysql> 
dmysql> INSERT INTO locations VALUES (1700,'MG Road','56000','Bangalore','Karnataka','IN'),(1800,'Oxford Street','W1','London','London','UK');
ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`company`.`locations`, CONSTRAINT `locations_ibfk_1` FOREIGN KEY (`country_id`) REFERENCES `countries` (`country_id`))
mysql> 
mmysql> INSERT INTO departments VALUES (1,'IT',1700),(2,'HR',1700),(3,'Finance',1800),(4,'Marketing',1800);
NERROR 1062 (23000): Duplicate entry '1' for key 'PRIMARY'
mysql> 
 mysql> INSERT INTO jobs VALUES ('it_prog','Programmer',5000,20000),('hr_rep','HR Representative',4000,15000),('fin_acc','Accountant',6000,18000),('mkt_man','Marketing Manager',8000,25000);
ERROR 1062 (23000): Duplicate entry 'it_prog' for key 'PRIMARY'
mysql> 
 mysql> INSERT INTO employees VALUES (101,'Rahul','Sharma','rahul@gmail.com','999991','2022-01-10','it_prog',15000,NULL,1),(102,'Aish','Khan','aish@gmail.com','999992','2021-01-12','hr_rep',9000,101,2),
    -> (103,'John','Smith','john2@gmail.com','999993','2020-03-15','fin_acc',12000,101,3),(104,'Priya','Nair','priya@gmail.com','999994','2023-04-18','it_prog',7000,101,1),(105,'David','Brown','david@gmail.com','999995','2022-05-20','mkt_man',22000,103,4);
ERROR 1136 (21S01): Column count doesn't match value count at row 1
mysql> 
mysql> INSERT INTO dependents VALUES (1,'Anu','Sharma','Daughter',101),(2,'Sara','Khan','Wife',102);
ERROR 1062 (23000): Duplicate entry '1' for key 'PRIMARY'
mysql> 
mysql> ALTER TABLE employees ADD commission DECIMAL(10,2);
ERROR 1060 (42S21): Duplicate column name 'commission'
mysql> 
mysql> UPDATE employees SET commission=2000 WHERE employee_id=101;
Query OK, 0 rows affected (0.00 sec)
Rows matched: 1  Changed: 0  Warnings: 0

mysql> UPDATE employees SET commission=NULL WHERE employee_id=102;
Query OK, 0 rows affected (0.00 sec)
Rows matched: 1  Changed: 0  Warnings: 0

mysql> UPDATE employees SET commission=1500 WHERE employee_id=103;
Query OK, 0 rows affected (0.01 sec)
Rows matched: 1  Changed: 0  Warnings: 0

mysql> UPDATE employees SET commission=NULL WHERE employee_id=104;
Query OK, 0 rows affected (0.00 sec)
Rows matched: 1  Changed: 0  Warnings: 0

mysql> UPDATE employees SET commission=3000 WHERE employee_id=105;
Query OK, 0 rows affected (0.00 sec)
Rows matched: 1  Changed: 0  Warnings: 0

mysql> 
mysql> SELECT first_name,last_name FROM employees JOIN departments USING (dept_id) WHERE location_id=1700;
+------------+-----------+
| first_name | last_name |
+------------+-----------+
| Rahul      | Sharma    |
| Priya      | Nair      |
| Aish       | Khan      |
+------------+-----------+
3 rows in set (0.00 sec)

mysql> 
mysql> SELECT first_name,last_name FROM employees JOIN departments USING (dept_id) WHERE location_id<>1700;
+------------+-----------+
| first_name | last_name |
+------------+-----------+
| John       | Smith     |
| David      | Brown     |
+------------+-----------+
2 rows in set (0.00 sec)

mysql> 
mysql> SELECT * FROM employees WHERE salary=(SELECT MAX(salary) FROM employees);
+-------------+------------+-----------+-----------------+----------+------------+---------+----------+------------+---------+------------+
| employee_id | first_name | last_name | email           | phone_no | hire_date  | job_id  | salary   | manager_id | dept_id | commission |
+-------------+------------+-----------+-----------------+----------+------------+---------+----------+------------+---------+------------+
|         105 | David      | Brown     | david@gmail.com | 999995   | 2022-05-20 | mkt_man | 22000.00 |        103 |       4 |    3000.00 |
+-------------+------------+-----------+-----------------+----------+------------+---------+----------+------------+---------+------------+
1 row in set (0.00 sec)

mysql> 
mysql> SELECT * FROM employees WHERE salary>(SELECT AVG(salary) FROM employees);
+-------------+------------+-----------+-----------------+----------+------------+---------+----------+------------+---------+------------+
| employee_id | first_name | last_name | email           | phone_no | hire_date  | job_id  | salary   | manager_id | dept_id | commission |
+-------------+------------+-----------+-----------------+----------+------------+---------+----------+------------+---------+------------+
|         101 | Rahul      | Sharma    | rahul@gmail.com | 999991   | 2022-01-10 | it_prog | 15000.00 |       NULL |       1 |    2000.00 |
|         105 | David      | Brown     | david@gmail.com | 999995   | 2022-05-20 | mkt_man | 22000.00 |        103 |       4 |    3000.00 |
+-------------+------------+-----------+-----------------+----------+------------+---------+----------+------------+---------+------------+
2 rows in set (0.00 sec)

mysql> 
mysql> SELECT DISTINCT dept_id,dept_name FROM departments JOIN employees USING (dept_id) WHERE salary>1000;
+---------+-----------+
| dept_id | dept_name |
+---------+-----------+
|       1 | IT        |
|       2 | HR        |
|       3 | finance   |
|       4 | marketing |
+---------+-----------+
4 rows in set (0.00 sec)

mysql> 
mysql> SELECT dept_id,dept_name FROM departments WHERE dept_id NOT IN (SELECT dept_id FROM employees WHERE salary>1000);
Empty set (0.00 sec)

mysql> 
mysql> SELECT * FROM employees WHERE salary>ALL (SELECT MIN(salary) FROM employees GROUP BY dept_id);
Empty set (0.01 sec)

mysql> 
mysql> SELECT * FROM employees WHERE salary>=ALL (SELECT MAX(salary) FROM employees GROUP BY dept_id);
+-------------+------------+-----------+-----------------+----------+------------+---------+----------+------------+---------+------------+
| employee_id | first_name | last_name | email           | phone_no | hire_date  | job_id  | salary   | manager_id | dept_id | commission |
+-------------+------------+-----------+-----------------+----------+------------+---------+----------+------------+---------+------------+
|         105 | David      | Brown     | david@gmail.com | 999995   | 2022-05-20 | mkt_man | 22000.00 |        103 |       4 |    3000.00 |
+-------------+------------+-----------+-----------------+----------+------------+---------+----------+------------+---------+------------+
1 row in set (0.00 sec)

mysql> 
mysql> SELECT AVG(avg_salary) FROM (SELECT AVG(salary) AS avg_salary FROM employees GROUP BY dept_id) AS dept_avg;
+------------------+
| AVG(avg_salary)  |
+------------------+
| 13500.0000000000 |
+------------------+
1 row in set (0.00 sec)

mysql> 
mysql> SELECT first_name,salary,(SELECT AVG(salary) FROM employees) AS avg_salary,salary-(SELECT AVG(salary) FROM employees) AS difference FROM employees;
+------------+----------+--------------+--------------+
| first_name | salary   | avg_salary   | difference   |
+------------+----------+--------------+--------------+
| Rahul      | 15000.00 | 13000.000000 |  2000.000000 |
| Aish       |  9000.00 | 13000.000000 | -4000.000000 |
| John       | 12000.00 | 13000.000000 | -1000.000000 |
| Priya      |  7000.00 | 13000.000000 | -6000.000000 |
| David      | 22000.00 | 13000.000000 |  9000.000000 |
+------------+----------+--------------+--------------+
5 rows in set (0.00 sec)

mysql> 
mysql> SELECT * FROM employees e WHERE salary>(SELECT AVG(salary) FROM employees WHERE dept_id=e.dept_id);
+-------------+------------+-----------+-----------------+----------+------------+---------+----------+------------+---------+------------+
| employee_id | first_name | last_name | email           | phone_no | hire_date  | job_id  | salary   | manager_id | dept_id | commission |
+-------------+------------+-----------+-----------------+----------+------------+---------+----------+------------+---------+------------+
|         101 | Rahul      | Sharma    | rahul@gmail.com | 999991   | 2022-01-10 | it_prog | 15000.00 |       NULL |       1 |    2000.00 |
+-------------+------------+-----------+-----------------+----------+------------+---------+----------+------------+---------+------------+
1 row in set (0.00 sec)

mysql> 
mysql> SELECT * FROM employees e WHERE NOT EXISTS (SELECT * FROM dependents d WHERE d.employee_id=e.employee_id);
+-------------+------------+-----------+-----------------+----------+------------+---------+----------+------------+---------+------------+
| employee_id | first_name | last_name | email           | phone_no | hire_date  | job_id  | salary   | manager_id | dept_id | commission |
+-------------+------------+-----------+-----------------+----------+------------+---------+----------+------------+---------+------------+
|         103 | John       | Smith     | john2@gmail.com | 99999    | 2020-03-15 | fin_acc | 12000.00 |        101 |       3 |    1500.00 |
|         104 | Priya      | Nair      | priya@gmail.com | 999994   | 2023-04-18 | it_prog |  7000.00 |        101 |       1 |       NULL |
|         105 | David      | Brown     | david@gmail.com | 999995   | 2022-05-20 | mkt_man | 22000.00 |        103 |       4 |    3000.00 |
+-------------+------------+-----------+-----------------+----------+------------+---------+----------+------------+---------+------------+
3 rows in set (0.00 sec)

mysql> 
mysql> SELECT e.first_name,e.last_name,d.dept_name FROM employees e JOIN departments d ON e.dept_id=d.dept_id WHERE e.dept_id IN (1,2,3);
+------------+-----------+-----------+
| first_name | last_name | dept_name |
+------------+-----------+-----------+
| Rahul      | Sharma    | IT        |
| Aish       | Khan      | HR        |
| John       | Smith     | finance   |
| Priya      | Nair      | IT        |
+------------+-----------+-----------+
4 rows in set (0.00 sec)

mysql> 
mysql> SELECT e.first_name,e.last_name,j.job_title,d.dept_name FROM employees e JOIN jobs j ON e.job_id=j.job_id JOIN departments d ON 
    -> e.dept_id=d.dept_id WHERE e.dept_id IN (1,2,3) AND e.salary>100000;
Empty set (0.00 sec)

mysql> 
mysql> SELECT d.dept_name,l.street_address,l.postal_code,c.country_name,r.region_name FROM departments d JOIN locations l ON d.location_id=l.location_id JOIN 
    -> countries c ON l.country_id=c.country_id JOIN regions r ON c.region_id=r.region_id;
Empty set (0.00 sec)

mysql> 
mysql> SELECT e.first_name,e.last_name,e.dept_id,d.dept_name FROM employees e LEFT JOIN departments d ON e.dept_id=d.dept_id;
+------------+-----------+---------+-----------+
| first_name | last_name | dept_id | dept_name |
+------------+-----------+---------+-----------+
| Rahul      | Sharma    |       1 | IT        |
| Priya      | Nair      |       1 | IT        |
| Aish       | Khan      |       2 | HR        |
| John       | Smith     |       3 | finance   |
| David      | Brown     |       4 | marketing |
+------------+-----------+---------+-----------+
5 rows in set (0.00 sec)

mysql> 
mysql> SELECT e.first_name,e.last_name,d.dept_name,l.city,l.state_province FROM employees e JOIN departments d ON e.dept_id=d.dept_id 
    -> JOIN locations l ON d.location_id=l.location_id WHERE e.first_name LIKE '%z%';
Empty set (0.00 sec)

mysql> 
mysql> SELECT e.first_name,e.last_name,d.dept_id,d.dept_name FROM departments d LEFT JOIN employees e ON d.dept_id=e.dept_id;
+------------+-----------+---------+-----------+
| first_name | last_name | dept_id | dept_name |
+------------+-----------+---------+-----------+
| Rahul      | Sharma    |       1 | IT        |
| Aish       | Khan      |       2 | HR        |
| John       | Smith     |       3 | finance   |
| Priya      | Nair      |       1 | IT        |
| David      | Brown     |       4 | marketing |
+------------+-----------+---------+-----------+
5 rows in set (0.00 sec)

mysql> 
mysql> SELECT e.first_name AS employee_name,m.first_name AS manager_name FROM employees e LEFT JOIN employees m ON e.manager_id=m.employee_id; 
+---------------+--------------+
| employee_name | manager_name |
+---------------+--------------+
| Rahul         | NULL         |
| Aish          | Rahul        |
| John          | Rahul        |
| Priya         | Rahul        |
| David         | John         |
+---------------+--------------+
5 rows in set (0.00 sec)

mysql> 
mysql> 
mysql> 
mysql> SELECT first_name,last_name,dept_id FROM employees WHERE dept_id=(SELECT dept_id FROM employees WHERE last_name='Smith');
+------------+-----------+---------+
| first_name | last_name | dept_id |
+------------+-----------+---------+
| John       | Smith     |       3 |
+------------+-----------+---------+
1 row in set (0.00 sec)

mysql> 
mysql> SELECT j.job_title,e.first_name,(j.max_salary-e.salary) AS salary_difference FROM employees e JOIN jobs j ON e.job_id=j.job_id;
+-------------------+------------+-------------------+
| job_title         | first_name | salary_difference |
+-------------------+------------+-------------------+
| Programmer        | Rahul      |           5000.00 |
| HR Representative | Aish       |           6000.00 |
| Accountant        | John       |           6000.00 |
| Programmer        | Priya      |          13000.00 |
| Marketing Manager | David      |           3000.00 |
+-------------------+------------+-------------------+
5 rows in set (0.00 sec)

mysql> 
mysql> SELECT d.dept_name,AVG(e.salary) AS avg_salary,COUNT(e.commission) AS commission_count FROM departments d LEFT JOIN employees e ON d.dept_id=e.dept_id GROUP BY d.dept_name;
+-----------+--------------+------------------+
| dept_name | avg_salary   | commission_count |
+-----------+--------------+------------------+
| finance   | 12000.000000 |                1 |
| HR        |  9000.000000 |                0 |
| IT        | 11000.000000 |                1 |
| marketing | 22000.000000 |                1 |
+-----------+--------------+------------------+
4 rows in set (0.00 sec)

mysql> 
mysql> CREATE OR REPLACE VIEW delhi_emp AS SELECT e.employee_id,e.first_name,e.phone_no,j.job_title,d.dept_name,m.first_name AS manager_name FROM employees e JOIN jobs j ON e.job_id=j.job_id JOIN 
    -> departments d ON e.dept_id=d.dept_id JOIN locations l ON d.location_id=l.location_id LEFT JOIN employees m ON e.manager_id=m.employee_id WHERE l.city='London';
Query OK, 0 rows affected (0.01 sec)

mysql> 
mysql> SELECT first_name FROM delhi_emp WHERE job_title='Marketing Manager' AND dept_name='Marketing';
Empty set (0.00 sec)

mysql> 
mysql> UPDATE employees SET phone_no='99999' WHERE first_name='John';
Query OK, 0 rows affected (0.00 sec)
Rows matched: 1  Changed: 0  Warnings: 0

mysql> 
mysql> SELECT * FROM employees e WHERE NOT EXISTS (SELECT * FROM dependents d WHERE d.employee_id=e.employee_id);
+-------------+------------+-----------+-----------------+----------+------------+---------+----------+------------+---------+------------+
| employee_id | first_name | last_name | email           | phone_no | hire_date  | job_id  | salary   | manager_id | dept_id | commission |
+-------------+------------+-----------+-----------------+----------+------------+---------+----------+------------+---------+------------+
|         103 | John       | Smith     | john2@gmail.com | 99999    | 2020-03-15 | fin_acc | 12000.00 |        101 |       3 |    1500.00 |
|         104 | Priya      | Nair      | priya@gmail.com | 999994   | 2023-04-18 | it_prog |  7000.00 |        101 |       1 |       NULL |
|         105 | David      | Brown     | david@gmail.com | 999995   | 2022-05-20 | mkt_man | 22000.00 |        103 |       4 |    3000.00 |
+-------------+------------+-----------+-----------------+----------+------------+---------+----------+------------+---------+------------+
3 rows in set (0.00 sec)

mysql> 
mysql> SELECT * FROM employees WHERE manager_id = 101 UNION SELECT * FROM employees WHERE manager_id = 201;
+-------------+------------+-----------+-----------------+----------+------------+---------+----------+------------+---------+------------+
| employee_id | first_name | last_name | email           | phone_no | hire_date  | job_id  | salary   | manager_id | dept_id | commission |
+-------------+------------+-----------+-----------------+----------+------------+---------+----------+------------+---------+------------+
|         102 | Aish       | Khan      | aish@gmail.com  | 999992   | 2021-01-12 | hr_rep  |  9000.00 |        101 |       2 |       NULL |
|         103 | John       | Smith     | john2@gmail.com | 99999    | 2020-03-15 | fin_acc | 12000.00 |        101 |       3 |    1500.00 |
|         104 | Priya      | Nair      | priya@gmail.com | 999994   | 2023-04-18 | it_prog |  7000.00 |        101 |       1 |       NULL |
+-------------+------------+-----------+-----------------+----------+------------+---------+----------+------------+---------+------------+
3 rows in set (0.00 sec)

mysql> 
mysql> SELECT * FROM employees e WHERE EXISTS (SELECT * FROM dependents d WHERE d.employee_id = e.employee_id);

