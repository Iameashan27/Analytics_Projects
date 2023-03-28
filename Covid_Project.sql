SELECT * FROM PortfolioProject..CovidDeaths
where continent is not null
Order by 3,4

--SELECT * FROM PortfolioProject..CovidVaccinations
--Order by 3,4

--Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in United States
Select Location, date, total_cases, total_deaths, {total_deaths/total_cases}*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%states'
Order by 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got covid
Select Location, date, total_cases, Population, (total_cases/population)*100 as PercentagePopulationInfected
From PortfolioProject..CovidDeaths
--where location like '%states'
Order by 1,2

--Looking at Countries with Highest Infection Rate compared to Population
Select Location,  MAX(total_cases), Population as HighestInfectionCount, Max((total_cases/population))*100 as PercentagePopulationInfected
From PortfolioProject..CovidDeaths
--where location like '%states'
Group by Location, Population
Order by PercentagePopulationInfected desc


--Showing the continents with the highest death count per population
Select Location, MAX(total_cases), Population as HighestInfectionCount, Max((total_cases/population))*100 as TotalDeathCount
From PortfolioProject..CovidDeaths
--where location like '%states'
where continent is not null
Group by continent
Order by TotalDeathCount desc

--Global Number
Select date, SUM(new_cases) as total_deaths, SUM(cast(new_deaths as int)) as total_deaths
,(SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--where location like '%states'
where continent is not null
Order by 1,2

--Looking at Total Population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int))
Over (Partition by dea.location Order by dea.location, dea.date) as AggregatePeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
	where continent is not null
	order by 2,3

