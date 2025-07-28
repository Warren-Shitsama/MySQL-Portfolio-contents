CREATE DATABASE synthetic_prostate_risk_assessment;

USE synthetic_prostate_risk_assessment;

CREATE TABLE risk_factors(
id	INT,
age	INT,
bmi	INT,
smoker	TEXT,
alcohol_consumption	TEXT,
diet_type	TEXT,
physical_activity_level	TEXT,
family_history	TEXT,
mental_stress_level	TEXT,
sleep_hours	INT,
regular_health_checkup	TEXT,
prostate_exam_done	TEXT,
risk_level	TEXT,
risk_level_number INT
);

LOAD DATA INFILE 'synthetic_prostate_cancer_risk.csv'
INTO TABLE risk_factors
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 1
-- Objective - to identify the factors that lead to prostate cancer
-- Data - is factors in numerical or categorical format that influence the risk of getting prostate cancer

-- 2 :  Intial inspection
-- examine first / last rows - To check data structure and content
SELECT *
FROM risk_factors
LIMIT 5;

-- check data types - verify if data is interpreted correctly
DESCRIBE risk_factors;

-- Summarize basic statistics
      -- Descriptive Statistics (MIN, MAX, STDDEV, AVG, VARIANCE) for numerical values
SELECT MIN(age) MIN, MAX(age) MAX, ROUND(STDDEV(age)) STDDEV, ROUND(AVG(age)) AVG,ROUND(VARIANCE(age)) VARIANCE
FROM risk_factors;

SELECT MIN(bmi) MIN, MAX(bmi) MAX, ROUND(STDDEV(bmi)) STDDEV, ROUND(AVG(bmi)) AVG,ROUND(VARIANCE(bmi)) VARIANCE
FROM risk_factors;

SELECT MIN(sleep_hours) MIN, MAX(sleep_hours) MAX, ROUND(STDDEV(sleep_hours)) STDDEV, ROUND(AVG(sleep_hours)) AVG,ROUND(VARIANCE(sleep_hours)) VARIANCE
FROM risk_factors;

	-- Frequency count for categorical columns
SELECT smoker, COUNT(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM risk_factors)) * 100) AS freq_percentage
FROM risk_factors
GROUP BY smoker;

SELECT alcohol_consumption, COUNT(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM risk_factors)) * 100) AS freq_percentage
FROM risk_factors
GROUP BY alcohol_consumption;

SELECT diet_type, COUNT(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM risk_factors)) * 100) AS freq_percentage
FROM risk_factors
GROUP BY diet_type;

SELECT physical_activity_level, COUNT(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM risk_factors)) * 100) AS freq_percentage
FROM risk_factors
GROUP BY physical_activity_level;

SELECT family_history, COUNT(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM risk_factors)) * 100) AS freq_percentage
FROM risk_factors
GROUP BY family_history;

SELECT mental_stress_level, COUNT(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM risk_factors)) * 100) AS freq_percentage
FROM risk_factors
GROUP BY mental_stress_level;

SELECT regular_health_checkup, COUNT(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM risk_factors)) * 100) AS freq_percentage
FROM risk_factors
GROUP BY regular_health_checkup;

SELECT prostate_exam_done, COUNT(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM risk_factors)) * 100) AS freq_percentage
FROM risk_factors
GROUP BY prostate_exam_done;

SELECT risk_level, COUNT(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM risk_factors)) * 100) AS freq_percentage
FROM risk_factors
GROUP BY risk_level;

-- Determine if there is any missing values
SELECT *
FROM risk_factors
WHERE age IS NULL; -- NO NULL a

SELECT *
FROM risk_factors
WHERE bmi IS NULL; -- no null

SELECT *
FROM risk_factors
WHERE smoker IS NULL; -- no null

SELECT *
FROM risk_factors
WHERE alcohol_consumption IS NULL; -- no null

SELECT *
FROM risk_factors
WHERE diet_type IS NULL; -- no null

SELECT *
FROM risk_factors
WHERE physical_activity_level IS NULL; -- no null

SELECT *
FROM risk_factors
WHERE family_history IS NULL; -- no null

SELECT *
FROM risk_factors
WHERE sleep_hours IS NULL; -- no null

SELECT *
FROM risk_factors
WHERE regular_health_checkup IS NULL; -- no null

SELECT *
FROM risk_factors
WHERE prostate_exam_done IS NULL; -- no null

SELECT *
FROM risk_factors
WHERE risk_level IS NULL; -- no null

