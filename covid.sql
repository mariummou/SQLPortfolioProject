select location,date,total_cases,new_cases, total_deaths,population
from project.coviddeaths
where continent is not null;
-- Looking at total cases v total deaths and what is the death rates from 2020 to 2021 in Bangladesh
select location,date,total_cases, total_deaths,(total_deaths/total_cases)*100 as Death_Percentage
from project.coviddeaths
where location like "bang%" and  continent is not null;


-- Looking at total cases vs Population
select location,date,total_cases, population,(total_cases/population)*100 as "Total Cases in BD"
from project.coviddeaths
where location like "bang%";

-- Looking at countries with highest infection rate except for the USA
select location,population,MAX(total_cases) as Highest_Infection_count, (max(total_cases)/population)*100 as Infection_percentage_by_population
from project.coviddeaths
group by location,population
order by Infection_percentage_by_population DESC;

-- continent with highest deaths per population
select continent,MAX(total_deaths) as Highest_death_count
from project.coviddeaths
group by continent
order by highest_death_count DESC;

-- Global Numbers

select date,SUM(new_cases) as total_new_cases, sum(new_deaths) as total_new_deaths, (sum(new_deaths)/sum(new_cases))*100 as death_percentage_per_newcases
from project.coviddeaths
group by date;

-- total population and vaccination
select de.location,de.date,de.population, va.new_vaccinations, sum(va.new_vaccinations) over (partition by de.location order by de.location,de.date)
as RollingPeoplevaccinated
from project.coviddeaths de
join project.covidvaccinations va
	ON de.location=va.location and de.date=va.date
	order by 2,3;
    
    
-- USE CTE
with PopvsVac (continent,location,date, Population, RollingPeoplevaccinated, new_vaccinations)
as
(
select de.continent,de.location,de.date,de.population, va.new_vaccinations, sum(va.new_vaccinations) over (partition by de.location order by de.location,de.date)
as RollingPeoplevaccinated
from project.coviddeaths de
join project.covidvaccinations va
	ON de.location=va.location and de.date=va.date
	
)
select *, (RollingPeoplevaccinated/population)*100 as rollingpeoplepercentage from popvsvac
order by 3 DESC;

