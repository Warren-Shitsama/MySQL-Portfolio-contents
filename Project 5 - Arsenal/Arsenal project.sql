CREATE DATABASE arsenal_football_club_database;

USE arsenal_football_club_database;

CREATE TABLE matches(
Season	TEXT,
Tour	INT,
Date	DATE,
Time	TIME,
Opponent	TEXT,
HoAw	TEXT,
ArsenalScore	INT,
OpponentScore	INT,
Stadium	TEXT,
Attendance	INT,
Coach	TEXT,
Referee TEXT,
PRIMARY KEY (Date)
);

LOAD DATA INFILE 'matches.csv'
INTO TABLE matches
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE players(
LastName	VARCHAR(300),
FirstName	VARCHAR(300),
Date	DATE,
Start	INT,
Pos	TEXT,
Min INT,
G	INT,
A	INT,
PK	INT,
PKA	INT,
S	INT,
SoT	INT,
YK	INT,
RK	INT,
Touches	INT,
Tackles	INT,
Ints	INT,
Blocks	INT,
xG	DECIMAL(2,1),
npxG	DECIMAL(2,1),
xAG	DECIMAL(2,1),
Passes	INT,
PassesA	INT,
PrgPas	INT,
Carries	INT,
PrgCar	INT,
Line	TEXT,
C INT,
PRIMARY KEY (LastName,FirstName,Date),
FOREIGN KEY (Date) REFERENCES matches(Date)
);

LOAD DATA INFILE 'players.csv'
INTO TABLE players
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE goalkeepers (
LastName	VARCHAR(300),
FirstName	VARCHAR(300),
Date	DATE,
Start	INT,
Pos TEXT,
Min	INT,
SoTA	INT,
GA	INT,
Saves	INT,
PSxG	DECIMAL (2,1),
PKatt	INT,
PKA	INT,
PKm	INT,
PassAtt	INT,
Throws	INT,
AvgLen	DECIMAL(3,1),
GKAtt	INT,
GKAvgLen	DECIMAL(3,1),
C INT,
PRIMARY KEY (LastName,FirstName,Date),
FOREIGN KEY (Date) REFERENCES matches(Date)
);

LOAD DATA INFILE 'goalkeepers.csv'
INTO TABLE goalkeepers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- 1. Problem and objective of the dataset
-- the dataset has the performance of the team(overall), players, goalkeepers and the coaches, the objective is to study the performnace to see 
-- if there is any improvement or need of improvement

-- 2. Data loading and Initial Inspection 

		-- Assess the datatypes of the tables
	DESCRIBE goalkeepers;
    
    DESCRIBE matches;
    
    DESCRIBE players;

		-- Assess the structure of the table
	SELECT *
    FROM goalkeepers
    LIMIT 3;

	SELECT *
    FROM matches
    LIMIT 3;

	SELECT *
    FROM players
    LIMIT 3;

-- 3. Exploratory Data Analysis
-- GOALKEEPER ANALYSIS

	-- How does the save percentage of Arsenal goalkeepers vary throughout the seasons?
		SELECT m.Season, LastName, FirstName, 
			SUM(Saves) / SUM(SoTA) * 100 AS Savepercentage
		FROM goalkeepers g
        JOIN matches m
			ON m.Date = g.Date
        GROUP BY Season, LastName, FirstName;
        
	-- Which goalkeeper faced the most penalty kicks and how effective was the saves?
		SELECT LastName, FirstName, SUM(PKatt) as Total_penalty_attempted, SUM(PKm) AS Total_penalty_missed,
				 SUM(PKm) / SUM(PKatt) * 100 AS Saves_percentage
		FROM goalkeepers
        WHERE PKatt > 0
        GROUP BY LastName, FirstName
        ;
        
	-- How does the average pass length (AvgLen) and goal kick length (GKAvgLen) differ between goalkeepers, and does it correlate with match outcomes?
		SELECT g.LastName, g.FirstName, SUM(AvgLen) / COUNT(*) AS avg_pass_len, SUM(GKAvgLen) / COUNT(*) AS avg_gk_len,
				CASE WHEN m.ArsenalScore > m.OpponentScore THEN 'Win'
					WHEN m.ArsenalScore < m.OpponentScore THEN 'Lose' ELSE 'Draw' END AS Match_outcome
        FROM goalkeepers g
        JOIN matches m 
			ON m.Date = g.Date
		GROUP BY g.LastName, g.FirstName,m.ArsenalScore,m.OpponentScore;

	-- Are there specific opponents against which Arsenal goalkeepers concede more goals (GA)?
		SELECT g.LastName, g.FirstName, m.Opponent, SUM(GA) AS Total_goals_conceded
        FROM goalkeepers g
        JOIN matches m
			ON m.Date = g.Date
		GROUP BY g.LastName, g.FirstName, m.Opponent
        ORDER BY g.LastName ASC, Total_goals_conceded DESC;

