-- DATA CLEANING 

-- 1. After creating a schema, create a table
CREATE TABLE diabetes_table(
	Diabetes_binary INT,
	HighBP	INT, 
    HighChol	INT, 
    CholCheck	INT,
    BMI	INT,
    Smoker	INT,
    Stroke	INT,
    HeartDiseaseorAttack	INT,
    PhysActivity	INT,
    Fruits	INT,
    Veggies	INT,
    HvyAlcoholConsump	INT,
    AnyHealthcare	INT,
    NoDocbcCost	INT,
    GenHlth	INT,
    MentHlth	INT,
    PhysHlth	INT,
    DiffWalk	INT,
    Sex	INT,
    Age	INT,
    Education	INT,
    Income INT
);

-- Confirm the presence of the table
SELECT *
FROM diabetes_table;

-- Confirm i have secure file priviledges
SHOW VARIABLES LIKE 'secure_file_priv';

-- Load the data into the table
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Diabetes_2.csv"
INTO TABLE diabetes_table
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Cornfirm the data has been inserted into the table diabetes_table
SELECT *
FROM diabetes_table;

-- Because the data in the columns will be updated with string, i have to update it to VARCHAR from INT.
ALTER TABLE diabetes_table
	MODIFY COLUMN Diabetes_binary VARCHAR(50), 
    MODIFY COLUMN HighBP VARCHAR(50), 
    MODIFY COLUMN HighChol VARCHAR(50), 
    MODIFY COLUMN CholCheck VARCHAR(50), 
    MODIFY COLUMN Smoker VARCHAR(50), 
    MODIFY COLUMN Stroke VARCHAR(50), 
    MODIFY COLUMN HeartDiseaseorAttack VARCHAR(50), 
    MODIFY COLUMN PhysActivity VARCHAR(50), 
    MODIFY COLUMN Fruits VARCHAR(50), 
    MODIFY COLUMN Veggies VARCHAR(50), 
    MODIFY COLUMN HvyAlcoholConsump VARCHAR(50), 
    MODIFY COLUMN AnyHealthcare VARCHAR(50), 
    MODIFY COLUMN NoDocbcCost VARCHAR(50), 
    MODIFY COLUMN DiffWalk VARCHAR(50), 
    MODIFY COLUMN Sex VARCHAR(50),
    MODIFY COLUMN BMI VARCHAR(50),
    MODIFY COLUMN GenHlth VARCHAR(50),
    MODIFY COLUMN MentHlth VARCHAR(50),
    MODIFY COLUMN Age VARCHAR(50),
    MODIFY COLUMN Education VARCHAR(50),
    MODIFY COLUMN Income VARCHAR(50)
    ;

-- Examine the new data types of the table
DESCRIBE diabetes_table;

ALTER TABLE diabetes_table
MODIFY COLUMN PhysHlth INT;

ALTER TABLE diabetes_table
MODIFY COLUMN MentHlth INT;


-- Testing to see if the classification can work
-- 1. BMI CLASSES
SELECT BMI, 
	CASE
		WHEN BMI <= '18.5' THEN 'Underweight'
		WHEN BMI BETWEEN '19' AND '25' THEN 'Normal weight'
		WHEN BMI BETWEEN '26' AND '30' THEN 'Overweight'
		WHEN BMI BETWEEN '31' AND '35' THEN 'Obese1'
		WHEN BMI BETWEEN '36' AND '40' THEN 'Obese2'
		WHEN BMI BETWEEN '41' AND '98' THEN 'Obese3'
    ELSE 'out of range'
    END as BMI_bracket
FROM diabetes_table
;

