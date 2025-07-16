#data cleaning
SELECT * FROM world_layoffs.layoffs;


#1.remove duplicates
#2. standardize the data 
#3.null/blank values
#4. remove any columns 

Create table layoffs_staging
like layoffs;

insert layoffs_staging
select * from layoffs;

select * from layoffs_staging;

#duplicates
select *,
row_number() over(partition by company,industry,total_laid_off,percentage_laid_off,`date`) as row_num
from layoffs_staging;

#CTE- to find repeated rows - showing duplicates 
with duplicate_cte as
(
select *,
row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoffs_staging
)
select * 
from  duplicate_cte 
where row_num>1;

#found 5 rows as such so delete it by creating additional table

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

#check the new table created
select * from layoffs_staging2;

#insert data into layoffs_staging2
insert into layoffs_staging2
select *,
row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoffs_staging;

#deleting duplicates 
delete
from layoffs_staging2
where row_num>1;

select * from layoffs_staging2;

#now standardizing data- finding issues and fixing it 
# trim spaces in company 
update layoffs_staging2
set company=trim(company)
WHERE company LIKE ' %' OR company LIKE '% ';

-- Turn off safe update mode
SET SQL_SAFE_UPDATES = 0;

-- Run your update safely
UPDATE layoffs_staging2
SET company = TRIM(company)
WHERE company LIKE ' %' OR company LIKE '% ';

-- (Optional) Re-enable safe update mode
SET SQL_SAFE_UPDATES = 1;

select * from layoffs_staging2;

#find any duplicates in industry 
select distinct industry 
from layoffs_staging2
order by 1;
#found 2 blanks and repeated crypto as cryptocurrency-make them as crypto 

update layoffs_staging2
set industry='Crypto'
where industry like 'crypto%';

-- Disable safe update mode
SET SQL_SAFE_UPDATES = 0;

-- Perform the update
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Re-enable safe update mode for safety
SET SQL_SAFE_UPDATES = 1;

select * 
from layoffs_staging2
where industry like 'Crypto%';

#check if any issues in location 
select distinct location 
from layoffs_staging2
order by 1;

#chekc for issues in country 
select distinct country
from layoffs_staging2
order by 1;

#found US wth a period so trail it  
select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;

SET SQL_SAFE_UPDATES = 0;

-- Perform the update
UPDATE layoffs_staging2
SET country= trim(trailing '.' from country)
WHERE country like 'United States%';

-- Re-enable safe update mode for safety
SET SQL_SAFE_UPDATES = 1;

#shows perios removed 
select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;

#convert text format of date to date format 
select `date`,
str_to_date(`date`,'%Y-%m-%d')
from  layoffs_staging2;

SET SQL_SAFE_UPDATES = 0;

-- Perform the update
UPDATE layoffs_staging2
SET `date`=str_to_date(`date`,'%Y-%m-%d');

-- Re-enable safe update mode for safety
SET SQL_SAFE_UPDATES = 1;

select `date`
from  layoffs_staging2;

#the date column is still in text but it is formatted so alter table
alter table layoffs_staging2
modify column `date` date;

#look for nulls in laid off and other columns
select * 
from  layoffs_staging2
where total_laid_off is null and percentage_laid_off is null;

-- select * 
-- from layoffs_staging2
-- where industry is null 
-- or industry='';

-- #update blanks to null for easy fillng later values 
-- SET SQL_SAFE_UPDATES = 0;

-- -- Perform the update
-- UPDATE layoffs_staging2
-- SET industry = null
-- where industry='';

-- -- Re-enable safe update mode for safety
-- SET SQL_SAFE_UPDATES = 1;

-- select t1.industry,t2.industry 
-- from layoffs_staging2 t1
-- join layoffs_staging2 t2
-- on t1.company=t2.company
-- where (t1.industry is null  or t1.industry=' ')
-- and t2.industry is not null;

-- #now update 
-- SET SQL_SAFE_UPDATES = 0;

-- -- Perform the update
-- UPDATE layoffs_staging2 t1
-- join layoffs_staging2 t2
--   on t1.company=t2.company
-- set t1.industry = t2.industry
-- where t1.industry is null 
-- and t2.industry is not null;

-- -- Re-enable safe update mode for safety
-- SET SQL_SAFE_UPDATES = 1;

#check if airbnb still has blanks 

-- Step 1: Disable safe update mode
SET SQL_SAFE_UPDATES = 0;

-- Step 2: Clean whitespace in 'company' column to ensure proper joins
UPDATE layoffs_staging2
SET company = TRIM(company);

-- Step 3: Convert empty strings or single-space strings in 'industry' to NULL
UPDATE layoffs_staging2
SET industry = NULL
WHERE TRIM(industry) = '' OR TRIM(industry) = ' ';

-- Step 4: Use self-join to update missing industries based on other records with same company
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
  ON TRIM(t1.company) = TRIM(t2.company)
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;

-- Step 5: Re-enable safe update mode
SET SQL_SAFE_UPDATES = 1;

-- Step 6: Check if any 'industry' values are still NULL
SELECT COUNT(*) AS null_industries
FROM layoffs_staging2
WHERE industry IS NULL;

#delete unncessary null values 
select * from layoffs_staging2
where total_laid_off is null and percentage_laid_off is null;

delete from  layoffs_staging2
where total_laid_off is null and percentage_laid_off is null;

select * from layoffs_staging2;

alter table layoffs_staging2
drop column row_num;

select * from layoffs_staging2;