-- PLAYER PERFORMANCE
 
		-- Which Arsenal players have the highest expected goals (xG) per 90 minutes played, and how does this compare to their actual goals scored (G)?
		SELECT LastName, FirstName,  Season,
				(SUM(xG) / SUM(Min))*90 AS xGper90, (SUM(G) / SUM(Min))*90 AS Gper90,G
		FROM players p
        JOIN matches m
			ON m.Date = p.Date
        WHERE G > 0 AND Line = 'Forward'
        GROUP BY LastName, FirstName,G,m.Season;
        
        -- How do progressive passes (PrgPas) and progressive carries (PrgCar) vary by player position (Pos) and season?
		SELECT Pos, Season, SUM(PrgPas) AS total_prgpas, SUM(PrgCar) AS total_prgcar
		FROM players p
        JOIN matches m
			ON m.Date = p.Date
		GROUP BY Pos, Season;
        
        -- Which players served as captain most frequently, and how did their performance (e.g., xG, xAG, Tackles) differ when they were captain?
			SELECT LastName, FirstName, SUM(C) AS captain_freq
            FROM players
            WHERE C = 1
            GROUP BY LastName, FirstName
            ;
            
            SELECT LastName, FirstName, SUM(G)
            FROM players
            WHERE C = 1
            GROUP BY LastName, FirstName;
            
			SELECT LastName, FirstName, SUM(G)
            FROM players
            WHERE C = 0
            GROUP BY LastName, FirstName;

		-- How does the number of touches (Touches) correlate with expected assists (xAG) for midfielders?
        SELECT 
			COUNT(*)*SUM(Touches*xAG) - SUM(Touches)*SUM(xAG)
            /
            SQRT((COUNT(*)*SUM(Touches*Touches) - POW(SUM(Touches),2))*(COUNT(*)*SUM(xAG*xAG) - POW(SUM(xAG),2))) AS Correlation
		FROM players
        WHERE Line = 'Midfielder'; -- there is a strong correlation
	
    
