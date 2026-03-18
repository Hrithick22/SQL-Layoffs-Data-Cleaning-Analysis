use world_layoffs;
select * from layoffs;
-- 1.Removing duplictaes
-- 2.Standerdization
-- 3.NULL and String handling 

-- REMOVING DUPLICATES 
-- Creating new table because the raw table should always  not disturbed
create table layoffs_staging 
like layoffs;

insert layoffs_staging
select *
from layoffs;


select * from layoffs_staging;

-- just  partiton by all with row number for duplicate removals
select *,
row_number() over (partition by company,industry,total_laid_off,percentage_laid_off,`date`)as row_num from layoffs_staging;

-- Now creating CTE for with row numer and taking duplicate ones
with dup_cte as (
select *, 
row_number() over (partition by location,funds_raised_millions,company,industry,total_laid_off,percentage_laid_off,`date`)as row_num from layoffs_staging
)
select * from dup_cte
where row_num >1;

-- CREATING AMOTHER NEW TABLE FOR DELETING  
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- INSERTED VALUES AND NEW THING DONE IS ADDED ROW NUMBER 
  insert layoffs_staging2
  select *, 
row_number() over (partition by location,funds_raised_millions,company,industry,total_laid_off,percentage_laid_off,`date`)
as row_num from layoffs_staging;

delete from layoffs_staging2
where row_num > 1 ;

select * from layoffs_staging2 
where row_num >1;

-- STANDARDINZING DATA
-- mainly triming,changing Date to actual date type from text,changing company name sto actual ones  
select distinct company
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select distinct industry from layoffs_staging2 order by 1; 

-- updating the name because same type of company but different names 
select distinct industry from layoffs_staging2
where industry like 'crypto%';

select * from layoffs_staging2 where industry  like 'crypto%'; 

update layoffs_staging2 
set industry = 'Crypto'
where industry like 'crypto%';

-- As like in the previous little alternation in the names can be altered 
select country from layoffs_staging2;

select distinct country from layoffs_staging2
where country like 'united states%';

select country,trim(trailing '.' from country) from layoffs_staging2 where country like 'united states%';

update layoffs_staging2 
set country = trim(trailing '.' from country) where country like 'united states%';
 
 -- Changing text type to date type  
select `date`,str_to_date(`date`,'%m/%d/%Y') from  layoffs_staging2 ;

update layoffs_staging2 set `date`= str_to_date(`date`,'%m/%d/%Y');
select `date` from layoffs_staging2;

alter table layoffs_staging2
modify column `date` date;

select * from layoffs_staging2;

-- NULL and String Handling 

select * from layoffs_staging2 where total_laid_off is null and percentage_laid_off is null;

select * from layoffs_staging2 ; 

select * from layoffs_staging2 where industry = '' or industry is null;

select * from layoffs_staging2 where company = 'Airbnb';

-- self joining to see whether the same company having null values in industry 

select t1.industry,t2.industry from 
layoffs_staging2 t1 
join layoffs_staging2 t2 
on t1.company = t2.company 
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

-- since cant update blank so we are turning blank into nulls
update layoffs_staging2
set industry = null 
where industry ='';

-- After all changing updating the null to the industry which its company belongs to 
update layoffs_staging2 t1 
join layoffs_staging2 t2
on t1.company = t2.company
set t1.industry = t2.industry 
where t1.industry is null 
and t2.industry is not null;

-- deleting the laid and percentage laid both null having since we need only lay off details 
select * from layoffs_staging2 where total_laid_off is null and percentage_laid_off is null;
delete from layoffs_staging2 where total_laid_off is null and percentage_laid_off is null;

select * from layoffs_staging2;

-- The row number we column we created and used for the data duplicate removal now deleted
alter table layoffs_staging2 
drop column row_num;

-- Exploratory Analysis -- 

-- The maximum laid offs --
select company,max(total_laid_off) as max from layoffs_staging2 group by company order by max desc;

-- The layoffs in a single date -- 
select `date`,sum(total_laid_off) as max from layoffs_staging2 group by `date` order by max desc ;

-- The most number of layoffs--
select company,sum(total_laid_off) as Total from layoffs_staging2 group by company order by 2 desc;

-- Max percentage layoffs analysis-- 
select max(percentage_laid_off) from layoffs_staging2 ;
select * from layoffs_staging2 where percentage_laid_off = 1 order by total_laid_off desc;
-- Data's earliest and latest layoff dates 
select min(`date`) as Earliest,max(`date`) Latest from layoffs_staging2; 

-- Layoff details of industries
select industry,sum(total_laid_off) as Total from layoffs_staging2 group by industry order by 2 desc;

-- layoffs detials by dates --
select year(`date`),sum(total_laid_off) as Total from layoffs_staging2 group by year(`date`) order by 1 desc;

select substring(`date`,1,7) as `Month`, sum(total_laid_off) 
as Total from layoffs_staging2
where substring(`date`,1,7) is not null 
group by `month` 
order by `month` asc ;

-- Rolling sum 
with Rolling_total as (
select substring(`date`,1,7) as `Month`,sum(total_laid_off) 
as Total from layoffs_staging2
where substring(`date`,1,7) is not null 
group by `month` 
order by `month` asc 
)
select `month`,Total,
sum(total) over ( order by `month` asc) as Rolling_Sum from Rolling_Total;


-- Year by year layoffs per company RANKING USING COMBINED CTE--
with Total_layoffs as (
select company,year(`date`) as years,sum(total_laid_off) as Total
from layoffs_staging2 group by  company, years
),
 company_rank as (
select *,
dense_rank() over(partition by years order by total desc) as `order` from Total_layoffs 
 where years is not null
 order by `order` asc )
 select * from company_rank 
 WHERE `ORDER` <= 5
 order bY YEARS ASC;
 
 