-- EXPLORATORY DATA ANALYSIS

SELECT * 
FROM layoffs_staging2;

-- 1. Looking at Percentage to see how big these layoffs were

SELECT MIN(percentage_laid_off) AS minimum_percentage_laidOff, MAX(percentage_laid_off) AS maximum_percentage_laidOff
FROM layoffs_staging2
WHERE percentage_laid_off IS NOT NULL;

-- 2. Which companies had 1 which is basically 100 percent of the company laid off

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off desc;

-- 3. if we order by funDs_raised_millions we can see how big some of these companies were
-- BritishVolt: Despite being in the promising EV sector, faced significant layoffs.
-- Quibi: Raised approximately $2 billion but ultimately ceased operations, leading to layoffs.

SELECT *
FROM layoffs_staging2
WHERE  percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- 4. Top 10 Companies with the most Total Layoffs

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 desc
LIMIT 10;

SELECT min(date) AS min_date, MAX(date) AS max_date
FROM layoffs_staging2;

-- 5. Annual Layoffs by Year

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 desc;


-- 6. Earlier we looked at Companies with the most Layoffs. Now let's look at that per year.

WITH Company_year AS (
SELECT company, YEAR(`date`) AS years, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company, years
),
Company_rank AS (
SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years order BY total_laid_off DESC) AS ranking
FROM Company_year
)
SELECT company, years, total_laid_off, ranking
FROM Company_rank
WHERE years IS NOT NULL AND ranking <= 3;

-- 7. Rolling Total of Layoffs Per Month

WITH Monthly_total AS (
SELECT substring(`date`, 1, 7) AS months, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE `date` is not null
GROUP BY months
ORDER BY months DESC)
SELECT months, total_off, SUM(total_off) OVER (ORDER BY months) AS rolling_total
FROM Monthly_total;

-- 8. Percentage Change in Layoffs Between Two Consecutive Months:

WITH Monthly_total AS (
SELECT substring(`date`, 1, 7) AS months, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE `date` is not null
GROUP BY months
ORDER BY months DESC),
Lagged_Summary AS(
SELECT months, total_off, LAG(total_off) OVER (ORDER BY months) AS previous_month_layoff
FROM Monthly_total
)
select months, total_off, previous_month_layoff, total_off - previous_month_layoff AS layoff_difference,
ROUND ( CASE WHEN previous_month_layoff = 0 THEN null
	ELSE (total_off - previous_month_layoff)/ previous_month_layoff * 100
END, 2) AS percentage_change
FROM lagged_Summary
WHERE previous_month_layoff IS NOT NULL;

-- 9. Companies with Significant Funds Raised but Still Had Layoffs

SELECT 
    company,
    location,
    industry,
    total_laid_off,
    funds_raised_millions
FROM
    layoffs_staging2
WHERE
    funds_raised_millions > (SELECT 
            AVG(funds_raised_millions)
        FROM
            layoffs_staging2
        WHERE
            funds_raised_millions IS NOT NULL)
        AND total_laid_off > 100;

-- 10. Calculate Average Funds Raised, Total Layoffs, and Rank Difference by Industry

-- The rank_difference helps in understanding how industries fare 
-- in terms of their financial health (funding) versus their workforce dynamics (layoffs). 
-- A negative rank_difference generally indicates industries with lower layoffs relative to their funding, 
-- suggesting stability or efficient management. 
-- Conversely, a positive rank_difference may indicate industries with higher layoffs despite good funding, 
-- highlighting potential challenges or inefficiencies in workforce management.

WITH IndustrySummary AS(
SELECT industry, AVG( funds_raised_millions ) AS average_funds, SUM( total_laid_off ) AS total_layoffs
FROM layoffs_staging2
WHERE funds_raised_millions IS NOT NULL AND total_laid_off IS NOT NULL
GROUP BY industry
),
IndustryRank AS(
SELECT industry, average_funds, total_layoffs, 
RANK() OVER(ORDER BY average_funds DESC) AS rank_fund,
RANK() OVER(ORDER BY total_layoffs DESC) AS rank_layoff
FROM IndustrySummary
)
SELECT industry, average_funds, total_layoffs, rank_fund, rank_layoff, CAST(rank_fund AS SIGNED) - CAST(rank_layoff AS SIGNED) AS rank_difference
FROM IndustryRank
ORDER BY rank_fund;

