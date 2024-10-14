-- Data Cleaning


SELECT *
FROM layoffs;

-- Remove Duplicates
-- Standardize the Data
-- Null values or blank spaces
-- Remove any columns


-- Remove duplicates
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, 'date') AS row_num
FROM layoffs;

WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country,
funds_raised_millions) AS row_num
FROM layoffs
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Found one duplicate
SELECT *
FROM layoffs
WHERE company = 'Oyster';

DELETE
FROM layoffs
WHERE row_num > 1;

SELECT *
FROM layoffs;

-- Standardize the data

SELECT company, TRIM(company)
FROM layoffs;

UPDATE layoffs
SET company = TRIM(company);

SELECT *
FROM layoffs
WHERE industry LIKE 'Crypto%';

UPDATE layoffs
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs
ORDER BY 1;

UPDATE layoffs
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT `date`
FROM layoffs;

UPDATE layoffs
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Missing values

SELECT *
FROM layoffs
WHERE industry IS NULL
OR industry = '';

SELECT * 
FROM layoffs
WHERE company = 'Airbnb';

SELECT t1.industry, t2.industry
FROM layoffs t1
JOIN layoffs t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs t1
JOIN layoffs t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT * 
FROM layoffs;


-- Delete columns
SELECT * 
FROM layoffs
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL;

DELETE
FROM layoffs
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL;

SELECT *
FROM layoffs;


-- Exploratory Data Analysis

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs;

SELECT *
FROM layoffs
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT industry, SUM(total_laid_off)
FROM layoffs
GROUP BY industry
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs
GROUP BY stage
ORDER BY 1 DESC;

SELECT company, AVG(percentage_laid_off)
FROM layoffs
GROUP BY company
ORDER BY 2 DESC;

SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off
,SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;