-- to make out the number of individual by the BMI class
SELECT BMI, COUNT(*) as count,
	CASE
		WHEN BMI <= '18.5' THEN 'Underweight'
		WHEN BMI BETWEEN '19' AND '25' THEN 'Normal weight'
		WHEN BMI BETWEEN '26' AND '30' THEN 'Overweight'
		WHEN BMI BETWEEN '31' AND '35' THEN 'Obese1'
		WHEN BMI BETWEEN '36' AND '40' THEN 'Obese2'
		WHEN BMI BETWEEN '41' AND '98' THEN 'Obese3'
    ELSE 'out of range'
    END as BMI_bracket
FROM diabetes_table
group by BMI
order by 1;

-- To include the BMI_bracket to the diabetes_table, i have to create another column on it
ALTER TABLE diabetes_table
ADD COLUMN BMI_class VARCHAR(50);

-- Time to insert the BMI_class data into the column BMI_class
UPDATE diabetes_table
SET BMI_class = 
	CASE
		WHEN BMI <= '18.5' THEN 'Underweight'
		WHEN BMI BETWEEN '19' AND '25' THEN 'Normal weight'
		WHEN BMI BETWEEN '26' AND '30' THEN 'Overweight'
		WHEN BMI BETWEEN '31' AND '35' THEN 'Obese1'
		WHEN BMI BETWEEN '36' AND '40' THEN 'Obese2'
		WHEN BMI BETWEEN '41' AND '98' THEN 'Obese3'
    ELSE 'out of range'
    END;
    
-- Confirm the changes on the table
SELECT *
FROM diabetes_table;

-- 2. GenHlth Classes
-- construct the classes
SELECT GenHlth, 
	CASE
		WHEN GenHlth = '1' THEN 'Excellent'
        WHEN GenHlth = '2' THEN 'Very good'
        WHEN GenHlth = '3' THEN 'Good'
        WHEN GenHlth = '4' THEN 'Fair'
        WHEN GenHlth = '5' THEN 'Poor'
    END as GenHlth_Classes
FROM diabetes_table;

-- Make out how many individual are in each class
SELECT GenHlth, 
	CASE
		WHEN GenHlth = '1' THEN 'Excellent'
        WHEN GenHlth = '2' THEN 'Very good'
        WHEN GenHlth = '3' THEN 'Good'
        WHEN GenHlth = '4' THEN 'Fair'
        WHEN GenHlth = '5' THEN 'Poor'
    END as GenHlth_classes,
    COUNT(*) as totals
FROM diabetes_table
GROUP BY GenHlth
ORDER BY 3;

-- Make a new clomn to accept the GenHlth_classes
ALTER TABLE diabetes_table
ADD COLUMN GenHlth_classes VARCHAR(50);

-- Make an update to have the GenHlth_classes in the GenHlth_classes Column
UPDATE diabetes_table
SET GenHlth_classes =
	CASE
		WHEN GenHlth = '1' THEN 'Excellent'
        WHEN GenHlth = '2' THEN 'Very good'
        WHEN GenHlth = '3' THEN 'Good'
        WHEN GenHlth = '4' THEN 'Fair'
        WHEN GenHlth = '5' THEN 'Poor'
    END;

SELECT *
FROM diabetes_table;

-- 3. PhysHlth
-- make the classifications
SELECT PhysHlth, 
	CASE
		WHEN PhysHlth BETWEEN '0' AND '6' THEN 'Poor'
        WHEN PhysHlth BETWEEN '7' AND '12' THEN 'Fair'
        WHEN PhysHlth BETWEEN '13' AND '18' THEN 'Good'
        WHEN PhysHlth BETWEEN '19' AND '24' THEN 'Very good'
        WHEN PhysHlth BETWEEN '25' AND '30' THEN 'Excellent'
    END as PhysHlth_Classes
FROM diabetes_table;

-- MAKE A COUNT ACROSS THE CLASSIFICATION
SELECT PhysHlth, 
	CASE
		WHEN PhysHlth BETWEEN '0' AND '6' THEN 'Poor'
        WHEN PhysHlth BETWEEN '7' AND '12' THEN 'Fair'
        WHEN PhysHlth BETWEEN '13' AND '18' THEN 'Good'
        WHEN PhysHlth BETWEEN '19' AND '24' THEN 'Very good'
        WHEN PhysHlth BETWEEN '25' AND '30' THEN 'Excellent'
	ELSE 'OUT OF RANGE'
    END as PhysHlth_Classes,
    COUNT(*) AS totals
