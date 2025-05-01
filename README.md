# Layoffs Data Cleaning and Analysis (SQL Project)

This project involves cleaning and analyzing a dataset of tech layoffs using SQL. The goal is to transform raw layoff data into a clean, analyzable format and perform exploratory data analysis (EDA) to derive key insights.

## Tools Used
- MySQL

## Dataset
- Source: Layoffs data (uploaded into a table named `layoffs`)
- Contains information on company layoffs including company name, location, industry, number and percentage laid off, date, stage, country, and funds raised.

## Project Steps

### 1. Data Preparation
- Created a staging table (`layoffs_staging`) to preserve the original data.
- Copied the raw data into the staging table.

### 2. Remove Duplicates
- Identified duplicates using `ROW_NUMBER()` and removed them by creating a second staging table (`layoffs_staging2`).

### 3. Standardize Data
- Trimmed whitespace and corrected inconsistencies (e.g., "Crypto" variations, country names).
- Converted `date` column from text to proper `DATE` format.

### 4. Handle Null and Blank Values
- Replaced blank strings with `NULL`.
- Used self-join logic to populate missing `industry` values based on matching companies.
- Removed rows with both `total_laid_off` and `percentage_laid_off` as `NULL`.

### 5. Data Cleaning Finalization
- Dropped helper column (`row_num`) after cleaning.
- Final clean data is in `layoffs_staging2`.

## Exploratory Data Analysis (EDA)

### Key Insights and Queries:
- Companies with 100% layoffs (`percentage_laid_off = 1`)
- Companies with high funding but still faced major layoffs
- Top 10 companies by total layoffs
- Layoffs trends over time (monthly and yearly)
- Rolling total of layoffs per month
- Monthly percentage change in layoffs
- Ranking industries by average funding vs total layoffs

### Example Metrics:
- Min/Max `percentage_laid_off`
- Layoffs over time (yearly and monthly)
- Industry-level stability using rank difference of funding vs layoffs

## Summary
This project demonstrates a full SQL-based data cleaning and analysis workflow—covering data deduplication, standardization, null handling, and exploratory analysis—all using MySQL.
