-- Create the database and the Table
CREATE DATABASE tuberculosis_trial;
USE tuberculosis_trial;

CREATE TABLE strep_tuberculosis(
row_id INT PRIMARY KEY,
patient_id INT, 
arm VARCHAR(20),
dose_strep_g DECIMAL(3,1),
dose_PAS_g DECIMAL(3,1),
gender CHAR(1),
baseline_condition VARCHAR(20),
baseline_temp VARCHAR(50),
baseline_esr VARCHAR(20),
baseline_cavitation VARCHAR(10),
strep_resistance VARCHAR(20),
radiologic_6m VARCHAR(50),
rad_num INT,
improved VARCHAR(10)
);

-- Load data into MySQL
LOAD DATA INFILE "strep_tb.csv"
INTO TABLE strep_tuberculosis
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- DATA CLEANING AND VALIDATION

-- Check for duplicates
SELECT patient_id, COUNT(*) AS count
FROM strep_tuberculosis
GROUP BY patient_id
HAVING count > 1;  -- No duplicates

-- Find missing values
SELECT
	SUM(CASE WHEN patient_id IS NULL OR patient_id = ' ' THEN 1 ELSE 0 END) AS Missing_id,
    SUM(CASE WHEN arm IS NULL OR arm = ' ' THEN 1 ELSE 0 END) AS Missing_arm,
    SUM(CASE WHEN dose_strep_g IS NULL OR dose_strep_g = ' ' THEN 1 ELSE 0 END) AS Missing_dose_strep,
    SUM(CASE WHEN dose_PAS_g IS NULL OR dose_PAS_g = ' ' THEN 1 ELSE 0 END) AS Missing_pas_g,
    SUM(CASE WHEN gender IS NULL OR gender = ' ' THEN 1 ELSE 0 END) AS Missing_gender,
     SUM(CASE WHEN baseline_condition IS NULL OR baseline_condition = ' ' THEN 1 ELSE 0 END) AS missing_condition,
    SUM(CASE WHEN baseline_temp IS NULL OR baseline_temp = ' ' THEN 1 ELSE 0 END) AS missing_temp,
	SUM(CASE WHEN baseline_esr IS NULL OR baseline_esr = ' ' THEN 1 ELSE 0 END) AS missing_esr,
    SUM(CASE WHEN baseline_cavitation IS NULL OR baseline_cavitation = ' ' THEN 1 ELSE 0 END) AS missing_cavitation,
    SUM(CASE WHEN strep_resistance IS NULL OR strep_resistance = ' ' THEN 1 ELSE 0 END) AS missing_resistance,
    SUM(CASE WHEN radiologic_6m IS NULL OR radiologic_6m = ' ' THEN 1 ELSE 0 END) AS missing_radiologic,
    SUM(CASE WHEN rad_num IS NULL OR rad_num = ' ' THEN 1 ELSE 0 END) AS missing_rad_num,
    SUM(CASE WHEN improved IS NULL OR improved = ' ' THEN 1 ELSE 0 END) AS missing_improved
FROM strep_tuberculosis;

-- Deleting unnecessary Columns
ALTER TABLE strep_tuberculosis
DROP COLUMN dose_PAS_g;

-- Standardizing Categorical values
UPDATE strep_tuberculosis
SET baseline_temp = '2_99-99.9F/37.3-37.7C'
WHERE baseline_temp = '%37.3-37.7C/37.3-37.7C%';

-- Create clean numerical and categorical mapping
ALTER TABLE strep_tuberculosis
ADD COLUMN cond_level INT;

UPDATE strep_tuberculosis
SET cond_level = 
		CASE 
			WHEN baseline_condition = '1_Good' THEN 1
			WHEN baseline_condition = '2_Fair' THEN 2
            WHEN baseline_condition = '3_Poor' THEN 3
		END;

ALTER TABLE strep_tuberculosis
ADD COLUMN temp_level INT;

UPDATE strep_tuberculosis
SET temp_level =
		CAST(SUBSTRING_INDEX(baseline_temp, '_',1)AS UNSIGNED);
        
ALTER TABLE strep_tuberculosis
ADD COLUMN esr_level INT;