-- 3: Exploratory Data Analysis
	-- Distribution analysis
    SELECT age
    FROM risk_factors; -- data for histogram
    
    SELECT bmi
    FROM risk_factors; -- data for box plot
    
    SELECT sleep_hours
    FROM risk_factors; -- data for histogram
    
-- Relationship analysis
	-- Category vs Category
SELECT smoker, COUNT(*) AS smoker_population, 
		SUM(CASE WHEN risk_level LIKE '%low%' THEN 1 ELSE 0 END) AS Low_risk_population,
        SUM(CASE WHEN risk_level like '%Medium%' THEN 1 ELSE 0 END) AS Medium_risk_population,
        SUM(CASE WHEN risk_level LIKE '%High%' THEN 1 ELSE 0 END) AS High_risk_population,
        (SUM(CASE WHEN risk_level LIKE '%Low%' THEN 1 ELSE 0 END) / COUNT(*))*100 AS Low_risk_percentage,
        (SUM(CASE WHEN risk_level like '%Medium%' THEN 1 ELSE 0 END ) / COUNT(*))*100 AS Medium_risk_percentage,
        (SUM(CASE WHEN risk_level LIKE '%High%' THEN 1 ELSE 0 END) / COUNT(*))*100 AS High_risk_percentage
FROM risk_factors
GROUP BY smoker;

SELECT alcohol_consumption, COUNT(*) AS smoker_population, 
		SUM(CASE WHEN risk_level LIKE '%low%' THEN 1 ELSE 0 END) AS Low_risk_population,
        SUM(CASE WHEN risk_level like '%Medium%' THEN 1 ELSE 0 END) AS Medium_risk_population,
        SUM(CASE WHEN risk_level LIKE '%High%' THEN 1 ELSE 0 END) AS High_risk_population,
        (SUM(CASE WHEN risk_level LIKE '%Low%' THEN 1 ELSE 0 END) / COUNT(*))*100 AS Low_risk_percentage,
        (SUM(CASE WHEN risk_level like '%Medium%' THEN 1 ELSE 0 END ) / COUNT(*))*100 AS Medium_risk_percentage,
        (SUM(CASE WHEN risk_level LIKE '%High%' THEN 1 ELSE 0 END) / COUNT(*))*100 AS High_risk_percentage
FROM risk_factors
GROUP BY alcohol_consumption;

SELECT diet_type, COUNT(*) AS smoker_population, 
		SUM(CASE WHEN risk_level LIKE '%low%' THEN 1 ELSE 0 END) AS Low_risk_population,
        SUM(CASE WHEN risk_level like '%Medium%' THEN 1 ELSE 0 END) AS Medium_risk_population,
        SUM(CASE WHEN risk_level LIKE '%High%' THEN 1 ELSE 0 END) AS High_risk_population,
        (SUM(CASE WHEN risk_level LIKE '%Low%' THEN 1 ELSE 0 END) / COUNT(*))*100 AS Low_risk_percentage,
        (SUM(CASE WHEN risk_level like '%Medium%' THEN 1 ELSE 0 END ) / COUNT(*))*100 AS Medium_risk_percentage,
        (SUM(CASE WHEN risk_level LIKE '%High%' THEN 1 ELSE 0 END) / COUNT(*))*100 AS High_risk_percentage
FROM risk_factors
GROUP BY diet_type;

SELECT physical_activity_level, COUNT(*) AS smoker_population, 
		SUM(CASE WHEN risk_level LIKE '%low%' THEN 1 ELSE 0 END) AS Low_risk_population,
        SUM(CASE WHEN risk_level like '%Medium%' THEN 1 ELSE 0 END) AS Medium_risk_population,
        SUM(CASE WHEN risk_level LIKE '%High%' THEN 1 ELSE 0 END) AS High_risk_population,
        (SUM(CASE WHEN risk_level LIKE '%Low%' THEN 1 ELSE 0 END) / COUNT(*))*100 AS Low_risk_percentage,
        (SUM(CASE WHEN risk_level like '%Medium%' THEN 1 ELSE 0 END ) / COUNT(*))*100 AS Medium_risk_percentage,
        (SUM(CASE WHEN risk_level LIKE '%High%' THEN 1 ELSE 0 END) / COUNT(*))*100 AS High_risk_percentage
FROM risk_factors
GROUP BY physical_activity_level;

