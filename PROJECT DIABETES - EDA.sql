-- EXPLORATORY DATA ANALYSIS

SELECT *
FROM diabetes_table;


-- Number of individuals that are diabetic positive by sex
SELECT Sex, COUNT(*) AS Totals
FROM diabetes_table
WHERE Diabetes_binary = 'Positive'
GROUP BY Sex;

-- Number of individuals that are diabetic negative by sex
SELECT Sex, COUNT(*) AS Totals
FROM diabetes_table
WHERE Diabetes_binary = 'Negative'
GROUP BY Sex;

-- Number of diabetic patients by sex
SELECT Sex, COUNT(*) as Totals
FROM diabetes_table
WHERE Diabetes_binary = 'Positive'
GROUP BY Sex;

DESCRIBE diabetes_table;

-- Indivi
SELECT COUNT(*) AS Total
FROM diabetes_table
WHERE GenHlth_classes = 'Excellent'
AND Diabetes_binary = 'Positive'
;

SELECT COUNT(*) AS Total
FROM diabetes_table
WHERE GenHlth_classes = 'Very good'
AND Diabetes_binary = 'Positive'
;

SELECT COUNT(*) AS Total
FROM diabetes_table
WHERE GenHlth_classes = 'Poor'
AND Diabetes_binary = 'Positive'
;

SELECT COUNT(*) AS Total
FROM diabetes_table
WHERE GenHlth_classes = 'Fair'
AND Diabetes_binary = 'Positive'
;

SELECT COUNT(*) Total
FROM diabetes_table
WHERE BMI_class = 'Normal weight'
AND Diabetes_binary = 'Positive';

SELECT  DISTINCT GenHlth_classes
FROM diabetes_table;

SELECT DISTINCT Diabetes_binary, count(*)
FROM diabetes_table
group by Diabetes_binary;

SELECT Diabetes_binary, SIGN(Diabetes_binary) AS sign_check
FROM diabetes_table
limit 70000;

UPDATE diabetes_table
SET Diabetes_binary = 'Positivee'
WHERE Diabetes_binary = 'Positive';

SELECT Diabetes_binary, length(Diabetes_binary) as length_check, count(*) as row_count
from diabetes_table
group by Diabetes_binary;

show columns from diabetes_table like 'Diabetes_binary';

SELECT * FROM diabetes_schema.diabetes_table
INTO OUTFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\wow3.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