FROM diabetes_table
GROUP BY PhysHlth, PhysHlth_Classes
ORDER BY 1 
;

-- Make a new colomn for PhysHlth_Classes
ALTER TABLE diabetes_table
ADD COLUMN PhysHlth_Classes VARCHAR(50);

UPDATE diabetes_table
SET PhysHlth_Classes = 
	CASE
		WHEN PhysHlth BETWEEN '0' AND '6' THEN 'Poor'
        WHEN PhysHlth BETWEEN '7' AND '12' THEN 'Fair'
        WHEN PhysHlth BETWEEN '13' AND '18' THEN 'Good'
        WHEN PhysHlth BETWEEN '19' AND '24' THEN 'Very good'
        WHEN PhysHlth BETWEEN '25' AND '30' THEN 'Excellent'
    END ;

SELECT *
FROM diabetes_table;

-- 3. MentHlth
SELECT MentHlth, 
	CASE
		WHEN MentHlth BETWEEN '0' AND '6' THEN 'Poor'
        WHEN MentHlth BETWEEN '7' AND '12' THEN 'Fair'
        WHEN MentHlth BETWEEN '13' AND '18' THEN 'Good'
        WHEN MentHlth BETWEEN '19' AND '24' THEN 'Very good'
        WHEN MentHlth BETWEEN '25' AND '30' THEN 'Excellent'
    END as MentHlth_Classes
FROM diabetes_table;

-- MAKE A COUNT ACROSS THE CLASSIFICATION
SELECT MentHlth, 
	CASE
		WHEN MentHlth BETWEEN '0' AND '6' THEN 'Poor'
        WHEN MentHlth BETWEEN '7' AND '12' THEN 'Fair'
        WHEN MentHlth BETWEEN '13' AND '18' THEN 'Good'
        WHEN MentHlth BETWEEN '19' AND '24' THEN 'Very good'
        WHEN MentHlth BETWEEN '25' AND '30' THEN 'Excellent'
	ELSE 'OUT OF RANGE'
    END as MentHlth_Classes,
    COUNT(*) AS totals
FROM diabetes_table
GROUP BY MentHlth, MentHlth_Classes
ORDER BY 1 
;

-- Make a new colomn for PhysHlth_Classes
ALTER TABLE diabetes_table
ADD COLUMN MentHlth_Classes VARCHAR(50);

UPDATE diabetes_table
SET MentHlth_Classes = 
	CASE
		WHEN MentHlth BETWEEN '0' AND '6' THEN 'Poor'
        WHEN MentHlth BETWEEN '7' AND '12' THEN 'Fair'
        WHEN MentHlth BETWEEN '13' AND '18' THEN 'Good'
        WHEN MentHlth BETWEEN '19' AND '24' THEN 'Very good'
        WHEN MentHlth BETWEEN '25' AND '30' THEN 'Excellent'
    END ;

SELECT *
FROM diabetes_table;

-- 4. Education
SELECT Education, 
	CASE
		WHEN Education = '1'THEN 'No school/Kindergarten'
        WHEN Education = '2' THEN 'Elementary'
        WHEN Education = '3' THEN 'High school dropout'
        WHEN Education ='4' THEN 'High school graduate'
        WHEN Education = '5' THEN 'College'
		WHEN Education = '6' THEN 'College dropout'
    END as Education_classes
FROM diabetes_table;

