CREATE DATABASE bitcoin_history_data;

USE bitcoin_history_data;

CREATE TABLE bitcoin_data(
Date	DATE,
Close	DECIMAL(9,3),
High	DECIMAL(9,3),
Low	DECIMAL(9,3),
Open	DECIMAL(9,3),
Volume BIGINT
);

LOAD DATA INFILE 'Bitcoin_history_data.csv'
INTO TABLE bitcoin_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 1. Identify the problem and the objective of the data
      -- the data has daily trading activity of a financial instrument, its main objective is for study in order to gain insights to help in investments
      
-- 2. Load data and initial inspection
		-- examine for structure / content
        SELECT *
        FROM bitcoin_data
        LIMIT 5;
        
        -- check for data types
        DESCRIBE bitcoin_data;
        
        -- check for missings values
        SELECT 
			COUNT(*) - COUNT(Date) AS missing_date_records,
            COUNT(*) - COUNT(Close) as missing_close_records,
            COUNT(*) - COUNT(High) AS missing_high_records,
            COUNT(*) - COUNT(Low) AS missing_low_records,
            COUNT(*) - COUNT(Open) AS missing_open_records,
            COUNT(*) - COUNT(Volume) AS missing_volume_records
		FROM bitcoin_data;

		-- check for duplicates 
        SELECT Date, COUNT(Date) AS count
        FROM bitcoin_data
        GROUP BY Date 
        HAVING count > 1;
        
        -- validate potential errors
        SELECT *
        FROM bitcoin_data
        WHERE Open <= 0
        OR Close <= 0
        OR Low <= 0
        OR High <= 0
        OR Volume <= 0
        ;
        
        -- Summary statistics
        SELECT ROUND(MAX(Close)), ROUND(MIN(Close)), ROUND(AVG(Close)), ROUND(STDDEV(Close)), ROUND(VARIANCE(Close))
        FROM bitcoin_data;
        
        SELECT MAX(High), MIN(High), AVG(High), STDDEV(High), VARIANCE(High)
        FROM bitcoin_data;
        
		SELECT MAX(Low), MIN(Low), AVG(Low), STDDEV(Low), VARIANCE(Low)
        FROM bitcoin_data;
        
        SELECT MAX(Open), MIN(Open), AVG(Open), STDDEV(Open), VARIANCE(Open)
        FROM bitcoin_data;
        
        SELECT MAX(Volume), MIN(Volume), AVG(Volume), STDDEV(Volume), VARIANCE(Volume)
        FROM bitcoin_data;

-- 3. Exploratory Data Analysis (EDA) - Trend analysis
		-- daily price changes
        SELECT Date, Close,
				((Close - LAG(Close, 1, Close) OVER(ORDER BY Date ASC)) / LAG(Close, 1, Close) OVER(ORDER BY Date ASC))*100 AS daily_price_percentage
		FROM bitcoin_data
        ;
        
        -- Recent trend (30 days)
        SELECT Date, Close, Volume,
				((Close - LAG(Close, 1, Close) OVER(ORDER BY Date ASC)) / LAG(Close, 1, Close) OVER(ORDER BY Date ASC))*100 AS daily_price_percentage
		FROM bitcoin_data
		WHERE Date >= DATE_SUB('2025-07-26', INTERVAL 30 DAY) 
        ORDER BY Date;
        
        -- monthly average
        SELECT DATE_FORMAT(Date, '%Y-%m') AS Month,
				ROUND(AVG(Close)) AS avg_monthly_close,
                ROUND(AVG(Volume)) AS avg_monthly_volume
		FROM bitcoin_data
        GROUP BY Month;
        
        -- Yearly average
        SELECT YEAR(Date) AS year,
				ROUND(AVG(Close)) AS avg_monthly_close,
                ROUND(AVG(Volume)) AS avg_monthly_volume
		FROM bitcoin_data
        GROUP BY year;
        
        -- Days with the highest volume
        SELECT Date, Volume
        FROM bitcoin_data
        ORDER BY Volume DESC
        LIMIT 10;
        
        -- Overall trend
        (SELECT *
        FROM bitcoin_data
        ORDER BY Date ASC
        LIMIT 1)
        UNION
        (SELECT *
        FROM bitcoin_data
        ORDER BY Date DESC
        LIMIT 1);
        
        CREATE TEMPORARY TABLE price_change
        (SELECT *
        FROM bitcoin_data
        ORDER BY Date ASC
        LIMIT 1)
        UNION
        (SELECT *
        FROM bitcoin_data
        ORDER BY Date DESC
        LIMIT 1);
        
        SELECT Close, Volume,((Close - LAG(Close, 1, Close) OVER()) / LAG(Close, 1, Close) OVER())*100 AS closepercentage,
				((Volume - LAG(Volume, 1, Volume) OVER()) / LAG(Volume, 1, Volume) OVER())*100 AS volume_percentage
		FROM price_change;
        
        -- the day between the start and finish of the volume
        SELECT DATEDIFF('2025-07-17' ,'2014-09-26')
        FROM bitcoin_data;
        
        -- daily price volatility
        SELECT Date, High, Low, 
				ABS(High - Low) AS price_change,
                ((ABS(High - Low)) / Close)*100 AS volatility_percentage
		FROM bitcoin_data
        ;
        
        -- Correlation between volume and price movement
        SELECT Date, Close, Volume,
				((Close - LAG(Close, 1, Close) OVER(ORDER BY Date)) / LAG(Close, 1, Close) OVER(ORDER BY Date)) AS price_change_percentage
		FROM bitcoin_data
		GROUP BY Date, Close, Volume;
        
        CREATE TEMPORARY TABLE volatility_checker
        SELECT Date, Close, Volume,
				((Close - LAG(Close, 1, Close) OVER(ORDER BY Date)) / LAG(Close, 1, Close) OVER(ORDER BY Date)) AS price_change_percentage
		FROM bitcoin_data
		GROUP BY Date, Close, Volume;

		
        SELECT COUNT(*)*SUM(CAST(Volume AS DOUBLE)*CAST(price_change_percentage AS DOUBLE)) - SUM(CAST(Volume AS DOUBLE))*SUM(CAST(price_change_percentage AS DOUBLE))
			/
			SQRT((COUNT(*)*SUM(CAST(Volume AS DOUBLE)*CAST(Volume AS DOUBLE)) - POW(SUM(CAST(Volume AS DOUBLE)),2))*(COUNT(*)*SUM(CAST(price_change_percentage AS DOUBLE)*CAST(price_change_percentage AS DOUBLE)) - POW(SUM(CAST(price_change_percentage AS DOUBLE)),2))) AS Volume_price_corr
		FROM volatility_checker;

		-- identify days with significant price drops
        SELECT Date, ((Close - Open) / Open)*100 AS price_change_per
        FROM bitcoin_data
        WHERE ((Close - Open) / Open)*100 < -10;
        
        -- 50-day moving average
			SELECT Date, Close, ROUND(AVG(Close) OVER(ORDER BY Date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)) AS 50_day_moving_average
            FROM bitcoin_data
            GROUP BY Date, Close
            ORDER BY Date;












































