-- MATCH OUTCOME AND TEAM PERFORMANCE
		-- What is Arsenal’s win rate at home vs. away, and how does it vary by season?
		SELECT Season, HoAw,
			SUM(CASE WHEN ArsenalScore > OpponentScore THEN 1 ELSE 0 END) / COUNT(*) * 100 AS Win_percentage
		FROM matches
        GROUP BY Season, HoAw;

		-- Which referees officiated matches where Arsenal had the highest/lowest goal difference (ArsenalScore - OpponentScore)?
        SELECT Date, Opponent,HoAw,ArsenalScore,OpponentScore,Referee, MIN(ArsenalScore - OpponentScore) AS Goal_difference
        FROM matches
        GROUP BY Date, Opponent,HoAw,ArsenalScore,OpponentScore,Referee
        ORDER BY Goal_difference ASC
        LIMIT 5;
        
		SELECT Date, Opponent,HoAw,ArsenalScore,OpponentScore,Referee, MAX(ArsenalScore - OpponentScore) AS Goal_difference
        FROM matches
        GROUP BY Date, Opponent,HoAw,ArsenalScore,OpponentScore,Referee
        ORDER BY Goal_difference DESC
        LIMIT 5;

		-- How does Arsenal’s performance (goals scored/conceded) differ under different coaches (e.g., Wenger, Emery, Arteta)?
		SELECT Coach, COUNT(Date) AS matches_played,AVG(ArsenalScore) AS avg_goal_scored,AVG(OpponentScore) AS avg_goal_conceded, 
				SUM(CASE WHEN ArsenalScore > OpponentScore THEN 1 ELSE 0 END) AS Wins,
                SUM(CASE WHEN ArsenalScore < OpponentScore THEN 1 ELSE 0 END) AS Loses,
                SUM(CASE WHEN ArsenalScore = OpponentScore THEN 1 ELSE 0 END) AS Draws,
                ROUND(SUM(CASE WHEN ArsenalScore > OpponentScore THEN 1 ELSE 0 END) / COUNT(*) * 100) AS win_percentage
		FROM matches
		GROUP BY Coach;
        
        -- Does attendance correlate with Arsenal’s performance in home matches?
        WITH goal_difference_vs_attendance AS(
		SELECT (ArsenalScore - OpponentScore) AS goal_difference, Attendance
        FROM matches
        WHERE HoAw = 'Home'
        GROUP BY Attendance,ArsenalScore,OpponentScore)
        SELECT 
			COUNT(*)*SUM(goal_difference*Attendance) - SUM(goal_difference)*SUM(Attendance)
            /
            SQRT((COUNT(*)*SUM(goal_difference*goal_difference)-POW(SUM(goal_difference),2))*(COUNT(*)*SUM(Attendance*Attendance)-POW(SUM(Attendance),2))) AS Corr
		FROM goal_difference_vs_attendance; -- Strong correlation
        
-- ADVANCED ANALYSIS
		-- How does the number of shots on target against (SoTA) faced by goalkeepers correlate with the number of tackles (Tackles) and interceptions (Ints) by defenders in the same match?
		WITH defenderstats AS (
        SELECT Date, SUM(COALESCE(Tackles,0)) AS Totaltackles, SUM(COALESCE(Ints,0)) AS Totalints
        FROM players
        WHERE Line = 'Defender'
        GROUP BY Date
        ),
        goalkeeper_vs_defender_stats AS (
        SELECT g.Date, d.Totaltackles,d.Totalints,SUM(COALESCE(SoTA,0)) AS Totalshotontarget
        FROM defenderstats d
        JOIN goalkeepers g
				ON g.Date = d.Date
        GROUP BY g.Date, d.Totaltackles,d.Totalints
        )
        SELECT 
			CASE WHEN SQRT((COUNT(*)*SUM(Totaltackles*Totaltackles)- POW(SUM(Totaltackles),2))*
						(COUNT(*)*SUM(Totalshotontarget*Totalshotontarget)- POW(SUM(Totalshotontarget),2))) = 0 THEN NULL 
					ELSE (COUNT(*)*SUM(Totaltackles*Totalshotontarget) - SUM(Totaltackles)*SUM(Totalshotontarget))
                    /
                    SQRT((COUNT(*)*SUM(Totaltackles*Totaltackles)- POW(SUM(Totaltackles),2))*
                    (COUNT(*)*SUM(Totalshotontarget*Totalshotontarget)- POW(SUM(Totalshotontarget),2)))
                    END AS Tackles_vs_Shots_on_Target,
			CASE WHEN SQRT((COUNT(*)*SUM(Totalints*Totalints)- POW(SUM(Totalints),2))*
						(COUNT(*)*SUM(Totalshotontarget*Totalshotontarget)- POW(SUM(Totalshotontarget),2))) = 0 THEN NULL 
					ELSE (COUNT(*)*SUM(Totalints*Totalshotontarget) - SUM(Totalints)*SUM(Totalshotontarget))
                    /
                    SQRT((COUNT(*)*SUM(Totalints*Totalints)- POW(SUM(Totalints),2))*
                    (COUNT(*)*SUM(Totalshotontarget*Totalshotontarget)- POW(SUM(Totalshotontarget),2)))
                    END AS Ints_vs_Shots_on_Target
        FROM goalkeeper_vs_defender_stats; -- NO CORR

		-- Which players have the highest impact on match outcomes based on combined xG and xAG?
        SELECT p.LastName, p.FirstName, (SUM(p.xG + p.xAG) / p.Min)*90 AS Combined_x_90, m.ArsenalScore, m.OpponentScore
        FROM players p
        JOIN matches m
			ON m.Date = p.Date
        GROUP BY LastName, FirstName,Min,m.ArsenalScore, m.OpponentScore
        ORDER BY Combined_x_90 DESC
        LIMIT 10;
        
        -- Are there specific stadiums where Arsenal performs significantly better or worse in terms of goal difference?
        SELECT Stadium, AVG(ArsenalScore - OpponentScore) AS avg_goal_diff
        FROM matches
        GROUP BY Stadium;
        