-- MAKE A COUNT ACROSS THE CLASSIFICATION
SELECT Education, 
	CASE
		WHEN Education = '1'THEN 'No school/Kindergarten'
        WHEN Education = '2' THEN 'Elementary'
        WHEN Education = '3' THEN 'High school dropout'
        WHEN Education ='4' THEN 'High school graduate'
        WHEN Education = '5' THEN 'College'
		WHEN Education = '6' THEN 'College dropout'
	ELSE 'OUT OF RANGE'
    END as Education_classes,
    COUNT(*) AS totals
FROM diabetes_table
GROUP BY Education, Education_classes
ORDER BY 1 
;

-- Make a new colomn for PhysHlth_Classes
ALTER TABLE diabetes_table
ADD COLUMN Education_classes VARCHAR(50);

UPDATE diabetes_table
SET Education_classes = 
	CASE
		WHEN Education = '1'THEN 'No school/Kindergarten'
        WHEN Education = '2' THEN 'Elementary'
        WHEN Education = '3' THEN 'High school dropout'
        WHEN Education ='4' THEN 'High school graduate'
        WHEN Education = '5' THEN 'College'
		WHEN Education = '6' THEN 'College dropout'
    END  ;

SELECT *
FROM diabetes_table;


-- 4. Income
SELECT Income, 
	CASE
		WHEN Income = '1'THEN 'less than $10000'
        WHEN Income BETWEEN '2' AND '5' THEN 'less than $35000'
        WHEN Income BETWEEN '6' AND '8' THEN 'more than $75000'
    END as Education_classes
FROM diabetes_table;

-- MAKE A COUNT ACROSS THE CLASSIFICATION
SELECT Income, 
	CASE
		WHEN Income = '1'THEN 'less than $10000'
        WHEN Income BETWEEN '2' AND '5' THEN 'less than $35000'
        WHEN Income BETWEEN '6' AND '8' THEN 'more than $75000'
	ELSE 'OUT OF RANGE'
    END as Income_classes,
    COUNT(*) AS totals
FROM diabetes_table
GROUP BY Income, Income_classes
ORDER BY 1 
;

-- Make a new colomn for PhysHlth_Classes
ALTER TABLE diabetes_table
ADD COLUMN Income_classes VARCHAR(50);

UPDATE diabetes_table
SET Income_classes = 
	CASE
		WHEN Income = '1'THEN 'less than $10000'
        WHEN Income BETWEEN '2' AND '5' THEN 'less than $35000'
        WHEN Income BETWEEN '6' AND '8' THEN 'more than $75000'
    END  ;

SELECT *
FROM diabetes_table;


-- DROP AY USELESS COLUMNS
ALTER TABLE diabetes_table
	DROP COLUMN BMI,
    DROP COLUMN GenHlth,
    DROP COLUMN MentHlth,
    DROP COLUMN PhysHlth,
    DROP COLUMN Education,
    DROP COLUMN Income;
   
SELECT *
FROM diabetes_table;
   
UPDATE diabetes_table
SET Diabetes_binary = 'Positive'
WHERE Diabetes_binary = '1';

UPDATE diabetes_table
SET Diabetes_binary = 'Negative'
WHERE Diabetes_binary = '0';

UPDATE diabetes_table
SET HighBP = 'Positive'
WHERE HighBP = '1';

UPDATE diabetes_table
SET HighBP = 'Negative'
WHERE HighBP = '0';

UPDATE diabetes_table
SET HighChol = 'Positive'
WHERE HighChol = '1';

UPDATE diabetes_table
SET HighChol = 'Negative'
WHERE HighChol = '0';

UPDATE diabetes_table
SET CholCheck = 'Positive'
WHERE CholCheck = '1';

UPDATE diabetes_table
SET CholCheck = 'Negative'
WHERE CholCheck = '0';

UPDATE diabetes_table
SET Smoker = 'Positive'
WHERE Smoker = '1';

UPDATE diabetes_table
SET Smoker = 'Negative'
WHERE Smoker = '0';

UPDATE diabetes_table
SET Stroke = 'Positive'
WHERE Stroke = '1';

UPDATE diabetes_table
SET Stroke = 'Negative'
WHERE Stroke = '0';

