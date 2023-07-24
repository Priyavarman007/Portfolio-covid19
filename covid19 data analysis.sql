SELECT TOP (1000) [iso_code]
      ,[continent]
      ,[location]
      ,[date]
      ,[total_cases]
      ,[new_cases]
      ,[new_cases_smoothed]
      ,[total_deaths]
      ,[new_deaths]
      ,[new_deaths_smoothed]
      ,[total_cases_per_million]
      ,[new_cases_per_million]
      ,[new_cases_smoothed_per_million]
      ,[total_deaths_per_million]
      ,[new_deaths_per_million]
      ,[new_deaths_smoothed_per_million]
      ,[reproduction_rate]
      ,[icu_patients]
      ,[icu_patients_per_million]
      ,[hosp_patients]
      ,[hosp_patients_per_million]
      ,[weekly_icu_admissions]
      ,[weekly_icu_admissions_per_million]
      ,[weekly_hosp_admissions]
      ,[weekly_hosp_admissions_per_million]
      ,[new_tests]
      ,[total_tests]
      ,[total_tests_per_thousand]
      ,[new_tests_per_thousand]
      ,[new_tests_smoothed]
      ,[new_tests_smoothed_per_thousand]
      ,[positive_rate]
      ,[tests_per_case]
      ,[tests_units]
      ,[total_vaccinations]
      ,[people_vaccinated]
      ,[people_fully_vaccinated]
      ,[new_vaccinations]
      ,[new_vaccinations_smoothed]
      ,[total_vaccinations_per_hundred]
      ,[people_vaccinated_per_hundred]
      ,[people_fully_vaccinated_per_hundred]
      ,[new_vaccinations_smoothed_per_million]
      ,[stringency_index]
      ,[population]
      ,[population_density]
      ,[median_age]
      ,[aged_65_older]
      ,[aged_70_older]
      ,[gdp_per_capita]
      ,[extreme_poverty]
      ,[cardiovasc_death_rate]
      ,[diabetes_prevalence]
      ,[female_smokers]
      ,[male_smokers]
      ,[handwashing_facilities]
      ,[hospital_beds_per_thousand]
      ,[life_expectancy]
      ,[human_development_index]
  FROM [Covid19].[dbo].[CovidDeaths$]

  select *   FROM [Covid19].[dbo].[CovidDeaths$]
  

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths$

select * from 
CovidDeaths$
where location LIKE 'i%'

select location, total_cases, new_cases, date from CovidDeaths$
where date > 2022 and location LIKE 'india%'
group by date;

select location, date, population, total_cases, (total_cases/population)*100 
from CovidDeaths$
where location like '%states'
order by 1,2

select location, population, max(total_cases) as highestinfectionrate, max((total_cases/population))*100 as percentpopulationinfected
from CovidDeaths$
--where location like '%states'
group by location, population
order by 1,2
 
select continent, max(cast(total_deaths as int)) as totaldeathcounts
from CovidDeaths$
--where location like '%states'
where continent is not null
group by continent
order by totaldeathcounts desc

select sum(new_cases) as totalcases,sum(cast(new_deaths as int)) as totaldeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercent-- total_deaths, (total_deaths/total_cases)*100 deathpercentage
from Covid19.dbo.CovidDeaths$
--where location like '%states'
where continent is not null
--group by date
order by 1,2

--Covidvaccination table

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location, dea.date) as rollingpeoplevaccinated
from Covid19.dbo.CovidDeaths$ dea
join Covid19.dbo.CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


with popvsvac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location, dea.date) as rollingpeoplevaccinated
from Covid19.dbo.CovidDeaths$ dea
join Covid19.dbo.CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (rollingpeoplevaccinated/population)*100 from popvsvac


-- Temp table

Drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)

insert into #percentpopulationvaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location, dea.date) as rollingpeoplevaccinated
from Covid19.dbo.CovidDeaths$ dea
join Covid19.dbo.CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select *, (rollingpeoplevaccinated/population)*100 from #percentpopulationvaccinated

--creating view--

create view percentpopulationvaccinated 
as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location, dea.date) as rollingpeoplevaccinated
from Covid19.dbo.CovidDeaths$ dea
join Covid19.dbo.CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select * from percentpopulationvaccinated

