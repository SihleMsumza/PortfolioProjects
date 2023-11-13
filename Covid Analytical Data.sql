--SELECT Full Exel Spreadsheet

SELECT*
FROM [Portfolio Projects]..['covid-data(deaths)$']
ORDER BY 3,4

--Select data that we will be using

SELECT location, date, total_cases, new_cases, total_deaths,(CONVERT(float,total_deaths)/NULLIF(CONVERT(float,total_cases),0))* 100 AS DeathPercentage
FROM [Portfolio Projects]..['covid-data(deaths)$']
ORDER BY 1,2

--Calculating Death percentage

SELECT Location,Date,Total_cases, Total_cases, total_deaths,(CONVERT(float,total_deaths)/NULLIF(CONVERT(float,total_cases),0))* 100 AS DeathPercentage
FROM [Portfolio Projects]..['covid-data(deaths)$']
ORDER BY 1,2

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as float)) as TotalDeathCount
From [Portfolio Projects]..['covid-data(deaths)$']
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingCountOfPeopleVaccinated
From [Portfolio Projects]..['covid-data(deaths)$'] dea
Join [Portfolio Projects]..['covid-data(Vaccinations)$'] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 1,2,3

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingCountOfPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From [Portfolio Projects]..['covid-data(deaths)$'] dea
Join [Portfolio Projects]..['covid-data(Vaccinations)$'] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingCountOfPeopleVaccinated/Population)*100 VacPopPerentage
From PopvsVac
order by VacPopPerentage Desc