UPDATE diabetes_table
SET HeartDiseaseorAttack = 'Positive'
WHERE HeartDiseaseorAttack = '1';

UPDATE diabetes_table
SET HeartDiseaseorAttack = 'Negative'
WHERE HeartDiseaseorAttack = '0';

UPDATE diabetes_table
SET PhysActivity = 'Positive'
WHERE PhysActivity = '1';

UPDATE diabetes_table
SET PhysActivity = 'Negative'
WHERE PhysActivity = '0';

UPDATE diabetes_table
SET Fruits = 'Positive'
WHERE Fruits = '1';

UPDATE diabetes_table
SET Fruits = 'Negative'
WHERE Fruits = '0';

UPDATE diabetes_table
SET Veggies = 'Positive'
WHERE Veggies = '1';

UPDATE diabetes_table
SET Veggies = 'Negative'
WHERE Veggies = '0';

UPDATE diabetes_table
SET HvyAlcoholConsump = 'Positive'
WHERE HvyAlcoholConsump = '1';

UPDATE diabetes_table
SET HvyAlcoholConsump = 'Negative'
WHERE HvyAlcoholConsump = '0';

UPDATE diabetes_table
SET AnyHealthcare = 'Positive'
WHERE AnyHealthcare = '1';

UPDATE diabetes_table
SET AnyHealthcare = 'Negative'
WHERE AnyHealthcare = '0';

UPDATE diabetes_table
SET NoDocbcCost = 'Positive'
WHERE NoDocbcCost = '1';

UPDATE diabetes_table
SET NoDocbcCost = 'Negative'
WHERE NoDocbcCost = '0';

UPDATE diabetes_table
SET DiffWalk = 'Positive'
WHERE DiffWalk = '1';

UPDATE diabetes_table
SET DiffWalk = 'Negative'
WHERE DiffWalk = '0';

UPDATE diabetes_table
SET Sex = 'Male'
WHERE Sex = '1';

UPDATE diabetes_table
SET Sex = 'Female'
WHERE Sex = 'Negative';

SELECT *
FROM diabetes_table;

SELECT
 distinct Age
FROM diabetes_table
ORDER BY 1 ASC;

ALTER TABLE diabetes_table
MODIFY COLUMN Age int;

SELECT Age,
	CASE
		WHEN Age BETWEEN 1 AND 2 THEN 'Teenager'
        WHEN Age BETWEEN  3 AND 4 THEN 'Youths'
        WHEN Age BETWEEN 5 AND 8 THEN 'Middle Aged'
        WHEN Age BETWEEN 9 AND 12 THEN 'Old'
        WHEN Age = 13 THEN 'Great Old'
    END AS Age_group
FROM diabetes_table;

SELECT Age,
	CASE
		WHEN Age BETWEEN 1 AND 2 THEN 'Teenager'
        WHEN Age BETWEEN  3 AND 4 THEN 'Youths'
        WHEN Age BETWEEN 5 AND 8 THEN 'Middle Aged'
        WHEN Age BETWEEN 9 AND 12 THEN 'Old'
        WHEN Age = 13 THEN 'Great Old'
    END AS Age_group,
    COUNT(*) AS Totals
FROM diabetes_table
GROUP BY Age, Age_group;

ALTER TABLE diabetes_table
ADD COLUMN Age_bracket VARCHAR(50);

UPDATE diabetes_table
SET Age_bracket =
	CASE
		WHEN Age BETWEEN 1 AND 2 THEN 'Teenager'
        WHEN Age BETWEEN  3 AND 4 THEN 'Youths'
        WHEN Age BETWEEN 5 AND 8 THEN 'Middle Aged'
        WHEN Age BETWEEN 9 AND 12 THEN 'Old'
        WHEN Age = 13 THEN 'Great Old'
    END;

ALTER TABLE diabetes_table
DROP column Age;

SELECT *
FROM diabetes_table;













