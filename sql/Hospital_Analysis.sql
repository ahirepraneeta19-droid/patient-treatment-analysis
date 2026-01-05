CREATE DATABASE hospital_db;
USE hospital_db;

CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100)
);

CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_name VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_name VARCHAR(100),
    department_id INT,
    doctor_id INT,
    admission_date DATE,
    discharge_date DATE,
    waiting_time_minutes INT,
    treatment_cost DECIMAL(10,2),
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

INSERT INTO departments (department_name) VALUES
('Cardiology'),
('Orthopedics'),
('Neurology'),
('General Medicine');

INSERT INTO doctors (doctor_name, department_id) VALUES
('Dr. Sharma', 1),
('Dr. Mehta', 2),
('Dr. Rao', 3),
('Dr. Singh', 4);

INSERT INTO patients 
(patient_name, department_id, doctor_id, admission_date, discharge_date, waiting_time_minutes, treatment_cost)
VALUES
('Amit', 1, 1, '2024-01-01', '2024-01-05', 30, 50000),
('Riya', 2, 2, '2024-01-03', '2024-01-10', 45, 35000),
('Karan', 1, 1, '2024-02-05', '2024-02-08', 25, 42000),
('Neha', 3, 3, '2024-02-10', '2024-02-15', 40, 60000),
('Amit', 1, 1, '2024-03-01', '2024-03-04', 35, 48000),
('Pooja', 4, 4, '2024-03-05', '2024-03-07', 20, 20000);

-- Calculate average treatment cost per doctor
SELECT 
    d.doctor_name,
    ROUND(AVG(p.treatment_cost), 2) AS avg_treatment_cost
FROM patients p
JOIN doctors d ON p.doctor_id = d.doctor_id
GROUP BY d.doctor_name;

-- Identify busiest departments based on patient count
SELECT 
    dept.department_name,
    COUNT(p.patient_id) AS patient_count
FROM patients p
JOIN departments dept ON p.department_id = dept.department_id
GROUP BY dept.department_name
ORDER BY patient_count DESC;

-- Retrieve patients with the longest hospital stays
SELECT 
    patient_name,
    DATEDIFF(discharge_date, admission_date) AS stay_days
FROM patients
ORDER BY stay_days DESC;

-- Calculate monthly admission and discharge statistics
SELECT 
    DATE_FORMAT(admission_date, '%Y-%m') AS month,
    COUNT(patient_id) AS total_admissions,
    COUNT(discharge_date) AS total_discharges
FROM patients
GROUP BY month
ORDER BY month;

-- Rank doctors based on the number of patients treated
SELECT 
    d.doctor_name,
    COUNT(p.patient_id) AS patient_count,
    RANK() OVER (ORDER BY COUNT(p.patient_id) DESC) AS doctor_rank
FROM patients p
JOIN doctors d ON p.doctor_id = d.doctor_id
GROUP BY d.doctor_name;

-- Determine readmission rates per department
SELECT 
    dept.department_name,
    COUNT(p.patient_id) AS total_admissions,
    COUNT(DISTINCT p.patient_name) AS unique_patients,
    ROUND(
        (COUNT(p.patient_id) - COUNT(DISTINCT p.patient_name)) * 100.0 
        / COUNT(p.patient_id), 2
    ) AS readmission_rate_percentage
FROM patients p
JOIN departments dept ON p.department_id = dept.department_id
GROUP BY dept.department_name;

-- Calculate average waiting time before treatment
SELECT 
    dept.department_name,
    ROUND(AVG(p.waiting_time_minutes), 2) AS avg_waiting_time_minutes
FROM patients p
JOIN departments dept ON p.department_id = dept.department_id
GROUP BY dept.department_name;

---------------------------------------------------****************************************-----------------------------------------------