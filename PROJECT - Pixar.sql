-- EXPLORATORY DATA ANALYSIS FOR PIXAR

CREATE TABLE box_office (
film	VARCHAR(100),
budget	INT,
box_office_us_canada INT,	
box_office_other	INT,
box_office_worldwide INT
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/box_office.csv"
INTO TABLE box_office
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT *
FROM box_office;

CREATE TABLE academy (
film	VARCHAR (150),
award_type	VARCHAR(150),
status VARCHAR (150)
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/academy.csv"
INTO TABLE academy
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT *
FROM academy;

CREATE TABLE genres (
film VARCHAR (150),
category VARCHAR(150), 
value VARCHAR(150)
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/genres.csv"
INTO TABLE genres
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT *
FROM genres;

CREATE TABLE pixar_films (
number int, 
film VARCHAR(150),
release_date VARCHAR(150),
run_time	INT, 
film_rating VARCHAR(150)
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pixar_films.csv"
INTO TABLE pixar_films
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE pixar_people (
film VARCHAR(150), 
role_type VARCHAR(150),
name VARCHAR (150)
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pixar_people.csv"
INTO TABLE pixar_people
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE public_response(
film VARCHAR(150),	
rotten_tomatoes_score	TINYINT,
rotten_tomatoes_counts	INT,
metacritic_score	TINYINT, 
metacritic_counts	TINYINT,
cinema_score	VARCHAR(100),
imdb_score	DECIMAL(10,2),
imdb_counts INT
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/public_response.csv"
INTO TABLE public_response
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT *
FROM public_response;

UPDATE public_response
SET cinema_score = null
WHERE cinema_score = 'NA';


SELECT *
FROM academy;

SELECT *
FROM box_office;

SELECT *
FROM genres;

SELECT *
FROM genres;

SELECT *
FROM pixar_films;

SELECT *
FROM pixar_people;

SELECT *
FROM public_response;

-- films award_type 
SELECT *
FROM academy
WHERE award_type = 'Original Score';

SELECT *
FROM academy
WHERE award_type = 'Original Song';

SELECT *
FROM academy
WHERE award_type = 'Original Score';

SELECT *
FROM academy
WHERE award_type = 'Animated Feature';

SELECT film, count(award_type)
FROM academy
GROUP BY film
ORDER BY 2 DESC
;

ALTER TABLE academy
CHANGE COLUMN `status` status_id VARCHAR(200);

-- PROCESS THE CASHFLOW FOR EACH FILM
SELECT *
FROM box_office;

SELECT film, MAX(budget), MIN(budget), AVG(budget), MAX(box_office_us_canada),
 MIN(box_office_us_canada), AVG(box_office_us_canada), 
MAX(box_office_other), MIN(box_office_other), AVG(box_office_other), 
MAX(box_office_worldwide), MIN(box_office_worldwide), AVG(box_office_worldwide)
FROM box_office
GROUP BY film
ORDER BY 2 desc;

-- process the type of film
SELECT *
FROM genres;

SELECT *
FROM genres
WHERE `value` = 'Animation';

SELECT *
FROM genres
WHERE `value` = 'Adventure';

SELECT *
FROM genres 
WHERE `category` = 'Subgenre';

SELECT  film, value
FROM genres 
WHERE category = 'Genre'
GROUP BY film,  value;

-- PROCESS THE PIXAR FILMS 
SELECT *
FROM pixar_films;

SELECT MAX(release_date), MIN(release_date)
from pixar_films;

SELECT film,MAX(run_time), MIN(run_time)
from pixar_films
GROUP BY film
ORDER BY 2 desc;


-- PROCESS THE PIXAR PEOPLE 
SELECT *
FROM pixar_people;

SELECT *
FROM pixar_people
WHERE `name` = 'John Lasseter';

SELECT *
FROM pixar_people
WHERE `name` = 'Darla K. Anderson';

-- processing of the public response
SELECT *
FROM public_response;

SELECT max(rotten_tomatoes_score), min(rotten_tomatoes_score), avg(rotten_tomatoes_score),
max(metacritic_score), min(metacritic_score), avg(metacritic_score),
max(imdb_score), min(imdb_score), avg(imdb_score)
FROM public_response
;












