select *
from PortfolioProject..CovidDeaths
where continent is null
order by 3,4

--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

--Seleccionamos la data que vamos a utilizar

select Location,date,total_cases,new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

--total cases vs total deaths
--Shows likelihood in USA
select Location,date,total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathsPercetage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2

--looking at total cases vs population (% de la poblacion infectada
select Location,date, population,total_cases,(total_cases/population)*100 as CasesPercetage
from PortfolioProject..CovidDeaths
where location like '%Peru%'
order by 1,2

--Countries with highest infection rate compared to population
select Location, population,max(total_cases) as HighestInfectionCount,max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%states%'
group by location, population
order by PercentPopulationInfected desc

--showing countries with highest deathcount per population
select Location,max(cast(total_deaths as int)) as TotalDeathCount,max((cast(total_deaths as int)/population))*100 as PercentPopulationDeath
from PortfolioProject..CovidDeaths
group by location, population
order by PercentPopulationDeath desc

--paises con mas muertes

select Location,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null 
group by location
order by TotalDeathCount desc

--continentes con mas muertes
select continent,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

select location,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is null
group by location
order by TotalDeathCount desc

--Mostrar los continentes con más muerte por població 
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
group by continent

select * from PortfolioProject..CovidDeaths

--Continente y locacion sin repeticion
select count (distinct continent) from PortfolioProject..CovidDeaths
select distinct continent from PortfolioProject..CovidDeaths

select count (distinct location) from PortfolioProject..CovidDeaths
--select distinct location from PortfolioProject..CovidDeaths
--order by location

select count (distinct location) from PortfolioProject..CovidDeaths
where cast(date as date)  ='2021-04-30'

--Continente con las más altas muertes por population
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from portfolioproject..CovidDeaths
where continent is not null
group by continent
order by totaldeathcount desc

--Global numbers / total de casos y muertos 
select sum(new_cases) as NewCasesPerDay, sum(cast(new_deaths as int)) as NewDeathsPerDay, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as Percetaje
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
order by 1,2

-- looking at total population vs vaccinations
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null 
order by 2,3

--use CTE
with popvsvac(
	Continent,
	Location,
	Date,
	Population,
	New_Vaccinations,
	RollingPeopleVaccinated)
as
(
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null 
)

select * ,(RollingPeopleVaccinated/Population)*100
from popvsvac


--Temp table--
drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
--where dea.continent is not null 

select * from #PercentPopulationVaccinated