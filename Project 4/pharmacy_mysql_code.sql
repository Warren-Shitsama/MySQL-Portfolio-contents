CREATE DATABASE pharmacy_sales_database;

USE pharmacy_sales_database;

CREATE TABLE pharmacy (
Date	DATE,
product TEXT,
sales_person TEXT,
boxes_shipped TEXT,
amount_in_dollars DECIMAL(5,2),
country TEXT
);

LOAD DATA INFILE 'pharmacy_otc_sales_data.csv'
INTO TABLE pharmacy
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 1. Problem and the objective of the dataset
		-- to study the trends in sales, therefore getting insights into product perfomance, sales person perfomance, country performance
        
-- 2. Data loading and Initial inspection
		-- Examine first rows 
        SELECT *
        FROM pharmacy
        LIMIT 5;
        
        -- Check the data types
        DESCRIBE pharmacy;
        
		-- Identify missing values
        SELECT 
			COUNT(*) - COUNT(Date) AS missingdate,
            COUNT(*) - COUNT(product) AS missingproduct,
            COUNT(*) - COUNT(sales_person) AS missingsalesperson,
            COUNT(*) - COUNT(boxes_shipped) AS missingboxes,
            COUNT(*) - COUNT(amount_in_dollars) AS missingamount,
            COUNT(*) - COUNT(country) AS missingcountry
		FROM pharmacy;

		-- Identify duplicates
        SELECT Date, product, sales_person, boxes_shipped, amount_in_dollars, country, COUNT(*) AS count
        FROM pharmacy
        GROUP BY Date, product, sales_person, boxes_shipped, amount_in_dollars, country
        HAVING count > 1;
        
        -- Identify potential errors
        SELECT *
        FROM pharmacy
        WHERE Date IS NULL
			OR product IS NULL
			OR sales_person IS NULL
			OR boxes_shipped IS NULL
			OR amount_in_dollars < 0 
			OR country IS NULL
			;
	
		-- Outlier detection - Tofind out which product were overcharged
        WITH stat AS(
			SELECT AVG(amount_in_dollars) AS avg_amount,
					STDDEV(amount_in_dollars) AS stddev_amount
			FROM pharmacy
        )
		SELECT
			Date,
            product,
            sales_person,
            boxes_shipped,
            amount_in_dollars,
            country
		FROM pharmacy, stat
        WHERE ABS(amount_in_dollars - avg_amount) > 2*stddev_amount
        ORDER BY amount_in_dollars DESC;
        
        -- Descriptive statistics
        SELECT MAX(Date), MIN(Date)
        FROM pharmacy;
        
        SELECT MAX(boxes_shipped) MAX, MIN(boxes_shipped) MIN, ROUND(AVG(boxes_shipped)) AVG, ROUND(STDDEV(boxes_shipped)) STDDEV
		FROM pharmacy;

		SELECT MAX(amount_in_dollars) MAX, MIN(amount_in_dollars) MIN, ROUND(AVG(amount_in_dollars)) AVG, ROUND(STDDEV(amount_in_dollars)) STDDEV
		FROM pharmacy;

		-- Categogy statistics
        -- Overall Product perfomace
				SELECT 
					product,
                    SUM(amount_in_dollars) AS total_revenue,
                    COUNT(boxes_shipped) AS total_boxes_sold,
                    ROUND(AVG(amount_in_dollars/boxes_shipped),1) AS product_price
				FROM pharmacy
                GROUP BY product;
                
                -- Best performing product per conuntry
                WITH ranker AS (
                SELECT product, country,
						SUM(amount_in_dollars) AS total_revenue
				FROM pharmacy 
                GROUP BY product, country
                )
                SELECT country, product, RANK() OVER(PARTITION BY country ORDER BY total_revenue DESC) AS ranking
                FROM ranker
                GROUP BY country, product
                ;
                
                -- Average price per product
                SELECT product,
					ROUND(AVG(amount_in_dollars/boxes_shipped)) AS avg_product_price,
                    ROUND(MAX(amount_in_dollars/boxes_shipped)) AS max_product_price,
                    ROUND(MIN(amount_in_dollars/boxes_shipped)) AS min_product_price
				FROM pharmacy 
                GROUP BY product;
                
                -- Overall sales person performance
                SELECT sales_person,
						ROUND(AVG(amount_in_dollars)) AS avg_transactional_amt,
                        SUM(amount_in_dollars) AS total_amount,
                        COUNT(boxes_shipped) AS total_boxes
				FROM pharmacy
                GROUP BY sales_person;
                
				-- Overall perfomance
                SELECT country,
						ROUND(AVG(amount_in_dollars)) AS avg_transactional_amt,
                        SUM(amount_in_dollars) AS total_amount,
                        COUNT(boxes_shipped) AS total_boxes
				FROM pharmacy 
                GROUP BY country;
                
                -- monthly perfomance
                SELECT DATE_FORMAT(Date, '%Y-%m') AS month,
						ROUND(AVG(amount_in_dollars)) AS avg_transactional_amt,
                        SUM(amount_in_dollars) AS total_amount,
                        COUNT(boxes_shipped) AS total_boxes
				FROM pharmacy 
                GROUP BY month;
                
                CREATE TEMPORARY TABLE monthly_monitor
                SELECT DATE_FORMAT(Date, '%Y-%m') AS month,
						ROUND(AVG(amount_in_dollars)) AS avg_transactional_amt,
                        SUM(amount_in_dollars) AS total_amount,
                        COUNT(boxes_shipped) AS total_boxes
				FROM pharmacy 
                GROUP BY month;
                
                SELECT COUNT(*)*SUM(total_amount*total_boxes) - SUM(total_amount)*SUM(total_boxes)
                /
                SQRT((COUNT(*)*SUM(total_amount*total_amount) - POW(SUM(total_amount),2))*(COUNT(*)*SUM(total_boxes*total_boxes) - POW(SUM(total_boxes),2)))
				FROM monthly_monitor;




























































































