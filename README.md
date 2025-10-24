# World Layoffs Data Analysis Project

## 📊 Project Overview
A comprehensive SQL-based data analysis project examining global layoff trends from 2020-2023. This project involves extensive data cleaning, standardization, and exploratory data analysis to uncover insights about workforce reductions across industries, companies, and geographic locations.

## 🎯 Business Problem
Understanding the patterns and drivers behind global layoffs to identify:
- Most affected industries and companies
- Geographic concentrations of workforce reductions
- Temporal trends and peak layoff periods
- Relationships between funding and layoffs
- High-risk sectors and companies

## 📁 Project Structure

```
world-layoffs-analysis/
│
├── data/
│   └── world_layoffs.layoffs
│
├── sql/
│   └── Layoffs_init_data_exploration_pt1.sql
    └── Layoffs_data_cleaning_and_standardization_pt2.sql
    └── Layoffs_exploratory_data_analysis_pt3.sql
│
│── README.md

```

## 🛠️ Technical Stack
- **Database**: MySQL
- **Tools**: SQL, CTEs, Window Functions, Data Cleaning Techniques
- **Analysis**: Exploratory Data Analysis, Trend Analysis, Statistical Summaries

## 📈 Dataset Information
The dataset contains layoff information with the following columns:
- `company`: Company name
- `location`: Geographic location
- `industry`: Industry sector
- `total_laid_off`: Number of employees laid off
- `percentage_laid_off`: Percentage of workforce laid off
- `date`: Date of layoff announcement
- `stage`: Company stage (Startup, Public, etc.)
- `country`: Country of operation
- `funds_raised_millions`: Total funds raised in millions

## 🔧 Data Cleaning Process

### 1. Duplicate Removal

- Identified and removed duplicate records using ROW_NUMBER()
- Removed 4 duplicate entries

### 2. Standardization

- Company Names: Trimmed whitespace
- Industry Names: Standardized crypto-related industries ("Crypto", "CryptoCurrency", "Crypto Currency" → "Crypto")
- Country Names: Fixed "United States." to "United States"
- Date Format: Converted from text to proper DATE format

### 3. Missing Value Handling

- Filled missing industry data using company matching
- Removed records with no layoff information (both total_laid_off and percentage_laid_off null)

### 4. Data Validation

- Ensured data consistency across all fields
- Validated date ranges and numeric values

## Major Findings

### 🚨 Critical Insights

### Tech Giants Dominated Layoffs
- **Amazon**: 18,150 employees
- **Google**: 12000 employees  
- **Meta**: 11,000 employees
- **Salesforce**:10,090 employees

### Consumer Sector Hit Hardest
- **Consumer**: 45,182 layoffs
- **Retail**: 43,613 layoffs
- Significant impact beyond tech sector

### Geographic Concentration
- **SF Bay Area**: 125,631 layoffs
- **Seattle**: 34,743 layoffs
- Traditional tech hubs disproportionately affected

### Temporal Peaks
- **January 2023**: 84,714 layoffs (worst month)
- **November 2022**: 53,451 layoffs
- Year-start appears to be peak restructuring period

### Accelerating Trend
- **2023 Q1**: 150,000+ layoffs
- Concerning acceleration pattern observed





