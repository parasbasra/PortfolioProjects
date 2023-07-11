select * from [PortfolioProject].[dbo].[coviddeath] order by 3,4
select * from [PortfolioProject].[dbo].[vaccination] order by 3,4

select location , date , total_cases , total_deaths , cast(total_deaths as float)/cast(total_cases as float)*100 as deathPercentage
from [PortfolioProject].[dbo].[coviddeath]
where location like '%states%'
order by 1,2

select location , population , max(total_cases) as HighInfection , max((total_cases/population))*100 as percentinfected
from [PortfolioProject].[dbo].[coviddeath]
group by location , population
order by percentinfected desc

select location , max(total_deaths) as totaldeathcount 
from [PortfolioProject].[dbo].[coviddeath]
where continent is null
group by location 
order by totaldeathcount desc

select continent , max(total_deaths) as totaldeathcount 
from [PortfolioProject].[dbo].[coviddeath]
where continent is not null
group by continent 
order by totaldeathcount desc

--global numbers--

select  sum(new_cases) as totalcases, sum(new_deaths) as totaldeaths, sum(new_deaths)/sum(new_cases)*100 as deathpercentage
from [PortfolioProject].[dbo].[coviddeath]
where continent is not null
--group by date 
order by 1,2

--joining both table

select * 
from [PortfolioProject].[dbo].[coviddeath] dea
join PortfolioProject.dbo.vaccination vac
on dea.location = vac.location
and dea.date = vac.date

--looking at total population vs vaccinations

select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations , sum(convert(float,vac.new_vaccinations))
over (partition by dea.location order by dea.location , dea.date) 
from [PortfolioProject].[dbo].[coviddeath] dea
join PortfolioProject.dbo.vaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--creating view

create view percentpopulation as
select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations , 
sum(convert(float,vac.new_vaccinations)) 
over (partition by dea.location order by dea.location , dea.date) as rollingpeople
from [PortfolioProject].[dbo].[coviddeath] dea
join PortfolioProject.dbo.vaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null