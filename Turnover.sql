--1. Which sectors show the greatest increase and decrease in turnover over the years available?
  SELECT 
  [Company Type], 
  SUM([2020 Turnover]) AS [2020 Turnover],
  SUM([2021 Turnover]) AS [2021 Turnover],
  SUM([2022 Turnover]) AS [2022 Turnover],
  SUM([2023 Turnover]) AS [2023 Turnover],
  SUM([2024 Turnover]) AS [2024 Turnover],
  SUM ([2024 Turnover] - [2020 Turnover]) AS turnover_change
FROM [dbo].[Turnover_Data]
GROUP BY[Company Type]
ORDER BY turnover_change DESC;

--2. What is the LEAST common month to incorporate a business? Is this true for all Company Types?  
SELECT 
  [Company Type],
  MONTH([IncorporationDate]) AS IncorporationMonth,
  DATENAME(month, [IncorporationDate]) AS MonthName,
  COUNT(*) AS IncorporationCount
FROM [dbo].[Turnover_Data]
GROUP BY [Company Type], MONTH([IncorporationDate]), DATENAME(month, [IncorporationDate])
ORDER BY [Company Type], IncorporationCount ASC;

--3. Which sectors are driving growth in high-performing regions
With high_performing_regions as
 (
 SELECT [Postcode], 
  SUM([2020 Turnover]) AS [2020 Turnover],
  SUM([2022 Turnover]) AS [2022 Turnover],
  SUM([2023 Turnover]) AS [2023 Turnover],
  SUM([2024 Turnover]) AS [2024 Turnover],
  (SUM([2024 Turnover]) - SUM([2020 Turnover])) AS [Growth],
  (SUM([2024 Turnover]) - SUM([2020 Turnover])) * 100.0 / NULLIF(SUM([2020 Turnover]), 0) as percentage_growth
 FROM [dbo].[Turnover_Data] 
 GROUP BY [Postcode]
 
 )
 select top (10)[Postcode], [Growth], percentage_growth 
 from high_performing_region
 where Postcode not in ('All')
 order by [Growth] desc, percentage_growth desc

--4. What is the total turnover for "Farming" broken down by years? 
select
  [Company Type], 
  SUM([2020 Turnover]) AS [2020 Turnover],
  SUM([2021 Turnover]) AS [2021 Turnover],
  SUM([2022 Turnover]) AS [2022 Turnover],
  SUM([2023 Turnover]) AS [2023 Turnover],
  SUM([2024 Turnover]) AS [2024 Turnover]
  FROM [dbo].[Turnover_Data]
  Where [Company Type] = 'Farming'
  group by [Company Type]