-- SEASONAL TRENDS AND COMPARISON

		-- How has Arsenal’s average expected goals (xG) per match changed across seasons, and does it align with actual goals scored?
        SELECT m.Season, AVG(p.xG) AS avgxg, AVG(p.G) AS avggoals
        FROM players p
        JOIN matches m
			ON p.Date = m.Date
        GROUP BY Season;

		-- Which season saw the highest number of progressive passes (PrgPas) by Arsenal players, and which players contributed most?
       WITH seasonprgpas AS (
       SELECT m.Season, SUM(p.PrgPas) AS totalprgpas
       FROM players p
       JOIN matches m
			ON m.Date = p.Date
		GROUP BY m.Season
       ),
       top_season AS(
       SELECT Season
       FROM seasonprgpas
       WHERE totalprgpas = (SELECT MAX(totalprgpas) FROM seasonprgpas)
       )
       SELECT 
			p.LastName, p.FirstName, COUNT(p.Date) AS matchplayed, SUM(p.PrgPas) AS Totalprgpass, 
			SUM(p.PrgPas) / COUNT(*) AS prgpass_per_match
		FROM players p 
        JOIN matches m
			ON m.Date = p.Date
		JOIN top_season ts
			ON ts.Season = m.Season
		GROUP BY p.LastName, p.FirstName
        ORDER BY Totalprgpass DESC
        LIMIT 5
       ;

		-- How does the number of shots on target (SoT) by Arsenal players correlate with match outcomes (win/loss/draw)?
	CREATE TEMPORARY TABLE SoT_Result 
	SELECT 
		p.Date,p.SoT, CASE WHEN m.ArsenalScore > m.OpponentScore THEN 1 
					WHEN m.ArsenalScore < m.OpponentScore THEN 2
					WHEN m.ArsenalScore = m.OpponentScore THEN 3
				ELSE 0 END AS match_result
	FROM players p
	JOIN matches m
		ON m.Date = p.Date
	GROUP BY p.Date,p.SoT;

	SELECT  match_result, AVG(SoT)
	FROM SoT_Result
	GROUP BY match_result
	ORDER BY field(match_result,1,2 ,3);


-- SPECIFIC MATCH AND PLAYER INSIGHTS
		-- In matches where Arsenal conceded no goals (GA == 0), which defenders had the highest number of tackles and interceptions?
		SELECT p.LastName, p.FirstName,g.GA,SUM(p.Tackles) AS total_tackles, SUM(p.Ints) AS total_ints
        FROM players p
        JOIN goalkeepers g
			ON p.Date = g.Date
		
        WHERE Line = 'Defender' AND g.GA = 0
        GROUP BY LastName, FirstName
        ORDER BY total_tackles DESC,total_ints DESC
        LIMIT 10;
        
		-- How did Aaron Ramsdale’s performance (e.g., Saves, PSxG) in the 2022/23 season compare to Bernd Leno’s in the 2021/22 season?
		(SELECT AVG(g.Saves) AS avg_saves, AVG(g.PSxG) AS avg_PSxG, AVG(g.GA) AS avg_ga
        FROM goalkeepers g
        JOIN matches m
				ON g.Date = m.Date
        WHERE LastName = 'Ramsdale' AND m.Season = '2022/23')
        UNION
        (SELECT AVG(g.Saves) AS avg_saves, AVG(g.PSxG) AS avg_PSxG, AVG(g.GA) AS avg_ga
        FROM goalkeepers g
        JOIN matches m
				ON g.Date = m.Date
        WHERE LastName = 'Leno' AND m.Season = '2021/22');






































































