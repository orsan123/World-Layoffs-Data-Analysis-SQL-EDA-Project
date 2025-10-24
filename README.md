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

│
├── data/
│ └── world_layoffs.layoffs (original dataset)
│
├── sql/
│ └── layoffs_analysis.sql (complete analysis script)
│
├── documentation/
│ └── README.md (this file)
│
└── insights/
└── key_findings_summary.md

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
```sql
-- Identified and removed duplicate records using ROW_NUMBER()
-- Removed 4 duplicate entries
