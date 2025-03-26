-- EXPLORATORY DATA ANALYSIS

CREATE TABLE airbnb (
id	INT,
name	VARCHAR(300),
host_id	INT,
host_name	VARCHAR(300),
neighbourhood_group	VARCHAR(300),
neighbourhood VARCHAR(100),
latitude	DOUBLE,
longitude	DOUBLE,
room_type	VARCHAR(300),
price	INT,
minimum_nights	INT,
number_of_reviews	INT,
last_review	VARCHAR(300),
reviews_per_month	VARCHAR(300),
calculated_host_listings_count	INT, 
availability_365 INT
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/AB_NYC_2019.csv"
INTO TABLE airbnb
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT *
FROM airbnb;


-- Types of airbnbs
SELECT room_type
FROM airbnb
GROUP BY room_type;

-- most review airbnb
SELECT room_type, sum(number_of_reviews)
FROM airbnb
GROUP BY room_type
ORDER BY 2 DESC;

-- most expensive and cheap airbnb
SELECT  max(price), min(price)
FROM airbnb
;

SELECT *
FROM airbnb
WHERE price = 10000
OR price = 0
ORDER BY price DESC;

-- minimum and maximum nights to spend in a airbnb
SELECT *
FROM airbnb
ORDER BY price, minimum_nights ;

-- neighbourhood with most airbnb
SELECT neighbourhood_group, count(id)
FROM airbnb
GROUP BY neighbourhood_group
ORDER BY 2 DESC;

-- MINIMUM NIGHTS BY ROOM TYPE
SELECT max(minimum_nights)
FROM airbnb
WHERE room_type = 'Private room';

SELECT max(minimum_nights)
FROM airbnb
WHERE room_type = 'Entire home/apt';

SELECT max(minimum_nights)
FROM airbnb
WHERE room_type = 'Shared room';

-- availability of airbnb
SELECT room_type, Count(availability_365)
FROM airbnb
GROUP BY room_type;

-- host with most airbnb
SELECT host_id,host_name,room_type, Count(id)
FROM airbnb
GROUP BY host_id,host_name, room_type
ORDER BY 4 DESC;































