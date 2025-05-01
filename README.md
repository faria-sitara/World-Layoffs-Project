# 📊 Layoffs Data Cleaning and Analysis (SQL Project)

This project involves cleaning and analyzing a dataset of tech layoffs using SQL. The goal is to transform raw layoff data into a clean, analyzable format and perform exploratory data analysis (EDA) to derive key insights.

## 🛠️ Tools Used
- MySQL

## 📁 Dataset
- **Source**: Layoffs data (imported into a table named `layoffs`)
- Includes: company name, location, industry, total and percentage laid off, date, stage, country, and funds raised.

## 🧹 Project Steps

### 1. Data Preparation
- Created a staging table (`layoffs_staging`) to preserve the original dataset 📦
- Duplicated raw data for cleaning

### 2. 🔁 Remove Duplicates
- Identified duplicates using `ROW_NUMBER()`
- Removed them via a second staging table (`layoffs_staging2`)

### 3. 🧼 Standardize Data
- Trimmed whitespace from company and country names
- Standardized entries like "Crypto"
- Converted `date` from string to proper `DATE` format 📅

### 4. 🔍 Handle Null and Blank Values
- Replaced blanks (`''`) with `NULL`
- Populated missing values using self-joins (e.g., missing `industry`)
- Deleted rows where both `total_laid_off` and `percentage_laid_off` were `NULL`

### 5. ✅ Final Cleanup
- Dropped helper columns like `row_num`
- Final clean data is stored in `layoffs_staging2`

## 📈 Exploratory Data Analysis (EDA)

### Key Insights & Queries:
- 🏢 Companies with 100% layoffs
- 💰 Companies with high funding that still had large layoffs
- 🔝 Top 10 companies by total layoffs
- 📆 Layoff trends (monthly & yearly)
- 📊 Rolling totals and % changes in layoffs
- 🏭 Industry ranking by average funding vs layoffs

### Example Metrics:
- 📉 Min/Max `percentage_laid_off`
- 📊 Total layoffs by year/month
- 🧠 Rank difference to analyze industry stability vs funding

## 📌 Summary
This SQL-based project showcases a full data pipeline:
- Data cleaning 🧽
- Deduplication 🗑️
- Transformation 🔧
- Exploratory insights 🔍

