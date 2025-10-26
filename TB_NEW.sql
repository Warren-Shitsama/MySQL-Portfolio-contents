-- Step 1: Create a database
CREATE DATABASE IF NOT EXISTS Tuberculosis_data_analysis;
USE Tuberculosis_data_analysis;

-- Step 2: Create a table
CREATE TABLE IF NOT EXISTS tuberculosis_data(
patient_id INT PRIMARY KEY,
sex VARCHAR(10),
age INT,
locality VARCHAR(20),
hiv_status VARCHAR(20),
gene_xpert_results VARCHAR(20),
resistance VARCHAR(20),
date DATE,
tat_hours INT
);

-- Step 3: Load data into MYSQL
LOAD DATA INFILE 'Tuberculosis data.csv'
INTO TABLE tuberculosis_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Step 4: Data cleaning
-- Look for file inconsistencies
-- age
SELECT *
FROM tuberculosis_data
WHERE age < 0; -- Nothing found

-- if there were any inconsistencies, this would be the query for it
UPDATE tuberculosis_data
SET age = ABS(age)
WHERE age < 0;

-- tat hours
SELECT *
FROM tuberculosis_data
WHERE tat_hours < 0; -- Nothing found

-- date
SELECT *
FROM tuberculosis_data
WHERE date > '2025-04-19' 
OR date < '2025-01-04';

-- Look for duplicate
SELECT patient_id, COUNT(*) AS count
FROM tuberculosis_data
GROUP BY patient_id
HAVING count > 1; -- No duplicates found

-- Step 5: Overview queries
-- Total number of patients
SELECT COUNT(*) AS total_number_of_patients
FROM tuberculosis_data;

-- Date range
SELECT MIN(date) AS min_date, MAX(date) AS max_date
FROM tuberculosis_data
;

-- Numeric summary for age and tat_hours
-- age
SELECT COUNT(age) AS count, ROUND(AVG(age)) AS avg_age, MIN(age) AS min_age, MAX(age) AS max_age, ROUND(STDDEV(age)) AS stddev_age
FROM tuberculosis_data;

SELECT age AS median_age 
FROM (SELECT age, ROW_NUMBER() OVER(ORDER BY age) AS row_num, COUNT(*) OVER() AS total 
FROM tuberculosis_data) AS sub
WHERE row_num IN (FLOOR((total + 1)/2), CEIL((total + 1)/2));

SELECT age AS q1_age
FROM (SELECT age, NTILE(4) OVER(ORDER BY age) AS quartile FROM tuberculosis_data) AS sub
WHERE quartile = 1
ORDER BY age DESC LIMIT 1;

SELECT age AS q3_age
FROM (SELECT age, NTILE(4) OVER(ORDER BY age) AS quartile FROM tuberculosis_data) AS sub
WHERE quartile = 3
ORDER BY age DESC LIMIT 1;
    
-- tat_hours
SELECT COUNT(tat_hours) AS count, ROUND(AVG(tat_hours)) AS avg_tat_hours, MIN(tat_hours) AS min_tat_hours, MAX(tat_hours) AS max_tat_hours, ROUND(STDDEV(tat_hours)) AS stddev_tat_hours
FROM tuberculosis_data;

SELECT tat_hours AS tat_hours_median
FROM (SELECT tat_hours, ROW_NUMBER() OVER(ORDER BY tat_hours) AS row_num, COUNT(*) OVER() AS total
		FROM tuberculosis_data) AS sub
WHERE row_num IN(FLOOR(total + 1)/2, CEIL(total + 1)/2);

SELECT tat_hours AS q1_tat
FROM (SELECT tat_hours, NTILE(4) OVER(ORDER BY age) AS quartile FROM tuberculosis_data) AS sub
WHERE quartile = 1
ORDER BY tat_hours DESC LIMIT 1;

SELECT tat_hours AS q3_tat
FROM (SELECT tat_hours, NTILE(4) OVER(ORDER BY age) AS quartile FROM tuberculosis_data) AS sub
WHERE quartile = 3
ORDER BY tat_hours DESC LIMIT 1;

-- Missing values
SELECT
	SUM(CASE WHEN patient_id IS NULL THEN 1 ELSE 0 END) AS null_patient_id,
	SUM(CASE WHEN sex IS NULL THEN 1 ELSE 0 END) AS null_sex,
	SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS null_age,
	SUM(CASE WHEN locality IS NULL THEN 1 ELSE 0 END) AS null_locality,
	SUM(CASE WHEN hiv_status IS NULL THEN 1 ELSE 0 END) AS null_hiv_status,
	SUM(CASE WHEN gene_xpert_results IS NULL THEN 1 ELSE 0 END) AS null_gene_xpert_results,
	SUM(CASE WHEN resistance IS NULL THEN 1 ELSE 0 END) AS null_resistance,
	SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS null_date,
	SUM(CASE WHEN tat_hours IS NULL THEN 1 ELSE 0 END) AS null_tat_hours
FROM tuberculosis_data;

-- Step 6: Demographic distribution
-- Sex distribution
SELECT sex, COUNT(*) AS count, ROUND((COUNT(*)/(SELECT COUNT(*) FROM tuberculosis_data))*100) AS percentage
FROM tuberculosis_data
GROUP BY sex;

