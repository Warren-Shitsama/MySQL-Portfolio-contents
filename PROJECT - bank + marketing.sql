CREATE TABLE bank1(
age	INT, 
job	VARCHAR(150),
marital	VARCHAR(150),
education	VARCHAR(150),
default_credit	CHAR(10),
balance	INT,
housing_loan CHAR(10),
personal_loan CHAR(10),
contact	VARCHAR(100),
last_contact_duration_seconds SMALLINT,
campaign_contacts TINYINT,
since_last_contact	SMALLINT,
previous_contact TINYINT,
campaign_outcome VARCHAR(100), 
deposit_subscription CHAR(10)
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bank.csv"
INTO TABLE bank1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS 
;

SELECT *
FROM bank1;

CREATE TABLE bank2 (
age	TINYINT,
job	VARCHAR(150), 
marital	VARCHAR(100),
education VARCHAR(150),
default_credit	CHAR(10),
balance	INT,
housing_loan CHAR(10),
personal_loan	CHAR(10),
contact	VARCHAR(50),
last_contact_duration_seconds SMALLINT,
campaign_contacts TINYINT,
since_last_contact	SMALLINT,
previous_contact	SMALLINT,
campaign_outcome	VARCHAR(100),
deposit_subscription CHAR(10)
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bank-full.csv"
INTO TABLE bank2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS ;

SELECT *
FROM bank1;

SELECT *
FROM bank2;

-- job with most participant
SELECT job, count(job)
FROM bank1
GROUP BY job
ORDER BY 2 DESC;

SELECT job, count(job)
FROM bank2
GROUP BY job
ORDER BY 2 DESC;

-- The receiving services at the bank by age and job
SELECT MAX(age), MIN(age), avg(age), job
FROM bank1
GROUP BY job;

-- job bracket with most single
SELECT job, count(marital)
FROM bank1
WHERE marital = 'single'
GROUP BY job
ORDER BY 2 DESC
;

-- JOB BARCKET WITH MOST MARRIED INDIVIDUAL
SELECT job, count(marital)
FROM bank1
WHERE marital = 'married'
GROUP BY job
ORDER BY 2 DESC
;

-- job bracket with most single
SELECT job, count(marital)
FROM bank2
WHERE marital = 'single'
GROUP BY job
ORDER BY 2 DESC
;

-- JOB BARCKET WITH MOST MARRIED INDIVIDUAL
SELECT job, count(marital)
FROM bank2
WHERE marital = 'married'
GROUP BY job
ORDER BY 2 DESC
;

-- The level of education of the bank's demographics
SELECT *
FROM bank1;

SELECT education, count(education)
FROM bank1
GROUP BY education
Order by 2 desc;

SELECT job, education, count(education)
FROM bank1
GROUP BY job, education
ORDER BY 3 DESC;

-- DEMOGRAPHIC WITH MOST LOAN
SELECT *, 
CASE
	WHEN age BETWEEN 18 AND 30 THEN 'youth'
    WHEN age BETWEEN 31 AND 60 THEN 'middle_aged'
    WHEN age BETWEEN 61 AND 100 THEN 'old'
END
FROM bank1;

ALTER TABLE bank1
ADD COLUMN  age_bracket VARCHAR (100);

UPDATE  bank1
SET age_bracket = CASE
	WHEN age BETWEEN 18 AND 30 THEN 'youth'
    WHEN age BETWEEN 31 AND 60 THEN 'middle_aged'
    WHEN age BETWEEN 61 AND 100 THEN 'old'
END;

SELECT *
FROM bank1;

SELECT age_bracket, count(personal_loan)
FROM bank1
GROUP BY age_bracket
ORDER BY 2 desc;

SELECT age_bracket, count(housing_loan)
FROM bank1
GROUP BY age_bracket
ORDER BY 2 desc;

-- most used method of contact
SELECT contact, count(contact)
FROM bank1
GROUP BY contact;

-- individual i need of contact
SELECT *
FROM bank1
ORDER BY campaign_contacts;

-- most contacted demo
SELECT age_bracket, count(campaign_contacts)
FROM bank1
GROUP BY age_bracket
ORDER BY 2 DESC;

-- the demographic with the most balance
SELECT age_bracket, sum(balance)
FROM bank1
GROUP BY age_bracket
ORDER BY 2 DESC;

-- the time spent by demographics
SELECT age_bracket, sum(last_contact_duration_seconds)
FROM bank1
GROUP BY age_bracket
ORDER BY 2 DESC;