UPDATE strep_tuberculosis
SET esr_level =
		CASE 
			WHEN baseline_esr = '2_11-20' THEN 2
            WHEN baseline_esr = '3_21-50' THEN 3
            WHEN baseline_esr = '4_51+' THEN 4
		END;
        
ALTER TABLE strep_tuberculosis
ADD COLUMN resist_level INT;

UPDATE strep_tuberculosis
SET resist_level = 
		CAST(SUBSTRING_INDEX(strep_resistance,'_',1)AS UNSIGNED);

-- EXPLORATORY DATA ANALYSIS

-- Total patients by arm
SELECT arm, COUNT(*) AS total, ROUND((COUNT(*)/(SELECT COUNT(*) FROM strep_tuberculosis))*100) AS pct
FROM strep_tuberculosis
GROUP BY arm;

-- Gender distribution by Arm
SELECT gender, arm, COUNT(*) AS total, ROUND((COUNT(*)/(SELECT COUNT(*) FROM strep_tuberculosis))*100) AS pct
FROM strep_tuberculosis
GROUP BY gender, arm;

-- Baseline condition distribution
SELECT baseline_condition, COUNT(*) AS count, ROUND((COUNT(*)/(SELECT COUNT(*) FROM strep_tuberculosis))*100) AS pct
FROM strep_tuberculosis
GROUP BY baseline_condition;

-- Radiologic 6m distribution by arm
SELECT arm,
   	SUM(CASE WHEN radiologic_6m = '1_Death'THEN 1 ELSE 0 END) AS Deaths,
	SUM(CASE WHEN radiologic_6m = '2_Considerable_deterioration'THEN 1 ELSE 0 END) AS Considerable_deterioration,
	SUM(CASE WHEN radiologic_6m = '3_Moderate_deterioration'THEN 1 ELSE 0 END) AS Moderate_deterioration,
	SUM(CASE WHEN radiologic_6m = '4_No_change'THEN 1 ELSE 0 END) AS No_change,
	SUM(CASE WHEN radiologic_6m = '5_Moderate_improvement'THEN 1 ELSE 0 END) AS Moderate_deterioration,
	SUM(CASE WHEN radiologic_6m = '6_Considerable_improvement'THEN 1 ELSE 0 END) AS Considerable_improvement,
    ROUND((COUNT(*)/(SELECT COUNT(*) FROM strep_tuberculosis))*100) AS pct
FROM strep_tuberculosis
GROUP BY arm;

-- Full radiologic distribution outcome BY ARM
SELECT arm, radiologic_6m, rad_num, 
		COUNT(*) AS count, ROUND((COUNT(*)/(SELECT COUNT(*) FROM strep_tuberculosis))*100) AS pct
FROM strep_tuberculosis
GROUP BY arm, radiologic_6m, rad_num
ORDER BY arm, rad_num DESC;

-- Improvement by baseline condition
SELECT arm, baseline_condition, improved, COUNT(*) AS count, ROUND((COUNT(*)/(SELECT COUNT(*) FROM strep_tuberculosis))*100) AS pct
FROM strep_tuberculosis
GROUP BY baseline_condition, improved, arm
ORDER BY arm, baseline_condition DESC;

SELECT LENGTH(improved)
FROM strep_tuberculosis; -- there is some white space in the improved column

UPDATE strep_tuberculosis
SET improved = TRIM(improved);

-- Outcome by baseline cavitation
SELECT arm, baseline_cavitation, COUNT(*) AS total,
	ROUND((SUM(CASE WHEN rad_num >= 5 THEN 1 ELSE 0 END)/(SELECT COUNT(*) FROM strep_tuberculosis))*100) AS pct
FROM strep_tuberculosis
GROUP BY arm, baseline_cavitation;

-- Streptomycin resistance by outcome
SELECT 
	strep_resistance, 
    ROUND(AVG(rad_num)) AS rad_num, COUNT(*) AS n
FROM strep_tuberculosis
WHERE arm = 'Streptomycin'
GROUP BY strep_resistance;

-- Risk of death top predictors
SELECT 
	baseline_condition,
    baseline_temp,
    baseline_cavitation,
    arm, 
    COUNT(*) AS n,
    SUM(CASE WHEN rad_num = 1 THEN 1 ELSE 0 END) AS deaths,
    ROUND( (SUM(CASE WHEN rad_num = 1 THEN 1 ELSE 0 END)/ (SELECT COUNT(*) FROM strep_tuberculosis))*100 ) AS pct
