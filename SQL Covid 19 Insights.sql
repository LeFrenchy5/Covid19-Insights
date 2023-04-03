-- Covid 19 Insights 

-- Showing total cases and total deaths per day
-- 1 Total Death Percentage.csv
Select Date, sum(new_cases) as total_cases, sum(new_deaths) as total_Deaths, sum(new_deaths)/sum(new_cases)*100 as Death_percentage
from covid_deaths
order by date;

-- Total Deaths Per Continent
-- 2 Total Death Per Continent.csv
Select continent, sum(new_deaths) as Total_Death_count
from covid_deaths
group by continent
order by total_death_count desc;

-- Looking at Countries with the highest infection rate compard to Poulation
-- 3 Countries with highest death count compared to population.csv
Select location, population,  max(total_cases) as highest_infection_count, max((total_cases/population))*100 as Percent_population_infected
from covid_deaths
group by location, population
order by Percent_population_infected desc;

-- Looking at Countries with the highest infection rate compard to Poulation
-- 4 Countries Highest Infection rate per day.csv
Select location, date, population,  max(total_cases) as highest_infection_count, max((total_cases/population))*100 as Percent_population_infected
from covid_deaths
group by location, population, date
order by Percent_population_infected desc;


-- Looking at total Population vs Vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(new_vaccinations) over (partition by dea.location order by dea.location , dea.date) as People_vaccinated
from covid_deaths dea
join
covid_vacs vac on dea.location = vac.location and dea.date = vac.date
order by dea.location , dea.date;

-- CTE Of Population vs Vaccinations To get Percentage Vaccinated Per Country
-- 5 Percentage Vaccinated.csv
with PopvsVac 
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(new_vaccinations) over (partition by dea.location order by dea.location , dea.date) as People_vaccinated
from covid_deaths dea
join
covid_vacs vac on dea.location = vac.location and dea.date = vac.date
order by dea.location , dea.date
)
select * , (people_vaccinated/population)*100 as Percentage_Vaccinated
from 
popvsvac;


-- Creating View of Population vs Vaccinations To Store Data For Visualization
create View PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(new_vaccinations) over (partition by dea.location order by dea.location , dea.date) as People_vaccinated
from covid_deaths dea
join
covid_vacs vac on dea.location = vac.location and dea.date = vac.date
order by dea.location , dea.date;


-- CTE Of Population vs Fully Vaccinated 
-- Showing Total Population , Total Vaccinated and Total Percentage Vaccinated
-- 6 Total Percentage Vaccinated.csv
With fullyVac
as
(
	select vacs.date,vacs.location ,dea.population,max(vacs.people_fully_vaccinated) as total_fully_vaccinated
	from covid_vacs vacs
	join 
	covid_deaths dea on vacs.date = dea.date and vacs.location = dea.location
	group by vacs.location
	order by date
)
select max(date) as date, sum(population) as total_population, sum(total_fully_vaccinated) as Fully_vaccinated, (sum(total_fully_vaccinated)/sum(population)) * 100 as Percentage_vaccinated
from fullyvac;

