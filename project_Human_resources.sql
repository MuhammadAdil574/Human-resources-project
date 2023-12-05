Create database HR;
Use HR;
show tables;
select* from Human_Resources;

desc Human_Resources;

set sql_safe_updates=0;
-- we will firstly  change the format of date from '/' to '-'
UPDATE Human_Resources
SET birth_date = CASE
    WHEN birth_date LIKE "%/%" THEN DATE_FORMAT(birth_date, "%y-%m-%d")
    WHEN birth_date LIKE "%-%" THEN DATE_FORMAT(birth_date, "%y-%m-%d")
    ELSE birth_date
END;
-- Alter the type of  column by using this querry and change the type from text to date

Alter table Human_Resources
modify column birth_date date;

select birth_date
from Human_Resources;

UPDATE Human_Resources
SET hire_date = CASE
    WHEN hire_date LIKE "%/%" THEN DATE_FORMAT(birth_date, "%y-%m-%d")
    WHEN hire_date LIKE "%-%" THEN DATE_FORMAT(birth_date, "%y-%m-%d")
    ELSE hire_date
END;

Alter table Human_Resources
modify column hire_date date;
desc Human_Resources;


select termdate from Human_Resources;

update Human_Resources
SET termdate = STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%S UTC')
where termdate is Not Null and termdate!=" " ;


alter table Human_Resources add column Age int;
update Human_Resources
set Age= timestampdiff(year, birth_date, curdate());

select birth_date,Age from Human_Resources;

select min(Age) as youngest, max(Age) as Oldest
 from Human_Resources;

select count(*) 
from Human_Resources
where Age<18;


-- Gender breakdown of employees of the company

select gen_der,count(*) As Count
from Human_Resources
where Age>=18 
group by gen_der;

-- whats the race  breakdown of the company

select race,count(*) As Count
from Human_Resources
where Age>=18 
group by race
order by Count desc;

-- whats the age distribution in the company

select min(Age) as Youngest,
max(Age) as Oldest
from Human_Resources
where Age>=18;

select
case
when Age >= 18 and Age <= 24 then "18-24"
when Age >= 25 and Age <= 34 then "25-34"
when Age >= 35 and Age <= 44 then "35-44"
when Age >= 45 and Age <= 54 then "45-54"
when Age >= 55 and Age <= 64 then "55-64"
else  "65+"
end as Age_Group,
count(*) As Count
from Human_Resources
group by Age_Group 
order by Age_Group;


select
case
when Age >= 18 and Age <= 24 then "18-24"
when Age >= 25 and Age <= 34 then "25-34"
when Age >= 35 and Age <= 44 then "35-44"
when Age >= 45 and Age <= 54 then "45-54"
when Age >= 55 and Age <= 64 then "55-64"
else  "65+"
end as Age_Group, gen_der,
count(*) As Count
from Human_Resources
group by Age_Group,gen_der 
order by Age_Group,gen_der;



-- how many employees work at headquaters versues remote location

select location, count(*) as Count
from Human_Resources
where Age>=18 
group by location;

-- Whats the average length of employment for employess who have been terminated


select cast(avg(datediff(termdate,hire_date))/365 as  decimal (1,0))
as avg_length_employment
from Human_Resources
where Age>=18 and termdate <= curdate() and termdate <>"0000-00-00";

-- how does gender distribution vary across departments

select gen_der,department,count(*)as Count
from Human_Resources
where Age>=18 
group by gen_der,department
order by department;

-- distribution of job titles across the company

select gen_der,job_title,count(*)as Count
from Human_Resources
where Age>=18 
group by job_title
order by job_title desc;

-- which department has highest turnover
select department, total_count,terminated_count,terminated_count/total_count as termination_rate
from
(select department,count(*) as total_count,
sum(case when termdate<>"0000-00-00" and termdate<= curdate() then 1 else 0 end) as terminated_count
from Human_Resources
group by department) As subquerry

order by termination_rate desc;

-- distribution of employees across locations by city and state?

select location_state,count(*)as Count
from Human_Resources
where Age>=18 
group by location_state
order by Count desc ;

-- employess count changed over time based on hire and termination dates?

select
 year, 
 hires,terminations,hires-terminations as net_change,
 cast((hires-terminations)/hires * 100 as decimal (2,0)) as net_change_percent
 from 
 (select 
 year (hire_date) as year,
 count(*) as hires,
 sum(case when termdate<>"0000-00-00" and termdate<= curdate() Then 1 else 0 end) as terminations
 from Human_Resources
 where Age>=18 
group by year (hire_date)) as subquerry
Order by year desc;


-- what is the tenure distribution for each department?

select  department, cast(avg(datediff(termdate,hire_date)/365) as decimal(1,0)) as Avg_tenure
from Human_Resources
where termdate<>"0000-00-00" and termdate<= curdate() and Age>=18
group by department;


-- thats the possible queries one can write in terms on knowing more about a Human resources department.

 
 
 
 


  