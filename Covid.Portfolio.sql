SELECT *
FROM PortfolioProject..Covid_Deaths
--WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..Covidvaccinations
--WHERE continent IS NOT NULL
--ORDER BY 3,4

--Data currently using

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM PortfolioProject..Covid_Deaths
WHERE continent IS NOT NULL
ORDER BY 1,2

--Total Cases vs Total Deaths
--Shows possibility of dying from COVID in country
SELECT location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..Covid_Deaths
WHERE location like '%Nigeria%'
AND continent IS NOT NULL
ORDER BY 1,2;

--Total Cases vs Population
--Shows percentage of Population with COVID
SELECT location,date,population,
total_cases, 
(total_cases/population)*100 as PopulationInfectedPercentage
FROM PortfolioProject..Covid_Deaths
WHERE location like '%Nigeria%'
AND continent IS NOT NULL
ORDER BY 1,2;

--Countries with Highest Infection Rate compared to Population
SELECT location,MAX(CAST(population AS float)) AS Population,
MAX(CAST(total_cases AS FLOAT)) AS HighestInfectionCount, 
(MAX(CAST(total_cases AS FLOAT))/MAX(CAST(population AS FLOAT)))*100 AS PopulationInfectedPercentage
FROM PortfolioProject..Covid_Deaths
--WHERE location like '%Nigeria%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY PopulationInfectedPercentage DESC;

--Countries with Highest Death count per Popuation
SELECT location,
MAX(CAST(total_deaths AS INT)) AS TotalDeathCount 
FROM PortfolioProject..Covid_Deaths
--WHERE location like '%Nigeria%',
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

--SELECT location,
--MAX(total_deaths) AS TotalDeathCount 
--FROM PortfolioProject..Covid_Deaths
--WHERE location like '%Nigeria%',
--WHERE continent IS NOT NULL
--GROUP BY location
--ORDER BY TotalDeathCount DESC;

--Breakdown by continent
SELECT continent,
MAX(CAST(total_deaths AS INT)) AS TotalDeathCount 
FROM PortfolioProject..Covid_Deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Breakdown of Total Deaths by Continent (Sum across all countries)
WITH CountryMaxDeaths AS (
    SELECT continent, location, MAX(CAST(total_deaths AS INT)) AS MaxDeathCount
    FROM PortfolioProject..Covid_Deaths
    WHERE continent IS NOT NULL
    GROUP BY continent, location
)
SELECT continent, SUM(MaxDeathCount) AS TotalDeathCount
FROM CountryMaxDeaths
GROUP BY continent
ORDER BY TotalDeathCount DESC;

--Showing Continent with Highest Death Count (Single Country)
SELECT continent,
MAX(CAST(total_deaths AS INT)) AS TotalDeathCount 
FROM PortfolioProject..Covid_Deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

--Globa Number
SELECT SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS INT)) AS Total_Deaths, 
             SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject..Covid_Deaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2;


-- Total Population vs Total Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
  AS RollingPeopleVaccinated
FROM PortfolioProject..Covid_Deaths AS dea
JOIN PortfolioProject..Covidvaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND vac.new_vaccinations IS NOT NULL
ORDER BY 2,3

--Using CTE
WITH PopvsVac( Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  SUM(CAST(vac.new_vaccinations AS INT )) OVER (PARTITION BY dea.location ORDER BY dea.location,
 dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..Covid_Deaths AS dea
JOIN PortfolioProject..Covidvaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND vac.new_vaccinations IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100 AS VaccinatedPercentage
FROM PopvsVac

--Using Temp Table
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
( Continent NVARCHAR(500),
location NVARCHAR(500),
Date DATETIME,
Population FLOAT,
New_Vaccinations FLOAT,
RollingPeopleVaccinated FLOAT
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  SUM(CAST(vac.new_vaccinations AS INT )) OVER (PARTITION BY dea.location ORDER BY dea.location,
 dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..Covid_Deaths AS dea
JOIN PortfolioProject..Covidvaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND vac.new_vaccinations IS NOT NULL
--ORDER BY 2,3
SELECT *, (RollingPeopleVaccinated/population)*100 AS VaccinatedPercentage
FROM #PercentPopulationVaccinated


--Creating view
CREATE VIEW Total_CasesvsTotal_Deaths AS
SELECT location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..Covid_Deaths
WHERE location like '%Nigeria%'
AND continent IS NOT NULL
--ORDER BY 1,2;

CREATE VIEW Total_CasesvsPopulation AS
SELECT location,date,population,
total_cases, 
(total_cases/population)*100 as PopulationInfectedPercentage
FROM PortfolioProject..Covid_Deaths
WHERE location like '%Nigeria%'
AND continent IS NOT NULL
--ORDER BY 1,2; 

CREATE VIEW CountriesInfectionRate AS
SELECT location,MAX(CAST(population AS float)) AS Population,
MAX(CAST(total_cases AS FLOAT)) AS HighestInfectionCount, 
(MAX(CAST(total_cases AS FLOAT))/MAX(CAST(population AS FLOAT)))*100 AS PopulationInfectedPercentage
FROM PortfolioProject..Covid_Deaths
--WHERE location like '%Nigeria%'
WHERE continent IS NOT NULL
GROUP BY location
--ORDER BY PopulationInfectedPercentage DESC;