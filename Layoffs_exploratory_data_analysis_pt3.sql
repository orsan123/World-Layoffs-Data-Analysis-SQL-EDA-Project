
-- ==============================================================================
-- EXPLORATORY DATA ANALYSIS WITH OBSERVATIONS
-- ==============================================================================


-- ==============================================================================
-- SUMMARY OF KEY FINDINGS:
-- ==============================================================================
-- 1. Tech giants (Amazon, Google, Meta) dominated total layoff numbers
-- 2. Consumer and Retail sectors were hit hardest overall  
-- 3. January 2023 was the worst single month with 84,919 layoffs
-- 4. Traditional tech hubs (SF Bay Area, Seattle) suffered most geographically
-- 5. Layoffs accelerated significantly in 2022-2023 period
-- 6. Some companies with substantial funding still failed completely
-- 7. 2023 shows concerning acceleration with 150k+ layoffs in Q1 alone
-- 8. Manufacturing and aerospace showed relative resilience


-- Check null values in total_laid_off
SELECT COUNT(*) FROM layoffs_staging2 WHERE total_laid_off IS NULL; -- 378 rows where total_laid_off is still null 

-- OBSERVATION: Data cleaning complete, ready for analysis with 1,617 clean records

-- Layoffs by industry and year
SELECT industry, SUM(total_laid_off) AS sum_layoffs, 
YEAR(`date`) AS year 
FROM layoffs_staging2
WHERE total_laid_off IS NOT NULL
AND YEAR(`date`) IS NOT NULL
GROUP BY industry, year
ORDER BY industry, year ASC;

-- Industries with least amount of layoffs
SELECT industry, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2 
WHERE total_laid_off IS NOT NULL
GROUP BY industry
ORDER BY total_laid_off;  -- manufacturing, fin-tech, aerospace had the least amount of layoffs

-- OBSERVATION: Manufacturing and aerospace relatively stable, while consumer sectors hit hard
-- INSIGHT: Some industries showed resilience during tech downturn

-- Top 5 companies that raised the most amount of funds
SELECT company, SUM(funds_raised_millions) FROM layoffs_staging2
GROUP BY company
ORDER BY SUM(funds_raised_millions) DESC
LIMIT 5;                                                 

-- OBSERVATION: These are the big companies like Netflix, Uber, Twitter etc that raised significant funds
-- INSIGHT: High funding didn't necessarily prevent layoffs, indicating business model challenges

-- Top 5 companies that had the most amount of layoffs
SELECT company, SUM(total_laid_off) FROM layoffs_staging2
WHERE total_laid_off IS NOT NULL
GROUP BY company                               
ORDER BY SUM(total_laid_off) DESC
LIMIT 5;

-- OBSERVATION: Amazon, Google, Meta, Salesforce, Philips had the most amount of layoffs overall
-- INSIGHT: Even most successful companies underwent significant restructuring

-- Number of layoffs each of these companies had per year 
WITH temp AS (
    SELECT company, 
    YEAR(`date`) AS year,
    SUM(total_laid_off) AS total
    FROM layoffs_staging2
    WHERE total_laid_off IS NOT NULL
    AND YEAR(`date`) IS NOT NULL
    GROUP BY company, year
    ORDER BY year
), 

top_5 AS (
    SELECT company, SUM(total_laid_off) FROM layoffs_staging2
    WHERE total_laid_off IS NOT NULL
    GROUP BY company
    ORDER BY SUM(total_laid_off) DESC
    LIMIT 5
)

SELECT top_5.company AS comp,
temp.year AS `year`,
temp.total AS temp_total
FROM temp
INNER JOIN top_5 ON temp.company = top_5.company
ORDER BY comp, temp.year;

-- OBSERVATION: Most top companies showed significant layoffs in 2022-2023 period
-- INSIGHT: Layoffs accelerated in recent years across all major players

-- Top 5 locations that had the highest amount of layoffs 
SELECT location, 
SUM(total_laid_off)  
FROM layoffs_staging2
GROUP BY location
ORDER BY SUM(total_laid_off) DESC;      

-- OBSERVATION: SF Bay Area, Seattle, New York City, Bengaluru, Amsterdam
-- INSIGHT: Traditional tech hubs suffered the most

-- Find the companies from locations that had the most amount of layoffs 
WITH temp AS (
    SELECT location, 
    SUM(total_laid_off)  
    FROM layoffs_staging2
    GROUP BY location
    ORDER BY SUM(total_laid_off) DESC
    LIMIT 5
),