-- Locality distribution
SELECT locality, COUNT(*) AS count, ROUND((COUNT(*)/(SELECT COUNT(*) FROM tuberculosis_data))*100) AS percentage
FROM tuberculosis_data
GROUP BY locality;

-- Ae group distribution
SELECT 
	CASE 
		WHEN age BETWEEN 0 AND 5 THEN '0-5'
		WHEN age BETWEEN 6 AND 18 THEN '6-18'
		WHEN age BETWEEN 19 AND 40 THEN '19-40'
		WHEN age BETWEEN 41 AND 60 THEN '41-60'
		WHEN age BETWEEN 61 AND 80 THEN '61-80'
        ELSE '81+'
	END AS age_groups, 
    COUNT(*) AS count, ROUND((COUNT(*)/(SELECT COUNT(*) FROM tuberculosis_data))*100) AS percentage
FROM tuberculosis_data
GROUP BY age_groups
ORDER BY age_groups;
    
-- HIV Status distribution
SELECT hiv_status, COUNT(*) AS count, ROUND((COUNT(*) / (SELECT COUNT(*) FROM tuberculosis_data))*100) AS percentage
FROM tuberculosis_data
GROUP BY hiv_status;

-- HIV Positivity among test
SELECT 
	(SUM(CASE WHEN hiv_status = 'positive' THEN 1 ELSE 0 END)/COUNT(*))*100 AS Percentage
FROM tuberculosis_data
WHERE hiv_status != 'not done';

-- Step 7: TB results distribution
-- GeneXpert results distribution
SELECT gene_xpert_results, COUNT(*) AS count, 
	ROUND((COUNT(*) / (SELECT COUNT(*) FROM tuberculosis_data))*100) AS percentage
FROM tuberculosis_data
GROUP BY gene_xpert_results;

-- Positivity by sex
SELECT sex, 
	ROUND((SUM(CASE WHEN gene_xpert_results = 'positive' THEN 1 ELSE 0 END)/COUNT(*))*100) AS percentage
FROM tuberculosis_data
GROUP BY sex;

-- Positivity by locality
SELECT locality, 
	ROUND((SUM(CASE WHEN gene_xpert_results = 'positive' THEN 1 ELSE 0 END)/COUNT(*))*100) AS percentage
FROM tuberculosis_data
GROUP BY locality;

-- Positivity by HIV Status
SELECT hiv_status, 
	ROUND((SUM(CASE WHEN gene_xpert_results = 'positive' THEN 1 ELSE 0 END)/COUNT(*))*100) AS percentage
FROM tuberculosis_data
WHERE hiv_status != 'not done'
GROUP BY hiv_status
;

-- Positivity by age_groups
SELECT
	CASE 
		WHEN age BETWEEN 0 AND 5 THEN '0-5'
        WHEN age BETWEEN 6 AND 18 THEN '6-18'
        WHEN age BETWEEN 19 AND 40 THEN '19-40'
        WHEN age BETWEEN 41 AND 60 THEN '41-60'
        WHEN age BETWEEN 61 AND 80 THEN '61-80'
        ELSE '81+'
	END AS age_groups,
		ROUND((SUM(CASE WHEN gene_xpert_results = 'positive' THEN 1 ELSE 0 END)/COUNT(*))*100,1) AS percentage
FROM tuberculosis_data
GROUP BY age_groups
ORDER BY age_groups;

-- Resistance distribution
SELECT resistance, COUNT(*) AS count, ROUND((COUNT(*) / (SELECT COUNT(*) FROM tuberculosis_data))*100,1) AS Percentage
FROM tuberculosis_data
GROUP BY resistance;

-- Resistance among TB positive
SELECT 
	(SUM(CASE WHEN resistance != 'not detected' THEN 1 ELSE 0 END)/COUNT(*))*100 AS percentage
FROM tuberculosis_data
WHERE gene_xpert_results = 'positive'
;

-- Additional insights on TB positive cases
SELECT AVG(age) AS avg_age
FROM tuberculosis_data
WHERE gene_xpert_results = 'positive';

-- Co-infectio rate (HIV + TB) among the HIV+
SELECT
	(SUM(CASE WHEN gene_xpert_results = 'positive' AND hiv_status = 'positive' THEN 1 ELSE 0 END) / COUNT(*))*100 AS percentage
FROM tuberculosis_data
WHERE hiv_status != 'not done';

-- Step 8: TAT analysis
-- Average TAT by GeneXpert results
SELECT gene_xpert_results AS results, ROUND(AVG(tat_hours)) AS avg_tat
FROM tuberculosis_data
GROUP BY results;

-- Average TAT by month
SELECT DATE_FORMAT(date, '%Y-%m') AS month, ROUND(AVG(tat_hours)) AS avg_date
FROM tuberculosis_data
GROUP BY month
ORDER BY month;

-- Step 9: Temporal trend
-- Number of cases by month
SELECT DATE_FORMAT(date, '%Y-%m') AS month, COUNT(*) AS count
FROM tuberculosis_data
GROUP BY month
ORDER BY month;

-- Positive cases by month
SELECT DATE_FORMAT(date, '%Y-%m') AS month, ROUND((SUM(CASE WHEN gene_xpert_results = 'positive' THEN 1 ELSE 0 END)/COUNT(*))*100,1) AS percentage
FROM tuberculosis_data
GROUP BY month
ORDER BY month;





















