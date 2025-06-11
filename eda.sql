USE laptopdb;

SELECT * FROM laptops;


# 1. Head / Tail / Sample

# Head
SELECT *
FROM laptops
ORDER BY `index` ASC
LIMIT 5;

# Tail
SELECT *
FROM laptops
ORDER BY `index` DESC
LIMIT 5;

# Sample
SELECT *
FROM laptops
ORDER BY RAND()
LIMIT 5;


# 2. For Numerical Columns
		-- 8 Number Summary [Count, Max, Min, Mean/AVG, STD, Q1, Q2, Q3]
        -- Missing Values
        -- Outliers
        -- Horizontal / Vertical Histogram
        
# 8 Number Summary
SELECT MIN(Price) OVER(), 
				MAX(Price) OVER(), 
                AVG(Price) OVER(), 
                COUNT(Price) OVER(),  
                STD(Price) OVER(), 
				PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q1',
                PERCENTILE_CONT(0.50) WITHIN GROUP(ORDER BY Price) OVER() AS 'Median',
                PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q3'
FROM laptops
ORDER BY `index`
LIMIT 1;

# Checking Missing Values
SELECT COUNT(Price)
FROM laptops
WHERE Price IS NULL;

# Outliers
SELECT *
FROM (
				SELECT *,
							PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q1',
							PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q3'
				FROM laptops
) t
WHERE 	t.Price < t.Q1 - (1.5*(t.Q3 - t.Q1)) OR 
				t.Price > t.Q1 + (1.5*(t.Q3 - t.Q1));

# Horizontal / Vertical Histogram

# Horizontal Histogram
SELECT t.buckets, COUNT(*) ,REPEAT('*', COUNT(*)/5)
FROM (
			SELECT Price,
			CASE	
						WHEN Price BETWEEN 0 AND 25000 THEN  '0 - 25K'
						WHEN Price BETWEEN 25001 AND 50000 THEN  '25K - 50K'
						WHEN Price BETWEEN 50001 AND 75000 THEN  '50K - 75K'
						WHEN Price BETWEEN 75001 AND 100000 THEN  '75K - 100K'
						WHEN Price BETWEEN 100001 AND 125000 THEN  '100K - 125K'
						WHEN Price BETWEEN 125001 AND 150000 THEN  '125K - 150K'
						WHEN Price BETWEEN 150001 AND 175000 THEN  '150K - 175K'
						WHEN Price BETWEEN 175001 AND 200000 THEN  '175K - 200K'
						WHEN Price BETWEEN 200001 AND 225000 THEN  '200K - 225K'
						WHEN Price BETWEEN 225001 AND 250000 THEN  '225K - 250K'
						WHEN Price BETWEEN 250001 AND 275000 THEN  '250K - 275K'
						WHEN Price BETWEEN 275001 AND 300000 THEN  '275K - 300K'
						WHEN Price BETWEEN 300001 AND 400000 THEN  '300K - 400K'
			END AS 'buckets'
			FROM laptops
) t
GROUP BY t.buckets;


# 3. For Categorical Columns
		-- Value Counts > Pie Chart
        -- Missing Values

SELECT Company, COUNT(Company)
FROM laptops
GROUP BY Company;


# 4. Numerical - Numerical
		-- Side by Side 8 number analysis
        -- Scatterplot
        -- Correlation

# Side by Side 8 number analysis
SELECT MIN(Price) OVER(), MIN(Inches) OVER(), 
				MAX(Price) OVER(), MAX(Inches) OVER(), 
                AVG(Price) OVER(), AVG(Inches) OVER(), 
                COUNT(Price) OVER(),  COUNT(Inches) OVER(),  
                STD(Price) OVER(), STD(Inches) OVER(), 
				PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q1', 
                PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY Inches) OVER() AS 'Q1',
                PERCENTILE_CONT(0.50) WITHIN GROUP(ORDER BY Price) OVER() AS 'Median',
                PERCENTILE_CONT(0.50) WITHIN GROUP(ORDER BY Inches) OVER() AS 'Median',
                PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q3',
                PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY Inches) OVER() AS 'Q3'
FROM laptops
ORDER BY `index`
LIMIT 1;

# Scatterplot

SELECT cpu_speed, Price
FROM laptops;

# Correlation
SELECT 
    (COUNT(*) * SUM(cpu_speed * Price) - SUM(cpu_speed) * SUM(Price)) /
    SQRT((COUNT(*) * SUM(cpu_speed * cpu_speed) - POW(SUM(cpu_speed), 2)) * (COUNT(*) * SUM(Price * Price) - POW(SUM(Price), 2))
    ) AS correlation_coefficient
FROM laptops
WHERE cpu_speed IS NOT NULL AND Price IS NOT NULL;


# 5. Categorical - Categorical
		-- Contigency Table > Stcaked Bar Chart

SELECT Company,
    SUM(CASE WHEN touchscreen = 1 THEN 1 ELSE 0 END) AS Touchscreen_Yes,
    SUM(CASE WHEN touchscreen = 0 THEN 1 ELSE 0 END) AS Touchscreen_No
FROM laptops
GROUP BY Company;


SELECT Company,
    SUM(CASE WHEN cpu_brand = 'Intel' THEN 1 ELSE 0 END) AS 'Intel',
    SUM(CASE WHEN cpu_brand = 'AMD' THEN 1 ELSE 0 END) AS 'AMD',
    SUM(CASE WHEN cpu_brand = 'Samsung' THEN 1 ELSE 0 END) AS 'Samsung'
FROM laptops
GROUP BY Company;


# 6. Numerical - Categorical
		-- Compare distribution across categories


# 7. Missing Value Treatment


# 8. Feature Engineering
		-- PPI
        -- Price Bracket


# 9. One Hot Encoding

















