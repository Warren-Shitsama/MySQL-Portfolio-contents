CREATE DATABASE mental_health;

USE mental_health;

CREATE TABLE driving_factors(
id	INT,
Name	TEXT,
Gender	TEXT,
Age	INT,
Age_group TEXT,
City	TEXT,
working_professional_or_student	TEXT,
Profession	TEXT,
academic_pressure INT,	
CGPA	DECIMAL (4,2),
study_satisfaction	INT,
job_satisfaction	INT,
sleep_duration	TEXT,
dietary_habits	TEXT,
Degree	TEXT,
sucidal_thoughts	TEXT,
work_study_hours	INT,
Financila_stress	INT,
family_history_of_mental_illness	TEXT,
Depression INT
);

LOAD DATA INFILE 'Mental health.csv'
INTO TABLE driving_factors
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
;

-- 1. Understand problem and data
		-- The dataset has numerical and categorical variables that influence differently the mental state of a person.
        -- The objective is therefore to identify which factors lead to depression and which don't or reduce stress
        
-- 2. Data loading and initial inspection
	-- examine first / last rows
		SELECT *
		FROM driving_factors
		LIMIT 5; -- For structure

	-- Check data types 
    DESCRIBE driving_factors;
    
    -- Descriptive statistics for numerical variables
    SELECT ROUND(AVG(Age)) AVG, MIN(Age) MIN, MAX(Age) MAX, ROUND(STDDEV(Age)) STDDEV, ROUND(VARIANCE(Age)) VARIANCE
    FROM driving_factors;
    
      SELECT ROUND(AVG(CGPA)) AVG, MIN(CGPA) MIN, MAX(CGPA) MAX, ROUND(STDDEV(CGPA)) STDDEV, ROUND(VARIANCE(CGPA)) VARIANCE
	  FROM driving_factors;

       SELECT ROUND(AVG(work_study_hours)) AVG, MIN(work_study_hours) MIN, MAX(work_study_hours) MAX, ROUND(STDDEV(work_study_hours)) STDDEV, ROUND(VARIANCE(work_study_hours)) VARIANCE
	   FROM driving_factors;
       
	-- Categorical frequency
		SELECT Gender, COUNT(*) AS total_number, (COUNT(*) / (SELECT COUNT(*) FROM driving_factors))*100 AS total_percentage
        FROM driving_factors
        GROUP BY Gender;
    
		SELECT working_professional_or_student, COUNT(*) AS total_number, COUNT(*) / (SELECT COUNT(*) FROM driving_factors)*100 AS total_percentage
        FROM driving_factors
        GROUP BY working_professional_or_student;
        
        SELECT Profession, COUNT(*) AS total_number, COUNT(*) / (SELECT COUNT(*) FROM driving_factors) * 100 AS total_percentage
        FROM driving_factors
        GROUP BY Profession;
        
		SELECT sleep_duration, COUNT(*) AS total_number, COUNT(*) / (SELECT COUNT(*) FROM driving_factors) * 100 AS total_percentage
        FROM driving_factors
        GROUP BY sleep_duration;
        
        SELECT dietary_habits, COUNT(*) AS total_number, COUNT(*) / (SELECT COUNT(*) FROM driving_factors)*100 AS total_percentage
        FROM driving_factors
        GROUP BY dietary_habits;
        
        SELECT sucidal_thoughts, COUNT(*) AS total_number, COUNT(*) / (SELECT COUNT(*) FROM driving_factors) *100 AS total_percentage
        FROM driving_factors
        GROUP BY sucidal_thoughts;
        
		SELECT family_history_of_mental_illness, COUNT(*) AS total_number, COUNT(*) / (SELECT COUNT(*) FROM driving_factors)*100 AS total_percentage
         FROM driving_factors
        GROUP BY family_history_of_mental_illness;