SELECT family_history, COUNT(*) AS smoker_population, 
		SUM(CASE WHEN risk_level LIKE '%low%' THEN 1 ELSE 0 END) AS Low_risk_population,
        SUM(CASE WHEN risk_level like '%Medium%' THEN 1 ELSE 0 END) AS Medium_risk_population,
        SUM(CASE WHEN risk_level LIKE '%High%' THEN 1 ELSE 0 END) AS High_risk_population,
        (SUM(CASE WHEN risk_level LIKE '%Low%' THEN 1 ELSE 0 END) / COUNT(*))*100 AS Low_risk_percentage,
        (SUM(CASE WHEN risk_level like '%Medium%' THEN 1 ELSE 0 END ) / COUNT(*))*100 AS Medium_risk_percentage,
        (SUM(CASE WHEN risk_level LIKE '%High%' THEN 1 ELSE 0 END) / COUNT(*))*100 AS High_risk_percentage
FROM risk_factors
GROUP BY family_history;

SELECT mental_stress_level, COUNT(*) AS smoker_population, 
		SUM(CASE WHEN risk_level LIKE '%low%' THEN 1 ELSE 0 END) AS Low_risk_population,
        SUM(CASE WHEN risk_level like '%Medium%' THEN 1 ELSE 0 END) AS Medium_risk_population,
        SUM(CASE WHEN risk_level LIKE '%High%' THEN 1 ELSE 0 END) AS High_risk_population,
        (SUM(CASE WHEN risk_level LIKE '%Low%' THEN 1 ELSE 0 END) / COUNT(*))*100 AS Low_risk_percentage,
        (SUM(CASE WHEN risk_level like '%Medium%' THEN 1 ELSE 0 END ) / COUNT(*))*100 AS Medium_risk_percentage,
        (SUM(CASE WHEN risk_level LIKE '%High%' THEN 1 ELSE 0 END) / COUNT(*))*100 AS High_risk_percentage
FROM risk_factors
GROUP BY mental_stress_level;

SELECT regular_health_checkup, COUNT(*) AS smoker_population, 
		SUM(CASE WHEN risk_level LIKE '%low%' THEN 1 ELSE 0 END) AS Low_risk_population,
        SUM(CASE WHEN risk_level like '%Medium%' THEN 1 ELSE 0 END) AS Medium_risk_population,
        SUM(CASE WHEN risk_level LIKE '%High%' THEN 1 ELSE 0 END) AS High_risk_population,
        (SUM(CASE WHEN risk_level LIKE '%Low%' THEN 1 ELSE 0 END) / COUNT(*))*100 AS Low_risk_percentage,
        (SUM(CASE WHEN risk_level like '%Medium%' THEN 1 ELSE 0 END ) / COUNT(*))*100 AS Medium_risk_percentage,
        (SUM(CASE WHEN risk_level LIKE '%High%' THEN 1 ELSE 0 END) / COUNT(*))*100 AS High_risk_percentage
FROM risk_factors
GROUP BY regular_health_checkup;

SELECT prostate_exam_done, COUNT(*) AS smoker_population, 
		SUM(CASE WHEN risk_level LIKE '%low%' THEN 1 ELSE 0 END) AS Low_risk_population,
        SUM(CASE WHEN risk_level like '%Medium%' THEN 1 ELSE 0 END) AS Medium_risk_population,
        SUM(CASE WHEN risk_level LIKE '%High%' THEN 1 ELSE 0 END) AS High_risk_population,
        (SUM(CASE WHEN risk_level LIKE '%Low%' THEN 1 ELSE 0 END) / COUNT(*))*100 AS Low_risk_percentage,
        (SUM(CASE WHEN risk_level like '%Medium%' THEN 1 ELSE 0 END ) / COUNT(*))*100 AS Medium_risk_percentage,
        (SUM(CASE WHEN risk_level LIKE '%High%' THEN 1 ELSE 0 END) / COUNT(*))*100 AS High_risk_percentage
FROM risk_factors
GROUP BY prostate_exam_done;

	-- Numerical vs Category
SELECT  risk_level,AVG(age) AS avg_age
FROM risk_factors
GROUP BY risk_level
ORDER BY FIELD(risk_level, 'Low', 'Medium', 'High');

SELECT AVG(bmi) AS avg_bmi, risk_level
FROM risk_factors
GROUP BY risk_level
ORDER BY FIELD(risk_level, 'Low', 'Medium', 'High');

SELECT risk_level, AVG(sleep_hours) AS avg_sleep_hours
FROM risk_factors
GROUP BY risk_level
ORDER BY FIELD(risk_level, 'Low', 'Medium', 'High');

SELECT *
FROM risk_factors;
























































