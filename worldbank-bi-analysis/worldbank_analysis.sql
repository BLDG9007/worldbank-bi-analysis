-- =========================================
-- WORLD BANK SQL ANALYSIS PROJECT
-- Author: Brandon L.D. Govender
-- =========================================

USE BI_Week2;
GO

-- =========================================
-- SECTION 1: BASIC ANALYSIS
-- =========================================

-- Top Economies by GDP
SELECT TOP 5 
    Country, 
    SUM(GDP_USD) AS Total_GDP
FROM dbo.worldbank
GROUP BY Country
ORDER BY Total_GDP DESC;

-- Rank countries by total GDP
SELECT 
    Country,
    SUM(GDP_USD) AS Total_GDP,
    RANK() OVER (ORDER BY SUM(GDP_USD) DESC) AS GDP_Rank
FROM dbo.worldbank
GROUP BY Country;

-- Year-over-year GDP change
SELECT 
    Country,
    Year,
    GDP_USD,
    LAG(GDP_USD) OVER (PARTITION BY Country ORDER BY Year) AS Prev_Year_GDP,
    GDP_USD - LAG(GDP_USD) OVER (PARTITION BY Country ORDER BY Year) AS Growth_Change
FROM dbo.worldbank;

-- Top country by GDP each year
WITH RankedGDP AS (
    SELECT 
        Country,
        Year,
        GDP_USD,
        RANK() OVER (PARTITION BY Year ORDER BY GDP_USD DESC) AS Rank_Per_Year
    FROM dbo.worldbank
)
SELECT *
FROM RankedGDP
WHERE Rank_Per_Year = 1;

-- Rolling average GDP (3-year window)
SELECT 
    Country,
    Year,
    AVG(GDP_USD) OVER (
        PARTITION BY Country 
        ORDER BY Year 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS Rolling_Avg_GDP
FROM dbo.worldbank;

-- Classify economic performance
SELECT 
    Country,
    Year,
    GDP_Growth,
    CASE 
        WHEN GDP_Growth > 5 THEN 'High Growth'
        WHEN GDP_Growth BETWEEN 2 AND 5 THEN 'Moderate Growth'
        WHEN GDP_Growth BETWEEN 0 AND 2 THEN 'Low Growth'
        ELSE 'Negative Growth'
    END AS Growth_Category
FROM dbo.worldbank;