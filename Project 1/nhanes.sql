CREATE DATABASE nhanes_db;

USE nhanes_db;

CREATE TABLE nhanes_tb (
sequence_number	INT,
age_group	TEXT,
age INT,	
gender	TEXT,
physical_activity TEXT,	
body_mass_index	INT,
fasting_blood_glucose INT, 	
diabetic_status	TEXT,
diabetic_score INT,
oral_score	INT,
insulin_levels INT
);

LOAD DATA INFILE 'nhanes_mod.csv'
INTO TABLE nhanes_tb
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
;

SELECT *
FROM nhanes_tb;

-- PROBLEM: This dataset as dependat variable and independent variables. The dependent variable uses the others to determine its value
--          Therefore, the problem here is -- which factors contribute to diabetes

-- PHASE 2: EXPLORATORY DATA ANALYSIS
-- 1) this is the data infor
DESCRIBE nhanes_tb;

-- 2) summary stats
SELECT DISTINCT COUNT(sequence_number)
FROM nhanes_tb; -- This study had 2220 participants

SELECT AVG(age), STDDEV(age),VARIANCE(age)
FROM nhanes_tb
;


SELECT age_group,COUNT(age_group)
FROM nhanes_tb
GROUP BY age_group;
-- most of the participants were adults

SELECT gender, COUNT(gender)
FROM nhanes_tb
GROUP BY gender; -- females take the bigger chuck of it by a small difference

SELECT physical_activity, COUNT(physical_activity) as comparison
FROM nhanes_tb
GROUP BY physical_activity
; -- most of them dont engage in physical activity

DELETE
FROM nhanes_tb
WHERE physical_activity = '7'
;

SELECT diabetic_status, COUNT(diabetic_status)
FROM nhanes_tb
GROUP BY diabetic_status;

DELETE
FROM nhanes_tb
WHERE diabetic_status = '3'
;

-- this is a data to see the age distribution with histograms
SELECT age
FROM nhanes_tb;

-- this is data to see relationships
SELECT body_mass_index, diabetic_score
FROM nhanes_tb;

-- PHASE 2: data cleaning
WITH duplicate_identifier as (
SELECT ROW_NUMBER() OVER(PARTITION BY sequence_number,age_group,age,gender,physical_activity,body_mass_index,fasting_blood_glucose,diabetic_status,diabetic_score,oral_score,insulin_levels) as row_num
FROM nhanes_tb)
SELECT *
FROM duplicate_identifier
WHERE row_num > 1; -- no duplicates found.

-- Phase 4: in depth analysis
SELECT 
(COUNT(*)*SUM(body_mass_index*diabetic_score)-SUM(body_mass_index)*SUM(diabetic_score))
/
SQRT((COUNT(*)*SUM(body_mass_index*body_mass_index)-POW(SUM(body_mass_index),2))*(COUNT(*)*SUM(diabetic_score*diabetic_score)-POW(SUM(diabetic_score),2)))
FROM nhanes_tb; -- there is no relationship between BMI and diabetic score

SELECT 
(COUNT(*)*SUM(insulin_levels*diabetic_score)-SUM(insulin_levels)*SUM(diabetic_score))
/
SQRT((COUNT(*)*SUM(insulin_levels*insulin_levels)-POW(SUM(insulin_levels),2))*(COUNT(*)*SUM(diabetic_score*diabetic_score)-POW(SUM(diabetic_score),2)))
FROM nhanes_tb; -- there is no correlation between insulin levels and diabetic score

SELECT 
(COUNT(*)*SUM(fasting_blood_glucose*diabetic_score)-SUM(fasting_blood_glucose)*SUM(diabetic_score))
/
SQRT((COUNT(*)*SUM(fasting_blood_glucose*fasting_blood_glucose)-POW(SUM(fasting_blood_glucose),2))*(COUNT(*)*SUM(diabetic_score*diabetic_score)-POW(SUM(diabetic_score),2)))
FROM nhanes_tb
; -- no correlation

-- Segmentation
CREATE TEMPORARY TABLE diabetic_positive
SELECT *
FROM nhanes_tb
WHERE diabetic_score = 1
;

SELECT AVG(age),STDDEV(age), VARIANCE(age)
FROM diabetic_positive
; -- avg_age is 60

SELECT gender, COUNT(*)
FROM diabetic_positive
GROUP BY gender; -- females make up the high percentage

SELECT age_group, COUNT(*)
FROM diabetic_positive
GROUP BY age_group; -- most of them are adults

SELECT *
FROM diabetic_positive; -- a totoal of 21 are diabetic positive out of 2219

SELECT physical_activity, COUNT(*)
FROM diabetic_positive
GROUP BY physical_activity; -- most of them dont exercise

SELECT MAX(insulin_levels), MIN(insulin_levels)
FROM diabetic_positive
;

SELECT MAX(insulin_levels), MIN(insulin_levels)
FROM nhanes_tb
WHERE diabetic_score = 2
; -- from this we cant say that insulin levels affect the probability of someone having diabetes

SELECT MAX(fasting_blood_glucose), MIN(fasting_blood_glucose)
FROM diabetic_positive
;

SELECT MAX(fasting_blood_glucose), MIN(fasting_blood_glucose)
FROM nhanes_tb
WHERE diabetic_score = 2
;

SELECT MAX(body_mass_index), MIN(body_mass_index)
FROM diabetic_positive
;

SELECT MAX(body_mass_index), MIN(body_mass_index)
FROM nhanes_tb
WHERE diabetic_score = 2
;