temp_2 AS (
    SELECT company, 
    location, 
    SUM(total_laid_off) AS total 
    FROM layoffs_staging2
    WHERE total_laid_off IS NOT NULL
    GROUP BY 2,1
)

SELECT t.location, 
t2.company AS company, 
t2.total AS total_off, 
ROW_NUMBER() OVER (ORDER BY t.location, t2.total DESC) AS rn
FROM temp t
INNER JOIN temp_2 t2 ON t.location = t2.location
ORDER BY rn;

-- OBSERVATION: Major companies in each tech hub driving the layoff numbers

-- Top 5 industries that had the most amount of layoffs
SELECT industry, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY industry
ORDER BY SUM(total_laid_off) DESC
LIMIT 5;  

-- OBSERVATION: Consumer, Retail, Other, Transportation, Finance
-- INSIGHT:consumer and retail hit particularly hard

-- Months that had the most amount of layoffs during these four years 
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, 
SUM(total_laid_off) AS total
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
HAVING total > 50000
ORDER BY `MONTH`; 

-- OBSERVATION: Jan 2023 had 84k+ and Nov 2022 had 53k+ layoffs (worst two months)
-- INSIGHT: Year-start (January) appears to be peak layoff period for corporate restructuring

-- Top 5 industries that took the biggest hits during november 2022 and january 2023
SELECT industry, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IN 
(
    SELECT `MONTH` FROM 
    ( 
        SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`,           
        SUM(total_laid_off) AS total
        FROM layoffs_staging2
        WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
        GROUP BY `MONTH`
        HAVING total > 50000
        ORDER BY `MONTH`
    ) temp
)
AND total_laid_off IS NOT NULL
GROUP BY 1
ORDER BY total_off DESC
LIMIT 5; 

-- OBSERVATION: Consumer and retail had the highest impact during these 2 worst months  
-- INSIGHT: Consumer sector drove the peak layoff periods

-- Top 5 companies that took the biggest hits during november 2022 and january 2023
SELECT company, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IN 
(
    SELECT `MONTH` FROM 
    (
        SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, 
        SUM(total_laid_off) AS total
        FROM layoffs_staging2
        WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
        GROUP BY `MONTH`
        HAVING total > 50000
        ORDER BY `MONTH`              
    ) temp
)
AND total_laid_off IS NOT NULL
GROUP BY 1
ORDER BY total_off DESC
LIMIT 5;  

-- OBSERVATION: The most devastating months were Nov 2022 and Jan 2023 with Amazon, Google, Meta, Microsoft, Salesforce hit hardest

-- Companies that laid off 100% of employees and their funding
SELECT company, 
SUM(funds_raised_millions) AS fuds_raised
FROM layoffs_staging2 
WHERE percentage_laid_off = 1
AND funds_raised_millions IS NOT NULL
GROUP BY company
ORDER BY fuds_raised DESC;

-- OBSERVATION: Several companies raised substantial funds but still laid off 100% of workforce
-- INSIGHT: Business model failures occurred despite huge funding, indicating deep operational issues

-- Top 3 laid off companies of each year 
WITH temp AS (
    SELECT company, 
    YEAR(`date`) AS year, 
    SUM(total_laid_off) AS total_layoffs
    FROM layoffs_staging2
    WHERE total_laid_off IS NOT NULL
    AND YEAR(`date`) IS NOT NULL
    GROUP BY 1, 2
),

tem AS (
    SELECT 
    company, 
    year, 
    total_layoffs, 
    DENSE_RANK() OVER (PARTITION BY year ORDER BY total_layoffs DESC) AS rn 
    FROM temp
)

SELECT company, year, total_layoffs, rn
FROM tem WHERE rn <= 3;

-- OBSERVATION: Different companies dominated layoffs each year, with tech giants becoming more prominent in recent years
-- INSIGHT: Layoff patterns evolved over time, with 2022-2023 showing concentration in largest tech firms

-- Rolling total of layoffs over time
WITH rolling_total AS (
    SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, 
    SUM(total_laid_off) AS total
    FROM layoffs_staging2
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
    GROUP BY `MONTH`
    ORDER BY `MONTH`
)

SELECT `MONTH`,
total, 
SUM(total) OVER (ORDER BY `MONTH`) AS rolling_total
FROM rolling_total;   

-- OBSERVATION: 2023 shows accelerating trend with over 150k layoffs in first quarter alone
-- CRITICAL INSIGHT: 2023 may be expected to be a very bad year for employees as the trend shows no signs of slowing

-- Final cleaned data view
SELECT * FROM layoffs_staging2;