FROM strep_tuberculosis
GROUP BY baseline_condition,baseline_temp,baseline_cavitation,arm
ORDER BY deaths DESC;

-- High risk profile
SELECT COUNT(*) AS high_risk_control
FROM strep_tuberculosis
WHERE baseline_condition = '3_Poor'
  AND temp_level >= 3
  AND baseline_cavitation = 'yes'
  AND arm = 'Control';

-- Correlation matrix (numerical values)
	-- rad_num vs baseline severity
	SELECT 
    -- Correlation: rad_num vs cond_level
    ROUND(
        (COUNT(*) * SUM(rad_num * cond_level) - SUM(rad_num) * SUM(cond_level)) /
        SQRT(
            (COUNT(*) * SUM(rad_num * rad_num) - SUM(rad_num) * SUM(rad_num)) *
            (COUNT(*) * SUM(cond_level * cond_level) - SUM(cond_level) * SUM(cond_level))
        )
    , 3) AS corr_rad_condition,

    -- Correlation: rad_num vs temp_level
    ROUND(
        (COUNT(*) * SUM(rad_num * temp_level) - SUM(rad_num) * SUM(temp_level)) /
        SQRT(
            (COUNT(*) * SUM(rad_num * rad_num) - SUM(rad_num) * SUM(rad_num)) *
            (COUNT(*) * SUM(temp_level * temp_level) - SUM(temp_level) * SUM(temp_level))
        )
    , 3) AS corr_rad_temp,

    -- Correlation: rad_num vs esr_level
    ROUND(
        (COUNT(*) * SUM(rad_num * esr_level) - SUM(rad_num) * SUM(esr_level)) /
        SQRT(
            (COUNT(*) * SUM(rad_num * rad_num) - SUM(rad_num) * SUM(rad_num)) *
            (COUNT(*) * SUM(esr_level * esr_level) - SUM(esr_level) * SUM(esr_level))
        )
    , 3) AS corr_rad_esr
FROM strep_tuberculosis
WHERE cond_level IS NOT NULL 
  AND temp_level IS NOT NULL 
  AND esr_level IS NOT NULL;

-- Survival benefit
SELECT
	(SELECT COUNT(*) FROM strep_tuberculosis WHERE arm = 'Control'AND rad_num = 1) as control_deaths,
    (SELECT COUNT(*) FROM strep_tuberculosis WHERE arm = 'Streptomycin' AND rad_num = 1) as Strept_deaths,
    (SELECT COUNT(*) FROM strep_tuberculosis WHERE arm = 'Control'AND rad_num = 1) - 
    (SELECT COUNT(*) FROM strep_tuberculosis WHERE arm = 'Streptomycin' AND rad_num = 1) as DIFF
;

-- One query clinical dashboard
SELECT 
    '-- SUMMARY DASHBOARD --' AS report,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN arm = 'Control' THEN 1 ELSE 0 END) AS n_control,
    SUM(CASE WHEN arm = 'Streptomycin' THEN 1 ELSE 0 END) AS n_strep,
    ROUND(100.0 * SUM(CASE WHEN improved = '%TRUE%' AND arm = 'Streptomycin' THEN 1 ELSE 0 END) / 
          SUM(CASE WHEN arm = 'Streptomycin' THEN 1 ELSE 0 END), 1) AS strep_improve_pct,
    ROUND(100.0 * SUM(CASE WHEN improved = '%TRUE%' AND arm = 'Control' THEN 1 ELSE 0 END) / 
          SUM(CASE WHEN arm = 'Control' THEN 1 ELSE 0 END), 1) AS control_improve_pct,
    ROUND(100.0 * SUM(CASE WHEN rad_num = 1 AND arm = 'Control' THEN 1 ELSE 0 END) / 
          SUM(CASE WHEN arm = 'Control' THEN 1 ELSE 0 END), 1) AS control_mortality_pct,
    ROUND(100.0 * SUM(CASE WHEN rad_num = 1 AND arm = 'Streptomycin' THEN 1 ELSE 0 END) / 
          SUM(CASE WHEN arm = 'Streptomycin' THEN 1 ELSE 0 END), 1) AS strep_mortality_pct
FROM strep_tuberculosis;
















