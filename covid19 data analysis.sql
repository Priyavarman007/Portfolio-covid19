select date, sum(new_cases),sum(cast(new_deaths as int)), sum(cast(new_deaths as int))/sum(new_cases)*100 as deathper-- total_deaths, (total_deaths/total_cases)*100 deathpercentage
from CovidDeaths$
--where location like '%states'
where continent is not null
group by date
order by 1,2