-- 3. Exploratory Data Analysis
			-- Distribution analysis
            SELECT Age
            FROM driving_factors; -- data for histogram
            
            SELECT CGPA
            FROM driving_factors; -- data for histogram
            
            -- Relationship analysis
            SELECT Gender, 
					COUNT(*) AS total_population,
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depressed,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) AS not_depressed,
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) / COUNT(*) *100 AS depressed_percentage,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) / COUNT(*)*100 AS not_depressed_percentage
			FROM driving_factors
            GROUP BY Gender;
            
            SELECT working_professional_or_student,
					COUNT(*),
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depressed_population,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) AS not_depressed_population,
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) / count(*) * 100 AS depressed_percentage,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) / count(*) * 100 AS not_depressed_perecntage
			FROM driving_factors
            GROUP BY working_professional_or_student;
            
             SELECT Profession,
					COUNT(*),
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depressed_population,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) AS not_depressed_population,
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) / count(*) * 100 AS depressed_percentage,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) / count(*) * 100 AS not_depressed_perecntage
			FROM driving_factors
            GROUP BY Profession;
            
            SELECT sleep_duration,
					COUNT(*),
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depressed_population,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) AS not_depressed_population,
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) / count(*) * 100 AS depressed_percentage,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) / count(*) * 100 AS not_depressed_perecntage
			FROM driving_factors
            GROUP BY sleep_duration;
            
             SELECT sleep_duration,
					COUNT(*),
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depressed_population,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) AS not_depressed_population,
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) / count(*) * 100 AS depressed_percentage,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) / count(*) * 100 AS not_depressed_perecntage
			FROM driving_factors
            GROUP BY sleep_duration;       
       
			 SELECT Degree,
					COUNT(*),
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depressed_population,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) AS not_depressed_population,
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) / count(*) * 100 AS depressed_percentage,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) / count(*) * 100 AS not_depressed_perecntage
			FROM driving_factors
            GROUP BY Degree;
	
			SELECT sucidal_thoughts,
					COUNT(*),
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depressed_population,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) AS not_depressed_population,
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) / count(*) * 100 AS depressed_percentage,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) / count(*) * 100 AS not_depressed_perecntage
			FROM driving_factors
            GROUP BY sucidal_thoughts;
            
            SELECT family_history_of_mental_illness,
					COUNT(*),
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depressed_population,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) AS not_depressed_population,
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) / count(*) * 100 AS depressed_percentage,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) / count(*) * 100 AS not_depressed_perecntage
			FROM driving_factors
            GROUP BY family_history_of_mental_illness;

			SELECT academic_pressure,
					COUNT(*),
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depressed_population,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) AS not_depressed_population,
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) / count(*) * 100 AS depressed_percentage,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) / count(*) * 100 AS not_depressed_perecntage
			FROM driving_factors
            GROUP BY academic_pressure;
            
            SELECT study_satisfaction,
					COUNT(*),
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depressed_population,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) AS not_depressed_population,
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) / count(*) * 100 AS depressed_percentage,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) / count(*) * 100 AS not_depressed_perecntage
			FROM driving_factors
            GROUP BY study_satisfaction;

			SELECT job_satisfaction,
					COUNT(*),
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depressed_population,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) AS not_depressed_population,
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) / count(*) * 100 AS depressed_percentage,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) / count(*) * 100 AS not_depressed_perecntage
			FROM driving_factors
            GROUP BY job_satisfaction;
            
            SELECT financial_stress,
					COUNT(*),
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depressed_population,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) AS not_depressed_population,
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) / count(*) * 100 AS depressed_percentage,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) / count(*) * 100 AS not_depressed_perecntage
			FROM driving_factors
            GROUP BY financial_stress;
            
            SELECT Age_group,
					COUNT(*),
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depressed_population,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) AS not_depressed_population,
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) / count(*) * 100 AS depressed_percentage,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) / count(*) * 100 AS not_depressed_perecntage
			FROM driving_factors
            GROUP BY Age_group;
            
            SELECT City,
					COUNT(*),
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) AS depressed_population,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) AS not_depressed_population,
                    SUM(CASE WHEN Depression = 1 THEN 1 ELSE 0 END) / count(*) * 100 AS depressed_percentage,
                    SUM(CASE WHEN Depression = 0 THEN 1 ELSE 0 END) / count(*) * 100 AS not_depressed_perecntage
			FROM driving_factors
            GROUP BY City;
            
	-- Numerical vs categorical
    SELECT Depression, AVG(Age) as age
    FROM driving_factors
    GROUP BY Depression
    ORDER BY FIELD(Depression, 1, 2);
    
    SELECT Depression, AVG(CGPA) as cgpa
    FROM driving_factors
    GROUP BY Depression
    ORDER BY FIELD(Depression, 1, 2);
    
    SELECT Depression, AVG(work_study_hours) as work_study_hours
    FROM driving_factors
    GROUP BY Depression
    ORDER BY FIELD(Depression, 1, 2);
    
    SELECT COUNT(*)*SUM(Age*CGPA) - SUM(Age*CGPA)
    /
    SQRT((COUNT(*)*SUM(Age*Age) - POW(SUM(Age),2))*(COUNT(*)*SUM(CGPA*CGPA) - POW(SUM(CGPA),2)))
    FROM driving_factors;
    
SELECT *
FROM driving_factors;










































