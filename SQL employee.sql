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
USE employee;

SELECT * FROM fact_employee 
WHERE employee_satisfaction = 5;

SELECT MAX(annual_salary) 
AS highest_salary, 
MIN(annual_salary) AS lowest_salary 
FROM fact_employee;

