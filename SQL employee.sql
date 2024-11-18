-- Crear BD
CREATE DATABASE employee;

USE employee;

-- Tabla Género
CREATE TABLE dim_gender (
    id_gender INT AUTO_INCREMENT PRIMARY KEY,
    gender char(1)
);

-- Tabla motivo baja
CREATE TABLE dim_leave_reason (
    id_leave_reason INT AUTO_INCREMENT PRIMARY KEY,
    leave_reason VARCHAR(50)
);

-- Tabla estado civil
CREATE TABLE dim_marital_status (
    id_marital_status INT AUTO_INCREMENT PRIMARY KEY,
    marital_status VARCHAR(50)
);

-- Tabla provincia
CREATE TABLE dim_branch (
    id_branch INT AUTO_INCREMENT PRIMARY KEY,
    branch VARCHAR(40)
);

-- Tabla status
CREATE TABLE dim_status (
    id_status INT AUTO_INCREMENT PRIMARY KEY,
    sstatus VARCHAR(30)
);

-- Tabla departamento
CREATE TABLE dim_department (
    id_department INT AUTO_INCREMENT PRIMARY KEY,
    department VARCHAR(50)
);

-- Tabla trabajo
CREATE TABLE dim_job_title (
    id_job_title INT AUTO_INCREMENT PRIMARY KEY,
    job_title VARCHAR(100)
);

-- Tabla permormance
CREATE TABLE dim_performance (
    id_performance INT NOT NULL UNIQUE PRIMARY KEY,
    performance VARCHAR(50)
);

-- Tabla empleados
CREATE TABLE dim_employee (
	employee_id INT NOT NULL UNIQUE PRIMARY KEY,
	dob DATE,
    age INT,
    surname VARCHAR(100) NOT NULL,
    name VARCHAR(100) NOT NULL,
	id_gender INT,
    id_marital_status INT,
    id_branch INT,
    id_leave_reason INT,
    id_status INT,
    id_department INT,
    id_job_title INT,
    id_performance INT,
    
    FOREIGN KEY (id_gender) REFERENCES dim_gender(id_gender),
    FOREIGN KEY (id_marital_status) REFERENCES dim_marital_status(id_marital_status),
    FOREIGN KEY (id_branch) REFERENCES dim_branch(id_branch),
    FOREIGN KEY (id_leave_reason) REFERENCES dim_leave_reason(id_leave_reason),
    FOREIGN KEY (id_status) REFERENCES dim_status(id_status),
    FOREIGN KEY (id_department) REFERENCES dim_department(id_department),
    FOREIGN KEY (id_job_title) REFERENCES dim_job_title(id_job_title),
    FOREIGN KEY (id_performance) REFERENCES dim_performance(id_performance)
);

-- Tabla transacciones
CREATE TABLE fact_employee (
   hire_date DATE,
   leave_date DATE,
   employee_satisfaction INT,
   annual_salary DOUBLE,
   bonus DOUBLE,
   employee_id INT,
   
   FOREIGN KEY (employee_id) REFERENCES dim_employee(employee_id)
);

-- Habilitar carga de archivo
SHOW VARIABLES LIKE 'local_infile';
SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile=1;
SHOW VARIABLES LIKE 'secure_file_priv';

-- Cargar datos 
LOAD DATA INFILE 'Ruta archivo.csv'
INTO TABLE dim_gender
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id_gender, gender);

-- Consultas
-- 1 Mayor y Menor salario
SELECT MAX(annual_salary) AS Mayor_salario, 
MIN(annual_salary) AS Menor_salario 
FROM fact_employee;

-- 2 Cantidad de Total de empleados
SELECT COUNT(employee_id) AS Cantidad_Transacciones 
FROM fact_employee;

-- 3 Cantidad de empleados Activos
SELECT dim_status.sstatus AS Estado, COUNT(dim_employee.employee_id) AS Cantidad_empleados
FROM dim_employee
JOIN dim_status
ON dim_employee.id_status = dim_status.id_status
GROUP BY dim_status.sstatus;

-- 4 Cantidad de empleados Inactivos (no da el resultado)
SELECT dim_status.sstatus AS Estado, COUNT(dim_employee.employee_id) AS Cantidad_empleados
FROM dim_employee
JOIN dim_status
ON dim_employee.id_status = dim_status.id_status
WHERE TRIM(dim_status.sstatus) != 'Active'
GROUP BY dim_status.sstatus;

-- 5 Promedio de sueldo por género
SELECT dim_gender.gender AS Genero, AVG(fact_employee.annual_salary) AS Promedio_sueldo
FROM fact_employee
JOIN dim_employee
ON fact_employee.employee_id = dim_employee.employee_id
JOIN dim_gender
ON dim_employee.id_gender = dim_gender.id_gender
GROUP BY dim_gender.gender;

-- 6 Cantidad empleados por ciudad
select COUNT(employee_id) as Cantidad_empelados
from dim_employee
join dim_branch
on dim_employee.id_branch = dim_branch.id_branch
group by dim_branch.branch;

-- 7 Nombre de Empleados con mayor performance
SELECT dim_employee.name AS Nombre_empleados, dim_performance.performance AS Rendimiento
FROM dim_employee
JOIN dim_performance
on dim_employee.id_performance = dim_performance.id_performance
WHERE dim_performance.performance = 'Fully Meets';

-- 8 Nombre de Empleados con satisfaccion mayor a 3
SELECT dim_employee.name AS Nombre_empleados, fact_employee.employee_satisfaction AS Satisfaccion
FROM dim_employee
JOIN fact_employee
on dim_employee.employee_id = fact_employee.employee_id
WHERE fact_employee.employee_satisfaction > 3
ORDER BY fact_employee.employee_satisfaction DESC;

-- 9 Promedio de edad según género
SELECT dim_gender.gender AS Genero, AVG(dim_employee.age) AS Promedio_edad
FROM dim_employee
JOIN dim_gender
ON dim_employee.id_gender = dim_gender.id_gender
GROUP BY dim_gender.gender;

-- 10 Cantidad de Empleados según titulo
SELECT dim_job_title.job_title AS Titulo, COUNT(dim_employee.employee_id) AS Cantidad_empleados
FROM dim_employee
JOIN dim_job_title
ON dim_employee.id_job_title = dim_job_title.id_job_title
GROUP BY dim_job_title.job_title
ORDER BY Cantidad_empleados DESC;
