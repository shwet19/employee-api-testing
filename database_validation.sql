-- =========================================================================
-- DATABASE VALIDATION SUITE FOR QA BACKEND TESTING ARCHITECTURE
-- Target DB Engine: MySQL / PostgreSQL
-- =========================================================================

-- 1. SCHEMA STRUCTURING & SAMPLE ENVIRONMENT CREATION
CREATE TABLE departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) DEFAULT 'Pune'
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    hire_date DATE NOT NULL,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Populate mock environment metrics to simulate data persistence
INSERT INTO departments (dept_name, location) VALUES 
('Engineering', 'Hinjewadi, Pune'),
('Quality Assurance', 'Magarpatta, Pune'),
('Human Resources', 'Mumbai');

INSERT INTO employees (first_name, last_name, email, salary, hire_date, dept_id) VALUES
('Shweta', 'Putte', 'shweta.p@qa.local', 75000.00, '2025-06-01', 2),
('Amit', 'Sharma', 'amit.s@dev.local', 85000.00, '2024-01-15', 1),
('Neha', 'Patil', 'neha.p@hr.local', 55000.00, '2023-11-10', 3),
('Rahul', 'Deshmukh', 'rahul.d@qa.local', 72000.00, '2025-02-20', 2);

-- =========================================================================
-- RECRUITER VERIFICATION INTEGRITY QUERIES (QA VALIDATION SCENARIOS)
-- =========================================================================

-- Scenario A: Fetch employees alongside their respective department configurations (INNER JOIN validation)
SELECT 
    e.emp_id, 
    CONCAT(e.first_name, ' ', e.last_name) AS full_name, 
    e.email, 
    d.dept_name, 
    d.location
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
ORDER BY e.emp_id ASC;

-- Scenario B: Identify the highest earning employee within the localized QA branch (Subquery + Aggregate function)
SELECT emp_id, first_name, last_name, salary 
FROM employees 
WHERE salary = (SELECT MAX(salary) FROM employees WHERE dept_id = 2);

-- Scenario C: Generate cumulative data summaries grouping total department counts (GROUP BY + HAVING filtering)
SELECT 
    d.dept_name, 
    COUNT(e.emp_id) AS total_headcount, 
    SUM(e.salary) AS total_payroll_expenditure
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_name
HAVING total_headcount > 0;

-- Scenario D: Extract recent team inclusions hired after a specific API trigger date validation window
SELECT emp_id, first_name, email, hire_date 
FROM employees 
WHERE hire_date >= '2025-01-01' 
AND email LIKE '%@qa.local';
