USE Portfolio
select [location]
      ,[date]
      ,[population]
      ,[total_cases]
      ,[new_cases]
      ,[total_deaths]
from [dbo].[coviddeaths] order by 1,2

--Case_Fatality_rate
select [location]
      ,[date]
      ,[total_cases]
      ,[total_deaths]
	  ,([total_deaths]/[total_cases])*100 as Case_Fatality_rate
from [dbo].[coviddeaths] 
--where location like '%India%'
order by 1,2

--Morbidity_rate
select [location]
      ,[date]
      ,[total_cases]
      ,[total_deaths]
	  ,[population]
	  ,([total_cases]/[population])*100 as Morbidity_rate
from [dbo].[coviddeaths] 
--where location like '%India%'
order by 1,2

--High Infection rate
select [location]
      ,[population]
      ,MAX(total_cases) as HighInfectioncount
      ,MAX([total_cases]/[population])*100 as InfectedPopulation
from [dbo].[coviddeaths] 
GROUP BY [location],[population]
order by InfectedPopulation DESC

--High Death rate
Select [location]
      ,MAX(CAST([total_deaths] as int)) as fatality
from [dbo].[coviddeaths] 
where continent is not null
GROUP BY [location]
order by fatality DESC

--Global 
select [location]
      ,[date]
      ,[total_cases]
      ,[total_deaths]
	  ,([total_deaths]/[total_cases])*100 as Case_Fatality_rate
from [dbo].[coviddeaths] where  continent is not null 
order by 1,2 DESC

--Join
Select * from [dbo].[coviddeaths] as d INNER JOIN [dbo].[covidvaccinations] as v
ON d.[location]=v.[location] and d.[date]=v.[date] 

--total vaccination
select  dea.[continent] 
       ,dea.[location]
       ,dea.[date]
	   ,dea.[population]
	   ,vac.[total_vaccinations]
from [dbo].[coviddeaths] AS dea INNER JOIN [dbo].[covidvaccinations] AS vac
ON dea.[location]=vac.[location] and dea.[date]=vac.[date] 
WHERE  dea.[continent] is not null ORDER BY 2,3

--USE CTA
WITH popvsvac(continent,location,date,population,total_vaccinations,rolling_population)
as
(
select  d.[continent],d.[location],d.[date],d.[population],v.[total_vaccinations]
        ,SUM(CONVERT(bigint,v.[total_vaccinations])) OVER(PARTITION BY d.[location] Order by d.[location],d.[date]) as rolling_population
from [dbo].[coviddeaths] as d INNER JOIN [dbo].[covidvaccinations] as v
ON d.[location]=v.[location] and d.[date]=v.[date] 
WHERE  d.[continent] is not null 
)
Select *,(rolling_population/population)*100 from popvsvac

--TEMP TABLE
DROP TABLE if exists percentpopulationvac
Create table percentpopulationvac
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
total_vaccinations numeric,
rolling_population numeric
)
Insert into percentpopulationvac
select  d.[continent],d.[location],d.[date],d.[population],v.[total_vaccinations]
        ,SUM(CONVERT(bigint,v.[total_vaccinations])) OVER(PARTITION BY d.[location] Order by d.[location],d.[date]) as rolling_population
from [dbo].[coviddeaths] as d INNER JOIN [dbo].[covidvaccinations] as v
ON d.[location]=v.[location] and d.[date]=v.[date] 
--WHERE  d.[continent] is not null 

Select *,(rolling_population/population)*100 from percentpopulationvac

--Creating view 
CREATE  View  populationvac as
select  d.[continent],d.[location],d.[date],d.[population],v.[total_vaccinations]
        ,SUM(CONVERT(bigint,v.[total_vaccinations])) OVER(PARTITION BY d.[location] Order by d.[location],d.[date]) as rolling_population
from [dbo].[coviddeaths] as d INNER JOIN [dbo].[covidvaccinations] as v
ON d.[location]=v.[location] and d.[date]=v.[date] 
WHERE  d.[continent] is not null 

select * from populationvac
