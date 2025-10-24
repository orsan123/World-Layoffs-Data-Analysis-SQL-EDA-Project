-- Initial data exploration
SELECT * FROM world_layoffs.layoffs;

-- Create staging table
CREATE TABLE layoffs_staging LIKE layoffs;
SELECT * FROM layoffs_staging;

-- Check for duplicates using CTE
WITH temp AS (
    SELECT *, 
    ROW_NUMBER() OVER (
        PARTITION BY company, location, industry, total_laid_off, 
        percentage_laid_off, date, stage, country, funds_raised_millions
    ) AS rn
    FROM layoffs_staging
)
SELECT * FROM temp WHERE rn = 2;

SELECT * FROM layoffs_staging WHERE company = 'Hibob';

-- Create improved staging table with row number
CREATE TABLE `layoffs_staging2` (
  `company` TEXT,
  `location` TEXT,
  `industry` TEXT,
  `total_laid_off` INT DEFAULT NULL,
  `percentage_laid_off` TEXT,
  `date` TEXT,
  `stage` TEXT,
  `country` TEXT,
  `funds_raised_millions` INT DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert data with row numbers
INSERT INTO layoffs_staging2 
SELECT *, 
ROW_NUMBER() OVER (
    PARTITION BY company, location, industry, total_laid_off, 
    percentage_laid_off, date, stage, country, funds_raised_millions
) AS rn
FROM layoffs_staging;

-- Remove duplicates
SELECT * FROM layoffs_staging2 WHERE row_num > 1;
DELETE FROM layoffs_staging2 WHERE row_num > 1;
SELECT * FROM layoffs_staging2;

-- Standardize the dataset
UPDATE layoffs_staging2 SET company = TRIM(company);
SELECT company FROM layoffs_staging2;

-- Standardize industry names
SELECT DISTINCT industry FROM layoffs_staging2 ORDER BY 1;
SELECT * FROM layoffs_staging2 WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2 
SET industry = 'Crypto' 
WHERE industry LIKE 'Crypto%';

-- Standardize country names
SELECT DISTINCT country FROM layoffs_staging2 ORDER BY 1;
SELECT *, country FROM layoffs_staging2 WHERE country LIKE 'United States.%';

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States.%';

-- Convert date format
SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y') FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Handle null and blank values
SELECT DISTINCT industry FROM layoffs_staging2;

UPDATE layoffs_staging2
SET industry = NULL 
WHERE industry = '';

-- Fill missing industry values
SELECT t1.company, t1.industry, t2.industry 
FROM layoffs_staging2 t1 
JOIN layoffs_staging2 t2 
    ON t1.company = t2.company
    AND t1.location = t2.location 
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2  
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

-- Remove records with no layoff data
SELECT * FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

-- Clean up table structure
ALTER TABLE layoffs_staging2 DROP COLUMN row_num;
SELECT * FROM layoffs_staging2;

