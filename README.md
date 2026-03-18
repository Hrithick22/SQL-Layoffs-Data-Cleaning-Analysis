# SQL-Layoffs-Data-Cleaning-Analysis
SQL project for cleaning and analyzing global layoffs dataset using MySQL

# Global Layoffs Data Cleaning and Analysis (SQL Project)

## Project Overview
This project focuses on cleaning and analyzing a global layoffs dataset using SQL.  
The goal of the project is to demonstrate practical SQL skills used in real-world data analytics workflows.

The project includes:

• Data cleaning  
• Removing duplicate records  
• Data standardization  
• Handling NULL and missing values  
• Converting text fields to proper data types  
• Exploratory data analysis (EDA)

This project simulates a real ETL and analysis pipeline commonly used in data analytics.

---

## Dataset
The dataset contains global layoff information including:

- Company
- Industry
- Location
- Total employees laid off
- Percentage laid off
- Date of layoffs
- Company funding stage
- Country

---

## SQL Techniques Used

### 1 Data Cleaning
- Created staging tables
- Removed duplicate records using `ROW_NUMBER()`
- Used `PARTITION BY` window functions

### 2 Data Standardization
- Trimmed inconsistent company names
- Standardized industry names
- Cleaned country names
- Converted date from text format to SQL date type

### 3 Handling Missing Values
- Replaced blank values with NULL
- Filled missing industry values using self joins
- Removed irrelevant rows where layoffs data was missing

### 4 Exploratory Data Analysis
Performed several analytical queries including:

- Companies with highest layoffs
- Layoffs by industry
- Layoffs by year
- Monthly layoff trends
- Rolling totals
- Top companies with layoffs per year using ranking functions

---

## SQL Concepts Demonstrated

- Window Functions
- CTE (Common Table Expressions)
- Data Cleaning
- Data Transformation
- Aggregate Analysis
- Ranking Functions
- Rolling Calculations

---

## Tools Used

- MySQL
- SQL

---

## Author

Hrithik  
Aspiring Data Analyst transitioning from a Chemistry background into data analytics.
